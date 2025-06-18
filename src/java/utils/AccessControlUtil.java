package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import models.UserDTO;
import models.AdminDTO;

public class AccessControlUtil {
    
    public static boolean hasManagerAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        Object accObj = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        if (accObj != null) {
            if ("admin".equals(accType)) {
                return true;
            } else if ("user".equals(accType) && accObj instanceof UserDTO) {
                UserDTO user = (UserDTO) accObj;
                return "staff".equalsIgnoreCase(user.getRole());
            }
        }
        
        return false;
    }
    
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String accType = (String) session.getAttribute("accType");
        return "admin".equals(accType);
    }
    
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