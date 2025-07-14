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

@WebServlet("/admin/tool-manager")
public class ToolManagerServlet extends HttpServlet {

    private AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Tool> tools = adminService.getAllTools();
        request.setAttribute("tools", tools);
        request.getRequestDispatcher("/admin/tool-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String toolId = request.getParameter("toolId");
        String action = request.getParameter("action");
        String toolName = request.getParameter("toolName");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String rentalFee = request.getParameter("rentalFee");
        
        try {
            switch (action) {
                case "delete":
                    deleteTool(Integer.parseInt(toolId));
                    break;
                case "edit":
                    editTool(Integer.parseInt(toolId), toolName, description, location, rentalFee);
                    break;
                case "add":
                    addTool(toolName, description, location, rentalFee);
                    break;
                default:
                    throw new Exception("未知的操作类型: " + action);
            }
            request.setAttribute("message", "操作成功");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        // 无论成功还是失败，都重新获取工具列表并转发到JSP页面
        List<Tool> tools = adminService.getAllTools();
        request.setAttribute("tools", tools);
        request.getRequestDispatcher("/admin/tool-manager.jsp").forward(request, response);
    }

    private void deleteTool(Integer toolId) throws Exception {
        adminService.deleteTool(toolId);
    }

    private void editTool(Integer toolId, String toolName, String description, String location, String rentalFee) throws Exception {
        adminService.editTool(toolId, toolName, description, location, rentalFee);
    }

    private void addTool(String toolName, String description, String location, String rentalFee) throws Exception {
        adminService.addTool(toolName, description, location, rentalFee);
    }
    
}
