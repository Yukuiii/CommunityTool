<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>工具上传 - 社区租借系统</title>
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

      .upload-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin-bottom: 30px;
      }

      .upload-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 1px solid #e9ecef;
      }

      .upload-title {
        font-size: 20px;
        color: #2c3e50;
        font-weight: 600;
      }

      .upload-form {
        padding: 40px;
      }

      .form-group {
        margin-bottom: 25px;
      }

      .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-weight: 500;
        font-size: 16px;
      }

      .form-group input,
      .form-group textarea {
        width: 100%;
        padding: 15px;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.3s ease;
        background: #fafbfc;
      }

      .form-group input:focus,
      .form-group textarea:focus {
        outline: none;
      }

      .form-group textarea {
        resize: vertical;
        min-height: 120px;
      }

      .upload-button {
        padding: 16px 24px;
        background: #007bff;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        min-width: 120px;
      }

      .upload-button:hover {
        background: #0056b3;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
      }

      .upload-button:active {
        transform: translateY(0);
        box-shadow: 0 2px 6px rgba(0, 123, 255, 0.2);
      }

      .upload-button:disabled {
        background: #6c757d;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
      }

      .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 8px;
        font-weight: 500;
        animation: slideInDown 0.5s ease-out;
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

      @keyframes slideInDown {
        from {
          opacity: 0;
          transform: translateY(-20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .form-actions {
        display: flex;
        gap: 15px;
        margin-top: 30px;
        justify-content: flex-end;
        align-items: center;
      }

      .cancel-btn {
        padding: 16px 24px;
        background: #6c757d;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        cursor: pointer;
        text-decoration: none;
        text-align: center;
        transition: all 0.3s ease;
        min-width: 100px;
      }

      .cancel-btn:hover {
        background: #5a6268;
        transform: translateY(-1px);
      }

      .upload-tips {
        background: #e7f3ff;
        border: 1px solid #b8daff;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 30px;
      }

      .upload-tips h3 {
        color: #004085;
        margin-bottom: 10px;
        font-size: 16px;
      }

      .upload-tips ul {
        color: #004085;
        margin-left: 20px;
      }

      .upload-tips li {
        margin-bottom: 5px;
        font-size: 14px;
      }

      .footer {
        margin-top: 50px;
        padding: 30px 0;
        text-align: center;
        color: #6c757d;
        border-top: 1px solid #e9ecef;
      }

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
        }

        .upload-form {
          padding: 20px;
        }

        .form-actions {
          flex-direction: column;
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
            <a href="${pageContext.request.contextPath}/provider/dashboard"
              >我的工具</a
            >
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/provider/tool-upload"
              class="active"
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

      <!-- 工具上传表单 -->
      <div class="upload-container">
        <div class="upload-header">
          <h2 class="upload-title">上传新工具</h2>
        </div>

        <div class="upload-form">
          <!-- 显示消息 -->
          <c:if test="${not empty message}">
            <div class="alert alert-success">${message}</div>
          </c:if>
          <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
          </c:if>

          <!-- 工具上传表单 -->
          <form
            id="uploadForm"
            method="post"
            action="${pageContext.request.contextPath}/provider/tool-upload"
          >
            <div class="form-group">
              <label for="toolName">工具名称 *</label>
              <input
                type="text"
                id="toolName"
                name="toolName"
                value="${toolName}"
              />
            </div>

            <div class="form-group">
              <label for="description">工具描述</label>
              <textarea id="description" name="description">
${description}</textarea
              >
            </div>

            <div class="form-group">
              <label for="rentalFee">租金（元/天） *</label>
              <input
                type="text"
                id="rentalFee"
                name="rentalFee"
                value="${rentalFee}"
              />
            </div>

            <div class="form-group">
              <label for="location">工具位置</label>
              <input
                type="text"
                id="location"
                name="location"
                value="${location}"
                placeholder="请输入工具存放位置，如：办公室A座201、仓库B区等"
              />
            </div>

            <div class="form-actions">
              <a
                href="${pageContext.request.contextPath}/provider/dashboard"
                class="cancel-btn"
                >取消</a
              >
              <button type="submit" class="upload-button" id="uploadButton">
                上传工具
              </button>
            </div>
          </form>
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
