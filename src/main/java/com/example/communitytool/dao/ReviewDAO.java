package com.example.communitytool.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.example.communitytool.pojo.Review;
import com.example.communitytool.util.DatabaseUtil;

/**
 * 评价数据访问对象
 * 处理评价相关的数据库操作
 */
public class ReviewDAO {
    
    /**
     * 根据评价ID查找评价
     * @param reviewId 评价ID
     * @return 评价对象，如果不存在返回null
     */
    public Review findById(Integer reviewId) {
        String sql = "SELECT review_id, user_id, tool_id, rating, review_content, status, reason, " +
                    "created_at, updated_at FROM reviews WHERE review_id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reviewId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setToolId(rs.getInt("tool_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewContent(rs.getString("review_content"));
                review.setStatus(rs.getString("status"));
                review.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    review.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    review.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                return review;
            }
            
        } catch (SQLException e) {
            System.err.println("查询评价失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 根据工具ID查询评价列表
     * @param toolId 工具ID
     * @return 评价列表
     */
    public List<Review> findByToolId(Integer toolId) {
        String sql = "SELECT review_id, user_id, tool_id, rating, review_content, status, reason, " +
                    "created_at, updated_at FROM reviews WHERE tool_id = ? ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Review> reviewList = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, toolId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setToolId(rs.getInt("tool_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewContent(rs.getString("review_content"));
                review.setStatus(rs.getString("status"));
                review.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    review.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    review.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                reviewList.add(review);
            }
            
        } catch (SQLException e) {
            System.err.println("根据工具ID查询评价失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return reviewList;
    }
    
    /**
     * 根据用户ID查询评价列表
     * @param userId 用户ID
     * @return 评价列表
     */
    public List<Review> findByUserId(Integer userId) {
        String sql = "SELECT review_id, user_id, tool_id, rating, review_content, status, reason, " +
                    "created_at, updated_at FROM reviews WHERE user_id = ? ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Review> reviewList = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setToolId(rs.getInt("tool_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewContent(rs.getString("review_content"));
                review.setStatus(rs.getString("status"));
                review.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    review.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    review.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                reviewList.add(review);
            }
            
        } catch (SQLException e) {
            System.err.println("根据用户ID查询评价失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return reviewList;
    }
    
    /**
     * 根据状态查询评价列表
     * @param status 评价状态
     * @return 评价列表
     */
    public List<Review> findByStatus(String status) {
        String sql = "SELECT review_id, user_id, tool_id, rating, review_content, status, reason, " +
                    "created_at, updated_at FROM reviews WHERE status = ? ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Review> reviewList = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setToolId(rs.getInt("tool_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewContent(rs.getString("review_content"));
                review.setStatus(rs.getString("status"));
                review.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    review.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    review.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                reviewList.add(review);
            }
            
        } catch (SQLException e) {
            System.err.println("根据状态查询评价失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return reviewList;
    }
    
    /**
     * 获取待审核评价列表
     * @return 待审核评价列表
     */
    public List<Review> findPendingReviews() {
        return findByStatus(Review.STATUS_PENDING);
    }
    
    /**
     * 插入新评价
     * @param review 评价对象
     * @return 是否插入成功
     */
    public boolean insert(Review review) {
        String sql = "INSERT INTO reviews (user_id, tool_id, rating, review_content, status, reason) VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            pstmt.setInt(1, review.getUserId());
            pstmt.setInt(2, review.getToolId());
            pstmt.setInt(3, review.getRating());
            pstmt.setString(4, review.getReviewContent());
            pstmt.setString(5, review.getStatus() != null ? review.getStatus() : Review.STATUS_PENDING);
            pstmt.setString(6, review.getReason());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                // 获取生成的主键
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    review.setReviewId(generatedKeys.getInt(1));
                }

                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("插入评价失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 更新评价状态
     * @param reviewId 评价ID
     * @param status 新状态
     * @return 是否更新成功
     */
    public boolean updateStatus(Integer reviewId, String status) {
        String sql = "UPDATE reviews SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE review_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, status);
            pstmt.setInt(2, reviewId);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("更新评价状态失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 更新评价信息
     * @param review 评价对象
     * @return 是否更新成功
     */
    public boolean update(Review review) {
        String sql = "UPDATE reviews SET rating = ?, review_content = ?, status = ?, reason = ?, " +
                    "updated_at = CURRENT_TIMESTAMP WHERE review_id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, review.getRating());
            pstmt.setString(2, review.getReviewContent());
            pstmt.setString(3, review.getStatus());
            pstmt.setString(4, review.getReason());
            pstmt.setInt(5, review.getReviewId());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("更新评价失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 删除评价
     * @param reviewId 评价ID
     * @return 是否删除成功
     */
    public boolean delete(Integer reviewId) {
        String sql = "DELETE FROM reviews WHERE review_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reviewId);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("删除评价失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * 获取所有评价列表
     * @return 评价列表
     */
    public List<Review> findAll() {
        String sql = "SELECT review_id, user_id, tool_id, rating, review_content, status, reason, " +
                    "created_at, updated_at FROM reviews ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Review> reviewList = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setToolId(rs.getInt("tool_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewContent(rs.getString("review_content"));
                review.setStatus(rs.getString("status"));
                review.setReason(rs.getString("reason"));

                // 处理时间字段
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    review.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    review.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                reviewList.add(review);
            }
            
        } catch (SQLException e) {
            System.err.println("查询所有评价失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return reviewList;
    }

    /**
     * 更新评价的拒绝原因
     * @param reviewId 评价ID
     * @param reason 拒绝原因
     * @return 是否更新成功
     */
    public boolean updateReason(Integer reviewId, String reason) {
        String sql = "UPDATE reviews SET reason = ?, updated_at = CURRENT_TIMESTAMP WHERE review_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reason);
            pstmt.setInt(2, reviewId);

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                DatabaseUtil.commit(conn);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("更新评价拒绝原因失败: " + e.getMessage());
            DatabaseUtil.rollback(conn);
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * 检查用户是否已对某工具进行评价
     * @param userId 用户ID
     * @param toolId 工具ID
     * @return 是否已评价
     */
    public boolean existsByUserIdAndToolId(Integer userId, Integer toolId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND tool_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, toolId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("检查评价是否存在失败: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
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