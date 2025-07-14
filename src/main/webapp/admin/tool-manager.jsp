<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>工具管理 - 管理员控制台</title>
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

      .tool-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }

      .tool-table th,
      .tool-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #dee2e6;
      }

      .tool-table th {
        background: #f8f9fa;
        font-weight: 600;
        color: #495057;
      }

      .tool-table tr:hover {
        background: #f8f9fa;
      }

      .status-badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 500;
      }

      .status-pending {
        background: #fff3cd;
        color: #856404;
      }

      .status-available {
        background: #d4edda;
        color: #155724;
      }

      .status-rented {
        background: #f8d7da;
        color: #721c24;
      }

      .status-rejected {
        background: #f5c6cb;
        color: #721c24;
      }

      .status-offline {
        background: #e2e3e5;
        color: #383d41;
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

      .description-cell {
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }

      .fee-cell {
        color: #28a745;
        font-weight: 600;
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

      .form-group textarea {
        resize: vertical;
        min-height: 80px;
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

        .tool-table {
          font-size: 12px;
        }

        .tool-table th,
        .tool-table td {
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

        .description-cell {
          max-width: 120px;
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
            <a href="${pageContext.request.contextPath}/admin/user-manager"
              >用户管理</a
            >
          </li>
          <li>
            <a
              href="${pageContext.request.contextPath}/admin/tool-manager"
              class="active"
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
          <h2>工具管理</h2>
          <button
            type="button"
            class="btn btn-primary"
            onclick="showAddToolModal()"
          >
            添加工具
          </button>
        </div>

        <!-- 工具列表 -->
        <c:choose>
          <c:when test="${not empty tools}">
            <table class="tool-table">
              <thead>
                <tr>
                  <th>工具ID</th>
                  <th>工具名称</th>
                  <th>描述</th>
                  <th>提供者ID</th>
                  <th>租金</th>
                  <th>状态</th>
                  <th>创建时间</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="tool" items="${tools}">
                  <tr>
                    <td>${tool.toolId}</td>
                    <td>${tool.toolName}</td>
                    <td class="description-cell" title="${tool.description}">
                      ${tool.description}
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${tool.providerId == 0}">
                          <span style="color: #007bff; font-weight: 500"
                            >管理员</span
                          >
                        </c:when>
                        <c:otherwise> ${tool.providerId} </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="fee-cell">¥${tool.rentalFee}</td>
                    <td>
                      <span
                        class="status-badge status-${tool.status == '待审核' ? 'pending' : tool.status == '闲置' ? 'available' : tool.status == '已借出' ? 'rented' : tool.status == '已拒绝' ? 'rejected' : 'offline'}"
                      >
                        ${tool.status}
                      </span>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty tool.createdAt}">
                          ${tool.createdAt.toString().substring(0,
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
                          onclick="showEditToolModal('${tool.toolId}', '${tool.toolName}', '${tool.description}', '${tool.rentalFee}')"
                        >
                          编辑
                        </button>
                        <button
                          type="button"
                          class="btn btn-danger btn-sm"
                          onclick="showDeleteConfirm('${tool.toolId}', '${tool.toolName}')"
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
              <p>暂无工具数据</p>
              <p style="font-size: 14px; margin-top: 10px">
                系统中还没有工具记录
              </p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- 添加工具模态框 -->
    <div id="addToolModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">添加工具</h3>
          <span class="close" onclick="closeAddToolModal()">&times;</span>
        </div>
        <form
          method="post"
          action="${pageContext.request.contextPath}/admin/tool-manager"
        >
          <input type="hidden" name="action" value="add" />
          <div class="form-group">
            <label for="addToolName">工具名称 *</label>
            <input
              type="text"
              id="addToolName"
              name="toolName"
              required
              placeholder="请输入工具名称"
              maxlength="100"
            />
          </div>
          <div class="form-group">
            <label for="addDescription">工具描述</label>
            <textarea
              id="addDescription"
              name="description"
              placeholder="请输入工具描述"
              rows="4"
            ></textarea>
          </div>
          <div class="form-group">
            <label for="addRentalFee">租金 (元) *</label>
            <input
              type="number"
              id="addRentalFee"
              name="rentalFee"
              required
              placeholder="请输入租金"
              min="0"
              step="1"
            />
          </div>
          <div class="modal-actions">
            <button
              type="button"
              class="btn btn-secondary"
              onclick="closeAddToolModal()"
            >
              取消
            </button>
            <button type="submit" class="btn btn-primary">添加工具</button>
          </div>
        </form>
      </div>
    </div>

    <!-- 编辑工具模态框 -->
    <div id="editToolModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">编辑工具</h3>
          <span class="close" onclick="closeEditToolModal()">&times;</span>
        </div>
        <form
          method="post"
          action="${pageContext.request.contextPath}/admin/tool-manager"
        >
          <input type="hidden" name="action" value="edit" />
          <input type="hidden" id="editToolId" name="toolId" />
          <div class="form-group">
            <label for="editToolName">工具名称 *</label>
            <input
              type="text"
              id="editToolName"
              name="toolName"
              required
              placeholder="请输入工具名称"
              maxlength="100"
            />
          </div>
          <div class="form-group">
            <label for="editDescription">工具描述</label>
            <textarea
              id="editDescription"
              name="description"
              placeholder="请输入工具描述"
              rows="4"
            ></textarea>
          </div>
          <div class="form-group">
            <label for="editRentalFee">租金 (元) *</label>
            <input
              type="number"
              id="editRentalFee"
              name="rentalFee"
              required
              placeholder="请输入租金"
              min="0"
              step="1"
            />
          </div>
          <div class="modal-actions">
            <button
              type="button"
              class="btn btn-secondary"
              onclick="closeEditToolModal()"
            >
              取消
            </button>
            <button type="submit" class="btn btn-warning">保存修改</button>
          </div>
        </form>
      </div>
    </div>

    <!-- 删除确认模态框 -->
    <div id="deleteConfirmModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">确认删除</h3>
          <span class="close" onclick="closeDeleteConfirmModal()">&times;</span>
        </div>
        <div class="modal-body">
          <p>确定要删除工具 "<span id="deleteToolName"></span>" 吗？</p>
          <p style="color: #dc3545; font-size: 14px; margin-top: 10px">
            <strong>警告：</strong
            >此操作不可撤销，工具的所有相关数据也将被删除。
          </p>
        </div>
        <form
          method="post"
          action="${pageContext.request.contextPath}/admin/tool-manager"
        >
          <input type="hidden" name="action" value="delete" />
          <input type="hidden" id="deleteToolId" name="toolId" />
          <div class="modal-actions">
            <button
              type="button"
              class="btn btn-secondary"
              onclick="closeDeleteConfirmModal()"
            >
              取消
            </button>
            <button type="submit" class="btn btn-danger">确认删除</button>
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

      // 显示添加工具模态框
      function showAddToolModal() {
        document.getElementById("addToolModal").style.display = "block";
        // 清空表单
        document.getElementById("addToolName").value = "";
        document.getElementById("addDescription").value = "";
        document.getElementById("addRentalFee").value = "";
        // 聚焦到工具名称输入框
        setTimeout(function () {
          document.getElementById("addToolName").focus();
        }, 100);
      }

      // 关闭添加工具模态框
      function closeAddToolModal() {
        document.getElementById("addToolModal").style.display = "none";
      }

      // 显示编辑工具模态框
      function showEditToolModal(toolId, toolName, description, rentalFee) {
        document.getElementById("editToolId").value = toolId;
        document.getElementById("editToolName").value = toolName;
        document.getElementById("editDescription").value = description;
        document.getElementById("editRentalFee").value = rentalFee;
        document.getElementById("editToolModal").style.display = "block";
        // 聚焦到工具名称输入框
        setTimeout(function () {
          document.getElementById("editToolName").focus();
        }, 100);
      }

      // 关闭编辑工具模态框
      function closeEditToolModal() {
        document.getElementById("editToolModal").style.display = "none";
      }

      // 显示删除确认模态框
      function showDeleteConfirm(toolId, toolName) {
        document.getElementById("deleteToolId").value = toolId;
        document.getElementById("deleteToolName").textContent = toolName;
        document.getElementById("deleteConfirmModal").style.display = "block";
      }

      // 关闭删除确认模态框
      function closeDeleteConfirmModal() {
        document.getElementById("deleteConfirmModal").style.display = "none";
      }

      // 点击模态框外部关闭
      window.onclick = function (event) {
        var addModal = document.getElementById("addToolModal");
        var editModal = document.getElementById("editToolModal");
        var deleteModal = document.getElementById("deleteConfirmModal");

        if (event.target == addModal) {
          closeAddToolModal();
        } else if (event.target == editModal) {
          closeEditToolModal();
        } else if (event.target == deleteModal) {
          closeDeleteConfirmModal();
        }
      };
    </script>
  </body>
</html>
