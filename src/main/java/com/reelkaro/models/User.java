package com.reelkaro.models;

import java.sql.Timestamp;

/**
 * User — POJO representing a row in the `users` table.
 * Both brands and creators share this base record.
 * Role-specific info lives in brand_profiles / creator_profiles.
 */
public class User {

    private int       id;
    private String    name;
    private String    email;
    private String    passwordHash;
    private String    role;           // "brand" or "creator"
    private String    languagePref;   // "en" or "hi"
    private Timestamp createdAt;

    // ---------- Constructors ----------

    public User() {}

    public User(int id, String name, String email, String role) {
        this.id   = id;
        this.name = name;
        this.email = email;
        this.role = role;
    }

    // ---------- Getters & Setters ----------

    public int getId()                       { return id; }
    public void setId(int id)                { this.id = id; }

    public String getName()                  { return name; }
    public void setName(String name)         { this.name = name; }

    public String getEmail()                 { return email; }
    public void setEmail(String email)       { this.email = email; }

    public String getPasswordHash()          { return passwordHash; }
    public void setPasswordHash(String h)    { this.passwordHash = h; }

    public String getRole()                  { return role; }
    public void setRole(String role)         { this.role = role; }

    public String getLanguagePref()          { return languagePref; }
    public void setLanguagePref(String lp)   { this.languagePref = lp; }

    public Timestamp getCreatedAt()          { return createdAt; }
    public void setCreatedAt(Timestamp t)    { this.createdAt = t; }
}
