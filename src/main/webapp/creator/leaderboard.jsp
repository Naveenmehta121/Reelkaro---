<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, java.util.List" %>
<%
    String lang      = SessionUtil.getLang(session);
    String userName  = SessionUtil.getUserName(session);
    boolean loggedIn = SessionUtil.isLoggedIn(session);
    String userRole  = SessionUtil.getUserRole(session);

    /* Leaderboard data set by LeaderboardServlet */
    List<Object[]> leaderboard = (List<Object[]>) request.getAttribute("leaderboard");
    String errorMsg = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creator Leaderboard — ReelKaro</title>
    <meta name="description" content="Top earning creators on ReelKaro — India's creator-brand marketplace.">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <button class="navbar-toggle" id="navbarToggle">☰</button>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/index.jsp" class="nav-link">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/Leaderboard" class="nav-link active">Leaderboard</a></li>
            <% if (loggedIn && "creator".equals(userRole)) { %>
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/FilterCampaign" class="nav-link">Browse</a></li>
            <% } else if (loggedIn && "brand".equals(userRole)) { %>
            <li><a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <% } %>
        </ul>
        <div class="navbar-actions">
            <div class="lang-toggle">
                <button class="lang-btn <%= "en".equals(lang) ? "active" : "" %>" data-lang="en">EN</button>
                <button class="lang-btn <%= "hi".equals(lang) ? "active" : "" %>" data-lang="hi">हि</button>
            </div>
            <form id="langForm" method="post" action="<%= request.getContextPath() %>/SetLanguage" style="display:none"><input type="hidden" name="lang" value="<%= lang %>"></form>
            <% if (loggedIn) { %>
            <a href="<%= request.getContextPath() %>/Logout" class="btn btn-secondary btn-sm">Logout</a>
            <% } else { %>
            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-secondary btn-sm">Login</a>
            <% } %>
        </div>
    </div>
</nav>

<section class="section">
    <div class="container">
        <div class="section-head">
            <span class="eyebrow">🏆 Hall of Fame</span>
            <h1 class="text-gradient" data-i18n="leaderboard.title">Top Creator Leaderboard</h1>
            <p>India's highest-earning creators on ReelKaro. Updated in real-time.</p>
        </div>

        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <% if (leaderboard == null || leaderboard.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">🏆</div>
            <h3>The leaderboard is being built!</h3>
            <p>Be the first creator to earn on ReelKaro and claim the top spot.</p>
            <a href="<%= request.getContextPath() %>/register-creator.jsp" class="btn btn-primary mt-4">Join as Creator →</a>
        </div>
        <% } else { %>

        <!-- Top 3 podium -->
        <div class="flex justify-center gap-6 mb-8" style="flex-wrap:wrap;align-items:flex-end;margin-bottom:var(--sp-8);">
            <%
                int[] podiumOrder = {1, 0, 2}; // 2nd, 1st, 3rd for visual podium
                int[] podiumHeights = {80, 100, 60};
                for (int pi = 0; pi < Math.min(3, leaderboard.size()); pi++) {
                    int dataIdx = podiumOrder[pi];
                    if (dataIdx >= leaderboard.size()) continue;
                    Object[] row = leaderboard.get(dataIdx);
                    int rank = (int) row[0];
                    String cName = (String) row[1];
                    String cUsername = (String) row[2];
                    String cCity = (String) row[3];
                    String cNiche = (String) row[5];
                    java.math.BigDecimal earned = (java.math.BigDecimal) row[6];
                    String medal = rank == 1 ? "🥇" : rank == 2 ? "🥈" : "🥉";
                    String rankClass = "rank-" + rank;
            %>
            <div class="text-center" style="flex:1;min-width:150px;max-width:200px;">
                <div class="rank-badge <%= rankClass %>" style="width:52px;height:52px;margin:0 auto var(--sp-3);">
                    <%= medal %>
                </div>
                <div style="font-size:1.2rem;font-weight:800;color:var(--text-primary);">
                    <%= cName != null ? cName : cUsername %>
                </div>
                <div style="color:#FFFFFF;font-size:0.85rem;">@<%= cUsername %></div>
                <div style="color:var(--text-muted);font-size:0.78rem;"><%= cCity %> · <%= cNiche %></div>
                <div style="font-size:1.4rem;font-weight:900;color:#FFFFFF;margin-top:var(--sp-2);">
                    ₹<%= String.format("%,.0f", earned.doubleValue()) %>
                </div>
                <div style="height:<%= podiumHeights[pi] %>px;background:linear-gradient(180deg,rgba(255,255,255,0.12),transparent);border-radius:var(--r-sm) var(--r-sm) 0 0;margin-top:var(--sp-3);"></div>
            </div>
            <% } %>
        </div>

        <!-- Full Leaderboard -->
        <div style="display:flex;flex-direction:column;gap:var(--sp-3);">
            <% for (int i = 0; i < leaderboard.size(); i++) {
                Object[] row = leaderboard.get(i);
                int rank = (int) row[0];
                String cName    = (String) row[1];
                String cUsername= (String) row[2];
                String cCity    = (String) row[3];
                String cState   = (String) row[4];
                String cNiche   = (String) row[5];
                java.math.BigDecimal earned = (java.math.BigDecimal) row[6];
                int approved = (int) row[7];
                String rankClass = rank <= 3 ? "rank-" + rank : "rank-other";
                String rowClass  = rank <= 3 ? "leaderboard-row top-3" : "leaderboard-row";
            %>
            <div class="<%= rowClass %>">
                <div class="rank-badge <%= rankClass %>"><%= rank %></div>
                <div style="flex:1;min-width:0;">
                    <div style="font-weight:700;color:var(--text-primary);">
                        <%= cName != null ? cName : "Creator" %>
                        <span style="color:#FFFFFF;font-weight:500;"> @<%= cUsername %></span>
                    </div>
                    <div style="font-size:0.78rem;color:var(--text-muted);margin-top:2px;">
                        <%= cCity %>, <%= cState %> · <%= cNiche %>
                    </div>
                </div>
                <div style="text-align:right;flex-shrink:0;">
                    <div style="font-size:1.1rem;font-weight:800;color:#FFFFFF;">
                        ₹<%= String.format("%,.0f", earned.doubleValue()) %>
                    </div>
                    <div style="font-size:0.75rem;color:var(--text-muted);">
                        <%= approved %> approved posts
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <% } %>

        <!-- Join CTA -->
        <div class="card text-center mt-8" style="background:linear-gradient(135deg,rgba(255,255,255,0.01),rgba(255,255,255,0.04));">
            <h3 style="margin-bottom:var(--sp-3);">🚀 Want to make it to the top?</h3>
            <p style="margin-bottom:var(--sp-5);">Apply to campaigns, create great content, and climb the ReelKaro rankings!</p>
            <% if (!loggedIn || "brand".equals(userRole)) { %>
            <a href="<%= request.getContextPath() %>/register-creator.jsp" class="btn btn-primary">Join as Creator →</a>
            <% } else { %>
            <a href="<%= request.getContextPath() %>/FilterCampaign" class="btn btn-primary">Browse Campaigns →</a>
            <% } %>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-bottom">
            <p>© 2024 ReelKaro. Made with ❤️ in India 🇮🇳</p>
            <div class="flex gap-4">
                <a href="<%= request.getContextPath() %>/index.jsp" style="color:var(--text-muted);font-size:0.85rem;">Home</a>
                <a href="<%= request.getContextPath() %>/login.jsp" style="color:var(--text-muted);font-size:0.85rem;">Login</a>
            </div>
        </div>
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
