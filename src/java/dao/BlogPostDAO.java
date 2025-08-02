package dao;

import java.sql.*;
import java.util.*;
import models.BlogPostDTO;
import utils.DBUtils;

public class BlogPostDAO {

    // Lấy danh sách tất cả bài viết
    public List<BlogPostDTO> getAll() throws Exception {
        List<BlogPostDTO> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT * FROM BlogPosts ORDER BY PublishedAt DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogPostDTO b = new BlogPostDTO(
                    rs.getInt("PostID"),
                    rs.getString("Title"),
                    rs.getString("Slug"),
                    rs.getString("Content"),
                    rs.getString("Summary"),
                    rs.getString("ThumbnailUrl"),
                    rs.getString("Status")
                );
                b.setAuthorID(rs.getInt("AuthorID"));
                b.setPublishedAt(rs.getTimestamp("PublishedAt"));
                b.setViewCount(rs.getInt("ViewCount"));
                list.add(b);
            }
        }
        return list;
    }

    // Thêm bài viết mới
    public void insert(BlogPostDTO post) throws Exception {
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "INSERT INTO BlogPosts (Title, Slug, Content, Summary, ThumbnailUrl, AuthorID, PublishedAt, ViewCount, Status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), 0, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getSlug());
            ps.setString(3, post.getContent());
            ps.setString(4, post.getSummary());
            ps.setString(5, post.getThumbnailUrl());
            ps.setInt(6, post.getAuthorID());
            ps.setString(7, post.getStatus());
            ps.executeUpdate();
        }
    }

    // Lấy bài viết theo ID
    public BlogPostDTO getById(int id) throws Exception {
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT * FROM BlogPosts WHERE PostID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BlogPostDTO b = new BlogPostDTO(
                    rs.getInt("PostID"),
                    rs.getString("Title"),
                    rs.getString("Slug"),
                    rs.getString("Content"),
                    rs.getString("Summary"),
                    rs.getString("ThumbnailUrl"),
                    rs.getString("Status")
                );
                b.setAuthorID(rs.getInt("AuthorID"));
                b.setPublishedAt(rs.getTimestamp("PublishedAt"));
                b.setViewCount(rs.getInt("ViewCount"));
                return b;
            }
        }
        return null;
    }

    // Cập nhật bài viết
    public void update(BlogPostDTO post) throws Exception {
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "UPDATE BlogPosts SET Title = ?, Slug = ?, Content = ?, Summary = ?, ThumbnailUrl = ?, Status = ? WHERE PostID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getSlug());
            ps.setString(3, post.getContent());
            ps.setString(4, post.getSummary());
            ps.setString(5, post.getThumbnailUrl());
            ps.setString(6, post.getStatus());
            ps.setInt(7, post.getPostID());
            ps.executeUpdate();
        }
    }

    // Xoá bài viết (và comment liên quan)
    public void delete(int postId) throws Exception {
        try (Connection conn = DBUtils.getConnection()) {
            conn.setAutoCommit(false);

            String deleteComments = "DELETE FROM BlogComments WHERE PostID = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(deleteComments)) {
                ps1.setInt(1, postId);
                ps1.executeUpdate();
            }

            String deletePost = "DELETE FROM BlogPosts WHERE PostID = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(deletePost)) {
                ps2.setInt(1, postId);
                ps2.executeUpdate();
            }

            conn.commit();
        }
    }

    // Tìm kiếm bài viết theo tiêu đề
    public List<BlogPostDTO> searchByTitle(String keyword) throws Exception {
        List<BlogPostDTO> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT * FROM BlogPosts WHERE Title LIKE ? ORDER BY PublishedAt DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogPostDTO b = new BlogPostDTO(
                    rs.getInt("PostID"),
                    rs.getString("Title"),
                    rs.getString("Slug"),
                    rs.getString("Content"),
                    rs.getString("Summary"),
                    rs.getString("ThumbnailUrl"),
                    rs.getString("Status")
                );
                b.setAuthorID(rs.getInt("AuthorID"));
                b.setPublishedAt(rs.getTimestamp("PublishedAt"));
                b.setViewCount(rs.getInt("ViewCount"));
                list.add(b);
            }
        }
        return list;
    }

    // Lấy danh sách bài viết theo trạng thái
    public List<BlogPostDTO> getByStatus(String status) throws Exception {
        List<BlogPostDTO> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "SELECT * FROM BlogPosts WHERE Status = ? ORDER BY PublishedAt DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogPostDTO b = new BlogPostDTO(
                    rs.getInt("PostID"),
                    rs.getString("Title"),
                    rs.getString("Slug"),
                    rs.getString("Content"),
                    rs.getString("Summary"),
                    rs.getString("ThumbnailUrl"),
                    rs.getString("Status")
                );
                b.setAuthorID(rs.getInt("AuthorID"));
                b.setPublishedAt(rs.getTimestamp("PublishedAt"));
                b.setViewCount(rs.getInt("ViewCount"));
                list.add(b);
            }
        }
        return list;
    }

    // Auto-publish bài viết hẹn giờ
    public void autoPublishScheduledPosts(Timestamp now) throws Exception {
        try (Connection conn = DBUtils.getConnection()) {
            String sql = "UPDATE BlogPosts SET Status = 'published' " +
                         "WHERE Status = 'scheduled' AND PublishedAt <= ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setTimestamp(1, now);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                System.out.println("📢 " + updated + " bài viết đã được publish.");
            }
        }
    }
    public boolean isSlugTaken(String slug) {
    try (Connection conn = DBUtils.getConnection()) {
        String sql = "SELECT COUNT(*) FROM BlogPosts WHERE Slug = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, slug);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}


    // Chưa dùng
    public BlogPostDTO getPostById(int postId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void incrementViewCount(int postId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public BlogPostDTO getPreviousPost(int postId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public BlogPostDTO getNextPost(int postId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int countPosts(String search) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<BlogPostDTO> getPostsByPage(int currentPage, int itemsPerPage, String search, String sort) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

   
}
