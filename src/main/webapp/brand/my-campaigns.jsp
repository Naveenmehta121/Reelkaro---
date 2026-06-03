<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.CampaignDAO, com.reelkaro.models.Campaign, java.util.List, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "brand")) return;
    String lang    = SessionUtil.getLang(session);
    int    brandId = SessionUtil.getUserId(session);
    String userName= SessionUtil.getUserName(session);

    CampaignDAO campaignDAO = new CampaignDAO();
    List<Campaign> campaigns = null;
    try {
        campaigns = campaignDAO.getCampaignsByBrand(brandId);
    } catch (SQLException e) { e.printStackTrace(); }

    String created = request.getParameter("created");
    String updated = request.getParameter("updated");
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Campaigns — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/PostCampaign" class="nav-link">Post Campaign</a></li>
            <li><a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="nav-link active">My Campaigns</a></li>
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
            <div class="role-badge">Brand Portal</div>
            <div class="user-name">👋 <%= userName %></div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="sidebar-link"><span class="icon">📊</span> Dashboard</a>
            <a href="<%= request.getContextPath() %>/PostCampaign" class="sidebar-link"><span class="icon">➕</span> Post Campaign</a>
            <a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="sidebar-link active"><span class="icon">📋</span> My Campaigns</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header flex justify-between items-center" style="flex-wrap:wrap;gap:var(--sp-4);">
            <div>
                <h2>📋 My Campaigns</h2>
                <p>Manage all your brand campaigns</p>
            </div>
            <a href="<%= request.getContextPath() %>/PostCampaign" class="btn btn-primary">➕ New Campaign</a>
        </div>

        <% if ("true".equals(created)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ Campaign posted successfully!</div>
        <% } %>
        <% if ("true".equals(updated)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ Campaign updated successfully!</div>
        <% } %>

        <% if (campaigns == null || campaigns.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">📢</div>
            <h3>No campaigns yet</h3>
            <p>Post your first campaign to start connecting with creators.</p>
            <a href="<%= request.getContextPath() %>/PostCampaign" class="btn btn-primary mt-4">Post First Campaign →</a>
        </div>
        <% } else {
            for (Campaign c : campaigns) {
                String statusClass = "badge-" + c.getStatus();
        %>
        <div class="card mb-4">
            <div class="card-header">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <span class="badge <%= statusClass %>"><%= c.getStatus().toUpperCase() %></span>
                        <span class="category-tag"><%= c.getCategory() != null ? c.getCategory() : "General" %></span>
                        <span style="font-size:1.2rem;"><%= c.getPlatform().equals("Instagram") ? "📸" : c.getPlatform().equals("YouTube") ? "▶️" : c.getPlatform().equals("Josh") ? "🎵" : c.getPlatform().equals("ShareChat") ? "💬" : "🎬" %></span>
                    </div>
                    <h3 class="card-title"><%= c.getTitle() %></h3>
                    <p style="font-size:0.85rem;margin-top:var(--sp-1);">
                        <%= c.getDescription().length() > 120 ? c.getDescription().substring(0, 120) + "..." : c.getDescription() %>
                    </p>
                </div>
                <div class="reward-badge" style="flex-shrink:0;">₹<%= c.getRewardPerCreatorInr().toPlainString() %></div>
            </div>

            <div class="meta-row mt-2">
                <span>📅 Deadline: <strong><%= c.getDeadline() %></strong></span>
                <span>👥 <%= c.getApplyCount() %>/<%= c.getMaxCreators() %> applicants</span>
                <span>💰 Budget: ₹<%= String.format("%,.0f", c.getBudgetInr().doubleValue()) %></span>
            </div>

            <div class="card-footer">
                <div class="flex gap-3" style="flex-wrap:wrap;">
                    <a href="<%= request.getContextPath() %>/brand/campaign-detail.jsp?id=<%= c.getId() %>"
                       class="btn btn-secondary btn-sm">👁 View Applicants</a>
                    <a href="<%= request.getContextPath() %>/EditCampaign?id=<%= c.getId() %>"
                       class="btn btn-secondary btn-sm">✏️ Edit</a>
                </div>

                <!-- Status change buttons -->
                <div class="flex gap-2" style="flex-wrap:wrap;">
                    <% if ("open".equals(c.getStatus())) { %>
                    <form method="post" action="<%= request.getContextPath() %>/EditCampaign" style="display:inline;">
                        <input type="hidden" name="campaign_id" value="<%= c.getId() %>">
                        <input type="hidden" name="action" value="status">
                        <input type="hidden" name="status" value="paused">
                        <button type="submit" class="btn btn-secondary btn-sm">⏸ Pause</button>
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/EditCampaign" style="display:inline;">
                        <input type="hidden" name="campaign_id" value="<%= c.getId() %>">
                        <input type="hidden" name="action" value="status">
                        <input type="hidden" name="status" value="closed">
                        <button type="submit" class="btn btn-danger btn-sm">🔒 Close</button>
                    </form>
                    <% } else if ("paused".equals(c.getStatus())) { %>
                    <form method="post" action="<%= request.getContextPath() %>/EditCampaign" style="display:inline;">
                        <input type="hidden" name="campaign_id" value="<%= c.getId() %>">
                        <input type="hidden" name="action" value="status">
                        <input type="hidden" name="status" value="open">
                        <button type="submit" class="btn btn-success btn-sm">▶️ Re-open</button>
                    </form>
                    <% } else if ("closed".equals(c.getStatus())) { %>
                    <span style="color:var(--text-muted);font-size:0.8rem;">Campaign closed</span>
                    <% } %>
                </div>
            </div>
        </div>
        <% } } %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
