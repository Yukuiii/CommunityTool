package com.example.communitytool.servlet.provider;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.dto.BorrowRecordToolsDTO;
import com.example.communitytool.pojo.User;
import com.example.communitytool.service.provider.ProviderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/provider/confirm-return-tool")
public class ConfirmReturnToolServlet extends HttpServlet {

    private ProviderService providerService = new ProviderService();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        if (currentUser == null || !"provider".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具提供者可以访问此页面");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        // 获取待确认归还的工具
        List<BorrowRecordToolsDTO> pendingReturnTools = providerService.getPendingReturnTools(currentUser.getUserId());
        request.setAttribute("pendingReturnTools", pendingReturnTools);
        request.getRequestDispatcher("/provider/confirm-return-tool.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        if (currentUser == null || !"provider".equals(userRole)) {
            request.setAttribute("error", "权限不足，只有工具提供者可以访问此页面");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        String recordIdParam = request.getParameter("recordId");

        try {
            Integer recordId = Integer.parseInt(recordIdParam);
            boolean success = providerService.confirmReturnTool(currentUser.getUserId(), recordId);
            if (success) {
                request.setAttribute("message", "确认归还工具成功");
            } else {
                request.setAttribute("error", "确认归还工具失败");
            }
        } catch (Exception e) {
            System.err.println("确认归还工具失败: " + e.getMessage());
            request.setAttribute("error", "确认归还工具失败，请稍后重试，错误信息: " + e.getMessage());
        }

        // 重新获取待确认归还的工具列表并转发到页面
        List<BorrowRecordToolsDTO> pendingReturnTools = providerService.getPendingReturnTools(currentUser.getUserId());
        request.setAttribute("pendingReturnTools", pendingReturnTools);
        request.getRequestDispatcher("/provider/confirm-return-tool.jsp").forward(request, response);
    }
}
