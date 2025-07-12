
-- 用户信息表
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户唯一标识',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户登录名',
    password VARCHAR(255) NOT NULL COMMENT '用户登录密码(加密存储)',
    phone VARCHAR(20) COMMENT '用户手机号',
    role VARCHAR(50) NOT NULL DEFAULT 'user' COMMENT '用户角色(提供者/使用者)',

    -- 时间字段
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    -- 索引
    INDEX idx_username (username),
    INDEX idx_phone (phone),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';


-- 管理员信息表
CREATE TABLE admins (
    admin_id VARCHAR(11) PRIMARY KEY COMMENT '管理员唯一标识',
    real_name VARCHAR(20) NOT NULL COMMENT '管理员的真实姓名',
    password VARCHAR(20) NOT NULL COMMENT '管理员登录密码',

    -- 时间字段
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    -- 索引
    INDEX idx_real_name (real_name),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员信息表';


-- 工具信息表
CREATE TABLE tools (
    tool_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '工具唯一标识',
    tool_name VARCHAR(100) NOT NULL COMMENT '工具名称',
    description TEXT COMMENT '工具详细描述',
    provider_id INT NOT NULL COMMENT '工具所属用户编号',
    rental_fee INT NOT NULL DEFAULT 0 COMMENT '工具借用金',
    status VARCHAR(50) NOT NULL DEFAULT '待审核' COMMENT '工具状态(待审核/已拒绝/闲置/已借出/下架)',
    reason TEXT NULL COMMENT '拒绝原因(当状态为已拒绝时填写)',

    -- 时间字段
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    -- 索引
    INDEX idx_tool_name (tool_name),
    INDEX idx_provider_id (provider_id),
    INDEX idx_status (status),
    INDEX idx_rental_fee (rental_fee),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工具信息表';

-- 借用记录表
CREATE TABLE borrow_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '借用记录唯一标识',
    user_id INT NOT NULL COMMENT '借用人编号',
    tool_id INT NOT NULL COMMENT '被借用工具编号',
    borrow_time DATETIME NOT NULL COMMENT '工具借用时间',
    return_time DATETIME NULL COMMENT '工具归还时间',
    status VARCHAR(50) NOT NULL DEFAULT '待审核' COMMENT '借用状态(待审核/已通过/已拒绝/借用中/已归还/已取消)',
    rental_fee INT NOT NULL DEFAULT 0 COMMENT '实际支付租金',
    reason TEXT NULL COMMENT '拒绝原因(当状态为已拒绝时填写)',

    -- 时间字段
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录更新时间',

    -- 索引
    INDEX idx_user_id (user_id),
    INDEX idx_tool_id (tool_id),
    INDEX idx_borrow_time (borrow_time),
    INDEX idx_return_time (return_time),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='借用记录表';

-- 评价信息表
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '评价唯一标识',
    user_id INT NOT NULL COMMENT '评价人编号',
    tool_id INT NOT NULL COMMENT '被评价工具编号',
    rating INT NOT NULL COMMENT '用户评分(1-5分)',
    review_content TEXT COMMENT '用户文字评价',
    status VARCHAR(50) NOT NULL DEFAULT '待审核' COMMENT '评价状态(待审核/已通过/已拒绝)',
    reason TEXT NULL COMMENT '拒绝原因(当状态为已拒绝时填写)',

    -- 时间字段
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评价创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '评价更新时间',

    -- 索引
    INDEX idx_user_id (user_id),
    INDEX idx_tool_id (tool_id),
    INDEX idx_rating (rating),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='评价信息表';


