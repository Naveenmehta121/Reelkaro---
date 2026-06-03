<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.CampaignDAO, com.reelkaro.dao.ApplicationDAO, com.reelkaro.models.Campaign, java.util.List, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "creator")) return;
    String lang      = SessionUtil.getLang(session);
    int    creatorId = SessionUtil.getUserId(session);
    String userName  = SessionUtil.getUserName(session);

    /* Fetch campaigns — servlet sets them if filter was applied, else load all open */
    List<Campaign> campaigns = (List<Campaign>) request.getAttribute("campaigns");
    if (campaigns == null) {
        CampaignDAO dao = new CampaignDAO();
        try { campaigns = dao.getOpenCampaigns(null, null, null, "newest"); }
        catch (SQLException e) { e.printStackTrace(); }
    }

    String filterPlatform  = (String) request.getAttribute("filterPlatform");
    String filterCategory  = (String) request.getAttribute("filterCategory");
    String filterMinReward = (String) request.getAttribute("filterMinReward");
    String filterSort      = (String) request.getAttribute("filterSort");
    if (filterSort == null) filterSort = "newest";

    ApplicationDAO appDAO = new ApplicationDAO();
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Campaigns — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <button class="navbar-toggle" id="navbarToggle">☰</button>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/FilterCampaign" class="nav-link active">Browse</a></li>
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
            <a href="<%= request.getContextPath() %>/FilterCampaign" class="sidebar-link active"><span class="icon">🔍</span> Browse Campaigns</a>
            <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="sidebar-link"><span class="icon">📨</span> My Applications</a>
            <a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="sidebar-link"><span class="icon">💰</span> Earnings</a>
            <a href="<%= request.getContextPath() %>/Leaderboard" class="sidebar-link"><span class="icon">🏆</span> Leaderboard</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2>🔍 Browse Open Campaigns</h2>
            <p>Find campaigns that match your content style and platform</p>
        </div>

        <!-- FILTER BAR -->
        <form method="get" action="<%= request.getContextPath() %>/FilterCampaign" class="filter-bar">
            <div class="form-group">
                <label class="form-label">Platform</label>
                <select name="platform" class="form-control">
                    <option value="">All Platforms</option>
                    <% for (String p : new String[]{"Instagram","YouTube","Josh","ShareChat","Moj"}) {
                       String sel = p.equals(filterPlatform) ? "selected" : ""; %>
                    <option value="<%= p %>" <%= sel %>><%= p %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Category</label>
                <select name="category" class="form-control">
                    <option value="">All Categories</option>
                    <% for (String cat : new String[]{"Fashion & Lifestyle","Food & Beverages","Beauty & Skincare",
                        "Health & Fitness","Tech & Gadgets","Travel & Tourism","Gaming & Esports",
                        "Home & Decor","Fintech & Finance","Education & EdTech","Music & Entertainment","Other"}) {
                        String sel = cat.equals(filterCategory) ? "selected" : ""; %>
                    <option value="<%= cat %>" <%= sel %>><%= cat %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Min Reward (₹)</label>
                <input type="number" name="minReward" class="form-control" placeholder="0"
                       value="<%= filterMinReward != null ? filterMinReward : "" %>">
            </div>
            <div class="form-group">
                <label class="form-label">Sort By</label>
                <select name="sort" class="form-control">
                    <option value="newest" <%= "newest".equals(filterSort) ? "selected" : "" %>>Newest First</option>
                    <option value="highest_reward" <%= "highest_reward".equals(filterSort) ? "selected" : "" %>>Highest Reward</option>
                </select>
            </div>
            <div class="form-group" style="align-self:flex-end;">
                <button type="submit" class="btn btn-primary btn-full">🔍 Filter</button>
            </div>
        </form>

        <!-- CAMPAIGN CARDS -->
        <% if (campaigns == null || campaigns.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">📭</div>
            <h3>No campaigns found</h3>
            <p>Try removing some filters or check back soon for new campaigns.</p>
        </div>
        <% } else { %>
        <p style="color:var(--text-muted);font-size:0.85rem;margin-bottom:var(--sp-4);">
            Showing <%= campaigns.size() %> open campaign<%= campaigns.size() != 1 ? "s" : "" %>
        </p>
        <div class="grid-2">
            <% for (Campaign c : campaigns) {
                boolean applied = false;
                String  appStatus = null;
                try {
                    applied   = appDAO.hasApplied(c.getId(), creatorId);
                    appStatus = appDAO.getApplicationStatus(c.getId(), creatorId);
                } catch (SQLException ignore) {}

                String platIcon = c.getPlatform().equals("Instagram") ? "📸" :
                                  c.getPlatform().equals("YouTube")   ? "▶️" :
                                  c.getPlatform().equals("Josh")      ? "🎵" :
                                  c.getPlatform().equals("ShareChat") ? "💬" : "🎬";
                String platClass = "plat-" + c.getPlatform().toLowerCase();
                String waTitle   = c.getTitle().replace("'","").replace("\"","");
                String waUrl     = request.getRequestURL().toString().split("/creator")[0]
                                   + "/Apply?id=" + c.getId();
            %>
            <div class="card campaign-card">
                <div class="card-header">
                    <div class="flex items-center gap-3" style="flex:1;min-width:0;">
                        <div class="platform-icon <%= platClass %>"><%= platIcon %></div>
                        <div style="min-width:0;">
                            <div class="flex items-center gap-2 mb-1" style="flex-wrap:wrap;">
                                <span class="badge badge-open">OPEN</span>
                                <% if (c.getCategory() != null) { %>
                                <span class="category-tag"><%= c.getCategory() %></span>
                                <% } %>
                            </div>
                            <h4 class="card-title" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                <%= c.getTitle() %>
                            </h4>
                        </div>
                    </div>
                    <div class="reward-badge">₹<%= c.getRewardPerCreatorInr().toPlainString() %></div>
                </div>

                <p style="font-size:0.85rem;color:var(--text-muted);margin-bottom:var(--sp-4);">
                    <%= c.getDescription().length() > 100 ? c.getDescription().substring(0,100)+"..." : c.getDescription() %>
                </p>

                <div class="meta-row">
                    <span>📱 <%= c.getPlatform() %></span>
                    <span>📅 <%= c.getDeadline() %></span>
                    <span>👥 <%= c.getApplyCount() %>/<%= c.getMaxCreators() %></span>
                    <span>🏢 <%= c.getCompanyName() != null ? c.getCompanyName() : c.getBrandName() %></span>
                </div>

                <div class="card-footer">
                    <div class="flex gap-2" style="flex-wrap:wrap;">
                        <% if (applied) { %>
                        <button class="btn btn-secondary btn-sm" disabled>
                            ✓ <%= appStatus != null ? appStatus.substring(0,1).toUpperCase()+appStatus.substring(1) : "Applied" %>
                        </button>
                        <% } else { %>
                        <a href="<%= request.getContextPath() %>/Apply?id=<%= c.getId() %>"
                           class="btn btn-primary btn-sm" data-i18n="btn.apply">Apply Now</a>
                        <% } %>
                        <a href="<%= request.getContextPath() %>/Apply?id=<%= c.getId() %>"
                           class="btn btn-secondary btn-sm">View Details</a>
                    </div>
                    <!-- WhatsApp Share -->
                    <button class="btn btn-whatsapp btn-sm"
                            data-wa-title="<%= waTitle %>"
                            data-wa-url="<%= waUrl %>">
                        📱 Share
                    </button>
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
