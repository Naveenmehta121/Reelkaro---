<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.CampaignDAO, java.sql.SQLException" %>
<%
    /* Role guard */
    if (!SessionUtil.requireRole(request, response, "brand")) return;

    String lang     = SessionUtil.getLang(session);
    int    brandId  = SessionUtil.getUserId(session);
    String userName = SessionUtil.getUserName(session);

    /* Load brand dashboard stats */
    CampaignDAO campaignDAO = new CampaignDAO();
    String[] stats = {"0","0","0","0"};
    try {
        stats = campaignDAO.getBrandStats(brandId);
    } catch (SQLException e) { e.printStackTrace(); }

    String activeCampaigns = stats[0];
    String totalApps       = stats[1];
    String totalSpent      = stats[2];
    String approvalRate    = stats[3];
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Brand Dashboard — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand">
            <span class="logo-rk">RK</span> ReelKaro
        </a>
        <button class="navbar-toggle" id="navbarToggle">☰</button>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="nav-link active">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/PostCampaign" class="nav-link">Post Campaign</a></li>
            <li><a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="nav-link">My Campaigns</a></li>
            <li><a href="<%= request.getContextPath() %>/Profile" class="nav-link">Profile</a></li>
        </ul>
        <div class="navbar-actions">
            <div class="lang-toggle">
                <button class="lang-btn <%= "en".equals(lang) ? "active" : "" %>" data-lang="en">EN</button>
                <button class="lang-btn <%= "hi".equals(lang) ? "active" : "" %>" data-lang="hi">हि</button>
            </div>
            <form id="langForm" method="post" action="<%= request.getContextPath() %>/SetLanguage" style="display:none">
                <input type="hidden" name="lang" value="<%= lang %>">
            </form>
            <span style="color:#FFFFFF;font-size:0.8rem;font-weight:600;">🏢 Brand</span>
            <a href="<%= request.getContextPath() %>/Logout" class="btn btn-secondary btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="dashboard-layout">
    <!-- SIDEBAR -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand">
            <div class="role-badge">Brand Portal</div>
            <div class="user-name">👋 <%= userName %></div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="sidebar-link active">
                <span class="icon">📊</span> Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/PostCampaign" class="sidebar-link">
                <span class="icon">➕</span> <span data-i18n="nav.post">Post Campaign</span>
            </a>
            <a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="sidebar-link">
                <span class="icon">📋</span> <span data-i18n="nav.campaigns">My Campaigns</span>
            </a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link">
                <span class="icon">👤</span> <span data-i18n="nav.profile">Profile</span>
            </a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;">
                <span class="icon">🚪</span> <span data-i18n="nav.logout">Logout</span>
            </a>
        </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">
        <div class="page-header">
            <h2>Brand Dashboard</h2>
            <p>Overview of your campaigns and creator activity</p>
        </div>

        <!-- STATS CARDS -->
        <div class="stats-grid">
            <div class="stat-card fade-in-delay-1">
                <div class="stat-icon">📢</div>
                <div class="stat-value" data-count="<%= activeCampaigns %>"><%= activeCampaigns %></div>
                <div class="stat-label" data-i18n="dash.active.camps">Active Campaigns</div>
            </div>
            <div class="stat-card fade-in-delay-2">
                <div class="stat-icon">👥</div>
                <div class="stat-value" data-count="<%= totalApps %>"><%= totalApps %></div>
                <div class="stat-label" data-i18n="dash.total.apps">Total Applications</div>
            </div>
            <div class="stat-card fade-in-delay-3">
                <div class="stat-icon">💰</div>
                <div class="stat-value">₹<%= String.format("%,.0f", Double.parseDouble(totalSpent.isEmpty() ? "0" : totalSpent)) %></div>
                <div class="stat-label" data-i18n="dash.total.spent">Total Spent</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✅</div>
                <div class="stat-value"><%= approvalRate %>%</div>
                <div class="stat-label" data-i18n="dash.approval.rate">Approval Rate</div>
            </div>
        </div>

        <!-- QUICK ACTIONS -->
        <div class="card mb-6">
            <h3 style="margin-bottom:var(--sp-5);">⚡ Quick Actions</h3>
            <div class="flex gap-4" style="flex-wrap:wrap;">
                <a href="<%= request.getContextPath() %>/PostCampaign" class="btn btn-primary">
                    ➕ Post New Campaign
                </a>
                <a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="btn btn-secondary">
                    📋 View All Campaigns
                </a>
                <a href="<%= request.getContextPath() %>/Profile" class="btn btn-secondary">
                    👤 Edit Profile
                </a>
            </div>
        </div>

        <!-- TIPS -->
        <div class="card" style="background:linear-gradient(135deg,rgba(255,255,255,0.01),rgba(255,255,255,0.04));">
            <h3 style="margin-bottom:var(--sp-4);">💡 Pro Tips</h3>
            <ul style="list-style:none;display:flex;flex-direction:column;gap:var(--sp-3);">
                <li style="display:flex;gap:var(--sp-3);align-items:flex-start;">
                    <span style="font-size:1.2rem;">🎯</span>
                    <div>
                        <strong style="color:var(--text-primary);">Set competitive rewards</strong>
                        <p style="font-size:0.85rem;margin-top:2px;">Campaigns offering ₹500+ per creator get 3x more applications.</p>
                    </div>
                </li>
                <li style="display:flex;gap:var(--sp-3);align-items:flex-start;">
                    <span style="font-size:1.2rem;">📅</span>
                    <div>
                        <strong style="color:var(--text-primary);">Give enough time</strong>
                        <p style="font-size:0.85rem;margin-top:2px;">Set deadlines at least 2 weeks out for maximum creator reach.</p>
                    </div>
                </li>
                <li style="display:flex;gap:var(--sp-3);align-items:flex-start;">
                    <span style="font-size:1.2rem;">✍️</span>
                    <div>
                        <strong style="color:var(--text-primary);">Be specific in description</strong>
                        <p style="font-size:0.85rem;margin-top:2px;">Detailed briefs attract serious creators and reduce revision rounds.</p>
                    </div>
                </li>
            </ul>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
