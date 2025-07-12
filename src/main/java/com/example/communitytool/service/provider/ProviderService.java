package com.example.communitytool.service.provider;

import java.util.ArrayList;
import java.util.List;

import com.example.communitytool.dao.BorrowRecordDAO;
import com.example.communitytool.dao.ReviewDAO;
import com.example.communitytool.dao.ToolDAO;
import com.example.communitytool.dto.BorrowRecordToolsDTO;
import com.example.communitytool.dto.ToolsReviewDTO;
import com.example.communitytool.pojo.BorrowRecord;
import com.example.communitytool.pojo.Review;
import com.example.communitytool.pojo.Tool;

/**
 * 工具提供者服务类
 * 处理工具提供者相关的业务逻辑
 */
public class ProviderService {

    private ToolDAO toolDAO;
    private BorrowRecordDAO borrowRecordDAO;
    private ReviewDAO reviewDAO;

    /**
     * 构造函数，初始化DAO对象
     */
    public ProviderService() {
        this.toolDAO = new ToolDAO();
        this.borrowRecordDAO = new BorrowRecordDAO();
        this.reviewDAO = new ReviewDAO();
    }

    /**
     * 上传工具
     * @param providerId 提供者ID
     * @param toolName 工具名称
     * @param description 工具描述
     * @param rentalFee 租金
     * @return 是否上传成功
     */
    public boolean uploadTool(Integer providerId, String toolName, String description, Integer rentalFee) {
        try {

            // 创建工具对象
            Tool tool = new Tool();
            tool.setProviderId(providerId);
            tool.setToolName(toolName.trim());
            tool.setDescription(description != null ? description.trim() : "");
            tool.setRentalFee(rentalFee);
            tool.setStatus(Tool.STATUS_PENDING); // 设置为待审核状态

            // 保存工具到数据库
            boolean success = toolDAO.insert(tool);

            if (success) {
                System.out.println("工具上传成功：" + toolName + " (提供者ID: " + providerId + ")");
                return true;
            } else {
                System.out.println("工具上传失败：数据库操作失败");
                return false;
            }

        } catch (Exception e) {
            System.err.println("上传工具异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取提供者的所有工具
     * @param providerId 提供者ID
     * @return 工具列表
     */
    public List<ToolsReviewDTO> getProviderTools(Integer providerId) {
        try {

            List<Tool> tools = toolDAO.findByProviderId(providerId);
            List<ToolsReviewDTO> toolsReviewDTOs = new ArrayList<>();
            for (Tool tool : tools) {
                List<Review> reviews = reviewDAO.findByToolId(tool.getToolId());
                toolsReviewDTOs.add(new ToolsReviewDTO(tool, reviews));
            }
            return toolsReviewDTOs;

        } catch (Exception e) {
            System.err.println("获取提供者工具异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 获取需要提供者审批的租借请求
     * @param providerId 提供者ID
     * @return 待审批的借用记录列表
     */
    public List<BorrowRecordToolsDTO> getPendingRentalRequests(Integer providerId) {
        try {
            // 获取提供者的所有工具
            List<Tool> providerTools = toolDAO.findByProviderId(providerId);

            // 查找状态为待审核的借用记录
            List<BorrowRecord> pendingRequests = borrowRecordDAO.findByStatus(BorrowRecord.STATUS_PENDING);
            
            // 过滤出属于该提供者工具的请求
            pendingRequests.removeIf(record -> {
                return providerTools.stream().noneMatch(tool -> tool.getToolId().equals(record.getToolId()));
            });

            List<BorrowRecordToolsDTO> borrowRecordToolsDTOs = new ArrayList<>();
            for (BorrowRecord record : pendingRequests) {
                Tool tool = toolDAO.findById(record.getToolId());
                if (tool != null) {
                    borrowRecordToolsDTOs.add(new BorrowRecordToolsDTO(record, tool));
                }
            }
            return borrowRecordToolsDTOs;
        } catch (Exception e) {
            System.err.println("获取待审批租借请求异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 审批租借请求
     * @param providerId 提供者ID
     * @param recordId 借用记录ID
     * @param approved 是否批准（true=批准，false=拒绝）
     * @param reason 拒绝原因
     * @return 是否审批成功
     */
    public boolean approveRentalRequest(Integer providerId, Integer recordId, boolean approved, String reason) {
        try {
            // 获取借用记录
            BorrowRecord record = borrowRecordDAO.findById(recordId);

            // 获取工具信息
            Tool tool = toolDAO.findById(record.getToolId());

            // 如果批准， 更新借用记录状态为借用中，并设置拒绝原因
            if (approved) {
                borrowRecordDAO.updateStatus(recordId, BorrowRecord.STATUS_BORROWING);
            } else {
                // 如果拒绝，回滚工具状态为闲置 更新借用记录状态为已拒绝
                toolDAO.updateStatus(tool.getToolId(), Tool.STATUS_AVAILABLE);
                borrowRecordDAO.updateStatus(recordId, BorrowRecord.STATUS_REJECTED);
                borrowRecordDAO.updateReason(recordId, reason);
            }
            
            return true;

        } catch (Exception e) {
            System.err.println("审批租借请求异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 确认归还工具
     * @param providerId 提供者ID
     * @param recordId 借用记录ID
     * @return 是否确认归还成功
     */
    public boolean confirmReturnTool(Integer providerId, Integer recordId) {
        try {
            // 获取借用记录
            BorrowRecord record = borrowRecordDAO.findById(recordId);

            // 更新借用记录状态为已归还
            boolean recordUpdated = borrowRecordDAO.updateStatus(recordId, BorrowRecord.STATUS_RETURNED);
            if (!recordUpdated) {
                throw new RuntimeException("更新借用记录状态失败");
            }

            // 更新工具状态为闲置
            boolean toolUpdated = toolDAO.updateStatus(record.getToolId(), Tool.STATUS_AVAILABLE);
            if (!toolUpdated) {
                throw new RuntimeException("更新工具状态失败");
            }

            return true;
        } catch (Exception e) {
            System.err.println("确认归还工具失败: " + e.getMessage());
            throw new RuntimeException(e.getMessage());
        }
    }

    /**
     * 获取待确认归还的工具列表
     * @param providerId 提供者ID
     * @return 待确认归还的工具列表
     */
    public List<BorrowRecordToolsDTO> getPendingReturnTools(Integer providerId) {
        try {
            // 获取提供者的所有工具
            List<Tool> providerTools = toolDAO.findByProviderId(providerId);

            // 获取所有状态为待确认归还的借用记录
            List<BorrowRecord> pendingReturnRecords = borrowRecordDAO.findByStatus(BorrowRecord.STATUS_CONFIRM_RETURN);

            // 过滤出属于该提供者工具的归还记录
            pendingReturnRecords.removeIf(record -> {
                return providerTools.stream().noneMatch(tool -> tool.getToolId().equals(record.getToolId()));
            });

            List<BorrowRecordToolsDTO> borrowRecordToolsDTOs = new ArrayList<>();
            for (BorrowRecord record : pendingReturnRecords) {
                Tool tool = toolDAO.findById(record.getToolId());
                if (tool != null) {
                    borrowRecordToolsDTOs.add(new BorrowRecordToolsDTO(record, tool));
                }
            }
            return borrowRecordToolsDTOs;
        } catch (Exception e) {
            System.err.println("获取待确认归还工具异常: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * 更新工具状态
     * @param toolId 工具ID
     * @param status 新状态
     * @return 是否更新成功
     */
    public boolean updateToolStatus(Integer toolId, String status) {
        try {
            // 参数验证
            if (toolId == null || status == null || status.trim().isEmpty()) {
                System.err.println("更新工具状态失败: 工具ID或状态不能为空");
                return false;
            }

            return toolDAO.updateStatus(toolId, status);
        } catch (Exception e) {
            System.err.println("更新工具状态失败: " + e.getMessage());
            return false;
        }
    }

    /**
     * 验证工具上传数据的有效性
     * @param toolName 工具名称
     * @param description 工具描述
     * @param rentalFee 租金
     * @return 验证错误信息，null表示验证通过
     */
    public String validateToolData(String toolName, String description, Integer rentalFee) {
        if (toolName == null || toolName.trim().isEmpty()) {
            return "工具名称不能为空";
        }

        if (toolName.trim().length() > 100) {
            return "工具名称不能超过100字符";
        }

        if (description != null && description.trim().length() > 500) {
            return "工具描述不能超过500字符";
        }

        if (rentalFee == null) {
            return "租金不能为空";
        }

        if (rentalFee < 0) {
            return "租金不能为负数";
        }

        if (rentalFee > 999999) {
            return "租金不能超过999999";
        }

        return null; // 验证通过
    }

    /**
     * 检查工具是否属于指定提供者
     * @param toolId 工具ID
     * @param providerId 提供者ID
     * @return 是否属于该提供者
     */
    public boolean isToolBelongsToProvider(Integer toolId, Integer providerId) {
        try {
            Tool tool = toolDAO.findById(toolId);
            return tool != null && tool.getProviderId().equals(providerId);
        } catch (Exception e) {
            System.err.println("检查工具归属失败: " + e.getMessage());
            return false;
        }
    }
}
