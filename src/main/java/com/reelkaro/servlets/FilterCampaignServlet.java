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
import java.util.List;

/**
 * FilterCampaignServlet — Creator browses and filters open campaigns.
 * Supports: platform filter, category filter, minimum reward filter, sort order.
 *
 * GET  /FilterCampaign?platform=Instagram&category=Fashion&minReward=500&sort=highest_reward
 * POST /FilterCampaign → same as GET (form submission)
 */
@WebServlet("/FilterCampaign")
public class FilterCampaignServlet extends HttpServlet {

    private final CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.requireRole(req, resp, "creator")) return;

        String   platform  = trim(req.getParameter("platform"));
        String   category  = trim(req.getParameter("category"));
        String   minRStr   = req.getParameter("minReward");
        String   sortBy    = trim(req.getParameter("sort"));
        BigDecimal minReward = parseBD(minRStr);

        if (sortBy.isEmpty()) sortBy = "newest";

        try {
            List<Campaign> campaigns = campaignDAO.getOpenCampaigns(platform, category, minReward, sortBy);
            req.setAttribute("campaigns", campaigns);
            req.setAttribute("filterPlatform",  platform);
            req.setAttribute("filterCategory",  category);
            req.setAttribute("filterMinReward", minRStr);
            req.setAttribute("filterSort",      sortBy);
            req.getRequestDispatcher("/creator/browse.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Could not load campaigns.");
            req.getRequestDispatcher("/creator/browse.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp); // redirect POST to GET handler
    }

    private String trim(String s) { return (s == null) ? "" : s.trim(); }
    private BigDecimal parseBD(String s) {
        try { return (s != null && !s.trim().isEmpty()) ? new BigDecimal(s.trim()) : BigDecimal.ZERO; }
        catch (Exception e) { return BigDecimal.ZERO; }
    }
}
