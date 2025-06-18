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

        if (AccessControlUtil.hasManagerAccess(httpRequest)) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
        }
    }

    @Override
    public void destroy() {
    }
} 