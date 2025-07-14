package com.example.communitytool.servlet.provider;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.dto.BorrowRecordToolsDTO;
import com.example.communitytool.pojo.User;
import com.example.communitytool.service.provider.ProviderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 租借请求审批处理Servlet
 * 处理工具提供者审批租借请求的操作
 */
@WebServlet("/provider/rental-approval")
public class RentalApprovalServlet extends HttpServlet {

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
            request.setAttribute("error", "权限不足，只有工具提供者可以审批租借请求");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        try {
            // 获取待审批的租借请求
            List<BorrowRecordToolsDTO> pendingRequests = providerService.getPendingRentalRequests(currentUser.getUserId());
            
            // 设置请求属性
            request.setAttribute("pendingRequests", pendingRequests);
            
            // 转发到审批页面
            request.getRequestDispatcher("/provider/rental-approval.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("获取待审批租借请求异常: " + e.getMessage());
            request.setAttribute("error", "获取待审批租借请求失败");
            request.getRequestDispatcher("/provider/rental-approval.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        
        // 获取当前登录用户
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        // 验证用户权限
        if (currentUser == null || !"provider".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具提供者可以审批租借请求");
            doGet(request, response);
            return;
        }
        
        // 获取表单参数
        String action = request.getParameter("action");
        String recordIdStr = request.getParameter("recordId");
        String reason = request.getParameter("reason");
         
        // 处理审批操作
        boolean approved;
        String actionName;
        
        if ("approve".equals(action)) {
            approved = true;
            actionName = "批准";
        } else if ("reject".equals(action)) {
            approved = false;
            actionName = "拒绝";
        } else {
            request.setAttribute("error", "不支持的操作类型: " + action);
            doGet(request, response);
            return;
        }
        
        try {
            // 解析记录ID
            Integer recordId;
            try {
                recordId = Integer.parseInt(recordIdStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("error", "记录ID格式不正确");
                doGet(request, response);
                return;
            }
            
            // 执行审批操作
            providerService.approveRentalRequest(
                currentUser.getUserId(), 
                recordId, 
                approved,
                reason
            );
            
        } catch (Exception e) {
            System.err.println("审批租借请求异常: " + e.getMessage());
            request.setAttribute("error", "审批操作失败: " + e.getMessage());
        }
        
        // 重新加载页面数据
        doGet(request, response);
    }
}
