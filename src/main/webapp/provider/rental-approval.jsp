<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>租借审批 - 社区租借系统</title>
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

      .logout-btn:hover {
        background: #c82333;
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

      .page-title {
        color: #2c3e50;
        font-size: 28px;
        margin-bottom: 30px;
        text-align: center;
      }

      .requests-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin-bottom: 30px;
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

      .requests-grid {
        display: grid;
        gap: 20px;
      }

      .request-card {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        border-left: 4px solid #007bff;
        transition: all 0.3s ease;
        border: 1px solid #e9ecef;
      }

      .request-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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

      .request-actions {
        display: flex;
        gap: 10px;
        margin-top: 15px;
      }

      .btn {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        text-align: center;
        font-size: 14px;
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
        margin: 15% auto;
        padding: 0;
        border-radius: 8px;
        width: 500px;
        max-width: 90%;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        animation: modalSlideIn 0.3s ease;
      }

      @keyframes modalSlideIn {
        from {
          opacity: 0;
          transform: translateY(-50px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .modal-header {
        padding: 20px;
        border-bottom: 1px solid #e9ecef;
        background: #f8f9fa;
        border-radius: 8px 8px 0 0;
      }

      .modal-title {
        margin: 0;
        font-size: 18px;
        color: #2c3e50;
      }

      .modal-body {
        padding: 20px;
      }

      .form-group {
        margin-bottom: 20px;
      }

      .form-label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: #495057;
      }

      .form-control {
        width: 100%;
        padding: 10px;
        border: 1px solid #ced4da;
        border-radius: 6px;
        font-size: 14px;
        transition: border-color 0.3s ease;
      }

      .form-control:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
      }

      textarea.form-control {
        resize: vertical;
        min-height: 100px;
      }

      .modal-footer {
        padding: 15px 20px;
        border-top: 1px solid #e9ecef;
        text-align: right;
        background: #f8f9fa;
        border-radius: 0 0 8px 8px;
      }

      .modal-btn {
        padding: 8px 16px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        margin-left: 10px;
        transition: background 0.3s ease;
      }

      .modal-btn-cancel {
        background: #6c757d;
        color: white;
      }

      .modal-btn-cancel:hover {
        background: #5a6268;
      }

      .modal-btn-confirm {
        background: #dc3545;
        color: white;
      }

      .modal-btn-confirm:hover {
        background: #c82333;
      }

      .modal-btn:disabled {
        background: #6c757d;
        cursor: not-allowed;
      }

      @media (max-width: 768px) {
        .header-content {
          flex-direction: column;
          gap: 15px;
        }

        .nav-menu ul {
          flex-direction: column;
          gap: 10px;
        }

        .request-details {
          grid-template-columns: 1fr;
        }

        .request-actions {
          flex-direction: column;
        }

        .modal-content {
          width: 95%;
          margin: 10% auto;
        }
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
          <a href="${pageContext.request.contextPath}/logout" class="logout-btn">退出登录</a>
        </div>
      </div>
    </div>

    <div class="container">
      <!-- 导航菜单 -->
      <div class="nav-menu">
        <ul>
          <li><a href="${pageContext.request.contextPath}/provider/dashboard">我的工具</a></li>
          <li><a href="${pageContext.request.contextPath}/provider/tool-upload">上传工具</a></li>
          <li><a href="${pageContext.request.contextPath}/provider/rental-approval" class="active">租借审批</a></li>
          <li><a href="${pageContext.request.contextPath}/provider/confirm-return-tool">待确认归还</a></li>
          <li><a href="${pageContext.request.contextPath}/profile">个人信息</a></li>
        </ul>
      </div>

      <!-- 显示消息 -->
      <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
      </c:if>

      <!-- 待审批请求 -->
      <div class="requests-container">
        <div class="requests-header">
          <h2 class="requests-title">待审批的租借请求</h2>
          <div class="requests-count">${pendingCount} 个待审批</div>
        </div>

        <div class="requests-grid">
          <c:choose>
            <c:when test="${empty pendingRequests}">
              <div class="empty-state">
                <h3>暂无待审批请求</h3>
                <p>目前没有需要您审批的租借请求</p>
              </div>
            </c:when>
            <c:otherwise>
              <c:forEach var="request" items="${pendingRequests}">
                <div class="request-card">
                  <div class="request-header">
                    <div class="request-info">
                      <div class="request-id">租借请求 #${request.borrowRecord.recordId}</div>
                      <span class="status-badge status-pending">${request.borrowRecord.status}</span>
                    </div>
                  </div>

                  <div class="request-details">
                    <div class="detail-item">
                      <div class="detail-label">借用人ID</div>
                      <div class="detail-value">${request.borrowRecord.userId}</div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">工具ID</div>
                      <div class="detail-value">${request.borrowRecord.toolId}</div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">租金</div>
                      <div class="detail-value">¥${request.borrowRecord.rentalFee}</div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">借用时间</div>
                      <div class="detail-value">
                        <c:choose>
                          <c:when test="${not empty request.borrowRecord.borrowTime}">
                            ${request.borrowRecord.borrowTime.toString().substring(0, 16).replace('T', ' ')}
                          </c:when>
                          <c:otherwise>未设定</c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">归还时间</div>
                      <div class="detail-value">
                        <c:choose>
                          <c:when test="${not empty request.borrowRecord.returnTime}">
                            ${request.borrowRecord.returnTime.toString().substring(0, 16).replace('T', ' ')}
                          </c:when>
                          <c:otherwise>未设定</c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">申请时间</div>
                      <div class="detail-value">
                        <c:choose>
                          <c:when test="${not empty request.borrowRecord.createdAt}">
                            ${request.borrowRecord.createdAt.toString().substring(0, 16).replace('T', ' ')}
                          </c:when>
                          <c:otherwise>未知</c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                  </div>

                  <div class="request-actions">
                    <form method="post" style="display: inline;">
                      <input type="hidden" name="recordId" value="${request.borrowRecord.recordId}">
                      <input type="hidden" name="action" value="approve">
                      <button type="submit" class="btn btn-approve"
                              onclick="return confirm('确定要批准这个租借请求吗？')">
                        ✓ 批准
                      </button>
                    </form>
                    <button type="button" class="btn btn-reject"
                            onclick="showRejectModal('${request.borrowRecord.recordId}')">
                      ✗ 拒绝
                    </button>
                  </div>
                </div>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <!-- 拒绝原因模态框 -->
    <div id="rejectModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">拒绝租借请求</h3>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label class="form-label">请求ID：</label>
            <span id="modalRecordId" style="font-weight: bold; color: #007bff;"></span>
          </div>
          <div class="form-group">
            <label for="rejectReason" class="form-label">拒绝原因 <span style="color: #dc3545;">*</span></label>
            <textarea
              id="rejectReason"
              name="reason"
              class="form-control"
              placeholder="请输入拒绝这个租借请求的原因..."
              required></textarea>
            <small style="color: #6c757d; font-size: 12px;">
              请详细说明拒绝的原因，这将帮助用户了解情况并改进申请。
            </small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="modal-btn modal-btn-cancel" onclick="closeRejectModal()">
            取消
          </button>
          <button type="button" class="modal-btn modal-btn-confirm" id="confirmRejectBtn" onclick="confirmReject()">
            确认拒绝
          </button>
        </div>
      </div>
    </div>

    <script>
      // 全局变量存储当前要拒绝的记录ID
      var currentRecordId = null;

      $(document).ready(function () {
        // 自动隐藏消息提示
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);

        // 请求卡片动画
        $(".request-card").each(function (index) {
          $(this)
            .delay(index * 100)
            .animate(
              {
                opacity: 1,
              },
              500
            );
        });

        // 点击模态框外部关闭模态框
        $(window).click(function (event) {
          if (event.target.id === "rejectModal") {
            closeRejectModal();
          }
        });

        // 监听拒绝原因输入框变化
        $("#rejectReason").on("input", function() {
          var reason = $(this).val().trim();
          $("#confirmRejectBtn").prop("disabled", reason.length === 0);
        });
      });

      // 显示拒绝原因模态框
      function showRejectModal(recordId) {
        currentRecordId = recordId;
        $("#modalRecordId").text("#" + recordId);
        $("#rejectReason").val("");
        $("#confirmRejectBtn").prop("disabled", true);
        $("#rejectModal").fadeIn(300);

        // 聚焦到文本框
        setTimeout(function() {
          $("#rejectReason").focus();
        }, 300);
      }

      // 关闭拒绝原因模态框
      function closeRejectModal() {
        $("#rejectModal").fadeOut(300);
        currentRecordId = null;
        $("#rejectReason").val("");
        $("#confirmRejectBtn").prop("disabled", false).html("确认拒绝");
      }

      // 确认拒绝
      function confirmReject() {
        var reason = $("#rejectReason").val().trim();

        if (!reason) {
          alert("请输入拒绝原因");
          $("#rejectReason").focus();
          return;
        }

        if (!currentRecordId) {
          alert("请选择要拒绝的请求");
          return;
        }

        // 禁用确认按钮，显示加载状态
        var $confirmBtn = $("#confirmRejectBtn");
        $confirmBtn.prop("disabled", true).html("⏳ 提交中...");

        // 创建表单并提交
        var form = $('<form method="post"></form>');
        form.append('<input type="hidden" name="recordId" value="' + currentRecordId + '">');
        form.append('<input type="hidden" name="action" value="reject">');
        form.append('<input type="hidden" name="reason" value="' + reason + '">');

        // 将表单添加到页面并提交
        $("body").append(form);
        form.submit();
      }

      // ESC键关闭模态框
      $(document).keydown(function (e) {
        if (e.keyCode === 27) {
          // ESC键
          if ($("#rejectModal").is(":visible")) {
            closeRejectModal();
          }
        }
      });
    </script>
  </body>
</html>
