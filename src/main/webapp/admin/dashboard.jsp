<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>管理员控制台 - 社区工具</title>
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

      .pending {
        color: #ffc107;
      }
      .available {
        color: #28a745;
      }
      .rented {
        color: #007bff;
      }
      .rejected {
        color: #dc3545;
      }
      .offline {
        color: #6c757d;
      }
      .total {
        color: #17a2b8;
      }

      .menu-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
        margin-bottom: 40px;
      }

      .menu-card {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
        display: flex;
        flex-direction: column;
        min-height: 200px;
      }

      .menu-card:hover {
        transform: translateY(-5px);
      }

      .menu-card h3 {
        color: #2c3e50;
        margin-bottom: 15px;
        font-size: 20px;
      }

      .menu-card p {
        color: #6c757d;
        margin-bottom: 20px;
        line-height: 1.6;
        flex-grow: 1;
      }

      .menu-btn {
        background: #007bff;
        color: white;
        border: none;
        padding: 12px 24px;
        border-radius: 8px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        transition: background 0.3s ease;
      }

      .menu-btn:hover {
        background: #0056b3;
      }

      .menu-btn.warning {
        background: #ffc107;
        color: #212529;
      }

      .menu-btn.warning:hover {
        background: #e0a800;
      }

      .menu-btn.success {
        background: #28a745;
        color: white;
      }

      .menu-btn.success:hover {
        background: #1e7e34;
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

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
        }

        .menu-grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>
  <body>
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
            <a
              href="${pageContext.request.contextPath}/admin/dashboard.jsp"
              class="active"
              >首页</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/tool-list"
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

      <!-- 功能菜单 -->
      <div class="menu-grid">
        <div class="menu-card">
          <h3>工具审核</h3>
          <p>
            审核用户提交的工具申请，包括通过和驳回操作。及时处理待审核工具，确保平台工具质量。
          </p>
          <a
            href="${pageContext.request.contextPath}/admin/tool-list"
            class="menu-btn warning"
          >
            审核工具
          </a>
        </div>

        <div class="menu-card">
          <h3>评论审核</h3>
          <p>
            审核用户提交的评论内容，包括通过和驳回操作。维护平台评论质量，营造良好的交流环境。
          </p>
          <a
            href="${pageContext.request.contextPath}/admin/review-audit"
            class="menu-btn info"
          >
            审核评论
          </a>
        </div>

        <div class="menu-card">
          <h3>用户管理</h3>
          <p>
            管理平台用户信息，包括添加、编辑、删除用户。维护用户数据的准确性和完整性。
          </p>
          <a
            href="${pageContext.request.contextPath}/admin/user-manager"
            class="menu-btn primary"
          >
            管理用户
          </a>
        </div>

        <div class="menu-card">
          <h3>工具管理</h3>
          <p>
            管理平台工具信息，包括添加、编辑、删除工具。维护工具数据的准确性和完整性。
          </p>
          <a
            href="${pageContext.request.contextPath}/admin/tool-manager"
            class="menu-btn success"
          >
            管理工具
          </a>
        </div>
      </div>
    </div>
    <script>
      $(document).ready(function () {
        // 自动隐藏消息提示
        setTimeout(function () {
          $(".alert").fadeOut();
        }, 5000);
      });
    </script>
  </body>
</html>
