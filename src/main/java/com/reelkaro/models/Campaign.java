package com.reelkaro.models;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Campaign — POJO representing a row in the `campaigns` table.
 * Brands create campaigns; creators browse and apply.
 */
public class Campaign {

    private int        id;
    private int        brandId;
    private String     brandName;          // joined from users.name (not a DB column)
    private String     companyName;        // joined from brand_profiles (not a DB column)
    private String     title;
    private String     description;
    private String     platform;           // Instagram, YouTube, Josh, ShareChat, Moj
    private String     category;
    private BigDecimal budgetInr;
    private BigDecimal rewardPerCreatorInr;
    private int        maxCreators;
    private Date       deadline;
    private String     status;             // open, closed, paused
    private Timestamp  createdAt;
    private int        applyCount;         // computed — number of applications

    // ---------- Constructors ----------

    public Campaign() {}

    // ---------- Getters & Setters ----------

    public int getId()                               { return id; }
    public void setId(int id)                        { this.id = id; }

    public int getBrandId()                          { return brandId; }
    public void setBrandId(int brandId)              { this.brandId = brandId; }

    public String getBrandName()                     { return brandName; }
    public void setBrandName(String brandName)       { this.brandName = brandName; }

    public String getCompanyName()                   { return companyName; }
    public void setCompanyName(String cn)            { this.companyName = cn; }

    public String getTitle()                         { return title; }
    public void setTitle(String title)               { this.title = title; }

    public String getDescription()                   { return description; }
    public void setDescription(String desc)          { this.description = desc; }

    public String getPlatform()                      { return platform; }
    public void setPlatform(String platform)         { this.platform = platform; }

    public String getCategory()                      { return category; }
    public void setCategory(String category)         { this.category = category; }

    public BigDecimal getBudgetInr()                 { return budgetInr; }
    public void setBudgetInr(BigDecimal b)           { this.budgetInr = b; }

    public BigDecimal getRewardPerCreatorInr()       { return rewardPerCreatorInr; }
    public void setRewardPerCreatorInr(BigDecimal r) { this.rewardPerCreatorInr = r; }

    public int getMaxCreators()                      { return maxCreators; }
    public void setMaxCreators(int m)                { this.maxCreators = m; }

    public Date getDeadline()                        { return deadline; }
    public void setDeadline(Date deadline)           { this.deadline = deadline; }

    public String getStatus()                        { return status; }
    public void setStatus(String status)             { this.status = status; }

    public Timestamp getCreatedAt()                  { return createdAt; }
    public void setCreatedAt(Timestamp t)            { this.createdAt = t; }

    public int getApplyCount()                       { return applyCount; }
    public void setApplyCount(int applyCount)        { this.applyCount = applyCount; }
}
