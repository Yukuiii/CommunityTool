<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>社区租借系统 - 登录</title>
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
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .login-container {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        overflow: hidden;
        width: 400px;
        max-width: 90%;
      }

      .login-header {
        background: white;
        color: #2c3e50;
        text-align: center;
        padding: 40px 20px 30px;
        border-bottom: 1px solid #f1f3f4;
      }

      .login-header h1 {
        font-size: 28px;
        margin-bottom: 10px;
      }

      .login-header p {
        font-size: 14px;
        color: #6c757d;
        margin-top: 8px;
      }

      .login-form {
        padding: 30px;
      }

      .form-group {
        margin-bottom: 20px;
      }

      .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-weight: 500;
      }

      .form-group input,
      .form-group select {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.3s ease;
        background: #fafbfc;
      }

      .form-group input:focus,
      .form-group select:focus {
        outline: none;
        border-color: #007bff;
        background: white;
        box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
      }

      .form-group select {
        cursor: pointer;
      }

      .form-group.focused label {
        color: #007bff;
        transform: translateY(-2px);
        transition: all 0.3s ease;
      }

      .form-group.focused input,
      .form-group.focused select {
        border-color: #007bff;
        background: white;
        box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
      }

      .login-button {
        width: 100%;
        padding: 14px;
        background: #007bff;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
      }

      .login-button:hover {
        background: #0056b3;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
      }

      .login-button:active {
        transform: translateY(0);
        box-shadow: 0 2px 6px rgba(0, 123, 255, 0.2);
      }

      .login-button:disabled {
        background: #6c757d;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
      }

      .login-button:disabled:hover {
        background: #6c757d;
        transform: none;
        box-shadow: none;
      }

      .error-message {
        background: #f8d7da;
        color: #721c24;
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 20px;
        border: 1px solid #f5c6cb;
        animation: slideInDown 0.5s ease-out;
      }

      .success-message {
        background: #d4edda;
        color: #155724;
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 20px;
        border: 1px solid #c3e6cb;
        animation: slideInDown 0.5s ease-out;
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

      .register-link {
        text-align: center;
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #e1e5e9;
      }

      .register-link a {
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
      }

      .register-link a:hover {
        color: #0056b3;
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <div class="login-container">
      <div class="login-header">
        <h1>社区工具租借系统</h1>
        <p>欢迎使用社区工具租借系统</p>
      </div>

      <div class="login-form">
        <!-- 显示错误或成功消息 -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">${error}</div>
        <% } %> <% if (request.getAttribute("message") != null) { %>
        <div class="success-message">${message}</div>
        <% } %>

        <!-- 统一登录表单 -->
        <form
          id="loginForm"
          method="post"
          action="${pageContext.request.contextPath}/login"
        >
          <div class="form-group">
            <label for="loginType">登录类型</label>
            <select
              id="loginType"
              name="loginType"
              required
              onchange="updateLoginForm()"
            >
              <option value="borrower">工具使用者</option>
              <option value="provider">工具提供者</option>
              <option value="admin">管理员</option>
            </select>
          </div>

          <div class="form-group">
            <label for="username" id="usernameLabel">用户名</label>
            <input
              type="text"
              id="username"
              name="username"
              required
              placeholder="请输入用户名"
              autocomplete="username"
            />
          </div>

          <div class="form-group">
            <label for="password" id="passwordLabel">密码</label>
            <input
              type="password"
              id="password"
              name="password"
              required
              placeholder="请输入密码"
              autocomplete="current-password"
            />
          </div>

          <button type="submit" class="login-button" id="loginButton">
            用户登录
          </button>
        </form>

        <!-- 注册链接 -->
        <div class="register-link" id="registerLink">
          <p>
            还没有账号？
            <a href="${pageContext.request.contextPath}/register.jsp"
              >立即注册</a
            >
          </p>
        </div>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        // 更新登录表单显示
        function updateLoginForm() {
          const loginType = $("#loginType").val();

          if (loginType === "admin") {
            // 管理员登录
            $("#usernameLabel").text("管理员账号");
            $("#passwordLabel").text("管理员密码");
            $("#username").attr("placeholder", "请输入管理员账号");
            $("#password").attr("placeholder", "请输入管理员密码");
            $("#loginButton").text("管理员登录");
            $("#registerLink").hide();
          } else {
            // 用户登录
            $("#usernameLabel").text("用户名");
            $("#passwordLabel").text("密码");
            $("#username").attr("placeholder", "请输入用户名");
            $("#password").attr("placeholder", "请输入密码");
            $("#loginButton").text("用户登录");
            $("#registerLink").show();
          }
        }

        // 登录类型改变时更新表单
        $("#loginType").change(function () {
          updateLoginForm();
        });

        // 检查服务器端设置的登录类型
        var serverLoginType =
          '<%= request.getAttribute("loginType") != null ? request.getAttribute("loginType") : "" %>';
        if (serverLoginType === "admin") {
          $("#loginType").val("admin");
          updateLoginForm();
        }

        // 表单提交验证
        $("#loginForm").submit(function (e) {
          const username = $("#username").val().trim();
          const password = $("#password").val().trim();

          if (!username || !password) {
            e.preventDefault();
            alert("请填写完整的登录信息");
            return false;
          }

          // 显示加载状态
          var $btn = $("#loginButton");
          $btn
            .prop("disabled", true)
            .html('<span class="loading">登录中...</span>');
        });

        // 输入框焦点效果
        $("input, select")
          .focus(function () {
            $(this).parent().addClass("focused");
          })
          .blur(function () {
            $(this).parent().removeClass("focused");
          });
        // 初始化表单
        updateLoginForm();
      });
    </script>
  </body>
</html>
