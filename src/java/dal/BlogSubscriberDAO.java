package dal;

import models.BlogSubscriberDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BlogSubscriberDAO {
    
    public List<BlogSubscriberDTO> getAllSubscribers() {
        String sql = "SELECT * FROM BlogSubscribers ORDER BY SubscribedAt DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogSubscriberDTO> subscribers = new ArrayList<>();

            while (resultSet.next()) {
                subscribers.add(mapResultSetToSubscriber(resultSet));
            }

            return subscribers;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public BlogSubscriberDTO getSubscriberById(int subscriberId) {
        String sql = "SELECT * FROM BlogSubscribers WHERE SubscriberID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, subscriberId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToSubscriber(resultSet);
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public BlogSubscriberDTO getSubscriberByEmail(String email) {
        String sql = "SELECT * FROM BlogSubscribers WHERE Email = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, email);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToSubscriber(resultSet);
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public int createSubscriber(BlogSubscriberDTO subscriber) {
        String sql = "INSERT INTO BlogSubscribers (Email, SubscribedAt, IsActive) VALUES (?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setString(1, subscriber.getEmail());
            preparedStatement.setTimestamp(2, subscriber.getSubscribedAt());
            preparedStatement.setBoolean(3, subscriber.getIsActive());
            
            preparedStatement.executeUpdate();
            
            try (ResultSet rs = preparedStatement.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    public boolean updateSubscriberStatus(int subscriberId, boolean isActive) {
        String sql = "UPDATE BlogSubscribers SET IsActive = ? WHERE SubscriberID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setBoolean(1, isActive);
            preparedStatement.setInt(2, subscriberId);

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteSubscriber(int subscriberId) {
        String sql = "DELETE FROM BlogSubscribers WHERE SubscriberID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, subscriberId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<BlogSubscriberDTO> getActiveSubscribers() {
        String sql = "SELECT * FROM BlogSubscribers WHERE IsActive = 1 ORDER BY SubscribedAt DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<BlogSubscriberDTO> subscribers = new ArrayList<>();

            while (resultSet.next()) {
                subscribers.add(mapResultSetToSubscriber(resultSet));
            }

            return subscribers;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private BlogSubscriberDTO mapResultSetToSubscriber(ResultSet rs) throws Exception {
        return BlogSubscriberDTO.builder()
                .SubscriberID(rs.getInt("SubscriberID"))
                .Email(rs.getString("Email"))
                .SubscribedAt(rs.getTimestamp("SubscribedAt"))
                .IsActive(rs.getBoolean("IsActive"))
                .build();
    }
} 