package utils;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Utility class for generating and managing verification codes
 */
public class VerificationCodeUtils {
    
    // Store verification codes with expiration time
    private static final ConcurrentHashMap<String, VerificationData> codeStorage = new ConcurrentHashMap<>();
    private static final int CODE_LENGTH = 6;
    private static final int EXPIRATION_MINUTES = 10; // Code expires in 10 minutes
    
    /**
     * Inner class to store verification data
     */
    private static class VerificationData {
        private final String code;
        private final LocalDateTime expirationTime;
        private final String email;
        
        public VerificationData(String code, String email) {
            this.code = code;
            this.email = email;
            this.expirationTime = LocalDateTime.now().plus(EXPIRATION_MINUTES, ChronoUnit.MINUTES);
        }
        
        public boolean isExpired() {
            return LocalDateTime.now().isAfter(expirationTime);
        }
        
        public String getCode() {
            return code;
        }
        
        public String getEmail() {
            return email;
        }
    }
    
    /**
     * Generate a random 6-digit verification code
     * @return 6-digit verification code as string
     */
    public static String generateVerificationCode() {
        SecureRandom random = new SecureRandom();
        StringBuilder code = new StringBuilder();
        
        for (int i = 0; i < CODE_LENGTH; i++) {
            code.append(random.nextInt(10));
        }
        
        return code.toString();
    }
    
    /**
     * Store verification code for an email with expiration
     * @param email The email address
     * @param code The verification code
     */
    public static void storeVerificationCode(String email, String code) {
        // Clean up expired codes first
        cleanupExpiredCodes();
        
        // Store new code
        String key = email.toLowerCase().trim();
        codeStorage.put(key, new VerificationData(code, email));
    }
    
    /**
     * Verify if the provided code matches the stored code for the email
     * @param email The email address
     * @param providedCode The code provided by user
     * @return true if code is valid and not expired, false otherwise
     */
    public static boolean verifyCode(String email, String providedCode) {
        String key = email.toLowerCase().trim();
        VerificationData data = codeStorage.get(key);
        
        if (data == null) {
            return false;
        }
        
        if (data.isExpired()) {
            codeStorage.remove(key);
            return false;
        }
        
        return data.getCode().equals(providedCode);
    }
    
    /**
     * Remove verification code after successful verification
     * @param email The email address
     */
    public static void removeVerificationCode(String email) {
        String key = email.toLowerCase().trim();
        codeStorage.remove(key);
    }
    
    /**
     * Check if a verification code exists for an email
     * @param email The email address
     * @return true if code exists and not expired, false otherwise
     */
    public static boolean hasValidCode(String email) {
        String key = email.toLowerCase().trim();
        VerificationData data = codeStorage.get(key);
        
        if (data == null) {
            return false;
        }
        
        if (data.isExpired()) {
            codeStorage.remove(key);
            return false;
        }
        
        return true;
    }
    
    /**
     * Clean up expired verification codes
     */
    private static void cleanupExpiredCodes() {
        codeStorage.entrySet().removeIf(entry -> entry.getValue().isExpired());
    }
    
    /**
     * Get remaining time for verification code in minutes
     * @param email The email address
     * @return remaining time in minutes, or 0 if expired/not found
     */
    public static long getRemainingTimeMinutes(String email) {
        String key = email.toLowerCase().trim();
        VerificationData data = codeStorage.get(key);
        
        if (data == null || data.isExpired()) {
            return 0;
        }
        
        return ChronoUnit.MINUTES.between(LocalDateTime.now(), data.expirationTime);
    }
}
