package models;

import java.time.LocalDateTime;

public class PartnerSearchPostDTO {
    private int postID;
    private int userID;
    private String title;
    private String description;
    private String preferredLocation;
    private Integer maxDistance;
    private LocalDateTime preferredDateTime;
    private String skillLevel;
    private String playStyle;
    private String contactMethod;
    private String contactInfo;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime expiresAt;
    private int viewCount;
    
    // User info for display
    private String authorName;
    private String authorSportLevel;
    private String authorGender;
    
    // Response count
    private int responseCount;

    public PartnerSearchPostDTO() {
    }

    public PartnerSearchPostDTO(int postID, int userID, String title, String description, 
                              String preferredLocation, Integer maxDistance, LocalDateTime preferredDateTime, 
                              String skillLevel, String playStyle, String contactMethod, String contactInfo, 
                              String status, LocalDateTime createdAt, LocalDateTime updatedAt, 
                              LocalDateTime expiresAt, int viewCount) {
        this.postID = postID;
        this.userID = userID;
        this.title = title;
        this.description = description;
        this.preferredLocation = preferredLocation;
        this.maxDistance = maxDistance;
        this.preferredDateTime = preferredDateTime;
        this.skillLevel = skillLevel;
        this.playStyle = playStyle;
        this.contactMethod = contactMethod;
        this.contactInfo = contactInfo;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.expiresAt = expiresAt;
        this.viewCount = viewCount;
    }

    // Getters and Setters
    public int getPostID() {
        return postID;
    }

    public void setPostID(int postID) {
        this.postID = postID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPreferredLocation() {
        return preferredLocation;
    }

    public void setPreferredLocation(String preferredLocation) {
        this.preferredLocation = preferredLocation;
    }

    public Integer getMaxDistance() {
        return maxDistance;
    }

    public void setMaxDistance(Integer maxDistance) {
        this.maxDistance = maxDistance;
    }

    public LocalDateTime getPreferredDateTime() {
        return preferredDateTime;
    }

    public void setPreferredDateTime(LocalDateTime preferredDateTime) {
        this.preferredDateTime = preferredDateTime;
    }

    public String getSkillLevel() {
        return skillLevel;
    }

    public void setSkillLevel(String skillLevel) {
        this.skillLevel = skillLevel;
    }

    public String getPlayStyle() {
        return playStyle;
    }

    public void setPlayStyle(String playStyle) {
        this.playStyle = playStyle;
    }

    public String getContactMethod() {
        return contactMethod;
    }

    public void setContactMethod(String contactMethod) {
        this.contactMethod = contactMethod;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorSportLevel() {
        return authorSportLevel;
    }

    public void setAuthorSportLevel(String authorSportLevel) {
        this.authorSportLevel = authorSportLevel;
    }

    public String getAuthorGender() {
        return authorGender;
    }

    public void setAuthorGender(String authorGender) {
        this.authorGender = authorGender;
    }

    public int getResponseCount() {
        return responseCount;
    }

    public void setResponseCount(int responseCount) {
        this.responseCount = responseCount;
    }

    // Helper methods
    public int getId() {
        return postID; // Convenience method for JSP EL
    }
    
    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    public boolean isActive() {
        return "Active".equals(status) && !isExpired();
    }
    
    // Additional getter for JSP EL compatibility
    public boolean getActive() {
        return isActive();
    }
}
