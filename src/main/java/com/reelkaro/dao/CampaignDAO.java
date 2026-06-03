package com.reelkaro.dao;

import com.reelkaro.models.Campaign;
import com.reelkaro.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CampaignDAO — All database operations for the `campaigns` table.
 */
public class CampaignDAO {

    // ============================================================
    // CREATE
    // ============================================================

    /**
     * Insert a new campaign. Returns the new campaign ID.
     */
    public int insertCampaign(int brandId, String title, String description,
                               String platform, String category,
                               BigDecimal budgetInr, BigDecimal rewardPerCreator,
                               int maxCreators, String deadline) throws SQLException {
        String sql = "INSERT INTO campaigns " +
                     "(brand_id, title, description, platform, category, " +
                     "budget_inr, reward_per_creator_inr, max_creators, deadline, status) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,'open')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt       (1, brandId);
            ps.setString    (2, title);
            ps.setString    (3, description);
            ps.setString    (4, platform);
            ps.setString    (5, category);
            ps.setBigDecimal(6, budgetInr);
            ps.setBigDecimal(7, rewardPerCreator);
            ps.setInt       (8, maxCreators);
            ps.setString    (9, deadline);   // "YYYY-MM-DD" string
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    // ============================================================
    // READ — Single campaign
    // ============================================================

    /**
     * Fetch a single campaign by ID, joined with brand name and apply count.
     */
    public Campaign getCampaignById(int id) throws SQLException {
        String sql = "SELECT c.*, u.name AS brand_name, bp.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.campaign_id = c.id) AS apply_count " +
                     "FROM campaigns c " +
                     "JOIN users u ON u.id = c.brand_id " +
                     "LEFT JOIN brand_profiles bp ON bp.user_id = c.brand_id " +
                     "WHERE c.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // ============================================================
    // READ — Lists
    // ============================================================

    /**
     * All campaigns posted by a specific brand.
     */
    public List<Campaign> getCampaignsByBrand(int brandId) throws SQLException {
        String sql = "SELECT c.*, u.name AS brand_name, bp.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.campaign_id = c.id) AS apply_count " +
                     "FROM campaigns c " +
                     "JOIN users u ON u.id = c.brand_id " +
                     "LEFT JOIN brand_profiles bp ON bp.user_id = c.brand_id " +
                     "WHERE c.brand_id = ? ORDER BY c.created_at DESC";
        return queryList(sql, brandId);
    }

    /**
     * All open campaigns (for creator browse page).
     * Supports filtering by platform and category, and sorting.
     *
     * @param platform  filter value or null/"" to skip
     * @param category  filter value or null/"" to skip
     * @param minReward minimum reward filter (0 = no filter)
     * @param sortBy    "newest" | "highest_reward"
     */
    public List<Campaign> getOpenCampaigns(String platform, String category,
                                            BigDecimal minReward, String sortBy) throws SQLException {
        StringBuilder sb = new StringBuilder(
            "SELECT c.*, u.name AS brand_name, bp.company_name, " +
            "(SELECT COUNT(*) FROM applications a WHERE a.campaign_id = c.id) AS apply_count " +
            "FROM campaigns c " +
            "JOIN users u ON u.id = c.brand_id " +
            "LEFT JOIN brand_profiles bp ON bp.user_id = c.brand_id " +
            "WHERE c.status = 'open' AND c.deadline >= CURDATE() "
        );

        List<Object> params = new ArrayList<>();

        if (platform != null && !platform.isEmpty()) {
            sb.append("AND c.platform = ? ");
            params.add(platform);
        }
        if (category != null && !category.isEmpty()) {
            sb.append("AND c.category = ? ");
            params.add(category);
        }
        if (minReward != null && minReward.compareTo(BigDecimal.ZERO) > 0) {
            sb.append("AND c.reward_per_creator_inr >= ? ");
            params.add(minReward);
        }

        if ("highest_reward".equals(sortBy)) {
            sb.append("ORDER BY c.reward_per_creator_inr DESC");
        } else {
            sb.append("ORDER BY c.created_at DESC");
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) ps.setString(i + 1, (String) p);
                else if (p instanceof BigDecimal) ps.setBigDecimal(i + 1, (BigDecimal) p);
            }
            try (ResultSet rs = ps.executeQuery()) {
                List<Campaign> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    // ============================================================
    // UPDATE
    // ============================================================

    /**
     * Update campaign status: open, paused, or closed.
     */
    public void updateCampaignStatus(int campaignId, String status) throws SQLException {
        String sql = "UPDATE campaigns SET status=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, campaignId);
            ps.executeUpdate();
        }
    }

    /**
     * Edit campaign details (title, description, platform, category,
     * budget, reward, maxCreators, deadline).
     */
    public void updateCampaign(int campaignId, String title, String description,
                                String platform, String category, BigDecimal budget,
                                BigDecimal reward, int maxCreators, String deadline) throws SQLException {
        String sql = "UPDATE campaigns SET title=?, description=?, platform=?, category=?, " +
                     "budget_inr=?, reward_per_creator_inr=?, max_creators=?, deadline=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString    (1, title);
            ps.setString    (2, description);
            ps.setString    (3, platform);
            ps.setString    (4, category);
            ps.setBigDecimal(5, budget);
            ps.setBigDecimal(6, reward);
            ps.setInt       (7, maxCreators);
            ps.setString    (8, deadline);
            ps.setInt       (9, campaignId);
            ps.executeUpdate();
        }
    }

    // ============================================================
    // STATS for brand dashboard
    // ============================================================

    /**
     * Returns [active_count, total_applications, total_spent, approval_rate%]
     * as a String array for the brand dashboard stats cards.
     */
    public String[] getBrandStats(int brandId) throws SQLException {
        String sql =
            "SELECT " +
            "  (SELECT COUNT(*) FROM campaigns WHERE brand_id=? AND status='open') AS active_campaigns, " +
            "  (SELECT COUNT(*) FROM applications a JOIN campaigns c ON c.id=a.campaign_id WHERE c.brand_id=?) AS total_apps, " +
            "  COALESCE((SELECT SUM(amount_inr) FROM rewards r JOIN campaigns c ON c.id=r.campaign_id WHERE c.brand_id=?), 0) AS total_spent, " +
            "  COALESCE((SELECT ROUND(100.0 * COUNT(*) / NULLIF((" +
            "      SELECT COUNT(*) FROM submissions s2 " +
            "      JOIN applications a2 ON a2.id=s2.application_id " +
            "      JOIN campaigns c2 ON c2.id=a2.campaign_id WHERE c2.brand_id=?),0),2)" +
            "  FROM submissions s JOIN applications a ON a.id=s.application_id " +
            "  JOIN campaigns c ON c.id=a.campaign_id WHERE c.brand_id=? AND s.approval_status='approved'),0) AS approval_rate";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, brandId);
            ps.setInt(2, brandId);
            ps.setInt(3, brandId);
            ps.setInt(4, brandId);
            ps.setInt(5, brandId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[]{
                        rs.getString("active_campaigns"),
                        rs.getString("total_apps"),
                        rs.getString("total_spent"),
                        rs.getString("approval_rate")
                    };
                }
            }
        }
        return new String[]{"0","0","0","0"};
    }

    // ============================================================
    // PRIVATE HELPERS
    // ============================================================

    /** Map a ResultSet row to a Campaign object */
    private Campaign mapRow(ResultSet rs) throws SQLException {
        Campaign c = new Campaign();
        c.setId                 (rs.getInt   ("id"));
        c.setBrandId            (rs.getInt   ("brand_id"));
        c.setBrandName          (rs.getString("brand_name"));
        c.setCompanyName        (rs.getString("company_name"));
        c.setTitle              (rs.getString("title"));
        c.setDescription        (rs.getString("description"));
        c.setPlatform           (rs.getString("platform"));
        c.setCategory           (rs.getString("category"));
        c.setBudgetInr          (rs.getBigDecimal("budget_inr"));
        c.setRewardPerCreatorInr(rs.getBigDecimal("reward_per_creator_inr"));
        c.setMaxCreators        (rs.getInt   ("max_creators"));
        c.setDeadline           (rs.getDate  ("deadline"));
        c.setStatus             (rs.getString("status"));
        c.setCreatedAt          (rs.getTimestamp("created_at"));
        c.setApplyCount         (rs.getInt   ("apply_count"));
        return c;
    }

    /** Execute a query with one int parameter and map all rows to Campaign list */
    private List<Campaign> queryList(String sql, int param) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                List<Campaign> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }
}
