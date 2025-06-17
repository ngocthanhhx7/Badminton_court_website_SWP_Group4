package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import models.UserDTO;
import models.AdminDTO;

/**
 * Utility class để kiểm tra phân quyền truy cập
 */
public class AccessControlUtil {
    
    /**
     * Kiểm tra quyền truy cập cho các trang manager
     * Chỉ Admin và Staff mới có quyền truy cập
     * 
     * @param request HttpServletRequest
     * @return true nếu có quyền truy cập, false nếu không
     */
    public static boolean hasManagerAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        if (accObj != null) {
            if ("admin".equals(accType)) {
                // Admin luôn có quyền truy cập
                return true;
            } else if ("user".equals(accType) && accObj instanceof UserDTO) {
                UserDTO user = (UserDTO) accObj;
                // Kiểm tra nếu user có role là "staff"
                return "staff".equalsIgnoreCase(user.getRole());
            }
        }
        
        return false;
    }
    
    /**
     * Kiểm tra xem user có phải là Admin không
     * 
     * @param request HttpServletRequest
     * @return true nếu là Admin, false nếu không
     */
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String accType = (String) session.getAttribute("accType");
        return "admin".equals(accType);
    }
    
    /**
     * Kiểm tra xem user có phải là Staff không
     * 
     * @param request HttpServletRequest
     * @return true nếu là Staff, false nếu không
     */
    public static boolean isStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        if ("user".equals(accType) && accObj instanceof UserDTO) {
            UserDTO user = (UserDTO) accObj;
            return "staff".equalsIgnoreCase(user.getRole());
        }
        
        return false;
    }
    
    /**
     * Lấy thông tin user hiện tại từ session
     * 
     * @param request HttpServletRequest
     * @return UserDTO nếu là user, null nếu không
     */
    public static UserDTO getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        if ("user".equals(accType) && accObj instanceof UserDTO) {
            return (UserDTO) accObj;
        }
        
        return null;
    }
    
    /**
     * Lấy thông tin admin hiện tại từ session
     * 
     * @param request HttpServletRequest
     * @return AdminDTO nếu là admin, null nếu không
     */
    public static AdminDTO getCurrentAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        if ("admin".equals(accType) && accObj instanceof AdminDTO) {
            return (AdminDTO) accObj;
        }
        
        return null;
    }
} 