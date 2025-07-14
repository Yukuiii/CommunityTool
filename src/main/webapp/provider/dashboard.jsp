<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>我的工具 - 社区租借系统</title>
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
        background: #dc3545;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        text-decoration: none;
        font-size: 14px;
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
        flex-wrap: wrap;
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

      .content-grid {
        margin-bottom: 40px;
      }

      .content-section {
        background: white;
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        width: 100%;
      }

      .section-title {
        font-size: 20px;
        color: #2c3e50;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid #e9ecef;
      }

      .tools-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 20px;
        margin-top: 20px;
      }

      .tool-item,
      .request-item {
        padding: 20px;
        border: 1px solid #e9ecef;
        border-radius: 12px;
        background: #fafbfc;
      }

      .tool-name,
      .request-tool {
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 12px;
        font-size: 18px;
        line-height: 1.3;
      }

      .tool-info,
      .request-info {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 10px;
        line-height: 1.4;
      }

      .status-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
      }

      .status-pending {
        background: #fff3cd;
        color: #856404;
      }
      .status-available {
        background: #d4edda;
        color: #155724;
      }
      .status-rented {
        background: #d1ecf1;
        color: #0c5460;
      }
      .status-rejected {
        background: #f8d7da;
        color: #721c24;
      }
      .status-offline {
        background: #e2e3e5;
        color: #383d41;
      }

      /* 工具管理按钮样式 */
      .tool-actions {
        display: flex;
        gap: 10px;
        margin-top: 20px;
        justify-content: flex-start;
        align-items: center;
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

      .btn-success {
        background: #28a745;
        color: white;
      }

      .btn-warning {
        background: #ffc107;
        color: #212529;
      }

      .reviews-section {
        margin-top: 15px;
        padding-top: 15px;
        border-top: 1px solid #e9ecef;
      }

      .reviews-title {
        font-size: 14px;
        font-weight: 600;
        color: #495057;
        margin-bottom: 10px;
      }

      .review-item {
        background: #f8f9fa;
        padding: 10px;
        border-radius: 6px;
        margin-bottom: 8px;
        font-size: 13px;
      }

      .review-rating {
        color: #ffc107;
        font-weight: 600;
        margin-right: 8px;
      }

      .review-content {
        color: #6c757d;
        margin-top: 5px;
        line-height: 1.4;
      }

      .review-status {
        font-size: 11px;
        padding: 2px 6px;
        border-radius: 10px;
        margin-left: 8px;
      }

      .review-status.pending {
        background: #fff3cd;
        color: #856404;
      }

      .review-status.approved {
        background: #d4edda;
        color: #155724;
      }

      .review-status.rejected {
        background: #f8d7da;
        color: #721c24;
      }

      .empty-state {
        text-align: center;
        color: #6c757d;
        padding: 40px 20px;
      }

      .empty-state i {
        font-size: 48px;
        margin-bottom: 15px;
        opacity: 0.5;
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

      .footer {
        margin-top: 50px;
        padding: 30px 0;
        text-align: center;
        color: #6c757d;
        border-top: 1px solid #e9ecef;
      }

      .user-role-badge {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        margin-left: 10px;
      }

      .role-provider {
        background: #e3f2fd;
        color: #1976d2;
      }

      .role-borrower {
        background: #e8f5e8;
        color: #2e7d32;
      }

      @media (max-width: 768px) {
        .tools-grid {
          grid-template-columns: 1fr;
        }

        .nav-menu ul {
          flex-direction: column;
        }

        .tool-item {
          padding: 15px;
        }
      }
    </style>
  </head>
  <body>
    <!-- 页面头部 -->
    <div class="header">
      <div class="header-content">
        <h1>
          <c:choose>
            <c:when test="${sessionScope.userRole == 'provider'}">
              社区工具租借系统
            </c:when>
            <c:otherwise> 社区工具租借系统 </c:otherwise>
          </c:choose>
        </h1>
        <div class="user-info">
          <span>欢迎，${sessionScope.user.username}</span>
          <span
            class="user-role-badge ${sessionScope.userRole == 'provider' ? 'role-provider' : 'role-borrower'}"
          >
            ${sessionScope.userRole == 'provider' ? '工具提供者' : '工具使用者'}
          </span>
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
              href="${pageContext.request.contextPath}/provider/dashboard"
              class="active"
              >我的工具</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/provider/tool-upload"
              >上传工具</a
            >
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/provider/rental-approval"
              >租借审批</a
            >
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/provider/confirm-return-tool"
              >待确认归还</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/profile">个人信息</a>
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

      <!-- 内容区域 -->
      <div class="content-grid">
        <!-- 我的工具 -->
        <div class="content-section">
          <h2 class="section-title">我的工具</h2>
          <c:choose>
            <c:when test="${not empty providerTools}">
              <div class="tools-grid">
                <c:forEach var="toolDto" items="${providerTools}">
                  <div class="tool-item">
                    <div class="tool-name">${toolDto.tool.toolName}</div>
                    <div class="tool-info">
                      租金: ¥${toolDto.tool.rentalFee}/天
                    </div>
                    <div class="tool-info">
                      <span
                        class="status-badge status-${toolDto.tool.status == '待审核' ? 'pending' : toolDto.tool.status == '闲置' ? 'available' : toolDto.tool.status == '已借出' ? 'rented' : toolDto.tool.status == '已拒绝' ? 'rejected' : 'offline'}"
                        >${toolDto.tool.status}</span
                      >
                      <c:if test="${toolDto.tool.status == '已拒绝'}">
                        <span class="status-badge status-rejected">
                          拒绝原因: ${toolDto.tool.reason}
                        </span>
                      </c:if>
                    </div>

                    <!-- 工具管理按钮 -->
                    <div class="tool-actions">
                      <c:choose>
                        <c:when test="${toolDto.tool.status == '闲置'}">
                          <form
                            method="post"
                            action="${pageContext.request.contextPath}/provider/tool-manager"
                            style="display: inline"
                          >
                            <input
                              type="hidden"
                              name="toolId"
                              value="${toolDto.tool.toolId}"
                            />
                            <input type="hidden" name="action" value="down" />
                            <button type="submit" class="btn btn-warning">
                              下架工具
                            </button>
                          </form>
                        </c:when>
                        <c:when test="${toolDto.tool.status == '下架'}">
                          <form
                            method="post"
                            action="${pageContext.request.contextPath}/provider/tool-manager"
                            style="display: inline"
                          >
                            <input
                              type="hidden"
                              name="toolId"
                              value="${toolDto.tool.toolId}"
                            />
                            <input type="hidden" name="action" value="up" />
                            <button type="submit" class="btn btn-success">
                              上架工具
                            </button>
                          </form>
                        </c:when>
                      </c:choose>
                    </div>

                    <!-- 评价信息展示 -->
                    <c:if test="${not empty toolDto.reviews}">
                      <div class="reviews-section">
                        <div class="reviews-title">
                          用户评价 (${toolDto.reviews.size()}条)
                        </div>
                        <c:forEach
                          var="review"
                          items="${toolDto.reviews}"
                          begin="0"
                          end="2"
                        >
                          <div class="review-item">
                            <span class="review-rating">
                              <c:forEach begin="1" end="${review.rating}"
                                >★</c:forEach
                              >
                              <c:forEach begin="${review.rating + 1}" end="5"
                                >☆</c:forEach
                              >
                            </span>
                            <span
                              class="review-status ${review.status == '待审核' ? 'pending' : review.status == '已通过' ? 'approved' : 'rejected'}"
                            >
                              ${review.status}
                            </span>
                            <c:if test="${not empty review.reviewContent}">
                              <div class="review-content">
                                ${review.reviewContent}
                              </div>
                            </c:if>
                            <c:if test="${review.status == '已拒绝'}">
                              <div class="review-content">
                                拒绝原因: ${review.reason}
                              </div>
                            </c:if>
                          </div>
                        </c:forEach>
                        <c:if test="${toolDto.reviews.size() > 3}">
                          <div
                            style="
                              text-align: center;
                              margin-top: 8px;
                              font-size: 12px;
                              color: #6c757d;
                            "
                          >
                            还有 ${toolDto.reviews.size() - 3} 条评价...
                          </div>
                        </c:if>
                      </div>
                    </c:if>
                  </div>
                </c:forEach>
              </div>
            </c:when>
            <c:otherwise>
              <div class="empty-state">
                <p>
                  暂无工具，<a
                    href="${pageContext.request.contextPath}/provider/tool-upload"
                    >立即上传</a
                  >
                </p>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        // 自动隐藏消息
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);
      });
    </script>
  </body>
</html>
