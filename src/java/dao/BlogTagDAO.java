package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.BlogTagDTO;
import utils.DBUtils;

public class BlogTagDAO {
    
    private static final String GET_ALL_TAGS = "SELECT * FROM BlogTags ORDER BY Name ASC";
    private static final String GET_TAG_BY_ID = "SELECT * FROM BlogTags WHERE TagID = ?";
    private static final String GET_TAG_BY_SLUG = "SELECT * FROM BlogTags WHERE Slug = ?";
    private static final String CREATE_TAG = "INSERT INTO BlogTags (Name, Slug, CreatedAt) VALUES (?, ?, ?)";
    private static final String UPDATE_TAG = "UPDATE BlogTags SET Name = ?, Slug = ? WHERE TagID = ?";
    private static final String DELETE_TAG = "DELETE FROM BlogTags WHERE TagID = ?";
    private static final String SEARCH_TAGS = "SELECT * FROM BlogTags WHERE Name LIKE ? OR Slug LIKE ? ORDER BY Name ASC";
    
    public List<BlogTagDTO> getAllTags() throws SQLException {
        List<BlogTagDTO> tags = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ALL_TAGS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                tags.add(mapResultSetToTag(rs));
            }
        }
        return tags;
    }
    
    public BlogTagDTO getTagById(int tagId) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_TAG_BY_ID)) {
            
            ps.setInt(1, tagId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTag(rs);
                }
            }
        }
        return null;
    }
    
    public BlogTagDTO getTagBySlug(String slug) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_TAG_BY_SLUG)) {
            
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTag(rs);
                }
            }
        }
        return null;
    }
    
    public int createTag(BlogTagDTO tag) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(CREATE_TAG, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, tag.getName());
            ps.setString(2, tag.getSlug());
            ps.setTimestamp(3, tag.getCreatedAt());
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }
    
    public boolean updateTag(BlogTagDTO tag) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_TAG)) {
            
            ps.setString(1, tag.getName());
            ps.setString(2, tag.getSlug());
            ps.setInt(3, tag.getTagID());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean deleteTag(int tagId) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_TAG)) {
            
            ps.setInt(1, tagId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<BlogTagDTO> searchTags(String keyword) throws SQLException {
        List<BlogTagDTO> tags = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(SEARCH_TAGS)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tags.add(mapResultSetToTag(rs));
                }
            }
        }
        return tags;
    }
    
    private BlogTagDTO mapResultSetToTag(ResultSet rs) throws SQLException {
        return BlogTagDTO.builder()
                .TagID(rs.getInt("TagID"))
                .Name(rs.getString("Name"))
                .Slug(rs.getString("Slug"))
                .CreatedAt(rs.getTimestamp("CreatedAt"))
                .build();
    }
} 