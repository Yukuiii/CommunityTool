<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>工具审核 - 管理员控制台</title>
    <!-- 引入jQuery -->
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Microsoft YaHei", Arial, sans-serif;
        background: #f8f9fa;
        min-height: 100vh;
      }

      .header {
        background: white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        padding: 15px 0;
        margin-bottom: 30px;
      }

      .header-content {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .header h1 {
        color: #2c3e50;
        font-size: 24px;
      }

      .user-info {
        display: flex;
        align-items: center;
        gap: 15px;
      }

      .user-info span {
        color: #6c757d;
      }

      .logout-btn {
        color: #dc3545;
        text-decoration: none;
        padding: 8px 16px;
        border: 1px solid #dc3545;
        border-radius: 6px;
      }

      .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
      }

      .nav-menu {
        background: white;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .nav-menu ul {
        list-style: none;
        display: flex;
        gap: 20px;
      }

      .nav-menu a {
        color: #6c757d;
        text-decoration: none;
        padding: 12px 20px;
        border-radius: 8px;
        font-weight: 500;
      }

      .nav-menu a.active {
        background: #007bff;
        color: white;
      }

      .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 8px;
        font-weight: 500;
      }

      .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }

      .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }

      .requests-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .requests-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 1px solid #e9ecef;
      }

      .requests-title {
        font-size: 20px;
        color: #2c3e50;
        font-weight: 600;
      }

      .requests-count {
        background: #007bff;
        color: white;
        padding: 6px 12px;
        border-radius: 15px;
        font-weight: 500;
        font-size: 14px;
      }

      .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 8px;
        font-weight: 500;
      }

      .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }

      .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }

      .requests-grid {
        display: grid;
        gap: 20px;
      }

      .request-card {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        border-left: 4px solid #007bff;
        border: 1px solid #e9ecef;
      }

      .request-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 15px;
      }

      .request-info {
        flex: 1;
      }

      .request-id {
        font-size: 16px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 8px;
      }

      .status-badge {
        padding: 4px 8px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 500;
        text-transform: uppercase;
      }

      .status-pending {
        background: #fff3cd;
        color: #856404;
        border: 1px solid #ffeaa7;
      }

      .request-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 15px;
        margin-bottom: 20px;
      }

      .detail-item {
        display: flex;
        flex-direction: column;
      }

      .detail-label {
        font-size: 12px;
        color: #6c757d;
        font-weight: 500;
        margin-bottom: 4px;
      }

      .detail-value {
        font-size: 14px;
        color: #2c3e50;
        font-weight: 500;
      }

      .tool-description {
        background: white;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        border-left: 4px solid #28a745;
      }

      .tool-description .label {
        font-size: 12px;
        color: #6c757d;
        text-transform: uppercase;
        margin-bottom: 8px;
        font-weight: 500;
      }

      .tool-description .content {
        color: #495057;
        line-height: 1.6;
      }

      .request-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
      }

      .btn {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        font-weight: 500;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        text-align: center;
        font-size: 14px;
      }

      .btn-approve {
        background: #28a745;
        color: white;
      }

      .btn-reject {
        background: #dc3545;
        color: white;
      }

      .btn-primary {
        background: #007bff;
        color: white;
      }

      .btn-success {
        background: #28a745;
        color: white;
      }

      .btn-danger {
        background: #dc3545;
        color: white;
      }

      .empty-state {
        text-align: center;
        padding: 40px 20px;
        color: #6c757d;
      }

      .empty-state h3 {
        font-size: 18px;
        margin-bottom: 10px;
        color: #495057;
      }

      .empty-state p {
        font-size: 14px;
        line-height: 1.5;
      }

      .footer {
        margin-top: 50px;
        padding: 30px 0;
        text-align: center;
        color: #6c757d;
        border-top: 1px solid #e9ecef;
      }

      .loading {
        display: inline-block;
        animation: spin 1s linear infinite;
      }

      @keyframes spin {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
        }

        .request-details {
          grid-template-columns: 1fr;
        }

        .request-actions {
          flex-direction: column;
        }
      }
    </style>
  </head>
  <body>
    <!-- 页面头部 -->
    <div class="header">
      <div class="header-content">
        <h1>管理员控制台</h1>
        <div class="user-info">
          <span>欢迎，${sessionScope.user.realName}</span>
          <a href="${pageContext.request.contextPath}/logout" class="logout-btn"
            >退出登录</a
          >
        </div>
      </div>
    </div>

    <div class="container">
      <!-- 导航菜单 -->
      <div class="nav-menu">
        <ul>
          <li>
            <a
              href="${pageContext.request.contextPath}/admin/tool-list"
              class="active"
              >工具审核</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/review-audit"
              >评论审核</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/user-manager"
              >用户管理</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/tool-manager"
              >工具管理</a
            >
          </li>
        </ul>
      </div>

      <!-- 显示消息 -->
      <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
      </c:if>

      <!-- 待审核工具 -->
      <div class="requests-container">
        <div class="requests-header">
          <h2 class="requests-title">待审核的工具</h2>
        </div>

        <div class="requests-grid">
          <c:choose>
            <c:when test="${empty pendingTools}">
              <div class="empty-state">
                <h3>暂无待审核工具</h3>
                <p>目前没有需要审核的工具申请</p>
              </div>
            </c:when>
            <c:otherwise>
              <c:forEach var="tool" items="${pendingTools}">
                <div class="request-card">
                  <div class="request-header">
                    <div class="request-info">
                      <div class="request-id">工具审核 #${tool.toolId}</div>
                      <span class="status-badge status-pending"
                        >${tool.status}</span
                      >
                    </div>
                  </div>

                  <div class="request-details">
                    <div class="detail-item">
                      <div class="detail-label">工具名称</div>
                      <div class="detail-value">${tool.toolName}</div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">提供者ID</div>
                      <div class="detail-value">${tool.providerId}</div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">租金</div>
                      <div class="detail-value">¥${tool.rentalFee}/天</div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">工具位置</div>
                      <div class="detail-value">
                        <c:choose>
                          <c:when test="${not empty tool.location}">
                            ${tool.location}
                          </c:when>
                          <c:otherwise>
                            <span style="color: #6c757d; font-style: italic"
                              >未设置</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">提交时间</div>
                      <div class="detail-value">
                        ${tool.createdAt.toString().substring(0,
                        19).replace('T', ' ')}
                      </div>
                    </div>
                  </div>

                  <div class="tool-description">
                    <div class="label">工具描述</div>
                    <div class="content">${tool.description}</div>
                  </div>

                  <div class="request-actions">
                    <button
                      class="btn btn-approve"
                      onclick="approveTool('${tool.toolId}')"
                    >
                      ✓ 审核通过
                    </button>
                    <button
                      class="btn btn-reject"
                      onclick="rejectTool('${tool.toolId}')"
                    >
                      ✗ 审核驳回
                    </button>
                  </div>
                </div>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        // 自动隐藏消息提示
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);
      });

      function approveTool(toolId) {
        // 创建表单并提交
        const form = $("<form>", {
          method: "POST",
          action: "${pageContext.request.contextPath}/admin/tool-approve",
        });

        form.append(
          $("<input>", {
            type: "hidden",
            name: "toolId",
            value: toolId,
          })
        );

        $("body").append(form);
        form.submit();
      }

      function rejectTool(toolId) {
        // 创建表单并提交
        const form = $("<form>", {
          method: "POST",
          action: "${pageContext.request.contextPath}/admin/tool-reject",
        });

        form.append(
          $("<input>", {
            type: "hidden",
            name: "toolId",
            value: toolId,
          })
        );

        // 添加空的拒绝原因（后端可以处理默认值）
        form.append(
          $("<input>", {
            type: "hidden",
            name: "reason",
            value: "管理员驳回",
          })
        );

        $("body").append(form);
        form.submit();
      }
    </script>
  </body>
</html>
