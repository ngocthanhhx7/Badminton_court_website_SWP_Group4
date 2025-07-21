package dao;

import models.CourtDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CourtDAO {
    
    public List<CourtDTO> getCourtsByIds(List<Integer> courtIds) {
        List<CourtDTO> courts = new ArrayList<>();
        if (courtIds == null || courtIds.isEmpty()) {
            return courts; // Trả về danh sách rỗng nếu không có ID nào
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM Courts WHERE CourtID IN (");
        for (int i = 0; i < courtIds.size(); i++) {
            sql.append("?");
            if (i < courtIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(")");
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < courtIds.size(); i++) {
                preparedStatement.setInt(i + 1, courtIds.get(i));
            }
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                courts.add(mapResultSetToCourt(resultSet));
            }
        } catch (Exception e) {
            System.err.println("Error getting courts by IDs: " + e.getMessage());
            e.printStackTrace();
        }

        return courts;
    }

    public List<CourtDTO> getAllCourts() {
        String sql = "SELECT * FROM Courts ORDER BY CourtID DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();

            while (resultSet.next()) {
                CourtDTO court = mapResultSetToCourt(resultSet);
                courts.add(court);
            }

            return courts;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public CourtDTO getCourtById(Integer courtId) {
        if (courtId == null) {
            return null;
        }
        
        String sql = "SELECT * FROM Courts WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, courtId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToCourt(resultSet);
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean addCourt(CourtDTO court) {
        if (court == null || court.getCourtName() == null || court.getCourtName().trim().isEmpty()) {
            return false;
        }
        String status = court.getStatus();
        if (status == null || !(status.equals("Available") || status.equals("Unavailable") || status.equals("Maintenance"))) {
            status = "Available";
        }
        String sql = "INSERT INTO Courts (CourtName, Description, CourtType, Status, CourtImage, CreatedBy, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, court.getCourtName().trim());
            preparedStatement.setString(2, court.getDescription() != null ? court.getDescription().trim() : null);
            preparedStatement.setString(3, court.getCourtType() != null ? court.getCourtType().trim() : "Single");
            preparedStatement.setString(4, status);
            preparedStatement.setString(5, court.getCourtImage() != null ? court.getCourtImage().trim() : null);
            preparedStatement.setInt(6, court.getCreatedBy() != null ? court.getCreatedBy() : 1);
            int result = preparedStatement.executeUpdate();
            System.out.println("Add court result: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error adding court: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCourt(CourtDTO court) {
        if (court == null || court.getCourtId() == null || court.getCourtName() == null || court.getCourtName().trim().isEmpty()) {
            return false;
        }
        String status = court.getStatus();
        if (status == null || !(status.equals("Available") || status.equals("Unavailable") || status.equals("Maintenance"))) {
            status = "Available";
        }
        String sql = "UPDATE Courts SET CourtName = ?, Description = ?, CourtType = ?, Status = ?, CourtImage = ?, UpdatedAt = GETDATE() WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, court.getCourtName().trim());
            preparedStatement.setString(2, court.getDescription() != null ? court.getDescription().trim() : null);
            preparedStatement.setString(3, court.getCourtType() != null ? court.getCourtType().trim() : "Single");
            preparedStatement.setString(4, status);
            preparedStatement.setString(5, court.getCourtImage() != null ? court.getCourtImage().trim() : null);
            preparedStatement.setInt(6, court.getCourtId());
            int result = preparedStatement.executeUpdate();
            System.out.println("Update court result: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error updating court: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCourt(Integer courtId) {
        if (courtId == null) {
            return false;
        }
        
        String sql = "DELETE FROM Courts WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, courtId);
            int result = preparedStatement.executeUpdate();
            System.out.println("Delete court result: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error deleting court: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleCourtStatus(Integer courtId) {
        if (courtId == null) {
            return false;
        }
        // Toggle Available <-> Unavailable
        String sql = "UPDATE Courts SET Status = CASE WHEN Status = 'Available' THEN 'Unavailable' ELSE 'Available' END, UpdatedAt = GETDATE() WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, courtId);
            int result = preparedStatement.executeUpdate();
            System.out.println("Toggle status result: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println("Error toggling court status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<CourtDTO> searchCourtsByNameOrTypeOrStatus(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllCourts();
        }
        
        String sql = "SELECT * FROM Courts WHERE CourtName LIKE ? OR CourtType LIKE ? OR Status LIKE ? ORDER BY CourtID DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            String searchTerm = "%" + keyword.trim() + "%";
            preparedStatement.setString(1, searchTerm);
            preparedStatement.setString(2, searchTerm);
            preparedStatement.setString(3, searchTerm);

            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();

            while (resultSet.next()) {
                CourtDTO court = mapResultSetToCourt(resultSet);
                courts.add(court);
            }

            return courts;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<CourtDTO> filterCourts(String search, String status, String courtType) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Courts WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (CourtName LIKE ? OR Description LIKE ?)");
            parameters.add("%" + search.trim() + "%");
            parameters.add("%" + search.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            parameters.add(status.trim());
        }
        if (courtType != null && !courtType.trim().isEmpty()) {
            sql.append(" AND CourtType = ?");
            parameters.add(courtType.trim());
        }

        sql.append(" ORDER BY CourtID DESC");

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                preparedStatement.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = preparedStatement.executeQuery();
            List<CourtDTO> filteredCourts = new ArrayList<>();
            
            while (rs.next()) {
                CourtDTO court = mapResultSetToCourt(rs);
                filteredCourts.add(court);
            }
            
            return filteredCourts;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<CourtDTO> getCourtsWithFilters(String status, String courtType, String searchName, String sortBy, String sortOrder, int page, int pageSize) {
        // Validate and sanitize parameters
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (pageSize > 100) pageSize = 100;
        
        // Validate sortBy to prevent SQL injection
        String[] allowedSortFields = {"CourtID", "CourtName", "CourtType", "Status", "CreatedAt"};
        boolean isValidSortField = false;
        for (String field : allowedSortFields) {
            if (field.equals(sortBy)) {
                isValidSortField = true;
                break;
            }
        }
        if (!isValidSortField) {
            sortBy = "CourtID";
        }
        
        // Validate sortOrder
        if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
            sortOrder = "DESC";
        }
        
        StringBuilder sql = new StringBuilder("SELECT * FROM Courts WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        // Add filters
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            parameters.add(status.trim());
        }
        
        if (courtType != null && !courtType.trim().isEmpty()) {
            sql.append(" AND CourtType = ?");
            parameters.add(courtType.trim());
        }
        
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND (CourtName LIKE ? OR Description LIKE ?)");
            parameters.add("%" + searchName.trim() + "%");
            parameters.add("%" + searchName.trim() + "%");
        }
        
        // Add sorting
        sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortOrder);
        
        // Add pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                preparedStatement.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();
            
            while (resultSet.next()) {
                CourtDTO court = mapResultSetToCourt(resultSet);
                courts.add(court);
            }
            
            return courts;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public int getFilteredCourtsCount(String status, String courtType, String searchName) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Courts WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        // Add filters
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            parameters.add(status.trim());
        }
        
        if (courtType != null && !courtType.trim().isEmpty()) {
            sql.append(" AND CourtType = ?");
            parameters.add(courtType.trim());
        }
        
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND (CourtName LIKE ? OR Description LIKE ?)");
            parameters.add("%" + searchName.trim() + "%");
            parameters.add("%" + searchName.trim() + "%");
        }
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                preparedStatement.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            
            return 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<CourtDTO> getSimilarCourts(Integer excludeCourtId, int limit) {
        if (excludeCourtId == null || limit <= 0) {
            return new ArrayList<>();
        }
        String sql = "SELECT TOP (?) * FROM Courts WHERE CourtID <> ? AND Status = 'Available' ORDER BY NEWID()";
        List<CourtDTO> similarCourts = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, limit);
            preparedStatement.setInt(2, excludeCourtId);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                CourtDTO court = mapResultSetToCourt(resultSet);
                similarCourts.add(court);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return similarCourts;
    }
    
    public List<CourtDTO> getActiveCourts() {
        String sql = "SELECT * FROM Courts WHERE Status = 'Available' ORDER BY CourtID DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();
            while (resultSet.next()) {
                CourtDTO court = mapResultSetToCourt(resultSet);
                courts.add(court);
            }
            return courts;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<CourtDTO> getCourtsByType(String courtType) {
        if (courtType == null || courtType.trim().isEmpty()) {
            return new ArrayList<>();
        }
        
        String sql = "SELECT * FROM Courts WHERE CourtType = ? AND Status = 'Available' ORDER BY CourtID DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, courtType.trim());
            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();

            while (resultSet.next()) {
                CourtDTO court = mapResultSetToCourt(resultSet);
                courts.add(court);
            }

            return courts;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public boolean isCourtExists(String courtName) {
        if (courtName == null || courtName.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM Courts WHERE CourtName = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, courtName.trim());
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean isCourtExists(Integer courtId) {
        if (courtId == null) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM Courts WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, courtId);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Helper method to map ResultSet to CourtDTO
    private CourtDTO mapResultSetToCourt(ResultSet rs) throws Exception {
        CourtDTO courtDto =  CourtDTO.builder()
                .courtId(rs.getInt("CourtID"))
                .courtName(rs.getString("CourtName"))
                .description(rs.getString("Description"))
                .courtType(rs.getString("CourtType"))
                .status(rs.getString("Status"))
                .createdBy(rs.getInt("CreatedBy"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .updatedAt(rs.getTimestamp("UpdatedAt"))
                .courtImage(rs.getString("CourtImage"))
                .build();
        return courtDto;
    }
    
    // Helper method to check and create table if needed
    public boolean checkAndCreateTable() {
        String createTableSQL = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courts' AND xtype='U') " +
            "CREATE TABLE Courts (" +
            "CourtID INT IDENTITY(1,1) PRIMARY KEY, " +
            "CourtName NVARCHAR(255) NOT NULL, " +
            "Description NVARCHAR(MAX), " +
            "CourtType NVARCHAR(50) NOT NULL DEFAULT 'Single', " +
            "Status NVARCHAR(50) NOT NULL DEFAULT 'Available', " +
            "CourtImage NVARCHAR(500), " +
            "CreatedBy INT NOT NULL DEFAULT 1, " +
            "CreatedAt DATETIME NOT NULL DEFAULT GETDATE(), " +
            "UpdatedAt DATETIME NOT NULL DEFAULT GETDATE() " +
            ")";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(createTableSQL)) {
            
            preparedStatement.execute();
            System.out.println("Table Courts checked/created successfully");
            return true;
        } catch (Exception e) {
            System.err.println("Error checking/creating table: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Test method
    public static void main(String[] args) {
        CourtDAO courtDAO = new CourtDAO();
        
//        System.out.println("\n=== Check/Create Table ===");
//        courtDAO.checkAndCreateTable();
//        
//        System.out.println("\n=== Test Database Connection ===");
//        try (Connection connection = DBUtils.getConnection()) {
//            System.out.println("Database connection successful!");
//            
//            // Test table structure
//            String checkTableSql = "SELECT TOP 1 * FROM Courts";
//            try (PreparedStatement stmt = connection.prepareStatement(checkTableSql)) {
//                ResultSet rs = stmt.executeQuery();
//                if (rs.next()) {
//                    System.out.println("Table Courts exists and has data");
//                    System.out.println("Columns: " + rs.getMetaData().getColumnCount());
//                    for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
//                        System.out.println("Column " + i + ": " + rs.getMetaData().getColumnName(i) + " (" + rs.getMetaData().getColumnTypeName(i) + ")");
//                    }
//                } else {
//                    System.out.println("Table Courts exists but is empty");
//                }
//            }
//        } catch (Exception e) {
//            System.err.println("Database connection failed: " + e.getMessage());
//            e.printStackTrace();
//        }
//        
//        System.out.println("\n=== Test getAllCourts ===");
//        try {
//            List<CourtDTO> courts = courtDAO.getAllCourts();
//            System.out.println("Total courts: " + courts.size());
//            for (CourtDTO c : courts) {
//                System.out.println(c.getCourtId() + " - " + c.getCourtName() + " - " + c.getCourtType() + " - " + c.getStatus());
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
        
//        System.out.println("\n=== Test getActiveCourts ===");
//        try {
//            List<CourtDTO> activeCourts = courtDAO.getActiveCourts();
//            System.out.println("Active courts: " + activeCourts.size());
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
        
        System.out.println("\n=== Test Add Court ===");
        try {
            CourtDTO newCourt = CourtDTO.builder()
                    .courtName("Test Court")
                    .description("Test Description")
                    .courtType("Single")
                    .status("Available")
                    .createdBy(1)
                    .build();
            
            boolean addResult = courtDAO.addCourt(newCourt);
            System.out.println("Add court result: " + addResult);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
