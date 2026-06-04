/**
 * ReelKaro \u2014 main.js
 * Handles:
 *  1. Language toggle (Hindi \u2194 English) with a JS translation map
 *  2. Client-side form validation
 *  3. WhatsApp share button generation
 *  4. Animated stats counter on the landing page
 *  5. Navbar mobile hamburger toggle
 *  6. Sidebar mobile toggle
 *  7. Auto-dismiss alerts
 */

// ============================================================
// 1. LANGUAGE TRANSLATIONS
// Keys = element data-i18n attribute values
// ============================================================
const translations = {
  en: {
    // Navbar
    "nav.home":         "Home",
    "nav.browse":       "Browse Campaigns",
    "nav.login":        "Login",
    "nav.register":     "Register",
    "nav.dashboard":    "Dashboard",
    "nav.campaigns":    "My Campaigns",
    "nav.post":         "Post Campaign",
    "nav.applications": "Applications",
    "nav.earnings":     "Earnings",
    "nav.leaderboard":  "Leaderboard",
    "nav.profile":      "Profile",
    "nav.logout":       "Logout",

    // Hero
    "hero.eyebrow":     "\u{1f1ee}\u{1f1f3} India's #1 Creator Marketplace",
    "hero.title.part1": "Where Brands Meet",
    "hero.title.part2": "India's Creators",
    "hero.desc":        "Post campaigns. Apply as a creator. Earn real money in INR. ReelKaro connects brands with Instagram, YouTube, Josh & ShareChat creators across India.",
    "hero.cta.brand":   "I'm a Brand \u2192",
    "hero.cta.creator": "I'm a Creator \u2192",
    "hero.stat.creators": "Creators",
    "hero.stat.brands":   "Brands",
    "hero.stat.campaigns":"Campaigns",
    "hero.stat.paid":     "Paid Out",

    // How it works
    "how.title":          "How ReelKaro Works",
    "how.brand.title":    "For Brands",
    "how.creator.title":  "For Creators",
    "how.brand.step1":    "Post your campaign with budget & requirements",
    "how.brand.step2":    "Review creator applications",
    "how.brand.step3":    "Approve content & reward creators",
    "how.creator.step1":  "Browse open campaigns",
    "how.creator.step2":  "Apply & get approved",
    "how.creator.step3":  "Post content & earn \u20b9\u20b9\u20b9",

    // Common buttons
    "btn.apply":        "Apply Now",
    "btn.applied":      "Applied \u2713",
    "btn.view":         "View Details",
    "btn.share":        "Share on WhatsApp",
    "btn.submit":       "Submit Content",
    "btn.save":         "Save Changes",
    "btn.post":         "Post Campaign",
    "btn.approve":      "Approve",
    "btn.reject":       "Reject",
    "btn.pause":        "Pause",
    "btn.close":        "Close",
    "btn.reopen":       "Re-open",
    "btn.save.upi":     "Save UPI ID",

    // Campaign card labels
    "card.reward":      "Reward",
    "card.deadline":    "Deadline",
    "card.applicants":  "Applicants",
    "card.platform":    "Platform",
    "card.category":    "Category",
    "card.budget":      "Total Budget",
    "card.max":         "Max Creators",
    "card.status":      "Status",

    // Dashboard
    "dash.welcome":         "Welcome back",
    "dash.active.camps":    "Active Campaigns",
    "dash.total.apps":      "Total Applications",
    "dash.total.spent":     "Total Spent",
    "dash.approval.rate":   "Approval Rate",
    "dash.total.earned":    "Total Earned",
    "dash.pending.apps":    "Pending Applications",
    "dash.approved.subs":   "Approved Submissions",
    "dash.rank":            "Leaderboard Rank",

    // Forms
    "form.name":            "Full Name",
    "form.email":           "Email Address",
    "form.password":        "Password",
    "form.confirm":         "Confirm Password",
    "form.company":         "Company Name",
    "form.industry":        "Industry",
    "form.website":         "Website (optional)",
    "form.gst":             "GST Number (optional)",
    "form.username":        "Creator Username",
    "form.niche":           "Content Niche",
    "form.instagram":       "Instagram Handle",
    "form.youtube":         "YouTube Channel",
    "form.josh":            "Josh Handle",
    "form.sharechat":       "ShareChat Handle",
    "form.followers":       "Total Followers",
    "form.city":            "City",
    "form.state":           "State",
    "form.bio":             "Bio",
    "form.title":           "Campaign Title",
    "form.desc":            "Description",
    "form.platform":        "Platform",
    "form.category":        "Category",
    "form.budget":          "Total Budget (\u20b9)",
    "form.reward":          "Reward per Creator (\u20b9)",
    "form.max":             "Max Creators",
    "form.deadline":        "Application Deadline",
    "form.content.link":    "Content URL / Post Link",
    "form.platform.posted": "Platform Posted On",
    "form.upi":             "UPI ID",
    "form.feedback":        "Feedback (optional)",

    // Misc
    "payout.coming":      "Payout Coming Soon",
    "no.campaigns":       "No campaigns found.",
    "no.apps":            "No applications yet.",
    "no.rewards":         "No rewards yet.",
    "filter.platform":    "Filter by Platform",
    "filter.category":    "Filter by Category",
    "filter.min.reward":  "Min Reward (\u20b9)",
    "filter.sort":        "Sort By",
    "sort.newest":        "Newest First",
    "sort.highest":       "Highest Reward",
    "leaderboard.title":  "Top Creator Leaderboard",
    "leaderboard.rank":   "Rank",
    "leaderboard.creator":"Creator",
    "leaderboard.city":   "City",
    "leaderboard.niche":  "Niche",
    "leaderboard.earned": "Total Earned",
    "leaderboard.approved":"Approved Posts",
  },

  hi: {
    // Navbar
    "nav.home":         "\u0939\u094b\u092e",
    "nav.browse":       "\u0905\u092d\u093f\u092f\u093e\u0928 \u0926\u0947\u0916\u0947\u0902",
    "nav.login":        "\u0932\u0949\u0917\u093f\u0928",
    "nav.register":     "\u0930\u091c\u093f\u0938\u094d\u091f\u0930",
    "nav.dashboard":    "\u0921\u0948\u0936\u092c\u094b\u0930\u094d\u0921",
    "nav.campaigns":    "\u092e\u0947\u0930\u0947 \u0905\u092d\u093f\u092f\u093e\u0928",
    "nav.post":         "\u0905\u092d\u093f\u092f\u093e\u0928 \u092a\u094b\u0938\u094d\u091f \u0915\u0930\u0947\u0902",
    "nav.applications": "\u0906\u0935\u0947\u0926\u0928",
    "nav.earnings":     "\u0915\u092e\u093e\u0908",
    "nav.leaderboard":  "\u0932\u0940\u0921\u0930\u092c\u094b\u0930\u094d\u0921",
    "nav.profile":      "\u092a\u094d\u0930\u094b\u092b\u093c\u093e\u0907\u0932",
    "nav.logout":       "\u0932\u0949\u0917\u0906\u0909\u091f",

    // Hero
    "hero.eyebrow":     "\u{1f1ee}\u{1f1f3} \u092d\u093e\u0930\u0924 \u0915\u093e \u0928\u0902\u092c\u0930 1 \u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u092e\u093e\u0930\u094d\u0915\u0947\u091f\u092a\u094d\u0932\u0947\u0938",
    "hero.title.part1": "\u092c\u094d\u0930\u093e\u0902\u0921\u094d\u0938 \u092e\u093f\u0932\u0924\u0947 \u0939\u0948\u0902",
    "hero.title.part2": "\u092d\u093e\u0930\u0924 \u0915\u0947 \u0915\u094d\u0930\u093f\u090f\u091f\u0930\u094d\u0938 \u0938\u0947",
    "hero.desc":        "\u0905\u092d\u093f\u092f\u093e\u0928 \u092a\u094b\u0938\u094d\u091f \u0915\u0930\u0947\u0902\u0964 \u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u0915\u0947 \u0930\u0942\u092a \u092e\u0947\u0902 \u0905\u092a\u094d\u0932\u093e\u0908 \u0915\u0930\u0947\u0902\u0964 INR \u092e\u0947\u0902 \u0905\u0938\u0932\u0940 \u092a\u0948\u0938\u0947 \u0915\u092e\u093e\u090f\u0902\u0964 ReelKaro \u092c\u094d\u0930\u093e\u0902\u0921\u094d\u0938 \u0915\u094b Instagram, YouTube, Josh \u0914\u0930 ShareChat \u0915\u094d\u0930\u093f\u090f\u091f\u0930\u094d\u0938 \u0938\u0947 \u091c\u094b\u0921\u093c\u0924\u093e \u0939\u0948\u0964",
    "hero.cta.brand":   "\u092e\u0948\u0902 \u090f\u0915 \u092c\u094d\u0930\u093e\u0902\u0921 \u0939\u0942\u0901 \u2192",
    "hero.cta.creator": "\u092e\u0948\u0902 \u090f\u0915 \u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u0939\u0942\u0901 \u2192",
    "hero.stat.creators": "\u0915\u094d\u0930\u093f\u090f\u091f\u0930\u094d\u0938",
    "hero.stat.brands":   "\u092c\u094d\u0930\u093e\u0902\u0921\u094d\u0938",
    "hero.stat.campaigns":"\u0905\u092d\u093f\u092f\u093e\u0928",
    "hero.stat.paid":     "\u092d\u0941\u0917\u0924\u093e\u0928 \u0939\u0941\u0906",

    // How it works
    "how.title":          "ReelKaro \u0915\u0948\u0938\u0947 \u0915\u093e\u092e \u0915\u0930\u0924\u093e \u0939\u0948",
    "how.brand.title":    "\u092c\u094d\u0930\u093e\u0902\u0921\u094d\u0938 \u0915\u0947 \u0932\u093f\u090f",
    "how.creator.title":  "\u0915\u094d\u0930\u093f\u090f\u091f\u0930\u094d\u0938 \u0915\u0947 \u0932\u093f\u090f",
    "how.brand.step1":    "\u092c\u091c\u091f \u0914\u0930 \u0906\u0935\u0936\u094d\u092f\u0915\u0924\u093e\u0913\u0902 \u0915\u0947 \u0938\u093e\u0925 \u0905\u092d\u093f\u092f\u093e\u0928 \u092a\u094b\u0938\u094d\u091f \u0915\u0930\u0947\u0902",
    "how.brand.step2":    "\u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u0906\u0935\u0947\u0926\u0928\u094b\u0902 \u0915\u0940 \u0938\u092e\u0940\u0915\u094d\u0937\u093e \u0915\u0930\u0947\u0902",
    "how.brand.step3":    "\u0915\u0902\u091f\u0947\u0902\u091f \u0905\u092a\u094d\u0930\u0942\u0935 \u0915\u0930\u0947\u0902 \u0914\u0930 \u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u0915\u094b \u092a\u0941\u0930\u0938\u094d\u0915\u0943\u0924 \u0915\u0930\u0947\u0902",
    "how.creator.step1":  "\u0916\u0941\u0932\u0947 \u0905\u092d\u093f\u092f\u093e\u0928 \u092c\u094d\u0930\u093e\u0909\u091c\u093c \u0915\u0930\u0947\u0902",
    "how.creator.step2":  "\u0905\u092a\u094d\u0932\u093e\u0908 \u0915\u0930\u0947\u0902 \u0914\u0930 \u0905\u092a\u094d\u0930\u0942\u0935 \u0939\u094b\u0902",
    "how.creator.step3":  "\u0915\u0902\u091f\u0947\u0902\u091f \u092a\u094b\u0938\u094d\u091f \u0915\u0930\u0947\u0902 \u0914\u0930 \u20b9\u20b9\u20b9 \u0915\u092e\u093e\u090f\u0902",

    // Common buttons
    "btn.apply":        "\u0905\u092d\u0940 \u0905\u092a\u094d\u0932\u093e\u0908 \u0915\u0930\u0947\u0902",
    "btn.applied":      "\u0905\u092a\u094d\u0932\u093e\u0908 \u0939\u094b \u0917\u092f\u093e \u2713",
    "btn.view":         "\u0935\u093f\u0935\u0930\u0923 \u0926\u0947\u0916\u0947\u0902",
    "btn.share":        "WhatsApp \u092a\u0930 \u0936\u0947\u092f\u0930 \u0915\u0930\u0947\u0902",
    "btn.submit":       "\u0915\u0902\u091f\u0947\u0902\u091f \u0938\u092c\u092e\u093f\u091f \u0915\u0930\u0947\u0902",
    "btn.save":         "\u092c\u0926\u0932\u093e\u0935 \u0938\u0939\u0947\u091c\u0947\u0902",
    "btn.post":         "\u0905\u092d\u093f\u092f\u093e\u0928 \u092a\u094b\u0938\u094d\u091f \u0915\u0930\u0947\u0902",
    "btn.approve":      "\u0905\u092a\u094d\u0930\u0942\u0935 \u0915\u0930\u0947\u0902",
    "btn.reject":       "\u0930\u093f\u091c\u0947\u0915\u094d\u091f \u0915\u0930\u0947\u0902",
    "btn.pause":        "\u0930\u094b\u0915\u0947\u0902",
    "btn.close":        "\u092c\u0902\u0926 \u0915\u0930\u0947\u0902",
    "btn.reopen":       "\u092b\u093f\u0930 \u0916\u094b\u0932\u0947\u0902",
    "btn.save.upi":     "UPI ID \u0938\u0939\u0947\u091c\u0947\u0902",

    // Campaign card labels
    "card.reward":      "\u0907\u0928\u093e\u092e",
    "card.deadline":    "\u0905\u0902\u0924\u093f\u092e \u0924\u093f\u0925\u093f",
    "card.applicants":  "\u0906\u0935\u0947\u0926\u0928\u0915\u0930\u094d\u0924\u093e",
    "card.platform":    "\u092a\u094d\u0932\u0947\u091f\u092b\u093c\u0949\u0930\u094d\u092e",
    "card.category":    "\u0936\u094d\u0930\u0947\u0923\u0940",
    "card.budget":      "\u0915\u0941\u0932 \u092c\u091c\u091f",
    "card.max":         "\u0905\u0927\u093f\u0915\u0924\u092e \u0915\u094d\u0930\u093f\u090f\u091f\u0930",
    "card.status":      "\u0938\u094d\u0925\u093f\u0924\u093f",

    // Dashboard
    "dash.welcome":         "\u0935\u093e\u092a\u0938 \u0938\u094d\u0935\u093e\u0917\u0924 \u0939\u0948",
    "dash.active.camps":    "\u0938\u0915\u094d\u0930\u093f\u092f \u0905\u092d\u093f\u092f\u093e\u0928",
    "dash.total.apps":      "\u0915\u0941\u0932 \u0906\u0935\u0947\u0926\u0928",
    "dash.total.spent":     "\u0915\u0941\u0932 \u0916\u0930\u094d\u091a",
    "dash.approval.rate":   "\u0905\u092a\u094d\u0930\u0942\u0935\u0932 \u0926\u0930",
    "dash.total.earned":    "\u0915\u0941\u0932 \u0915\u092e\u093e\u0908",
    "dash.pending.apps":    "\u0932\u0902\u092c\u093f\u0924 \u0906\u0935\u0947\u0926\u0928",
    "dash.approved.subs":   "\u0905\u092a\u094d\u0930\u0942\u0935 \u0938\u092c\u092e\u093f\u0936\u0928",
    "dash.rank":            "\u0932\u0940\u0921\u0930\u092c\u094b\u0930\u094d\u0921 \u0930\u0948\u0902\u0915",

    // Forms
    "form.name":            "\u092a\u0942\u0930\u093e \u0928\u093e\u092e",
    "form.email":           "\u0908\u092e\u0947\u0932 \u092a\u0924\u093e",
    "form.password":        "\u092a\u093e\u0938\u0935\u0930\u094d\u0921",
    "form.confirm":         "\u092a\u093e\u0938\u0935\u0930\u094d\u0921 \u0915\u0940 \u092a\u0941\u0937\u094d\u091f\u093f \u0915\u0930\u0947\u0902",
    "form.company":         "\u0915\u0902\u092a\u0928\u0940 \u0915\u093e \u0928\u093e\u092e",
    "form.industry":        "\u0909\u0926\u094d\u092f\u094b\u0917",
    "form.website":         "\u0935\u0947\u092c\u0938\u093e\u0907\u091f (\u0935\u0948\u0915\u0932\u094d\u092a\u093f\u0915)",
    "form.gst":             "GST \u0928\u0902\u092c\u0930 (\u0935\u0948\u0915\u0932\u094d\u092a\u093f\u0915)",
    "form.username":        "\u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u092f\u0942\u091c\u093c\u0930\u0928\u0947\u092e",
    "form.niche":           "\u0915\u0902\u091f\u0947\u0902\u091f \u0928\u093f\u091a",
    "form.instagram":       "Instagram \u0939\u0948\u0902\u0921\u0932",
    "form.youtube":         "YouTube \u091a\u0948\u0928\u0932",
    "form.josh":            "Josh \u0939\u0948\u0902\u0921\u0932",
    "form.sharechat":       "ShareChat \u0939\u0948\u0902\u0921\u0932",
    "form.followers":       "\u0915\u0941\u0932 \u092b\u0949\u0932\u094b\u0905\u0930\u094d\u0938",
    "form.city":            "\u0936\u0939\u0930",
    "form.state":           "\u0930\u093e\u091c\u094d\u092f",
    "form.bio":             "\u092c\u093e\u092f\u094b",
    "form.title":           "\u0905\u092d\u093f\u092f\u093e\u0928 \u0936\u0940\u0930\u094d\u0937\u0915",
    "form.desc":            "\u0935\u093f\u0935\u0930\u0923",
    "form.platform":        "\u092a\u094d\u0932\u0947\u091f\u092b\u093c\u0949\u0930\u094d\u092e",
    "form.category":        "\u0936\u094d\u0930\u0947\u0923\u0940",
    "form.budget":          "\u0915\u0941\u0932 \u092c\u091c\u091f (\u20b9)",
    "form.reward":          "\u092a\u094d\u0930\u0924\u093f \u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u0907\u0928\u093e\u092e (\u20b9)",
    "form.max":             "\u0905\u0927\u093f\u0915\u0924\u092e \u0915\u094d\u0930\u093f\u090f\u091f\u0930",
    "form.deadline":        "\u0906\u0935\u0947\u0926\u0928 \u0915\u0940 \u0905\u0902\u0924\u093f\u092e \u0924\u093f\u0925\u093f",
    "form.content.link":    "\u0915\u0902\u091f\u0947\u0902\u091f URL / \u092a\u094b\u0938\u094d\u091f \u0932\u093f\u0902\u0915",
    "form.platform.posted": "\u092a\u094b\u0938\u094d\u091f \u0915\u093f\u092f\u093e \u0917\u092f\u093e \u092a\u094d\u0932\u0947\u091f\u092b\u093c\u0949\u0930\u094d\u092e",
    "form.upi":             "UPI ID",
    "form.feedback":        "\u092b\u0940\u0921\u092c\u0948\u0915 (\u0935\u0948\u0915\u0932\u094d\u092a\u093f\u0915)",

    // Misc
    "payout.coming":      "\u092d\u0941\u0917\u0924\u093e\u0928 \u091c\u0932\u094d\u0926 \u0906\u090f\u0917\u093e",
    "no.campaigns":       "\u0915\u094b\u0908 \u0905\u092d\u093f\u092f\u093e\u0928 \u0928\u0939\u0940\u0902 \u092e\u093f\u0932\u093e\u0964",
    "no.apps":            "\u0905\u092d\u0940 \u0924\u0915 \u0915\u094b\u0908 \u0906\u0935\u0947\u0926\u0928 \u0928\u0939\u0940\u0902\u0964",
    "no.rewards":         "\u0905\u092d\u0940 \u0924\u0915 \u0915\u094b\u0908 \u0907\u0928\u093e\u092e \u0928\u0939\u0940\u0902\u0964",
    "filter.platform":    "\u092a\u094d\u0932\u0947\u091f\u092b\u093c\u0949\u0930\u094d\u092e \u0938\u0947 \u092b\u093c\u093f\u0932\u094d\u091f\u0930 \u0915\u0930\u0947\u0902",
    "filter.category":    "\u0936\u094d\u0930\u0947\u0923\u0940 \u0938\u0947 \u092b\u093c\u093f\u0932\u094d\u091f\u0930 \u0915\u0930\u0947\u0902",
    "filter.min.reward":  "\u0928\u094d\u092f\u0942\u0928\u0924\u092e \u0907\u0928\u093e\u092e (\u20b9)",
    "filter.sort":        "\u0915\u094d\u0930\u092e\u092c\u0926\u094d\u0927 \u0915\u0930\u0947\u0902",
    "sort.newest":        "\u0928\u0935\u0940\u0928\u0924\u092e \u092a\u0939\u0932\u0947",
    "sort.highest":       "\u0938\u092c\u0938\u0947 \u091c\u093c\u094d\u092f\u093e\u0926\u093e \u0907\u0928\u093e\u092e",
    "leaderboard.title":  "\u0936\u0940\u0930\u094d\u0937 \u0915\u094d\u0930\u093f\u090f\u091f\u0930 \u0932\u0940\u0921\u0930\u092c\u094b\u0930\u094d\u0921",
    "leaderboard.rank":   "\u0930\u0948\u0902\u0915",
    "leaderboard.creator":"\u0915\u094d\u0930\u093f\u090f\u091f\u0930",
    "leaderboard.city":   "\u0936\u0939\u0930",
    "leaderboard.niche":  "\u0928\u093f\u091a",
    "leaderboard.earned": "\u0915\u0941\u0932 \u0915\u092e\u093e\u0908",
    "leaderboard.approved":"\u0905\u092a\u094d\u0930\u0942\u0935 \u092a\u094b\u0938\u094d\u091f",
  }
};

