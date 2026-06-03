-- ============================================================
-- ReelKaro Database Schema
-- India's First Creator-Brand Campaign Marketplace
-- ============================================================

CREATE DATABASE IF NOT EXISTS reelkaro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE reelkaro;

-- ============================================================
-- USERS TABLE
-- Stores all registered users (brands and creators)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150)  NOT NULL,
    email         VARCHAR(255)  NOT NULL UNIQUE,
    password_hash VARCHAR(64)   NOT NULL,          -- SHA-256 hex string
    role          ENUM('brand','creator') NOT NULL,
    language_pref ENUM('en','hi') NOT NULL DEFAULT 'en',
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- BRAND PROFILES TABLE
-- Extended info for users with role = 'brand'
-- ============================================================
CREATE TABLE IF NOT EXISTS brand_profiles (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT          NOT NULL UNIQUE,
    company_name VARCHAR(200) NOT NULL,
    industry     VARCHAR(100),
    website      VARCHAR(255),
    gst_number   VARCHAR(20),
    verified     BOOLEAN      DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- CREATOR PROFILES TABLE
-- Extended info for users with role = 'creator'
-- ============================================================
CREATE TABLE IF NOT EXISTS creator_profiles (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    user_id           INT          NOT NULL UNIQUE,
    username          VARCHAR(100) NOT NULL,
    niche             VARCHAR(100),
    instagram_handle  VARCHAR(100),
    youtube_handle    VARCHAR(100),
    josh_handle       VARCHAR(100),
    sharechat_handle  VARCHAR(100),
    followers_count   INT          DEFAULT 0,
    city              VARCHAR(100),
    state             VARCHAR(100),
    bio               TEXT,
    profile_pic_url   VARCHAR(500),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- CAMPAIGNS TABLE
-- Campaigns posted by brands
-- ============================================================
CREATE TABLE IF NOT EXISTS campaigns (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    brand_id              INT NOT NULL,                         -- references users.id (role=brand)
    title                 VARCHAR(300) NOT NULL,
    description           TEXT         NOT NULL,
    platform              ENUM('Instagram','YouTube','Josh','ShareChat','Moj') NOT NULL,
    category              VARCHAR(100),
    budget_inr            DECIMAL(12,2) NOT NULL,
    reward_per_creator_inr DECIMAL(10,2) NOT NULL,
    max_creators          INT          DEFAULT 10,
    deadline              DATE         NOT NULL,
    status                ENUM('open','closed','paused') DEFAULT 'open',
    created_at            TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- APPLICATIONS TABLE
-- Creator applications to campaigns
-- ============================================================
CREATE TABLE IF NOT EXISTS applications (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    creator_id  INT NOT NULL,                               -- references users.id (role=creator)
    status      ENUM('pending','approved','rejected') DEFAULT 'pending',
    applied_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_application (campaign_id, creator_id),-- prevent duplicate applies
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (creator_id)  REFERENCES users(id)     ON DELETE CASCADE
);

-- ============================================================
-- SUBMISSIONS TABLE
-- Content submitted by creators after approval
-- ============================================================
CREATE TABLE IF NOT EXISTS submissions (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    application_id   INT NOT NULL UNIQUE,
    content_link     VARCHAR(500) NOT NULL,
    platform_posted  VARCHAR(50),
    submitted_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    approval_status  ENUM('pending','approved','rejected') DEFAULT 'pending',
    feedback         TEXT,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE
);

-- ============================================================
-- REWARDS TABLE
-- Monetary rewards for approved submissions
-- ============================================================
CREATE TABLE IF NOT EXISTS rewards (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    creator_id     INT           NOT NULL,
    campaign_id    INT           NOT NULL,
    amount_inr     DECIMAL(10,2) NOT NULL,
    payout_status  ENUM('pending','processing','paid') DEFAULT 'pending',
    upi_id         VARCHAR(100),
    awarded_at     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creator_id)  REFERENCES users(id)     ON DELETE CASCADE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
);

-- ============================================================
-- LEADERBOARD VIEW
-- Auto-computed ranking of creators by earnings
-- ============================================================
CREATE OR REPLACE VIEW leaderboard_view AS
SELECT
    r.creator_id,
    u.name                              AS creator_name,
    cp.username,
    cp.city,
    cp.state,
    cp.niche,
    SUM(r.amount_inr)                   AS total_earned_inr,
    COUNT(r.id)                         AS total_approved,
    RANK() OVER (ORDER BY SUM(r.amount_inr) DESC) AS rank_position
FROM rewards r
JOIN users          u  ON u.id  = r.creator_id
JOIN creator_profiles cp ON cp.user_id = r.creator_id
WHERE r.payout_status IN ('pending','processing','paid')
GROUP BY r.creator_id, u.name, cp.username, cp.city, cp.state, cp.niche;

-- ============================================================
-- SAMPLE SEED DATA (optional, for testing)
-- ============================================================
-- Insert a demo brand user (password: 'password123' SHA-256)
INSERT IGNORE INTO users (name, email, password_hash, role) VALUES
('Demo Brand',   'brand@demo.com',   'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'brand'),
('Demo Creator', 'creator@demo.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'creator');

INSERT IGNORE INTO brand_profiles (user_id, company_name, industry, website) VALUES
(1, 'Demo Brand Pvt. Ltd.', 'FMCG', 'https://demobrand.in');

INSERT IGNORE INTO creator_profiles (user_id, username, niche, instagram_handle, city, state, followers_count, bio) VALUES
(2, 'demo_creator', 'Lifestyle', '@democreator', 'Mumbai', 'Maharashtra', 50000, 'Lifestyle creator from Mumbai.');
