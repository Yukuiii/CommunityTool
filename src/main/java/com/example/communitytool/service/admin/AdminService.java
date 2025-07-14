package com.example.communitytool.service.admin;

import java.util.List;

import com.example.communitytool.dao.BorrowRecordDAO;
import com.example.communitytool.dao.ReviewDAO;
import com.example.communitytool.dao.ToolDAO;
import com.example.communitytool.dao.UserDAO;
import com.example.communitytool.pojo.BorrowRecord;
import com.example.communitytool.pojo.Review;
import com.example.communitytool.pojo.Tool;
import com.example.communitytool.pojo.User;

/**
 * 管理员服务类
 * 处理管理员相关的业务逻辑
 */
public class AdminService {

    private ToolDAO toolDAO;
    private ReviewDAO reviewDAO;
    private UserDAO userDAO;
    private BorrowRecordDAO borrowRecordDAO;
    /**
     * 构造函数，初始化DAO对象
     */
    public AdminService() {
        this.toolDAO = new ToolDAO();
        this.reviewDAO = new ReviewDAO();
        this.userDAO = new UserDAO();
        this.borrowRecordDAO = new BorrowRecordDAO();
    }

    /**
     * 获取待审核工具列表
     * @return 待审核工具列表
     */
    public List<Tool> getPendingTools() {
        try {
            return toolDAO.findPendingTools();
        } catch (Exception e) {
            System.err.println("获取待审核工具列表异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 审核工具通过
     * @param toolId 工具ID
     * @return 是否审核成功
     */
    public boolean approveToolReview(Integer toolId) {
        try {
            // 更新工具状态为闲置
            boolean success = toolDAO.updateStatus(toolId, Tool.STATUS_AVAILABLE);
            return success;
        } catch (Exception e) {
            System.err.println("审核工具通过异常: " + e.getMessage());
            return false;
        }
    }

    /**
     * 审核工具驳回
     * @param toolId 工具ID
     * @param reason 拒绝原因
     * @return 是否审核成功
     */
    public boolean rejectToolReview(Integer toolId, String reason) {
        try {
            // 更新工具状态为审核驳回
            boolean success = toolDAO.updateStatus(toolId, Tool.STATUS_REJECTED);     
            // 更新工具拒绝原因
            toolDAO.updateReason(toolId, reason);
            return success;
        } catch (Exception e) {
            System.err.println("审核工具驳回异常: " + e.getMessage());
            return false;
        }
    }


    /**
     * 根据状态获取工具列表
     * @param status 工具状态
     * @return 工具列表
     */
    public List<Tool> getToolsByStatus(String status) {
        try {
            return toolDAO.findByStatus(status);
        } catch (Exception e) {
            System.err.println("根据状态获取工具列表异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 获取待审核评论列表
     * @return 待审核评论列表
     */
    public List<Review> getPendingReviews() {
        try {
            return reviewDAO.findPendingReviews();
        } catch (Exception e) {
            System.err.println("获取待审核评论列表异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 审核评论通过
     * @param reviewId 评论ID
     * @return 是否审核成功
     */
    public boolean approveReview(Integer reviewId) {
        try {
            // 更新评论状态为通过
            return reviewDAO.updateStatus(reviewId, Review.STATUS_APPROVED);
        } catch (Exception e) {
            System.err.println("审核评论通过异常: " + e.getMessage());
            return false;
        }
    }

    /**
     * 审核评论拒绝
     * @param reviewId 评论ID
     * @return 是否审核成功
     */
    public boolean rejectReview(Integer reviewId, String reason) {
        try {
            // 更新评论拒绝原因
            reviewDAO.updateReason(reviewId, reason);
            // 更新评论状态为拒绝
            return reviewDAO.updateStatus(reviewId, Review.STATUS_REJECTED);
        } catch (Exception e) {
            System.err.println("审核评论拒绝异常: " + e.getMessage());
            return false;
        }
    }

    /**
     * 获取所有用户（用于用户管理）
     */
    public List<User> getAllUsers() {
        try {
            // 获取所有用户
            return userDAO.findAll();
        } catch (Exception e) {
            System.err.println("获取所有用户异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 删除用户
     * @param userId 用户ID
     * @throws Exception 删除失败时抛出异常
     */
    public void deleteUser(Integer userId) throws Exception {
        try {
            // 检查用户是否存在
            User user = userDAO.findById(userId);
            if (user == null) {
                throw new Exception("用户不存在，无法删除");
            }

            // 判断用户是工具提供者还是工具使用者
            if(user.getRole().equals("borrower")){
                // 判断用户当前是否有租借工具，如果有在租借的工具则无法删除
                List<BorrowRecord> borrowRecords = borrowRecordDAO.findByUserId(userId);
                for (BorrowRecord borrowRecord : borrowRecords) {
                    if(borrowRecord.getStatus().equals(BorrowRecord.STATUS_BORROWING)){
                        throw new Exception("用户当前有租借工具，无法删除");
                    }
                    // 删除借用记录
                    borrowRecordDAO.delete(borrowRecord.getRecordId());
                }

                // 删除用户
                boolean success = userDAO.delete(userId);
                if (!success) {
                    throw new Exception("删除用户失败");
                }
            }else{
                // 这里判断用户是工具提供者的话，判断是否有工具正在被租借
                List<Tool> tools = toolDAO.findByProviderId(userId);
                for (Tool tool : tools) {
                    if(tool.getStatus().equals(Tool.STATUS_RENTED)){
                        throw new Exception("用户当前有工具正在被租借，无法删除");
                    }
                    // 删除工具
                    toolDAO.delete(tool.getToolId()); 
                }
               
                // 删除用户
                boolean success = userDAO.delete(userId);
                if (!success) {
                    throw new Exception("删除用户失败");
                }
            }
        } catch (Exception e) {
            System.err.println("删除用户异常: " + e.getMessage());
            throw new Exception("删除用户失败: " + e.getMessage());
        }
    }

    /**
     * 编辑用户信息
     * @param userId 用户ID
     * @param username 用户名
     * @param password 密码
     * @param phone 手机号
     * @param role 角色
     * @throws Exception 编辑失败时抛出异常
     */
    public void editUser(Integer userId, String username, String password, String phone, String role) throws Exception {
        try {
            // 检查用户是否存在
            User existingUser = userDAO.findById(userId);
            if (existingUser == null) {
                throw new Exception("用户不存在，无法编辑");
            }

            // 检查用户名是否已被其他用户使用
            if (username != null && !username.trim().isEmpty()) {
                User userWithSameName = userDAO.findByUsername(username);
                if (userWithSameName != null && !userWithSameName.getUserId().equals(userId)) {
                    throw new Exception("用户名已存在，请选择其他用户名");
                }
            }

            // 创建更新的用户对象
            User updatedUser = new User();
            updatedUser.setUserId(userId);
            updatedUser.setUsername(username != null && !username.trim().isEmpty() ? username : existingUser.getUsername());
            updatedUser.setPassword(password != null && !password.trim().isEmpty() ? password : existingUser.getPassword());
            updatedUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone : existingUser.getPhone());
            updatedUser.setRole(role != null && !role.trim().isEmpty() ? role : existingUser.getRole());

            // 更新用户信息
            boolean success = userDAO.update(updatedUser);
            if (!success) {
                throw new Exception("更新用户信息失败");
            }
        } catch (Exception e) {
            System.err.println("编辑用户异常: " + e.getMessage());
            throw new Exception("编辑用户失败: " + e.getMessage());
        }
    }

    /**
     * 添加新用户
     * @param username 用户名
     * @param password 密码
     * @param phone 手机号
     * @param role 角色
     * @throws Exception 添加失败时抛出异常
     */
    public void addUser(String username, String password, String phone, String role) throws Exception {
        try {
            // 验证必填字段
            if (username == null || username.trim().isEmpty()) {
                throw new Exception("用户名不能为空");
            }
            if (password == null || password.trim().isEmpty()) {
                throw new Exception("密码不能为空");
            }
            if (role == null || role.trim().isEmpty()) {
                throw new Exception("用户角色不能为空");
            }

            // 检查用户名是否已存在
            User existingUser = userDAO.findByUsername(username);
            if (existingUser != null) {
                throw new Exception("用户名已存在，请选择其他用户名");
            }


            // 创建新用户对象
            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setPassword(password);
            newUser.setPhone(phone != null ? phone.trim() : null);
            newUser.setRole(role.trim());

            // 插入新用户
            boolean success = userDAO.insert(newUser);
            if (!success) {
                throw new Exception("添加用户失败");
            }
        } catch (Exception e) {
            System.err.println("添加用户异常: " + e.getMessage());
            throw new Exception("添加用户失败: " + e.getMessage());
        }
    }

    /**
     * 获取所有工具列表（用于管理员工具管理）
     * @return 所有工具列表，获取失败时返回null
     */
    public List<Tool> getAllTools() {
        try {
            return toolDAO.findAll();
        } catch (Exception e) {
            System.err.println("获取所有工具异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 删除工具
     * @param toolId 工具ID
     * @throws Exception 删除失败时抛出异常
     */
    public void deleteTool(Integer toolId) throws Exception {
        try {
            // 检查工具是否存在
            Tool existingTool = toolDAO.findById(toolId);
            if (existingTool == null) {
                throw new Exception("工具不存在，无法删除");
            }

            // 检查工具是否正在被租借
            if (Tool.STATUS_RENTED.equals(existingTool.getStatus())) {
                throw new Exception("工具正在被租借，无法删除");
            }

            // 删除工具
            boolean success = toolDAO.delete(toolId);
            if (!success) {
                throw new Exception("删除工具失败");
            }
        } catch (Exception e) {
            System.err.println("删除工具异常: " + e.getMessage());
            throw new Exception("删除工具失败: " + e.getMessage());
        }
    }

    /**
     * 编辑工具信息
     * @param toolId 工具ID
     * @param toolName 工具名称
     * @param description 工具描述
     * @param rentalFee 租金
     * @throws Exception 编辑失败时抛出异常
     */
    public void editTool(Integer toolId, String toolName, String description, String rentalFee) throws Exception {
        try {
            // 检查工具是否存在
            Tool existingTool = toolDAO.findById(toolId);
            if (existingTool == null) {
                throw new Exception("工具不存在，无法编辑");
            }

            // 验证输入参数
            if (toolName == null || toolName.trim().isEmpty()) {
                throw new Exception("工具名称不能为空");
            }

            if (description == null) {
                description = "";
            }

            Integer fee;
            try {
                fee = Integer.parseInt(rentalFee);
                if (fee < 0) {
                    throw new Exception("租金不能为负数");
                }
            } catch (NumberFormatException e) {
                throw new Exception("租金格式不正确，请输入有效数字");
            }

            // 更新工具信息
            boolean success = toolDAO.updateTool(toolId, toolName.trim(), description.trim(), fee);
            if (!success) {
                throw new Exception("更新工具信息失败");
            }
        } catch (Exception e) {
            System.err.println("编辑工具异常: " + e.getMessage());
            throw new Exception("编辑工具失败: " + e.getMessage());
        }
    }

    /**
     * 添加工具
     * @param toolName 工具名称
     * @param description 工具描述
     * @param rentalFee 租金
     * @throws Exception 添加失败时抛出异常
     */
    public void addTool(String toolName, String description, String rentalFee) throws Exception {
        try {
            // 验证输入参数
            if (toolName == null || toolName.trim().isEmpty()) {
                throw new Exception("工具名称不能为空");
            }

            if (description == null) {
                description = "";
            }

            Integer fee;
            try {
                fee = Integer.parseInt(rentalFee);
                if (fee < 0) {
                    throw new Exception("租金不能为负数");
                }
            } catch (NumberFormatException e) {
                throw new Exception("租金格式不正确，请输入有效数字");
            }

            // 创建工具对象
            Tool tool = new Tool();
            tool.setToolName(toolName.trim());
            tool.setDescription(description.trim());
            tool.setRentalFee(fee);
            tool.setStatus(Tool.STATUS_AVAILABLE); // 管理员添加的工具直接设为闲置状态
            tool.setProviderId(0); // 设置为id为0.标识管理员添加的工具

            // 插入工具
            boolean success = toolDAO.insert(tool);
            if (!success) {
                throw new Exception("添加工具失败");
            }
        } catch (Exception e) {
            System.err.println("添加工具异常: " + e.getMessage());
            throw new Exception("添加工具失败: " + e.getMessage());
        }
    }
}
