package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import utils.DBUtils;

public class ChatDAO {
    public static void saveMessage(String sender, String content, LocalDateTime timestamp) {
        String sql = "INSERT INTO Messages(sender, content, timestamp) VALUES (?, ?, ?)";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sender);
            ps.setString(2, content);
            ps.setTimestamp(3, Timestamp.valueOf(timestamp));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
