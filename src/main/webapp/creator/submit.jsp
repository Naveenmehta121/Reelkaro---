<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil" %>
<%
    if (!SessionUtil.requireRole(request, response, "creator")) return;
    String lang       = SessionUtil.getLang(session);
    String userName   = SessionUtil.getUserName(session);
    Integer campaignId= (Integer) request.getAttribute("campaignId");
    Integer appId     = (Integer) request.getAttribute("appId");
    String  errorMsg  = (String)  request.getAttribute("errorMsg");
    if (campaignId == null) campaignId = 0;
    if (appId == null) appId = 0;
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Content — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link">Dashboard</a></li>
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
        <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="btn btn-secondary btn-sm mb-6">← Back to Applications</a>

        <div class="page-header">
            <h2>📤 Submit Your Content</h2>
            <p>Paste the link to your published post. The brand will review and approve it.</p>
        </div>

        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <div class="card" style="max-width:560px;">
            <!-- Step indicator -->
            <div style="display:flex;gap:var(--sp-3);margin-bottom:var(--sp-6);">
                <div style="display:flex;align-items:center;gap:var(--sp-2);">
                    <div style="width:28px;height:28px;background:rgba(255,255,255,0.1);border:1px solid rgba(255,255,255,0.2);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.8rem;color:#FFFFFF;font-weight:700;">✓</div>
                    <span style="font-size:0.85rem;color:var(--text-muted);">Applied</span>
                </div>
                <div style="flex:1;height:2px;background:rgba(255,255,255,0.2);margin:14px 0;"></div>
                <div style="display:flex;align-items:center;gap:var(--sp-2);">
                    <div style="width:28px;height:28px;background:rgba(255,255,255,0.1);border:1px solid rgba(255,255,255,0.2);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.8rem;color:#FFFFFF;font-weight:700;">✓</div>
                    <span style="font-size:0.85rem;color:var(--text-muted);">Approved</span>
                </div>
                <div style="flex:1;height:2px;background:rgba(255,255,255,0.2);margin:14px 0;"></div>
                <div style="display:flex;align-items:center;gap:var(--sp-2);">
                    <div style="width:28px;height:28px;background:#FFFFFF;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.8rem;color:#000000;font-weight:700;box-shadow:0 0 10px rgba(255,255,255,0.25);">3</div>
                    <span style="font-size:0.85rem;color:#FFFFFF;font-weight:600;">Submit</span>
                </div>
            </div>

            <form method="post" action="<%= request.getContextPath() %>/SubmitContent" data-validate>
                <input type="hidden" name="application_id" value="<%= appId %>">

                <div class="form-group">
                    <label class="form-label" for="content_link">Content URL / Post Link *</label>
                    <input type="url" id="content_link" name="content_link" class="form-control"
                           placeholder="https://www.instagram.com/p/..." required>
                    <p class="form-hint">
                        Paste the direct URL to your published post on the platform.
                        Make sure it's public and accessible.
                    </p>
                </div>

                <div class="form-group">
                    <label class="form-label" for="platform_posted">Platform Posted On *</label>
                    <select id="platform_posted" name="platform_posted" class="form-control" required>
                        <option value="">Select Platform</option>
                        <option value="Instagram">📸 Instagram</option>
                        <option value="YouTube">▶️ YouTube</option>
                        <option value="Josh">🎵 Josh</option>
                        <option value="ShareChat">💬 ShareChat</option>
                        <option value="Moj">🎬 Moj</option>
                    </select>
                </div>

                <div class="alert alert-info" style="margin-bottom:var(--sp-5);">
                    ℹ️ Once you submit, the brand will review your content.
                    If approved, your reward will be added to your earnings automatically.
                </div>

                <button type="submit" class="btn btn-primary btn-lg" id="submitContentBtn">
                    📤 Submit Content
                </button>
                <a href="<%= request.getContextPath() %>/creator/my-applications.jsp"
                   class="btn btn-secondary" style="margin-left:var(--sp-3);">Cancel</a>
            </form>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
