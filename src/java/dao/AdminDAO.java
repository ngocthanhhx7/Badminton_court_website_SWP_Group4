package dao;

import models.AdminDTO;
import utils.DBUtils;
import java.sql.Timestamp;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    private final DBContext dbContext;

    public AdminDAO() {
        this.dbContext = DBContext.getInstance();
    }

    public AdminDTO login(String username, String password) {
        String query = "SELECT * FROM Admins WHERE Username = ? AND Password = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new AdminDTO(
                            rs.getInt("AdminID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("Status"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getTimestamp("UpdatedAt")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Admins WHERE email = ? OR username = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private void validateEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty() || !email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            throw new SQLException("Email phải có đuôi @gmail.com.");
        }
    }

    private void validatePassword(String password) throws SQLException {
        if (password == null || password.length() < 8
                || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            throw new SQLException("Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
        }
    }

    public boolean registerAdmin(AdminDTO admin) throws SQLException {
        validateEmail(admin.getEmail());
        validatePassword(admin.getPassword());

        String sql = "INSERT INTO Admins (Username, Password, FullName, Email, Status, CreatedAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getPassword());
            stmt.setString(3, admin.getFullName());
            stmt.setString(4, admin.getEmail());
            stmt.setString(5, admin.getStatus() != null ? admin.getStatus() : "Active");
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        validateEmail(email);
        validatePassword(newPassword);
        String sql = "UPDATE Admins SET Password = ?, UpdatedAt = GETDATE() WHERE Email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public AdminDTO getAdminByID(int adminID) throws SQLException {
        String sql = "SELECT * FROM Admins WHERE AdminID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, adminID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new AdminDTO(
                            rs.getInt("AdminID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("Status"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getTimestamp("UpdatedAt")
                    );
                }
            }
        }
        return null;
    }

    public List<AdminDTO> getAllAdmins() throws SQLException {
        List<AdminDTO> admins = new ArrayList<>();
        String sql = "SELECT * FROM Admins";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                admins.add(new AdminDTO(
                        rs.getInt("AdminID"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getTimestamp("UpdatedAt")
                ));
            }
        }
        return admins;
    }
}
