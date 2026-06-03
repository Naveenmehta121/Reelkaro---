package com.reelkaro.servlets;

import com.reelkaro.dao.RewardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * LeaderboardServlet — Loads the top-20 creator leaderboard and forwards
 * to the leaderboard JSP. Public page — no login required.
 *
 * GET /Leaderboard
 */
@WebServlet("/Leaderboard")
public class LeaderboardServlet extends HttpServlet {

    private final RewardDAO rewardDAO = new RewardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Object[]> rows = rewardDAO.getLeaderboard();
            req.setAttribute("leaderboard", rows);
            req.getRequestDispatcher("/creator/leaderboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Could not load leaderboard.");
            req.getRequestDispatcher("/creator/leaderboard.jsp").forward(req, resp);
        }
    }
}