// ============================================================
// 2. LANGUAGE APPLICATION
// Elements with data-i18n="key" get their textContent swapped.
// Elements with data-i18n-ph="key" get their placeholder swapped.
// ============================================================
function applyLanguage(lang) {
  const map = translations[lang] || translations['en'];
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (map[key]) el.textContent = map[key];
  });
  document.querySelectorAll('[data-i18n-ph]').forEach(el => {
    const key = el.getAttribute('data-i18n-ph');
    if (map[key]) el.placeholder = map[key];
  });

  // Update active state on language toggle buttons
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === lang);
  });

  // Persist preference in localStorage (also sent server-side via form)
  localStorage.setItem('rk_lang', lang);
}

// ============================================================
// 3. WHATSAPP SHARE
// Generates share link: wa.me/?text=...
// Call attachWhatsAppButtons() on page load.
// ============================================================
function attachWhatsAppButtons() {
  document.querySelectorAll('[data-wa-title]').forEach(btn => {
    btn.addEventListener('click', function () {
      const title = this.dataset.waTitle || 'ReelKaro Campaign';
      const url   = this.dataset.waUrl   || window.location.href;
      const text  = encodeURIComponent(
        `Check out this campaign on ReelKaro: ${title}\n${url}`
      );
      window.open(`https://wa.me/?text=${text}`, '_blank');
    });
  });
}

