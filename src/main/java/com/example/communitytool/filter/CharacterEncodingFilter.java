package com.example.communitytool.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 字符编码过滤器
 * 统一设置请求和响应的字符编码为UTF-8
 */
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    private boolean forceEncoding = false;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 从web.xml获取编码配置
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.trim().isEmpty()) {
            this.encoding = encodingParam.trim();
        }
        
        // 从web.xml获取强制编码配置
        String forceEncodingParam = filterConfig.getInitParameter("forceEncoding");
        if (forceEncodingParam != null) {
            this.forceEncoding = Boolean.parseBoolean(forceEncodingParam);
        }
        
        System.out.println("CharacterEncodingFilter initialized with encoding: " + encoding + 
                          ", forceEncoding: " + forceEncoding);
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 设置请求编码
        if (forceEncoding || httpRequest.getCharacterEncoding() == null) {
            httpRequest.setCharacterEncoding(encoding);
        }
        
        // 设置响应编码
        if (forceEncoding || httpResponse.getCharacterEncoding() == null || 
            "ISO-8859-1".equals(httpResponse.getCharacterEncoding())) {
            httpResponse.setCharacterEncoding(encoding);
        }
        
        // 设置响应内容类型
        if (httpResponse.getContentType() == null) {
            httpResponse.setContentType("text/html; charset=" + encoding);
        }
        
        // 继续过滤器链
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("CharacterEncodingFilter destroyed");
    }
}
