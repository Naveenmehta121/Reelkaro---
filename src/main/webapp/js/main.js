/**
 * ReelKaro — main.js
 * Handles:
 *  1. Language toggle (Hindi ↔ English) with a JS translation map
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
    "hero.eyebrow":     "🇮🇳 India's #1 Creator Marketplace",
    "hero.title.part1": "Where Brands Meet",
    "hero.title.part2": "India's Creators",
    "hero.desc":        "Post campaigns. Apply as a creator. Earn real money in INR. ReelKaro connects brands with Instagram, YouTube, Josh & ShareChat creators across India.",
    "hero.cta.brand":   "I'm a Brand →",
    "hero.cta.creator": "I'm a Creator →",
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
    "how.creator.step3":  "Post content & earn ₹₹₹",

    // Common buttons
    "btn.apply":        "Apply Now",
    "btn.applied":      "Applied ✓",
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
    "form.budget":          "Total Budget (₹)",
    "form.reward":          "Reward per Creator (₹)",
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
    "filter.min.reward":  "Min Reward (₹)",
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
    "nav.home":         "होम",
    "nav.browse":       "अभियान देखें",
    "nav.login":        "लॉगिन",
    "nav.register":     "रजिस्टर",
    "nav.dashboard":    "डैशबोर्ड",
    "nav.campaigns":    "मेरे अभियान",
    "nav.post":         "अभियान पोस्ट करें",
    "nav.applications": "आवेदन",
    "nav.earnings":     "कमाई",
    "nav.leaderboard":  "लीडरबोर्ड",
    "nav.profile":      "प्रोफ़ाइल",
    "nav.logout":       "लॉगआउट",

    // Hero
    "hero.eyebrow":     "🇮🇳 भारत का नंबर 1 क्रिएटर मार्केटप्लेस",
    "hero.title.part1": "ब्रांड्स मिलते हैं",
    "hero.title.part2": "भारत के क्रिएटर्स से",
    "hero.desc":        "अभियान पोस्ट करें। क्रिएटर के रूप में अप्लाई करें। INR में असली पैसे कमाएं। ReelKaro ब्रांड्स को Instagram, YouTube, Josh और ShareChat क्रिएटर्स से जोड़ता है।",
    "hero.cta.brand":   "मैं एक ब्रांड हूँ →",
    "hero.cta.creator": "मैं एक क्रिएटर हूँ →",
    "hero.stat.creators": "क्रिएटर्स",
    "hero.stat.brands":   "ब्रांड्स",
    "hero.stat.campaigns":"अभियान",
    "hero.stat.paid":     "भुगतान हुआ",

    // How it works
    "how.title":          "ReelKaro कैसे काम करता है",
    "how.brand.title":    "ब्रांड्स के लिए",
    "how.creator.title":  "क्रिएटर्स के लिए",
    "how.brand.step1":    "बजट और आवश्यकताओं के साथ अभियान पोस्ट करें",
    "how.brand.step2":    "क्रिएटर आवेदनों की समीक्षा करें",
    "how.brand.step3":    "कंटेंट अप्रूव करें और क्रिएटर को पुरस्कृत करें",
    "how.creator.step1":  "खुले अभियान ब्राउज़ करें",
    "how.creator.step2":  "अप्लाई करें और अप्रूव हों",
    "how.creator.step3":  "कंटेंट पोस्ट करें और ₹₹₹ कमाएं",

    // Common buttons
    "btn.apply":        "अभी अप्लाई करें",
    "btn.applied":      "अप्लाई हो गया ✓",
    "btn.view":         "विवरण देखें",
    "btn.share":        "WhatsApp पर शेयर करें",
    "btn.submit":       "कंटेंट सबमिट करें",
    "btn.save":         "बदलाव सहेजें",
    "btn.post":         "अभियान पोस्ट करें",
    "btn.approve":      "अप्रूव करें",
    "btn.reject":       "रिजेक्ट करें",
    "btn.pause":        "रोकें",
    "btn.close":        "बंद करें",
    "btn.reopen":       "फिर खोलें",
    "btn.save.upi":     "UPI ID सहेजें",

    // Campaign card labels
    "card.reward":      "इनाम",
    "card.deadline":    "अंतिम तिथि",
    "card.applicants":  "आवेदनकर्ता",
    "card.platform":    "प्लेटफ़ॉर्म",
    "card.category":    "श्रेणी",
    "card.budget":      "कुल बजट",
    "card.max":         "अधिकतम क्रिएटर",
    "card.status":      "स्थिति",

    // Dashboard
    "dash.welcome":         "वापस स्वागत है",
    "dash.active.camps":    "सक्रिय अभियान",
    "dash.total.apps":      "कुल आवेदन",
    "dash.total.spent":     "कुल खर्च",
    "dash.approval.rate":   "अप्रूवल दर",
    "dash.total.earned":    "कुल कमाई",
    "dash.pending.apps":    "लंबित आवेदन",
    "dash.approved.subs":   "अप्रूव सबमिशन",
    "dash.rank":            "लीडरबोर्ड रैंक",

    // Forms
    "form.name":            "पूरा नाम",
    "form.email":           "ईमेल पता",
    "form.password":        "पासवर्ड",
    "form.confirm":         "पासवर्ड की पुष्टि करें",
    "form.company":         "कंपनी का नाम",
    "form.industry":        "उद्योग",
    "form.website":         "वेबसाइट (वैकल्पिक)",
    "form.gst":             "GST नंबर (वैकल्पिक)",
    "form.username":        "क्रिएटर यूज़रनेम",
    "form.niche":           "कंटेंट निच",
    "form.instagram":       "Instagram हैंडल",
    "form.youtube":         "YouTube चैनल",
    "form.josh":            "Josh हैंडल",
    "form.sharechat":       "ShareChat हैंडल",
    "form.followers":       "कुल फॉलोअर्स",
    "form.city":            "शहर",
    "form.state":           "राज्य",
    "form.bio":             "बायो",
    "form.title":           "अभियान शीर्षक",
    "form.desc":            "विवरण",
    "form.platform":        "प्लेटफ़ॉर्म",
    "form.category":        "श्रेणी",
    "form.budget":          "कुल बजट (₹)",
    "form.reward":          "प्रति क्रिएटर इनाम (₹)",
    "form.max":             "अधिकतम क्रिएटर",
    "form.deadline":        "आवेदन की अंतिम तिथि",
    "form.content.link":    "कंटेंट URL / पोस्ट लिंक",
    "form.platform.posted": "पोस्ट किया गया प्लेटफ़ॉर्म",
    "form.upi":             "UPI ID",
    "form.feedback":        "फीडबैक (वैकल्पिक)",

    // Misc
    "payout.coming":      "भुगतान जल्द आएगा",
    "no.campaigns":       "कोई अभियान नहीं मिला।",
    "no.apps":            "अभी तक कोई आवेदन नहीं।",
    "no.rewards":         "अभी तक कोई इनाम नहीं।",
    "filter.platform":    "प्लेटफ़ॉर्म से फ़िल्टर करें",
    "filter.category":    "श्रेणी से फ़िल्टर करें",
    "filter.min.reward":  "न्यूनतम इनाम (₹)",
    "filter.sort":        "क्रमबद्ध करें",
    "sort.newest":        "नवीनतम पहले",
    "sort.highest":       "सबसे ज़्यादा इनाम",
    "leaderboard.title":  "शीर्ष क्रिएटर लीडरबोर्ड",
    "leaderboard.rank":   "रैंक",
    "leaderboard.creator":"क्रिएटर",
    "leaderboard.city":   "शहर",
    "leaderboard.niche":  "निच",
    "leaderboard.earned": "कुल कमाई",
    "leaderboard.approved":"अप्रूव पोस्ट",
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
        const prefix = el.dataset.prefix || '';
        const suffix = el.dataset.suffix || '';
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
  }, { threshold: 0.3 });

  counters.forEach(c => observer.observe(c));
}

// ============================================================
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
  const icons = { error: '❌', success: '✅', info: 'ℹ️', warning: '⚠️' };
  return icons[type] || 'ℹ️';
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
    'Instagram': '📸',
    'YouTube':   '▶️',
    'Josh':      '🎵',
    'ShareChat': '💬',
    'Moj':       '🎬'
  };
  return icons[platform] || '📱';
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
// INIT — runs when DOM is ready
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
