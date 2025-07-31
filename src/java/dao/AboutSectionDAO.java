package dao;

import models.AboutSectionDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AboutSectionDAO {

    private static final String GET_ALL_SECTIONS = "SELECT * FROM AboutSections ORDER BY AboutID DESC";
    private static final String GET_ACTIVE_SECTIONS = "SELECT * FROM AboutSections WHERE IsActive = 1 ORDER BY AboutID ASC";
    private static final String GET_SECTION_BY_ID = "SELECT * FROM AboutSections WHERE AboutID = ?";
    private static final String ADD_SECTION = "INSERT INTO AboutSections (Title, Subtitle, Content, Image1, Image2, SectionType, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SECTION = "UPDATE AboutSections SET Title = ?, Subtitle = ?, Content = ?, Image1 = ?, Image2 = ?, SectionType = ?, IsActive = ? WHERE AboutID = ?";
    private static final String DELETE_SECTION = "DELETE FROM AboutSections WHERE AboutID = ?";
    private static final String TOGGLE_STATUS = "UPDATE AboutSections SET IsActive = ~IsActive WHERE AboutID = ?";
    
    // Queries for pagination, filtering, and search (SQL Server)
    private static final String COUNT_ALL_SECTIONS = "SELECT COUNT(*) FROM AboutSections";
    private static final String COUNT_FILTERED_SECTIONS = "SELECT COUNT(*) FROM AboutSections WHERE (? IS NULL OR IsActive = ?) AND (? IS NULL OR Title LIKE ?) AND (? IS NULL OR SectionType = ?)";
    private static final String GET_SECTIONS_WITH_FILTERS = "SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY %s) AS RowNum, * FROM AboutSections WHERE (? IS NULL OR IsActive = ?) AND (? IS NULL OR Title LIKE ?) AND (? IS NULL OR SectionType = ?)) AS PagedResults WHERE RowNum BETWEEN ? AND ?";

    public List<AboutSectionDTO> getAllSections() throws SQLException {
        List<AboutSectionDTO> sections = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_ALL_SECTIONS);
            rs = ptm.executeQuery();
            while (rs.next()) {
                sections.add(mapResultSetToSection(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return sections;
    }

    public List<AboutSectionDTO> getAllActiveSections() throws SQLException {
        List<AboutSectionDTO> sections = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_ACTIVE_SECTIONS);
            rs = ptm.executeQuery();
            while (rs.next()) {
                sections.add(mapResultSetToSection(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return sections;
    }

    public AboutSectionDTO getSectionById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_SECTION_BY_ID);
            ptm.setInt(1, id);
            rs = ptm.executeQuery();
            if (rs.next()) {
                return mapResultSetToSection(rs);
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return null;
    }

    public boolean addSection(AboutSectionDTO section) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(ADD_SECTION);
            ptm.setString(1, section.getTitle());
            ptm.setString(2, section.getSubtitle());
            ptm.setString(3, section.getContent());
            ptm.setString(4, section.getImage1());
            ptm.setString(5, section.getImage2());
            ptm.setString(6, section.getSectionType());
            ptm.setBoolean(7, section.getIsActive());
            ptm.setTimestamp(8, section.getCreatedAt());
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean updateSection(AboutSectionDTO section) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(UPDATE_SECTION);
            ptm.setString(1, section.getTitle());
            ptm.setString(2, section.getSubtitle());
            ptm.setString(3, section.getContent());
            ptm.setString(4, section.getImage1());
            ptm.setString(5, section.getImage2());
            ptm.setString(6, section.getSectionType());
            ptm.setBoolean(7, section.getIsActive());
            ptm.setInt(8, section.getAboutID());
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean deleteSection(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(DELETE_SECTION);
            ptm.setInt(1, id);
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean toggleSectionStatus(int sectionId) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(TOGGLE_STATUS);
            ptm.setInt(1, sectionId);
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    // Methods for pagination, filtering, and search
    
    public int getTotalSections() throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(COUNT_ALL_SECTIONS);
            rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return 0;
    }
    
    public int getFilteredSectionsCount(Boolean isActive, String searchTitle, String sectionType) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(COUNT_FILTERED_SECTIONS);
            ptm.setObject(1, isActive);
            ptm.setObject(2, isActive);
            ptm.setObject(3, searchTitle);
            ptm.setObject(4, searchTitle != null ? "%" + searchTitle + "%" : null);
            ptm.setObject(5, sectionType);
            ptm.setObject(6, sectionType);
            rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return 0;
    }
    
    public List<AboutSectionDTO> getSectionsWithFilters(Boolean isActive, String searchTitle, String sectionType, String sortBy, String sortOrder, int page, int pageSize) throws SQLException {
        List<AboutSectionDTO> sections = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.getConnection();
            
            // Validate and set sort parameters
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "AboutID";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedSortFields = {"AboutID", "Title", "SectionType", "IsActive", "CreatedAt"};
            boolean isValidSortField = false;
            for (String field : allowedSortFields) {
                if (field.equals(sortBy)) {
                    isValidSortField = true;
                    break;
                }
            }
            if (!isValidSortField) {
                sortBy = "AboutID";
            }
            
            // Validate sortOrder
            if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
                sortOrder = "DESC";
            }
            
            // Calculate row numbers for SQL Server pagination
            int startRow = (page - 1) * pageSize + 1;
            int endRow = page * pageSize;
            
            String query = String.format(GET_SECTIONS_WITH_FILTERS, sortBy + " " + sortOrder);
            ptm = conn.prepareStatement(query);
            
            int paramIndex = 1;
            ptm.setObject(paramIndex++, isActive);
            ptm.setObject(paramIndex++, isActive);
            ptm.setObject(paramIndex++, searchTitle);
            ptm.setObject(paramIndex++, searchTitle != null ? "%" + searchTitle + "%" : null);
            ptm.setObject(paramIndex++, sectionType);
            ptm.setObject(paramIndex++, sectionType);
            ptm.setInt(paramIndex++, startRow);
            ptm.setInt(paramIndex++, endRow);
            
            rs = ptm.executeQuery();
            while (rs.next()) {
                sections.add(mapResultSetToSection(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return sections;
    }
    
    private AboutSectionDTO mapResultSetToSection(ResultSet rs) throws SQLException {
        return AboutSectionDTO.builder()
                .AboutID(rs.getInt("AboutID"))
                .Title(rs.getString("Title"))
                .Subtitle(rs.getString("Subtitle"))
                .Content(rs.getString("Content"))
                .Image1(rs.getString("Image1"))
                .Image2(rs.getString("Image2"))
                .SectionType(rs.getString("SectionType"))
                .IsActive(rs.getBoolean("IsActive"))
                .CreatedAt(rs.getTimestamp("CreatedAt"))
                .build();
    }

    public List<AboutSectionDTO> searchSections(String keyword) {
        String sql = "SELECT * FROM AboutSections WHERE Title LIKE ? OR Subtitle LIKE ? OR Content LIKE ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            String likePattern = "%" + keyword + "%";
            preparedStatement.setString(1, likePattern);
            preparedStatement.setString(2, likePattern);
            preparedStatement.setString(3, likePattern);

            ResultSet resultSet = preparedStatement.executeQuery();
            List<AboutSectionDTO> sections = new ArrayList<>();

            while (resultSet.next()) {
                AboutSectionDTO section = AboutSectionDTO.builder()
                        .AboutID(resultSet.getInt("AboutID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .Content(resultSet.getString("Content"))
                        .Image1(resultSet.getString("Image1"))
                        .Image2(resultSet.getString("Image2"))
                        .SectionType(resultSet.getString("SectionType"))
                        .IsActive(resultSet.getBoolean("IsActive"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                sections.add(section);
            }

            return sections;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        AboutSectionDAO dao = new AboutSectionDAO();
        try {
            List<AboutSectionDTO> list = dao.getAllSections();
            if (list != null) {
                list.forEach(System.out::println);
            } else {
                System.out.println("No sections found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
