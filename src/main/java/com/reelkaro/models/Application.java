package com.reelkaro.models;

import java.sql.Timestamp;

/**
 * Application — POJO for a row in the `applications` table.
 * Represents a creator applying to a campaign.
 */
public class Application {

    private int       id;
    private int       campaignId;
    private String    campaignTitle;      // joined from campaigns (not a DB column)
    private int       creatorId;
    private String    creatorName;        // joined from users (not a DB column)
    private String    creatorUsername;    // joined from creator_profiles (not a DB column)
    private String    status;             // pending, approved, rejected
    private Timestamp appliedAt;

    // ---------- Constructors ----------

    public Application() {}

    // ---------- Getters & Setters ----------

    public int getId()                              { return id; }
    public void setId(int id)                       { this.id = id; }

    public int getCampaignId()                      { return campaignId; }
    public void setCampaignId(int campaignId)       { this.campaignId = campaignId; }

    public String getCampaignTitle()                { return campaignTitle; }
    public void setCampaignTitle(String t)          { this.campaignTitle = t; }

    public int getCreatorId()                       { return creatorId; }
    public void setCreatorId(int creatorId)         { this.creatorId = creatorId; }

    public String getCreatorName()                  { return creatorName; }
    public void setCreatorName(String n)            { this.creatorName = n; }

    public String getCreatorUsername()              { return creatorUsername; }
    public void setCreatorUsername(String u)        { this.creatorUsername = u; }

    public String getStatus()                       { return status; }
    public void setStatus(String status)            { this.status = status; }

    public Timestamp getAppliedAt()                 { return appliedAt; }
    public void setAppliedAt(Timestamp t)           { this.appliedAt = t; }
}
