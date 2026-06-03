package com.reelkaro.dao;

import com.reelkaro.models.Application;
import com.reelkaro.models.Submission;
import com.reelkaro.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ApplicationDAO — Handles all DB operations for applications and submissions.
 *
 * Applications  → creators apply to campaigns
 * Submissions   → creators submit content after approval
 */
public class ApplicationDAO {

    // ============================================================
    // APPLICATIONS
    // ============================================================

    /**
     * Insert a new application. Returns generated ID, or -1 on failure.
     * The UNIQUE constraint (campaign_id, creator_id) prevents duplicates.
     */
    public int insertApplication(int campaignId, int creatorId) throws SQLException {
        String sql = "INSERT IGNORE INTO applications (campaign_id, creator_id) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, campaignId);
            ps.setInt(2, creatorId);
            int affected = ps.executeUpdate();
            if (affected == 0) return -1; // duplicate — INSERT IGNORE silently skipped it
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /**
     * Check whether a creator has already applied to a campaign.
     */
    public boolean hasApplied(int campaignId, int creatorId) throws SQLException {
        String sql = "SELECT id FROM applications WHERE campaign_id=? AND creator_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            ps.setInt(2, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Get the status of an application (or null if not applied).
     */
    public String getApplicationStatus(int campaignId, int creatorId) throws SQLException {
        String sql = "SELECT status FROM applications WHERE campaign_id=? AND creator_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            ps.setInt(2, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("status");
            }
        }
        return null;
    }

    /**
     * Get application ID for a given campaign + creator pair.
     */
    public int getApplicationId(int campaignId, int creatorId) throws SQLException {
        String sql = "SELECT id FROM applications WHERE campaign_id=? AND creator_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            ps.setInt(2, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }
        return -1;
    }

