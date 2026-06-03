package com.reelkaro.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * SessionUtil — Helper methods for session management and role-based access.
 *
 * Every protected page calls SessionUtil.requireRole(...) at the top.
 * If the user is not logged in, or has the wrong role, they are
 * redirected to /login.jsp automatically.
 *
 * Session attributes stored after login:
 *   "userId"   (Integer) — users.id
 *   "userName" (String)  — users.name
 *   "userRole" (String)  — "brand" or "creator"
 *   "lang"     (String)  — "en" or "hi" (language preference)
 */
public class SessionUtil {

    private SessionUtil() {} // prevent instantiation

    // -------------------------------------------------------
    // GETTERS — read typed values from session safely
    // -------------------------------------------------------

    public static Integer getUserId(HttpSession session) {
        if (session == null) return null;
        return (Integer) session.getAttribute("userId");
    }

    public static String getUserRole(HttpSession session) {
        if (session == null) return null;
        return (String) session.getAttribute("userRole");
    }

    public static String getUserName(HttpSession session) {
        if (session == null) return null;
        return (String) session.getAttribute("userName");
    }

    public static String getLang(HttpSession session) {
        if (session == null) return "en";
        String lang = (String) session.getAttribute("lang");
        return (lang != null) ? lang : "en";
    }

    // -------------------------------------------------------
    // AUTH GUARD — call this at the top of every protected servlet
    // -------------------------------------------------------

    /**
     * Checks that:
     *  1. A session exists and the user is logged in.
     *  2. The user's role matches the required role.
     *
     * If the check fails, the user is redirected to /login.jsp
     * and this method returns FALSE — the caller should then
     * immediately return from doGet/doPost.
     *
     * @param req          the HTTP request
     * @param resp         the HTTP response
     * @param requiredRole "brand" or "creator"
     * @return true if authenticated and authorised, false otherwise
     */
    public static boolean requireRole(HttpServletRequest req,
                                      HttpServletResponse resp,
                                      String requiredRole) throws IOException {
        HttpSession session = req.getSession(false); // don't create a new session
        if (session == null || getUserId(session) == null) {
            // Not logged in at all
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return false;
        }
        String role = getUserRole(session);
        if (!requiredRole.equals(role)) {
            // Logged in but wrong role — send back to their own dashboard
            if ("brand".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/brand/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/creator/dashboard.jsp");
            }
            return false;
        }
        return true;
    }

    /**
     * Checks that a session exists, regardless of role.
     * Used by pages that only need authentication (not role-check).
     */
    public static boolean isLoggedIn(HttpSession session) {
        return session != null && getUserId(session) != null;
    }

    /**
     * Destroys the session (logout).
     */
    public static void invalidate(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
