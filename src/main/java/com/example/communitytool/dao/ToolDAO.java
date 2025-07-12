package com.example.communitytool.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.example.communitytool.pojo.Tool;
import com.example.communitytool.util.DatabaseUtil;

/**
 * 工具数据访问对象
 * 处理工具相关的数据库操作
 */
public class ToolDAO {
    
    /**
     * 根据工具ID查找工具
     * @param toolId 工具ID
     * @return 工具对象，如果不存在返回null
     */ 
    public Tool findById(Integer toolId) {
        String sql = "SELECT tool_id, tool_name, description, provider_id, rental_fee, status, " +
                    "created_at, updated_at, reason FROM tools WHERE tool_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, toolId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Tool tool = new Tool();
                tool.setToolId(rs.getInt("tool_id"));
                tool.setToolName(rs.getString("tool_name"));
                tool.setDescription(rs.getString("description"));
                tool.setProviderId(rs.getInt("provider_id"));
                tool.setRentalFee(rs.getInt("rental_fee"));
                tool.setStatus(rs.getString("status"));
                tool.setReason(rs.getString("reason"));
                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    tool.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    tool.setUpdatedAt(updatedAt.toLocalDateTime());
                }
                
                return tool;
            }
            
        } catch (SQLException e) {
            System.err.println("查询工具失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 根据状态查询工具列表
     * @param status 工具状态
     * @return 工具列表
     */
    public List<Tool> findByStatus(String status) {
        String sql = "SELECT tool_id, tool_name, description, provider_id, rental_fee, status, " +
                    "created_at, updated_at, reason FROM tools WHERE status = ? ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Tool> toolList = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Tool tool = new Tool();
                tool.setToolId(rs.getInt("tool_id"));
                tool.setToolName(rs.getString("tool_name"));
                tool.setDescription(rs.getString("description"));
                tool.setProviderId(rs.getInt("provider_id"));
                tool.setRentalFee(rs.getInt("rental_fee"));
                tool.setStatus(rs.getString("status"));
                tool.setReason(rs.getString("reason"));
                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    tool.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    tool.setUpdatedAt(updatedAt.toLocalDateTime());
                }
                
                toolList.add(tool);
            }
            
        } catch (SQLException e) {
            System.err.println("根据状态查询工具失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return toolList;
    }
    
    /**
     * 获取待审核工具列表
     * @return 待审核工具列表
     */
    public List<Tool> findPendingTools() {
        return findByStatus(Tool.STATUS_PENDING);
    }
    
    /**
     * 更新工具状态
     * @param toolId 工具ID
     * @param status 新状态
     * @return 是否更新成功
     */
    public boolean updateStatus(Integer toolId, String status) {
        String sql = "UPDATE tools SET status = ? WHERE tool_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, status);
            pstmt.setInt(2, toolId);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("更新工具状态失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 插入新工具
     * @param tool 工具对象
     * @return 是否插入成功
     */
    public boolean insert(Tool tool) {
        String sql = "INSERT INTO tools (tool_name, description, provider_id, rental_fee, status) VALUES (?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            pstmt.setString(1, tool.getToolName());
            pstmt.setString(2, tool.getDescription());
            pstmt.setInt(3, tool.getProviderId());
            pstmt.setInt(4, tool.getRentalFee());
            pstmt.setString(5, tool.getStatus());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                // 获取生成的主键
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    tool.setToolId(generatedKeys.getInt(1));
                }
                
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("插入工具失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 获取所有工具列表
     * @return 工具列表
     */
    public List<Tool> findAll() {
        String sql = "SELECT tool_id, tool_name, description, provider_id, rental_fee, status, " +
                    "created_at, updated_at, reason FROM tools ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Tool> toolList = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Tool tool = new Tool();
                tool.setToolId(rs.getInt("tool_id"));
                tool.setToolName(rs.getString("tool_name"));
                tool.setDescription(rs.getString("description"));
                tool.setProviderId(rs.getInt("provider_id"));
                tool.setRentalFee(rs.getInt("rental_fee"));
                tool.setStatus(rs.getString("status"));
                tool.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    tool.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    tool.setUpdatedAt(updatedAt.toLocalDateTime());
                }
                
                toolList.add(tool);
            }
            
        } catch (SQLException e) {
            System.err.println("查询所有工具失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return toolList;
    }
    
    /**
     * 根据提供者ID查询工具列表
     * @param providerId 提供者ID
     * @return 工具列表
     */
    public List<Tool> findByProviderId(Integer providerId) {
        String sql = "SELECT tool_id, tool_name, description, provider_id, rental_fee, status, " +
                    "created_at, updated_at, reason FROM tools WHERE provider_id = ? ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Tool> toolList = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, providerId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Tool tool = new Tool();
                tool.setToolId(rs.getInt("tool_id"));
                tool.setToolName(rs.getString("tool_name"));
                tool.setDescription(rs.getString("description"));
                tool.setProviderId(rs.getInt("provider_id"));
                tool.setRentalFee(rs.getInt("rental_fee"));
                tool.setStatus(rs.getString("status"));
                tool.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    tool.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    tool.setUpdatedAt(updatedAt.toLocalDateTime());
                }
                
                toolList.add(tool);
            }
            
        } catch (SQLException e) {
            System.err.println("根据提供者ID查询工具失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return toolList;
    }


    public boolean updateReason(Integer toolId, String reason) {
        String sql = "UPDATE tools SET reason = ? WHERE tool_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reason);
            pstmt.setInt(2, toolId);
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("更新拒绝原因失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    /**
     * 更新工具信息
     * @param toolId 工具ID
     * @param toolName 工具名称
     * @param description 工具描述
     * @param rentalFee 租金
     * @return 是否更新成功
     */
    public boolean updateTool(Integer toolId, String toolName, String description, Integer rentalFee) {
        String sql = "UPDATE tools SET tool_name = ?, description = ?, rental_fee = ? WHERE tool_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, toolName);
            pstmt.setString(2, description);
            pstmt.setInt(3, rentalFee);
            pstmt.setInt(4, toolId);
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("更新工具信息失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    /**
     * 根据工具名称模糊搜索闲置工具
     * @param toolName 工具名称关键词
     * @return 匹配的闲置工具列表
     */
    public List<Tool> searchAvailableToolsByName(String toolName) {
        String sql = "SELECT tool_id, tool_name, description, provider_id, rental_fee, status, " +
                    "created_at, updated_at, reason FROM tools WHERE status = ? AND tool_name LIKE ? " +
                    "ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Tool> toolList = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, Tool.STATUS_AVAILABLE);
            pstmt.setString(2, "%" + toolName + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Tool tool = new Tool();
                tool.setToolId(rs.getInt("tool_id"));
                tool.setToolName(rs.getString("tool_name"));
                tool.setDescription(rs.getString("description"));
                tool.setProviderId(rs.getInt("provider_id"));
                tool.setRentalFee(rs.getInt("rental_fee"));
                tool.setStatus(rs.getString("status"));
                tool.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    tool.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    tool.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                toolList.add(tool);
            }

        } catch (SQLException e) {
            System.err.println("按工具名称搜索闲置工具失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return toolList;
    }

    public boolean delete(Integer toolId) {
        String sql = "DELETE FROM tools WHERE tool_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, toolId);
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("删除工具失败: " + e.getMessage());
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
