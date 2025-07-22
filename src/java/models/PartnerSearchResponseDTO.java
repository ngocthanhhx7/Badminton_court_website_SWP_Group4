package models;

import java.time.LocalDateTime;

public class PartnerSearchResponseDTO {
    private int responseID;
    private int postID;
    private int responderID;
    private String message;
    private String status;
    private LocalDateTime createdAt;
    
    // Additional info for display
    private String responderName;
    private String responderSportLevel;
    private String responderPhone;
    private String responderGender;

    public PartnerSearchResponseDTO() {
    }

    public PartnerSearchResponseDTO(int responseID, int postID, int responderID, 
                                  String message, String status, LocalDateTime createdAt) {
        this.responseID = responseID;
        this.postID = postID;
        this.responderID = responderID;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getResponseID() {
        return responseID;
    }

    public void setResponseID(int responseID) {
        this.responseID = responseID;
    }

    public int getPostID() {
        return postID;
    }

    public void setPostID(int postID) {
        this.postID = postID;
    }

    public int getResponderID() {
        return responderID;
    }

    public void setResponderID(int responderID) {
        this.responderID = responderID;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
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

    public String getResponderName() {
        return responderName;
    }

    public void setResponderName(String responderName) {
        this.responderName = responderName;
    }

    public String getResponderSportLevel() {
        return responderSportLevel;
    }

    public void setResponderSportLevel(String responderSportLevel) {
        this.responderSportLevel = responderSportLevel;
    }

    public String getResponderPhone() {
        return responderPhone;
    }

    public void setResponderPhone(String responderPhone) {
        this.responderPhone = responderPhone;
    }

    public String getResponderGender() {
        return responderGender;
    }

    public void setResponderGender(String responderGender) {
        this.responderGender = responderGender;
    }
}
