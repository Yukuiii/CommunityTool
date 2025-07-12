package com.example.communitytool.servlet.provider;

import java.io.IOException;
import java.util.List;

import com.example.communitytool.dto.BorrowRecordToolsDTO;
import com.example.communitytool.dto.ToolsReviewDTO;
import com.example.communitytool.pojo.Tool;
import com.example.communitytool.pojo.User;
import com.example.communitytool.service.provider.ProviderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * 负责工具提供者上下架工具
 */
@WebServlet("/provider/tool-manager")
public class ToolManagerServlet extends HttpServlet {

    private ProviderService providerService = new ProviderService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");

        if (currentUser == null || !"provider".equals(userRole)) {
            req.setAttribute("error", "权限不足，只有工具提供者可以访问此页面");
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
            return;
        }

        String toolId = req.getParameter("toolId");
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "up":
                    providerService.updateToolStatus(Integer.parseInt(toolId), Tool.STATUS_AVAILABLE);
                    break;
                case "down":
                    providerService.updateToolStatus(Integer.parseInt(toolId), Tool.STATUS_OFFLINE);
                    break;
                default:
                    throw new Exception("未知的操作类型: " + action);
            }
            req.setAttribute("message", "操作成功");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }

        // 无论成功还是失败，都重新获取工具列表并转发到JSP页面
        List<ToolsReviewDTO> providerTools = providerService.getProviderTools(currentUser.getUserId());
            
        // 获取待审批的租借请求
        List<BorrowRecordToolsDTO> pendingRequests = providerService.getPendingRentalRequests(currentUser.getUserId());
        
        // 设置请求属性
        req.setAttribute("providerTools", providerTools);
        req.setAttribute("pendingRequests", pendingRequests);
        // 转发到仪表盘页面
        req.getRequestDispatcher("/provider/dashboard.jsp").forward(req, resp);
    }
}
