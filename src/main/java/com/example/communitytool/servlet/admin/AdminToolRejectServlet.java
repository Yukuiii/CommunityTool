package com.example.communitytool.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.pojo.Tool;
import com.example.communitytool.service.admin.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 管理员工具审核驳回Servlet
 * 负责处理工具审核驳回操作
 */
@WebServlet("/admin/tool-reject")
public class AdminToolRejectServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.adminService = new AdminService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleReject(request, response);
    }

    /**
     * 处理审核驳回
     */
    private void handleReject(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String toolIdStr = request.getParameter("toolId");
        try {
            Integer toolId = Integer.parseInt(toolIdStr.trim());
            String reason = request.getParameter("reason");
            boolean success = adminService.rejectToolReview(toolId, reason);

            if (success) {
                request.setAttribute("message", "工具审核驳回成功");
            } else {
                request.setAttribute("error", "工具审核驳回失败");
            }   
        } catch (Exception e) {
            System.err.println("处理审核驳回异常: " + e.getMessage());
            request.setAttribute("error", "审核驳回操作失败");
        }

        List<Tool> pendingTools = adminService.getPendingTools();
        request.setAttribute("pendingTools", pendingTools);
        request.setAttribute("pendingCount", pendingTools.size());
        request.getRequestDispatcher("/admin/tool-review.jsp").forward(request, response);
    }
}
