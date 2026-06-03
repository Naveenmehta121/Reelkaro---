<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.models.Campaign" %>
<%
    if (!SessionUtil.requireRole(request, response, "creator")) return;
    String   lang           = SessionUtil.getLang(session);
    int      creatorId      = SessionUtil.getUserId(session);
    String   userName       = SessionUtil.getUserName(session);
    Campaign c              = (Campaign) request.getAttribute("campaign");
    boolean  alreadyApplied = Boolean.TRUE.equals(request.getAttribute("alreadyApplied"));
    String   appStatus      = (String) request.getAttribute("appStatus");
    String   errorMsg       = (String) request.getAttribute("errorMsg");

    if (c == null) { response.sendRedirect(request.getContextPath() + "/creator/browse.jsp"); return; }

    String platIcon = c.getPlatform().equals("Instagram") ? "📸" :
                      c.getPlatform().equals("YouTube")   ? "▶️" :
                      c.getPlatform().equals("Josh")      ? "🎵" :
                      c.getPlatform().equals("ShareChat") ? "💬" : "🎬";
    String waUrl = request.getRequestURL().toString().split("/creator")[0] + "/Apply?id=" + c.getId();
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= c.getTitle() %> — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/FilterCampaign" class="nav-link active">Browse</a></li>
            <li><a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="nav-link">Applications</a></li>
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
            <a href="<%= request.getContextPath() %>/FilterCampaign" class="sidebar-link active"><span class="icon">🔍</span> Browse</a>
            <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="sidebar-link"><span class="icon">📨</span> My Applications</a>
            <a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="sidebar-link"><span class="icon">💰</span> Earnings</a>
            <a href="<%= request.getContextPath() %>/Leaderboard" class="sidebar-link"><span class="icon">🏆</span> Leaderboard</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <a href="<%= request.getContextPath() %>/FilterCampaign" class="btn btn-secondary btn-sm mb-6">← Back to Campaigns</a>

        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <!-- Campaign Detail Card -->
        <div class="card mb-6">
            <div class="card-header">
                <div style="flex:1;">
                    <div class="flex items-center gap-3 mb-3">
                        <div class="platform-icon plat-<%= c.getPlatform().toLowerCase() %>"><%= platIcon %></div>
                        <div>
                            <span class="badge badge-<%= c.getStatus() %>"><%= c.getStatus().toUpperCase() %></span>
                            <% if (c.getCategory() != null) { %>
                            <span class="category-tag" style="margin-left:var(--sp-2);"><%= c.getCategory() %></span>
                            <% } %>
                        </div>
                    </div>
                    <h2><%= c.getTitle() %></h2>
                    <p style="color:var(--text-muted);margin-top:var(--sp-2);">
                        by <strong style="color:var(--text-primary);">
                            <%= c.getCompanyName() != null ? c.getCompanyName() : c.getBrandName() %>
                        </strong>
                    </p>
                </div>
                <div class="reward-badge" style="flex-shrink:0;white-space:nowrap;font-size:1.4rem;">
                    ₹<%= c.getRewardPerCreatorInr().toPlainString() %>
                </div>
            </div>

            <div style="padding:var(--sp-5);background:var(--navy-mid);border-radius:var(--r-md);margin:var(--sp-4) 0;">
                <h4 style="margin-bottom:var(--sp-3);color:var(--text-secondary);">📋 Campaign Brief</h4>
                <p style="white-space:pre-wrap;line-height:1.8;color:var(--text-secondary);"><%= c.getDescription() %></p>
            </div>

            <!-- Campaign Stats Grid -->
            <div class="stats-grid" style="margin:var(--sp-4) 0 0;">
                <div class="stat-card" style="padding:var(--sp-4);">
                    <div class="stat-value" style="font-size:1.3rem;">₹<%= String.format("%,.0f", c.getBudgetInr().doubleValue()) %></div>
                    <div class="stat-label">Total Budget</div>
                </div>
                <div class="stat-card" style="padding:var(--sp-4);">
                    <div class="stat-value" style="font-size:1.3rem;"><%= c.getMaxCreators() %></div>
                    <div class="stat-label">Max Creators</div>
                </div>
                <div class="stat-card" style="padding:var(--sp-4);">
                    <div class="stat-value" style="font-size:1.3rem;"><%= c.getApplyCount() %></div>
                    <div class="stat-label">Applicants</div>
                </div>
                <div class="stat-card" style="padding:var(--sp-4);">
                    <div class="stat-value" style="font-size:1rem;"><%= c.getDeadline() %></div>
                    <div class="stat-label">Deadline</div>
                </div>
            </div>
        </div>

        <!-- APPLY SECTION -->
        <div class="card" style="background:linear-gradient(135deg,rgba(255,255,255,0.03),var(--navy-card));">
            <h3 style="margin-bottom:var(--sp-4);">🚀 Apply for this Campaign</h3>

            <% if (!"open".equals(c.getStatus())) { %>
            <div class="alert alert-warning">This campaign is currently <%= c.getStatus() %> and not accepting new applications.</div>

            <% } else if (alreadyApplied) { %>
            <div class="alert alert-info">
                You have already applied to this campaign. Status: <strong><%= appStatus != null ? appStatus.toUpperCase() : "PENDING" %></strong>
            </div>
            <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="btn btn-secondary">View My Applications →</a>

            <% } else { %>
            <p style="margin-bottom:var(--sp-5);">
                Click the button below to apply. Your application will be reviewed by
                <strong><%= c.getCompanyName() != null ? c.getCompanyName() : c.getBrandName() %></strong>.
                Once approved, you can submit your content link.
            </p>

            <form method="post" action="<%= request.getContextPath() %>/Apply">
                <input type="hidden" name="campaign_id" value="<%= c.getId() %>">
                <button type="submit" class="btn btn-primary btn-lg" id="applyBtn" data-i18n="btn.apply">
                    🎯 Apply Now — Earn ₹<%= c.getRewardPerCreatorInr().toPlainString() %>
                </button>
            </form>
            <% } %>

            <!-- WhatsApp share -->
            <div style="margin-top:var(--sp-5);padding-top:var(--sp-5);border-top:1px solid var(--navy-border);">
                <p style="font-size:0.85rem;margin-bottom:var(--sp-3);">📢 Share this campaign with fellow creators:</p>
                <button class="btn btn-whatsapp"
                        data-wa-title="<%= c.getTitle().replace("\"","") %>"
                        data-wa-url="<%= waUrl %>">
                    📱 Share on WhatsApp
                </button>
            </div>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
