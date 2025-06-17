package dao;

import models.InstagramFeedDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InstagramFeedDAO {

    public List<InstagramFeedDTO> getAllFeeds(int page, int pageSize, String searchKeyword, Boolean isVisible) throws SQLException {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT * FROM InstagramFeeds WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (InstagramLink LIKE ? OR ImageUrl LIKE ?)");
            params.add("%" + searchKeyword + "%");
            params.add("%" + searchKeyword + "%");
        }
        
        if (isVisible != null) {
            sql.append(" AND IsVisible = ?");
            params.add(isVisible);
        }
        
        sql.append(" ORDER BY DisplayOrder ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                preparedStatement.setObject(i + 1, params.get(i));
            }

            ResultSet resultSet = preparedStatement.executeQuery();
            List<InstagramFeedDTO> feeds = new ArrayList<>();

            while (resultSet.next()) {
                feeds.add(mapResultSetToFeed(resultSet));
            }

            return feeds;
        }
    }

    public int getTotalFeeds(String searchKeyword, Boolean isVisible) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM InstagramFeeds WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (InstagramLink LIKE ? OR ImageUrl LIKE ?)");
            params.add("%" + searchKeyword + "%");
            params.add("%" + searchKeyword + "%");
        }
        
        if (isVisible != null) {
            sql.append(" AND IsVisible = ?");
            params.add(isVisible);
        }

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                preparedStatement.setObject(i + 1, params.get(i));
            }

            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }

    public InstagramFeedDTO getFeedById(int id) throws SQLException {
        String sql = "SELECT * FROM InstagramFeeds WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToFeed(resultSet);
            }

            return null;
        }
    }

    public boolean addFeed(InstagramFeedDTO feed) throws SQLException {
        String sql = "INSERT INTO InstagramFeeds (ImageUrl, InstagramLink, DisplayOrder, IsVisible, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, feed.getImageUrl());
            preparedStatement.setString(2, feed.getInstagramLink());
            preparedStatement.setInt(3, getNextDisplayOrder());
            preparedStatement.setBoolean(4, feed.getIsVisible());

            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean updateFeed(InstagramFeedDTO feed) throws SQLException {
        String sql = "UPDATE InstagramFeeds SET ImageUrl = ?, InstagramLink = ?, DisplayOrder = ?, IsVisible = ? WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, feed.getImageUrl());
            preparedStatement.setString(2, feed.getInstagramLink());
            preparedStatement.setInt(3, feed.getDisplayOrder());
            preparedStatement.setBoolean(4, feed.getIsVisible());
            preparedStatement.setInt(5, feed.getFeedID());

            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean deleteFeed(int id) throws SQLException {
        String sql = "DELETE FROM InstagramFeeds WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, id);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean toggleVisibility(int id) throws SQLException {
        String sql = "UPDATE InstagramFeeds SET IsVisible = ~IsVisible WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, id);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean updateDisplayOrder(int feedId, int newOrder) throws SQLException {
        String sql = "UPDATE InstagramFeeds SET DisplayOrder = ? WHERE FeedID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, newOrder);
            preparedStatement.setInt(2, feedId);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    private int getNextDisplayOrder() throws SQLException {
        String sql = "SELECT ISNULL(MAX(DisplayOrder), 0) + 1 FROM InstagramFeeds";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 1;
        }
    }

    private InstagramFeedDTO mapResultSetToFeed(ResultSet resultSet) throws SQLException {
        return InstagramFeedDTO.builder()
                .FeedID(resultSet.getInt("FeedID"))
                .ImageUrl(resultSet.getString("ImageUrl"))
                .InstagramLink(resultSet.getString("InstagramLink"))
                .DisplayOrder(resultSet.getInt("DisplayOrder"))
                .IsVisible(resultSet.getBoolean("IsVisible"))
                .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                .build();
    }

    public static void main(String[] args) {
        InstagramFeedDAO dao = new InstagramFeedDAO();
        try {
            List<InstagramFeedDTO> list = dao.getAllFeeds(1, 10, null, null);
            if (list != null) {
                list.forEach(System.out::println);
            } else {
                System.out.println("No feeds found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
