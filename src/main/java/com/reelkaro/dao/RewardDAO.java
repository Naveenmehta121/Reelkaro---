package com.reelkaro.dao;

import com.reelkaro.models.Reward;
import com.reelkaro.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * RewardDAO — Database operations for the `rewards` table
 * and the `leaderboard_view`.
 *
 * A reward row is auto-created whenever a brand approves a submission.
 * Creators can attach their UPI ID for future Razorpay payouts.
 */
public class RewardDAO {

    // ============================================================
    // CREATE
    // ============================================================

    /**
     * Insert a reward record when a brand approves a submission.
     * If a reward already exists for this creator+campaign pair,
     * we silently skip (ON DUPLICATE KEY UPDATE does nothing).
     */
    public void insertReward(int creatorId, int campaignId, BigDecimal amountInr) throws SQLException {
        String sql = "INSERT IGNORE INTO rewards (creator_id, campaign_id, amount_inr) VALUES (?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt       (1, creatorId);
            ps.setInt       (2, campaignId);
            ps.setBigDecimal(3, amountInr);
            ps.executeUpdate();
        }
    }

    // ============================================================
    // READ
    // ============================================================

    /**
     * All rewards for a specific creator, joined with campaign title.
     */
    public List<Reward> getRewardsByCreator(int creatorId) throws SQLException {
        String sql = "SELECT r.*, c.title AS campaign_title " +
                     "FROM rewards r " +
                     "JOIN campaigns c ON c.id = r.campaign_id " +
                     "WHERE r.creator_id = ? ORDER BY r.awarded_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Reward> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    /**
     * Total earnings (sum of all reward amounts) for a creator.
     * Returns 0 if the creator has no rewards yet.
     */
    public BigDecimal getTotalEarnings(int creatorId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount_inr), 0) AS total FROM rewards WHERE creator_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }

    /**
     * Top 20 creators from the leaderboard_view, ordered by rank.
     * Returns a list of Object arrays:
     * [0]=rank, [1]=creator_name, [2]=username, [3]=city, [4]=state,
     * [5]=niche, [6]=total_earned_inr, [7]=total_approved
     */
    public List<Object[]> getLeaderboard() throws SQLException {
        String sql = "SELECT rank_position, creator_name, username, city, state, niche, " +
                     "total_earned_inr, total_approved " +
                     "FROM leaderboard_view ORDER BY rank_position LIMIT 20";
        List<Object[]> rows = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rows.add(new Object[]{
                    rs.getInt("rank_position"),
                    rs.getString("creator_name"),
                    rs.getString("username"),
                    rs.getString("city"),
                    rs.getString("state"),
                    rs.getString("niche"),
                    rs.getBigDecimal("total_earned_inr"),
                    rs.getInt("total_approved")
                });
            }
        }
        return rows;
    }

    /**
     * Get the leaderboard rank of a specific creator.
     * Returns 0 if they are not on the board yet.
     */
    public int getCreatorRank(int creatorId) throws SQLException {
        String sql = "SELECT rank_position FROM leaderboard_view WHERE creator_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("rank_position");
            }
        }
        return 0;
    }

    // ============================================================
    // UPDATE
    // ============================================================

    /**
     * Save a creator's UPI ID to their reward records.
     * All rewards for this creator get the same UPI ID.
     */
    public void updateUpiId(int creatorId, String upiId) throws SQLException {
        String sql = "UPDATE rewards SET upi_id=? WHERE creator_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, upiId);
            ps.setInt   (2, creatorId);
            ps.executeUpdate();
        }
    }

    /**
     * Update payout status for a specific reward record.
     */
    public void updatePayoutStatus(int rewardId, String status) throws SQLException {
        String sql = "UPDATE rewards SET payout_status=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, rewardId);
            ps.executeUpdate();
        }
    }

    // ============================================================
    // PRIVATE MAPPER
    // ============================================================

    private Reward mapRow(ResultSet rs) throws SQLException {
        Reward r = new Reward();
        r.setId           (rs.getInt       ("id"));
        r.setCreatorId    (rs.getInt       ("creator_id"));
        r.setCampaignId   (rs.getInt       ("campaign_id"));
        r.setAmountInr    (rs.getBigDecimal("amount_inr"));
        r.setPayoutStatus (rs.getString    ("payout_status"));
        r.setUpiId        (rs.getString    ("upi_id"));
        r.setAwardedAt    (rs.getTimestamp ("awarded_at"));
        try { r.setCampaignTitle(rs.getString("campaign_title")); } catch (SQLException ignore) {}
        return r;
    }
}
