package com.reelkaro.servlets;

import com.reelkaro.utils.SessionUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * LogoutServlet — Invalidates the session and redirects to the landing page.
 * GET /Logout
 */
@WebServlet("/Logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        SessionUtil.invalidate(req);
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        doGet(req, resp); // support both GET and POST for logout links/forms
    }
}