// ============================================================
// 4. ANIMATED STATS COUNTER
// Add data-count="12345" to any element; it counts up on load.
// ============================================================
function animateCounters() {
  const counters = document.querySelectorAll('[data-count]');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el     = entry.target;
        const target = parseInt(el.dataset.count, 10);
        if (isNaN(target)) {
          observer.unobserve(el);
          return;
        }

        const prefix = el.dataset.prefix || '';
        const suffix = el.dataset.suffix || '';

        if (target <= 0) {
          el.textContent = prefix + "0" + suffix;
          observer.unobserve(el);
          return;
        }

        const duration = 1800;
        const step   = target / (duration / 16);
        let   current = 0;
        const timer = setInterval(() => {
          current += step;
          if (current >= target) {
            current = target;
            clearInterval(timer);
          }
          el.textContent = prefix + Math.floor(current).toLocaleString('en-IN') + suffix;
        }, 16);
        observer.unobserve(el);
      }
    });
  }, { threshold: 0.1 });

  counters.forEach(c => observer.observe(c));
}

// 5. CLIENT-SIDE FORM VALIDATION
// ============================================================
function setupFormValidation() {
  // ---- Registration forms ----
  const registerForms = document.querySelectorAll('form[data-validate]');
  registerForms.forEach(form => {
    form.addEventListener('submit', function (e) {
      const password = form.querySelector('[name="password"]');
      const confirm  = form.querySelector('[name="confirm_password"]');
      const email    = form.querySelector('[name="email"]');

      let valid = true;

      // Email format check
      if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
        showFieldError(email, 'Please enter a valid email address.');
        valid = false;
      } else if (email) clearFieldError(email);

      // Password length check
      if (password && password.value.length < 6) {
        showFieldError(password, 'Password must be at least 6 characters.');
        valid = false;
      } else if (password) clearFieldError(password);

      // Confirm password check
      if (password && confirm && password.value !== confirm.value) {
        showFieldError(confirm, 'Passwords do not match.');
        valid = false;
      } else if (confirm) clearFieldError(confirm);

      if (!valid) e.preventDefault();
    });
  });

  // ---- Campaign form ----
  const campaignForm = document.querySelector('form[data-validate="campaign"]');
  if (campaignForm) {
    campaignForm.addEventListener('submit', function (e) {
      const reward = parseFloat(campaignForm.querySelector('[name="reward_per_creator_inr"]')?.value || 0);
      const budget = parseFloat(campaignForm.querySelector('[name="budget_inr"]')?.value || 0);
      const max    = parseInt(campaignForm.querySelector('[name="max_creators"]')?.value || 0, 10);

      if (reward > budget) {
        showAlert('Reward per creator cannot exceed total budget.', 'error');
        e.preventDefault();
        return;
      }
      if (max <= 0) {
        showAlert('Max creators must be at least 1.', 'error');
        e.preventDefault();
        return;
      }
    });
  }
}

