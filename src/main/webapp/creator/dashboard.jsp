<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.*, java.math.BigDecimal, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "creator")) return;
    String lang    = SessionUtil.getLang(session);
    int    userId  = SessionUtil.getUserId(session);
    String userName= SessionUtil.getUserName(session);

    ApplicationDAO appDAO    = new ApplicationDAO();
    RewardDAO      rewardDAO = new RewardDAO();

    int        pendingApps    = 0;
    int        approvedSubs   = 0;
    BigDecimal totalEarned    = BigDecimal.ZERO;
    int        rank           = 0;

    try {
        pendingApps  = appDAO.countPendingApplications(userId);
        approvedSubs = appDAO.countApprovedSubmissions(userId);
        totalEarned  = rewardDAO.getTotalEarnings(userId);
        rank         = rewardDAO.getCreatorRank(userId);
    } catch (SQLException e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creator Dashboard — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <button class="navbar-toggle" id="navbarToggle">☰</button>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link active">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/FilterCampaign" class="nav-link">Browse</a></li>
            <li><a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="nav-link">Applications</a></li>
            <li><a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="nav-link">Earnings</a></li>
            <li><a href="<%= request.getContextPath() %>/Leaderboard" class="nav-link">Leaderboard</a></li>
        </ul>
        <div class="navbar-actions">
            <div class="lang-toggle">
                <button class="lang-btn <%= "en".equals(lang) ? "active" : "" %>" data-lang="en">EN</button>
                <button class="lang-btn <%= "hi".equals(lang) ? "active" : "" %>" data-lang="hi">हि</button>
            </div>
            <form id="langForm" method="post" action="<%= request.getContextPath() %>/SetLanguage" style="display:none"><input type="hidden" name="lang" value="<%= lang %>"></form>
            <span style="color:#FFFFFF;font-size:0.8rem;font-weight:600;">🎬 Creator</span>
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
            <a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="sidebar-link active"><span class="icon">📊</span> Dashboard</a>
            <a href="<%= request.getContextPath() %>/FilterCampaign" class="sidebar-link"><span class="icon">🔍</span> Browse Campaigns</a>
            <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="sidebar-link"><span class="icon">📨</span> My Applications</a>
            <a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="sidebar-link"><span class="icon">💰</span> Earnings</a>
            <a href="<%= request.getContextPath() %>/Leaderboard" class="sidebar-link"><span class="icon">🏆</span> Leaderboard</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2>Creator Dashboard</h2>
            <p>Your performance overview and quick actions</p>
        </div>

        <!-- STATS -->
        <div class="stats-grid">
            <div class="stat-card fade-in-delay-1">
                <div class="stat-icon">💰</div>
                <div class="stat-value">₹<%= String.format("%,.0f", totalEarned.doubleValue()) %></div>
                <div class="stat-label" data-i18n="dash.total.earned">Total Earned</div>
            </div>
            <div class="stat-card fade-in-delay-2">
                <div class="stat-icon">⏳</div>
                <div class="stat-value"><%= pendingApps %></div>
                <div class="stat-label" data-i18n="dash.pending.apps">Pending Applications</div>
            </div>
            <div class="stat-card fade-in-delay-3">
                <div class="stat-icon">✅</div>
                <div class="stat-value"><%= approvedSubs %></div>
                <div class="stat-label" data-i18n="dash.approved.subs">Approved Submissions</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🏆</div>
                <div class="stat-value"><%= rank > 0 ? "#" + rank : "—" %></div>
                <div class="stat-label" data-i18n="dash.rank">Leaderboard Rank</div>
            </div>
        </div>

        <!-- QUICK ACTIONS -->
        <div class="card mb-6">
            <h3 style="margin-bottom:var(--sp-5);">⚡ Quick Actions</h3>
            <div class="flex gap-4" style="flex-wrap:wrap;">
                <a href="<%= request.getContextPath() %>/FilterCampaign" class="btn btn-primary">
                    🔍 Browse Campaigns
                </a>
                <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="btn btn-secondary">
                    📨 View Applications
                </a>
                <a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="btn btn-secondary">
                    💰 View Earnings
                </a>
                <a href="<%= request.getContextPath() %>/Leaderboard" class="btn btn-secondary">
                    🏆 Leaderboard
                </a>
            </div>
        </div>

        <!-- MOTIVATION CARD -->
        <div class="card" style="background:linear-gradient(135deg,rgba(255,255,255,0.01),rgba(255,255,255,0.04));">
            <h3 style="color:#FFFFFF;margin-bottom:var(--sp-4);">🚀 Level Up Your Creator Game</h3>
            <ul style="display:flex;flex-direction:column;gap:var(--sp-3);">
                <li style="display:flex;gap:var(--sp-3);align-items:flex-start;">
                    <span style="font-size:1.2rem;">📸</span>
                    <div>
                        <strong style="color:var(--text-primary);">Complete your profile</strong>
                        <p style="font-size:0.85rem;margin-top:2px;">Brands pick creators with complete social handles and bios.</p>
                    </div>
                </li>
                <li style="display:flex;gap:var(--sp-3);align-items:flex-start;">
                    <span style="font-size:1.2rem;">⚡</span>
                    <div>
                        <strong style="color:var(--text-primary);">Apply to more campaigns</strong>
                        <p style="font-size:0.85rem;margin-top:2px;">Higher application volume = higher chance of approvals.</p>
                    </div>
                </li>
                <li style="display:flex;gap:var(--sp-3);align-items:flex-start;">
                    <span style="font-size:1.2rem;">💰</span>
                    <div>
                        <strong style="color:var(--text-primary);">Add your UPI ID</strong>
                        <p style="font-size:0.85rem;margin-top:2px;">Set up your UPI on the Earnings page to receive payouts.</p>
                    </div>
                </li>
            </ul>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
