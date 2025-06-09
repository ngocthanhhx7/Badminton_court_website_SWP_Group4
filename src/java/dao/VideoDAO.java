package dao;

import models.VideoDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VideoDAO {

    public List<VideoDTO> getAllVideos() {
        String sql = "SELECT * FROM Videos ORDER BY CreatedAt DESC";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<VideoDTO> videos = new ArrayList<>();

            while (resultSet.next()) {
                VideoDTO video = VideoDTO.builder()
                        .VideoID(resultSet.getInt("VideoID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .VideoUrl(resultSet.getString("VideoUrl"))
                        .ThumbnailUrl(resultSet.getString("ThumbnailUrl"))
                        .IsFeatured(resultSet.getBoolean("IsFeatured"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                videos.add(video);
            }

            return videos;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public VideoDTO getVideoById(int videoId) {
        String sql = "SELECT * FROM Videos WHERE VideoID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, videoId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
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

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean addVideo(VideoDTO video) {
        String sql = "INSERT INTO Videos (Title, Subtitle, VideoUrl, ThumbnailUrl, IsFeatured, CreatedAt) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, video.getTitle());
            preparedStatement.setString(2, video.getSubtitle());
            preparedStatement.setString(3, video.getVideoUrl());
            preparedStatement.setString(4, video.getThumbnailUrl());
            preparedStatement.setBoolean(5, video.getIsFeatured());
            preparedStatement.setTimestamp(6, video.getCreatedAt());

            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVideo(VideoDTO video) {
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
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteVideo(int videoId) {
        String sql = "DELETE FROM Videos WHERE VideoID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, videoId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<VideoDTO> searchVideos(String keyword) {
        String sql = "SELECT * FROM Videos WHERE Title LIKE ? OR Subtitle LIKE ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, "%" + keyword + "%");
            preparedStatement.setString(2, "%" + keyword + "%");

            ResultSet resultSet = preparedStatement.executeQuery();
            List<VideoDTO> videos = new ArrayList<>();

            while (resultSet.next()) {
                VideoDTO video = VideoDTO.builder()
                        .VideoID(resultSet.getInt("VideoID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .VideoUrl(resultSet.getString("VideoUrl"))
                        .ThumbnailUrl(resultSet.getString("ThumbnailUrl"))
                        .IsFeatured(resultSet.getBoolean("IsFeatured"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                videos.add(video);
            }

            return videos;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        VideoDAO dao = new VideoDAO();
        List<VideoDTO> list = dao.getAllVideos();
        if (list != null) {
            list.forEach(System.out::println);
        } else {
            System.out.println("No videos found.");
        }
    }
}

    
