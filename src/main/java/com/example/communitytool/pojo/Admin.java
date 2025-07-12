package com.example.communitytool.pojo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 管理员实体类
 * 对应数据库中的admins表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Admin {

    // 基础字段
    private String adminId;           // 管理员唯一标识
    private String realName;          // 管理员的真实姓名
    private String password;          // 管理员登录密码

    // 时间字段
    private LocalDateTime createdAt;    // 创建时间
    private LocalDateTime updatedAt;    // 更新时间

    // 带参构造函数(基础字段)
    public Admin(String adminId, String realName, String password) {
        this.adminId = adminId;
        this.realName = realName;
        this.password = password;
    }
}
