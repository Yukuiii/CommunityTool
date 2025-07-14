<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>确认归还工具 - 社区租借系统</title>
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

        .page-title {
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 30px;
            text-align: center;
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

        .returns-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .returns-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .returns-title {
            font-size: 20px;
            color: #2c3e50;
            font-weight: 600;
        }

        .returns-count {
            background: #007bff;
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-weight: 500;
            font-size: 14px;
        }

        .returns-grid {
            display: grid;
            gap: 20px;
        }

        .return-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid #007bff;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }

        .return-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .return-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .return-info {
            flex: 1;
        }

        .return-id {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
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

        .return-details {
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

        .return-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-confirm {
            background: #28a745;
            color: white;
        }

        .btn-confirm:hover {
            background: #218838;
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
            
            .return-details {
                grid-template-columns: 1fr;
            }
            
            .return-actions {
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
                <li><a href="${pageContext.request.contextPath}/provider/rental-approval">租借审批</a></li>
                <li><a href="${pageContext.request.contextPath}/provider/confirm-return-tool" class="active">待确认归还</a></li>
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


        <!-- 待确认归还的工具 -->
        <div class="returns-container">
            <div class="returns-header">
                <h2 class="returns-title">待确认归还的工具</h2>
                <div class="returns-count">${pendingReturnTools != null ? pendingReturnTools.size() : 0} 个待确认</div>
            </div>

            <div class="returns-grid">
                <c:choose>
                    <c:when test="${empty pendingReturnTools}">
                        <div class="empty-state">
                            <h3>暂无待确认归还的工具</h3>
                            <p>目前没有需要您确认归还的工具</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="returnItem" items="${pendingReturnTools}">
                            <div class="return-card">
                                <div class="return-header">
                                    <div class="return-info">
                                        <div class="return-id">归还记录 #${returnItem.borrowRecord.recordId}</div>
                                        <span class="status-badge status-pending">${returnItem.borrowRecord.status}</span>
                                    </div>
                                </div>

                                <div class="return-details">
                                    <div class="detail-item">
                                        <div class="detail-label">工具名称</div>
                                        <div class="detail-value">${returnItem.tool.toolName}</div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">借用人ID</div>
                                        <div class="detail-value">${returnItem.borrowRecord.userId}</div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">借用时间</div>
                                        <div class="detail-value">
                                            ${returnItem.borrowRecord.borrowTime.toString().substring(0, 19).replace('T', ' ')}
                                        </div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">租金</div>
                                        <div class="detail-value">¥${returnItem.borrowRecord.rentalFee}</div>
                                    </div>
                                </div>

                                <div class="tool-description">
                                    <div class="label">工具描述</div>
                                    <div class="content">${returnItem.tool.description}</div>
                                </div>

                                <div class="return-actions">
                                    <form method="post" style="display: inline;">
                                        <input type="hidden" name="recordId" value="${returnItem.borrowRecord.recordId}">
                                        <button type="submit" class="btn btn-confirm" 
                                                onclick="return confirm('确定要确认这个工具已归还吗？确认后工具状态将变为闲置。')">
                                            ✓ 确认归还
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // 自动隐藏消息
            setTimeout(function() {
                $('.alert').fadeOut();
            }, 5000);
        });
    </script>
</body>
</html>
