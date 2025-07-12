package com.example.communitytool.service;

import java.time.LocalDateTime;

import com.example.communitytool.dao.UserDAO;
import com.example.communitytool.pojo.User;
import com.example.communitytool.util.PasswordUtil;

/**
 * 用户资料服务类
 * 处理用户个人资料相关的业务逻辑，包括资料更新和查询
 */
public class ProfileService {

    private UserDAO userDAO;

    /**
     * 构造函数，初始化DAO对象
     */
    public ProfileService() {
        this.userDAO = new UserDAO();
    }

    /**
     * 更新用户个人资料
     * @param userId 用户ID
     * @param username 新用户名
     * @param phone 新手机号
     * @param password 新密码（可为空，为空则不更新密码）
     * @throws Exception 更新失败时抛出异常
     */
    public void updateProfile(Integer userId, String username, String phone, String password) throws Exception {
        try {
            // 根据用户ID查找用户
            User user = userDAO.findById(userId);
            if (user == null) {
                throw new Exception("用户不存在");
            }

            // 如果提供了新密码，进行密码验证和更新
            if(password != null && !password.trim().isEmpty()){
                // 检查新密码是否与原密码相同
                if(PasswordUtil.verifyPassword(password, user.getPassword())){
                    throw new Exception("不能和原密码相同");
                }
                // 加密新密码并设置
                user.setPassword(PasswordUtil.encryptPassword(password));
            }

            // 更新用户名和手机号
            user.setUsername(username);
            user.setPhone(phone);
            // 设置更新时间
            user.setUpdatedAt(LocalDateTime.now());

            // 保存更新到数据库
            userDAO.update(user);

        } catch (Exception e) {
            System.err.println("更新用户资料异常: " + e.getMessage());
            throw new Exception("更新用户资料失败: " + e.getMessage());
        }
    }

    /**
     * 根据用户ID获取用户信息
     * @param userId 用户ID
     * @return 用户信息对象，获取失败时返回null
     */
    public User getUserById(Integer userId) {
        try {
            if (userId == null) {
                System.err.println("获取用户信息失败: 用户ID为空");
                return null;
            }
            return userDAO.findById(userId);
        } catch (Exception e) {
            System.err.println("获取用户信息失败: " + e.getMessage());
            return null;
        }
    }

    /**
     * 验证用户资料更新数据的有效性
     * @param username 用户名
     * @param phone 手机号
     * @param password 密码（可为空）
     * @return 验证错误信息，null表示验证通过
     */
    public String validateProfileData(String username, String phone, String password) {
        // 验证用户名
        if (username == null || username.trim().isEmpty()) {
            return "用户名不能为空";
        }

        if (username.trim().length() < 3 || username.trim().length() > 20) {
            return "用户名长度必须在3-20位之间";
        }

        if (!username.trim().matches("^[a-zA-Z0-9_]+$")) {
            return "用户名只能包含字母、数字和下划线";
        }

        // 验证手机号（如果提供）
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.trim().matches("^1[3-9]\\d{9}$")) {
                return "手机号格式不正确";
            }
        }

        // 验证密码（如果提供）
        if (password != null && !password.trim().isEmpty()) {
            if (password.length() < 6) {
                return "密码长度至少6位";
            }
        }

        return null; // 验证通过
    }

    /**
     * 检查用户名是否已被其他用户使用
     * @param username 用户名
     * @param currentUserId 当前用户ID（排除自己）
     * @return 是否已被使用
     */
    public boolean isUsernameExistsForOtherUser(String username, Integer currentUserId) {
        try {
            User existingUser = userDAO.findByUsername(username);
            if (existingUser == null) {
                return false; // 用户名不存在
            }
            // 如果存在的用户就是当前用户，则不算重复
            return !existingUser.getUserId().equals(currentUserId);
        } catch (Exception e) {
            System.err.println("检查用户名是否存在异常: " + e.getMessage());
            return true; // 出现异常时返回true，避免重复用户名
        }
    }
}
