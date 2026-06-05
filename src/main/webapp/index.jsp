<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.reelkaro.utils.SessionUtil" %>
<%
    /* Determine current language from session */
    String lang = SessionUtil.getLang(session);
    String userRole = (String) session.getAttribute("userRole");
    String userName = (String) session.getAttribute("userName");
    boolean loggedIn = SessionUtil.isLoggedIn(session);
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReelKaro — India's First Creator-Brand Campaign Marketplace</title>
    <meta name="description" content="ReelKaro connects Indian brands with creators on Instagram, YouTube, Josh, ShareChat and Moj. Post campaigns, apply, earn in INR.">
    <meta name="keywords" content="influencer marketing India, brand campaigns, creator monetization, Instagram campaigns India">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        /* ── Category Cards ── */
        .cat-card {
            position: relative;
            padding: var(--sp-5) var(--sp-4);
            border-radius: var(--r-xl);
            background: rgba(255,255,255,0.03);
            border: 1px solid transparent;
            background-clip: padding-box;
            text-align: center;
            cursor: default;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        /* Rotating conic gradient border */
        .cat-card::before {
            content: '';
            position: absolute;
            inset: -2px;
            border-radius: inherit;
            background: conic-gradient(
                from var(--_a, 0deg),
                transparent 40%,
                rgba(255,255,255,0.55) 50%,
                transparent 60%
            );
            animation: borderSpin 3.5s linear infinite;
            z-index: 0;
            opacity: 0;
            transition: opacity 0.4s ease;
        }
        /* Inner fill to mask the conic BG */
        .cat-card::after {
            content: '';
            position: absolute;
            inset: 1px;
            border-radius: calc(var(--r-xl) - 1px);
            background: var(--bg-surface, #1A1A1A);
            z-index: 1;
        }
        .cat-card:hover::before {
            opacity: 1;
        }
        .cat-card:hover {
            transform: translateY(-6px) scale(1.04);
            box-shadow:
                0 0 18px rgba(255,255,255,0.08),
                0 12px 32px rgba(0,0,0,0.4);
        }
        .cat-card-inner {
            position: relative;
            z-index: 2;
        }
        .cat-card-dot {
            display: inline-block;
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(255,255,255,0.7), rgba(255,255,255,0.25));
            margin-bottom: var(--sp-3);
            box-shadow: 0 0 8px rgba(255,255,255,0.3);
        }
        .cat-card-label {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-secondary);
            letter-spacing: 0.01em;
            line-height: 1.35;
            transition: color 0.3s ease;
        }
        .cat-card:hover .cat-card-label {
            color: var(--text-primary);
        }
        @keyframes borderSpin {
            to { --_a: 360deg; }
        }
        @property --_a {
            syntax: '<angle>';
            inherits: false;
            initial-value: 0deg;
        }
        /* ── Hero Grid ── */
        .hero-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: var(--sp-12);
            align-items: center;
        }
        .hero-visual {
            display: flex;
            flex-direction: column;
            gap: var(--sp-4);
            position: relative;
        }
        /* Gradient glows for visual cards */
        .showcase-card {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border);
            backdrop-filter: blur(16px);
            border-radius: var(--r-xl);
            padding: var(--sp-5);
            box-shadow: var(--shadow-md);
            transition: var(--t-normal);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            gap: var(--sp-2);
        }
        .showcase-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
        }
        .showcase-card:hover {
            transform: translateY(-4px) scale(1.02);
            border-color: rgba(255, 255, 255, 0.2);
            box-shadow: 0 12px 32px rgba(255, 255, 255, 0.1);
        }
        .showcase-progress {
            height: 6px;
            background: rgba(255,255,255,0.06);
            border-radius: var(--r-full);
            overflow: hidden;
            margin-top: var(--sp-2);
        }
        .showcase-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #FFFFFF, #E8E8E8);
            border-radius: var(--r-full);
        }
        /* Trust logos styling */
        .trust-logos {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: var(--sp-12);
            flex-wrap: wrap;
            opacity: 0.65;
            margin-top: var(--sp-5);
        }
        .trust-logo {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-secondary);
            letter-spacing: -0.02em;
            transition: var(--t-fast);
        }
        .trust-logo:hover {
            opacity: 1;
            color: var(--text-primary);
        }
        @media (max-width: 992px) {
            .hero-grid {
                grid-template-columns: 1fr;
                text-align: center;
            }
            .hero-content {
                margin: 0 auto;
                max-width: 100%;
            }
            .hero-buttons {
                justify-content: center;
            }
            .hero-stats {
                justify-content: center;
            }
            .hero-visual {
                display: none;
            }
        }
    </style>
