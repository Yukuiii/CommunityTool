package com.example.communitytool.pojo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 工具实体类
 * 对应数据库中的tools表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Tool {

    // 基础字段
    private Integer toolId;           // 工具唯一标识
    private Integer providerId;       // 工具提供者id
    private String toolName;          // 工具名称
    private String description;       // 工具详细描述
    private Integer rentalFee;        // 工具租金
    private String status;            // 工具状态(待审核/已拒绝/闲置/已借出/下架)
    private String reason;            // 拒绝原因
    private String location;          // 工具位置

    // 时间字段
    private LocalDateTime createdAt;  // 创建时间
    private LocalDateTime updatedAt;  // 更新时间

    // 工具状态常量
    public static final String STATUS_PENDING = "待审核";
    public static final String STATUS_REJECTED = "已拒绝";
    public static final String STATUS_AVAILABLE = "闲置";
    public static final String STATUS_RENTED = "已借出";
    public static final String STATUS_OFFLINE = "下架";
}