function showFieldError(field, message) {
  clearFieldError(field);
  field.style.borderColor = 'var(--danger)';
  const err = document.createElement('p');
  err.className = 'field-error';
  err.style.cssText = 'color:var(--danger);font-size:0.78rem;margin-top:4px;';
  err.textContent = message;
  field.parentNode.appendChild(err);
}

function clearFieldError(field) {
  field.style.borderColor = '';
  const existing = field.parentNode.querySelector('.field-error');
  if (existing) existing.remove();
}

// ============================================================
// 6. INLINE ALERT HELPER
// ============================================================
function showAlert(message, type = 'info') {
  const existing = document.querySelector('.js-alert');
  if (existing) existing.remove();

  const alert = document.createElement('div');
  alert.className = `alert alert-${type} js-alert fade-in`;
  alert.innerHTML = `<span>${getAlertIcon(type)}</span> ${message}`;

  const main = document.querySelector('.main-content') || document.querySelector('main') || document.body;
  main.insertBefore(alert, main.firstChild);

  setTimeout(() => alert.remove(), 5000);
}

function getAlertIcon(type) {
  const icons = { error: '\u274c', success: '\u2705', info: '\u2139\ufe0f', warning: '\u26a0\ufe0f' };
  return icons[type] || '\u2139\ufe0f';
}

