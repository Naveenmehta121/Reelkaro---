package com.reelkaro.servlets;

import com.reelkaro.dao.UserDAO;
import com.reelkaro.utils.HashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * RegisterCreatorServlet — Handles creator registration (POST /RegisterCreator).
 *
 * Collects social handles, niche, city/state, and creates both
 * the user row and the creator_profiles row in one transaction.
 */
@WebServlet("/RegisterCreator")
public class RegisterCreatorServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register-creator.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name          = trim(req.getParameter("name"));
        String email         = trim(req.getParameter("email"));
        String password      = req.getParameter("password");
        String confirm       = req.getParameter("confirm_password");
        String username      = trim(req.getParameter("username"));
        String niche         = trim(req.getParameter("niche"));
        String instagram     = trim(req.getParameter("instagram_handle"));
        String youtube       = trim(req.getParameter("youtube_handle"));
        String josh          = trim(req.getParameter("josh_handle"));
        String sharechat     = trim(req.getParameter("sharechat_handle"));
        String city          = trim(req.getParameter("city"));
        String state         = trim(req.getParameter("state"));
        String bio           = trim(req.getParameter("bio"));
        int    followersCount = parseIntSafe(req.getParameter("followers_count"));

        // ---- Server-side validation ----
        if (name.isEmpty() || email.isEmpty() || password == null
                || password.isEmpty() || username.isEmpty()) {
            setError(req, "Name, email, password, and username are required.");
            req.getRequestDispatcher("/register-creator.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirm)) {
            setError(req, "Passwords do not match.");
            req.getRequestDispatcher("/register-creator.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            setError(req, "Password must be at least 6 characters.");
            req.getRequestDispatcher("/register-creator.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                setError(req, "This email is already registered. Please login.");
                req.getRequestDispatcher("/register-creator.jsp").forward(req, resp);
                return;
            }

            String hash   = HashUtil.sha256(password);
            int    userId = userDAO.insertUser(name, email, hash, "creator");

            if (userId > 0) {
                userDAO.insertCreatorProfile(userId, username, niche, instagram, youtube,
                        josh, sharechat, followersCount, city, state, bio);
                resp.sendRedirect(req.getContextPath() + "/login.jsp?registered=true");
            } else {
                setError(req, "Registration failed. Please try again.");
                req.getRequestDispatcher("/register-creator.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            setError(req, "Database error: " + e.getMessage());
            req.getRequestDispatcher("/register-creator.jsp").forward(req, resp);
        }
    }

    private void setError(HttpServletRequest req, String msg) {
        req.setAttribute("errorMsg", msg);
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }

    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (NumberFormatException e) { return 0; }
    }
}
