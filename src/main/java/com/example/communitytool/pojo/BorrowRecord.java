package com.example.communitytool.pojo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 借用记录实体类
 * 对应数据库中的borrow_records表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BorrowRecord {

    // 基础字段
    private Integer recordId;         // 借用记录唯一标识
    private Integer userId;           // 借用人编号
    private Integer toolId;           // 被借用工具编号
    private LocalDateTime borrowTime; // 工具借用时间
    private LocalDateTime returnTime; // 工具归还时间
    private String status;            // 借用状态(待审核/已拒绝/借用中/已归还)
    private Integer rentalFee;        // 实际支付租金
    private String reason;            // 拒绝原因

    // 时间字段
    private LocalDateTime createdAt;  // 记录创建时间
    private LocalDateTime updatedAt;  // 记录更新时间

    // 借用状态常量
    public static final String STATUS_PENDING = "待审核";
    public static final String STATUS_REJECTED = "已拒绝";
    public static final String STATUS_BORROWING = "借用中";
    public static final String STATUS_CONFIRM_RETURN = "待确认归还";
    public static final String STATUS_RETURNED = "已归还";
    public static final String STATUS_REVIEWED = "已评价";
}
