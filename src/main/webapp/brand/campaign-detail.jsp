<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.*, com.reelkaro.models.*, java.util.List, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "brand")) return;
    String lang    = SessionUtil.getLang(session);
    int    brandId = SessionUtil.getUserId(session);
    String userName= SessionUtil.getUserName(session);

    int campaignId = 0;
    try { campaignId = Integer.parseInt(request.getParameter("id")); } catch (Exception ignore) {}

    CampaignDAO    campaignDAO    = new CampaignDAO();
    ApplicationDAO applicationDAO = new ApplicationDAO();

    Campaign          campaign    = null;
    List<Application> applications= null;
    List<Submission>  submissions  = null;

    try {
        campaign     = campaignDAO.getCampaignById(campaignId);
        /* Security: confirm campaign belongs to this brand */
        if (campaign == null || campaign.getBrandId() != brandId) {
            response.sendRedirect(request.getContextPath() + "/brand/my-campaigns.jsp");
            return;
        }
        applications = applicationDAO.getApplicationsByCampaign(campaignId);
        submissions  = applicationDAO.getSubmissionsByCampaign(campaignId);
    } catch (SQLException e) { e.printStackTrace(); }

    String reviewed = request.getParameter("reviewed");
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaign Detail — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="nav-link">My Campaigns</a></li>
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
        <% if ("true".equals(reviewed)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ Submission reviewed successfully!</div>
        <% } %>

        <% if (campaign != null) { %>
        <!-- Campaign header -->
        <div class="card mb-6">
            <div class="card-header">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <span class="badge badge-<%= campaign.getStatus() %>"><%= campaign.getStatus().toUpperCase() %></span>
                        <span class="category-tag"><%= campaign.getCategory() != null ? campaign.getCategory() : "General" %></span>
                    </div>
                    <h2><%= campaign.getTitle() %></h2>
                    <p style="margin-top:var(--sp-3);"><%= campaign.getDescription() %></p>
                </div>
                <div class="reward-badge" style="flex-shrink:0;white-space:nowrap;">₹<%= campaign.getRewardPerCreatorInr().toPlainString() %>/creator</div>
            </div>
            <div class="meta-row">
                <span>📱 <%= campaign.getPlatform() %></span>
                <span>📅 Deadline: <%= campaign.getDeadline() %></span>
                <span>👥 <%= campaign.getApplyCount() %>/<%= campaign.getMaxCreators() %> creators</span>
                <span>💰 Budget: ₹<%= String.format("%,.0f", campaign.getBudgetInr().doubleValue()) %></span>
            </div>
        </div>

        <!-- APPLICANTS TABLE -->
        <div class="card mb-6">
            <h3 style="margin-bottom:var(--sp-5);">👥 Applicants (<%= applications != null ? applications.size() : 0 %>)</h3>
            <% if (applications == null || applications.isEmpty()) { %>
            <div class="empty-state" style="padding:var(--sp-8);">
                <div class="empty-icon">📭</div>
                <p>No applications yet.</p>
            </div>
            <% } else { %>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Creator</th>
                            <th>Username</th>
                            <th>Applied On</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (Application app : applications) { %>
                    <tr>
                        <td><strong style="color:var(--text-primary)"><%= app.getCreatorName() %></strong></td>
                        <td><span>@<%= app.getCreatorUsername() != null ? app.getCreatorUsername() : "-" %></span></td>
                        <td><%= app.getAppliedAt().toString().substring(0,10) %></td>
                        <td><span class="badge badge-<%= app.getStatus() %>"><%= app.getStatus().toUpperCase() %></span></td>
                        <td>
                            <% if ("pending".equals(app.getStatus())) { %>
                            <div class="flex gap-2" style="flex-wrap:wrap;">
                                <form method="post" action="<%= request.getContextPath() %>/ApproveApplicationDirect" style="display:inline;">
                                    <input type="hidden" name="campaign_id"   value="<%= campaign.getId() %>">
                                    <input type="hidden" name="application_id" value="<%= app.getId() %>">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-success btn-sm">✓ Approve</button>
                                </form>
                                <form method="post" action="<%= request.getContextPath() %>/ApproveApplicationDirect" style="display:inline;">
                                    <input type="hidden" name="campaign_id"   value="<%= campaign.getId() %>">
                                    <input type="hidden" name="application_id" value="<%= app.getId() %>">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-danger btn-sm">✗ Reject</button>
                                </form>
                            </div>
                            <% } else { %>
                            <span style="color:var(--text-muted);font-size:0.8rem;"><%= app.getStatus() %></span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>

        <!-- SUBMISSIONS TABLE -->
        <div class="card">
            <h3 style="margin-bottom:var(--sp-5);">📤 Submitted Content (<%= submissions != null ? submissions.size() : 0 %>)</h3>
            <% if (submissions == null || submissions.isEmpty()) { %>
            <div class="empty-state" style="padding:var(--sp-8);">
                <div class="empty-icon">📭</div>
                <p>No content submitted yet. Approve some applicants first.</p>
            </div>
            <% } else { %>
            <% for (Submission sub : submissions) { %>
            <div class="card mb-4" style="border-color:var(--navy-border);">
                <div class="flex justify-between items-center" style="flex-wrap:wrap;gap:var(--sp-3);">
                    <div>
                        <strong style="color:var(--text-primary)"><%= sub.getCreatorName() %></strong>
                        <span class="badge badge-<%= sub.getApprovalStatus() %>" style="margin-left:var(--sp-2);">
                            <%= sub.getApprovalStatus().toUpperCase() %>
                        </span>
                        <p style="margin-top:var(--sp-2);font-size:0.85rem;">
                            📎 <a href="<%= sub.getContentLink() %>" target="_blank" style="color:#FFFFFF;text-decoration:underline;">View Content</a>
                            &nbsp;•&nbsp; Posted on: <strong><%= sub.getPlatformPosted() %></strong>
                            &nbsp;•&nbsp; <%= sub.getSubmittedAt().toString().substring(0,10) %>
                        </p>
                        <% if (sub.getFeedback() != null && !sub.getFeedback().isEmpty()) { %>
                        <p style="font-size:0.82rem;color:var(--text-muted);margin-top:var(--sp-2);">
                            💬 Feedback: <%= sub.getFeedback() %>
                        </p>
                        <% } %>
                    </div>

                    <% if ("pending".equals(sub.getApprovalStatus())) { %>
                    <form method="post" action="<%= request.getContextPath() %>/ApproveReject">
                        <input type="hidden" name="submission_id" value="<%= sub.getId() %>">
                        <input type="hidden" name="campaign_id"   value="<%= campaign.getId() %>">
                        <div class="flex gap-3 items-center" style="flex-wrap:wrap;">
                            <input type="text" name="feedback" class="form-control"
                                   placeholder="Optional feedback..." style="max-width:200px;font-size:0.82rem;">
                            <button type="submit" name="action" value="approve" class="btn btn-success btn-sm">✅ Approve</button>
                            <button type="submit" name="action" value="reject"  class="btn btn-danger btn-sm">❌ Reject</button>
                        </div>
                    </form>
                    <% } %>
                </div>
            </div>
            <% } %>
            <% } %>
        </div>
        <% } %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
