<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.ApplicationDAO, com.reelkaro.models.Application, java.util.List, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "creator")) return;
    String lang      = SessionUtil.getLang(session);
    int    creatorId = SessionUtil.getUserId(session);
    String userName  = SessionUtil.getUserName(session);

    ApplicationDAO appDAO = new ApplicationDAO();
    List<Application> apps = null;
    try { apps = appDAO.getApplicationsByCreator(creatorId); }
    catch (SQLException e) { e.printStackTrace(); }

    String applied   = request.getParameter("applied");
    String submitted = request.getParameter("submitted");
    String errorMsg  = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/FilterCampaign" class="nav-link">Browse</a></li>
            <li><a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="nav-link active">Applications</a></li>
        </ul>
        <div class="navbar-actions">
            <div class="lang-toggle">
                <button class="lang-btn <%= "en".equals(lang) ? "active" : "" %>" data-lang="en">EN</button>
                <button class="lang-btn <%= "hi".equals(lang) ? "active" : "" %>" data-lang="hi">हि</button>
            </div>
            <form id="langForm" method="post" action="<%= request.getContextPath() %>/SetLanguage" style="display:none"><input type="hidden" name="lang" value="<%= lang %>"></form>
            <a href="<%= request.getContextPath() %>/Logout" class="btn btn-secondary btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="dashboard-layout">
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand">
            <div class="role-badge" style="color:#FFFFFF;border-color:rgba(255,255,255,0.2);background:rgba(255,255,255,0.08);">Creator Portal</div>
            <div class="user-name">👋 <%= userName %></div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="sidebar-link"><span class="icon">📊</span> Dashboard</a>
            <a href="<%= request.getContextPath() %>/FilterCampaign" class="sidebar-link"><span class="icon">🔍</span> Browse</a>
            <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="sidebar-link active"><span class="icon">📨</span> My Applications</a>
            <a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="sidebar-link"><span class="icon">💰</span> Earnings</a>
            <a href="<%= request.getContextPath() %>/Leaderboard" class="sidebar-link"><span class="icon">🏆</span> Leaderboard</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2>📨 My Applications</h2>
            <p>Track all your campaign applications and submit content when approved</p>
        </div>

        <% if ("true".equals(applied)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ Application submitted! The brand will review it soon.</div>
        <% } %>
        <% if ("true".equals(submitted)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ Content submitted! Waiting for brand review.</div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <% if (apps == null || apps.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">📭</div>
            <h3>No applications yet</h3>
            <p>Browse open campaigns and apply to start earning!</p>
            <a href="<%= request.getContextPath() %>/FilterCampaign" class="btn btn-primary mt-4">Browse Campaigns →</a>
        </div>
        <% } else { %>
        <div style="display:flex;flex-direction:column;gap:var(--sp-4);">
            <% for (Application app : apps) { %>
            <div class="card">
                <div class="flex justify-between items-center" style="flex-wrap:wrap;gap:var(--sp-3);">
                    <div>
                        <h4><%= app.getCampaignTitle() != null ? app.getCampaignTitle() : "Campaign #" + app.getCampaignId() %></h4>
                        <div class="flex items-center gap-3 mt-2" style="flex-wrap:wrap;">
                            <span class="badge badge-<%= app.getStatus() %>"><%= app.getStatus().toUpperCase() %></span>
                            <span style="font-size:0.8rem;color:var(--text-muted);">Applied: <%= app.getAppliedAt().toString().substring(0,10) %></span>
                        </div>
                    </div>

                    <!-- Action based on status -->
                    <div class="flex gap-3" style="flex-wrap:wrap;">
                        <a href="<%= request.getContextPath() %>/Apply?id=<%= app.getCampaignId() %>"
                           class="btn btn-secondary btn-sm">View Campaign</a>

                        <% if ("approved".equals(app.getStatus())) { %>
                        <a href="<%= request.getContextPath() %>/SubmitContent?id=<%= app.getCampaignId() %>"
                           class="btn btn-primary btn-sm" data-i18n="btn.submit">Submit Content</a>
                        <% } else if ("pending".equals(app.getStatus())) { %>
                        <span class="badge badge-pending" style="font-size:0.8rem;">⏳ Awaiting Brand Review</span>
                        <% } else if ("rejected".equals(app.getStatus())) { %>
                        <span class="badge badge-rejected">❌ Not Selected</span>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
