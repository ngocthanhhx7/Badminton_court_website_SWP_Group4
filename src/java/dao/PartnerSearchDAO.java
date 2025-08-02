package dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import models.PartnerSearchPostDTO;
import models.PartnerSearchResponseDTO;
import utils.DBUtils;

public class PartnerSearchDAO {

    public List<PartnerSearchPostDTO> getAllActivePosts() {
        List<PartnerSearchPostDTO> posts = new ArrayList<>();
        String sql = """
            SELECT p.*, u.FullName, u.SportLevel, u.Gender,
                   (SELECT COUNT(*) FROM PartnerSearchResponses r WHERE r.PostID = p.PostID) as ResponseCount
            FROM PartnerSearchPosts p
            JOIN Users u ON p.UserID = u.UserID
            WHERE p.Status = 'Active' AND (p.ExpiresAt IS NULL OR p.ExpiresAt > GETDATE())
            ORDER BY p.CreatedAt DESC
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PartnerSearchPostDTO post = mapResultSetToPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    public List<PartnerSearchPostDTO> searchPosts(String location, String skillLevel, 
                                                 String playStyle, Integer maxDistance) {
        List<PartnerSearchPostDTO> posts = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT p.*, u.FullName, u.SportLevel, u.Gender,
                   (SELECT COUNT(*) FROM PartnerSearchResponses r WHERE r.PostID = p.PostID) as ResponseCount
            FROM PartnerSearchPosts p
            JOIN Users u ON p.UserID = u.UserID
            WHERE p.Status = 'Active' AND (p.ExpiresAt IS NULL OR p.ExpiresAt > GETDATE())
        """);

