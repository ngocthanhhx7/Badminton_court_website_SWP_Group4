package dao;

import models.UserDTO;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection conn;

    public UserDAO() {
        this.conn = DBUtils.getConnection();
    }

    public UserDTO login(String username, String password) {
        String query = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserDTO(
                            rs.getInt("UserID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("Email"),
                            rs.getString("FullName"),
                            rs.getDate("Dob"),
                            rs.getString("Gender"),
                            rs.getString("Phone"),
                            rs.getString("Address"),
                            rs.getString("SportLevel"),
                            rs.getString("Role"),
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
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
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? OR username = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public UserDTO loginWithEmailOrUsername(String input, String password) {
        String query = "SELECT * FROM Users WHERE (Username = ? OR Email = ?) AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, input);
            ps.setString(2, input);
            ps.setString(3, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserDTO(
                            rs.getInt("UserID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("Email"),
                            rs.getString("FullName"),
                            rs.getDate("Dob"),
                            rs.getString("Gender"),
                            rs.getString("Phone"),
                            rs.getString("Address"),
                            rs.getString("SportLevel"),
                            rs.getString("Role"),
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
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

    public boolean isPhoneExists(String phone) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE phone = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public boolean registerUserBasic(UserDTO user) throws SQLException {
        String sql = "INSERT INTO users (username, email, password, role, phone, createdAt, createdBy) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getPhone());
            ps.setTimestamp(6, user.getCreatedAt());

            // Sửa đúng:
            if (user.getCreatedBy() != null) {
                ps.setInt(7, user.getCreatedBy());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;
        }
    }

    public UserDTO findUserByEmailOrUsername(String input) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? OR username = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, input);
            ps.setString(2, input);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public void updateUserProfile(UserDTO user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, password = ?, dob = ?, gender = ?, phone = ?, address = ?, sport_level = ?, role = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPassword());
            ps.setDate(3, new java.sql.Date(user.getDob().getTime()));
            ps.setString(4, user.getGender());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getSportLevel());
            ps.setString(8, user.getRole());
            ps.setInt(9, user.getUserID());
            ps.executeUpdate();
        }
    }

    public boolean updatePassword(String email, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        }
    }

    public UserDTO getUserByID(int userID) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public boolean addUser(UserDTO user, int createdBy) throws SQLException {
        String sql = "INSERT INTO users (full_name, gender, dob, specialization, role, status, email, phone, address, username, password, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getGender());
            ps.setDate(3, new java.sql.Date(user.getDob().getTime()));
            ps.setString(4, user.getSportLevel()); // lưu sportLevel tương ứng với specialization
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());
            ps.setString(7, user.getEmail());
            ps.setString(8, user.getPhone());
            ps.setString(9, user.getAddress());
            ps.setString(10, user.getUsername());
            ps.setString(11, user.getPassword());
            ps.setInt(12, createdBy);
            return ps.executeUpdate() > 0;
        }
    }

    public List<UserDTO> getAllEmployee() throws SQLException {
        List<UserDTO> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'Employee'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }

    public UserDTO getEmployeeByID(int userID) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ? AND role = 'Employee'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public boolean UpdateEmployee(UserDTO user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, gender = ?, dob = ?, specialization = ?, status = ?, phone = ?, address = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getGender());
            ps.setDate(3, new java.sql.Date(user.getDob().getTime()));
            ps.setString(4, user.getSportLevel());
            ps.setString(5, user.getStatus());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getAddress());
            ps.setInt(8, user.getUserID());
            return ps.executeUpdate() > 0;
        }
    }

    private UserDTO mapResultSetToUser(ResultSet rs) throws SQLException {
        UserDTO user = new UserDTO();
        user.setUserID(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setPhone(rs.getString("phone"));
        user.setFullName(rs.getString("full_name"));
        user.setGender(rs.getString("gender"));
        user.setDob(rs.getDate("dob"));
        user.setSportLevel(rs.getString("specialization"));
        user.setStatus(rs.getString("status"));
        user.setAddress(rs.getString("address"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setCreatedBy(rs.getInt("created_by"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }

    public void updateUser(UserDTO user) {
        String selectSql = "SELECT UpdatedAt FROM Users WHERE Email = ?";
        String updateSql = "UPDATE Users SET FullName = ?, Dob = ?, Gender = ?, Phone = ?, Address = ?, SportLevel = ?, Password = ?, CreatedAt = ?, UpdatedAt = ? WHERE Email = ?";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement selectPs = conn.prepareStatement(selectSql); PreparedStatement updatePs = conn.prepareStatement(updateSql)) {

            // 1. Lấy UpdatedAt hiện tại từ DB (dùng làm CreatedAt mới)
            Timestamp prevUpdatedAt = null;
            selectPs.setString(1, user.getEmail());
            try (ResultSet rs = selectPs.executeQuery()) {
                if (rs.next()) {
                    prevUpdatedAt = rs.getTimestamp("UpdatedAt");
                }
            }

            // 2. Nếu không có user thì thoát
            if (prevUpdatedAt == null) {
                System.out.println("User không tồn tại.");
                return;
            }

            // 3. Thời gian mới
            Timestamp now = new Timestamp(System.currentTimeMillis());

            // 4. Update thông tin + thời gian
            updatePs.setString(1, user.getFullName());
            updatePs.setDate(2, new java.sql.Date(user.getDob().getTime()));
            updatePs.setString(3, user.getGender());
            updatePs.setString(4, user.getPhone());
            updatePs.setString(5, user.getAddress());
            updatePs.setString(6, user.getSportLevel());
            updatePs.setString(7, user.getPassword());
            updatePs.setTimestamp(8, prevUpdatedAt);
            updatePs.setTimestamp(9, now);
            updatePs.setString(10, user.getEmail());

            updatePs.executeUpdate();

            System.out.println("Cập nhật thành công. CreatedAt: " + prevUpdatedAt + ", UpdatedAt: " + now);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
