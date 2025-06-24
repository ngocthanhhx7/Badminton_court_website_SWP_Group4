package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.UserDTO;
import org.mindrot.jbcrypt.BCrypt;
import utils.DBUtils;
import models.UserDTO;
import utils.DBUtils;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import static utils.PasswordUtil.hashPassword;
public class UserDAO {

    private Connection conn;

    public UserDAO() {
        this.conn = DBUtils.getConnection();
    }

//    public UserDTO login(String username, String password) {
//        String query = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
//        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
//            ps.setString(1, username);
//            ps.setString(2, password);
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    return new UserDTO(
//                            rs.getInt("UserID"),
//                            rs.getString("Username"),
//                            rs.getString("Password"),
//                            rs.getString("Email"),
//                            rs.getString("FullName"),
//                            rs.getDate("Dob"),
//                            rs.getString("Gender"),
//                            rs.getString("Phone"),
//                            rs.getString("Address"),
//                            rs.getString("SportLevel"),
//                            rs.getString("Role"),
//                            rs.getString("Status"),
//                            rs.getInt("CreatedBy"),
//                            rs.getTimestamp("CreatedAt"),
//                            rs.getTimestamp("UpdatedAt")
//                    );
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
   public UserDTO login(String username, String password) {
    String query = "SELECT * FROM Users WHERE Username = ?";
    try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String hashedPassword = rs.getString("Password");

                // Chỉ kiểm tra bằng BCrypt
                if (BCrypt.checkpw(password, hashedPassword)) {
                    return new UserDTO(
                            rs.getInt("UserID"),
                            rs.getString("Username"),
                            hashedPassword,
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

//    public UserDTO findUserByEmailOrUsername(String input) throws SQLException {
//        String sql = "SELECT * FROM users WHERE email = ? OR username = ?";
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, input);
//            ps.setString(2, input);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                return mapResultSetToUser(rs);
//            }
//        }
//        return null;
//    }
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
        String sql = "UPDATE users SET FullName = ?, Password = ?, Dob = ?, Gender = ?, Phone = ?, Address = ?, SportLevel = ?, Role = ? WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, BCrypt.hashpw(user.getPassword(), BCrypt.gensalt())); // BCrypt
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
//    public boolean updatePassword(String email, String hashedPassword) throws SQLException {
//        String sql = "UPDATE users SET password = ? WHERE email = ?";
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, hashedPassword);
//            ps.setString(2, email);
//            return ps.executeUpdate() > 0;
//        }
//    }
public boolean updatePassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt())); // BCrypt
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        }
    }
    public UserDTO getUserByID(int userID) throws SQLException {
        String sql = "SELECT * FROM users WHERE UserID = ?";
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
        String sql = "INSERT INTO users (FullName, Gender, Dob, SportLevel, Role, Status, Email, Phone, Address, Username, Password, CreatedBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getGender());
            ps.setDate(3, new java.sql.Date(user.getDob().getTime()));
            ps.setString(4, user.getSportLevel());
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
        String sql = "SELECT * FROM users WHERE UserID = ? AND Role = 'Employee'";
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
        String sql = "UPDATE users SET FullName = ?, Gender = ?, Dob = ?, SportLevel = ?, Status = ?, Phone = ?, Address = ? WHERE UserID = ?";
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
//
    private UserDTO mapResultSetToUser(ResultSet rs) throws SQLException {
        UserDTO user = new UserDTO();
        user.setUserID(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setEmail(rs.getString("Email"));
        user.setPassword(rs.getString("Password"));
        user.setRole(rs.getString("Role"));
        user.setPhone(rs.getString("Phone"));
        user.setFullName(rs.getString("FullName"));
        user.setGender(rs.getString("Gender"));
        user.setDob(rs.getDate("Dob"));
        user.setSportLevel(rs.getString("SportLevel"));
        user.setStatus(rs.getString("Status"));
        user.setAddress(rs.getString("Address"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        user.setCreatedBy(rs.getInt("CreatedBy"));
        user.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return user;
    }
//
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
//
    public boolean registerUser(UserDTO user) throws SQLException {
        String sql = "INSERT INTO Users (Username, [Password], Email, FullName, Dob, Gender, Phone, [Address], SportLevel, [Role], [Status], CreatedBy, CreatedAt, UpdatedAt, verify_code) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Active', ?, GETDATE(), GETDATE(), ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());

            if (user.getFullName() != null && !user.getFullName().isEmpty()) {
                ps.setString(4, user.getFullName());
            } else {
                ps.setNull(4, Types.NVARCHAR);
            }

            if (user.getDob() != null) {
                ps.setDate(5, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            if (user.getGender() != null && !user.getGender().isEmpty()) {
                ps.setString(6, user.getGender());
            } else {
                ps.setNull(6, Types.NVARCHAR);
            }

            if (user.getPhone() != null && !user.getPhone().isEmpty()) {
                ps.setString(7, user.getPhone());
            } else {
                ps.setNull(7, Types.NVARCHAR);
            }

            if (user.getAddress() != null && !user.getAddress().isEmpty()) {
                ps.setString(8, user.getAddress());
            } else {
                ps.setNull(8, Types.NVARCHAR);
            }

            if (user.getSportLevel() != null && !user.getSportLevel().isEmpty()) {
                ps.setString(9, user.getSportLevel());
            } else {
                ps.setNull(9, Types.NVARCHAR);
            }

            ps.setString(10, user.getRole() != null ? user.getRole() : "Customer");

            if (user.getCreatedBy() != null) {
                ps.setInt(11, user.getCreatedBy());
            } else {
                ps.setNull(11, Types.INTEGER);
            }

            // Thêm dòng này để set verify_code
            ps.setString(12, user.getVerifyCode());

            return ps.executeUpdate() > 0;
        }
    }
    // Hàm hash password đơn giản bằng MD5, giống trong servlet hoặc DAO
    private static String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
public boolean updateUserProfile1(UserDTO user) throws SQLException {
    String sql = "UPDATE Users "
               + "SET FullName = ?, Dob = ?, Gender = ?, Phone = ?, Address = ?, SportLevel = ? "
               + "WHERE UserID = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getFullName());
        if (user.getDob() != null) {
            ps.setDate(2, new java.sql.Date(user.getDob().getTime()));
        } else {
            ps.setNull(2, java.sql.Types.DATE);
        }
        ps.setString(3, user.getGender());
        ps.setString(4, user.getPhone());
        ps.setString(5, user.getAddress());
        ps.setString(6, user.getSportLevel());
        ps.setInt(7, user.getUserID());
        // executeUpdate trả về số bản ghi bị ảnh hưởng
        return ps.executeUpdate() > 0;
    }
}
public boolean insertUser(String email, String password, String code) {
        String sql = "INSERT INTO users (email, password, verify_code , is_verified) VALUES (?, ?, ?,false)";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, code);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi để dễ debug
            return false;
        }
    }
//
    public boolean verifyCode(String email, String code) {
        String sql = "SELECT * FROM users WHERE email=? AND verify_code=?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim());
            ps.setString(2, code.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String updateSql = "UPDATE users SET is_verified=1, verify_code=NULL WHERE email=? AND verify_code=?";
                    try (PreparedStatement update = conn.prepareStatement(updateSql)) {
                        update.setString(1, email.trim());
                        update.setString(2, code.trim());
                        int rows = update.executeUpdate();
                        return rows > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    // Lấy tất cả user
    public List<UserDTO> getAllUsers() throws SQLException {
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY UserID DESC";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        }
        return list;
    }

    // Tìm kiếm user theo username, email, fullname
    public List<UserDTO> searchUsers(String keyword) throws SQLException {
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE username LIKE ? OR email LIKE ? OR FullName LIKE ? ORDER BY UserID DESC";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        }
        return list;
    }

    // Thêm user đơn giản (dùng cho admin thêm user)
    public boolean addUserSimple(UserDTO user) throws SQLException {
        String sql = "INSERT INTO users (username, email, password, FullName, Dob, Gender, role, status, phone, address, SportLevel) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            
            // Xử lý Dob
            if (user.getDob() != null) {
                ps.setDate(5, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }
            
            // Xử lý Gender
            ps.setString(6, user.getGender());
            
            ps.setString(7, user.getRole());
            ps.setString(8, user.getStatus());
            ps.setString(9, user.getPhone());
            ps.setString(10, user.getAddress());
            ps.setString(11, user.getSportLevel());
            return ps.executeUpdate() > 0;
        }
    }

    // Cập nhật user đơn giản (dùng cho admin sửa user)
    public boolean updateUserSimple(UserDTO user) throws SQLException {
        String sql = "UPDATE users SET FullName=?, Dob=?, Gender=?, role=?, status=?, phone=?, address=? WHERE UserID=?";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            
            // Xử lý Dob
            if (user.getDob() != null) {
                ps.setDate(2, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(2, Types.DATE);
            }
            
            // Xử lý Gender
            ps.setString(3, user.getGender());
            
            ps.setString(4, user.getRole());
            ps.setString(5, user.getStatus());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getAddress());
            ps.setInt(8, user.getUserID());
            return ps.executeUpdate() > 0;
        }
    }
    
     public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        System.out.println("\n=== Test getAllUsers ===");
        try {
            List<UserDTO> users = userDAO.getAllUsers();
            for (UserDTO u : users) {
                System.out.println(u.getUserID() + " - " + u.getUsername() + " - " + u.getEmail());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa user theo UserID
    public boolean deleteUser(int userID) throws SQLException {
        String sql = "DELETE FROM users WHERE UserID = ?";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userID);
            return ps.executeUpdate() > 0;
        }
    }

}