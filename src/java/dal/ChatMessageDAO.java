package dal;

import models.ChatMessageDTO;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatMessageDAO {
    public List<ChatMessageDTO> getMessagesByUser(int userId) {
        String sql = "SELECT * FROM ChatMessages WHERE UserID = ? ORDER BY SentAt ASC";
        List<ChatMessageDTO> messages = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                messages.add(mapResultSetToMessage(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return messages;
    }

    public int createMessage(ChatMessageDTO message) {
        String sql = "INSERT INTO ChatMessages (UserID, Content, SenderType) VALUES (?, ?, ?)";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, message.getUserID());
            ps.setString(2, message.getContent());
            ps.setString(3, message.getSenderType());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    private ChatMessageDTO mapResultSetToMessage(ResultSet rs) throws SQLException {
        return ChatMessageDTO.builder()
                .MessageID(rs.getInt("MessageID"))
                .UserID(rs.getInt("UserID"))
                .Content(rs.getString("Content"))
                .SentAt(rs.getTimestamp("SentAt"))
                .SenderType(rs.getString("SenderType"))
                .build();
    }
} 