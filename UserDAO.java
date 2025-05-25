package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.entity.Users;

public class UserDAO {

    private final DBContext dbContext;

    public UserDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Kiểm tra email hoặc username đã tồn tại chưa trong bảng Users
    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ? OR username = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Validate email: must end with @gmail.com
    private void validateEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty() || !email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            throw new SQLException("Email phải có đuôi @gmail.com.");
        }
    }

    // Validate password: at least 8 chars, 1 uppercase, 1 special char, 1 digit
    private void validatePassword(String password) throws SQLException {
        if (password == null || password.length() < 8
                || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            throw new SQLException("Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
        }
    }

    // Kiểm tra số điện thoại đã tồn tại chưa (chỉ kiểm tra nếu phone không null)
    public boolean isPhoneExists(String phone) throws SQLException {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Users WHERE phone = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Đăng ký tài khoản cơ bản vào bảng Users
    public boolean registerUserBasic(Users user) throws SQLException {
        validateEmail(user.getEmail());
        validatePassword(user.getPassword());
        String sql = "INSERT INTO Users (username, email, password, role, phone, createdBy, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword()); // Already hashed in Service
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getPhone());
            stmt.setObject(6, user.getCreatedBy(), java.sql.Types.INTEGER);
            stmt.setDate(7, user.getCreatedAt());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in registerUserBasic: " + e.getMessage());
            throw e;
        }
    }

    // Tìm người dùng trong Users dựa trên email hoặc username
    public Users findUserByEmailOrUsername(String emailOrUsername) throws SQLException {
        String sql = "SELECT * FROM Users WHERE email = ? OR username = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, emailOrUsername);
            stmt.setString(2, emailOrUsername);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Users user = new Users();
                    user.setUserID(rs.getInt("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("fullName"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getString("gender"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setMedicalHistory(rs.getString("medicalHistory"));
                    user.setSpecialization(rs.getString("specialization"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedBy(rs.getInt("createdBy"));
                    user.setCreatedAt(rs.getDate("createdAt"));
                    user.setUpdatedAt(rs.getDate("updatedAt"));
                    return user;
                }
            }
        }
        return null;
    }

    // Cập nhật thông tin hồ sơ của user
    public void updateUserProfile(Users user) throws SQLException {
        String sql = "UPDATE Users SET fullName = ?, dob = ?, gender = ?, phone = ?, address = ?, "
                + "medicalHistory = ?, specialization = ?, updatedAt = GETDATE() "
                + "WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setDate(2, user.getDob());
            stmt.setString(3, user.getGender());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getMedicalHistory());
            stmt.setString(7, user.getSpecialization());
            stmt.setInt(8, user.getUserID());
            stmt.executeUpdate();
        }
    }

    // New method to update password
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        validateEmail(email);
        validatePassword(newPassword);
        String sql = "UPDATE Users SET [password] = ?, updatedAt = GETDATE() WHERE email = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword); // Already hashed in Service
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    // Placeholder for password hashing
    private String hashPassword(String password) {
        // Implement password hashing (e.g., using BCrypt)
        return password; // Replace with actual hashing logic (e.g., BCrypt.hashpw(password, BCrypt.gensalt()))
    }

    public Users getUserByID(int userID) throws SQLException {
        String sql = "SELECT * FROM Users WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Users user = new Users();
                    user.setUserID(rs.getInt("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("fullName"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getString("gender"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setMedicalHistory(rs.getString("medicalHistory"));
                    user.setSpecialization(rs.getString("specialization"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedBy(rs.getInt("createdBy"));
                    user.setCreatedAt(rs.getDate("createdAt"));
                    user.setUpdatedAt(rs.getDate("updatedAt"));
                    return user;
                }
            }
        }
        return null;
    }

    // Trong UserDAO, phương thức addUser
    public boolean addUser(Users user, int createdBy) throws SQLException {
        validateEmail(user.getEmail());
        validatePassword(user.getPassword());
        if (isEmailOrUsernameExists(user.getEmail(), user.getUsername()) || isPhoneExists(user.getPhone())) {
            throw new SQLException("Email, username hoặc số điện thoại đã tồn tại.");
        }

        // Map gender to match database values
        String mappedGender = user.getGender();
        if (mappedGender != null && !mappedGender.trim().isEmpty()) {
            mappedGender = mappedGender.trim();
            if (mappedGender.equals("Nam")) {
                mappedGender = "Male";
            } else if (mappedGender.equals("Nữ")) {
                mappedGender = "Female";
            } else if (mappedGender.equals("Khác")) {
                mappedGender = "Other";
            }
        } else {
            mappedGender = null; // Allow NULL as per database schema
        }

        String sql = "INSERT INTO Users (fullName, gender, dob, specialization, role, status, email, phone, address, username, password, createdBy, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName() != null ? user.getFullName().trim() : null);
            stmt.setString(2, mappedGender); // Allow NULL if gender is not provided
            stmt.setDate(3, user.getDob());
            stmt.setString(4, user.getSpecialization() != null ? user.getSpecialization().trim() : null);
            stmt.setString(5, user.getRole() != null ? user.getRole().trim() : null);
            stmt.setString(6, user.getStatus() != null ? user.getStatus().trim() : "Active"); // Đảm bảo mặc định "Active"
            stmt.setString(7, user.getEmail() != null ? user.getEmail().trim() : null);
            stmt.setString(8, user.getPhone() != null ? user.getPhone().trim() : null);
            stmt.setString(9, user.getAddress() != null ? user.getAddress().trim() : null);
            stmt.setString(10, user.getUsername() != null ? user.getUsername().trim() : null);
            stmt.setString(11, user.getPassword() != null ? user.getPassword().trim() : null);
            stmt.setObject(12, createdBy, java.sql.Types.INTEGER);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

  public List<Users> getAllEmployee() throws SQLException {
    List<Users> users = new ArrayList<>();
    String sql = "SELECT UserID, Username, [Password], Email, FullName, Dob, Gender, Phone, [Address], MedicalHistory, Specialization, [Role], [Status], CreatedBy, CreatedAt, UpdatedAt FROM Users WHERE Role IN ('doctor', 'nurse','receptionist')";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            Users user = new Users();
            user.setUserID(rs.getInt("UserID"));
            user.setUsername(rs.getString("Username"));
            user.setPassword(rs.getString("Password"));
            user.setEmail(rs.getString("Email"));
            user.setFullName(rs.getString("FullName"));
            user.setDob(rs.getDate("Dob"));
            user.setGender(rs.getString("Gender"));
            user.setPhone(rs.getString("Phone"));
            user.setAddress(rs.getString("Address"));
            user.setMedicalHistory(rs.getString("MedicalHistory"));
            user.setSpecialization(rs.getString("Specialization"));
            user.setRole(rs.getString("Role"));
            user.setStatus(rs.getString("Status"));
            user.setCreatedBy(rs.getObject("CreatedBy") != null ? rs.getInt("CreatedBy") : null);
            user.setCreatedAt(rs.getDate("CreatedAt"));
            user.setUpdatedAt(rs.getDate("UpdatedAt"));
            users.add(user);
        }
    }
    return users;
}

public Users getEmployeeByID(int userID) throws SQLException {
    String sql = "SELECT * FROM Users WHERE userID = ? AND Role IN ('doctor', 'nurse', 'receptionist')";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userID);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Users user = new Users();
                user.setUserID(rs.getInt("userID"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("fullName"));
                user.setDob(rs.getDate("dob"));
                user.setGender(rs.getString("gender"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setMedicalHistory(rs.getString("medicalHistory"));
                user.setSpecialization(rs.getString("specialization"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedBy(rs.getObject("createdBy") != null ? rs.getInt("createdBy") : null);
                user.setCreatedAt(rs.getDate("createdAt"));
                user.setUpdatedAt(rs.getDate("updatedAt"));
                return user;
            }
        }
    }
    return null;
}
public boolean  UpdateEmployee(Users user) {
        String sql = "UPDATE Users SET fullName = ?, gender = ?, specialization = ?, dob = ?, status = ? WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); // Replace with your DB connection logic
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getGender());
            stmt.setString(3, user.getSpecialization());
            stmt.setDate(4, new java.sql.Date(user.getDob().getTime()));
            stmt.setString(5, user.getStatus());
            stmt.setInt(6, user.getUserID());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }



}
