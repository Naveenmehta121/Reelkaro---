package com.reelkaro.servlets;

import com.reelkaro.dao.RewardDAO;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * RewardServlet — Handles creator UPI ID updates and payout status changes.
 *
 * POST /Reward?action=upi     → Creator saves their UPI ID
 * POST /Reward?action=payout  → Admin/Brand marks a reward as "processing" (placeholder)
 */
@WebServlet("/Reward")
public class RewardServlet extends HttpServlet {

    private final RewardDAO rewardDAO = new RewardDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Ensure user is logged in (creators use this for UPI)
        HttpSession session = req.getSession(false);
        if (session == null || SessionUtil.getUserId(session) == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int    userId = SessionUtil.getUserId(session);
        String action = trim(req.getParameter("action"));

        try {
            if ("upi".equals(action)) {
                // Creator saving UPI ID
                String upiId = trim(req.getParameter("upi_id"));
                if (upiId.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/creator/earnings.jsp?error=empty_upi");
                    return;
                }
                rewardDAO.updateUpiId(userId, upiId);
                resp.sendRedirect(req.getContextPath() + "/creator/earnings.jsp?upi_saved=true");

            } else if ("payout".equals(action)) {
                // Brand/admin marking a payout (placeholder for Razorpay)
                int    rewardId = parseIntSafe(req.getParameter("reward_id"));
                String status   = trim(req.getParameter("status")); // processing / paid
                rewardDAO.updatePayoutStatus(rewardId, status);
                resp.sendRedirect(req.getContextPath() + "/creator/earnings.jsp?payout_updated=true");

            } else {
                resp.sendRedirect(req.getContextPath() + "/creator/earnings.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/creator/earnings.jsp?error=db");
        }
    }

    private String trim(String s) { return (s == null) ? "" : s.trim(); }
    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (Exception e) { return 0; }
    }
}
