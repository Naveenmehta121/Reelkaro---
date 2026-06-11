package com.reelkaro.servlets;

import com.reelkaro.dao.ApplicationDAO;
import com.reelkaro.dao.CampaignDAO;
import com.reelkaro.models.Campaign;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * ApproveApplicationDirectServlet — Handles direct approval of applications by the brand.
 * 
 * POST /ApproveApplicationDirect
 */
@WebServlet("/ApproveApplicationDirect")
public class ApproveApplicationDirectServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final CampaignDAO    campaignDAO    = new CampaignDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "brand")) return;
        req.setCharacterEncoding("UTF-8");

        int brandId       = SessionUtil.getUserId(req.getSession(false));
        int applicationId = parseIntSafe(req.getParameter("application_id"));
        int campaignId    = parseIntSafe(req.getParameter("campaign_id"));

        try {
            // Security check: confirm the campaign belongs to this brand
            Campaign campaign = campaignDAO.getCampaignById(campaignId);
            if (campaign == null || campaign.getBrandId() != brandId) {
                resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp");
                return;
            }

            // Direct approve or reject the application
            String action = req.getParameter("action");
            if ("reject".equals(action)) {
                applicationDAO.updateApplicationStatus(applicationId, "rejected");
            } else {
                applicationDAO.updateApplicationStatus(applicationId, "approved");
            }

            resp.sendRedirect(req.getContextPath()
                    + "/brand/campaign-detail.jsp?id=" + campaignId + "&reviewed=true");

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/brand/campaign-detail.jsp?id=" + campaignId + "&error=db");
        }
    }

    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (Exception e) { return 0; }
    }
}
