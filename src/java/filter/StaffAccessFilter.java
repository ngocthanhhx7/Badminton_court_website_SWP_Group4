package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import models.UserDTO;
import models.AdminDTO;

public class StaffAccessFilter implements Filter {
    
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
            // Nếu không có session, cho phép request tiếp tục
            chain.doFilter(request, response);
            return;
        }

        // Lấy thông tin user từ session
        Object sessionUser = session.getAttribute("acc");
        
        // Kiểm tra nếu là Staff và đang cố truy cập trang home
        if (sessionUser != null) {
            String userRole = null;
            
            // Kiểm tra loại object và lấy role tương ứng
            if (sessionUser instanceof UserDTO) {
                UserDTO user = (UserDTO) sessionUser;
                userRole = user.getRole();
            } else if (sessionUser instanceof AdminDTO) {
                // Admin không có role field, nhưng có thể coi như có quyền cao nhất
                // Không cần chuyển hướng admin khỏi trang home
                chain.doFilter(request, response);
                return;
            }
            
            // Chỉ kiểm tra chuyển hướng cho Staff (UserDTO với role = "Staff")
            if ("staff".equalsIgnoreCase(userRole) && httpRequest.getRequestURI().endsWith("/home")) {
                // Chuyển hướng Staff về trang page-manager
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/page-manager");
                return;
            }
        }

        // Cho phép request tiếp tục nếu không phải Staff hoặc không phải trang home
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 