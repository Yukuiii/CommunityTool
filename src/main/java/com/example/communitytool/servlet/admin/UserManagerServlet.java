package com.example.communitytool.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.pojo.User;
import com.example.communitytool.service.admin.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/user-manager")
public class UserManagerServlet extends HttpServlet {

    private AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = adminService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/user-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String action = request.getParameter("action");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        try {
            switch (action) {
                case "delete":
                    deleteUser(Integer.parseInt(userId));
                    break;
                case "edit":
                    editUser(Integer.parseInt(userId), username, password, phone, role);
                    break;
                case "add":
                    addUser(username, password, phone, role);
                    break;
                default:
                    throw new Exception("未知的操作类型: " + action);
            }
            request.setAttribute("message", "操作成功");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        // 无论成功还是失败，都重新获取用户列表并转发到JSP页面
        List<User> users = adminService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/user-manager.jsp").forward(request, response);
        
    }

    private void deleteUser(Integer userId) throws Exception {
        adminService.deleteUser(userId);
    }

    private void editUser(Integer userId, String username, String password, String phone, String role) throws Exception {
        adminService.editUser(userId, username, password, phone, role);
    }

    private void addUser(String username, String password, String phone, String role) throws Exception {
        adminService.addUser(username, password, phone, role);
    }
}
