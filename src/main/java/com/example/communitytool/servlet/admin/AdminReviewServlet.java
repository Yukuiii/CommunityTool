package com.example.communitytool.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.pojo.Review;
import com.example.communitytool.service.admin.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 管理员评论审核处理Servlet
 * 处理管理员的评论审核相关请求
 */
@WebServlet("/admin/review-audit")
public class AdminReviewServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        showPendingReviews(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            request.setAttribute("error", "操作参数缺失");
            showPendingReviews(request, response);
            return;
        }

        switch (action) {
            case "approve":
                handleApprove(request, response);
                break;
            case "reject":
                handleReject(request, response);
                break;
            default:
                request.setAttribute("error", "未知操作: " + action);
                showPendingReviews(request, response);
                break;
        }
    }

    /**
     * 显示待审核评论列表
     */
    private void showPendingReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Review> pendingReviews = adminService.getPendingReviews();
            request.setAttribute("pendingReviews", pendingReviews);
            request.setAttribute("pendingCount", pendingReviews != null ? pendingReviews.size() : 0);
            
            request.getRequestDispatcher("/admin/review-audit.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("显示待审核评论列表异常: " + e.getMessage());
            request.setAttribute("error", "获取待审核评论列表失败");
            request.getRequestDispatcher("/admin/review-audit.jsp").forward(request, response);
        }
    }

    /**
     * 处理审核通过
     */
    private void handleApprove(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String reviewIdStr = request.getParameter("reviewId");

        try {
            Integer reviewId = Integer.parseInt(reviewIdStr.trim());
            adminService.approveReview(reviewId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "评论ID格式错误");
        } catch (Exception e) {
            System.err.println("处理审核通过异常: " + e.getMessage());
            request.setAttribute("error", "审核通过操作失败");
        }

        // 重新显示待审核评论列表
        showPendingReviews(request, response);
    }

    /**
     * 处理审核拒绝
     */
    private void handleReject(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String reviewIdStr = request.getParameter("reviewId");
        String reason = request.getParameter("reason");
        try {
            Integer reviewId = Integer.parseInt(reviewIdStr.trim());
            adminService.rejectReview(reviewId, reason);

        } catch (Exception e) {
            System.err.println("处理审核拒绝异常: " + e.getMessage());
            request.setAttribute("error", "审核拒绝操作失败");
        }

        // 重新显示待审核评论列表
        showPendingReviews(request, response);
    }
}
