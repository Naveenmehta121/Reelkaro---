package com.reelkaro.servlets;

import com.reelkaro.dao.UserDAO;
import com.reelkaro.models.User;
import com.reelkaro.utils.HashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * LoginServlet — Authenticates users, creates a session, and
 * redirects to the correct dashboard based on role.
 *
 * GET  /Login → show login.jsp
 * POST /Login → authenticate, create session, redirect
 */
@WebServlet("/Login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email    = trim(req.getParameter("email"));
        String password = req.getParameter("password");

        if (email.isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("errorMsg", "Email and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            String hash = HashUtil.sha256(password);
            User   user = userDAO.findByEmailAndPassword(email, hash);

            if (user == null) {
                req.setAttribute("errorMsg", "Invalid email or password.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // ---- Create session ----
            HttpSession session = req.getSession(true);   // create new session
            session.setAttribute("userId",   user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("lang",
                    user.getLanguagePref() != null ? user.getLanguagePref() : "en");
            session.setMaxInactiveInterval(3600); // 1-hour timeout

            // ---- Route to the correct dashboard ----
            if ("brand".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/brand/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/creator/dashboard.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Login failed due to a server error. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }
}
