package dao;

import models.SliderDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SliderDAO {

    private static final String GET_ALL_SLIDERS = "SELECT * FROM Sliders ORDER BY SliderID DESC";
    private static final String GET_ACTIVE_SLIDERS = "SELECT * FROM Sliders WHERE IsActive = 1 ORDER BY Position ASC";
    private static final String GET_SLIDER_BY_ID = "SELECT * FROM Sliders WHERE SliderID = ?";
    private static final String ADD_SLIDER = "INSERT INTO Sliders (Title, Subtitle, BackgroundImage, Position, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_SLIDER = "UPDATE Sliders SET Title = ?, Subtitle = ?, BackgroundImage = ?, Position = ? WHERE SliderID = ?";
    private static final String DELETE_SLIDER = "DELETE FROM Sliders WHERE SliderID = ?";
    private static final String TOGGLE_STATUS = "UPDATE Sliders SET IsActive = ~IsActive WHERE SliderID = ?";
    
    // Updated queries for SQL Server pagination, filtering, and search
    private static final String COUNT_ALL_SLIDERS = "SELECT COUNT(*) FROM Sliders";
    private static final String COUNT_FILTERED_SLIDERS = "SELECT COUNT(*) FROM Sliders WHERE (? IS NULL OR IsActive = ?) AND (? IS NULL OR Title LIKE ?)";
    private static final String GET_SLIDERS_WITH_FILTERS = "SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY %s) AS RowNum, * FROM Sliders WHERE (? IS NULL OR IsActive = ?) AND (? IS NULL OR Title LIKE ?)) AS PagedResults WHERE RowNum BETWEEN ? AND ?";

    public List<SliderDTO> getAllSliders() throws SQLException {
        List<SliderDTO> sliders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_ALL_SLIDERS);
            rs = ptm.executeQuery();
            while (rs.next()) {
                sliders.add(mapResultSetToSlider(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return sliders;
    }

    public SliderDTO getSliderById(int sliderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_SLIDER_BY_ID);
            ptm.setInt(1, sliderId);
            rs = ptm.executeQuery();
            if (rs.next()) {
                return mapResultSetToSlider(rs);
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return null;
    }

    public boolean addSlider(SliderDTO slider) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(ADD_SLIDER);
            ptm.setString(1, slider.getTitle());
            ptm.setString(2, slider.getSubtitle());
            ptm.setString(3, slider.getBackgroundImage());
            ptm.setInt(4, slider.getPosition());
            ptm.setBoolean(5, slider.getIsActive());
            ptm.setTimestamp(6, slider.getCreatedAt());
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean updateSlider(SliderDTO slider) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(UPDATE_SLIDER);
            ptm.setString(1, slider.getTitle());
            ptm.setString(2, slider.getSubtitle());
            ptm.setString(3, slider.getBackgroundImage());
            ptm.setInt(4, slider.getPosition());
            ptm.setInt(5, slider.getSliderID());
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean deleteSlider(int sliderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(DELETE_SLIDER);
            ptm.setInt(1, sliderId);
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean toggleSliderStatus(int sliderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(TOGGLE_STATUS);
            ptm.setInt(1, sliderId);
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    // Updated methods for SQL Server pagination, filtering, and search
    
    public int getTotalSliders() throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(COUNT_ALL_SLIDERS);
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
    
    public int getFilteredSlidersCount(Boolean isActive, String searchTitle) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(COUNT_FILTERED_SLIDERS);
            ptm.setObject(1, isActive);
            ptm.setObject(2, isActive);
            ptm.setObject(3, searchTitle);
            ptm.setObject(4, searchTitle != null ? "%" + searchTitle + "%" : null);
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
    
    public List<SliderDTO> getSlidersWithFilters(Boolean isActive, String searchTitle, String sortBy, String sortOrder, int page, int pageSize) throws SQLException {
        List<SliderDTO> sliders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.getConnection();
            
            // Validate and set sort parameters
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "SliderID";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedSortFields = {"SliderID", "Title", "Position", "IsActive", "CreatedAt"};
            boolean isValidSortField = false;
            for (String field : allowedSortFields) {
                if (field.equals(sortBy)) {
                    isValidSortField = true;
                    break;
                }
            }
            if (!isValidSortField) {
                sortBy = "SliderID";
            }
            
            // Validate sortOrder
            if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
                sortOrder = "DESC";
            }
            
            // Calculate row numbers for SQL Server pagination
            int startRow = (page - 1) * pageSize + 1;
            int endRow = page * pageSize;
            
            String query = String.format(GET_SLIDERS_WITH_FILTERS, sortBy + " " + sortOrder);
            ptm = conn.prepareStatement(query);
            
            int paramIndex = 1;
            ptm.setObject(paramIndex++, isActive);
            ptm.setObject(paramIndex++, isActive);
            ptm.setObject(paramIndex++, searchTitle);
            ptm.setObject(paramIndex++, searchTitle != null ? "%" + searchTitle + "%" : null);
            ptm.setInt(paramIndex++, startRow);
            ptm.setInt(paramIndex++, endRow);
            
            rs = ptm.executeQuery();
            while (rs.next()) {
                sliders.add(mapResultSetToSlider(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return sliders;
    }
    
    private SliderDTO mapResultSetToSlider(ResultSet rs) throws SQLException {
        return SliderDTO.builder()
                .SliderID(rs.getInt("SliderID"))
                .Title(rs.getString("Title"))
                .Subtitle(rs.getString("Subtitle"))
                .BackgroundImage(rs.getString("BackgroundImage"))
                .Position(rs.getInt("Position"))
                .IsActive(rs.getBoolean("IsActive"))
                .CreatedAt(rs.getTimestamp("CreatedAt"))
                .build();
    }

    public List<SliderDTO> searchSliders(String keyword) {
        String sql = "SELECT * FROM Sliders WHERE Title LIKE ? OR Subtitle LIKE ?";
        try (Connection connection = DBUtils.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, "%" + keyword + "%");
            preparedStatement.setString(2, "%" + keyword + "%");

            ResultSet resultSet = preparedStatement.executeQuery();
            List<SliderDTO> sliders = new ArrayList<>();

            while (resultSet.next()) {
                SliderDTO slider = SliderDTO.builder()
                        .SliderID(resultSet.getInt("SliderID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .BackgroundImage(resultSet.getString("BackgroundImage"))
                        .Position(resultSet.getInt("Position"))
                        .IsActive(resultSet.getBoolean("IsActive"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                sliders.add(slider);
            }

            return sliders;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<SliderDTO> getAllActiveSliders() {
        String sql = "SELECT * FROM Sliders WHERE IsActive = 1 ORDER BY Position ASC";
        List<SliderDTO> sliders = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SliderDTO slider = SliderDTO.builder()
                        .SliderID(rs.getInt("SliderID"))
                        .Title(rs.getString("Title"))
                        .Subtitle(rs.getString("Subtitle"))
                        .BackgroundImage(rs.getString("BackgroundImage"))
                        .Position(rs.getInt("Position"))
                        .IsActive(rs.getBoolean("IsActive"))
                        .CreatedAt(rs.getTimestamp("CreatedAt"))
                        .build();
                sliders.add(slider);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return sliders;
    }

    public static void main(String[] args) {
        SliderDAO dao = new SliderDAO();
        try {
            List<SliderDTO> list = dao.getAllSliders();
            if (list != null) {
                list.forEach(System.out::println);
            } else {
                System.out.println("No sliders found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
