<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>个人信息 - 社区租借系统</title>
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

      .profile-section {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        max-width: 600px;
        margin: 0 auto;
      }

      .section-title {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 30px;
        text-align: center;
        padding-bottom: 15px;
        border-bottom: 2px solid #e9ecef;
      }

      .form-group {
        margin-bottom: 25px;
      }

      .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #2c3e50;
        font-size: 14px;
      }

      .form-group input {
        width: 100%;
        padding: 12px 16px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.3s ease;
        background: white;
      }

      .form-group input:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
      }

      .form-group input:disabled {
        background: #f8f9fa;
        color: #6c757d;
        cursor: not-allowed;
      }

      .form-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 30px;
      }

      .btn {
        padding: 12px 30px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        text-align: center;
      }

      .btn-primary {
        background: #007bff;
        color: white;
      }

      .btn-primary:hover {
        background: #0056b3;
        transform: translateY(-1px);
      }

      .btn-secondary {
        background: #6c757d;
        color: white;
      }

      .btn-secondary:hover {
        background: #545b62;
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

      .info-text {
        font-size: 14px;
        color: #6c757d;
        margin-top: 5px;
      }

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
        }

        .profile-section {
          margin: 0 10px;
          padding: 20px;
        }

        .form-buttons {
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
          <c:choose>
            <c:when test="${sessionScope.userRole == 'provider'}">
              <li>
                <a href="${pageContext.request.contextPath}/provider/dashboard"
                  >控制台</a
                >
              </li>
              <li>
                <a
                  href="${pageContext.request.contextPath}/provider/tool-upload"
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
            </c:when>
            <c:otherwise>
              <li>
                <a href="${pageContext.request.contextPath}/borrower/dashboard"
                  >可租借工具</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/borrower/my-records"
                  >我的租借</a
                >
              </li>
            </c:otherwise>
          </c:choose>
          <li>
            <a href="${pageContext.request.contextPath}/profile" class="active"
              >个人信息</a
            >
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

      <!-- 个人信息修改表单 -->
      <div class="profile-section">
        <h2 class="section-title">个人信息</h2>

        <form
          method="post"
          action="${pageContext.request.contextPath}/profile"
          id="profileForm"
        >
          <div class="form-group">
            <label for="userId">用户ID</label>
            <input type="text" id="userId" value="${user.userId}" disabled />
            <div class="info-text">用户ID不可修改</div>
          </div>

          <div class="form-group">
            <label for="username">用户名 *</label>
            <input
              type="text"
              id="username"
              name="username"
              value="${user.username}"
              required
              maxlength="50"
              placeholder="请输入用户名"
            />
            <div class="info-text">用户名用于登录系统</div>
          </div>

          <div class="form-group">
            <label for="phone">手机号</label>
            <input
              type="tel"
              id="phone"
              name="phone"
              value="${user.phone}"
              maxlength="20"
              placeholder="请输入手机号"
            />
            <div class="info-text">手机号用于联系</div>
          </div>

          <div class="form-group">
            <label for="role">用户角色</label>
            <input
              type="text"
              id="role"
              value="${user.role == 'provider' ? '工具提供者' : '工具使用者'}"
              disabled
            />
            <div class="info-text">用户角色不可修改</div>
          </div>

          <div class="form-group">
            <label for="password">新密码</label>
            <input
              type="password"
              id="password"
              name="password"
              placeholder="如不修改密码请留空"
              minlength="6"
            />
            <div class="info-text">留空表示不修改密码，密码长度至少6位</div>
          </div>

          <div class="form-buttons">
            <button type="submit" class="btn btn-primary">保存修改</button>
            <c:choose>
              <c:when test="${sessionScope.userRole == 'provider'}">
                <a
                  href="${pageContext.request.contextPath}/provider/dashboard"
                  class="btn btn-secondary"
                  >返回控制台</a
                >
              </c:when>
              <c:otherwise>
                <a
                  href="${pageContext.request.contextPath}/borrower/dashboard"
                  class="btn btn-secondary"
                  >返回控制台</a
                >
              </c:otherwise>
            </c:choose>
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

        // 表单提交验证
        $("#profileForm").submit(function (e) {
          const username = $("#username").val().trim();
          const password = $("#password").val();

          if (!username) {
            alert("请输入用户名！");
            e.preventDefault();
            return false;
          }

          if (password && password.length < 6) {
            alert("密码长度至少6位！");
            e.preventDefault();
            return false;
          }

          return confirm("确定要保存修改吗？");
        });
      });
    </script>
  </body>
</html>
