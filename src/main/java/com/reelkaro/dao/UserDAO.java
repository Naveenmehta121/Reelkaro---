package com.reelkaro.dao;

import com.reelkaro.models.User;
import com.reelkaro.utils.DBConnection;

import java.sql.*;

/**
 * UserDAO — All database operations related to users, brands, and creators.
 *
 * Uses try-with-resources for every Connection/Statement/ResultSet
 * to ensure resources are always closed, even on exception.
 */
public class UserDAO {

    // ============================================================
    // USER REGISTRATION
    // ============================================================

    /**
     * Insert a new user into the `users` table.
     * @return the auto-generated user ID, or -1 on failure.
     */
    public int insertUser(String name, String email, String passwordHash, String role) throws SQLException {
        String sql = "INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setString(4, role);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /**
     * Insert a brand profile row linked to the given userId.
     */
    public void insertBrandProfile(int userId, String companyName, String industry,
                                   String website, String gstNumber) throws SQLException {
        String sql = "INSERT INTO brand_profiles (user_id, company_name, industry, website, gst_number) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt   (1, userId);
            ps.setString(2, companyName);
            ps.setString(3, industry);
            ps.setString(4, website);
            ps.setString(5, gstNumber);
            ps.executeUpdate();
        }
    }

    /**
     * Insert a creator profile row linked to the given userId.
     */
    public void insertCreatorProfile(int userId, String username, String niche,
                                     String instagram, String youtube, String josh,
                                     String sharechat, int followersCount,
                                     String city, String state, String bio) throws SQLException {
        String sql = "INSERT INTO creator_profiles " +
                     "(user_id, username, niche, instagram_handle, youtube_handle, josh_handle, " +
                     "sharechat_handle, followers_count, city, state, bio) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt   (1, userId);
            ps.setString(2, username);
            ps.setString(3, niche);
            ps.setString(4, instagram);
            ps.setString(5, youtube);
            ps.setString(6, josh);
            ps.setString(7, sharechat);
            ps.setInt   (8, followersCount);
            ps.setString(9, city);
            ps.setString(10, state);
            ps.setString(11, bio);
            ps.executeUpdate();
        }
    }

    // ============================================================
    // AUTHENTICATION
    // ============================================================

    /**
     * Find a user by email and password hash.
     * Returns the User object if found, null otherwise.
     */
    public User findByEmailAndPassword(String email, String passwordHash) throws SQLException {
        String sql = "SELECT id, name, email, role, language_pref FROM users " +
                     "WHERE email = ? AND password_hash = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId          (rs.getInt   ("id"));
                    u.setName        (rs.getString("name"));
                    u.setEmail       (rs.getString("email"));
                    u.setRole        (rs.getString("role"));
                    u.setLanguagePref(rs.getString("language_pref"));
                    return u;
                }
            }
        }
        return null;
    }

    /**
     * Check whether an email is already registered.
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ============================================================
    // PROFILE UPDATES
    // ============================================================

    /**
     * Update the language preference for a user.
     */
    public void updateLanguagePref(int userId, String lang) throws SQLException {
        String sql = "UPDATE users SET language_pref = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, lang);
            ps.setInt   (2, userId);
            ps.executeUpdate();
        }
    }

    /**
     * Update brand profile fields.
     */
    public void updateBrandProfile(int userId, String companyName, String industry,
                                   String website, String gstNumber) throws SQLException {
        String sql = "UPDATE brand_profiles SET company_name=?, industry=?, website=?, gst_number=? " +
                     "WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, companyName);
            ps.setString(2, industry);
            ps.setString(3, website);
            ps.setString(4, gstNumber);
            ps.setInt   (5, userId);
            ps.executeUpdate();
        }
    }

    /**
     * Update creator profile fields.
     */
    public void updateCreatorProfile(int userId, String username, String niche,
                                     String instagram, String youtube, String josh,
                                     String sharechat, int followersCount,
                                     String city, String state, String bio) throws SQLException {
        String sql = "UPDATE creator_profiles SET username=?, niche=?, instagram_handle=?, " +
                     "youtube_handle=?, josh_handle=?, sharechat_handle=?, " +
                     "followers_count=?, city=?, state=?, bio=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, niche);
            ps.setString(3, instagram);
            ps.setString(4, youtube);
            ps.setString(5, josh);
            ps.setString(6, sharechat);
            ps.setInt   (7, followersCount);
            ps.setString(8, city);
            ps.setString(9, state);
            ps.setString(10, bio);
            ps.setInt   (11, userId);
            ps.executeUpdate();
        }
    }

    // ============================================================
    // PROFILE READS
    // ============================================================

    /**
     * Returns a ResultSet row as java.sql.ResultSet for brand profile data.
     * Caller uses the returned value to populate a Map or directly in JSP.
     * To keep DAO simple, we return a lightweight String array:
     * [0]=company_name, [1]=industry, [2]=website, [3]=gst_number, [4]=verified
     */
    public String[] getBrandProfile(int userId) throws SQLException {
        String sql = "SELECT company_name, industry, website, gst_number, verified " +
                     "FROM brand_profiles WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[]{
                        rs.getString("company_name"),
                        rs.getString("industry"),
                        rs.getString("website"),
                        rs.getString("gst_number"),
                        String.valueOf(rs.getBoolean("verified"))
                    };
                }
            }
        }
        return null;
    }

    /**
     * Returns creator profile data as a String array.
     * [0]=username [1]=niche [2]=instagram [3]=youtube [4]=josh
     * [5]=sharechat [6]=followers_count [7]=city [8]=state [9]=bio
     */
    public String[] getCreatorProfile(int userId) throws SQLException {
        String sql = "SELECT username, niche, instagram_handle, youtube_handle, josh_handle, " +
                     "sharechat_handle, followers_count, city, state, bio " +
                     "FROM creator_profiles WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[]{
                        rs.getString("username"),
                        rs.getString("niche"),
                        rs.getString("instagram_handle"),
                        rs.getString("youtube_handle"),
                        rs.getString("josh_handle"),
                        rs.getString("sharechat_handle"),
                        String.valueOf(rs.getInt("followers_count")),
                        rs.getString("city"),
                        rs.getString("state"),
                        rs.getString("bio")
                    };
                }
            }
        }
        return null;
    }

    /**
     * Get a user's display name by ID.
     */
    public String getUserName(int userId) throws SQLException {
        String sql = "SELECT name FROM users WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("name");
            }
        }
        return "";
    }
}
