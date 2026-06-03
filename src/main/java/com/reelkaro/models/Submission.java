package com.reelkaro.models;

import java.sql.Timestamp;

/**
 * Submission — POJO for a row in the `submissions` table.
 * A creator submits a content link after their application is approved.
 */
public class Submission {

    private int       id;
    private int       applicationId;
    private int       campaignId;          // joined (not a DB column)
    private String    campaignTitle;       // joined (not a DB column)
    private int       creatorId;           // joined (not a DB column)
    private String    creatorName;         // joined (not a DB column)
    private String    contentLink;
    private String    platformPosted;
    private Timestamp submittedAt;
    private String    approvalStatus;      // pending, approved, rejected
    private String    feedback;

    // ---------- Constructors ----------

    public Submission() {}

    // ---------- Getters & Setters ----------

    public int getId()                              { return id; }
    public void setId(int id)                       { this.id = id; }

    public int getApplicationId()                   { return applicationId; }
    public void setApplicationId(int aid)           { this.applicationId = aid; }

    public int getCampaignId()                      { return campaignId; }
    public void setCampaignId(int cid)              { this.campaignId = cid; }

    public String getCampaignTitle()                { return campaignTitle; }
    public void setCampaignTitle(String t)          { this.campaignTitle = t; }

    public int getCreatorId()                       { return creatorId; }
    public void setCreatorId(int creatorId)         { this.creatorId = creatorId; }

    public String getCreatorName()                  { return creatorName; }
    public void setCreatorName(String n)            { this.creatorName = n; }

    public String getContentLink()                  { return contentLink; }
    public void setContentLink(String cl)           { this.contentLink = cl; }

    public String getPlatformPosted()               { return platformPosted; }
    public void setPlatformPosted(String pp)        { this.platformPosted = pp; }

    public Timestamp getSubmittedAt()               { return submittedAt; }
    public void setSubmittedAt(Timestamp t)         { this.submittedAt = t; }

    public String getApprovalStatus()               { return approvalStatus; }
    public void setApprovalStatus(String as)        { this.approvalStatus = as; }

    public String getFeedback()                     { return feedback; }
    public void setFeedback(String feedback)        { this.feedback = feedback; }
}
