package com.example.communitytool.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * 数据库连接工具类
 * 提供数据库连接的获取和管理功能
 */
public class DatabaseUtil {
    
    private static String driver;
    private static String url;
    private static String username;
    private static String password;
    
    // 静态代码块，加载数据库配置
    static {
        loadDatabaseConfig();
    }
    
    /**
     * 加载数据库配置文件
     */
    private static void loadDatabaseConfig() {
        Properties props = new Properties();
        InputStream inputStream = null;
        
        try {
            // 从类路径加载配置文件
            inputStream = DatabaseUtil.class.getClassLoader()
                    .getResourceAsStream("database.properties");
            
            if (inputStream == null) {
                throw new RuntimeException("无法找到数据库配置文件 database.properties");
            }
            
            props.load(inputStream);
            
            // 读取配置参数
            driver = props.getProperty("driver");
            url = props.getProperty("url");
            username = props.getProperty("username");
            password = props.getProperty("password");
            
            // 验证配置参数
            if (driver == null || url == null || username == null || password == null) {
                throw new RuntimeException("数据库配置文件中缺少必要的配置参数");
            }
            
            // 加载数据库驱动
            Class.forName(driver);
            
            System.out.println("数据库配置加载成功");
            
        } catch (IOException e) {
            throw new RuntimeException("读取数据库配置文件失败: " + e.getMessage(), e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("数据库驱动加载失败: " + e.getMessage(), e);
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    System.err.println("关闭配置文件流失败: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * 获取数据库连接
     * @return 数据库连接对象
     * @throws SQLException 数据库连接异常
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(url, username, password);
            // 设置自动提交为false，支持事务
            conn.setAutoCommit(false);
            return conn;
        } catch (SQLException e) {
            System.err.println("获取数据库连接失败: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * 关闭数据库连接
     * @param conn 数据库连接对象
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("关闭数据库连接失败: " + e.getMessage());
            }
        }
    }
    
    /**
     * 提交事务
     * @param conn 数据库连接对象
     */
    public static void commit(Connection conn) {
        if (conn != null) {
            try {
                conn.commit();
            } catch (SQLException e) {
                System.err.println("提交事务失败: " + e.getMessage());
            }
        }
    }
    
    /**
     * 回滚事务
     * @param conn 数据库连接对象
     */
    public static void rollback(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                System.err.println("回滚事务失败: " + e.getMessage());
            }
        }
    }
    
    /**
     * 测试数据库连接
     * @return 连接是否成功
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("数据库连接测试失败: " + e.getMessage());
            return false;
        } finally {
            closeConnection(conn);
        }
    }
}
