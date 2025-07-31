package service;

import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import dal.UserDAO;
import java.security.MessageDigest;
import models.UserDTO;
import java.sql.Connection;
import org.mindrot.jbcrypt.BCrypt;
import utils.DBUtils;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserService {


    private UserDAO userDAO = new UserDAO();
    

    // Đăng ký tài khoản người dùng mới
    public boolean registerUser(String username, String email, String password, String role, String phone ) throws SQLException {
        // Debug logging
        System.out.println("UserService.registerUser - Debug values:");
        System.out.println("Username: '" + username + "'");
        System.out.println("Email: '" + email + "'");
        System.out.println("Phone: '" + phone + "' (length: " + (phone != null ? phone.length() : "null") + ")");
        System.out.println("Role: '" + role + "'");
        
        // Kiểm tra tồn tại
        if (userDAO.isEmailOrUsernameExists(email, username)) {
            return false;
        }
        if (phone != null && !phone.trim().isEmpty() && userDAO.isPhoneExists(phone)) {
            return false;
        }
        

        // Mã hóa và validate mật khẩu
        validatePassword(password);
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // Tạo đối tượng user
        UserDTO user = new UserDTO();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setRole(role);
        user.setPhone(phone);
        user.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
        user.setCreatedBy(null);

        // Debug user object
        System.out.println("UserDTO created - Phone: '" + user.getPhone() + "'");

        // Gọi DAO để lưu vào DB
        return userDAO.registerUserBasic(user);
    }

    // Kiểm tra duplicate cho từng field riêng biệt
    public String checkDuplicateFields(String username, String email, String phone) throws SQLException {
        List<String> errors = new ArrayList<>();
        
        // Kiểm tra username
        if (isUsernameExists(username)) {
            errors.add("Username đã tồn tại");
        }
        
        // Kiểm tra email
        if (isEmailExists(email)) {
            errors.add("Email đã được sử dụng");
        }
        
        // Kiểm tra phone nếu có
        if (phone != null && !phone.trim().isEmpty() && userDAO.isPhoneExists(phone)) {
            errors.add("Số điện thoại đã được sử dụng");
        }
        
        return errors.isEmpty() ? null : String.join(", ", errors);
    }
    
    public boolean isUsernameExists(String username) throws SQLException {
        return userDAO.isEmailOrUsernameExists("", username);
    }
    
    public boolean isEmailExists(String email) throws SQLException {
        return userDAO.isEmailOrUsernameExists(email, "");
    }

    // Kiểm tra username/email đã tồn tại
    public boolean isEmailOrUsernameExists(String email, String username) throws SQLException {
        return userDAO.isEmailOrUsernameExists(email, username);
    }

    // Validate phone number: must be exactly 10 digits or null/empty
    private void validatePhoneNumber(String phone) throws IllegalArgumentException {
        if (phone != null && !phone.trim().isEmpty() && !phone.matches("\\d{10}")) {
            throw new IllegalArgumentException("Phone number must be exactly 10 digits.");
        }
    }

    // Xác thực người dùng khi đăng nhập
    public UserDTO authenticateUser(String emailOrUsername, String password) throws SQLException {
    UserDTO user = userDAO.findUserByEmailOrUsername(emailOrUsername);
    if (user == null) {
        return null;
    }
    String hashed = user.getPassword();
    // Phải dùng checkpw mới xác minh được
    if (BCrypt.checkpw(password, hashed)) {
        return user;
    }
    return null;
}

    // Kiểm tra xem user đã hoàn thiện hồ sơ chưa
    public boolean isProfileComplete(UserDTO user) {
        return user.getFullName() != null && !user.getFullName().trim().isEmpty() &&
               user.getDob() != null &&
               user.getGender() != null && !user.getGender().trim().isEmpty() &&
               user.getPhone() != null && !user.getPhone().trim().isEmpty() &&
               user.getAddress() != null && !user.getAddress().trim().isEmpty();
    }

    // Cập nhật thông tin hồ sơ của user
    public void updateUserProfile(UserDTO user) throws SQLException {
        userDAO.updateUserProfile(user);
    }

    // Validate email: must end with .com
    private void validateEmail(String email) throws IllegalArgumentException {
        if (email == null || email.trim().isEmpty() || !email.endsWith(".com") || email.equals(".com")) {
            throw new IllegalArgumentException("Email phải có đuôi .com.");
        }
    }

    // Validate DOB: must not exceed current date
    private void validateDob(Date dob) throws IllegalArgumentException {
        LocalDate currentDate = LocalDate.now(); // Current date: 08:56 AM +07 on Friday, May 23, 2025
        LocalDate dobDate = dob.toLocalDate();
        if (dobDate.isAfter(currentDate)) {
            throw new IllegalArgumentException("Năm sinh không được vượt quá thời gian thực.");
        }
    }

    // Validate password: at least 6 chars
    private void validatePassword(String password) throws IllegalArgumentException {
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự.");
        }
    }
    

    // New method to update password
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        validateEmail(email);
        validatePassword(newPassword);
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return userDAO.updatePassword(email, hashedPassword);
    }

    public UserDTO getUserByID(int userID) throws SQLException {
        return userDAO.getUserByID(userID);
    }

    // New method to add user
    public boolean addUser(String fullName, String gender, Date dob, String specialization, String role, String status, String email, String phone, String address, String username, String password, int createdBy) throws SQLException {
        // Validate inputs
        validateEmail(email);
        validatePhoneNumber(phone);
        validateDob(dob);
        validatePassword(password);

        // Check for existing email, username, or phone
        if (userDAO.isEmailOrUsernameExists(email, username)) {
            return false;
        }
        if (phone != null && !phone.trim().isEmpty() && userDAO.isPhoneExists(phone)) {
            return false;
        }
        

        // Map gender to match database values
        String mappedGender = gender;
        if (mappedGender != null && !mappedGender.trim().isEmpty()) {
            mappedGender = mappedGender.trim();
            if (mappedGender.equals("Nam")) mappedGender = "Male";
            else if (mappedGender.equals("Nữ")) mappedGender = "Female";
            else if (mappedGender.equals("Khác")) mappedGender = "Other";
        } else {
            mappedGender = null; // Allow NULL as per database schema
        }

        // Create Users object
        UserDTO user = new UserDTO();
        user.setFullName(fullName);
        user.setGender(mappedGender);
        user.setDob(dob);
        user.setSportLevel(role);
        user.setRole(role);
        user.setStatus(status);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setUsername(username);
        user.setPassword(password); // Consider encrypting password here if needed
        user.setCreatedBy(createdBy);

        // Call DAO to add user
        return userDAO.addUser(user, createdBy);
    }

  public List<UserDTO> getAllEmployee() throws SQLException {
    List<UserDTO> users = userDAO.getAllEmployee();
    return users != null ? users : new ArrayList<>();
}


