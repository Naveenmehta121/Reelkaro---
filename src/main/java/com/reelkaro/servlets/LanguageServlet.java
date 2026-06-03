package com.reelkaro.servlets;

import com.reelkaro.dao.UserDAO;
import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * LanguageServlet — Toggles the session language between English ("en") and Hindi ("hi").
 * Also persists the preference to the database.
 *
 * POST /SetLanguage?lang=hi  (or lang=en)
 * Redirects back to the referring page (or index.jsp if no referer).
 */
@WebServlet("/SetLanguage")
public class LanguageServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String lang    = req.getParameter("lang");
        String referer = req.getHeader("Referer");

        if (!"hi".equals(lang)) lang = "en"; // default to English for any invalid value

        // Update session attribute immediately so the current page reflects change
        HttpSession session = req.getSession(true);
        session.setAttribute("lang", lang);

        // Persist to DB if user is logged in
        Integer userId = SessionUtil.getUserId(session);
        if (userId != null) {
            try {
                userDAO.updateLanguagePref(userId, lang);
            } catch (SQLException e) {
                e.printStackTrace(); // non-fatal — language still set in session
            }
        }

        // Redirect back to wherever the user was
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doPost(req, resp);
    }
}
