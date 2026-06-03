# ReelKaro — India's First Creator-Brand Campaign Marketplace

A production-ready Java EE web application where brands post campaigns and content creators earn rewards in INR by posting branded content on Instagram, YouTube, Josh, ShareChat, and Moj.

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Pure HTML5, CSS3, JavaScript (no frameworks) |
| Backend | Java Servlets + JSP (Jakarta EE 10) |
| Database | MySQL 8.x with JDBC |
| Server | Apache Tomcat 10.x |
| Build | Maven |
| Deploy (Backend) | Render |
| Deploy (Static) | Netlify (optional for static assets) |

---

## 📁 Project Structure

```
ReelKaro/
├── pom.xml                                 ← Maven build file
├── database/
│   └── schema.sql                          ← Full DB schema + seed data
├── src/main/java/com/reelkaro/
│   ├── filters/
│   │   └── CharacterEncodingFilter.java    ← UTF-8 for Hindi support
│   ├── utils/
│   │   ├── DBConnection.java               ← JDBC connection (env vars)
│   │   ├── HashUtil.java                   ← SHA-256 password hashing
│   │   └── SessionUtil.java                ← Session management + role guards
│   ├── models/
│   │   ├── User.java
│   │   ├── Campaign.java
│   │   ├── Application.java
│   │   ├── Submission.java
│   │   └── Reward.java
│   ├── dao/
│   │   ├── UserDAO.java
│   │   ├── CampaignDAO.java
│   │   ├── ApplicationDAO.java
│   │   └── RewardDAO.java
│   └── servlets/
│       ├── RegisterBrandServlet.java
│       ├── RegisterCreatorServlet.java
│       ├── LoginServlet.java
│       ├── LogoutServlet.java
│       ├── PostCampaignServlet.java
│       ├── EditCampaignServlet.java
│       ├── ApplyServlet.java
│       ├── SubmitContentServlet.java
│       ├── ApproveRejectServlet.java
│       ├── RewardServlet.java
│       ├── LeaderboardServlet.java
│       ├── ProfileServlet.java
│       ├── FilterCampaignServlet.java
│       └── LanguageServlet.java
└── src/main/webapp/
    ├── index.jsp                           ← Public landing page
    ├── login.jsp
    ├── register-brand.jsp
    ├── register-creator.jsp
    ├── brand/
    │   ├── dashboard.jsp
    │   ├── post-campaign.jsp               ← Also used for editing
    │   ├── my-campaigns.jsp
    │   ├── campaign-detail.jsp
    │   └── profile.jsp
    ├── creator/
    │   ├── dashboard.jsp
    │   ├── browse.jsp
    │   ├── apply.jsp
    │   ├── my-applications.jsp
    │   ├── submit.jsp
    │   ├── earnings.jsp
    │   ├── leaderboard.jsp
    │   └── profile.jsp
    ├── css/
    │   └── style.css                       ← Single global stylesheet
    ├── js/
    │   └── main.js                         ← Language toggle, validation, WhatsApp
    └── WEB-INF/
        └── web.xml
```

---

## ⚙️ Local Setup

