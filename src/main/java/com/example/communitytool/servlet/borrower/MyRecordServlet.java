package com.example.communitytool.servlet.borrower;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.dto.BorrowRecordToolsDTO;
import com.example.communitytool.pojo.User;
import com.example.communitytool.service.borrower.BorrowerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 获取我的租借记录列表
 */
@WebServlet("/borrower/my-records")
public class MyRecordServlet extends HttpServlet {

    private BorrowerService borrowerService = new BorrowerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        if (currentUser == null || !"borrower".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具使用者可以访问此页面");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            List<BorrowRecordToolsDTO> myRecords = borrowerService.getMyRecords(currentUser.getUserId());
            request.setAttribute("myRecords", myRecords);

        } catch (Exception e) {
            System.err.println("获取我的租借记录列表异常: " + e.getMessage());
            request.setAttribute("error", "获取我的租借记录列表失败");
        }

        request.getRequestDispatcher("/borrower/my-records.jsp").forward(request, response);
    }

}
