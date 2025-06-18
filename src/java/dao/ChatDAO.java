package dao;

import java.sql.*;
import java.util.*;
import models.ChatMessage;

public class ChatDAO {
    private Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/your_db";
        String user = "root";
        String pass = "password";
        return DriverManager.getConnection(url, user, pass);
    }

    public void insertMessage(ChatMessage msg) {
        String sql = "INSERT INTO ChatMessage (sender, receiver, message, timestamp) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, msg.getSender());
            ps.setString(2, msg.getReceiver());
            ps.setString(3, msg.getMessage());
            ps.setTimestamp(4, msg.getTimestamp());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ChatMessage> getMessages(String sender, String receiver) {
        List<ChatMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM ChatMessage WHERE (sender=? AND receiver=?) OR (sender=? AND receiver=?) ORDER BY timestamp ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sender);
            ps.setString(2, receiver);
            ps.setString(3, receiver);
            ps.setString(4, sender);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ChatMessage msg = new ChatMessage(
                    rs.getString("sender"),
                    rs.getString("receiver"),
                    rs.getString("message"),
                    rs.getTimestamp("timestamp")
                );
                list.add(msg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}