### Prerequisites
- **Java 17+** — [Download](https://adoptium.net/)
- **Maven 3.9+** — [Download](https://maven.apache.org/)
- **MySQL 8.0+** — [Download](https://dev.mysql.com/downloads/)
- **Apache Tomcat 10.1+** — [Download](https://tomcat.apache.org/download-10.cgi)

### Step 1: Clone / Open the project

```bash
cd "d:\ete\Reelkero - indias first clipping platform"
```

### Step 2: Set up the MySQL database

```bash
# Log in to MySQL
mysql -u root -p

# Run the schema file
source database/schema.sql;

# Verify tables
USE reelkaro;
SHOW TABLES;
```

Expected tables:
- `users`, `brand_profiles`, `creator_profiles`
- `campaigns`, `applications`, `submissions`, `rewards`
- `leaderboard_view` (view, auto-computed)

### Step 3: Configure environment variables

Set these environment variables before starting Tomcat:

**Windows (Command Prompt):**
```cmd
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=reelkaro
set DB_USER=root
set DB_PASSWORD=your_mysql_password
```

**Windows (PowerShell):**
```powershell
$env:DB_HOST="localhost"
$env:DB_PORT="3306"
$env:DB_NAME="reelkaro"
$env:DB_USER="root"
$env:DB_PASSWORD="your_mysql_password"
```

**Linux/Mac:**
```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=reelkaro
export DB_USER=root
export DB_PASSWORD=your_mysql_password
```

### Step 4: Build the WAR file

```bash
mvn clean package
```

This produces: `target/reelkaro.war`

### Step 5: Deploy to Tomcat

1. Copy `target/reelkaro.war` into Tomcat's `webapps/` directory
2. Start Tomcat:
   ```bash
   # Windows
   %CATALINA_HOME%\bin\startup.bat
   
   # Linux/Mac
   $CATALINA_HOME/bin/startup.sh
   ```
3. Open your browser: `http://localhost:8080/reelkaro/`

---

## 🌐 Demo Credentials (from seed data)

| Role | Email | Password |
|------|-------|----------|
| Brand | brand@demo.com | password123 |
| Creator | creator@demo.com | password123 |

---

## 🔒 Security Notes

- Passwords are stored as **SHA-256 hex hashes** — never plaintext
- Session-based auth: brand routes block creators and vice versa
- Server-side validation on ALL forms (client-side validation is for UX only)
- Database uses prepared statements throughout — **no SQL injection possible**
- UTF-8 encoding filter ensures safe Devanagari/Hindi text storage

---

## 📱 Features Summary

### For Brands
- Register with company info, GST number, industry
- Post campaigns with platform, category, budget (₹), reward per creator (₹)
- Review creator applications — approve/reject
- Review submitted content — approve/reject with feedback
- Pause or close campaigns at any time
- Dashboard with stats: active campaigns, total applications, amount spent (₹), approval rate

### For Creators
- Register with social handles (Instagram, YouTube, Josh, ShareChat)
- Browse and filter open campaigns by platform, category, min reward
- Apply with one click — button changes to "Applied" after
- Submit content link after application is approved
- Track all applications and their status
- Earnings page with total ₹ earned, UPI ID input, payout status
- Leaderboard page showing top 20 creators with city, niche, and earnings

### Platform-wide
- Hindi ↔ English language toggle on every page (saved in session + DB)
- WhatsApp share button on every campaign card
- Animated stats counter on landing page
- Responsive mobile-first design — Indian color palette (saffron, white, green)

---

## ☁️ Render Deployment (Backend)

### Step 1: Push to GitHub

```bash
git init
git add .
git commit -m "Initial ReelKaro application"
git remote add origin https://github.com/yourname/reelkaro.git
git push -u origin main
```

### Step 2: Create Render Web Service

1. Go to [render.com](https://render.com) → New → Web Service
2. Connect your GitHub repository
3. Settings:
   - **Runtime**: Docker (or Java)
   - **Build Command**: `mvn clean package -DskipTests`
   - **Start Command**: (use a Dockerfile or Render's Tomcat environment)

### Step 3: Add a Render-managed MySQL database

1. Render → New → PostgreSQL (or use PlanetScale/Railway for MySQL)
2. Copy the connection string components

### Step 4: Set Environment Variables in Render

In your Render service dashboard → Environment:

```
DB_HOST     = <your render mysql host>
DB_PORT     = 3306
DB_NAME     = reelkaro
DB_USER     = <your db user>
DB_PASSWORD = <your db password>
```

### Step 5: Dockerfile (for Render with Tomcat)

Create a `Dockerfile` in project root:

```dockerfile
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jre17
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/reelkaro.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

---

## 💳 Razorpay Integration (Placeholder)

The earnings page shows a **"Payout Coming Soon"** badge. To activate:

1. Add Razorpay Java SDK to `pom.xml`
2. Create a `PayoutServlet.java`
3. In `RewardServlet.java`, replace the UPI save logic with a Razorpay payout API call
4. Razorpay Payouts API: `POST /v1/payouts` with UPI contact

---

## 🧪 Testing the Application

1. **Register a brand** at `/register-brand.jsp`
2. **Post a campaign** from brand dashboard
3. **Register a creator** at `/register-creator.jsp`
4. **Browse and apply** to the campaign
5. **Login as brand**, go to campaign detail, approve the application
6. **Login as creator**, submit content link
7. **Login as brand**, approve the submission — reward auto-created
8. **Check creator earnings** — reward appears in ledger
9. **Visit leaderboard** — creator appears in rankings

---

## 📜 License

MIT License — Free to use, fork, and modify for educational and commercial purposes.

---

*Made with ❤️ for Bharat's creators* 🇮🇳
