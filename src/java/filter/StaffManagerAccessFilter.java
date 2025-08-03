package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import models.UserDTO;
import models.AdminDTO;
import utils.AccessControlUtil;

public class StaffManagerAccessFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Kiểm tra session có tồn tại không
        if (session == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
            return;
        }

        // Lấy thông tin user từ session
        Object sessionUser = session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");
        
        // Kiểm tra nếu là Staff và đang cố truy cập trang manager
        if (sessionUser != null && "user".equals(accType) && sessionUser instanceof UserDTO) {
            UserDTO user = (UserDTO) sessionUser;
            String userRole = user.getRole();
            
                            // If it's Staff, block access to manager pages
                if ("staff".equalsIgnoreCase(userRole)) {
                    String requestURI = httpRequest.getRequestURI();
                    
                    // List of manager URLs that Staff are not allowed to access
                    String[] restrictedUrls = {
                        "/user-manager",
                        "/admin-manager", 
                        "/court-manager",
                        "/service-manager",
                        "/court-rates-manager"
                    };
                    
                    // Check if current URL is in the blocked list
                    for (String restrictedUrl : restrictedUrls) {
                        if (requestURI.contains(restrictedUrl)) {
                            // Redirect Staff to access-denied page
                            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
                            return;
                        }
                    }
                }
        }

        // Cho phép request tiếp tục nếu không phải Staff hoặc không phải trang manager bị chặn
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 