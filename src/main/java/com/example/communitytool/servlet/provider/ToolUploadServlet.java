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
        String location = request.getParameter("location");
        String rentalFeeStr = request.getParameter("rentalFee");

        try {
            // 验证租金格式
            Integer rentalFee = null;
            if (rentalFeeStr != null && !rentalFeeStr.trim().isEmpty()) {
                rentalFee = Integer.parseInt(rentalFeeStr.trim());
            }

            // 验证数据有效性
            String validationError = providerService.validateToolData(toolName, description, location, rentalFee);
            if (validationError != null) {
                request.setAttribute("error", validationError);
                request.setAttribute("toolName", toolName);
                request.setAttribute("description", description);
                request.setAttribute("location", location);
                request.setAttribute("rentalFee", rentalFeeStr);
                request.getRequestDispatcher("/provider/tool-upload.jsp").forward(request, response);
                return;
            }

            // 上传工具
            boolean success = providerService.uploadTool(
                currentUser.getUserId(),
                toolName,
                description,
                location,
                rentalFee
            );

            if (success) {
                response.sendRedirect(request.getContextPath() + "/provider/dashboard");
            } else {
                request.setAttribute("error", "工具上传失败，请稍后重试");
                request.getRequestDispatcher("/provider/tool-upload.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "工具上传失败，请稍后重试");
            request.getRequestDispatcher("/provider/tool-upload.jsp").forward(request, response);
        }
    }
}
