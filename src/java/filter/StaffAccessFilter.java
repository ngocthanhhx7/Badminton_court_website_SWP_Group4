package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import models.UserDTO;

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
        UserDTO user = (UserDTO) session.getAttribute("acc");
        
        // Kiểm tra nếu là Staff và đang cố truy cập trang home
        if (user != null && "staff".equalsIgnoreCase(user.getRole()) 
            && httpRequest.getRequestURI().endsWith("/home")) {
            // Chuyển hướng Staff về trang page-manager
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/page-manager");
            return;
        }

        // Cho phép request tiếp tục nếu không phải Staff hoặc không phải trang home
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 