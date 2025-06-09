package dao;

import models.InstagramFeedDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class InstagramFeedDAO {

    public List<InstagramFeedDTO> getAllFeeds() {
        String sql = "SELECT * FROM InstagramFeeds ORDER BY DisplayOrder ASC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<InstagramFeedDTO> feeds = new ArrayList<>();

            while (resultSet.next()) {
                InstagramFeedDTO feed = InstagramFeedDTO.builder()
                        .FeedID(resultSet.getInt("FeedID"))
                        .ImageUrl(resultSet.getString("ImageUrl"))
                        .InstagramLink(resultSet.getString("InstagramLink"))
                        .DisplayOrder(resultSet.getInt("DisplayOrder"))
                        .IsVisible(resultSet.getBoolean("IsVisible"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                feeds.add(feed);
            }

            return feeds;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public InstagramFeedDTO getFeedById(int id) {
        String sql = "SELECT * FROM InstagramFeeds WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return InstagramFeedDTO.builder()
                        .FeedID(resultSet.getInt("FeedID"))
                        .ImageUrl(resultSet.getString("ImageUrl"))
                        .InstagramLink(resultSet.getString("InstagramLink"))
                        .DisplayOrder(resultSet.getInt("DisplayOrder"))
                        .IsVisible(resultSet.getBoolean("IsVisible"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean addFeed(InstagramFeedDTO feed) {
        String sql = "INSERT INTO InstagramFeeds (ImageUrl, InstagramLink, DisplayOrder, IsVisible, CreatedAt) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, feed.getImageUrl());
            preparedStatement.setString(2, feed.getInstagramLink());
            preparedStatement.setInt(3, feed.getDisplayOrder());
            preparedStatement.setBoolean(4, feed.getIsVisible());
            preparedStatement.setTimestamp(5, feed.getCreatedAt());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateFeed(InstagramFeedDTO feed) {
        String sql = "UPDATE InstagramFeeds SET ImageUrl = ?, InstagramLink = ?, DisplayOrder = ?, IsVisible = ? WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, feed.getImageUrl());
            preparedStatement.setString(2, feed.getInstagramLink());
            preparedStatement.setInt(3, feed.getDisplayOrder());
            preparedStatement.setBoolean(4, feed.getIsVisible());
            preparedStatement.setInt(5, feed.getFeedID());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFeed(int id) {
        String sql = "DELETE FROM InstagramFeeds WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, id);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<InstagramFeedDTO> searchFeeds(String keyword) {
        String sql = "SELECT * FROM InstagramFeeds WHERE InstagramLink LIKE ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, "%" + keyword + "%");

            ResultSet resultSet = preparedStatement.executeQuery();
            List<InstagramFeedDTO> feeds = new ArrayList<>();

            while (resultSet.next()) {
                InstagramFeedDTO feed = InstagramFeedDTO.builder()
                        .FeedID(resultSet.getInt("FeedID"))
                        .ImageUrl(resultSet.getString("ImageUrl"))
                        .InstagramLink(resultSet.getString("InstagramLink"))
                        .DisplayOrder(resultSet.getInt("DisplayOrder"))
                        .IsVisible(resultSet.getBoolean("IsVisible"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                feeds.add(feed);
            }

            return feeds;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        InstagramFeedDAO dao = new InstagramFeedDAO();
        List<InstagramFeedDTO> list = dao.getAllFeeds();
        if (list != null) {
            list.forEach(System.out::println);
        } else {
            System.out.println("No feeds found.");
        }
    }
}
