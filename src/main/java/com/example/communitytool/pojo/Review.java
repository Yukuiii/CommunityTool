package com.example.communitytool.pojo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 评价实体类
 * 对应数据库中的reviews表
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Review {

    // 基础字段
    private Integer reviewId;         // 评价唯一标识
    private Integer userId;           // 评价人编号
    private Integer toolId;           // 被评价工具编号
    private Integer rating;           // 用户评分(1-5分)
    private String reviewContent;     // 用户文字评价
    private String status;            // 评价状态(待审核/已通过/已拒绝)
    private String reason;            // 拒绝原因

    // 时间字段
    private LocalDateTime createdAt;  // 评价创建时间
    private LocalDateTime updatedAt;  // 评价更新时间

    // 评价状态常量
    public static final String STATUS_PENDING = "待审核";
    public static final String STATUS_APPROVED = "已通过";
    public static final String STATUS_REJECTED = "已拒绝";

    // 评分常量
    public static final int MIN_RATING = 1;
    public static final int MAX_RATING = 5;
}
