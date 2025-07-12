<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>社区工具租借系统 - 用户注册</title>
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
        padding: 20px 0;
      }

      .register-container {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        overflow: hidden;
        width: 450px;
        max-width: 90%;
      }

      .register-header {
        background: white;
        color: #2c3e50;
        text-align: center;
        padding: 40px 20px 30px;
        border-bottom: 1px solid #f1f3f4;
      }

      .register-header h1 {
        font-size: 28px;
        margin-bottom: 10px;
      }

      .register-header p {
        font-size: 14px;
        color: #6c757d;
        margin-top: 8px;
      }

      .register-form {
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

      .form-row {
        display: flex;
        gap: 15px;
      }

      .form-row .form-group {
        flex: 1;
      }

      .register-button {
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

      .register-button:hover {
        background: #0056b3;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
      }

      .register-button:active {
        transform: translateY(0);
        box-shadow: 0 2px 6px rgba(0, 123, 255, 0.2);
      }

      .register-button:disabled {
        background: #6c757d;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
      }

      .register-button:disabled:hover {
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

      .login-link {
        text-align: center;
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #e1e5e9;
      }

      .login-link a {
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
      }

      .login-link a:hover {
        color: #0056b3;
        text-decoration: underline;
      }

      .password-strength {
        margin-top: 5px;
        font-size: 12px;
      }

      .strength-weak {
        color: #dc3545;
      }

      .strength-medium {
        color: #fd7e14;
      }

      .strength-strong {
        color: #28a745;
      }

      .form-help {
        font-size: 12px;
        color: #666;
        margin-top: 5px;
      }
    </style>
  </head>
  <body>
    <div class="register-container">
      <div class="register-header">
        <h1>社区租借系统 - 用户注册</h1>
        <p>创建您的社区租借系统账号</p>
      </div>

      <div class="register-form">
        <!-- 显示错误或成功消息 -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">${error}</div>
        <% } %> <% if (request.getAttribute("message") != null) { %>
        <div class="success-message">${message}</div>
        <% } %>

        <!-- 注册表单 -->
        <form id="registerForm" method="post" action="${pageContext.request.contextPath}/register">
          <div class="form-group">
            <label for="username">用户名 *</label>
            <input
              type="text"
              id="username"
              name="username"
              required
              placeholder="请输入用户名"
              autocomplete="username"
              value="${param.username}"
            />
            <div class="form-help">用户名长度为3-20个字符，只能包含字母、数字和下划线</div>
          </div>

          <div class="form-group">
            <label for="phone">手机号码</label>
            <input
              type="tel"
              id="phone"
              name="phone"
              placeholder="请输入手机号码"
              value="${param.phone}"
            />
            <div class="form-help">可选，用于接收重要通知</div>
          </div>

          <div class="form-group">
            <label for="password">密码 *</label>
            <input
              type="password"
              id="password"
              name="password"
              required
              placeholder="请输入密码"
              autocomplete="new-password"
            />
            <div id="passwordStrength" class="password-strength"></div>
            <div class="form-help">密码长度至少6位，建议包含字母、数字和特殊字符</div>
          </div>

          <div class="form-group">
            <label for="confirmPassword">确认密码 *</label>
            <input
              type="password"
              id="confirmPassword"
              name="confirmPassword"
              required
              placeholder="请再次输入密码"
              autocomplete="new-password"
            />
          </div>

          <div class="form-group">
            <label for="role">用户类型 *</label>
            <select id="role" name="role" required>
              <option value="">请选择用户类型</option>
              <option value="borrower" ${param.role == 'borrower' ? 'selected' : ''}>工具使用者</option>
              <option value="provider" ${param.role == 'provider' ? 'selected' : ''}>工具提供者</option>
            </select>
            <div class="form-help">工具使用者：可以借用他人的工具；工具提供者：可以出借自己的工具给他人</div>
          </div>

          <button type="submit" class="register-button" id="registerButton">
            立即注册
          </button>
        </form>

        <!-- 登录链接 -->
        <div class="login-link">
          <p>已有账号？ <a href="${pageContext.request.contextPath}/login.jsp">立即登录</a></p>
        </div>
      </div>
    </div>

    <script>
      $(document).ready(function() {
        // 密码强度检测
        function checkPasswordStrength(password) {
          var strength = 0;
          var strengthText = '';
          var strengthClass = '';
          
          if (password.length >= 6) strength++;
          if (password.match(/[a-z]/)) strength++;
          if (password.match(/[A-Z]/)) strength++;
          if (password.match(/[0-9]/)) strength++;
          if (password.match(/[^a-zA-Z0-9]/)) strength++;
          
          switch(strength) {
            case 0:
            case 1:
              strengthText = '密码强度：弱';
              strengthClass = 'strength-weak';
              break;
            case 2:
            case 3:
              strengthText = '密码强度：中等';
              strengthClass = 'strength-medium';
              break;
            case 4:
            case 5:
              strengthText = '密码强度：强';
              strengthClass = 'strength-strong';
              break;
          }
          
          $('#passwordStrength').text(strengthText).attr('class', 'password-strength ' + strengthClass);
        }
        
        // 密码输入时检测强度
        $('#password').on('input', function() {
          var password = $(this).val();
          if (password.length > 0) {
            checkPasswordStrength(password);
          } else {
            $('#passwordStrength').text('').attr('class', 'password-strength');
          }
        });
        
        // 表单提交验证
        $('#registerForm').submit(function(e) {
          var username = $('#username').val().trim();
          var password = $('#password').val();
          var confirmPassword = $('#confirmPassword').val();
          var phone = $('#phone').val().trim();
          var role = $('#role').val();

          // 基础验证
          if (!username || !password || !confirmPassword || !role) {
            e.preventDefault();
            alert('请填写所有必填项');
            return false;
          }

          // 用户名验证
          if (username.length < 3 || username.length > 20) {
            e.preventDefault();
            alert('用户名长度必须在3-20个字符之间');
            $('#username').focus();
            return false;
          }

          if (!/^[a-zA-Z0-9_]+$/.test(username)) {
            e.preventDefault();
            alert('用户名只能包含字母、数字和下划线');
            $('#username').focus();
            return false;
          }

          // 密码验证
          if (password.length < 6) {
            e.preventDefault();
            alert('密码长度至少6位');
            $('#password').focus();
            return false;
          }

          // 确认密码验证
          if (password !== confirmPassword) {
            e.preventDefault();
            alert('两次输入的密码不一致');
            $('#confirmPassword').focus();
            return false;
          }

          // 手机号格式验证（如果填写了）
          if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
            e.preventDefault();
            alert('请输入有效的手机号码');
            $('#phone').focus();
            return false;
          }

          // 显示加载状态
          var $btn = $('#registerButton');
          $btn.prop('disabled', true).html('<span class="loading">⏳</span> 注册中...');
        });
        
        // 输入框焦点效果
        $('input, select').focus(function() {
          $(this).parent().addClass('focused');
        }).blur(function() {
          $(this).parent().removeClass('focused');
        });
        
        // 错误消息自动消失
        $('.error-message, .success-message').delay(5000).fadeOut();
      });
    </script>
  </body>
</html>
