package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import models.UserDTO;

public class ProfileCheckFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();

        // Lấy thông tin user từ session
        UserDTO user = (UserDTO) session.getAttribute("acc");
        String accType = (String) session.getAttribute("accType");

        // Nếu là user và chưa hoàn thiện profile
        if ("user".equals(accType) && user != null) {
            if (user.getFullName() == null
                    || user.getDob() == null
                    || user.getGender() == null
                    || user.getPhone() == null
                    || user.getAddress() == null
                    || user.getSportLevel() == null) {
                
                // Cho phép truy cập trang completeProfile.jsp
                String requestURI = httpRequest.getRequestURI();
                if (!requestURI.contains("completeProfile.jsp") 
                    && !requestURI.contains("complete-profile")
                    && !requestURI.contains("Login.jsp")
                    && !requestURI.contains("login")
                    && !requestURI.contains("logout")
                    && !requestURI.contains("assets")) {
                    
                    httpResponse.sendRedirect("completeProfile.jsp");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 