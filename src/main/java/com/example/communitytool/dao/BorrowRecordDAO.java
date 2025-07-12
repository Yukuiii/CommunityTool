package com.example.communitytool.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.example.communitytool.pojo.BorrowRecord;
import com.example.communitytool.util.DatabaseUtil;

/**
 * 借用记录数据访问对象
 * 处理借用记录相关的数据库操作
 */
public class BorrowRecordDAO {
    
    /**
     * 根据记录ID查找借用记录
     * @param recordId 记录ID
     * @return 借用记录对象，如果不存在返回null
     */
    public BorrowRecord findById(Integer recordId) {
        String sql = "SELECT record_id, user_id, tool_id, borrow_time, return_time, status, rental_fee, " +
                    "created_at, updated_at, reason FROM borrow_records WHERE record_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBorrowRecord(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("查询借用记录失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 根据工具ID查找借用记录列表
     * @param toolId 工具ID
     * @return 借用记录列表
     */
    public List<BorrowRecord> findByToolId(Integer toolId) {
        String sql = "SELECT record_id, user_id, tool_id, borrow_time, return_time, status, rental_fee, " +
                    "created_at, updated_at, reason FROM borrow_records WHERE tool_id = ? ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<BorrowRecord> recordList = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, toolId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                recordList.add(mapResultSetToBorrowRecord(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("根据工具ID查询借用记录失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return recordList;
    }
    
    /**
     * 根据用户ID查找借用记录列表
     * @param userId 用户ID
     * @return 借用记录列表
     */
    public List<BorrowRecord> findByUserId(Integer userId) {
        String sql = "SELECT record_id, user_id, tool_id, borrow_time, return_time, status, rental_fee, " +
                    "created_at, updated_at, reason FROM borrow_records WHERE user_id = ? ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<BorrowRecord> recordList = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                recordList.add(mapResultSetToBorrowRecord(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("根据用户ID查询借用记录失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return recordList;
    }
    
    /**
     * 根据状态查询借用记录列表
     * @param status 借用状态
     * @return 借用记录列表
     */
    public List<BorrowRecord> findByStatus(String status) {
        String sql = "SELECT record_id, user_id, tool_id, borrow_time, return_time, status, rental_fee, " +
                    "created_at, updated_at, reason FROM borrow_records WHERE status = ? ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<BorrowRecord> recordList = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                recordList.add(mapResultSetToBorrowRecord(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("根据状态查询借用记录失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return recordList;
    }
    
    /**
     * 插入新借用记录
     * @param record 借用记录对象
     * @return 是否插入成功
     */
    public boolean insert(BorrowRecord record) {
        String sql = "INSERT INTO borrow_records (user_id, tool_id, borrow_time, return_time, status, rental_fee, reason) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            pstmt.setInt(1, record.getUserId());
            pstmt.setInt(2, record.getToolId());
            pstmt.setTimestamp(3, record.getBorrowTime() != null ?
                Timestamp.valueOf(record.getBorrowTime()) : null);
            pstmt.setTimestamp(4, record.getReturnTime() != null ?
                Timestamp.valueOf(record.getReturnTime()) : null);
            pstmt.setString(5, record.getStatus());
            pstmt.setInt(6, record.getRentalFee());
            pstmt.setString(7, record.getReason());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                // 获取生成的主键
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    record.setRecordId(generatedKeys.getInt(1));
                }
                
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("插入借用记录失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 更新借用记录状态
     * @param recordId 记录ID
     * @param status 新状态
     * @return 是否更新成功
     */
    public boolean updateStatus(Integer recordId, String status) {
        String sql = "UPDATE borrow_records SET status = ? WHERE record_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, status);
            pstmt.setInt(2, recordId);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("更新借用记录状态失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 将ResultSet映射为BorrowRecord对象
     */
    private BorrowRecord mapResultSetToBorrowRecord(ResultSet rs) throws SQLException {
        BorrowRecord record = new BorrowRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setUserId(rs.getInt("user_id"));
        record.setToolId(rs.getInt("tool_id"));
        record.setStatus(rs.getString("status"));
        record.setRentalFee(rs.getInt("rental_fee"));
        record.setReason(rs.getString("reason"));

        // 处理时间字段
        Timestamp borrowTime = rs.getTimestamp("borrow_time");
        if (borrowTime != null) {
            record.setBorrowTime(borrowTime.toLocalDateTime());
        }
        
        Timestamp returnTime = rs.getTimestamp("return_time");
        if (returnTime != null) {
            record.setReturnTime(returnTime.toLocalDateTime());
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            record.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            record.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return record;
    }
    
    /**
     * 根据提供者ID查找相关的借用记录
     * @param providerId 提供者ID
     * @return 借用记录列表
     */
    public List<BorrowRecord> findByProviderId(Integer providerId) {
        String sql = "SELECT br.record_id, br.user_id, br.tool_id, br.borrow_time, br.return_time, " +
                    "br.status, br.rental_fee, br.created_at, br.updated_at, br.reason " +
                    "FROM borrow_records br " +
                    "INNER JOIN tools t ON br.tool_id = t.tool_id " +
                    "WHERE t.provider_id = ? ORDER BY br.created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<BorrowRecord> recordList = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, providerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                recordList.add(mapResultSetToBorrowRecord(rs));
            }

        } catch (SQLException e) {
            System.err.println("根据提供者ID查询借用记录失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return recordList;
    }

    /**
     * 根据工具ID和状态查找借用记录
     * @param toolId 工具ID
     * @param status 借用状态
     * @return 借用记录列表
     */
    public List<BorrowRecord> findByToolIdAndStatus(Integer toolId, String status) {
        String sql = "SELECT record_id, user_id, tool_id, borrow_time, return_time, status, rental_fee, " +
                    "created_at, updated_at, reason FROM borrow_records WHERE tool_id = ? AND status = ? " +
                    "ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<BorrowRecord> recordList = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, toolId);
            pstmt.setString(2, status);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                recordList.add(mapResultSetToBorrowRecord(rs));
            }

        } catch (SQLException e) {
            System.err.println("根据工具ID和状态查询借用记录失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return recordList;
    }

    public boolean updateReturnTime(Integer recordId, LocalDateTime returnTime) {
        String sql = "UPDATE borrow_records SET return_time = ? WHERE record_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setTimestamp(1, Timestamp.valueOf(returnTime));
            pstmt.setInt(2, recordId);
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("更新归还时间失败: " + e.getMessage());
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

    /**
     * 更新借用记录的拒绝原因
     * @param recordId 记录ID
     * @param reason 拒绝原因
     * @return 是否更新成功
     */
    public boolean updateReason(Integer recordId, String reason) {
        String sql = "UPDATE borrow_records SET reason = ? WHERE record_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reason);
            pstmt.setInt(2, recordId);

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("更新借用记录拒绝原因失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    public boolean delete(Integer recordId) {
        String sql = "DELETE FROM borrow_records WHERE record_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordId);
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("删除借用记录失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

}
