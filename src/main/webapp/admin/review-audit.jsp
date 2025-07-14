<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>评论审核 - 管理员控制台</title>
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
        color: #666;
        font-size: 14px;
      }

      .logout-btn {
        background: #dc3545;
        color: white;
        text-decoration: none;
        padding: 8px 16px;
        border-radius: 6px;
        font-size: 14px;
        transition: all 0.3s ease;
      }

      .logout-btn:hover {
        background: #c82333;
        transform: translateY(-1px);
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
        transition: all 0.3s ease;
        font-weight: 500;
      }

      .nav-menu a:hover {
        background: #e3f2fd;
        color: #007bff;
      }

      .nav-menu a.active {
        background: #007bff;
        color: white;
      }

      .main-content {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .main-content h2 {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 10px;
        font-weight: 600;
      }

      .main-content p {
        color: #6c757d;
        margin-bottom: 20px;
        font-size: 16px;
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

      .stats-info {
        background: #f8f9fa;
        border: 1px solid #dee2e6;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        text-align: center;
        color: #495057;
      }

      .stats-info strong {
        color: #007bff;
        font-size: 18px;
      }

      .review-list {
        display: grid;
        gap: 20px;
      }

      .review-card {
        border: 1px solid #e9ecef;
        border-radius: 10px;
        padding: 20px;
        background: #fafafa;
      }

      .review-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 1px solid #dee2e6;
      }

      .review-info {
        display: flex;
        gap: 20px;
        font-size: 14px;
        color: #666;
      }

      .review-rating {
        display: flex;
        align-items: center;
        gap: 5px;
      }

      .stars {
        color: #ffc107;
        font-size: 16px;
      }

      .review-content {
        margin: 15px 0;
        padding: 15px;
        background: white;
        border-radius: 6px;
        border-left: 4px solid #007bff;
        font-size: 15px;
        line-height: 1.6;
      }

      .review-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
        margin-top: 15px;
      }

      .btn {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        text-align: center;
      }

      .btn-approve {
        background: #28a745;
        color: white;
      }

      .btn-approve:hover {
        background: #218838;
        transform: translateY(-1px);
      }

      .btn-reject {
        background: #dc3545;
        color: white;
      }

      .btn-reject:hover {
        background: #c82333;
        transform: translateY(-1px);
      }

      .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #6c757d;
      }

      .empty-state div {
        font-size: 48px;
        margin-bottom: 20px;
      }

      .empty-state p {
        font-size: 18px;
        margin-bottom: 10px;
      }

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
        }

        .review-header {
          flex-direction: column;
          align-items: flex-start;
          gap: 10px;
        }

        .review-info {
          flex-direction: column;
          gap: 5px;
        }

        .review-actions {
          flex-direction: column;
          gap: 10px;
        }

        .btn {
          width: 100%;
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
            <a href="${pageContext.request.contextPath}/admin/tool-list"
              >工具审核</a
            >
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/admin/review-audit"
              class="active"
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

      <!-- 主要内容区域 -->
      <div class="main-content">
        <h2>评论审核</h2>
        <!-- 待审核评论列表 -->
        <c:choose>
          <c:when test="${not empty pendingReviews}">
            <div class="review-list">
              <c:forEach var="review" items="${pendingReviews}">
                <div class="review-card">
                  <div class="review-header">
                    <div class="review-info">
                      <span>评论ID: ${review.reviewId}</span>
                      <span>用户ID: ${review.userId}</span>
                      <span>工具ID: ${review.toolId}</span>
                      <span
                        >提交时间:
                        <c:choose>
                          <c:when test="${not empty review.createdAt}">
                            ${review.createdAt.toString().substring(0,
                            19).replace('T', ' ')}
                          </c:when>
                          <c:otherwise>未知</c:otherwise>
                        </c:choose>
                      </span>
                    </div>
                    <div class="review-rating">
                      <span class="stars">
                        <c:forEach begin="1" end="${review.rating}"
                          >★</c:forEach
                        >
                        <c:forEach begin="${review.rating + 1}" end="5"
                          >☆</c:forEach
                        >
                      </span>
                      <span>${review.rating}/5分</span>
                    </div>
                  </div>

                  <c:if test="${not empty review.reviewContent}">
                    <div class="review-content">${review.reviewContent}</div>
                  </c:if>

                  <div class="review-actions">
                    <form
                      method="post"
                      action="${pageContext.request.contextPath}/admin/review-audit"
                      style="display: inline"
                    >
                      <input type="hidden" name="action" value="approve" />
                      <input
                        type="hidden"
                        name="reviewId"
                        value="${review.reviewId}"
                      />
                      <button type="submit" class="btn btn-approve">
                        通过
                      </button>
                    </form>
                    <button
                      type="button"
                      class="btn btn-reject"
                      onclick="rejectReview('${review.reviewId}')"
                    >
                      拒绝
                    </button>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <p>暂无待审核的评论</p>
              <p style="font-size: 14px; margin-top: 10px">
                所有评论都已处理完毕
              </p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        // 自动隐藏消息提示
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);
      });

      function rejectReview(reviewId) {
        // 创建表单并提交
        const form = $("<form>", {
          method: "POST",
          action: "${pageContext.request.contextPath}/admin/review-audit",
        });

        form.append(
          $("<input>", {
            type: "hidden",
            name: "action",
            value: "reject",
          })
        );

        form.append(
          $("<input>", {
            type: "hidden",
            name: "reviewId",
            value: reviewId,
          })
        );

        // 添加默认拒绝原因
        form.append(
          $("<input>", {
            type: "hidden",
            name: "reason",
            value: "管理员拒绝",
          })
        );

        $("body").append(form);
        form.submit();
      }
    </script>
  </body>
</html>
