<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.models.Campaign" %>
<%
    if (!SessionUtil.requireRole(request, response, "brand")) return;
    String   lang     = SessionUtil.getLang(session);
    String   userName = SessionUtil.getUserName(session);
    String   errorMsg = (String) request.getAttribute("errorMsg");
    /* If editing an existing campaign, the servlet puts it in "campaign" attribute */
    Campaign edit     = (Campaign) request.getAttribute("campaign");
    boolean  isEdit   = (edit != null);
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Campaign" : "Post Campaign" %> — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand">
            <span class="logo-rk">RK</span> ReelKaro
        </a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/PostCampaign" class="nav-link active">Post Campaign</a></li>
            <li><a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="nav-link">My Campaigns</a></li>
        </ul>
        <div class="navbar-actions">
            <div class="lang-toggle">
                <button class="lang-btn <%= "en".equals(lang) ? "active" : "" %>" data-lang="en">EN</button>
                <button class="lang-btn <%= "hi".equals(lang) ? "active" : "" %>" data-lang="hi">हि</button>
            </div>
            <form id="langForm" method="post" action="<%= request.getContextPath() %>/SetLanguage" style="display:none">
                <input type="hidden" name="lang" value="<%= lang %>">
            </form>
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
            <a href="<%= request.getContextPath() %>/PostCampaign" class="sidebar-link active"><span class="icon">➕</span> Post Campaign</a>
            <a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="sidebar-link"><span class="icon">📋</span> My Campaigns</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2><%= isEdit ? "✏️ Edit Campaign" : "➕ Post New Campaign" %></h2>
            <p>Fill in the details below. All currency amounts are in Indian Rupees (₹).</p>
        </div>

        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <div class="card" style="max-width:720px;">
            <form method="post"
                  action="<%= isEdit ? request.getContextPath()+"/EditCampaign" : request.getContextPath()+"/PostCampaign" %>"
                  data-validate="campaign" id="campaignForm">

                <% if (isEdit) { %>
                <input type="hidden" name="campaign_id" value="<%= edit.getId() %>">
                <% } %>

                <div class="form-group">
                    <label class="form-label" for="title">Campaign Title *</label>
                    <input type="text" id="title" name="title" class="form-control"
                           placeholder="e.g. Promote our new summer collection on Instagram"
                           value="<%= isEdit ? edit.getTitle() : "" %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Campaign Description *</label>
                    <textarea id="description" name="description" class="form-control" rows="5"
                              placeholder="Describe exactly what you want creators to do, what content to create, any dos and don'ts, hashtags to use, etc." required><%= isEdit ? edit.getDescription() : "" %></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="platform">Platform *</label>
                        <select id="platform" name="platform" class="form-control" required>
                            <option value="">Select Platform</option>
                            <%
                                String[] platforms = {"Instagram","YouTube","Josh","ShareChat","Moj"};
                                for (String p : platforms) {
                                    String sel = isEdit && p.equals(edit.getPlatform()) ? "selected" : "";
                            %>
                            <option value="<%= p %>" <%= sel %>><%= p %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="category">Category</label>
                        <select id="category" name="category" class="form-control">
                            <option value="">Select Category</option>
                            <%
                                String[] cats = {"Fashion & Lifestyle","Food & Beverages","Beauty & Skincare",
                                    "Health & Fitness","Tech & Gadgets","Travel & Tourism",
                                    "Gaming & Esports","Home & Decor","Fintech & Finance",
                                    "Education & EdTech","Music & Entertainment","Other"};
                                for (String cat : cats) {
                                    String sel = isEdit && cat.equals(edit.getCategory()) ? "selected" : "";
                            %>
                            <option value="<%= cat %>" <%= sel %>><%= cat %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="budget_inr">Total Budget (₹) *</label>
                        <input type="number" id="budget_inr" name="budget_inr" class="form-control"
                               placeholder="e.g. 50000" min="1" step="1"
                               value="<%= isEdit ? edit.getBudgetInr().toPlainString() : "" %>" required>
                        <p class="form-hint">Your maximum spend for this campaign</p>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="reward_per_creator_inr">Reward per Creator (₹) *</label>
                        <input type="number" id="reward_per_creator_inr" name="reward_per_creator_inr"
                               class="form-control" placeholder="e.g. 500" min="1" step="1"
                               value="<%= isEdit ? edit.getRewardPerCreatorInr().toPlainString() : "" %>" required>
                        <p class="form-hint">Amount paid to each creator on approval</p>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="max_creators">Max Creators *</label>
                        <input type="number" id="max_creators" name="max_creators" class="form-control"
                               placeholder="e.g. 20" min="1"
                               value="<%= isEdit ? edit.getMaxCreators() : "10" %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="deadline">Application Deadline *</label>
                        <input type="date" id="deadline" name="deadline" class="form-control"
                               value="<%= isEdit ? edit.getDeadline().toString() : "" %>" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg" id="submitCampaignBtn">
                    <%= isEdit ? "💾 Save Changes" : "🚀 Post Campaign" %>
                </button>
                <a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp"
                   class="btn btn-secondary" style="margin-left:var(--sp-3);">Cancel</a>
            </form>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
