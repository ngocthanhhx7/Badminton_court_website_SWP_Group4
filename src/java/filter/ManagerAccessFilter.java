package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import utils.AccessControlUtil;

public class ManagerAccessFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Kiểm tra quyền truy cập sử dụng AccessControlUtil
        if (AccessControlUtil.hasManagerAccess(httpRequest)) {
            // Cho phép truy cập
            chain.doFilter(request, response);
        } else {
            // Không có quyền, chuyển hướng về trang lỗi
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
        }
    }

    @Override
    public void destroy() {
    }
} 