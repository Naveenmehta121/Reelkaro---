package com.reelkaro.servlets;

import com.reelkaro.dao.CampaignDAO;
import com.reelkaro.models.Campaign;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

/**
 * EditCampaignServlet — Brand edits an existing campaign or changes its status.
 * GET  /EditCampaign?id=X      → show edit form pre-filled
 * POST /EditCampaign            → update campaign details
 * POST /EditCampaign?action=status → change status (open/paused/closed)
 */
@WebServlet("/EditCampaign")
public class EditCampaignServlet extends HttpServlet {

    private final CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "brand")) return;

        int campaignId = parseIntSafe(req.getParameter("id"));
        try {
            Campaign c = campaignDAO.getCampaignById(campaignId);
            if (c == null || c.getBrandId() != SessionUtil.getUserId(req.getSession(false))) {
                resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp");
                return;
            }
            req.setAttribute("campaign", c);
            req.getRequestDispatcher("/brand/post-campaign.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "brand")) return;
        req.setCharacterEncoding("UTF-8");

        int    brandId    = SessionUtil.getUserId(req.getSession(false));
        int    campaignId = parseIntSafe(req.getParameter("campaign_id"));
        String action     = trim(req.getParameter("action"));

        try {
            // --- Status-only change (pause / close / reopen) ---
            if ("status".equals(action)) {
                String newStatus = trim(req.getParameter("status"));
                Campaign c = campaignDAO.getCampaignById(campaignId);
                if (c != null && c.getBrandId() == brandId) {
                    campaignDAO.updateCampaignStatus(campaignId, newStatus);
                }
                resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp");
                return;
            }

            // --- Full edit ---
            String title    = trim(req.getParameter("title"));
            String desc     = trim(req.getParameter("description"));
            String platform = trim(req.getParameter("platform"));
            String category = trim(req.getParameter("category"));
            String deadline = trim(req.getParameter("deadline"));
            BigDecimal budget  = parseBD(req.getParameter("budget_inr"));
            BigDecimal reward  = parseBD(req.getParameter("reward_per_creator_inr"));
            int maxCreators    = parseIntSafe(req.getParameter("max_creators"));

            if (title.isEmpty() || desc.isEmpty() || platform.isEmpty() || deadline.isEmpty()
                    || budget == null || reward == null || maxCreators <= 0) {
                resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp?error=invalid");
                return;
            }

            Campaign c = campaignDAO.getCampaignById(campaignId);
            if (c != null && c.getBrandId() == brandId) {
                campaignDAO.updateCampaign(campaignId, title, desc, platform, category,
                        budget, reward, maxCreators, deadline);
            }
            resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp?updated=true");

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/brand/my-campaigns.jsp?error=db");
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
