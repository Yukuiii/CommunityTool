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
 * 管理员工具列表展示Servlet
 * 负责显示待审核工具列表
 */
@WebServlet("/admin/tool-list")
public class AdminToolListServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showPendingTools(request, response);
    }

    /**
     * 显示待审核工具列表
     */
    private void showPendingTools(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Tool> pendingTools = adminService.getPendingTools();
            request.setAttribute("pendingTools", pendingTools);
            request.setAttribute("pendingCount", pendingTools.size());
            
            request.getRequestDispatcher("/admin/tool-review.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("显示待审核工具列表异常: " + e.getMessage());
            request.setAttribute("error", "获取待审核工具列表失败");
            request.getRequestDispatcher("/admin/tool-review.jsp").forward(request, response);
        }
    }
}
