package com.reelkaro.servlets;

import com.reelkaro.dao.ApplicationDAO;
import com.reelkaro.models.Application;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * SubmitContentServlet — Creator submits their content link after application is approved.
 * GET  /SubmitContent?id=X (campaign_id) → show submit form (submit.jsp)
 * POST /SubmitContent                     → save submission
 */
@WebServlet("/SubmitContent")
public class SubmitContentServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "creator")) return;

        int creatorId  = SessionUtil.getUserId(req.getSession(false));
        int campaignId = parseIntSafe(req.getParameter("id"));

        try {
            // Fetch application to check it's approved
            int appId = applicationDAO.getApplicationId(campaignId, creatorId);
            if (appId < 0) {
                resp.sendRedirect(req.getContextPath() + "/creator/my-applications.jsp");
                return;
            }
            String status = applicationDAO.getApplicationStatus(campaignId, creatorId);
            if (!"approved".equals(status)) {
                req.setAttribute("errorMsg", "You can only submit after your application is approved.");
                req.getRequestDispatcher("/creator/my-applications.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("campaignId", campaignId);
            req.setAttribute("appId",      appId);
            req.getRequestDispatcher("/creator/submit.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/creator/my-applications.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "creator")) return;
        req.setCharacterEncoding("UTF-8");

        int    creatorId       = SessionUtil.getUserId(req.getSession(false));
        int    applicationId   = parseIntSafe(req.getParameter("application_id"));
        String contentLink     = trim(req.getParameter("content_link"));
        String platformPosted  = trim(req.getParameter("platform_posted"));

        if (contentLink.isEmpty()) {
            req.setAttribute("errorMsg", "Content link is required.");
            req.setAttribute("appId", applicationId);
            req.getRequestDispatcher("/creator/submit.jsp").forward(req, resp);
            return;
        }

        try {
            applicationDAO.insertSubmission(applicationId, contentLink, platformPosted);
            resp.sendRedirect(req.getContextPath() + "/creator/my-applications.jsp?submitted=true");
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Database error: " + e.getMessage());
            req.setAttribute("appId", applicationId);
            req.getRequestDispatcher("/creator/submit.jsp").forward(req, resp);
        }
    }

    private String trim(String s) { return (s == null) ? "" : s.trim(); }
    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (Exception e) { return 0; }
    }
}
