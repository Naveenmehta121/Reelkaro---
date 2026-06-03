package com.reelkaro.models;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Reward — POJO for a row in the `rewards` table.
 * Auto-created when a brand approves a creator's submission.
 */
public class Reward {

    private int        id;
    private int        creatorId;
    private String     creatorName;    // joined (not a DB column)
    private int        campaignId;
    private String     campaignTitle;  // joined (not a DB column)
    private BigDecimal amountInr;
    private String     payoutStatus;   // pending, processing, paid
    private String     upiId;
    private Timestamp  awardedAt;

    // ---------- Constructors ----------

    public Reward() {}

    // ---------- Getters & Setters ----------

    public int getId()                            { return id; }
    public void setId(int id)                     { this.id = id; }

    public int getCreatorId()                     { return creatorId; }
    public void setCreatorId(int cid)             { this.creatorId = cid; }

    public String getCreatorName()                { return creatorName; }
    public void setCreatorName(String n)          { this.creatorName = n; }

    public int getCampaignId()                    { return campaignId; }
    public void setCampaignId(int cid)            { this.campaignId = cid; }

    public String getCampaignTitle()              { return campaignTitle; }
    public void setCampaignTitle(String t)        { this.campaignTitle = t; }

    public BigDecimal getAmountInr()              { return amountInr; }
    public void setAmountInr(BigDecimal a)        { this.amountInr = a; }

    public String getPayoutStatus()               { return payoutStatus; }
    public void setPayoutStatus(String ps)        { this.payoutStatus = ps; }

    public String getUpiId()                      { return upiId; }
    public void setUpiId(String upiId)            { this.upiId = upiId; }

    public Timestamp getAwardedAt()               { return awardedAt; }
    public void setAwardedAt(Timestamp t)         { this.awardedAt = t; }
}
