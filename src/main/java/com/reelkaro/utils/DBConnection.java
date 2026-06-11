package com.reelkaro.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — Singleton utility for MySQL JDBC connections.
 *
 * Reads connection parameters from environment variables so that
 * the same WAR can run locally and on Render without code changes.
 *
 * Environment variables required:
 *   DB_HOST     — e.g. "localhost" or your Render MySQL host
 *   DB_PORT     — e.g. "3306"
 *   DB_NAME     — e.g. "reelkaro"
 *   DB_USER     — e.g. "root"
 *   DB_PASSWORD — your MySQL password
 */
public class DBConnection {

    // ---------- Read from environment with sensible local defaults ----------
    private static final String HOST     = getEnv("DB_HOST",     "localhost");
    private static final String PORT     = getEnv("DB_PORT",     "3306");
    private static final String DB_NAME  = getEnv("DB_NAME",     "reelkaro");
    private static final String USER     = getEnv("DB_USER",     "root");
    private static final String PASSWORD = getEnv("DB_PASSWORD", "");

    // Use SSL for cloud hosts (Aiven, Railway, etc.), disable only for localhost
    private static final boolean IS_LOCAL = HOST.equals("localhost") || HOST.equals("127.0.0.1");
    private static final String JDBC_URL =
            "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB_NAME
            + "?useSSL=" + (!IS_LOCAL)
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=Asia/Kolkata"
            + "&characterEncoding=utf8"
            + "&connectTimeout=5000"
            + "&socketTimeout=30000"
            + "&autoReconnect=true"
            + "&failOverReadOnly=false";

    // Static initializer: load the MySQL JDBC driver once when class loads
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[DBConnection] JDBC URL: " + JDBC_URL);
            System.out.println("[DBConnection] User: " + USER + " | DB: " + DB_NAME + " | Host: " + HOST + ":" + PORT);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. "
                    + "Add mysql-connector-java.jar to WEB-INF/lib.", e);
        }
    }

    /**
     * Returns a new JDBC Connection.
     * The caller is responsible for closing it (use try-with-resources).
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
    }

    // Helper: read env var or return a default value
    private static String getEnv(String key, String defaultValue) {
        String val = System.getenv(key);
        return (val != null && !val.isEmpty()) ? val : defaultValue;
    }
}
