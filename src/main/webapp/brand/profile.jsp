<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil, com.reelkaro.dao.UserDAO, java.sql.SQLException" %>
<%
    if (!SessionUtil.requireRole(request, response, "brand")) return;
    String lang    = SessionUtil.getLang(session);
    int    userId  = SessionUtil.getUserId(session);
    String userName= SessionUtil.getUserName(session);

    UserDAO userDAO = new UserDAO();
    String[] profile = null;
    try { profile = userDAO.getBrandProfile(userId); } catch (SQLException e) { e.printStackTrace(); }

    String errorMsg = (String) request.getAttribute("errorMsg");
    String saved    = request.getParameter("saved");

    // profile array: [0]=company_name [1]=industry [2]=website [3]=gst_number [4]=verified
    String companyName = (profile != null && profile[0] != null) ? profile[0] : "";
    String industry    = (profile != null && profile[1] != null) ? profile[1] : "";
    String website     = (profile != null && profile[2] != null) ? profile[2] : "";
    String gstNumber   = (profile != null && profile[3] != null) ? profile[3] : "";
    String verified    = (profile != null && profile[4] != null) ? profile[4] : "false";
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Brand Profile — ReelKaro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand"><span class="logo-rk">RK</span> ReelKaro</a>
        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="nav-link">My Campaigns</a></li>
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
            <div class="role-badge">Brand Portal</div>
            <div class="user-name">👋 <%= userName %></div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="sidebar-link"><span class="icon">📊</span> Dashboard</a>
            <a href="<%= request.getContextPath() %>/PostCampaign" class="sidebar-link"><span class="icon">➕</span> Post Campaign</a>
            <a href="<%= request.getContextPath() %>/brand/my-campaigns.jsp" class="sidebar-link"><span class="icon">📋</span> My Campaigns</a>
            <a href="<%= request.getContextPath() %>/Profile" class="sidebar-link active"><span class="icon">👤</span> Profile</a>
            <a href="<%= request.getContextPath() %>/Logout" class="sidebar-link" style="margin-top:var(--sp-6);color:var(--danger)!important;"><span class="icon">🚪</span> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2>👤 Brand Profile</h2>
            <p>Update your company information and settings</p>
        </div>

        <% if ("true".equals(saved)) { %>
        <div class="alert alert-success" data-auto-dismiss="4000">✅ Profile saved successfully!</div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <div class="card" style="max-width:640px;">
            <!-- Verification badge -->
            <div class="flex items-center gap-3 mb-6" style="padding-bottom:var(--sp-5);border-bottom:1px solid var(--navy-border);">
                <div style="width:64px;height:64px;background:linear-gradient(135deg,#FFFFFF,#E8E8E8);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:1.8rem;color:#000000;box-shadow:0 4px 12px rgba(255,255,255,0.15);">🏢</div>
                <div>
                    <h3><%= companyName.isEmpty() ? userName : companyName %></h3>
                    <div style="margin-top:4px;">
                        <% if ("true".equals(verified)) { %>
                        <span class="badge badge-approved">✓ Verified Brand</span>
                        <% } else { %>
                        <span class="badge badge-pending">Verification Pending</span>
                        <% } %>
                    </div>
                </div>
            </div>

            <form method="post" action="<%= request.getContextPath() %>/Profile">
                <div class="form-group">
                    <label class="form-label" for="company_name">Company Name *</label>
                    <input type="text" id="company_name" name="company_name" class="form-control"
                           value="<%= companyName %>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="industry">Industry</label>
                        <select id="industry" name="industry" class="form-control">
                            <option value="">Select Industry</option>
                            <%
                                String[] industries = {"FMCG","Fashion & Apparel","Beauty & Skincare",
                                    "Food & Beverages","Technology","Fintech","Health & Wellness",
                                    "Education & EdTech","Travel & Tourism","Entertainment",
                                    "Real Estate","Automobile","Other"};
                                for (String ind : industries) {
                                    String sel = ind.equals(industry) ? "selected" : "";
                            %>
                            <option value="<%= ind %>" <%= sel %>><%= ind %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="website">Website</label>
                        <input type="url" id="website" name="website" class="form-control"
                               value="<%= website %>" placeholder="https://yourbrand.in">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="gst_number">GST Number</label>
                    <input type="text" id="gst_number" name="gst_number" class="form-control"
                           value="<%= gstNumber %>" placeholder="22AAAAA0000A1Z5">
                    <p class="form-hint">Required for generating invoices and tax compliance.</p>
                </div>

                <button type="submit" class="btn btn-primary" id="saveProfileBtn">
                    💾 Save Profile
                </button>
            </form>
        </div>
    </main>
</div>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
