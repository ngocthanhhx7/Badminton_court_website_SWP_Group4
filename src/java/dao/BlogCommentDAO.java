package dao;

import models.BlogCommentDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BlogCommentDAO {
    
    public List<BlogCommentDTO> getAllComments() {
        String sql = "SELECT * FROM BlogComments ORDER BY CreatedAt DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogCommentDTO> comments = new ArrayList<>();

            while (resultSet.next()) {
                comments.add(mapResultSetToComment(resultSet));
            }

            return comments;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public BlogCommentDTO getCommentById(int commentId) {
        String sql = "SELECT * FROM BlogComments WHERE CommentID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, commentId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToComment(resultSet);
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<BlogCommentDTO> getCommentsByPost(int postId) {
        String sql = "SELECT * FROM BlogComments WHERE PostID = ? ORDER BY CreatedAt DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, postId);
            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogCommentDTO> comments = new ArrayList<>();

            while (resultSet.next()) {
                comments.add(mapResultSetToComment(resultSet));
            }

            return comments;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<BlogCommentDTO> getCommentsByUser(int userId) {
        String sql = "SELECT * FROM BlogComments WHERE UserID = ? ORDER BY CreatedAt DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, userId);
            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogCommentDTO> comments = new ArrayList<>();

            while (resultSet.next()) {
                comments.add(mapResultSetToComment(resultSet));
            }

            return comments;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<BlogCommentDTO> getReplies(int parentCommentId) {
        String sql = "SELECT * FROM BlogComments WHERE ParentCommentID = ? ORDER BY CreatedAt ASC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, parentCommentId);
            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogCommentDTO> replies = new ArrayList<>();

            while (resultSet.next()) {
                replies.add(mapResultSetToComment(resultSet));
            }

            return replies;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public int createComment(BlogCommentDTO comment) {
        String sql = "INSERT INTO BlogComments (PostID, UserID, Content, CreatedAt, ParentCommentID) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setInt(1, comment.getPostID());
            preparedStatement.setInt(2, comment.getUserID());
            preparedStatement.setString(3, comment.getContent());
            preparedStatement.setTimestamp(4, comment.getCreatedAt());
            preparedStatement.setObject(5, comment.getParentCommentID());
            
            preparedStatement.executeUpdate();
            
            try (ResultSet rs = preparedStatement.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    public boolean updateComment(BlogCommentDTO comment) {
        String sql = "UPDATE BlogComments SET Content = ? WHERE CommentID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, comment.getContent());
            preparedStatement.setInt(2, comment.getCommentID());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM BlogComments WHERE CommentID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, commentId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteReplies(int parentCommentId) {
        String sql = "DELETE FROM BlogComments WHERE ParentCommentID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, parentCommentId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private BlogCommentDTO mapResultSetToComment(ResultSet rs) throws Exception {
        return BlogCommentDTO.builder()
                .CommentID(rs.getInt("CommentID"))
                .PostID(rs.getInt("PostID"))
                .UserID(rs.getInt("UserID"))
                .Content(rs.getString("Content"))
                .CreatedAt(rs.getTimestamp("CreatedAt"))
                .ParentCommentID(rs.getInt("ParentCommentID"))
                .build();
    }
} 