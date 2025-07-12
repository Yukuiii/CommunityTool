package com.example.communitytool.servlet.provider;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.dto.BorrowRecordToolsDTO;
import com.example.communitytool.dto.ToolsReviewDTO;
import com.example.communitytool.pojo.User;
import com.example.communitytool.service.provider.ProviderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 工具提供者仪表盘Servlet
 * 显示工具提供者的工具管理和租借请求概览
 */
@WebServlet("/provider/dashboard")
public class ProviderDashboardServlet extends HttpServlet {

    private ProviderService providerService = new ProviderService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 获取当前登录用户
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        // 验证用户权限
        if (currentUser == null || !"provider".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具提供者可以访问此页面");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        try {
            // 获取提供者的所有工具
            List<ToolsReviewDTO> providerTools = providerService.getProviderTools(currentUser.getUserId());
            
            // 获取待审批的租借请求
            List<BorrowRecordToolsDTO> pendingRequests = providerService.getPendingRentalRequests(currentUser.getUserId());
            
            // 设置请求属性
            request.setAttribute("providerTools", providerTools);
            request.setAttribute("pendingRequests", pendingRequests);
            // 转发到仪表盘页面
            request.getRequestDispatcher("/provider/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("获取工具提供者仪表盘数据异常: " + e.getMessage());
            request.setAttribute("error", "获取仪表盘数据失败");
            request.getRequestDispatcher("/provider/dashboard.jsp").forward(request, response);
        }
    }

}
