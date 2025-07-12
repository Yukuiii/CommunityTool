package com.example.communitytool.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 身份验证过滤器
 * 检查用户是否已登录，保护需要认证的页面
 */
public class AuthenticationFilter implements Filter {
    
    // 不需要登录验证的路径
    private static final List<String> EXCLUDED_PATHS = Arrays.asList(
        "/login", "/register", "/logout"
    );
    
    // 管理员专用路径
    private static final List<String> ADMIN_PATHS = Arrays.asList(
        "/admin/"
    );
    
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // 检查是否为排除路径
        if (isExcludedPath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        HttpSession session = httpRequest.getSession(false);
        Object user = null;
        Object userRole = null;
        
        if (session != null) {
            user = session.getAttribute("user");
            userRole = session.getAttribute("userRole");
        }
        
        // 检查用户是否已登录
        if (user == null) {
            httpRequest.setAttribute("error", "请先登录");
            httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
            return;
        }
        
        // 检查管理员权限
        if (isAdminPath(path)) {
            if (!"admin".equals(userRole)) {
                httpRequest.setAttribute("error", "权限不足，需要管理员权限");
                httpRequest.getRequestDispatcher("/login.jsp").forward(httpRequest, httpResponse);
                return;
            }
        }
        
        // 用户已登录且权限验证通过，继续处理请求
        chain.doFilter(request, response);
    }
    
    /**
     * 检查是否为排除路径（不需要登录验证）
     */
    private boolean isExcludedPath(String path) {
        return EXCLUDED_PATHS.stream().anyMatch(excludedPath -> 
            path.equals(excludedPath) || path.startsWith(excludedPath)
        );
    }
    
    /**
     * 检查是否为管理员路径
     */
    private boolean isAdminPath(String path) {
        return ADMIN_PATHS.stream().anyMatch(path::startsWith);
    }
}
