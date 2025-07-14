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
 * 管理员工具审核通过Servlet
 * 负责处理工具审核通过操作
 */
@WebServlet("/admin/tool-approve")
public class AdminToolApproveServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.adminService = new AdminService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleApprove(request, response);
    }

    /**
     * 处理审核通过
     */
    private void handleApprove(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String toolIdStr = request.getParameter("toolId");

        try {
            Integer toolId = Integer.parseInt(toolIdStr.trim());
            adminService.approveToolReview(toolId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "工具ID格式错误");
        } catch (Exception e) {
            System.err.println("处理审核通过异常: " + e.getMessage());
            request.setAttribute("error", "审核通过操作失败");
        }

        List<Tool> pendingTools = adminService.getPendingTools();
        request.setAttribute("pendingTools", pendingTools);
        request.setAttribute("pendingCount", pendingTools.size());
        request.getRequestDispatcher("/admin/tool-review.jsp").forward(request, response);
    }
}