// ============================================================
// 7. AUTO-DISMISS ALERTS (from JSP session messages)
// ============================================================
function autoDismissAlerts() {
  document.querySelectorAll('.alert[data-auto-dismiss]').forEach(alert => {
    const delay = parseInt(alert.dataset.autoDismiss || 4000, 10);
    setTimeout(() => {
      alert.style.opacity = '0';
      alert.style.transform = 'translateY(-10px)';
      alert.style.transition = 'all 0.3s ease';
      setTimeout(() => alert.remove(), 300);
    }, delay);
  });
}

// ============================================================
// 8. NAVBAR MOBILE HAMBURGER
// ============================================================
function setupNavbar() {
  const toggle = document.getElementById('navbarToggle');
  const nav    = document.getElementById('navbarNav');
  if (!toggle || !nav) return;
  toggle.addEventListener('click', () => nav.classList.toggle('open'));
}

// ============================================================
// 9. SIDEBAR MOBILE TOGGLE
// ============================================================
function setupSidebar() {
  const toggle  = document.getElementById('sidebarToggle');
  const sidebar = document.getElementById('sidebar');
  if (!toggle || !sidebar) return;
  toggle.addEventListener('click', () => sidebar.classList.toggle('open'));
}

// ============================================================
// 10. PLATFORM ICON HELPER (used inline in JSPs too)
// ============================================================
function getPlatformIcon(platform) {
  const icons = {
    'Instagram': '\u{1f4f8}',
    'YouTube':   '\u25b6\ufe0f',
    'Josh':      '\u{1f3b5}',
    'ShareChat': '\u{1f4ac}',
    'Moj':       '\u{1f3ac}'
  };
  return icons[platform] || '\u{1f4f1}';
}

