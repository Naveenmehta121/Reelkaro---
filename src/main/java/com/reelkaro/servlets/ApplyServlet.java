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
 * ApplyServlet — Creator applies to an open campaign.
 * GET  /Apply?id=X → show campaign detail with apply button (apply.jsp)
 * POST /Apply       → submit application
 */
@WebServlet("/Apply")
public class ApplyServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final CampaignDAO    campaignDAO    = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "creator")) return;

        int campaignId = parseIntSafe(req.getParameter("id"));
        int creatorId  = SessionUtil.getUserId(req.getSession(false));

        try {
            Campaign c = campaignDAO.getCampaignById(campaignId);
            if (c == null) {
                resp.sendRedirect(req.getContextPath() + "/creator/browse.jsp");
                return;
            }
            // Attach apply status so JSP can show "Applied" instead of "Apply Now"
            boolean alreadyApplied = applicationDAO.hasApplied(campaignId, creatorId);
            String  appStatus      = applicationDAO.getApplicationStatus(campaignId, creatorId);

            req.setAttribute("campaign",      c);
            req.setAttribute("alreadyApplied", alreadyApplied);
            req.setAttribute("appStatus",     appStatus);
            req.getRequestDispatcher("/creator/apply.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/creator/browse.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "creator")) return;

        int creatorId  = SessionUtil.getUserId(req.getSession(false));
        int campaignId = parseIntSafe(req.getParameter("campaign_id"));

        try {
            Campaign c = campaignDAO.getCampaignById(campaignId);

            // Guard: only open campaigns can be applied to
            if (c == null || !"open".equals(c.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/creator/browse.jsp?error=closed");
                return;
            }

            // Guard: duplicate prevention (DB UNIQUE key also handles this)
            if (applicationDAO.hasApplied(campaignId, creatorId)) {
                resp.sendRedirect(req.getContextPath() + "/Apply?id=" + campaignId + "&duplicate=true");
                return;
            }

            int appId = applicationDAO.insertApplication(campaignId, creatorId);
            if (appId > 0) {
                resp.sendRedirect(req.getContextPath() + "/creator/my-applications.jsp?applied=true");
            } else {
                resp.sendRedirect(req.getContextPath() + "/Apply?id=" + campaignId + "&error=true");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/Apply?id=" + campaignId + "&error=db");
        }
    }

    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (Exception e) { return 0; }
    }
}
