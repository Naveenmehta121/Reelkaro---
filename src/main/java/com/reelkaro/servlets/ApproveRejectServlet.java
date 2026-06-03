package com.reelkaro.servlets;

import com.reelkaro.dao.ApplicationDAO;
import com.reelkaro.dao.CampaignDAO;
import com.reelkaro.dao.RewardDAO;
import com.reelkaro.models.Campaign;
import com.reelkaro.models.Submission;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * ApproveRejectServlet — Brand approves or rejects a creator's submission.
 *
 * When a submission is APPROVED, a reward entry is automatically created.
 * POST /ApproveReject
 */
@WebServlet("/ApproveReject")
public class ApproveRejectServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final CampaignDAO    campaignDAO    = new CampaignDAO();
    private final RewardDAO      rewardDAO      = new RewardDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "brand")) return;
        req.setCharacterEncoding("UTF-8");

        int    brandId      = SessionUtil.getUserId(req.getSession(false));
        int    submissionId = parseIntSafe(req.getParameter("submission_id"));
        int    campaignId   = parseIntSafe(req.getParameter("campaign_id"));
        String action       = trim(req.getParameter("action"));     // "approve" or "reject"
        String feedback     = trim(req.getParameter("feedback"));

        try {
            // Security check: confirm the campaign belongs to this brand
            Campaign campaign = campaignDAO.getCampaignById(campaignId);
            if (campaign == null || campaign.getBrandId() != brandId) {
                resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp");
                return;
            }

            if ("approve".equals(action)) {
                // 1. Mark submission as approved
                applicationDAO.updateSubmissionStatus(submissionId, "approved", feedback);

                // 2. Fetch the submission to get creatorId
                Submission sub = getSubmissionById(submissionId);
                if (sub != null) {
                    // 3. Auto-create reward entry
                    rewardDAO.insertReward(sub.getCreatorId(), campaignId,
                            campaign.getRewardPerCreatorInr());
                }

            } else if ("reject".equals(action)) {
                applicationDAO.updateSubmissionStatus(submissionId, "rejected", feedback);
            }

            resp.sendRedirect(req.getContextPath()
                    + "/brand/campaign-detail.jsp?id=" + campaignId + "&reviewed=true");

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/brand/campaign-detail.jsp?id=" + campaignId + "&error=db");
        }
    }

    /**
     * Fetch a submission by its ID using the campaign DAO via application lookup.
     * We re-use ApplicationDAO.getSubmissionByCampaign to avoid an extra raw query.
     */
    private Submission getSubmissionById(int submissionId) throws SQLException {
        // Use a targeted SQL query via a new connection
        String sql = "SELECT s.*, a.creator_id, a.campaign_id, c.title AS campaign_title, " +
                     "u.name AS creator_name FROM submissions s " +
                     "JOIN applications a ON a.id = s.application_id " +
                     "JOIN campaigns c ON c.id = a.campaign_id " +
                     "JOIN users u ON u.id = a.creator_id WHERE s.id=?";
        try (java.sql.Connection con = com.reelkaro.utils.DBConnection.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, submissionId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Submission s = new Submission();
                    s.setId            (rs.getInt   ("id"));
                    s.setApplicationId (rs.getInt   ("application_id"));
                    s.setCreatorId     (rs.getInt   ("creator_id"));
                    s.setCampaignId    (rs.getInt   ("campaign_id"));
                    s.setCampaignTitle (rs.getString("campaign_title"));
                    s.setCreatorName   (rs.getString("creator_name"));
                    s.setContentLink   (rs.getString("content_link"));
                    s.setApprovalStatus(rs.getString("approval_status"));
                    return s;
                }
            }
        }
        return null;
    }

    private String trim(String s) { return (s == null) ? "" : s.trim(); }
    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (Exception e) { return 0; }
    }
}
