package com.reelkaro.servlets;

import com.reelkaro.dao.CampaignDAO;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

/**
 * PostCampaignServlet — Brand creates a new campaign.
 * GET  /PostCampaign → show the post-campaign form
 * POST /PostCampaign → validate and insert the campaign
 */
@WebServlet("/PostCampaign")
public class PostCampaignServlet extends HttpServlet {

    private final CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "brand")) return;
        req.getRequestDispatcher("/brand/post-campaign.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.requireRole(req, resp, "brand")) return;
        req.setCharacterEncoding("UTF-8");

        int    brandId  = SessionUtil.getUserId(req.getSession(false));
        String title    = trim(req.getParameter("title"));
        String desc     = trim(req.getParameter("description"));
        String platform = trim(req.getParameter("platform"));
        String category = trim(req.getParameter("category"));
        String deadline = trim(req.getParameter("deadline"));
        BigDecimal budget  = parseBD(req.getParameter("budget_inr"));
        BigDecimal reward  = parseBD(req.getParameter("reward_per_creator_inr"));
        int maxCreators    = parseIntSafe(req.getParameter("max_creators"));

        // ---- Validation ----
        if (title.isEmpty() || desc.isEmpty() || platform.isEmpty() || deadline.isEmpty()
                || budget == null || reward == null || maxCreators <= 0) {
            req.setAttribute("errorMsg", "All fields are required and max creators must be > 0.");
            req.getRequestDispatcher("/brand/post-campaign.jsp").forward(req, resp);
            return;
        }
        if (reward.compareTo(budget) > 0) {
            req.setAttribute("errorMsg", "Reward per creator cannot exceed total budget.");
            req.getRequestDispatcher("/brand/post-campaign.jsp").forward(req, resp);
            return;
        }

        try {
            int campaignId = campaignDAO.insertCampaign(brandId, title, desc, platform,
                    category, budget, reward, maxCreators, deadline);
            if (campaignId > 0) {
                resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp?created=true");
            } else {
                req.setAttribute("errorMsg", "Failed to post campaign. Please try again.");
                req.getRequestDispatcher("/brand/post-campaign.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/brand/post-campaign.jsp").forward(req, resp);
        }
    }

    private String trim(String s) { return (s == null) ? "" : s.trim(); }
    private BigDecimal parseBD(String s) {
        try { return new BigDecimal(s == null ? "0" : s.trim()); }
        catch (Exception e) { return null; }
    }
    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (Exception e) { return 0; }
    }
}
