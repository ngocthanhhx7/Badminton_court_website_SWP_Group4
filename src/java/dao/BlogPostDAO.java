package dao;

import models.BlogPostDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class BlogPostDAO {

    public List<BlogPostDTO> getAllPosts() {
        String sql = "SELECT * FROM BlogPosts ORDER BY PublishedAt DESC";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogPostDTO> posts = new ArrayList<>();

            while (resultSet.next()) {
                posts.add(mapResultSetToPost(resultSet));
            }

            return posts;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public BlogPostDTO getPostById(int postId) {
        String sql = "SELECT * FROM BlogPosts WHERE PostID = ?";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, postId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToPost(resultSet);
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<BlogPostDTO> getPostsByAuthor(int authorId) {
        String sql = "SELECT * FROM BlogPosts WHERE AuthorID = ? ORDER BY PublishedAt DESC";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, authorId);
            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogPostDTO> posts = new ArrayList<>();

            while (resultSet.next()) {
                posts.add(mapResultSetToPost(resultSet));
            }

            return posts;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public int createPost(BlogPostDTO post) {
        String sql = "INSERT INTO BlogPosts (Title, Slug, Content, Summary, ThumbnailUrl, PublishedAt, AuthorID, ViewCount, Status, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql,
                        Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setString(1, post.getTitle());
            preparedStatement.setString(2, post.getSlug());
            preparedStatement.setString(3, post.getContent());
            preparedStatement.setString(4, post.getSummary());
            preparedStatement.setString(5, post.getThumbnailUrl());
            preparedStatement.setTimestamp(6, post.getPublishedAt());
            preparedStatement.setInt(7, post.getAuthorID());
            preparedStatement.setInt(8, post.getViewCount());
            preparedStatement.setString(9, post.getStatus());
            preparedStatement.setTimestamp(10, post.getCreatedAt());
            preparedStatement.setTimestamp(11, post.getUpdatedAt());

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

    public boolean updatePost(BlogPostDTO post) {
        String sql = "UPDATE BlogPosts SET Title = ?, Slug = ?, Content = ?, Summary = ?, ThumbnailUrl = ?, PublishedAt = ?, ViewCount = ?, Status = ?, UpdatedAt = ? WHERE PostID = ?";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, post.getTitle());
            preparedStatement.setString(2, post.getSlug());
            preparedStatement.setString(3, post.getContent());
            preparedStatement.setString(4, post.getSummary());
            preparedStatement.setString(5, post.getThumbnailUrl());
            preparedStatement.setTimestamp(6, post.getPublishedAt());
            preparedStatement.setInt(7, post.getViewCount());
            preparedStatement.setString(8, post.getStatus());
            preparedStatement.setTimestamp(9, post.getUpdatedAt());
            preparedStatement.setInt(10, post.getPostID());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePost(int postId) {
        String sql = "DELETE FROM BlogPosts WHERE PostID = ?";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, postId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean incrementViewCount(int postId) {
        String sql = "UPDATE BlogPosts SET ViewCount = ViewCount + 1 WHERE PostID = ?";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, postId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<BlogPostDTO> searchPosts(String keyword) {
        String sql = "SELECT * FROM BlogPosts WHERE Title LIKE ? OR Content LIKE ? OR Summary LIKE ? ORDER BY PublishedAt DESC";
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            preparedStatement.setString(1, searchPattern);
            preparedStatement.setString(2, searchPattern);
            preparedStatement.setString(3, searchPattern);

            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogPostDTO> posts = new ArrayList<>();

            while (resultSet.next()) {
                posts.add(mapResultSetToPost(resultSet));
            }

            return posts;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<BlogPostDTO> getSimilarPosts(int postId, int limit) {
        List<BlogPostDTO> similarPosts = new ArrayList<>();
        try {
            // First get the tags of the current post
            String getPostTagsQuery = "SELECT TagID FROM BlogTags WHERE PostID = ?";
            List<Integer> postTags = new ArrayList<>();
            try (Connection conn = DBUtils.getConnection();
                    PreparedStatement ps = conn.prepareStatement(getPostTagsQuery)) {
                ps.setInt(1, postId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        postTags.add(rs.getInt("TagID"));
                    }
                }
            }

            if (!postTags.isEmpty()) {
                // Get posts that share tags with the current post
                String getSimilarPostsQuery = "SELECT DISTINCT p.* FROM BlogPosts p "
                        + "JOIN BlogTags pt ON p.PostID = pt.PostID "
                        + "WHERE p.PostID != ? AND pt.TagID IN ("
                        + String.join(",", Collections.nCopies(postTags.size(), "?")) + ") "
                        + "ORDER BY p.PublishedAt DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

                try (Connection conn = DBUtils.getConnection();
                        PreparedStatement ps = conn.prepareStatement(getSimilarPostsQuery)) {

                    int paramIndex = 1;
                    ps.setInt(paramIndex++, postId);

                    for (Integer tagId : postTags) {
                        ps.setInt(paramIndex++, tagId);
                    }

                    ps.setInt(paramIndex, limit);

                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            similarPosts.add(mapResultSetToPost(rs));
                        }
                    }
                }
            } else {
                // If no tags, get recent posts instead
                String getRecentPostsQuery = "SELECT * FROM BlogPosts WHERE PostID != ? ORDER BY PublishedAt DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
                try (Connection conn = DBUtils.getConnection();
                        PreparedStatement ps = conn.prepareStatement(getRecentPostsQuery)) {
                    ps.setInt(1, postId);
                    ps.setInt(2, limit);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            similarPosts.add(mapResultSetToPost(rs));
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return similarPosts;
    }

    private BlogPostDTO mapResultSetToPost(ResultSet rs) throws Exception {
        BlogPostDTO post = new BlogPostDTO();
        post.setPostID(rs.getInt("PostID"));
        post.setTitle(rs.getString("Title"));
        post.setContent(rs.getString("Content"));
        post.setSummary(rs.getString("Summary"));
        post.setThumbnailUrl(rs.getString("ThumbnailUrl"));
        post.setAuthorID(rs.getInt("AuthorID"));
        post.setPublishedAt(rs.getTimestamp("PublishedAt"));
        post.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        post.setViewCount(rs.getInt("ViewCount"));

        // Get comment count
        String getCommentCountQuery = "SELECT COUNT(*) as comment_count FROM BlogComments WHERE PostID = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(getCommentCountQuery)) {
            ps.setInt(1, post.getPostID());
            try (ResultSet countRs = ps.executeQuery()) {
                if (countRs.next()) {
                    post.setCommentCount(countRs.getInt("comment_count"));
                }
            }
        }

        return post;
    }

    public int getTotalPosts(String search, Integer tagId) {
        int total = 0;
        try {
            StringBuilder query = new StringBuilder("SELECT COUNT(DISTINCT p.PostID) as total FROM BlogPosts p");
            List<Object> params = new ArrayList<>();

            if (tagId != null) {
                query.append(" JOIN BlogPostTags pt ON p.PostID = pt.PostID");
            }

            query.append(" WHERE 1=1");

            if (search != null && !search.isEmpty()) {
                query.append(" AND (p.Title LIKE ? OR p.Content LIKE ? OR p.Summary LIKE ?)");
                String searchPattern = "%" + search + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }

            if (tagId != null) {
                query.append(" AND pt.TagID = ?");
                params.add(tagId);
            }

            try (Connection conn = DBUtils.getConnection();
                    PreparedStatement ps = conn.prepareStatement(query.toString())) {

                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // public List<BlogPostDTO> getPostsByPage(int page, int itemsPerPage, String
    // search, Integer tagId) {
    // List<BlogPostDTO> posts = new ArrayList<>();
    // try {
    // StringBuilder query = new StringBuilder(
    // "SELECT DISTINCT p.* FROM BlogPosts p"
    // );

    // List<Object> params = new ArrayList<>();

    // if (tagId != null) {
    // query.append(" JOIN BlogPostTags pt ON p.PostID = pt.PostID");
    // }

    // query.append(" WHERE 1=1");

    // if (search != null && !search.isEmpty()) {
    // query.append(" AND (p.Title LIKE ? OR p.Content LIKE ? OR p.Summary LIKE
    // ?)");
    // String searchPattern = "%" + search + "%";
    // params.add(searchPattern);
    // params.add(searchPattern);
    // params.add(searchPattern);
    // }

    // if (tagId != null) {
    // query.append(" AND pt.TagID = ?");
    // params.add(tagId);
    // }

    // query.append(" ORDER BY p.PublishedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS
    // ONLY");
    // params.add(itemsPerPage);
    // params.add((page - 1) * itemsPerPage);

    // try (Connection conn = DBUtils.getConnection(); PreparedStatement ps =
    // conn.prepareStatement(query.toString())) {

    // for (int i = 0; i < params.size(); i++) {
    // ps.setObject(i + 1, params.get(i));
    // }

    // try (ResultSet rs = ps.executeQuery()) {
    // while (rs.next()) {
    // posts.add(mapResultSetToPost(rs));
    // }
    // }
    // }
    // } catch (Exception e) {
    // e.printStackTrace();
    // }
    // return posts;
    // }

    public int countPosts(String search) {
        String sql = "SELECT COUNT(*) FROM BlogPosts WHERE Title LIKE ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + (search == null ? "" : search) + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<BlogPostDTO> getPostsByPage(int page, int size, String search, String sort) {
        List<BlogPostDTO> posts = new ArrayList<>();
        String orderClause = "ORDER BY PublishedAt DESC";
        if ("views".equals(sort)) {
            orderClause = "ORDER BY ViewCount DESC";
        }

        String sql = "SELECT * FROM BlogPosts WHERE Title LIKE ? " + orderClause
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + (search == null ? "" : search) + "%");
            ps.setInt(2, (page - 1) * size);
            ps.setInt(3, size);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                posts.add(mapResultSetToPost(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }

    public BlogPostDTO getPreviousPost(int currentPostId) {
        String sql = "SELECT TOP 1 * FROM BlogPosts WHERE PostID < ? ORDER BY PostID DESC";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentPostId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPost(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public BlogPostDTO getNextPost(int currentPostId) {
        String sql = "SELECT TOP 1 * FROM BlogPosts WHERE PostID > ? ORDER BY PostID ASC";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentPostId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPost(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