    /**
     * Update the status of an application: pending | approved | rejected.
     */
    public void updateApplicationStatus(int applicationId, String status) throws SQLException {
        String sql = "UPDATE applications SET status=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, applicationId);
            ps.executeUpdate();
        }
    }

    /**
     * All applications for a specific campaign (brand view).
     * Joined with creator name, username.
     */
    public List<Application> getApplicationsByCampaign(int campaignId) throws SQLException {
        String sql = "SELECT a.*, u.name AS creator_name, cp.username AS creator_username " +
                     "FROM applications a " +
                     "JOIN users u ON u.id = a.creator_id " +
                     "LEFT JOIN creator_profiles cp ON cp.user_id = a.creator_id " +
                     "WHERE a.campaign_id = ? ORDER BY a.applied_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Application> list = new ArrayList<>();
                while (rs.next()) list.add(mapApplicationRow(rs));
                return list;
            }
        }
    }

    /**
     * All applications made by a specific creator (creator view).
     * Joined with campaign title and brand name.
     */
    public List<Application> getApplicationsByCreator(int creatorId) throws SQLException {
        String sql = "SELECT a.*, c.title AS campaign_title, u.name AS brand_name " +
                     "FROM applications a " +
                     "JOIN campaigns c ON c.id = a.campaign_id " +
                     "JOIN users u ON u.id = c.brand_id " +
                     "WHERE a.creator_id = ? ORDER BY a.applied_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Application> list = new ArrayList<>();
                while (rs.next()) {
                    Application app = mapApplicationRow(rs);
                    app.setCampaignTitle(rs.getString("campaign_title"));
                    list.add(app);
                }
                return list;
            }
        }
    }

    /**
     * Count pending applications for a creator.
     */
    public int countPendingApplications(int creatorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE creator_id=? AND status='pending'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ============================================================
    // SUBMISSIONS
    // ============================================================

    /**
     * Insert a content submission for an approved application.
     */
    public void insertSubmission(int applicationId, String contentLink,
                                  String platformPosted) throws SQLException {
        String sql = "INSERT INTO submissions (application_id, content_link, platform_posted) " +
                     "VALUES (?,?,?) ON DUPLICATE KEY UPDATE content_link=?, platform_posted=?, submitted_at=NOW()";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt   (1, applicationId);
            ps.setString(2, contentLink);
            ps.setString(3, platformPosted);
            ps.setString(4, contentLink);
            ps.setString(5, platformPosted);
            ps.executeUpdate();
        }
    }

    /**
     * Get submission for a given application ID.
     */
    public Submission getSubmissionByApplicationId(int applicationId) throws SQLException {
        String sql = "SELECT s.*, a.creator_id, a.campaign_id, c.title AS campaign_title, " +
                     "u.name AS creator_name " +
                     "FROM submissions s " +
                     "JOIN applications a ON a.id = s.application_id " +
                     "JOIN campaigns c ON c.id = a.campaign_id " +
                     "JOIN users u ON u.id = a.creator_id " +
                     "WHERE s.application_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapSubmissionRow(rs);
            }
        }
        return null;
    }

    /**
     * All submissions for a specific campaign (brand review page).
     */
    public List<Submission> getSubmissionsByCampaign(int campaignId) throws SQLException {
        String sql = "SELECT s.*, a.creator_id, a.campaign_id, c.title AS campaign_title, " +
                     "u.name AS creator_name " +
                     "FROM submissions s " +
                     "JOIN applications a ON a.id = s.application_id " +
                     "JOIN campaigns c ON c.id = a.campaign_id " +
                     "JOIN users u ON u.id = a.creator_id " +
                     "WHERE a.campaign_id = ? ORDER BY s.submitted_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, campaignId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Submission> list = new ArrayList<>();
                while (rs.next()) list.add(mapSubmissionRow(rs));
                return list;
            }
        }
    }

    /**
     * All submissions by a creator (for creator dashboard).
     */
    public List<Submission> getSubmissionsByCreator(int creatorId) throws SQLException {
        String sql = "SELECT s.*, a.creator_id, a.campaign_id, c.title AS campaign_title, " +
                     "u.name AS creator_name " +
                     "FROM submissions s " +
                     "JOIN applications a ON a.id = s.application_id " +
                     "JOIN campaigns c ON c.id = a.campaign_id " +
                     "JOIN users u ON u.id = a.creator_id " +
                     "WHERE a.creator_id = ? ORDER BY s.submitted_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Submission> list = new ArrayList<>();
                while (rs.next()) list.add(mapSubmissionRow(rs));
                return list;
            }
        }
    }

    /**
     * Update the approval status and optional feedback of a submission.
     */
    public void updateSubmissionStatus(int submissionId, String status, String feedback) throws SQLException {
        String sql = "UPDATE submissions SET approval_status=?, feedback=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, feedback);
            ps.setInt   (3, submissionId);
            ps.executeUpdate();
        }
    }

    /**
     * Count approved submissions for a creator (for dashboard stats).
     */
    public int countApprovedSubmissions(int creatorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM submissions s " +
                     "JOIN applications a ON a.id = s.application_id " +
                     "WHERE a.creator_id=? AND s.approval_status='approved'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ============================================================
    // PRIVATE MAPPERS
    // ============================================================

    private Application mapApplicationRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId           (rs.getInt   ("id"));
        a.setCampaignId   (rs.getInt   ("campaign_id"));
        a.setCreatorId    (rs.getInt   ("creator_id"));
        a.setStatus       (rs.getString("status"));
        a.setAppliedAt    (rs.getTimestamp("applied_at"));
        try { a.setCreatorName    (rs.getString("creator_name")); } catch (SQLException ignore) {}
        try { a.setCreatorUsername(rs.getString("creator_username")); } catch (SQLException ignore) {}
        return a;
    }

    private Submission mapSubmissionRow(ResultSet rs) throws SQLException {
        Submission s = new Submission();
        s.setId            (rs.getInt   ("id"));
        s.setApplicationId (rs.getInt   ("application_id"));
        s.setCampaignId    (rs.getInt   ("campaign_id"));
        s.setCreatorId     (rs.getInt   ("creator_id"));
        s.setContentLink   (rs.getString("content_link"));
        s.setPlatformPosted(rs.getString("platform_posted"));
        s.setSubmittedAt   (rs.getTimestamp("submitted_at"));
        s.setApprovalStatus(rs.getString("approval_status"));
        s.setFeedback      (rs.getString("feedback"));
        try { s.setCampaignTitle(rs.getString("campaign_title")); } catch (SQLException ignore) {}
        try { s.setCreatorName  (rs.getString("creator_name"));   } catch (SQLException ignore) {}
        return s;
    }
}
