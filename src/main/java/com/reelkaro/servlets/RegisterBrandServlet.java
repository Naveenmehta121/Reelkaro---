package com.reelkaro.servlets;

import com.reelkaro.dao.UserDAO;
import com.reelkaro.utils.HashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * RegisterBrandServlet — Handles brand registration (POST /RegisterBrand).
 *
 * Validates inputs server-side, hashes the password, inserts the user
 * and brand profile rows, then redirects to the login page.
 */
@WebServlet("/RegisterBrand")
public class RegisterBrandServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // Show the registration form
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register-brand.jsp").forward(req, resp);
    }

    // Handle form submission
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name        = trim(req.getParameter("name"));
        String email       = trim(req.getParameter("email"));
        String password    = req.getParameter("password");
        String confirm     = req.getParameter("confirm_password");
        String companyName = trim(req.getParameter("company_name"));
        String industry    = trim(req.getParameter("industry"));
        String website     = trim(req.getParameter("website"));
        String gstNumber   = trim(req.getParameter("gst_number"));

        // ---- Server-side validation ----
        if (name.isEmpty() || email.isEmpty() || password == null
                || password.isEmpty() || companyName.isEmpty()) {
            setError(req, "All required fields must be filled.");
            req.getRequestDispatcher("/register-brand.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirm)) {
            setError(req, "Passwords do not match.");
            req.getRequestDispatcher("/register-brand.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            setError(req, "Password must be at least 6 characters.");
            req.getRequestDispatcher("/register-brand.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                setError(req, "This email is already registered. Please login.");
                req.getRequestDispatcher("/register-brand.jsp").forward(req, resp);
                return;
            }

            String hash   = HashUtil.sha256(password);
            int    userId = userDAO.insertUser(name, email, hash, "brand");

            if (userId > 0) {
                userDAO.insertBrandProfile(userId, companyName, industry, website, gstNumber);
                // Redirect to login with a success message
                resp.sendRedirect(req.getContextPath() + "/login.jsp?registered=true");
            } else {
                setError(req, "Registration failed. Please try again.");
                req.getRequestDispatcher("/register-brand.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            setError(req, "Database error: " + e.getMessage());
            req.getRequestDispatcher("/register-brand.jsp").forward(req, resp);
        }
    }

    private void setError(HttpServletRequest req, String msg) {
        req.setAttribute("errorMsg", msg);
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }
}
