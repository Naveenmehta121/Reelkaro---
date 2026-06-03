<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil" %>
<%
    String lang     = SessionUtil.getLang(session);
    String errorMsg = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register as Brand — ReelKaro</title>
    <meta name="description" content="Create a brand account on ReelKaro and start posting campaigns to India's top creators.">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<main class="auth-page" style="padding: var(--sp-8) var(--sp-4);">
    <div class="auth-card fade-in" style="max-width:560px;">

        <div class="logo">
            <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand" style="font-size:1.4rem;justify-content:center;">
                <span class="logo-rk">RK</span> ReelKaro
            </a>
        </div>

        <h2>Register as a Brand</h2>
        <p class="subtitle">Start reaching India's top creators today</p>

        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <form method="post" action="<%= request.getContextPath() %>/RegisterBrand" data-validate id="brandRegForm">

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="name">Full Name *</label>
                    <input type="text" id="name" name="name" class="form-control"
                           placeholder="Your name" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="email">Email Address *</label>
                    <input type="email" id="email" name="email" class="form-control"
                           placeholder="brand@company.com" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="password">Password *</label>
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="Min 6 characters" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="confirm_password">Confirm Password *</label>
                    <input type="password" id="confirm_password" name="confirm_password"
                           class="form-control" placeholder="Repeat password" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="company_name">Company Name *</label>
                <input type="text" id="company_name" name="company_name" class="form-control"
                       placeholder="Acme Pvt. Ltd." required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="industry">Industry</label>
                    <select id="industry" name="industry" class="form-control">
                        <option value="">Select Industry</option>
                        <option>FMCG</option>
                        <option>Fashion & Apparel</option>
                        <option>Beauty & Skincare</option>
                        <option>Food & Beverages</option>
                        <option>Technology</option>
                        <option>Fintech</option>
                        <option>Health & Wellness</option>
                        <option>Education & EdTech</option>
                        <option>Travel & Tourism</option>
                        <option>Entertainment</option>
                        <option>Real Estate</option>
                        <option>Automobile</option>
                        <option>Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="website">Website (optional)</label>
                    <input type="url" id="website" name="website" class="form-control"
                           placeholder="https://yourbrand.in">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="gst_number">GST Number (optional)</label>
                <input type="text" id="gst_number" name="gst_number" class="form-control"
                       placeholder="22AAAAA0000A1Z5">
                <p class="form-hint">Required for invoicing. You can add this later in your profile.</p>
            </div>

            <button type="submit" class="btn btn-primary btn-full btn-lg" id="registerBrandBtn">
                Create Brand Account →
            </button>
        </form>

        <p class="auth-footer">
            Already have an account? <a href="<%= request.getContextPath() %>/login.jsp">Login →</a>
        </p>
        <p class="auth-footer" style="margin-top:var(--sp-2);">
            Are you a creator? <a href="<%= request.getContextPath() %>/register-creator.jsp">Register as Creator →</a>
        </p>
    </div>
</main>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
