package dal;

import models.AdminDTO;
import utils.DBUtils;
import java.sql.Timestamp;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    private Connection conn;

    public AdminDAO() {
        this.conn = DBUtils.getConnection();
    }

    public AdminDTO login(String username, String password) {
        String query = "SELECT * FROM Admins WHERE Username = ? AND Password = ?";
        try (Connection conn = new DBUtils().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
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
        try (Connection conn = new DBUtils().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public AdminDTO loginWithEmailOrUsername(String input, String password) {
        String query = "SELECT * FROM Admins WHERE (Username = ? OR Email = ?) AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, input);
            ps.setString(2, input);
            ps.setString(3, password);
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

    private void validateEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty() || !email.endsWith(".com") || email.equals(".com")) {
            throw new SQLException("Email phải có đuôi .com.");
        }
    }

    private void validatePassword(String password) throws SQLException {
        if (password == null || password.length() < 8
                || !password.matches("^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d).+$")) {
            throw new SQLException("Mật khẩu phải có ít nhất 8 ký tự, 1 chữ cái in hoa, 1 ký tự đặc biệt và 1 số.");
        }
    }

    public boolean registerAdmin(AdminDTO admin) throws SQLException {
        String sql = "INSERT INTO Admins (Username, [Password], Email, FullName, [Status], verify_code) "
                + "VALUES (?, ?, ?, 'Active', ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getPassword());
            ps.setString(3, admin.getEmail());

            if (admin.getFullName() != null && !admin.getFullName().isEmpty()) {
                ps.setString(4, admin.getFullName());
            } else {
                ps.setNull(4, Types.NVARCHAR);
            }

            // Thêm dòng này để set verify_code
            ps.setString(12, admin.getVerifyCode());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        validateEmail(email);
        validatePassword(newPassword);
        String sql = "UPDATE Admins SET Password = ?, UpdatedAt = GETDATE() WHERE Email = ?";
        try (Connection conn = new DBUtils().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    public AdminDTO getAdminByID(int adminID) throws SQLException {
        String sql = "SELECT * FROM admins WHERE AdminID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
        }
        return null;
    }
        private AdminDTO mapResultSetToAdmin(ResultSet rs) throws SQLException {
        AdminDTO admin = new AdminDTO();
        admin.setAdminID(rs.getInt("AdminID"));
        admin.setUsername(rs.getString("Username"));
        admin.setEmail(rs.getString("Email"));
        admin.setPassword(rs.getString("Password"));
        
        
        admin.setFullName(rs.getString("FullName"));
       
        admin.setStatus(rs.getString("Status"));
        return admin;
    }

    public List<AdminDTO> getAllAdmin() throws SQLException {
        List<AdminDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM admins ORDER BY AdminID ASC";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAdmin(rs));
            }
        }
        return list;
    }
        // Tìm kiếm theo username, email, fullname
    public List<AdminDTO> searchAdmin(String keyword) throws SQLException {
        List<AdminDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM admins WHERE username LIKE ? OR email LIKE ? OR FullName LIKE ? ORDER BY AdminID ASC";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAdmin(rs));
            }
        }
        return list;
    }

    public boolean updateAdmin(AdminDTO admin) throws SQLException {
        String sql = "UPDATE Admins SET Username = ?, Password = ?, FullName = ?, Email = ?, Status = ?, UpdatedAt = GETDATE() WHERE AdminID = ?";
        try (Connection conn = new DBUtils().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getPassword());
            stmt.setString(3, admin.getFullName());
            stmt.setString(4, admin.getEmail());
            stmt.setString(5, admin.getStatus());
            stmt.setInt(6, admin.getAdminID());
            return stmt.executeUpdate() > 0;
        }
    }
        // Cập nhật 
    public boolean updateAdminSimple(AdminDTO admin) throws SQLException {
        String sql = "UPDATE admins SET FullName=?, status=? WHERE AdminID=?";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setString(1, admin.getFullName());
            ps.setString(2, admin.getStatus());
            ps.setInt(3, admin.getAdminID());
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean addAdminSimple(AdminDTO admin) throws SQLException {
        String sql = "INSERT INTO admins (username, email, password, FullName, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getEmail());
            ps.setString(3, admin.getPassword());
            ps.setString(4, admin.getFullName());
            ps.setString(5, admin.getStatus());
            return ps.executeUpdate() > 0;
        }
    }
    public boolean insertAdmin(String email, String password, String code) {
        String sql = "INSERT INTO admins (email, password, verify_code , is_verified) VALUES (?, ?, ?,false)";
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
    }
        
    public boolean verifyCode(String email, String code) {
        String sql = "SELECT * FROM admins WHERE email=? AND verify_code=?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim());
            ps.setString(2, code.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String updateSql = "UPDATE admins SET is_verified=1, verify_code=NULL WHERE email=? AND verify_code=?";
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
    
    
        public boolean deleteAdmin(int adminID) throws SQLException {
        String sql = "DELETE FROM admins WHERE AdminID = ?";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setInt(1, adminID);
            return ps.executeUpdate() > 0;
        }
    }
}
