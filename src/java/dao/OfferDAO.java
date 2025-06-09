package dao;

import models.OfferDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OfferDAO {

    public List<OfferDTO> getAllOffers() {
        String sql = "SELECT * FROM Offers ORDER BY CreatedAt DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<OfferDTO> offers = new ArrayList<>();

            while (resultSet.next()) {
                OfferDTO offer = OfferDTO.builder()
                        .OfferID(resultSet.getInt("OfferID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .Description(resultSet.getString("Description"))
                        .ImageUrl(resultSet.getString("ImageUrl"))
                        .Capacity(resultSet.getInt("Capacity"))
                        .IsVIP(resultSet.getBoolean("IsVIP"))
                        .IsActive(resultSet.getBoolean("IsActive"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                offers.add(offer);
            }

            return offers;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public OfferDTO getOfferById(int offerId) {
        String sql = "SELECT * FROM Offers WHERE OfferID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, offerId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return OfferDTO.builder()
                        .OfferID(resultSet.getInt("OfferID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .Description(resultSet.getString("Description"))
                        .ImageUrl(resultSet.getString("ImageUrl"))
                        .Capacity(resultSet.getInt("Capacity"))
                        .IsVIP(resultSet.getBoolean("IsVIP"))
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

    public boolean addOffer(OfferDTO offer) {
        String sql = "INSERT INTO Offers (Title, Subtitle, Description, ImageUrl, Capacity, IsVIP, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, offer.getTitle());
            preparedStatement.setString(2, offer.getSubtitle());
            preparedStatement.setString(3, offer.getDescription());
            preparedStatement.setString(4, offer.getImageUrl());
            preparedStatement.setInt(5, offer.getCapacity());
            preparedStatement.setBoolean(6, offer.getIsVIP());
            preparedStatement.setBoolean(7, offer.getIsActive());
            preparedStatement.setTimestamp(8, offer.getCreatedAt());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateOffer(OfferDTO offer) {
        String sql = "UPDATE Offers SET Title = ?, Subtitle = ?, Description = ?, ImageUrl = ?, Capacity = ?, IsVIP = ?, IsActive = ? WHERE OfferID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, offer.getTitle());
            preparedStatement.setString(2, offer.getSubtitle());
            preparedStatement.setString(3, offer.getDescription());
            preparedStatement.setString(4, offer.getImageUrl());
            preparedStatement.setInt(5, offer.getCapacity());
            preparedStatement.setBoolean(6, offer.getIsVIP());
            preparedStatement.setBoolean(7, offer.getIsActive());
            preparedStatement.setInt(8, offer.getOfferID());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteOffer(int offerId) {
        String sql = "DELETE FROM Offers WHERE OfferID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, offerId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<OfferDTO> searchOffers(String keyword) {
        String sql = "SELECT * FROM Offers WHERE Title LIKE ? OR Subtitle LIKE ? OR Description LIKE ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            String likeKeyword = "%" + keyword + "%";
            preparedStatement.setString(1, likeKeyword);
            preparedStatement.setString(2, likeKeyword);
            preparedStatement.setString(3, likeKeyword);

            ResultSet resultSet = preparedStatement.executeQuery();
            List<OfferDTO> offers = new ArrayList<>();

            while (resultSet.next()) {
                OfferDTO offer = OfferDTO.builder()
                        .OfferID(resultSet.getInt("OfferID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .Description(resultSet.getString("Description"))
                        .ImageUrl(resultSet.getString("ImageUrl"))
                        .Capacity(resultSet.getInt("Capacity"))
                        .IsVIP(resultSet.getBoolean("IsVIP"))
                        .IsActive(resultSet.getBoolean("IsActive"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                offers.add(offer);
            }

            return offers;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        OfferDAO dao = new OfferDAO();
        List<OfferDTO> list = dao.getAllOffers();
        if (list != null) {
            list.forEach(System.out::println);
        } else {
            System.out.println("No offers found.");
        }
    }
}
