package com.example.communitytool.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * 密码加密工具类
 * 提供密码的加密和验证功能
 */
public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * 生成随机盐值
     * @return Base64编码的盐值
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * 使用盐值加密密码
     * @param password 原始密码
     * @param salt 盐值
     * @return 加密后的密码
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            
            // 将盐值和密码组合
            String saltedPassword = salt + password;
            byte[] hashedBytes = md.digest(saltedPassword.getBytes());
            
            // 转换为Base64编码
            return Base64.getEncoder().encodeToString(hashedBytes);
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("密码加密失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 加密密码（自动生成盐值）
     * @param password 原始密码
     * @return 格式为 "盐值:加密密码" 的字符串
     */
    public static String encryptPassword(String password) {
        String salt = generateSalt();
        String hashedPassword = hashPassword(password, salt);
        return salt + ":" + hashedPassword;
    }
    
    /**
     * 验证密码
     * @param password 用户输入的密码
     * @param storedPassword 存储的加密密码（格式：盐值:加密密码）
     * @return 密码是否匹配
     */
    public static boolean verifyPassword(String password, String storedPassword) {
        try {
            // 分离盐值和加密密码
            String[] parts = storedPassword.split(":", 2);
            if (parts.length != 2) {
                return false;
            }
            
            String salt = parts[0];
            String hashedPassword = parts[1];
            
            // 使用相同的盐值加密输入的密码
            String inputHashedPassword = hashPassword(password, salt);
            
            // 比较加密结果
            return hashedPassword.equals(inputHashedPassword);
            
        } catch (Exception e) {
            System.err.println("密码验证失败: " + e.getMessage());
            return false;
        }
    }

    
    /**
     * 验证密码强度
     * @param password 密码
     * @return 密码是否符合强度要求
     */
    public static boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        
        // 检查是否包含字母和数字
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        
        return hasLetter && hasDigit;
    }
    
    /**
     * 获取密码强度描述
     * @param password 密码
     * @return 密码强度描述
     */
    public static String getPasswordStrengthDescription(String password) {
        if (password == null || password.isEmpty()) {
            return "密码不能为空";
        }
        
        if (password.length() < 6) {
            return "密码长度至少6位";
        }
        
        if (password.length() > 20) {
            return "密码长度不能超过20位";
        }
        
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        boolean hasSpecial = password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");
        
        if (!hasLetter && !hasDigit) {
            return "密码必须包含字母或数字";
        }
        
        if (hasLetter && hasDigit && hasSpecial) {
            return "强密码";
        } else if (hasLetter && hasDigit) {
            return "中等强度密码";
        } else {
            return "弱密码，建议包含字母和数字";
        }
    }
}
