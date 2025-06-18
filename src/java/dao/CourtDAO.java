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

    public List<CourtDTO> getAllCourts() {
        String sql = "SELECT * FROM Courts ORDER BY CourtID DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();

            while (resultSet.next()) {
                CourtDTO court = CourtDTO.builder()
                        .courtId(resultSet.getInt("CourtID"))
                        .courtName(resultSet.getString("CourtName"))
                        .description(resultSet.getString("Description"))
                        .courtType(resultSet.getString("CourtType"))
                        .status(resultSet.getString("Status"))
                        .createdBy(resultSet.getInt("CreatedBy"))
                        .createdAt(resultSet.getTimestamp("CreatedAt"))
                        .updatedAt(resultSet.getTimestamp("UpdatedAt"))
                        .courtImage(resultSet.getString("CourtImage"))
                        .build();
                courts.add(court);
            }

            return courts;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public CourtDTO getCourtById(Integer courtId) {
        String sql = "SELECT * FROM Courts WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, courtId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return CourtDTO.builder()
                        .courtId(resultSet.getInt("CourtID"))
                        .courtName(resultSet.getString("CourtName"))
                        .description(resultSet.getString("Description"))
                        .courtType(resultSet.getString("CourtType"))
                        .status(resultSet.getString("Status"))
                        .createdBy(resultSet.getInt("CreatedBy"))
                        .createdAt(resultSet.getTimestamp("CreatedAt"))
                        .updatedAt(resultSet.getTimestamp("UpdatedAt"))
                        .courtImage(resultSet.getString("CourtImage"))
                        .build();
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean addCourt(CourtDTO court) {
        String sql = "INSERT INTO Courts (CourtName, Description, CourtType, Status, CourtImage, CreatedBy, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, court.getCourtName());
            preparedStatement.setString(2, court.getDescription());
            preparedStatement.setString(3, court.getCourtType());
            preparedStatement.setString(4, court.getStatus());
            preparedStatement.setString(5, court.getCourtImage());
            preparedStatement.setInt(6, court.getCreatedBy() != null ? court.getCreatedBy() : 1);

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCourt(CourtDTO court) {
        String sql = "UPDATE Courts SET CourtName = ?, Description = ?, CourtType = ?, Status = ?, CourtImage = ?, UpdatedAt = GETDATE() WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, court.getCourtName());
            preparedStatement.setString(2, court.getDescription());
            preparedStatement.setString(3, court.getCourtType());
            preparedStatement.setString(4, court.getStatus());
            preparedStatement.setString(5, court.getCourtImage());
            preparedStatement.setInt(6, court.getCourtId());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCourt(Integer courtId) {
        String sql = "DELETE FROM Courts WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, courtId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CourtDTO> searchCourtsByNameOrTypeOrStatus(String keyword) {
        String sql = "SELECT * FROM Courts WHERE CourtName LIKE ? OR CourtType LIKE ? OR Status LIKE ? ORDER BY CourtID DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, "%" + keyword + "%");
            preparedStatement.setString(2, "%" + keyword + "%");
            preparedStatement.setString(3, "%" + keyword + "%");

            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();

            while (resultSet.next()) {
                CourtDTO court = CourtDTO.builder()
                        .courtId(resultSet.getInt("CourtID"))
                        .courtName(resultSet.getString("CourtName"))
                        .description(resultSet.getString("Description"))
                        .courtType(resultSet.getString("CourtType"))
                        .status(resultSet.getString("Status"))
                        .createdBy(resultSet.getInt("CreatedBy"))
                        .createdAt(resultSet.getTimestamp("CreatedAt"))
                        .updatedAt(resultSet.getTimestamp("UpdatedAt"))
                        .courtImage(resultSet.getString("CourtImage"))
                        .build();
                courts.add(court);
            }

            return courts;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<CourtDTO> filterCourts(String search, String status, String courtType) {
        List<CourtDTO> filteredCourts = new ArrayList<>();
        String sql = "SELECT * FROM Courts WHERE 1=1";

        if (search != null && !search.isEmpty()) {
            sql += " AND (CourtName LIKE ? OR Description LIKE ?)";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND Status = ?";
        }
        if (courtType != null && !courtType.isEmpty()) {
            sql += " AND CourtType = ?";
        }

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            int index = 1;
            if (search != null && !search.isEmpty()) {
                preparedStatement.setString(index++, "%" + search + "%");
                preparedStatement.setString(index++, "%" + search + "%");
            }
            if (status != null && !status.isEmpty()) {
                preparedStatement.setString(index++, status);
            }
            if (courtType != null && !courtType.isEmpty()) {
                preparedStatement.setString(index++, courtType);
            }

            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                CourtDTO court = CourtDTO.builder()
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
                filteredCourts.add(court);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return filteredCourts;
    }

    public List<CourtDTO> getSimilarCourts(Integer excludeCourtId, int limit) {
        String sql = "SELECT TOP (?) * FROM Courts WHERE CourtID <> ? ORDER BY NEWID()";
        List<CourtDTO> similarCourts = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, limit);
            preparedStatement.setInt(2, excludeCourtId);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                CourtDTO court = CourtDTO.builder()
                        .courtId(resultSet.getInt("CourtID"))
                        .courtName(resultSet.getString("CourtName"))
                        .description(resultSet.getString("Description"))
                        .courtType(resultSet.getString("CourtType"))
                        .status(resultSet.getString("Status"))
                        .createdBy(resultSet.getInt("CreatedBy"))
                        .createdAt(resultSet.getTimestamp("CreatedAt"))
                        .updatedAt(resultSet.getTimestamp("UpdatedAt"))
                        .courtImage(resultSet.getString("CourtImage"))
                        .build();
                similarCourts.add(court);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return similarCourts;
    }
    
    public static void main(String[] args) {
        CourtDAO courtDAO = new CourtDAO();
        System.out.println("\n=== Test getAllCourts ===");
        try {
            List<CourtDTO> courts = courtDAO.getAllCourts();
            for (CourtDTO c : courts) {
                System.out.println(c.getCourtId() + " - " + c.getCourtName() + " - " + c.getCourtType());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