</head>
<body>

<!-- ======================================================
     NAVBAR
     ====================================================== -->
<nav class="navbar">
    <div class="container">
        <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand">
            <span class="logo-rk">RK</span> ReelKaro
        </a>

        <button class="navbar-toggle" id="navbarToggle" aria-label="Toggle menu">☰</button>

        <ul class="navbar-nav" id="navbarNav">
            <li><a href="<%= request.getContextPath() %>/index.jsp" class="nav-link active" data-i18n="nav.home">Home</a></li>
            <% if (loggedIn && "creator".equals(userRole)) { %>
                <li><a href="<%= request.getContextPath() %>/FilterCampaign" class="nav-link" data-i18n="nav.browse">Browse Campaigns</a></li>
                <li><a href="<%= request.getContextPath() %>/creator/dashboard.jsp" class="nav-link" data-i18n="nav.dashboard">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/Leaderboard" class="nav-link" data-i18n="nav.leaderboard">Leaderboard</a></li>
            <% } else if (loggedIn && "brand".equals(userRole)) { %>
                <li><a href="<%= request.getContextPath() %>/brand/dashboard.jsp" class="nav-link" data-i18n="nav.dashboard">Dashboard</a></li>
            <% } %>
        </ul>

        <div class="navbar-actions">
            <!-- Language Toggle -->
            <div class="lang-toggle">
                <button class="lang-btn <%= "en".equals(lang) ? "active" : "" %>" data-lang="en">EN</button>
                <button class="lang-btn <%= "hi".equals(lang) ? "active" : "" %>" data-lang="hi">हि</button>
            </div>
            <!-- Hidden form to POST language to server -->
            <form id="langForm" method="post" action="<%= request.getContextPath() %>/SetLanguage" style="display:none">
                <input type="hidden" name="lang" value="<%= lang %>">
            </form>

            <% if (loggedIn) { %>
                <span style="color:var(--text-secondary);font-size:0.85rem;font-weight:500;">👋 <%= userName %></span>
                <a href="<%= request.getContextPath() %>/Logout" class="btn btn-secondary btn-sm" data-i18n="nav.logout">Logout</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-secondary btn-sm" data-i18n="nav.login">Login</a>
                <a href="<%= request.getContextPath() %>/register-brand.jsp" class="btn btn-primary btn-sm" data-i18n="nav.register">Register</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- ======================================================
     HERO SECTION
     ====================================================== -->
<section class="hero">
    <div class="container">
        <div class="hero-grid">
            <div class="hero-content fade-in">
                <div class="animated-gradient-text hero-eyebrow" data-colors="['#FF0055', '#7A00FF', '#00E5FF']" data-speed="5" data-border="true" data-i18n="hero.eyebrow">
                    🇮🇳 India's #1 Creator Marketplace
                </div>

                <h1>
                    <span data-i18n="hero.title.part1">Where Brands Meet</span><br>
                    <span class="animated-gradient-text" data-colors="['#FF0055', '#7A00FF', '#00E5FF', '#FF0055']" data-speed="6" data-direction="horizontal" data-yoyo="true" data-i18n="hero.title.part2" style="font-size: inherit; font-weight: inherit; letter-spacing: inherit; display: inline-block;">India's Creators</span>
                </h1>

                <p data-i18n="hero.desc">
                    Post campaigns. Apply as a creator. Earn real money in INR.
                    ReelKaro connects brands with Instagram, YouTube, Josh &amp; ShareChat creators across India.
                </p>

                <div class="hero-buttons">
                    <a href="<%= request.getContextPath() %>/register-brand.jsp" class="btn btn-primary btn-lg" data-i18n="hero.cta.brand">
                        I'm a Brand →
                    </a>
                    <a href="<%= request.getContextPath() %>/register-creator.jsp" class="btn btn-outline btn-lg" data-i18n="hero.cta.creator">
                        I'm a Creator →
                    </a>
                </div>

                <div class="hero-stats">
                    <div class="hero-stat-item">
                        <div class="value" data-count="25000" data-suffix="+">25,000+</div>
                        <div class="label" data-i18n="hero.stat.creators">Creators</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="value" data-count="800" data-suffix="+">800+</div>
                        <div class="label" data-i18n="hero.stat.brands">Brands</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="value" data-count="3500" data-suffix="+">3,500+</div>
                        <div class="label" data-i18n="hero.stat.campaigns">Campaigns</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="value" data-prefix="₹" data-count="5" data-suffix="Cr+">₹5Cr+</div>
                        <div class="label" data-i18n="hero.stat.paid">Paid Out</div>
                    </div>
                </div>
            </div>

            <!-- Right side: Floating mock marketplace cards -->
            <div class="hero-visual fade-in-delay-1">
                <div class="showcase-card" style="transform: rotate(-1deg); margin-left: 20px;">
                    <div class="flex justify-between items-center">
                        <span class="badge badge-open" style="font-size: 0.65rem;">📸 Instagram</span>
                        <span style="font-weight: 800; font-size: 0.95rem; color: #FFFFFF;">₹2,500 / Post</span>
                    </div>
                    <h3 style="font-size: 1rem; margin-top: var(--sp-2);">boAt Audio — Airdopes 131 Launch</h3>
                    <p style="font-size: 0.8rem; line-height: 1.4;">Create a 30s aesthetic reel demonstrating deep bass and styling.</p>
                    <div class="showcase-progress">
                        <div class="showcase-progress-bar" style="width: 80%;"></div>
                    </div>
                    <div class="flex justify-between" style="font-size: 0.72rem; color: var(--text-muted); margin-top: 2px;">
                        <span>80/100 Creators Approved</span>
                        <span style="color: var(--text-secondary); font-weight: 600;">Active</span>
                    </div>
                </div>

                <div class="showcase-card" style="transform: rotate(1deg); margin-left: -10px; border-color: rgba(255, 255, 255, 0.12);">
                    <div class="flex justify-between items-center">
                        <span class="badge badge-pending" style="font-size: 0.65rem;">▶️ YouTube</span>
                        <span style="font-weight: 800; font-size: 0.95rem; color: #FFFFFF;">₹4,200 / Video</span>
                    </div>
                    <h3 style="font-size: 1rem; margin-top: var(--sp-2);">Mamaearth — Vitamin C Face Wash</h3>
                    <p style="font-size: 0.8rem; line-height: 1.4;">Detailed honest review video focusing on organic ingredients.</p>
                    <div class="showcase-progress">
                        <div class="showcase-progress-bar" style="width: 45%;"></div>
                    </div>
                    <div class="flex justify-between" style="font-size: 0.72rem; color: var(--text-muted); margin-top: 2px;">
                        <span>22/50 Creators Approved</span>
                        <span style="color: var(--text-secondary); font-weight: 600;">Active</span>
                    </div>
                </div>

                <div class="showcase-card" style="transform: rotate(-0.5deg); margin-left: 15px;">
                    <div class="flex justify-between items-center">
                        <span class="badge badge-open" style="font-size: 0.65rem;">🎬 Moj</span>
                        <span style="font-weight: 800; font-size: 0.95rem; color: #FFFFFF;">₹1,800 / Clip</span>
                    </div>
                    <h3 style="font-size: 1rem; margin-top: var(--sp-2);">Flipkart — Big Billion Days Clipping</h3>
                    <p style="font-size: 0.8rem; line-height: 1.4;">Remix, clip, or post funny memes on Moj with campaign hashtag.</p>
                    <div class="showcase-progress">
                        <div class="showcase-progress-bar" style="width: 95%;"></div>
                    </div>
                    <div class="flex justify-between" style="font-size: 0.72rem; color: var(--text-muted); margin-top: 2px;">
                        <span>190/200 Creators Approved</span>
                        <span style="color: var(--text-muted); font-weight: 600;">Almost Full</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ======================================================
     CURVED LOOP MARQUEE — draggable animated band
     SEO keywords: influencer marketing India, creator economy,
     brand campaigns, monetize content, earn in INR
     ====================================================== -->
<section class="curved-loop-section" aria-label="Influencer marketing platform highlights">
    <div
      class="curved-loop-jacket"
      data-text="Influencer Marketing ✦ Creator Economy India ✦ Brand Campaigns ✦ Earn in INR ✦ Monetize Content ✦ Josh · ShareChat · Moj ✦ Instagram Campaigns ✦ YouTube Collabs ✦"
      data-speed="1.8"
      data-curve="380"
      data-direction="left"
      data-interactive="true"
      id="curvedLoopMain"
      title="India's leading influencer marketing & creator economy platform"
    ></div>
</section>

<!-- ======================================================
     PLATFORMS STRIP
     ====================================================== -->
<section class="section-sm" style="background: var(--bg-surface); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border);">
    <div class="container text-center">
        <p style="font-size: 0.75rem; color: var(--text-muted); margin-bottom: var(--sp-5); text-transform: uppercase; letter-spacing: 0.12em; font-weight: 600;">Monetize Content Across Major Platforms</p>
        <div class="flex justify-center gap-4 flex-wrap">
            <div class="platform-pill plat-instagram">📸 Instagram</div>
            <div class="platform-pill plat-youtube">▶️ YouTube</div>
            <div class="platform-pill plat-josh">🎵 Josh</div>
            <div class="platform-pill plat-sharechat">💬 ShareChat</div>
            <div class="platform-pill plat-moj">🎬 Moj</div>
        </div>

        <div style="margin-top: var(--sp-10); border-top: 1px dashed var(--border); padding-top: var(--sp-6);">
            <p style="font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.1em; font-weight: 500;">Trusted by India's Top Brands &amp; Startups</p>
            <div class="trust-logos">
                <span class="trust-logo">boAt</span>
                <span class="trust-logo">Flipkart</span>
                <span class="trust-logo">Myntra</span>
                <span class="trust-logo">Lenskart</span>
                <span class="trust-logo">TATA</span>
                <span class="trust-logo">Zomato</span>
            </div>
        </div>
    </div>
</section>

<!-- ======================================================
     HOW IT WORKS
     ====================================================== -->
<section class="section">
    <div class="container">
        <div class="section-head">
            <span class="eyebrow">Process</span>
            <h2 data-i18n="how.title">How ReelKaro Works</h2>
            <p>Sleek, transparent, and direct campaign workflow built for Bharat's creator economy</p>
        </div>

        <div class="grid-2" style="margin-top: var(--sp-10);">
            <!-- For Brands Bento Card -->
            <div class="card card-glow-violet" style="background: linear-gradient(135deg, rgba(255, 255, 255, 0.01) 0%, rgba(255, 255, 255, 0.04) 100%); border-color: rgba(255, 255, 255, 0.12);">
                <div class="text-center mb-6">
                    <span class="badge badge-open" style="font-size:0.75rem;padding:4px 12px;margin-bottom:var(--sp-2);">For Brands</span>
                    <h3 data-i18n="how.brand.title">For Brands</h3>
                </div>
                <div class="flex flex-col gap-4">
                    <div class="flex items-center gap-4" style="background: rgba(255,255,255,0.02); padding: var(--sp-4); border-radius: var(--r-md); border: 1px solid var(--border);">
                        <div class="step-number" style="margin: 0; width: 36px; height: 36px; font-size: 0.9rem; background: linear-gradient(135deg, #FFFFFF, #E8E8E8); color: #000000; box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);">1</div>
                        <h4 data-i18n="how.brand.step1" style="font-size:0.9rem; font-weight: 500; color: var(--text-secondary);">Post your campaign with budget & requirements</h4>
                    </div>
                    <div class="flex items-center gap-4" style="background: rgba(255,255,255,0.02); padding: var(--sp-4); border-radius: var(--r-md); border: 1px solid var(--border);">
                        <div class="step-number" style="margin: 0; width: 36px; height: 36px; font-size: 0.9rem; background: linear-gradient(135deg, #FFFFFF, #E8E8E8); color: #000000; box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);">2</div>
                        <h4 data-i18n="how.brand.step2" style="font-size:0.9rem; font-weight: 500; color: var(--text-secondary);">Review creator applications</h4>
                    </div>
                    <div class="flex items-center gap-4" style="background: rgba(255,255,255,0.02); padding: var(--sp-4); border-radius: var(--r-md); border: 1px solid var(--border);">
                        <div class="step-number" style="margin: 0; width: 36px; height: 36px; font-size: 0.9rem; background: linear-gradient(135deg, #FFFFFF, #E8E8E8); color: #000000; box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);">3</div>
                        <h4 data-i18n="how.brand.step3" style="font-size:0.9rem; font-weight: 500; color: var(--text-secondary);">Approve content & reward creators</h4>
                    </div>
                </div>
                <div class="text-center mt-6">
                    <a href="<%= request.getContextPath() %>/register-brand.jsp" class="btn btn-primary btn-sm">Hire Creators Now →</a>
                </div>
            </div>

            <!-- For Creators Bento Card -->
            <div class="card card-glow-accent" style="background: linear-gradient(135deg, rgba(255, 255, 255, 0.01) 0%, rgba(255, 255, 255, 0.04) 100%); border-color: rgba(255, 255, 255, 0.10);">
                <div class="text-center mb-6">
                    <span class="badge badge-pending" style="font-size:0.75rem;padding:4px 12px;margin-bottom:var(--sp-2);">For Creators</span>
                    <h3 data-i18n="how.creator.title">For Creators</h3>
                </div>
                <div class="flex flex-col gap-4">
                    <div class="flex items-center gap-4" style="background: rgba(255,255,255,0.02); padding: var(--sp-4); border-radius: var(--r-md); border: 1px solid var(--border);">
                        <div class="step-number" style="margin: 0; width: 36px; height: 36px; font-size: 0.9rem; background: linear-gradient(135deg, #FFFFFF, #E8E8E8); color: #000000; box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);">1</div>
                        <h4 data-i18n="how.creator.step1" style="font-size:0.9rem; font-weight: 500; color: var(--text-secondary);">Browse open campaigns</h4>
                    </div>
                    <div class="flex items-center gap-4" style="background: rgba(255,255,255,0.02); padding: var(--sp-4); border-radius: var(--r-md); border: 1px solid var(--border);">
                        <div class="step-number" style="margin: 0; width: 36px; height: 36px; font-size: 0.9rem; background: linear-gradient(135deg, #FFFFFF, #E8E8E8); color: #000000; box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);">2</div>
                        <h4 data-i18n="how.creator.step2" style="font-size:0.9rem; font-weight: 500; color: var(--text-secondary);">Apply & get approved</h4>
                    </div>
                    <div class="flex items-center gap-4" style="background: rgba(255,255,255,0.02); padding: var(--sp-4); border-radius: var(--r-md); border: 1px solid var(--border);">
                        <div class="step-number" style="margin: 0; width: 36px; height: 36px; font-size: 0.9rem; background: linear-gradient(135deg, #FFFFFF, #E8E8E8); color: #000000; box-shadow: 0 4px 12px rgba(255, 255, 255, 0.15);">3</div>
                        <h4 data-i18n="how.creator.step3" style="font-size:0.9rem; font-weight: 500; color: var(--text-secondary);">Post content & earn ₹₹₹</h4>
                    </div>
                </div>
                <div class="text-center mt-6">
                    <a href="<%= request.getContextPath() %>/register-creator.jsp" class="btn btn-outline btn-sm">Monetize Content →</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ======================================================
     REELKARO FEATURES BENTO GRID
     ====================================================== -->
<section class="section">
    <div class="container">
        <div class="section-head text-center">
            <span class="eyebrow">Features</span>
            <h2>Powerful Features for Growth</h2>
            <p>India's first automated clipping and influencer marketing portal built for scale</p>
        </div>

        <div class="card-grid bento-section"
             data-text-auto-hide="false"
             data-enable-stars="true"
             data-enable-spotlight="true"
             data-enable-border-glow="true"
             data-enable-tilt="true"
             data-enable-magnetism="true"
             data-click-effect="true"
             data-spotlight-radius="320"
             data-particle-count="14"
             data-glow-color="255, 0, 85"
             style="margin-top: var(--sp-10);"
        >
            <!-- 1. Analytics -->
            <div class="magic-bento-card particle-container">
                <div class="magic-bento-card__header">
                    <div class="magic-bento-card__label">Insights</div>
                </div>
                <div class="magic-bento-card__content">
                    <h3 class="magic-bento-card__title">Campaign Analytics</h3>
                    <p class="magic-bento-card__description">Track user engagement, reach, and clips across Instagram, YouTube, Josh, and Moj in real-time.</p>
                </div>
            </div>

            <!-- 2. Dashboard -->
            <div class="magic-bento-card particle-container">
                <div class="magic-bento-card__header">
                    <div class="magic-bento-card__label">Overview</div>
                </div>
                <div class="magic-bento-card__content">
                    <h3 class="magic-bento-card__title">Central Dashboard</h3>
                    <p class="magic-bento-card__description">A single hub to manage active submissions, creator reviews, and live payouts securely.</p>
                </div>
            </div>

            <!-- 3. Collaboration -->
            <div class="magic-bento-card particle-container">
                <div class="magic-bento-card__header">
                    <div class="magic-bento-card__label">Teamwork</div>
                </div>
                <div class="magic-bento-card__content">
                    <h3 class="magic-bento-card__title">Seamless Collaboration</h3>
                    <p class="magic-bento-card__description">Connect brands with creators directly. Manage chat logs, asset delivery, content guidelines, and approvals within one secure dashboard.</p>
                </div>
            </div>

            <!-- 4. Automation -->
            <div class="magic-bento-card particle-container">
                <div class="magic-bento-card__header">
                    <div class="magic-bento-card__label">Efficiency</div>
                </div>
                <div class="magic-bento-card__content">
                    <h3 class="magic-bento-card__title">Smart Automation</h3>
                    <p class="magic-bento-card__description">Instantly verify live campaign links and automate payout payouts once deliverables match brand criteria.</p>
                </div>
            </div>

            <!-- 5. Integration -->
            <div class="magic-bento-card particle-container">
                <div class="magic-bento-card__header">
                    <div class="magic-bento-card__label">Connectivity</div>
                </div>
                <div class="magic-bento-card__content">
                    <h3 class="magic-bento-card__title">One-Click Assets</h3>
                    <p class="magic-bento-card__description">Sync your media briefs, logo PNGs, hashtags, and sound templates directly for creator access.</p>
                </div>
            </div>

            <!-- 6. Security -->
            <div class="magic-bento-card particle-container">
                <div class="magic-bento-card__header">
                    <div class="magic-bento-card__label">Protection</div>
                </div>
                <div class="magic-bento-card__content">
                    <h3 class="magic-bento-card__title">Secure Escrow Payouts</h3>
                    <p class="magic-bento-card__description">Verify campaigns with escrowed amounts. Guaranteed TDS validation and automatic invoices in INR.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ======================================================
     FEATURED CATEGORIES
     ====================================================== -->
<section class="section" style="background: var(--bg-surface); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border);">
    <div class="container">
        <div class="section-head">
            <span class="eyebrow">Categories</span>
            <h2>Campaigns for Every Niche</h2>
            <p>From fashion to fintech — there's a campaign for every creator in India.</p>
        </div>

        <div class="grid-4" style="margin-top:var(--sp-8);">
            <%
                String[] categories = {
                    "Fashion & Lifestyle", "Food & Beverages",
                    "Beauty & Skincare",  "Health & Fitness",
                    "Tech & Gadgets",     "Travel & Tourism",
                    "Gaming & Esports",   "Home & Decor",
                    "Fintech & Finance",  "Education & EdTech",
                    "Wellness & Yoga",    "Music & Entertainment"
                };
                for (String cat : categories) {
            %>
            <div class="cat-card">
                <div class="cat-card-inner">
                    <div class="cat-card-dot"></div>
                    <div class="cat-card-label"><%= cat %></div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- ======================================================
     CTA BANNER
     ====================================================== -->
<section class="section">
    <div class="container">
        <div class="cta-banner text-center">
            <div style="font-size:3rem;margin-bottom:var(--sp-4);">🚀</div>
            <h2>Ready to grow your brand or income?</h2>
            <p style="max-width:500px;margin:var(--sp-4) auto var(--sp-8); color: var(--text-secondary);">
                Join thousands of brands and creators already winning on ReelKaro.
                Registration is free. Campaigns start in minutes.
            </p>
            <div class="flex justify-center gap-4" style="flex-wrap:wrap;">
                <a href="<%= request.getContextPath() %>/register-brand.jsp" class="btn btn-primary btn-lg">
                    Start a Campaign →
                </a>
                <a href="<%= request.getContextPath() %>/register-creator.jsp" class="btn btn-outline btn-lg">
                    Join as Creator →
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ======================================================
     FOOTER
     ====================================================== -->
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <a href="<%= request.getContextPath() %>/index.jsp" class="navbar-brand" style="font-size:1.3rem;">
                    <span class="logo-rk">RK</span> ReelKaro
                </a>
                <p class="desc">India's first creator-brand campaign marketplace. Connect, create, and earn in INR.</p>
                <div class="social-links" style="margin-top:var(--sp-4);">
                    <a href="#" class="social-link" title="Instagram">📸</a>
                    <a href="#" class="social-link" title="YouTube">▶️</a>
                    <a href="#" class="social-link" title="Twitter">🐦</a>
                    <a href="#" class="social-link" title="LinkedIn">💼</a>
                </div>
            </div>

            <div class="footer-col">
                <h4>Platform</h4>
                <a href="<%= request.getContextPath() %>/register-brand.jsp">For Brands</a>
                <a href="<%= request.getContextPath() %>/register-creator.jsp">For Creators</a>
                <a href="<%= request.getContextPath() %>/Leaderboard">Leaderboard</a>
                <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
            </div>

            <div class="footer-col">
                <h4>Platforms</h4>
                <a href="#">Instagram</a>
                <a href="#">YouTube</a>
                <a href="#">Josh</a>
                <a href="#">ShareChat</a>
                <a href="#">Moj</a>
            </div>

            <div class="footer-col">
                <h4>Support</h4>
                <a href="#">Help Center</a>
                <a href="#">Terms of Service</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Contact Us</a>
            </div>
        </div>

        <div class="footer-bottom">
            <p>© 2024 ReelKaro. Made with ❤️ in India 🇮🇳 All amounts in INR (₹)</p>
            <p>Built for Bharat's creators</p>
        </div>
    </div>
</footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
<script src="<%= request.getContextPath() %>/js/curved-loop.js"></script>
<script src="<%= request.getContextPath() %>/js/gradient-text.js"></script>
<script src="<%= request.getContextPath() %>/js/magic-bento.js"></script>
<script src="<%= request.getContextPath() %>/js/main.js"></script>
<script>
  // Initialise widgets on DOMContentLoaded
  document.addEventListener('DOMContentLoaded', function () {
    CurvedLoop.initAll();
    GradientText.initAll();
    MagicBento.initAll();
  });
</script>
</body>
</html>
