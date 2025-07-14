<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>工具使用者控制台 - 社区租借系统</title>
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
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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
        margin-bottom: 15px;
      }

      .tool-fee {
        font-size: 18px;
        font-weight: bold;
        color: #28a745;
      }

      .tool-provider {
        font-size: 12px;
        color: #6c757d;
      }

      .rent-btn {
        width: 100%;
        background: #007bff;
        color: white;
        border: none;
        padding: 10px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
      }

      .rent-btn:disabled {
        background: #6c757d;
        cursor: not-allowed;
      }

      /* 评价展示样式 */
      .reviews-section {
        margin-bottom: 15px;
        padding: 15px 0;
        border-top: 1px solid #e9ecef;
      }

      .reviews-header {
        margin-bottom: 10px;
      }

      .reviews-title {
        font-size: 14px;
        font-weight: bold;
        color: #495057;
      }

      .reviews-list {
        max-height: 200px;
        overflow-y: auto;
      }

      .review-item {
        padding: 8px 0;
        border-bottom: 1px solid #f8f9fa;
      }

      .review-item:last-child {
        border-bottom: none;
      }

      .review-rating {
        display: flex;
        align-items: center;
        margin-bottom: 5px;
      }

      .star {
        color: #ddd;
        font-size: 14px;
        margin-right: 2px;
      }

      .star.filled {
        color: #ffc107;
      }

      .rating-text {
        margin-left: 8px;
        font-size: 12px;
        color: #6c757d;
      }

      .review-content {
        font-size: 13px;
        color: #495057;
        line-height: 1.4;
        margin-bottom: 5px;
      }

      .review-time {
        font-size: 11px;
        color: #6c757d;
      }

      .more-reviews {
        text-align: center;
        font-size: 12px;
        color: #6c757d;
        padding: 8px 0;
        font-style: italic;
      }

      .no-reviews {
        text-align: center;
        font-size: 13px;
        color: #6c757d;
        padding: 10px 0;
        font-style: italic;
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

      .footer {
        text-align: center;
        padding: 30px 0;
        color: #6c757d;
        border-top: 1px solid #e9ecef;
        margin-top: 50px;
      }

      .modal-btn:disabled {
        background: #6c757d;
        cursor: not-allowed;
      }

      /* 支付模态框样式 */
      .payment-modal {
        display: none;
        position: fixed;
        z-index: 1001;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
      }

      .payment-modal-content {
        background-color: white;
        margin: 10% auto;
        padding: 0;
        border-radius: 8px;
        width: 450px;
        max-width: 90%;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
      }

      .payment-methods {
        padding: 20px;
      }

      .payment-method {
        display: flex;
        align-items: center;
        padding: 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        margin-bottom: 15px;
        cursor: pointer;
      }

      .payment-method input[type="radio"] {
        margin-right: 15px;
        transform: scale(1.2);
      }

      .payment-icon {
        width: 40px;
        height: 40px;
        margin-right: 15px;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
      }

      .wechat-icon {
        background: #07c160;
        color: white;
      }

      .alipay-icon {
        background: #1677ff;
        color: white;
      }

      .payment-info {
        flex: 1;
      }

      .payment-name {
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 5px;
      }

      .payment-desc {
        font-size: 12px;
        color: #6c757d;
      }

      .payment-amount {
        text-align: center;
        padding: 20px;
        background: #f8f9fa;
        border-top: 1px solid #e9ecef;
        border-bottom: 1px solid #e9ecef;
      }

      .amount-label {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 5px;
      }

      .amount-value {
        font-size: 24px;
        font-weight: bold;
        color: #28a745;
      }

      /* 模态框组件样式 */
      .modal-header {
        padding: 20px 20px 0 20px;
        border-bottom: 1px solid #e9ecef;
      }

      .modal-title {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        padding-bottom: 15px;
      }

      .modal-footer {
        padding: 20px;
        border-top: 1px solid #e9ecef;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
      }

      .modal-btn {
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        text-align: center;
      }

      .modal-btn-cancel {
        background: #6c757d;
        color: white;
      }

      .modal-btn-confirm {
        background: #007bff;
        color: white;
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

      /* 搜索框样式 */
      .search-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        gap: 20px;
      }

      .search-form {
        display: flex;
        gap: 10px;
        align-items: center;
        flex: 1;
        max-width: 400px;
      }

      .search-input {
        flex: 1;
        padding: 10px 15px;
        border: 2px solid #e9ecef;
        border-radius: 6px;
        font-size: 14px;
      }

      .search-input:focus {
        outline: none;
      }

      .search-btn {
        background: #007bff;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        white-space: nowrap;
      }

      .clear-search-btn {
        background: #6c757d;
        color: white;
        border: none;
        padding: 10px 15px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        text-decoration: none;
        white-space: nowrap;
      }

      .search-result-info {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 15px;
      }

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
        }

        .search-container {
          flex-direction: column;
          align-items: stretch;
        }

        .search-form {
          max-width: none;
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
              href="${pageContext.request.contextPath}/borrower/dashboard"
              class="active"
              >首页</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/borrower/my-records"
              >我的租借记录</a
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

      <!-- 可租借工具列表 -->
      <div class="tools-section">
        <div class="section-header">
          <div class="search-container">
            <h2 class="section-title">可租借工具</h2>
            <form
              class="search-form"
              method="get"
              action="${pageContext.request.contextPath}/borrower/dashboard"
            >
              <input
                type="text"
                name="search"
                class="search-input"
                placeholder="搜索工具名称..."
                value="${searchKeyword}"
              />
              <button type="submit" class="search-btn">搜索</button>
              <c:if test="${not empty searchKeyword}">
                <a
                  href="${pageContext.request.contextPath}/borrower/dashboard"
                  class="clear-search-btn"
                  >清除</a
                >
              </c:if>
            </form>
          </div>

          <!-- 搜索结果信息 -->
          <c:if test="${not empty searchKeyword}">
            <div class="search-result-info">
              搜索关键词："${searchKeyword}"，找到 ${not empty availableTools ?
              availableTools.size() : 0} 个结果
            </div>
          </c:if>
        </div>

        <c:choose>
          <c:when test="${not empty availableTools}">
            <div class="tools-grid">
              <c:forEach var="toolReviewDTO" items="${availableTools}">
                <div class="tool-card">
                  <div class="tool-name">${toolReviewDTO.tool.toolName}</div>
                  <div class="tool-description">
                    ${toolReviewDTO.tool.description}
                  </div>
                  <div class="tool-info">
                    <div class="tool-fee">
                      ¥${toolReviewDTO.tool.rentalFee}/天
                    </div>
                    <div class="tool-provider">
                      提供者ID: ${toolReviewDTO.tool.providerId}
                    </div>
                    <div class="tool-location">
                      <c:choose>
                        <c:when test="${not empty toolReviewDTO.tool.location}">
                          位置: ${toolReviewDTO.tool.location}
                        </c:when>
                        <c:otherwise>
                          <span style="color: #6c757d; font-style: italic"
                            >位置: 未设置</span
                          >
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>

                  <!-- 评价信息展示 -->
                  <div class="reviews-section">
                    <c:choose>
                      <c:when test="${not empty toolReviewDTO.reviews}">
                        <div class="reviews-header">
                          <span class="reviews-title"
                            >用户评价 (${toolReviewDTO.reviews.size()}条)</span
                          >
                        </div>
                        <div class="reviews-list">
                          <c:forEach
                            var="review"
                            items="${toolReviewDTO.reviews}"
                            varStatus="status"
                          >
                            <c:if test="${status.index < 3}">
                              <!-- 最多显示3条评价 -->
                              <div class="review-item">
                                <div class="review-rating">
                                  <c:forEach begin="1" end="5" var="star">
                                    <span
                                      class="star ${star <= review.rating ? 'filled' : ''}"
                                      >★</span
                                    >
                                  </c:forEach>
                                  <span class="rating-text"
                                    >${review.rating}分</span
                                  >
                                </div>
                                <div class="review-content">
                                  ${review.reviewContent}
                                </div>
                                <div class="review-time">
                                  ${review.createdAt.toString().substring(0,
                                  19).replace('T', ' ')}
                                </div>
                              </div>
                            </c:if>
                          </c:forEach>
                          <c:if test="${toolReviewDTO.reviews.size() > 3}">
                            <div class="more-reviews">
                              还有${toolReviewDTO.reviews.size() - 3}条评价...
                            </div>
                          </c:if>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="no-reviews">暂无评价</div>
                      </c:otherwise>
                    </c:choose>
                  </div>

                  <button
                    type="button"
                    class="rent-btn"
                    data-tool-id="${toolReviewDTO.tool.toolId}"
                    data-rental-fee="${toolReviewDTO.tool.rentalFee}"
                    onclick="showPaymentModalDirectly(this)"
                  >
                    立即租借
                  </button>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <c:choose>
                <c:when test="${not empty searchKeyword}">
                  <p>未找到匹配的工具</p>
                </c:when>
                <c:otherwise>
                  <p>暂无可租借的工具</p>
                </c:otherwise>
              </c:choose>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- 支付模态框 -->
    <div id="paymentModal" class="payment-modal">
      <div class="payment-modal-content">
        <div class="modal-header">
          <h3 class="modal-title">选择支付方式</h3>
        </div>

        <div class="payment-amount">
          <div class="amount-label">需支付金额</div>
          <div class="amount-value" id="paymentAmount">¥0.00</div>
        </div>

        <div class="payment-methods">
          <div class="payment-method" onclick="selectPaymentMethod('wechat')">
            <input
              type="radio"
              name="paymentMethod"
              value="wechat"
              id="wechatPay"
            />
            <div class="payment-info">
              <div class="payment-name">微信支付</div>
              <div class="payment-desc">使用微信支付</div>
            </div>
          </div>

          <div class="payment-method" onclick="selectPaymentMethod('alipay')">
            <input
              type="radio"
              name="paymentMethod"
              value="alipay"
              id="alipayPay"
            />
            <div class="payment-info">
              <div class="payment-name">支付宝支付</div>
              <div class="payment-desc">使用支付宝支付</div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button
            type="button"
            class="modal-btn modal-btn-cancel"
            onclick="closePaymentModal()"
          >
            取消
          </button>
          <button
            type="button"
            class="modal-btn modal-btn-confirm"
            id="confirmPaymentBtn"
            onclick="confirmPayment()"
            disabled
          >
            确认支付
          </button>
        </div>
      </div>
    </div>

    <script>
      // 全局变量存储当前选中的工具信息
      var currentToolId = null;
      var currentRentalFee = null;
      var selectedPaymentMethod = null;

      $(document).ready(function () {
        // 自动隐藏消息提示
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);

        // 点击模态框外部关闭模态框
        $(window).click(function (event) {
          if (event.target.id === "paymentModal") {
            closePaymentModal();
          }
        });
      });

      // 直接显示支付模态框
      function showPaymentModalDirectly(button) {
        var toolId = $(button).data("tool-id");
        var rentalFee = $(button).data("rental-fee");

        // 存储当前工具ID和租金
        currentToolId = toolId;
        currentRentalFee = rentalFee;

        // 设置支付金额
        $("#paymentAmount").text("¥" + rentalFee);

        // 重置支付方式选择
        selectedPaymentMethod = null;
        $("input[name='paymentMethod']").prop("checked", false);
        $("#confirmPaymentBtn").prop("disabled", true);

        // 显示支付模态框
        $("#paymentModal").fadeIn(300);
      }

      // 显示支付模态框
      function showPaymentModal() {
        if (!currentToolId || !currentRentalFee) {
          alert("请选择要租借的工具");
          return;
        }

        // 关闭租借确认模态框
        $("#rentModal").fadeOut(300);

        // 设置支付金额
        $("#paymentAmount").text("¥" + currentRentalFee);

        // 重置支付方式选择
        selectedPaymentMethod = null;
        $("input[name='paymentMethod']").prop("checked", false);
        $("#confirmPaymentBtn").prop("disabled", true);

        // 显示支付模态框
        $("#paymentModal").fadeIn(300);
      }

      // 关闭支付模态框
      function closePaymentModal() {
        $("#paymentModal").fadeOut(300);
        selectedPaymentMethod = null;
        currentToolId = null;
        currentRentalFee = null;
      }

      // 选择支付方式
      function selectPaymentMethod(method) {
        selectedPaymentMethod = method;

        // 更新UI状态
        $("input[name='paymentMethod']").prop("checked", false);

        if (method === "wechat") {
          $("#wechatPay").prop("checked", true);
        } else if (method === "alipay") {
          $("#alipayPay").prop("checked", true);
        }

        // 启用确认支付按钮
        $("#confirmPaymentBtn").prop("disabled", false);
      }

      // 确认支付
      function confirmPayment() {
        if (!selectedPaymentMethod) {
          alert("请选择支付方式");
          return;
        }

        // 关闭支付模态框
        $("#paymentModal").fadeOut(300);

        // 直接提交租借申请
        submitRentRequest();
      }

      // 提交租借申请
      function submitRentRequest() {
        if (!currentToolId) {
          alert("请选择要租借的工具");
          return;
        }

        // 创建表单并提交
        var form = $(
          '<form method="post" action="${pageContext.request.contextPath}/borrower/rent-tool"></form>'
        );
        form.append(
          '<input type="hidden" name="toolId" value="' + currentToolId + '">'
        );

        // 将表单添加到页面并提交
        $("body").append(form);
        form.submit();
      }

      // ESC键关闭模态框
      $(document).keydown(function (e) {
        if (e.keyCode === 27) {
          // ESC键
          if ($("#paymentModal").is(":visible")) {
            closePaymentModal();
          } else if ($("#rentModal").is(":visible")) {
            closeRentModal();
          }
        }
      });
    </script>
  </body>
</html>
