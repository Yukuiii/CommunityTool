package com.example.communitytool.service;

import com.example.communitytool.dao.AdminDAO;
import com.example.communitytool.dao.UserDAO;
import com.example.communitytool.pojo.Admin;
import com.example.communitytool.pojo.User;
import com.example.communitytool.util.PasswordUtil;

/**
 * 登录服务类
 * 处理用户和管理员的登录业务逻辑
 */
public class LoginService {

    private UserDAO userDAO;
    private AdminDAO adminDAO;

    /**
     * 构造函数，初始化DAO对象
     */
    public LoginService() {
        this.userDAO = new UserDAO();
        this.adminDAO = new AdminDAO();
    }

    /**
     * 用户登录验证
     * @param username 用户名
     * @param password 密码
     * @return 是否登录成功
     */
    public boolean userLogin(String username, String password) {
        try {
            // 参数验证
            if (username == null || username.trim().isEmpty()) {
                System.out.println("用户登录失败：用户名为空");
                return false;
            }

            if (password == null || password.trim().isEmpty()) {
                System.out.println("用户登录失败：密码为空");
                return false;
            }

            // 查找用户
            User user = userDAO.findByUsername(username.trim());
            if (user == null) {
                System.out.println("用户登录失败：用户不存在 - " + username);
                return false;
            }

            // 验证密码
            boolean passwordValid = false;
            String storedPassword = user.getPassword();

            // 验证密码
            passwordValid = PasswordUtil.verifyPassword(password, storedPassword);

            if (passwordValid) {
                System.out.println("用户登录成功：" + username);
                return true;
            } else {
                System.out.println("用户登录失败：密码错误 - " + username);
                return false;
            }

        } catch (Exception e) {
            System.err.println("用户登录异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 管理员登录验证
     * @param adminId 管理员ID或真实姓名
     * @param password 密码
     * @return 是否登录成功
     */
    public boolean adminLogin(String adminId, String password) {
        try {
            // 参数验证
            if (adminId == null || adminId.trim().isEmpty()) {
                System.out.println("管理员登录失败：管理员ID为空");
                return false;
            }

            if (password == null || password.trim().isEmpty()) {
                System.out.println("管理员登录失败：密码为空");
                return false;
            }

            // 查找管理员（先按ID查找，再按真实姓名查找）
            Admin admin = adminDAO.findById(adminId.trim());
            if (admin == null) {
                admin = adminDAO.findByRealName(adminId.trim());
            }

            if (admin == null) {
                System.out.println("管理员登录失败：管理员不存在 - " + adminId);
                return false;
            }

            // 验证密码
            boolean passwordValid = false;
            String storedPassword = admin.getPassword();

            // 验证密码
            passwordValid = PasswordUtil.verifyPassword(password, storedPassword);

            if (passwordValid) {
                System.out.println("管理员登录成功：" + adminId + " (" + admin.getRealName() + ")");
                return true;
            } else {
                System.out.println("管理员登录失败：密码错误 - " + adminId);
                return false;
            }

        } catch (Exception e) {
            System.err.println("管理员登录异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 根据用户名获取用户信息（用于登录成功后获取用户详情）
     * @param username 用户名
     * @return 用户对象（密码字段为null）
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
     * 根据管理员ID获取管理员信息（用于登录成功后获取管理员详情）
     * @param adminId 管理员ID或真实姓名
     * @return 管理员对象（密码字段为null）
     */
    public Admin getAdminById(String adminId) {
        try {
            Admin admin = adminDAO.findById(adminId);
            if (admin == null) {
                admin = adminDAO.findByRealName(adminId);
            }
            if (admin != null) {
                // 清除密码信息
                admin.setPassword(null);
            }
            return admin;
        } catch (Exception e) {
            System.err.println("获取管理员信息异常: " + e.getMessage());
            return null;
        }
    }
}
