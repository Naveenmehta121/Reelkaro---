<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.UserDAO, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "creator")) return;
    String lang     = SessionUtil.getLang(session);
    int    userId   = SessionUtil.getUserId(session);
    String userName = SessionUtil.getUserName(session);

    UserDAO userDAO = new UserDAO();
    String[] profile = null;
    try { profile = userDAO.getCreatorProfile(userId); } catch (SQLException e) { e.printStackTrace(); }

    String errorMsg = (String) request.getAttribute("errorMsg");
    String saved    = request.getParameter("saved");

    // profile: [0]=username [1]=niche [2]=instagram [3]=youtube [4]=josh [5]=sharechat
    //          [6]=followers_count [7]=city [8]=state [9]=bio
    String username     = (profile != null && profile[0] != null) ? profile[0] : "";
    String niche        = (profile != null && profile[1] != null) ? profile[1] : "";
    String instagram    = (profile != null && profile[2] != null) ? profile[2] : "";
    String youtube      = (profile != null && profile[3] != null) ? profile[3] : "";
    String josh         = (profile != null && profile[4] != null) ? profile[4] : "";
    String sharechat    = (profile != null && profile[5] != null) ? profile[5] : "";
    String followersStr = (profile != null && profile[6] != null) ? profile[6] : "0";
    String city         = (profile != null && profile[7] != null) ? profile[7] : "";
    String state        = (profile != null && profile[8] != null) ? profile[8] : "";
    String bio          = (profile != null && profile[9] != null) ? profile[9] : "";
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creator Profile — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/FilterCampaign" class="nav-link">Browse</a></li>
            <li><a href="<%= request.getContextPath() %>/Profile" class="nav-link active">Profile</a></li>
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
            <a href="<%= request.getContextPath() %>/creator/my-applications.jsp" class="sidebar-link"><span class="icon">📨</span> Applications</a>
            <a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="sidebar-link"><span class="icon">💰</span> Earnings</a>
            <a href="<%= request.getContextPath() %>/Leaderboard" class="sidebar-link"><span class="icon">🏆</span> Leaderboard</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link active"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2>👤 Creator Profile</h2>
            <p>Keep your profile complete to get noticed by brands</p>
        </div>

        <% if ("true".equals(saved)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ Profile saved successfully!</div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <div class="card" style="max-width:680px;">
            <!-- Avatar section -->
            <div class="flex items-center gap-4 mb-6" style="padding-bottom:var(--sp-5);border-bottom:1px solid var(--navy-border);">
                <div style="width:72px;height:72px;background:linear-gradient(135deg,#FFFFFF,#E8E8E8);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:2rem;flex-shrink:0;color:#000000;box-shadow:0 4px 12px rgba(255,255,255,0.15);">🎬</div>
                <div>
                    <h3><%= userName %></h3>
                    <div style="color:#FFFFFF;margin-top:2px;">@<%= username.isEmpty() ? "your_handle" : username %></div>
                    <div style="color:var(--text-muted);font-size:0.8rem;margin-top:2px;">
                        <%= niche.isEmpty() ? "Content Creator" : niche %>
                        <% if (!city.isEmpty()) { %> · <%= city %><% } %>
                    </div>
                </div>
            </div>

            <form method="post" action="<%= request.getContextPath() %>/Profile">

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="username">Creator Username *</label>
                        <input type="text" id="username" name="username" class="form-control"
                               value="<%= username %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="niche">Content Niche</label>
                        <select id="niche" name="niche" class="form-control">
                            <option value="">Select Niche</option>
                            <%
                                String[] niches = {"Lifestyle","Fashion & Beauty","Food & Cooking","Travel",
                                    "Tech & Gadgets","Health & Fitness","Gaming","Comedy & Entertainment",
                                    "Education","Finance & Business","Music & Dance","Spirituality & Yoga","Parenting & Family","Other"};
                                for (String n : niches) {
                                    String sel = n.equals(niche) ? "selected" : "";
                            %>
                            <option value="<%= n %>" <%= sel %>><%= n %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <!-- Social Handles -->
                <h4 style="font-size:0.9rem;color:var(--text-muted);margin:var(--sp-5) 0 var(--sp-4);">🔗 Social Media Handles</h4>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="instagram_handle">📸 Instagram</label>
                        <input type="text" id="instagram_handle" name="instagram_handle"
                               class="form-control" value="<%= instagram %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="youtube_handle">▶️ YouTube</label>
                        <input type="text" id="youtube_handle" name="youtube_handle"
                               class="form-control" value="<%= youtube %>">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="josh_handle">🎵 Josh</label>
                        <input type="text" id="josh_handle" name="josh_handle"
                               class="form-control" value="<%= josh %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="sharechat_handle">💬 ShareChat</label>
                        <input type="text" id="sharechat_handle" name="sharechat_handle"
                               class="form-control" value="<%= sharechat %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="followers_count">Total Followers</label>
                        <input type="number" id="followers_count" name="followers_count"
                               class="form-control" value="<%= followersStr %>" min="0">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="city">City</label>
                        <input type="text" id="city" name="city" class="form-control" value="<%= city %>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="state">State</label>
                    <select id="state" name="state" class="form-control">
                        <option value="">Select State</option>
                        <%
                            String[] states = {"Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh",
                                "Goa","Gujarat","Haryana","Himachal Pradesh","Jharkhand","Karnataka","Kerala",
                                "Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland",
                                "Odisha","Punjab","Rajasthan","Sikkim","Tamil Nadu","Telangana","Tripura",
                                "Uttar Pradesh","Uttarakhand","West Bengal","Delhi"};
                            for (String s : states) {
                                String sel = s.equals(state) ? "selected" : "";
                        %>
                        <option value="<%= s %>" <%= sel %>><%= s %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="bio">Bio</label>
                    <textarea id="bio" name="bio" class="form-control" rows="4"
                              placeholder="Tell brands about your content style, audience, and what makes you unique..."><%= bio %></textarea>
                </div>

                <button type="submit" class="btn btn-primary" id="saveCreatorProfileBtn">
                    💾 Save Profile
                </button>
            </form>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
