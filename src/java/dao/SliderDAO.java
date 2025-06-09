package dao;

import models.SliderDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SliderDAO {

    public List<SliderDTO> getAllSliders() {
        String sql = "SELECT * FROM Sliders ORDER BY SliderID DESC";
        try (Connection connection = DBUtils.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

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

    public SliderDTO getSliderById(int sliderId) {
        String sql = "SELECT * FROM Sliders WHERE SliderID = ?";
        try (Connection connection = DBUtils.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, sliderId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return SliderDTO.builder()
                        .SliderID(resultSet.getInt("SliderID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .BackgroundImage(resultSet.getString("BackgroundImage"))
                        .Position(resultSet.getInt("Position"))
                        .IsActive(resultSet.getBoolean("IsActive"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean addSlider(SliderDTO slider) {
        String sql = "INSERT INTO Sliders (Title, Subtitle, BackgroundImage, Position, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, slider.getTitle());
            preparedStatement.setString(2, slider.getSubtitle());
            preparedStatement.setString(3, slider.getBackgroundImage());
            preparedStatement.setInt(4, slider.getPosition());
            preparedStatement.setBoolean(5, slider.getIsActive());
            preparedStatement.setTimestamp(6, slider.getCreatedAt());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSlider(SliderDTO slider) {
        String sql = "UPDATE Sliders SET Title = ?, Subtitle = ?, BackgroundImage = ?, Position = ?, IsActive = ? WHERE SliderID = ?";
        try (Connection connection = DBUtils.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, slider.getTitle());
            preparedStatement.setString(2, slider.getSubtitle());
            preparedStatement.setString(3, slider.getBackgroundImage());
            preparedStatement.setInt(4, slider.getPosition());
            preparedStatement.setBoolean(5, slider.getIsActive());
            preparedStatement.setInt(6, slider.getSliderID());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSlider(int sliderId) {
        String sql = "DELETE FROM Sliders WHERE SliderID = ?";
        try (Connection connection = DBUtils.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, sliderId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
        List<SliderDTO> list = dao.getAllSliders();
        if (list != null) {
            list.forEach(System.out::println);
        } else {
            System.out.println("No sliders found.");
        }
    }
}
