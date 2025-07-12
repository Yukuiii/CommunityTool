package com.example.communitytool.servlet;

import java.io.IOException;

import com.example.communitytool.pojo.User;
import com.example.communitytool.service.ProfileService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * 修改个人信息
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private ProfileService profileService = new ProfileService();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        if (currentUser == null || !"borrower".equals(userRole) && !"provider".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具使用者或工具提供者可以访问此页面");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        User user = profileService.getUserById(currentUser.getUserId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        Integer userId = currentUser.getUserId();
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        try {
            profileService.updateProfile(userId, username, phone, password);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
            return;
        }
        request.setAttribute("message", "修改个人信息成功");
        doGet(request, response);
    }
}
