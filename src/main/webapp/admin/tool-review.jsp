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
        transition: all 0.3s ease;
      }

      .logout-btn:hover {
        background: #dc3545;
        color: white;
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

      .btn-primary {
        background: #007bff;
        color: white;
      }

      .btn-primary:hover {
        background: #0056b3;
      }

      .btn-success {
        background: #28a745;
        color: white;
      }

      .btn-success:hover {
        background: #218838;
      }

      .btn-danger {
        background: #dc3545;
        color: white;
      }

      .btn-danger:hover {
        background: #c82333;
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
        padding: 30px;
        border-radius: 12px;
        width: 90%;
        max-width: 500px;
        text-align: center;
      }

      .modal h3 {
        color: #2c3e50;
        margin-bottom: 15px;
      }

      .modal p {
        color: #6c757d;
        margin-bottom: 25px;
        line-height: 1.6;
      }

      .modal-actions {
        display: flex;
        gap: 15px;
        justify-content: center;
      }

      .reason-input {
        margin: 20px 0;
        text-align: left;
      }

      .reason-input label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #333;
      }

      .reason-input textarea {
        width: 100%;
        padding: 12px;
        border: 2px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        font-family: inherit;
        resize: vertical;
        min-height: 80px;
        box-sizing: border-box;
      }

      .reason-input textarea:focus {
        outline: none;
        border-color: #007bff;
      }

      .reason-input .char-count {
        text-align: right;
        font-size: 12px;
        color: #6c757d;
        margin-top: 5px;
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
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
              >控制台</a
            >
          </li>
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
          <div class="requests-count">${pendingCount} 个待审核</div>
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
                      onclick="approveToolConfirm('${tool.toolId}', '${tool.toolName}')"
                    >
                      ✓ 审核通过
                    </button>
                    <button
                      class="btn btn-reject"
                      onclick="rejectToolConfirm('${tool.toolId}', '${tool.toolName}')"
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

    <!-- 确认模态框 -->
    <div id="confirmModal" class="modal">
      <div class="modal-content">
        <h3 id="modalTitle">确认操作</h3>
        <p id="modalMessage">确定要执行此操作吗？</p>

        <!-- 拒绝原因输入框（仅在拒绝操作时显示） -->
        <div id="reasonInput" class="reason-input" style="display: none">
          <label for="rejectReason">拒绝原因 *</label>
          <textarea
            id="rejectReason"
            placeholder="请详细说明拒绝的原因，以便工具提供者了解并改进..."
            maxlength="500"
            oninput="updateCharCount()"
          ></textarea>
          <div class="char-count"><span id="charCount">0</span>/500</div>
        </div>

        <div class="modal-actions">
          <button class="btn btn-primary" onclick="closeModal()">取消</button>
          <button
            id="confirmBtn"
            class="btn btn-success"
            onclick="executeAction()"
          >
            确认
          </button>
        </div>
      </div>
    </div>

    <script>
      let currentAction = null;
      let currentToolId = null;
      let currentToolName = null;

      $(document).ready(function () {
        // 自动隐藏消息提示
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);
      });

      function approveToolConfirm(toolId, toolName) {
        currentAction = "approve";
        currentToolId = toolId;
        currentToolName = toolName;

        $("#modalTitle").text("确认审核通过");
        $("#modalMessage").text(
          '确定要通过工具"' +
            toolName +
            '"的审核吗？通过后工具将变为可借用状态。'
        );
        $("#confirmBtn")
          .removeClass("btn-danger")
          .addClass("btn-success")
          .text("确认通过");

        // 隐藏拒绝原因输入框
        $("#reasonInput").hide();
        $("#confirmModal").show();
      }

      function rejectToolConfirm(toolId, toolName) {
        currentAction = "reject";
        currentToolId = toolId;
        currentToolName = toolName;

        $("#modalTitle").text("确认审核驳回");
        $("#modalMessage").text(
          '请填写驳回工具"' + toolName + '"的原因，以便工具提供者了解并改进。'
        );
        $("#confirmBtn")
          .removeClass("btn-success")
          .addClass("btn-danger")
          .text("确认驳回");

        // 显示拒绝原因输入框并清空内容
        $("#reasonInput").show();
        $("#rejectReason").val("");
        updateCharCount();

        $("#confirmModal").show();
      }

      function executeAction() {
        if (!currentAction || !currentToolId) {
          return;
        }

        // 如果是拒绝操作，验证拒绝原因
        if (currentAction === "reject") {
          const reason = $("#rejectReason").val().trim();
          if (!reason) {
            alert("请填写拒绝原因！");
            return;
          }
          if (reason.length < 5) {
            alert("拒绝原因至少需要5个字符！");
            return;
          }
        }

        // 显示加载状态
        $("#confirmBtn")
          .prop("disabled", true)
          .html('<span class="loading">⏳</span> 处理中...');

        // 根据操作类型确定提交路径
        let actionUrl = "";
        if (currentAction === "approve") {
          actionUrl = "${pageContext.request.contextPath}/admin/tool-approve";
        } else if (currentAction === "reject") {
          actionUrl = "${pageContext.request.contextPath}/admin/tool-reject";
        }

        // 创建表单并提交
        const form = $("<form>", {
          method: "POST",
          action: actionUrl,
        });

        form.append(
          $("<input>", {
            type: "hidden",
            name: "toolId",
            value: currentToolId,
          })
        );

        // 如果是拒绝操作，添加拒绝原因
        if (currentAction === "reject") {
          form.append(
            $("<input>", {
              type: "hidden",
              name: "reason",
              value: $("#rejectReason").val().trim(),
            })
          );
        }

        $("body").append(form);
        form.submit();
      }

      function closeModal() {
        $("#confirmModal").hide();
        currentAction = null;
        currentToolId = null;
        currentToolName = null;
        $("#confirmBtn").prop("disabled", false).html("确认");

        // 重置拒绝原因输入框
        $("#reasonInput").hide();
        $("#rejectReason").val("");
        updateCharCount();
      }

      // 更新字符计数
      function updateCharCount() {
        const text = $("#rejectReason").val();
        const count = text.length;
        $("#charCount").text(count);

        // 根据字符数量改变颜色
        if (count > 450) {
          $("#charCount").css("color", "#dc3545");
        } else if (count > 400) {
          $("#charCount").css("color", "#ffc107");
        } else {
          $("#charCount").css("color", "#6c757d");
        }
      }

      // 点击模态框外部关闭
      $(window).click(function (event) {
        if (event.target.id === "confirmModal") {
          closeModal();
        }
      });
    </script>
  </body>
</html>