public UserDTO getEmpolyeeByID(int userID) throws SQLException {
    return userDAO.getEmployeeByID(userID);
}
public UserDTO getUserByEmail(String email) throws SQLException {
    return userDAO.findUserByEmailOrUsername(email); // Nếu bạn đã có hàm này trong DAO
}
public class MD5Utils {
    public static String hash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }
}
  public UserDTO loginWithEmailOrUsername(String emailOrUsername, String password) {
    String query = "SELECT * FROM Users WHERE Username = ? OR Email = ?";
    try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setString(1, emailOrUsername);
        ps.setString(2, emailOrUsername);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String storedPassword = rs.getString("Password");
                int userId = rs.getInt("UserID");

                boolean match = false;
                boolean isBCrypt = storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$");
                boolean isMD5 = storedPassword.matches("^[a-fA-F0-9]{32}$");

                // So sánh theo định dạng
                if (isBCrypt) {
                    match = BCrypt.checkpw(password, storedPassword);
                } else if (isMD5) {
                    // Kiểm tra bằng MD5
                    String md5Input = utils.MD5Utils.hash(password); // Viết hàm hash MD5 nếu chưa có
                    match = storedPassword.equals(md5Input);
                } else {
                    // Plaintext
                    match = storedPassword.equals(password);
                }

                if (match) {
                    // Nếu không phải BCrypt thì cập nhật lại
                    if (!isBCrypt) {
                        String newBCrypt = BCrypt.hashpw(password, BCrypt.gensalt(10));
                        String update = "UPDATE Users SET Password = ? WHERE UserID = ?";
                        try (PreparedStatement ps2 = conn.prepareStatement(update)) {
                            ps2.setString(1, newBCrypt);
                            ps2.setInt(2, userId);
                            ps2.executeUpdate();
                        }
                    }

                    // Trả về user
                    return new UserDTO(
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        storedPassword,
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
  
}