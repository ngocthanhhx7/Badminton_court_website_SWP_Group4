package dao;

import models.CourtDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
                        .courtId(resultSet.getLong("CourtID"))
                        .courtName(resultSet.getString("CourtName"))
                        .description(resultSet.getString("Description"))
                        .courtType(resultSet.getString("CourtType"))
                        .status(resultSet.getString("Status"))
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

    public CourtDTO getCourtById(Long courtId) {
        String sql = "SELECT * FROM Courts WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setLong(1, courtId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return CourtDTO.builder()
                        .courtId(resultSet.getLong("CourtID"))
                        .courtName(resultSet.getString("CourtName"))
                        .description(resultSet.getString("Description"))
                        .courtType(resultSet.getString("CourtType"))
                        .status(resultSet.getString("Status"))
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
        String sql = "INSERT INTO Courts (CourtName, Description, CourtType, Status, CourtImage, CreatedBy) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, court.getCourtName());
            preparedStatement.setString(2, court.getDescription());
            preparedStatement.setString(3, court.getCourtType());
            preparedStatement.setString(4, court.getStatus());
            preparedStatement.setString(5, court.getCourtImage());
            preparedStatement.setLong(6, 1); // giả sử CreatedBy là userId = 1, bạn có thể sửa

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCourt(CourtDTO court) {
        String sql = "UPDATE Courts SET CourtName = ?, Description = ?, CourtType = ?, Status = ?, CourtImage = ? WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, court.getCourtName());
            preparedStatement.setString(2, court.getDescription());
            preparedStatement.setString(3, court.getCourtType());
            preparedStatement.setString(4, court.getStatus());
            preparedStatement.setString(5, court.getCourtImage());
            preparedStatement.setLong(6, court.getCourtId());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCourt(Long courtId) {
        String sql = "DELETE FROM Courts WHERE CourtID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setLong(1, courtId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CourtDTO> searchCourtsByNameOrTypeOrStatus(String keyword) {
        String sql = "SELECT * FROM Courts WHERE CourtName LIKE ? OR CourtType LIKE ? OR Status LIKE ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, "%" + keyword + "%");
            preparedStatement.setString(2, "%" + keyword + "%");
            preparedStatement.setString(3, "%" + keyword + "%");

            ResultSet resultSet = preparedStatement.executeQuery();
            List<CourtDTO> courts = new ArrayList<>();

            while (resultSet.next()) {
                CourtDTO court = CourtDTO.builder()
                        .courtId(resultSet.getLong("CourtID"))
                        .courtName(resultSet.getString("CourtName"))
                        .description(resultSet.getString("Description"))
                        .courtType(resultSet.getString("CourtType"))
                        .status(resultSet.getString("Status"))
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
        sql += " AND (courtName LIKE ? OR description LIKE ?)";
    }
    if (status != null && !status.isEmpty()) {
        sql += " AND status = ?";
    }
    if (courtType != null && !courtType.isEmpty()) {
        sql += " AND courtType = ?";
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
            CourtDTO court = new CourtDTO();
            court.setCourtId(rs.getLong("courtId"));
            court.setCourtName(rs.getString("courtName"));
            court.setDescription(rs.getString("description"));
            court.setCourtType(rs.getString("courtType"));
            court.setStatus(rs.getString("status"));
            court.setCourtImage(rs.getString("courtImage"));
            filteredCourts.add(court);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return filteredCourts;
}


    public static void main(String[] args) {
        CourtDAO dao = new CourtDAO();
        List<CourtDTO> list = dao.getAllCourts();
        if (list != null) {
            list.forEach(System.out::println);
        } else {
            System.out.println("No courts found.");
        }
    }
}
