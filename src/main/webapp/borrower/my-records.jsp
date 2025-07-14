<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>我的租借工具 - 社区租借系统</title>
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

      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
      }

      .stat-card {
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        text-align: center;
      }

      .stat-number {
        font-size: 32px;
        font-weight: bold;
        color: #007bff;
        margin-bottom: 5px;
      }

      .stat-label {
        color: #6c757d;
        font-size: 14px;
      }

      .tools-section {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        overflow: hidden;
      }

      .section-header {
        background: #f8f9fa;
        padding: 20px;
        border-bottom: 1px solid #e9ecef;
      }

      .section-title {
        font-size: 18px;
        color: #2c3e50;
        margin: 0;
      }

      .tools-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 20px;
        padding: 20px;
      }

      .tool-card {
        border: 1px solid #e9ecef;
        border-radius: 8px;
        padding: 20px;
      }

      .tool-name {
        font-size: 16px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 10px;
      }

      .tool-description {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 15px;
        line-height: 1.5;
      }

      .tool-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
      }

      .tool-fee {
        font-size: 16px;
        font-weight: bold;
        color: #28a745;
      }

      .tool-provider {
        font-size: 12px;
        color: #6c757d;
      }

      .status-badge {
        display: inline-block;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
        text-align: center;
      }

      .status-pending {
        background: #fff3cd;
        color: #856404;
        border: 1px solid #ffeaa7;
      }

      .status-available {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }

      .status-rented {
        background: #cce5ff;
        color: #004085;
        border: 1px solid #99d6ff;
      }

      .status-rejected {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }

      .status-offline {
        background: #e2e3e5;
        color: #383d41;
        border: 1px solid #d6d8db;
      }

      .return-btn {
        background: #28a745;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        margin-top: 10px;
        width: 100%;
      }

      .review-btn {
        background: #007bff;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        margin-top: 10px;
        width: 100%;
      }

      .return-btn:disabled {
        background: #6c757d;
        cursor: not-allowed;
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

      .empty-state a {
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
      }

      .footer {
        text-align: center;
        padding: 30px 0;
        color: #6c757d;
        border-top: 1px solid #e9ecef;
        margin-top: 50px;
      }

      /* 模态框样式 */
      .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
      }

      .modal-content {
        background-color: white;
        margin: 10% auto;
        padding: 30px;
        border-radius: 10px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        position: relative;
      }

      .modal-header {
        text-align: center;
        margin-bottom: 25px;
      }

      .modal-header h2 {
        color: #333;
        font-size: 24px;
        margin-bottom: 10px;
      }

      .close {
        position: absolute;
        right: 15px;
        top: 15px;
        color: #aaa;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        line-height: 1;
      }

      .form-group {
        margin-bottom: 20px;
      }

      .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #333;
      }

      .rating-container {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-bottom: 15px;
      }

      .rating-option {
        display: flex;
        align-items: center;
        gap: 5px;
        cursor: pointer;
        font-size: 14px;
        color: #333;
      }

      .rating-option input[type="radio"] {
        margin: 0;
        cursor: pointer;
      }

      .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 2px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        font-family: inherit;
        resize: vertical;
        min-height: 100px;
      }

      .form-group textarea:focus {
        outline: none;
      }

      .modal-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 25px;
      }

      .btn-submit {
        background: #007bff;
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
      }

      .btn-cancel {
        background: #6c757d;
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
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

      .time-info {
        background: #f8f9fa;
        border-radius: 6px;
        padding: 10px;
        margin-top: 10px;
        font-size: 12px;
        color: #6c757d;
        border-left: 3px solid #007bff;
      }

      .time-info div {
        margin-bottom: 5px;
      }

      .time-info div:last-child {
        margin-bottom: 0;
      }

      .time-info strong {
        color: #495057;
        font-weight: 600;
      }

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
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
            <a href="${pageContext.request.contextPath}/borrower/dashboard"
              >可租借工具</a
            >
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/borrower/my-records"
              class="active"
              >我的租借</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/profile">个人信息</a>
          </li>
        </ul>
      </div>

      <!-- 显示错误或成功消息 -->
      <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
      </c:if>
      <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
      </c:if>

      <!-- 我的租借记录列表 -->
      <div class="tools-section">
        <div class="section-header">
          <h2 class="section-title">我的租借记录</h2>
        </div>

        <c:choose>
          <c:when test="${not empty myRecords}">
            <div class="tools-grid">
              <c:forEach var="record" items="${myRecords}">
                <div class="tool-card">
                  <div class="tool-name">${record.tool.toolName}</div>
                  <div class="tool-description">${record.tool.description}</div>
                  <div class="tool-info">
                    <div class="tool-fee">
                      ¥${record.borrowRecord.rentalFee}/天
                    </div>
                    <div class="tool-provider">
                      提供者ID: ${record.tool.providerId}
                    </div>
                  </div>

                  <!-- 时间信息显示 -->
                  <div class="time-info">
                    <div>
                      <strong>借用时间：</strong>
                      <c:choose>
                        <c:when
                          test="${not empty record.borrowRecord.borrowTime}"
                        >
                          ${record.borrowRecord.borrowTime.toString().replace('T',
                          ' ').substring(0, 19)}
                        </c:when>
                        <c:otherwise> 未记录 </c:otherwise>
                      </c:choose>
                    </div>

                    <!-- 只有已归还和已评价状态才显示归还时间 -->
                    <c:if
                      test="${record.borrowRecord.status == '已归还' || record.borrowRecord.status == '已评价'}"
                    >
                      <div>
                        <strong>归还时间：</strong>
                        <c:choose>
                          <c:when
                            test="${not empty record.borrowRecord.returnTime}"
                          >
                            ${record.borrowRecord.returnTime.toString().replace('T',
                            ' ').substring(0, 19)}
                          </c:when>
                          <c:otherwise> 未记录 </c:otherwise>
                        </c:choose>
                      </div>
                    </c:if>
                  </div>
                  <div style="text-align: center; margin-top: 15px">
                    <span
                      class="status-badge status-${record.borrowRecord.status == '待审核' ? 'pending' : record.borrowRecord.status == '闲置' ? 'available' : record.borrowRecord.status == '借用中' ? 'rented' : record.borrowRecord.status == '已拒绝' ? 'rejected' : 'offline'}"
                    >
                      ${record.borrowRecord.status}
                    </span>

                    <!-- 如果状态是借用中，显示归还按钮 -->
                    <c:if test="${record.borrowRecord.status == '借用中'}">
                      <form
                        method="post"
                        action="${pageContext.request.contextPath}/borrower/return-tool"
                        style="margin-top: 10px"
                      >
                        <input
                          type="hidden"
                          name="recordId"
                          value="${record.borrowRecord.recordId}"
                        />
                        <button type="submit" class="return-btn">
                          归还工具
                        </button>
                      </form>
                    </c:if>

                    <!-- 如果状态是已归还，显示评价按钮 -->
                    <c:if test="${record.borrowRecord.status == '已归还'}">
                      <button
                        type="button"
                        class="review-btn"
                        onclick="openReviewModal('${record.tool.toolId}', '${record.tool.toolName}', '${record.borrowRecord.recordId}')"
                        style="margin-top: 10px"
                      >
                        评价工具
                      </button>
                    </c:if>
                    <c:if test="${record.borrowRecord.status == '已拒绝'}">
                      <div class="reason">
                        拒绝原因: ${record.borrowRecord.reason}
                      </div>
                    </c:if>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <p>您还没有租借任何工具</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- 评价工具模态框 -->
    <div id="reviewModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <span class="close">&times;</span>
          <h2>评价工具</h2>
          <p id="toolNameDisplay" style="color: #666; font-size: 16px"></p>
        </div>

        <form
          id="reviewForm"
          method="post"
          action="${pageContext.request.contextPath}/borrower/review-tool"
        >
          <input type="hidden" id="toolId" name="toolId" />
          <input type="hidden" id="recordId" name="recordId" />

          <div class="form-group">
            <label>评分 *</label>
            <div class="rating-container">
              <label class="rating-option">
                <input type="radio" name="rating" value="1" required />
                1分
              </label>
              <label class="rating-option">
                <input type="radio" name="rating" value="2" required />
                2分
              </label>
              <label class="rating-option">
                <input type="radio" name="rating" value="3" required />
                3分
              </label>
              <label class="rating-option">
                <input type="radio" name="rating" value="4" required />
                4分
              </label>
              <label class="rating-option">
                <input type="radio" name="rating" value="5" required />
                5分
              </label>
            </div>
          </div>

          <div class="form-group">
            <label for="comment">评价内容</label>
            <textarea
              id="comment"
              name="comment"
              placeholder="请分享您对这个工具的使用体验..."
              maxlength="500"
            ></textarea>
          </div>

          <div class="modal-buttons">
            <button
              type="button"
              class="btn-cancel"
              onclick="closeReviewModal()"
            >
              取消
            </button>
            <button type="submit" class="btn-submit">提交评价</button>
          </div>
        </form>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        // 自动隐藏消息提示
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);
      });

      // 打开评价模态框
      function openReviewModal(toolId, toolName, recordId) {
        $("#toolId").val(toolId);
        $("#recordId").val(recordId);
        $("#toolNameDisplay").text(toolName);
        $("#reviewModal").show();

        // 重置表单
        $("input[name='rating']").prop("checked", false);
        $("#comment").val("");
      }

      // 关闭评价模态框
      function closeReviewModal() {
        $("#reviewModal").hide();
      }

      $(document).ready(function () {
        // 点击模态框外部关闭
        $(window).click(function (event) {
          if (event.target.id === "reviewModal") {
            closeReviewModal();
          }
        });

        // 点击关闭按钮
        $(".close").click(function () {
          closeReviewModal();
        });
      });
    </script>
  </body>
</html>