function getPlatformClass(platform) {
  const classes = {
    'Instagram': 'plat-instagram',
    'YouTube':   'plat-youtube',
    'Josh':      'plat-josh',
    'ShareChat': 'plat-sharechat',
    'Moj':       'plat-moj'
  };
  return classes[platform] || '';
}

// ============================================================
// INIT \u2014 runs when DOM is ready
// ============================================================
document.addEventListener('DOMContentLoaded', function () {
  // Read saved language preference
  const savedLang = localStorage.getItem('rk_lang') || document.documentElement.lang || 'en';
  applyLanguage(savedLang);

  // Language toggle buttons (data-lang attribute on the buttons)
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.addEventListener('click', function () {
      const lang = this.dataset.lang;
      applyLanguage(lang);
      // Also POST to server to persist in session + DB
      const form = document.getElementById('langForm');
      if (form) {
        form.querySelector('[name="lang"]').value = lang;
        form.submit();
      }
    });
  });

  attachWhatsAppButtons();
  animateCounters();
  setupFormValidation();
  autoDismissAlerts();
  setupNavbar();
  setupSidebar();

  // Fade in main cards
  document.querySelectorAll('.card, .stat-card').forEach((el, i) => {
    el.style.animationDelay = `${i * 0.05}s`;
    el.classList.add('fade-in');
  });
});
