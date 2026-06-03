<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.RewardDAO, com.reelkaro.models.Reward, java.math.BigDecimal, java.util.List, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "creator")) return;
    String lang      = SessionUtil.getLang(session);
    int    creatorId = SessionUtil.getUserId(session);
    String userName  = SessionUtil.getUserName(session);

    RewardDAO      rewardDAO = new RewardDAO();
    List<Reward>   rewards   = null;
    BigDecimal     total     = BigDecimal.ZERO;
    String         savedUpi  = request.getParameter("upi_saved");
    String         errorMsg  = (String) request.getAttribute("errorMsg");

    try {
        rewards = rewardDAO.getRewardsByCreator(creatorId);
        total   = rewardDAO.getTotalEarnings(creatorId);
    } catch (SQLException e) { e.printStackTrace(); }

    /* Get current UPI ID from latest reward if available */
    String currentUpi = "";
    if (rewards != null && !rewards.isEmpty() && rewards.get(0).getUpiId() != null) {
        currentUpi = rewards.get(0).getUpiId();
    }
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Earnings — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="nav-link active">Earnings</a></li>
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
            <a href="<%= request.getContextPath() %>/creator/earnings.jsp" class="sidebar-link active"><span class="icon">💰</span> Earnings</a>
            <a href="<%= request.getContextPath() %>/Leaderboard" class="sidebar-link"><span class="icon">🏆</span> Leaderboard</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2>💰 My Earnings</h2>
            <p>Track all your campaign rewards and payout status</p>
        </div>

        <% if ("true".equals(savedUpi)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ UPI ID saved! Payouts will be sent to your UPI.</div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <div class="card mb-6" style="background:linear-gradient(135deg,rgba(255,255,255,0.01),rgba(255,255,255,0.05));border-color:rgba(255,255,255,0.12);">
            <div class="flex justify-between items-center" style="flex-wrap:wrap;gap:var(--sp-4);">
                <div>
                    <p style="font-size:0.85rem;color:var(--text-muted);margin-bottom:var(--sp-2);">TOTAL EARNED</p>
                    <div style="font-size:3rem;font-weight:900;color:#FFFFFF;">
                        ₹<%= String.format("%,.0f", total.doubleValue()) %>
                    </div>
                </div>
                <div>
                    <div class="payout-badge" style="font-size:0.85rem;padding:8px 18px;background:rgba(255,255,255,0.08);color:#FFFFFF;border-color:rgba(255,255,255,0.15);">Payout Coming Soon</div>
                    <p style="font-size:0.75rem;color:var(--text-muted);margin-top:var(--sp-2);">Razorpay integration in progress</p>
                </div>
            </div>
        </div>

        <!-- UPI ID -->
        <div class="card mb-6">
            <h3 style="margin-bottom:var(--sp-4);">📲 Payout UPI ID</h3>
            <p style="font-size:0.85rem;margin-bottom:var(--sp-4);">
                Add your UPI ID so we can process your payout when Razorpay integration goes live.
            </p>
            <form method="post" action="<%= request.getContextPath() %>/Reward" class="flex gap-4" style="flex-wrap:wrap;align-items:flex-end;">
                <input type="hidden" name="action" value="upi">
                <div class="form-group" style="flex:1;min-width:200px;margin-bottom:0;">
                    <label class="form-label" for="upi_id">UPI ID</label>
                    <input type="text" id="upi_id" name="upi_id" class="form-control"
                           placeholder="yourname@upi" value="<%= currentUpi %>">
                </div>
                <button type="submit" class="btn btn-primary" id="saveUpiBtn">💾 Save UPI ID</button>
            </form>
        </div>

        <!-- Rewards Table -->
        <div class="card">
            <h3 style="margin-bottom:var(--sp-5);">📋 Reward Ledger</h3>

            <% if (rewards == null || rewards.isEmpty()) { %>
            <div class="empty-state" style="padding:var(--sp-8);">
                <div class="empty-icon">💸</div>
                <h3>No rewards yet</h3>
                <p>Apply to campaigns and get approved to start earning!</p>
                <a href="<%= request.getContextPath() %>/FilterCampaign" class="btn btn-primary mt-4">Browse Campaigns →</a>
            </div>
            <% } else { %>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Campaign</th>
                            <th>Amount</th>
                            <th>Payout Status</th>
                            <th>UPI ID</th>
                            <th>Awarded On</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        int i = 1;
                        for (Reward r : rewards) {
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong style="color:var(--text-primary);"><%= r.getCampaignTitle() %></strong></td>
                        <td><span style="color:#FFFFFF;font-weight:700;">₹<%= String.format("%,.0f", r.getAmountInr().doubleValue()) %></span></td>
                        <td>
                            <span class="badge badge-<%= r.getPayoutStatus() %>">
                                <%= r.getPayoutStatus().toUpperCase() %>
                            </span>
                            <% if (!"paid".equals(r.getPayoutStatus())) { %>
                            <span class="payout-badge" style="margin-left:4px;font-size:0.65rem;padding:2px 8px;">Coming Soon</span>
                            <% } %>
                        </td>
                        <td><%= r.getUpiId() != null ? r.getUpiId() : "—" %></td>
                        <td><%= r.getAwardedAt().toString().substring(0,10) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
