package com.example.communitytool.servlet;

import java.io.IOException;

import com.example.communitytool.service.RegisterService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 用户注册处理Servlet
 * 处理用户注册请求
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private RegisterService registerService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.registerService = new RegisterService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET请求直接转发到注册页面
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置请求编码
        request.setCharacterEncoding("UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        // 使用RegisterService进行数据验证
        String validationError = registerService.validateRegistrationData(username, password, confirmPassword, phone);
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            // 检查用户名是否已存在
            if (registerService.isUsernameExists(username.trim())) {
                request.setAttribute("error", "用户名已存在，请选择其他用户名");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 使用RegisterService创建用户
            boolean success = registerService.registerUser(username.trim(), password,
                                                         phone != null ? phone.trim() : null,
                                                         role != null ? role : "user");

            if (success) {
                // 注册成功，重定向到登录页面
                request.setAttribute("message", "注册成功！请登录您的账号");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "注册失败，请稍后重试");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("注册过程中发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
