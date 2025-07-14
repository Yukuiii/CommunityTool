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

@WebServlet("/borrower/review-tool")
public class ReviewToolServlet extends HttpServlet {

    private BorrowerService borrowerService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.borrowerService = new BorrowerService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        if (currentUser == null || !"borrower".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具使用者可以访问此页面");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        Integer toolId = Integer.parseInt(request.getParameter("toolId"));
        Integer rating = Integer.parseInt(request.getParameter("rating"));
        Integer recordId = Integer.parseInt(request.getParameter("recordId"));
        String comment = request.getParameter("comment");

        try {
            borrowerService.reviewTool(toolId, currentUser.getUserId(), rating, comment, recordId);
        } catch (Exception e) {
            System.err.println("评价工具异常: " + e.getMessage());
            request.setAttribute("error", "评价工具失败，请稍后重试");
        }

        List<BorrowRecordToolsDTO> myRecords = borrowerService.getMyRecords(currentUser.getUserId());
        request.setAttribute("myRecords", myRecords);
        request.getRequestDispatcher("/borrower/my-records.jsp").forward(request, response);
    }
}
