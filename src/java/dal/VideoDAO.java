package dal;

import models.VideoDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VideoDAO {

    public List<VideoDTO> getAllVideos(int page, int pageSize, String searchKeyword, Boolean isFeatured) throws SQLException {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT * FROM Videos WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (Title LIKE ? OR Subtitle LIKE ?)");
            params.add("%" + searchKeyword + "%");
            params.add("%" + searchKeyword + "%");
        }
        
        if (isFeatured != null) {
            sql.append(" AND IsFeatured = ?");
            params.add(isFeatured);
        }
        
        sql.append(" ORDER BY CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                preparedStatement.setObject(i + 1, params.get(i));
            }

            ResultSet resultSet = preparedStatement.executeQuery();
            List<VideoDTO> videos = new ArrayList<>();

            while (resultSet.next()) {
                videos.add(mapResultSetToVideo(resultSet));
            }

            return videos;
        }
    }

    public int getTotalVideos(String searchKeyword, Boolean isFeatured) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Videos WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (Title LIKE ? OR Subtitle LIKE ?)");
            params.add("%" + searchKeyword + "%");
            params.add("%" + searchKeyword + "%");
        }
        
        if (isFeatured != null) {
            sql.append(" AND IsFeatured = ?");
            params.add(isFeatured);
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

    public VideoDTO getVideoById(int videoId) throws SQLException {
        String sql = "SELECT * FROM Videos WHERE VideoID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, videoId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToVideo(resultSet);
            }

            return null;
        }
    }

    public boolean addVideo(VideoDTO video) throws SQLException {
        String sql = "INSERT INTO Videos (Title, Subtitle, VideoUrl, ThumbnailUrl, IsFeatured, CreatedAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, video.getTitle());
            preparedStatement.setString(2, video.getSubtitle());
            preparedStatement.setString(3, video.getVideoUrl());
            preparedStatement.setString(4, video.getThumbnailUrl());
            preparedStatement.setBoolean(5, video.getIsFeatured());

            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean updateVideo(VideoDTO video) throws SQLException {
        String sql = "UPDATE Videos SET Title = ?, Subtitle = ?, VideoUrl = ?, ThumbnailUrl = ?, IsFeatured = ? WHERE VideoID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, video.getTitle());
            preparedStatement.setString(2, video.getSubtitle());
            preparedStatement.setString(3, video.getVideoUrl());
            preparedStatement.setString(4, video.getThumbnailUrl());
            preparedStatement.setBoolean(5, video.getIsFeatured());
            preparedStatement.setInt(6, video.getVideoID());

            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean deleteVideo(int videoId) throws SQLException {
        String sql = "DELETE FROM Videos WHERE VideoID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, videoId);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean toggleFeatured(int videoId) throws SQLException {
        String sql = "UPDATE Videos SET IsFeatured = ~IsFeatured WHERE VideoID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, videoId);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    private VideoDTO mapResultSetToVideo(ResultSet resultSet) throws SQLException {
        return VideoDTO.builder()
                .VideoID(resultSet.getInt("VideoID"))
                .Title(resultSet.getString("Title"))
                .Subtitle(resultSet.getString("Subtitle"))
                .VideoUrl(resultSet.getString("VideoUrl"))
                .ThumbnailUrl(resultSet.getString("ThumbnailUrl"))
                .IsFeatured(resultSet.getBoolean("IsFeatured"))
                .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                .build();
    }

    public static void main(String[] args) {
        VideoDAO dao = new VideoDAO();
        try {
            List<VideoDTO> list = dao.getAllVideos(1, 10, null, null);
            if (list != null) {
                list.forEach(System.out::println);
            } else {
                System.out.println("No videos found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

    