        List<Object> params = new ArrayList<>();

        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND p.PreferredLocation LIKE ?");
            params.add("%" + location + "%");
        }

        if (skillLevel != null && !skillLevel.trim().isEmpty()) {
            sql.append(" AND p.SkillLevel = ?");
            params.add(skillLevel);
        }

        if (playStyle != null && !playStyle.trim().isEmpty()) {
            sql.append(" AND p.PlayStyle = ?");
            params.add(playStyle);
        }

        if (maxDistance != null && maxDistance > 0) {
            sql.append(" AND (p.MaxDistance IS NULL OR p.MaxDistance <= ?)");
            params.add(maxDistance);
        }

        sql.append(" ORDER BY p.CreatedAt DESC");

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PartnerSearchPostDTO post = mapResultSetToPost(rs);
                    posts.add(post);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    public PartnerSearchPostDTO getPostById(int postId) {
        String sql = """
            SELECT p.*, u.FullName, u.SportLevel, u.Gender,
                   (SELECT COUNT(*) FROM PartnerSearchResponses r WHERE r.PostID = p.PostID) as ResponseCount
            FROM PartnerSearchPosts p
            JOIN Users u ON p.UserID = u.UserID
            WHERE p.PostID = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPost(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PartnerSearchPostDTO> getPostsByUser(int userId) {
        List<PartnerSearchPostDTO> posts = new ArrayList<>();
        String sql = """
            SELECT p.*, u.FullName, u.SportLevel, u.Gender,
                   (SELECT COUNT(*) FROM PartnerSearchResponses r WHERE r.PostID = p.PostID) as ResponseCount
            FROM PartnerSearchPosts p
            JOIN Users u ON p.UserID = u.UserID
            WHERE p.UserID = ?
            ORDER BY p.CreatedAt DESC
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PartnerSearchPostDTO post = mapResultSetToPost(rs);
                    posts.add(post);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    public List<PartnerSearchPostDTO> getActivePostsByUser(int userId) {
        List<PartnerSearchPostDTO> posts = new ArrayList<>();
        String sql = """
            SELECT p.*, u.FullName, u.SportLevel, u.Gender,
                   (SELECT COUNT(*) FROM PartnerSearchResponses r WHERE r.PostID = p.PostID) as ResponseCount
            FROM PartnerSearchPosts p
            JOIN Users u ON p.UserID = u.UserID
            WHERE p.UserID = ? AND p.Status = 'Active' AND (p.ExpiresAt IS NULL OR p.ExpiresAt > GETDATE())
            ORDER BY p.CreatedAt DESC
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PartnerSearchPostDTO post = mapResultSetToPost(rs);
                    posts.add(post);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    public boolean createPost(PartnerSearchPostDTO post) {
        String sql = """
            INSERT INTO PartnerSearchPosts 
            (UserID, Title, Description, PreferredLocation, MaxDistance, PreferredDateTime, 
             SkillLevel, PlayStyle, ContactMethod, ContactInfo, ExpiresAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, post.getUserID());
            ps.setString(2, post.getTitle());
            ps.setString(3, post.getDescription());
            ps.setString(4, post.getPreferredLocation());
            if (post.getMaxDistance() != null) {
                ps.setInt(5, post.getMaxDistance());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            if (post.getPreferredDateTime() != null) {
                ps.setTimestamp(6, Timestamp.valueOf(post.getPreferredDateTime()));
            } else {
                ps.setNull(6, Types.TIMESTAMP);
            }
            ps.setString(7, post.getSkillLevel());
            ps.setString(8, post.getPlayStyle());
            ps.setString(9, post.getContactMethod());
            ps.setString(10, post.getContactInfo());
            if (post.getExpiresAt() != null) {
                ps.setTimestamp(11, Timestamp.valueOf(post.getExpiresAt()));
            } else {
                ps.setNull(11, Types.TIMESTAMP);
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePost(PartnerSearchPostDTO post) {
        String sql = """
            UPDATE PartnerSearchPosts 
            SET Title = ?, Description = ?, PreferredLocation = ?, MaxDistance = ?, 
                PreferredDateTime = ?, SkillLevel = ?, PlayStyle = ?, ContactMethod = ?, 
                ContactInfo = ?, Status = ?, UpdatedAt = GETDATE(), ExpiresAt = ?
            WHERE PostID = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, post.getTitle());
            ps.setString(2, post.getDescription());
            ps.setString(3, post.getPreferredLocation());
            if (post.getMaxDistance() != null) {
                ps.setInt(4, post.getMaxDistance());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (post.getPreferredDateTime() != null) {
                ps.setTimestamp(5, Timestamp.valueOf(post.getPreferredDateTime()));
            } else {
                ps.setNull(5, Types.TIMESTAMP);
            }
            ps.setString(6, post.getSkillLevel());
            ps.setString(7, post.getPlayStyle());
            ps.setString(8, post.getContactMethod());
            ps.setString(9, post.getContactInfo());
            ps.setString(10, post.getStatus());
            if (post.getExpiresAt() != null) {
                ps.setTimestamp(11, Timestamp.valueOf(post.getExpiresAt()));
            } else {
                ps.setNull(11, Types.TIMESTAMP);
            }
            ps.setInt(12, post.getPostID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean incrementViewCount(int postId) {
        String sql = "UPDATE PartnerSearchPosts SET ViewCount = ViewCount + 1 WHERE PostID = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addResponse(PartnerSearchResponseDTO response) {
        String sql = """
            INSERT INTO PartnerSearchResponses (PostID, ResponderID, Message)
            VALUES (?, ?, ?)
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, response.getPostID());
            ps.setInt(2, response.getResponderID());
            ps.setString(3, response.getMessage());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<PartnerSearchResponseDTO> getResponsesByPost(int postId) {
        List<PartnerSearchResponseDTO> responses = new ArrayList<>();
        String sql = """
            SELECT r.*, u.FullName, u.SportLevel, u.Phone, u.Gender
            FROM PartnerSearchResponses r
            JOIN Users u ON r.ResponderID = u.UserID
            WHERE r.PostID = ?
            ORDER BY r.CreatedAt DESC
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PartnerSearchResponseDTO response = new PartnerSearchResponseDTO();
                    response.setResponseID(rs.getInt("ResponseID"));
                    response.setPostID(rs.getInt("PostID"));
                    response.setResponderID(rs.getInt("ResponderID"));
                    response.setMessage(rs.getString("Message"));
                    response.setStatus(rs.getString("Status"));
                    response.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    response.setResponderName(rs.getString("FullName"));
                    response.setResponderSportLevel(rs.getString("SportLevel"));
                    response.setResponderPhone(rs.getString("Phone"));
                    response.setResponderGender(rs.getString("Gender"));
                    responses.add(response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return responses;
    }

    private PartnerSearchPostDTO mapResultSetToPost(ResultSet rs) throws SQLException {
        PartnerSearchPostDTO post = new PartnerSearchPostDTO();
        post.setPostID(rs.getInt("PostID"));
        post.setUserID(rs.getInt("UserID"));
        post.setTitle(rs.getString("Title"));
        post.setDescription(rs.getString("Description"));
        post.setPreferredLocation(rs.getString("PreferredLocation"));
        
        // Handle MaxDistance safely
        int maxDistance = rs.getInt("MaxDistance");
        if (rs.wasNull()) {
            post.setMaxDistance(null);
        } else {
            post.setMaxDistance(maxDistance);
        }
        
        Timestamp preferredDateTime = rs.getTimestamp("PreferredDateTime");
        if (preferredDateTime != null) {
            post.setPreferredDateTime(preferredDateTime.toLocalDateTime());
        }
        
        post.setSkillLevel(rs.getString("SkillLevel"));
        post.setPlayStyle(rs.getString("PlayStyle"));
        post.setContactMethod(rs.getString("ContactMethod"));
        post.setContactInfo(rs.getString("ContactInfo"));
        post.setStatus(rs.getString("Status"));
        post.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        post.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
        
        Timestamp expiresAt = rs.getTimestamp("ExpiresAt");
        if (expiresAt != null) {
            post.setExpiresAt(expiresAt.toLocalDateTime());
        }
        
        post.setViewCount(rs.getInt("ViewCount"));
        post.setAuthorName(rs.getString("FullName"));
        post.setAuthorSportLevel(rs.getString("SportLevel"));
        post.setAuthorGender(rs.getString("Gender"));
        post.setResponseCount(rs.getInt("ResponseCount"));
        
        return post;
    }

    public boolean updatePostStatus(int postId, String status, int userId) {
        String sql = "UPDATE PartnerSearchPosts SET Status = ?, UpdatedAt = GETDATE() WHERE PostID = ? AND UserID = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, postId);
            ps.setInt(3, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePost(int postId, int userId) {
        // First delete responses, then delete the post
        String deleteResponsesSql = "DELETE FROM PartnerSearchResponses WHERE PostID = ?";
        String deletePostSql = "DELETE FROM PartnerSearchPosts WHERE PostID = ? AND UserID = ?";
        
        try (Connection conn = DBUtils.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps1 = conn.prepareStatement(deleteResponsesSql);
                 PreparedStatement ps2 = conn.prepareStatement(deletePostSql)) {
                
                // Delete responses first
                ps1.setInt(1, postId);
                ps1.executeUpdate();
                
                // Delete the post
                ps2.setInt(1, postId);
                ps2.setInt(2, userId);
                int result = ps2.executeUpdate();
                
                conn.commit();
                return result > 0;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
