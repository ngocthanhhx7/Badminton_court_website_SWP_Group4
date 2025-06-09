package dao;

import models.AboutSectionDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AboutSectionDAO {

    public List<AboutSectionDTO> getAllSections() {
        String sql = "SELECT * FROM AboutSections ORDER BY AboutID DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

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

    public AboutSectionDTO getSectionById(int id) {
        String sql = "SELECT * FROM AboutSections WHERE AboutID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return AboutSectionDTO.builder()
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
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean addSection(AboutSectionDTO section) {
        String sql = "INSERT INTO AboutSections (Title, Subtitle, Content, Image1, Image2, SectionType, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, section.getTitle());
            preparedStatement.setString(2, section.getSubtitle());
            preparedStatement.setString(3, section.getContent());
            preparedStatement.setString(4, section.getImage1());
            preparedStatement.setString(5, section.getImage2());
            preparedStatement.setString(6, section.getSectionType());
            preparedStatement.setBoolean(7, section.getIsActive());
            preparedStatement.setTimestamp(8, section.getCreatedAt());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSection(AboutSectionDTO section) {
        String sql = "UPDATE AboutSections SET Title = ?, Subtitle = ?, Content = ?, Image1 = ?, Image2 = ?, SectionType = ?, IsActive = ? WHERE AboutID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, section.getTitle());
            preparedStatement.setString(2, section.getSubtitle());
            preparedStatement.setString(3, section.getContent());
            preparedStatement.setString(4, section.getImage1());
            preparedStatement.setString(5, section.getImage2());
            preparedStatement.setString(6, section.getSectionType());
            preparedStatement.setBoolean(7, section.getIsActive());
            preparedStatement.setInt(8, section.getAboutID());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSection(int id) {
        String sql = "DELETE FROM AboutSections WHERE AboutID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, id);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
        List<AboutSectionDTO> list = dao.getAllSections();
        if (list != null) {
            list.forEach(System.out::println);
        } else {
            System.out.println("No sections found.");
        }
    }
}
