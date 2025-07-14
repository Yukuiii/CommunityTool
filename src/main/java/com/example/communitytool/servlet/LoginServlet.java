package com.example.communitytool.servlet;

import java.io.IOException;

import com.example.communitytool.service.LoginService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 登录处理Servlet
 * 处理用户和管理员的登录请求
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private LoginService loginService = new LoginService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // GET请求直接转发到登录页面
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType");
        
        // 验证登录
        boolean loginSuccess = false;
        String userRole = null;
        
        if ("admin".equals(loginType)) {
            // 管理员登录验证
            loginSuccess = loginService.adminLogin(username.trim(), password);
            userRole = "admin";
        } else if ("borrower".equals(loginType)) {
            // 工具使用者登录验证
            loginSuccess = loginService.userLogin(username.trim(), password, loginType);
            userRole = "borrower";
        } else if ("provider".equals(loginType)) {
            // 工具提供者登录验证
            loginSuccess = loginService.userLogin(username.trim(), password, loginType);
            userRole = "provider";
        }
        
        if (loginSuccess) {
            // 登录成功，获取完整的用户对象
            HttpSession session = request.getSession();
            Object userObject = null;

            if ("admin".equals(userRole)) {
                // 管理员登录，获取Admin对象
                userObject = loginService.getAdminById(username.trim());
            } else {
                // 普通用户登录，获取User对象
                userObject = loginService.getUserByUsername(username.trim());
            }

            // 存储用户对象到session
            session.setAttribute("user", userObject);
            session.setAttribute("userRole", userRole);

            // 跳转到目标页面
            
                // 根据用户类型跳转到不同的默认页面
                if ("admin".equals(userRole)) {
                    response.sendRedirect(request.getContextPath() + "/admin/tool-list");
                } else if ("borrower".equals(userRole)) {
                    response.sendRedirect(request.getContextPath() + "/borrower/dashboard");
                } else if ("provider".equals(userRole)) {
                    response.sendRedirect(request.getContextPath() + "/provider/dashboard");
                }
        } else {
            // 登录失败
            request.setAttribute("error", "用户名或密码不正确");
            request.setAttribute("loginType", loginType);
            
            // 转发回登录页面
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
}
