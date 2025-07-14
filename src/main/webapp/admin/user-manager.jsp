<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>用户管理 - 管理员控制台</title>
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

      .main-content {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .main-content h2 {
        color: #2c3e50;
        margin-bottom: 20px;
        font-size: 20px;
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

      .toolbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
      }

      .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s ease;
        text-align: center;
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
        background: #1e7e34;
      }

      .btn-danger {
        background: #dc3545;
        color: white;
      }

      .btn-danger:hover {
        background: #c82333;
      }

      .btn-warning {
        background: #ffc107;
        color: #212529;
      }

      .btn-warning:hover {
        background: #e0a800;
      }

      .btn-sm {
        padding: 6px 12px;
        font-size: 12px;
      }

      .user-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }

      .user-table th,
      .user-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #dee2e6;
      }

      .user-table th {
        background: #f8f9fa;
        font-weight: 600;
        color: #495057;
      }

      .user-table tr:hover {
        background: #f8f9fa;
      }

      .role-badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 500;
      }

      .role-provider {
        background: #e3f2fd;
        color: #1976d2;
      }

      .role-borrower {
        background: #f3e5f5;
        color: #7b1fa2;
      }

      .role-admin {
        background: #fff3e0;
        color: #f57c00;
      }

      .action-buttons {
        display: flex;
        gap: 8px;
      }

      .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #6c757d;
      }

      .empty-state p {
        font-size: 16px;
        margin-bottom: 10px;
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
        margin: 5% auto;
        padding: 30px;
        border-radius: 10px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
      }

      .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #dee2e6;
      }

      .modal-title {
        font-size: 18px;
        font-weight: bold;
        color: #333;
      }

      .close {
        color: #aaa;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        line-height: 1;
      }

      .close:hover {
        color: #000;
      }

      .form-group {
        margin-bottom: 20px;
      }

      .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: #333;
      }

      .form-group input,
      .form-group select,
      .form-group textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        transition: border-color 0.3s ease;
      }

      .form-group input:focus,
      .form-group select:focus,
      .form-group textarea:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
      }

      .modal-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
      }

      .modal-body {
        margin-bottom: 20px;
      }

      .btn-secondary {
        background: #6c757d;
        color: white;
      }

      .btn-secondary:hover {
        background: #545b62;
      }

      @media (max-width: 768px) {
        .nav-menu ul {
          flex-direction: column;
        }

        .toolbar {
          flex-direction: column;
          gap: 15px;
          align-items: flex-start;
        }

        .user-table {
          font-size: 12px;
        }

        .user-table th,
        .user-table td {
          padding: 8px;
        }

        .action-buttons {
          flex-direction: column;
          gap: 5px;
        }

        .modal-content {
          margin: 2% auto;
          width: 95%;
          padding: 20px;
        }

        .modal-actions {
          flex-direction: column;
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
            <a href="${pageContext.request.contextPath}/admin/review-audit"
              >评论审核</a
            >
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/admin/user-manager"
              class="active"
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
        <div class="toolbar">
          <h2>用户管理</h2>
          <button
            type="button"
            class="btn btn-primary"
            onclick="showAddUserModal()"
          >
            添加用户
          </button>
        </div>

        <!-- 用户列表 -->
        <c:choose>
          <c:when test="${not empty users}">
            <table class="user-table">
              <thead>
                <tr>
                  <th>用户ID</th>
                  <th>用户名</th>
                  <th>手机号</th>
                  <th>角色</th>
                  <th>注册时间</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="user" items="${users}">
                  <tr>
                    <td>${user.userId}</td>
                    <td>${user.username}</td>
                    <td>${user.phone != null ? user.phone : '未设置'}</td>
                    <td>
                      <span class="role-badge role-${user.role}">
                        <c:choose>
                          <c:when test="${user.role == 'provider'}"
                            >工具提供者</c:when
                          >
                          <c:when test="${user.role == 'borrower'}"
                            >工具使用者</c:when
                          >
                          <c:otherwise>${user.role}</c:otherwise>
                        </c:choose>
                      </span>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty user.createdAt}">
                          ${user.createdAt.toString().substring(0,
                          19).replace('T', ' ')}
                        </c:when>
                        <c:otherwise>未知</c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="action-buttons">
                        <button
                          type="button"
                          class="btn btn-warning btn-sm"
                          onclick="showEditUserModal('${user.userId}', '${user.username}', '${user.phone}', '${user.role}')"
                        >
                          编辑
                        </button>
                        <button
                          type="button"
                          class="btn btn-danger btn-sm"
                          onclick="deleteUser('${user.userId}')"
                        >
                          删除
                        </button>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <p>暂无用户数据</p>
              <p style="font-size: 14px; margin-top: 10px">
                系统中还没有注册用户
              </p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- 添加用户模态框 -->
    <div id="addUserModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">添加用户</h3>
          <span class="close" onclick="closeAddUserModal()">&times;</span>
        </div>
        <form
          method="post"
          action="${pageContext.request.contextPath}/admin/user-manager"
        >
          <input type="hidden" name="action" value="add" />
          <div class="form-group">
            <label for="addUsername">用户名 *</label>
            <input
              type="text"
              id="addUsername"
              name="username"
              required
              placeholder="请输入用户名"
              maxlength="50"
            />
          </div>
          <div class="form-group">
            <label for="addPassword">密码 *</label>
            <input
              type="password"
              id="addPassword"
              name="password"
              required
              placeholder="请输入密码"
              maxlength="255"
            />
          </div>
          <div class="form-group">
            <label for="addPhone">手机号</label>
            <input
              type="text"
              id="addPhone"
              name="phone"
              placeholder="请输入手机号"
              maxlength="20"
            />
          </div>
          <div class="form-group">
            <label for="addRole">用户角色 *</label>
            <select id="addRole" name="role" required>
              <option value="">请选择角色</option>
              <option value="borrower">工具使用者</option>
              <option value="provider">工具提供者</option>
            </select>
          </div>
          <div class="modal-actions">
            <button
              type="button"
              class="btn btn-secondary"
              onclick="closeAddUserModal()"
            >
              取消
            </button>
            <button type="submit" class="btn btn-primary">添加用户</button>
          </div>
        </form>
      </div>
    </div>

    <!-- 编辑用户模态框 -->
    <div id="editUserModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">编辑用户</h3>
          <span class="close" onclick="closeEditUserModal()">&times;</span>
        </div>
        <form
          method="post"
          action="${pageContext.request.contextPath}/admin/user-manager"
        >
          <input type="hidden" name="action" value="edit" />
          <input type="hidden" id="editUserId" name="userId" />
          <div class="form-group">
            <label for="editUsername">用户名 *</label>
            <input
              type="text"
              id="editUsername"
              name="username"
              required
              placeholder="请输入用户名"
              maxlength="50"
            />
          </div>
          <div class="form-group">
            <label for="editPassword">密码</label>
            <input
              type="password"
              id="editPassword"
              name="password"
              placeholder="留空则不修改密码"
              maxlength="255"
            />
          </div>
          <div class="form-group">
            <label for="editPhone">手机号</label>
            <input
              type="text"
              id="editPhone"
              name="phone"
              placeholder="请输入手机号"
              maxlength="20"
            />
          </div>
          <div class="form-group">
            <label for="editRole">用户角色 *</label>
            <select id="editRole" name="role" required>
              <option value="">请选择角色</option>
              <option value="borrower">工具使用者</option>
              <option value="provider">工具提供者</option>
            </select>
          </div>
          <div class="modal-actions">
            <button
              type="button"
              class="btn btn-secondary"
              onclick="closeEditUserModal()"
            >
              取消
            </button>
            <button type="submit" class="btn btn-warning">保存修改</button>
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

      // 显示添加用户模态框
      function showAddUserModal() {
        document.getElementById("addUserModal").style.display = "block";
        // 清空表单
        document.getElementById("addUsername").value = "";
        document.getElementById("addPassword").value = "";
        document.getElementById("addPhone").value = "";
        document.getElementById("addRole").value = "";
        // 聚焦到用户名输入框
        setTimeout(function () {
          document.getElementById("addUsername").focus();
        }, 100);
      }

      // 关闭添加用户模态框
      function closeAddUserModal() {
        document.getElementById("addUserModal").style.display = "none";
      }

      // 显示编辑用户模态框
      function showEditUserModal(userId, username, phone, role) {
        document.getElementById("editUserId").value = userId;
        document.getElementById("editUsername").value = username;
        document.getElementById("editPassword").value = "";
        document.getElementById("editPhone").value = phone;
        document.getElementById("editRole").value = role;
        document.getElementById("editUserModal").style.display = "block";
        // 聚焦到用户名输入框
        setTimeout(function () {
          document.getElementById("editUsername").focus();
        }, 100);
      }

      // 关闭编辑用户模态框
      function closeEditUserModal() {
        document.getElementById("editUserModal").style.display = "none";
      }

      // 直接删除用户
      function deleteUser(userId) {
        // 创建表单并提交删除请求
        const form = $("<form>", {
          method: "POST",
          action: "${pageContext.request.contextPath}/admin/user-manager",
        });

        form.append(
          $("<input>", {
            type: "hidden",
            name: "action",
            value: "delete",
          })
        );

        form.append(
          $("<input>", {
            type: "hidden",
            name: "userId",
            value: userId,
          })
        );

        $("body").append(form);
        form.submit();
      }

      // 点击模态框外部关闭
      window.onclick = function (event) {
        var addModal = document.getElementById("addUserModal");
        var editModal = document.getElementById("editUserModal");

        if (event.target == addModal) {
          closeAddUserModal();
        } else if (event.target == editModal) {
          closeEditUserModal();
        }
      };
    </script>
  </body>
</html>
