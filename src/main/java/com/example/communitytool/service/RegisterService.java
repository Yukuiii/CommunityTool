package com.example.communitytool.service;

import com.example.communitytool.dao.UserDAO;
import com.example.communitytool.pojo.User;

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

            // 检查用户名是否已存在
            if (userDAO.existsByUsername(username.trim())) {
                throw new Exception("用户名已存在");
            }

            // 创建用户对象
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(password);
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
}
