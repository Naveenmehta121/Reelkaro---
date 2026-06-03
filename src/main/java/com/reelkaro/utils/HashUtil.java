package com.reelkaro.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * HashUtil — Password hashing using SHA-256.
 *
 * SHA-256 produces a 256-bit (32-byte) digest.
 * We store it as a 64-character lowercase hex string in the DB.
 *
 * NOTE: For production you should upgrade to BCrypt or Argon2.
 * SHA-256 is used here to keep dependencies minimal (pure JDK).
 */
public class HashUtil {

    private HashUtil() {} // prevent instantiation

    /**
     * Hash a plain-text password using SHA-256.
     * @param plainText the raw password entered by the user
     * @return 64-char lowercase hex string
     */
    public static String sha256(String plainText) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(
                    plainText.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hashBytes);
        } catch (NoSuchAlgorithmException e) {
            // SHA-256 is guaranteed by the JDK — this should never happen
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Converts a byte array to a lowercase hex string.
     * e.g. [0x0A, 0xFF] → "0aff"
     */
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
