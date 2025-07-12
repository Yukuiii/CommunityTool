package com.example.communitytool.service.borrower;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.example.communitytool.dao.BorrowRecordDAO;
import com.example.communitytool.dao.ReviewDAO;
import com.example.communitytool.dao.ToolDAO;
import com.example.communitytool.dto.BorrowRecordToolsDTO;
import com.example.communitytool.pojo.BorrowRecord;
import com.example.communitytool.pojo.Review;
import com.example.communitytool.pojo.Tool;

/**
 * 工具借用者服务类
 * 处理工具借用者相关的业务逻辑，包括工具搜索、租借、归还、评价等功能
 */
public class BorrowerService {

    private ToolDAO toolDAO;
    private BorrowRecordDAO borrowRecordDAO;
    private ReviewDAO reviewDAO;

    /**
     * 构造函数，初始化DAO对象
     */
    public BorrowerService() {
        this.toolDAO = new ToolDAO();
        this.borrowRecordDAO = new BorrowRecordDAO();
        this.reviewDAO = new ReviewDAO();
    }

    /**
     * 获取所有闲置工具列表
     * @return 闲置状态的工具列表，获取失败时返回空列表
     */
    public List<Tool> getAvailableTools() {
        try {
            // 获取状态为"闲置"的工具
            return toolDAO.findByStatus(Tool.STATUS_AVAILABLE);
        } catch (Exception e) {
            System.err.println("获取闲置工具列表失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * 根据工具名称搜索闲置工具
     * @param toolName 工具名称关键词，支持模糊搜索
     * @return 匹配的闲置工具列表，搜索失败时返回空列表
     */
    public List<Tool> searchAvailableTools(String toolName) {
        try {
            if (toolName == null || toolName.trim().isEmpty()) {
                // 如果搜索关键词为空，返回所有闲置工具
                return getAvailableTools();
            }
            // 按工具名称模糊搜索闲置工具
            return toolDAO.searchAvailableToolsByName(toolName.trim());
        } catch (Exception e) {
            System.err.println("搜索闲置工具失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * 租借工具
     * 创建租借记录并设置状态为待审核，同时将工具状态更新为已借出防止重复租借
     * @param userId 借用者用户ID
     * @param toolId 要租借的工具ID
     * @throws RuntimeException 租借失败时抛出运行时异常
     */
    public void rentTool(Integer userId, Integer toolId) {
        try {
            // 参数验证
            if (userId == null || toolId == null) {
                throw new RuntimeException("用户ID和工具ID不能为空");
            }

            // 1. 获取工具信息并验证工具状态
            Tool tool = toolDAO.findById(toolId);
            if (tool == null) {
                throw new RuntimeException("工具不存在");
            }

            if (!Tool.STATUS_AVAILABLE.equals(tool.getStatus())) {
                throw new RuntimeException("工具当前不可租借");
            }

            // 2. 创建租借记录
            BorrowRecord borrowRecord = new BorrowRecord();
            borrowRecord.setUserId(userId);
            borrowRecord.setToolId(toolId);
            borrowRecord.setBorrowTime(LocalDateTime.now());
            borrowRecord.setStatus(BorrowRecord.STATUS_PENDING); // 待审核状态
            borrowRecord.setRentalFee(tool.getRentalFee()); // 设置租金

            // 3. 保存租借记录
            boolean recordInserted = borrowRecordDAO.insert(borrowRecord);
            if (!recordInserted) {
                throw new RuntimeException("创建租借记录失败");
            }

            // 4. 更新工具状态为已借出（防止其他人同时租借）
            boolean toolUpdated = toolDAO.updateStatus(toolId, Tool.STATUS_RENTED);
            if (!toolUpdated) {
                throw new RuntimeException("更新工具状态失败");
            }

            System.out.println("租借工具成功: 用户ID " + userId + " 租借工具ID " + toolId);

        } catch (Exception e) {
            System.err.println("租借工具失败: " + e.getMessage());
            throw new RuntimeException("租借工具失败: " + e.getMessage());
        }
    }

    /**
     * 获取我的租借记录列表
     * 通过借用记录关联查询工具信息，返回包含工具详情的租借记录DTO列表
     * @param userId 用户ID
     * @return 包含工具信息的租借记录DTO列表，获取失败时返回空列表
     */
    public List<BorrowRecordToolsDTO> getMyRecords(Integer userId) {
        try {
            // 参数验证
            if (userId == null) {
                System.err.println("获取租借记录失败: 用户ID为空");
                return new ArrayList<>();
            }

            // 1. 获取用户的所有借用记录
            List<BorrowRecord> borrowRecords = borrowRecordDAO.findByUserId(userId);
            List<BorrowRecordToolsDTO> borrowRecordToolsDTOs = new ArrayList<>();

            // 2. 为每个借用记录关联查询工具信息
            for (BorrowRecord record : borrowRecords) {
                Tool tool = toolDAO.findById(record.getToolId());
                if (tool != null) {
                    borrowRecordToolsDTOs.add(new BorrowRecordToolsDTO(record, tool));
                } else {
                    System.err.println("警告: 找不到工具ID为 " + record.getToolId() + " 的工具信息");
                }
            }
            return borrowRecordToolsDTOs;

        } catch (Exception e) {
            System.err.println("获取我的租借记录列表失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * 归还工具
     * 将借用记录状态更新为待确认归还，需要工具提供者确认归还
     * @param userId 用户ID
     * @param recordId 借用记录ID
     * @throws RuntimeException 归还失败时抛出运行时异常
     */
    public void returnTool(Integer userId, Integer recordId) {
        try {
            // 参数验证
            if (userId == null || recordId == null) {
                throw new RuntimeException("用户ID和记录ID不能为空");
            }

            // 验证记录是否存在且属于该用户
            BorrowRecord record = borrowRecordDAO.findById(recordId);
            if (record == null) {
                throw new RuntimeException("借用记录不存在");
            }

            if (!record.getUserId().equals(userId)) {
                throw new RuntimeException("无权限操作此借用记录");
            }

            if (!BorrowRecord.STATUS_BORROWING.equals(record.getStatus())) {
                throw new RuntimeException("当前记录状态不允许归还操作");
            }

            // 更新借用记录为待确认归还，由工具提供者确认归还
            boolean statusUpdated = borrowRecordDAO.updateStatus(recordId, BorrowRecord.STATUS_CONFIRM_RETURN);
            if (!statusUpdated) {
                throw new RuntimeException("更新借用记录状态失败");
            }

            // 更新归还时间
            boolean timeUpdated = borrowRecordDAO.updateReturnTime(recordId, LocalDateTime.now());
            if (!timeUpdated) {
                throw new RuntimeException("更新归还时间失败");
            }

            System.out.println("归还工具成功: 用户ID " + userId + " 归还记录ID " + recordId);

        } catch (Exception e) {
            System.err.println("归还工具失败: " + e.getMessage());
            throw new RuntimeException("归还工具失败: " + e.getMessage());
        }
    }

    /**
     * 评价工具
     * 创建工具评价记录并更新借用记录状态为已评价
     * @param toolId 工具ID
     * @param userId 用户ID
     * @param rating 评分（1-5分）
     * @param comment 评价内容
     * @param recordId 借用记录ID
     * @throws RuntimeException 评价失败时抛出运行时异常
     */
    public void reviewTool(Integer toolId, Integer userId, Integer rating, String comment, Integer recordId) {
        try {
            // 参数验证
            if (toolId == null || userId == null || rating == null || recordId == null) {
                throw new RuntimeException("工具ID、用户ID、评分和记录ID不能为空");
            }

            if (rating < 1 || rating > 5) {
                throw new RuntimeException("评分必须在1-5分之间");
            }

            // 验证借用记录状态
            BorrowRecord record = borrowRecordDAO.findById(recordId);
            if (record == null) {
                throw new RuntimeException("借用记录不存在");
            }

            if (!record.getUserId().equals(userId)) {
                throw new RuntimeException("无权限评价此借用记录");
            }

            if (!BorrowRecord.STATUS_RETURNED.equals(record.getStatus())) {
                throw new RuntimeException("只能对已归还的工具进行评价");
            }

            // 创建评价记录，状态为待审核
            Review review = new Review();
            review.setToolId(toolId);
            review.setUserId(userId);
            review.setRating(rating);
            review.setReviewContent(comment != null ? comment.trim() : "");
            review.setStatus(Review.STATUS_PENDING);

            // 保存评价
            boolean reviewInserted = reviewDAO.insert(review);
            if (!reviewInserted) {
                throw new RuntimeException("保存评价失败");
            }

            // 更新借用记录为已评价
            boolean statusUpdated = borrowRecordDAO.updateStatus(recordId, BorrowRecord.STATUS_REVIEWED);
            if (!statusUpdated) {
                throw new RuntimeException("更新借用记录状态失败");
            }

            System.out.println("评价工具成功: 用户ID " + userId + " 评价工具ID " + toolId);

        } catch (Exception e) {
            System.err.println("评价工具失败: " + e.getMessage());
            throw new RuntimeException("评价工具失败: " + e.getMessage());
        }
    }

    /**
     * 验证评价数据的有效性
     * @param rating 评分
     * @param comment 评价内容
     * @return 验证错误信息，null表示验证通过
     */
    public String validateReviewData(Integer rating, String comment) {
        if (rating == null) {
            return "评分不能为空";
        }

        if (rating < 1 || rating > 5) {
            return "评分必须在1-5分之间";
        }

        if (comment != null && comment.trim().length() > 500) {
            return "评价内容不能超过500字";
        }

        return null; // 验证通过
    }
}
