package dal;

import models.EmailVerificationDTO;
import utils.DBUtils;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.Random;

public class EmailVerificationDAO {

    /**
     * Tạo mã verification mới cho user
     */
    public String createVerification(int userID, String email) throws SQLException {
        // Xóa verification cũ chưa verify (nếu có)
        deleteUnverifiedByUser(userID);
        
        // Tạo mã verify 6 số
        String verifyCode = generateVerifyCode();
        
        // Thời gian hết hạn: 15 phút
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(15);
        
        String sql = "INSERT INTO EmailVerifications (UserID, Email, VerifyCode, ExpiresAt) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userID);
            ps.setString(2, email);
            ps.setString(3, verifyCode);
            ps.setTimestamp(4, Timestamp.valueOf(expiresAt));
            
            ps.executeUpdate();
            return verifyCode;
        }
    }

    /**
     * Xác minh mã code
     */
    public boolean verifyCode(String email, String code) throws SQLException {
        String selectSql = "SELECT * FROM EmailVerifications WHERE Email = ? AND VerifyCode = ? AND IsVerified = 0 AND ExpiresAt > GETDATE()";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {
            
            ps.setString(1, email.trim());
            ps.setString(2, code.trim());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Cập nhật thành verified
                    String updateSql = "UPDATE EmailVerifications SET IsVerified = 1, VerifiedAt = GETDATE() WHERE VerificationID = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, rs.getInt("VerificationID"));
                        return updatePs.executeUpdate() > 0;
                    }
                }
            }
        }
        return false;
    }

    /**
     * Kiểm tra user đã verify email chưa
     */
    public boolean isEmailVerified(int userID) throws SQLException {
        String sql = "SELECT COUNT(*) FROM EmailVerifications WHERE UserID = ? AND IsVerified = 1";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Resend verification code
     */
    public String resendVerification(int userID, String email) throws SQLException {
        // Kiểm tra có thể resend không
        if (!canResend(userID)) {
            throw new SQLException("You must wait 2 minutes before requesting another code");
        }
        
        // Xóa mã cũ và tạo mã mới
        deleteUnverifiedByUser(userID);
        String newCode = createVerification(userID, email);
        
        // Cập nhật resend count
        String updateSql = "UPDATE EmailVerifications SET ResendCount = ResendCount + 1, LastResendAt = GETDATE() WHERE UserID = ? AND VerifyCode = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {
            
            ps.setInt(1, userID);
            ps.setString(2, newCode);
            ps.executeUpdate();
        }
        
        return newCode;
    }

    /**
     * Kiểm tra có thể resend không
     */
    private boolean canResend(int userID) throws SQLException {
        String sql = "SELECT LastResendAt FROM EmailVerifications WHERE UserID = ? AND IsVerified = 0 ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp lastResend = rs.getTimestamp("LastResendAt");
                    if (lastResend != null) {
                        // Kiểm tra đã qua 2 phút chưa
                        LocalDateTime lastResendTime = lastResend.toLocalDateTime();
                        return LocalDateTime.now().isAfter(lastResendTime.plusMinutes(2));
                    }
                }
            }
        }
        return true; // Nếu chưa có resend nào thì cho phép
    }

    /**
     * Xóa các verification chưa verify của user
     */
    private void deleteUnverifiedByUser(int userID) throws SQLException {
        String sql = "DELETE FROM EmailVerifications WHERE UserID = ? AND IsVerified = 0";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userID);
            ps.executeUpdate();
        }
    }

    /**
     * Lấy thông tin verification theo email
     */
    public EmailVerificationDTO getVerificationByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM EmailVerifications WHERE Email = ? AND IsVerified = 0 ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Tạo mã verify 6 số ngẫu nhiên
     */
    private String generateVerifyCode() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }

    /**
     * Map ResultSet to DTO
     */
    private EmailVerificationDTO mapResultSet(ResultSet rs) throws SQLException {
        EmailVerificationDTO dto = new EmailVerificationDTO();
        dto.setVerificationID(rs.getInt("VerificationID"));
        dto.setUserID(rs.getInt("UserID"));
        dto.setEmail(rs.getString("Email"));
        dto.setVerifyCode(rs.getString("VerifyCode"));
        dto.setVerified(rs.getBoolean("IsVerified"));
        dto.setExpiresAt(rs.getTimestamp("ExpiresAt").toLocalDateTime());
        dto.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        
        Timestamp verifiedAt = rs.getTimestamp("VerifiedAt");
        if (verifiedAt != null) {
            dto.setVerifiedAt(verifiedAt.toLocalDateTime());
        }
        
        dto.setResendCount(rs.getInt("ResendCount"));
        
        Timestamp lastResendAt = rs.getTimestamp("LastResendAt");
        if (lastResendAt != null) {
            dto.setLastResendAt(lastResendAt.toLocalDateTime());
        }
        
        return dto;
    }

    /**
     * Dọn dẹp các verification đã hết hạn
     */
    public void cleanupExpiredVerifications() throws SQLException {
        String sql = "DELETE FROM EmailVerifications WHERE ExpiresAt < GETDATE() AND IsVerified = 0";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.executeUpdate();
        }
    }
}
