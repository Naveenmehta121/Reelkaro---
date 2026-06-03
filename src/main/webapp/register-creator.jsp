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
    <title>Register as Creator — ReelKaro</title>
    <meta name="description" content="Join ReelKaro as a content creator and earn money by promoting brands on Instagram, YouTube, Josh and ShareChat.">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<main class="auth-page" style="padding: var(--sp-8) var(--sp-4);">
    <div class="auth-card fade-in" style="max-width:580px;">

        <div class="logo">
            <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand" style="font-size:1.4rem;justify-content:center;">
                <span class="logo-rk">RK</span> ReelKaro
            </a>
        </div>

        <h2>Join as a Creator</h2>
        <p class="subtitle">Start earning by promoting brands you love</p>

        <% if (errorMsg != null) { %>
        <div class="alert alert-error">❌ <%= errorMsg %></div>
        <% } %>

        <form method="post" action="<%= request.getContextPath() %>/RegisterCreator" data-validate id="creatorRegForm">

            <!-- Basic Info -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="name">Full Name *</label>
                    <input type="text" id="name" name="name" class="form-control"
                           placeholder="Your real name" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="username">Creator Username *</label>
                    <input type="text" id="username" name="username" class="form-control"
                           placeholder="@yourcreatorname" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="email">Email Address *</label>
                    <input type="email" id="email" name="email" class="form-control"
                           placeholder="you@gmail.com" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="niche">Content Niche *</label>
                    <select id="niche" name="niche" class="form-control" required>
                        <option value="">Select your niche</option>
                        <option>Lifestyle</option>
                        <option>Fashion & Beauty</option>
                        <option>Food & Cooking</option>
                        <option>Travel</option>
                        <option>Tech & Gadgets</option>
                        <option>Health & Fitness</option>
                        <option>Gaming</option>
                        <option>Comedy & Entertainment</option>
                        <option>Education</option>
                        <option>Finance & Business</option>
                        <option>Music & Dance</option>
                        <option>Spirituality & Yoga</option>
                        <option>Parenting & Family</option>
                        <option>Other</option>
                    </select>
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

            <!-- Social Handles -->
            <div style="margin:var(--sp-5) 0 var(--sp-3);">
                <h4 style="font-size:0.9rem;color:var(--text-muted);margin-bottom:var(--sp-4);">
                    🔗 Social Media Handles
                    <span style="font-size:0.75rem;font-weight:400;"> (add at least one)</span>
                </h4>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="instagram_handle">📸 Instagram</label>
                        <input type="text" id="instagram_handle" name="instagram_handle"
                               class="form-control" placeholder="@instagramhandle">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="youtube_handle">▶️ YouTube</label>
                        <input type="text" id="youtube_handle" name="youtube_handle"
                               class="form-control" placeholder="Channel name or URL">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="josh_handle">🎵 Josh</label>
                        <input type="text" id="josh_handle" name="josh_handle"
                               class="form-control" placeholder="@joshhandle">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="sharechat_handle">💬 ShareChat</label>
                        <input type="text" id="sharechat_handle" name="sharechat_handle"
                               class="form-control" placeholder="@sharechathandle">
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="followers_count">Total Followers</label>
                    <input type="number" id="followers_count" name="followers_count"
                           class="form-control" placeholder="0" min="0">
                    <p class="form-hint">Combined followers across all platforms</p>
                </div>
                <div class="form-group">
                    <label class="form-label" for="city">City</label>
                    <input type="text" id="city" name="city" class="form-control"
                           placeholder="Mumbai, Delhi, Bangalore...">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="state">State</label>
                    <select id="state" name="state" class="form-control">
                        <option value="">Select State</option>
                        <option>Andhra Pradesh</option><option>Arunachal Pradesh</option>
                        <option>Assam</option><option>Bihar</option><option>Chhattisgarh</option>
                        <option>Goa</option><option>Gujarat</option><option>Haryana</option>
                        <option>Himachal Pradesh</option><option>Jharkhand</option>
                        <option>Karnataka</option><option>Kerala</option>
                        <option>Madhya Pradesh</option><option>Maharashtra</option>
                        <option>Manipur</option><option>Meghalaya</option><option>Mizoram</option>
                        <option>Nagaland</option><option>Odisha</option><option>Punjab</option>
                        <option>Rajasthan</option><option>Sikkim</option>
                        <option>Tamil Nadu</option><option>Telangana</option>
                        <option>Tripura</option><option>Uttar Pradesh</option>
                        <option>Uttarakhand</option><option>West Bengal</option>
                        <option>Delhi</option>
                    </select>
                </div>
                <div class="form-group" style="align-self:end;">
                    <!-- Spacer -->
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="bio">Bio</label>
                <textarea id="bio" name="bio" class="form-control"
                          placeholder="Tell brands a bit about yourself and your content style..." rows="3"></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-full btn-lg" id="registerCreatorBtn">
                Create Creator Account →
            </button>
        </form>

        <p class="auth-footer">
            Already have an account? <a href="<%= request.getContextPath() %>/login.jsp">Login →</a>
        </p>
        <p class="auth-footer" style="margin-top:var(--sp-2);">
            Are you a brand? <a href="<%= request.getContextPath() %>/register-brand.jsp">Register as Brand →</a>
        </p>
    </div>
</main>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
