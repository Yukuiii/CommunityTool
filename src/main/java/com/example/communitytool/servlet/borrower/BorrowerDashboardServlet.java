package com.example.communitytool.servlet.borrower;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.pojo.Tool;
import com.example.communitytool.pojo.User;
import com.example.communitytool.service.borrower.BorrowerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/borrower/dashboard")
public class BorrowerDashboardServlet extends HttpServlet {

    private BorrowerService borrowerService = new BorrowerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        // 验证用户权限
        if (currentUser == null || !"borrower".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具使用者可以访问此页面");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            // 获取搜索关键词
            String searchKeyword = request.getParameter("search");

            List<Tool> availableTools;
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // 如果有搜索关键词，进行搜索
                availableTools = borrowerService.searchAvailableTools(searchKeyword);
                request.setAttribute("searchKeyword", searchKeyword);
            } else {
                // 否则获取所有闲置工具
                availableTools = borrowerService.getAvailableTools();
            }

            request.setAttribute("availableTools", availableTools);

        } catch (Exception e) {
            System.err.println("获取工具使用者仪表盘数据异常: " + e.getMessage());
            request.setAttribute("error", "获取仪表盘数据失败");
        }

        request.getRequestDispatcher("/borrower/dashboard.jsp").forward(request, response);
    }
}
