package com.reelkaro.servlets;

import com.reelkaro.dao.UserDAO;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * ProfileServlet — Handles viewing and saving profile data for both roles.
 *
 * GET  /Profile → show brand/profile.jsp or creator/profile.jsp
 * POST /Profile → save updated profile
 */
@WebServlet("/Profile")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!SessionUtil.isLoggedIn(session)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int    userId = SessionUtil.getUserId(session);
        String role   = SessionUtil.getUserRole(session);

        try {
            if ("brand".equals(role)) {
                String[] profile = userDAO.getBrandProfile(userId);
                req.setAttribute("profile", profile);
                req.getRequestDispatcher("/brand/profile.jsp").forward(req, resp);
            } else {
                String[] profile = userDAO.getCreatorProfile(userId);
                req.setAttribute("profile", profile);
                req.getRequestDispatcher("/creator/profile.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!SessionUtil.isLoggedIn(session)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        req.setCharacterEncoding("UTF-8");

        int    userId = SessionUtil.getUserId(session);
        String role   = SessionUtil.getUserRole(session);

        try {
            if ("brand".equals(role)) {
                String companyName = trim(req.getParameter("company_name"));
                String industry    = trim(req.getParameter("industry"));
                String website     = trim(req.getParameter("website"));
                String gstNumber   = trim(req.getParameter("gst_number"));
                userDAO.updateBrandProfile(userId, companyName, industry, website, gstNumber);
                resp.sendRedirect(req.getContextPath() + "/brand/profile.jsp?saved=true");

            } else {
                String username      = trim(req.getParameter("username"));
                String niche         = trim(req.getParameter("niche"));
                String instagram     = trim(req.getParameter("instagram_handle"));
                String youtube       = trim(req.getParameter("youtube_handle"));
                String josh          = trim(req.getParameter("josh_handle"));
                String sharechat     = trim(req.getParameter("sharechat_handle"));
                int    followersCount= parseIntSafe(req.getParameter("followers_count"));
                String city          = trim(req.getParameter("city"));
                String state         = trim(req.getParameter("state"));
                String bio           = trim(req.getParameter("bio"));
                userDAO.updateCreatorProfile(userId, username, niche, instagram, youtube,
                        josh, sharechat, followersCount, city, state, bio);
                resp.sendRedirect(req.getContextPath() + "/creator/profile.jsp?saved=true");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Save failed: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private String trim(String s) { return (s == null) ? "" : s.trim(); }
    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s == null ? "0" : s.trim()); }
        catch (Exception e) { return 0; }
    }
}
