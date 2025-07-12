package com.example.communitytool.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.example.communitytool.pojo.Admin;
import com.example.communitytool.util.DatabaseUtil;

/**
 * 管理员数据访问对象
 * 处理管理员相关的数据库操作
 */
public class AdminDAO {
    
    /**
     * 根据管理员ID查找管理员
     * @param adminId 管理员ID
     * @return 管理员对象，如果不存在返回null
     */
    public Admin findById(String adminId) {
        String sql = "SELECT admin_id, real_name, password, created_at, updated_at " +
                    "FROM admins WHERE admin_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, adminId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getString("admin_id"));
                admin.setRealName(rs.getString("real_name"));
                admin.setPassword(rs.getString("password"));
                
                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    admin.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    admin.setUpdatedAt(updatedAt.toLocalDateTime());
                }
                
                return admin;
            }
            
        } catch (SQLException e) {
            System.err.println("查询管理员失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 根据真实姓名查找管理员
     * @param realName 真实姓名
     * @return 管理员对象，如果不存在返回null
     */
    public Admin findByRealName(String realName) {
        String sql = "SELECT admin_id, real_name, password, created_at, updated_at " +
                    "FROM admins WHERE real_name = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, realName);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getString("admin_id"));
                admin.setRealName(rs.getString("real_name"));
                admin.setPassword(rs.getString("password"));
                
                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    admin.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    admin.setUpdatedAt(updatedAt.toLocalDateTime());
                }
                
                return admin;
            }
            
        } catch (SQLException e) {
            System.err.println("查询管理员失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 检查管理员ID是否存在
     * @param adminId 管理员ID
     * @return 是否存在
     */
    public boolean existsById(String adminId) {
        String sql = "SELECT COUNT(*) FROM admins WHERE admin_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, adminId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("检查管理员ID是否存在失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return false;
    }
    
    /**
     * 插入新管理员
     * @param admin 管理员对象
     * @return 是否插入成功
     */
    public boolean insert(Admin admin) {
        String sql = "INSERT INTO admins (admin_id, real_name, password) VALUES (?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, admin.getAdminId());
            pstmt.setString(2, admin.getRealName());
            pstmt.setString(3, admin.getPassword());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("插入管理员失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 更新管理员信息
     * @param admin 管理员对象
     * @return 是否更新成功
     */
    public boolean update(Admin admin) {
        String sql = "UPDATE admins SET real_name = ?, password = ? WHERE admin_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, admin.getRealName());
            pstmt.setString(2, admin.getPassword());
            pstmt.setString(3, admin.getAdminId());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("更新管理员失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 获取所有管理员列表
     * @return 管理员列表
     */
    public List<Admin> findAll() {
        String sql = "SELECT admin_id, real_name, password, created_at, updated_at FROM admins ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Admin> adminList = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getString("admin_id"));
                admin.setRealName(rs.getString("real_name"));
                admin.setPassword(rs.getString("password"));
                
                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    admin.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    admin.setUpdatedAt(updatedAt.toLocalDateTime());
                }
                
                adminList.add(admin);
            }
            
        } catch (SQLException e) {
            System.err.println("查询所有管理员失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return adminList;
    }
    
    /**
     * 删除管理员
     * @param adminId 管理员ID
     * @return 是否删除成功
     */
    public boolean delete(String adminId) {
        String sql = "DELETE FROM admins WHERE admin_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, adminId);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("删除管理员失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 关闭数据库资源
     */
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("关闭ResultSet失败: " + e.getMessage());
            }
        }
        
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                System.err.println("关闭PreparedStatement失败: " + e.getMessage());
            }
        }
        
        DatabaseUtil.closeConnection(conn);
    }
}
