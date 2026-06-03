<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil" %>
<%
    String lang = SessionUtil.getLang(session);
    // If already logged in, redirect to their dashboard
    if (SessionUtil.isLoggedIn(session)) {
        String role = SessionUtil.getUserRole(session);
        if ("brand".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/brand/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/creator/dashboard.jsp");
        }
        return;
    }

    String registered = request.getParameter("registered");
    String errorMsg   = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — ReelKaro</title>
    <meta name="description" content="Login to your ReelKaro account. Access your brand or creator dashboard.">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<main class="auth-page">
    <div class="auth-card fade-in">

        <!-- Logo -->
        <div class="logo">
            <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand" style="font-size:1.6rem;justify-content:center;">
                <span class="logo-rk">RK</span> ReelKaro
            </a>
            <p style="margin-top:var(--sp-2);color:var(--text-muted);font-size:0.8rem;">India's Creator Marketplace</p>
        </div>

        <h2>Welcome Back</h2>
        <p class="subtitle">Login to your ReelKaro account</p>

        <!-- Success message after registration -->
        <% if ("true".equals(registered)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">
            ✅ Registration successful! Please login.
        </div>
        <% } %>

        <!-- Error message from servlet -->
        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <!-- Login Form -->
        <form method="post" action="<%= request.getContextPath() %>/Login" data-validate id="loginForm">
            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="you@example.com" required autocomplete="email">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="Your password" required autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-primary btn-full btn-lg" id="loginBtn">
                Login →
            </button>
        </form>

        <div class="divider"><span>or</span></div>

        <!-- Role-specific registration links -->
        <div class="flex gap-4">
            <a href="<%= request.getContextPath() %>/register-brand.jsp"
               class="btn btn-secondary btn-full" style="font-size:0.85rem;">
                🏢 Register as Brand
            </a>
            <a href="<%= request.getContextPath() %>/register-creator.jsp"
               class="btn btn-secondary btn-full" style="font-size:0.85rem;">
                🎬 Register as Creator
            </a>
        </div>

        <p class="auth-footer">
            <a href="<%= request.getContextPath() %>/index.jsp">← Back to Home</a>
        </p>

        <!-- Demo credentials hint -->
        <div class="alert alert-info" style="margin-top:var(--sp-5);font-size:0.8rem;">
            ℹ️ <strong>Demo:</strong> brand@demo.com / creator@demo.com | password: password123
        </div>
    </div>
</main>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
