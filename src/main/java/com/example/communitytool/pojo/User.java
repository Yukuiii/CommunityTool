package com.example.communitytool.pojo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 用户实体类
 * 对应数据库中的users表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    // 基础字段
    private Integer userId;           // 用户唯一标识
    private String username;          // 用户登录名
    private String password;          // 用户登录密码(加密存储)
    private String phone;             // 用户手机号
    private String role;              // 用户角色(提供者/使用者)

    // 时间字段
    private LocalDateTime createdAt;    // 创建时间
    private LocalDateTime updatedAt;    // 更新时间
}
