package models;

import java.time.LocalDateTime;

public class EmailVerificationDTO {
    private int verificationID;
    private int userID;
    private String email;
    private String verifyCode;
    private boolean isVerified;
    private LocalDateTime expiresAt;
    private LocalDateTime createdAt;
    private LocalDateTime verifiedAt;
    private int resendCount;
    private LocalDateTime lastResendAt;

    // Constructors
    public EmailVerificationDTO() {
    }

    public EmailVerificationDTO(int userID, String email, String verifyCode, LocalDateTime expiresAt) {
        this.userID = userID;
        this.email = email;
        this.verifyCode = verifyCode;
        this.expiresAt = expiresAt;
        this.isVerified = false;
        this.resendCount = 0;
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public int getVerificationID() {
        return verificationID;
    }

    public void setVerificationID(int verificationID) {
        this.verificationID = verificationID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getVerifyCode() {
        return verifyCode;
    }

    public void setVerifyCode(String verifyCode) {
        this.verifyCode = verifyCode;
    }

    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean verified) {
        isVerified = verified;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(LocalDateTime verifiedAt) {
        this.verifiedAt = verifiedAt;
    }

    public int getResendCount() {
        return resendCount;
    }

    public void setResendCount(int resendCount) {
        this.resendCount = resendCount;
    }

    public LocalDateTime getLastResendAt() {
        return lastResendAt;
    }

    public void setLastResendAt(LocalDateTime lastResendAt) {
        this.lastResendAt = lastResendAt;
    }

    // Utility methods
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }

    public boolean canResend() {
        // Cho phép resend nếu chưa verify và đã qua 2 phút từ lần gửi cuối
        if (isVerified) return false;
        if (lastResendAt == null) return true;
        return LocalDateTime.now().isAfter(lastResendAt.plusMinutes(2));
    }
}
