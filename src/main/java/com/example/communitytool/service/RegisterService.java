package com.example.communitytool.service;

import com.example.communitytool.dao.UserDAO;
import com.example.communitytool.pojo.User;
import com.example.communitytool.util.PasswordUtil;

/**
 * 注册服务类
 * 处理用户注册相关的业务逻辑
 */
public class RegisterService {

    private UserDAO userDAO;

    /**
     * 构造函数，初始化DAO对象
     */
    public RegisterService() {
        this.userDAO = new UserDAO();
    }

    /**
     * 用户注册
     * @param username 用户名
     * @param password 密码
     * @param phone 手机号
     * @param role 用户角色，默认为"user"
     * @return 是否注册成功
     */
    public boolean registerUser(String username, String password, String phone, String role) {
        try {
            // 参数验证
            if (username == null || username.trim().isEmpty()) {
                System.out.println("注册失败：用户名为空");
                return false;
            }

            if (password == null || password.trim().isEmpty()) {
                System.out.println("注册失败：密码为空");
                return false;
            }

            // 检查用户名是否已存在
            if (userDAO.existsByUsername(username.trim())) {
                System.out.println("注册失败：用户名已存在 - " + username);
                return false;
            }

            // 创建用户对象
            User user = new User();
            user.setUsername(username.trim());

            // 加密密码
            String encryptedPassword = PasswordUtil.encryptPassword(password);
            user.setPassword(encryptedPassword);

            user.setPhone(phone != null ? phone.trim() : null);
            user.setRole(role != null ? role : "borrower");

            // 保存用户到数据库
            boolean success = userDAO.insert(user);

            if (success) {
                System.out.println("用户注册成功：" + username);
                return true;
            } else {
                System.out.println("用户注册失败：数据库操作失败 - " + username);
                return false;
            }

        } catch (Exception e) {
            System.err.println("用户注册异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 检查用户名是否已存在
     * @param username 用户名
     * @return 是否存在
     */
    public boolean isUsernameExists(String username) {
        try {
            return userDAO.existsByUsername(username);
        } catch (Exception e) {
            System.err.println("检查用户名是否存在异常: " + e.getMessage());
            return true; // 出现异常时返回true，避免重复注册
        }
    }

    /**
     * 验证用户名格式
     * @param username 用户名
     * @return 是否有效
     */
    public boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        String trimmedUsername = username.trim();

        // 长度检查：3-20位
        if (trimmedUsername.length() < 3 || trimmedUsername.length() > 20) {
            return false;
        }

        // 字符检查：只能包含字母、数字、下划线
        return trimmedUsername.matches("^[a-zA-Z0-9_]+$");
    }

    /**
     * 验证手机号格式
     * @param phone 手机号
     * @return 是否有效
     */
    public boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true; // 手机号可以为空
        }

        // 中国大陆手机号格式验证
        return phone.trim().matches("^1[3-9]\\d{9}$");
    }

    /**
     * 验证密码强度
     * @param password 密码
     * @return 是否符合要求
     */
    public boolean isValidPassword(String password) {
        return PasswordUtil.isPasswordStrong(password);
    }

    /**
     * 获取密码强度描述
     * @param password 密码
     * @return 密码强度描述
     */
    public String getPasswordStrengthDescription(String password) {
        return PasswordUtil.getPasswordStrengthDescription(password);
    }

    /**
     * 根据用户名获取用户信息
     * @param username 用户名
     * @return 用户对象
     */
    public User getUserByUsername(String username) {
        try {
            User user = userDAO.findByUsername(username);
            if (user != null) {
                // 清除密码信息
                user.setPassword(null);
            }
            return user;
        } catch (Exception e) {
            System.err.println("获取用户信息异常: " + e.getMessage());
            return null;
        }
    }

    /**
     * 验证注册数据的完整性
     * @param username 用户名
     * @param password 密码
     * @param confirmPassword 确认密码
     * @param phone 手机号
     * @return 验证错误信息，null表示验证通过
     */
    public String validateRegistrationData(String username, String password, String confirmPassword, String phone) {
        // 检查必填项
        if (username == null || username.trim().isEmpty()) {
            return "用户名不能为空";
        }

        if (password == null || password.isEmpty()) {
            return "密码不能为空";
        }

        if (confirmPassword == null || confirmPassword.isEmpty()) {
            return "请确认密码";
        }

        // 验证用户名格式
        if (!isValidUsername(username)) {
            return "用户名格式不正确，只能包含3-20位字母、数字和下划线";
        }

        // 验证密码长度
        if (password.length() < 6) {
            return "密码长度至少6位";
        }

        // 验证密码确认
        if (!password.equals(confirmPassword)) {
            return "两次输入的密码不一致";
        }

        // 验证手机号格式（如果提供）
        if (!isValidPhone(phone)) {
            return "手机号格式不正确";
        }

        return null; // 验证通过
    }
}
