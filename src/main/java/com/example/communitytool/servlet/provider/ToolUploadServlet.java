package com.example.communitytool.servlet.provider;

import java.io.IOException;

import com.example.communitytool.pojo.User;
import com.example.communitytool.service.provider.ProviderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 工具上传处理Servlet
 * 处理工具提供者上传工具的请求
 */
@WebServlet("/provider/tool-upload")
public class ToolUploadServlet extends HttpServlet {

    private ProviderService providerService = new ProviderService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // GET请求转发到工具上传页面
        request.getRequestDispatcher("/provider/tool-upload.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 获取当前登录用户
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        // 验证用户权限
        if (currentUser == null || !"provider".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具提供者可以上传工具");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // 获取表单参数
        String toolName = request.getParameter("toolName");
        String description = request.getParameter("description");
        Integer rentalFee = Integer.parseInt(request.getParameter("rentalFee"));
        
        // 上传工具
        providerService.uploadTool(
            currentUser.getUserId(), 
            toolName, 
            description, 
            rentalFee
        );

        response.sendRedirect(request.getContextPath() + "/provider/dashboard");
    }
}
