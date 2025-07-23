package service;

import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import dao.UserDAO;
import models.UserDTO;
import org.mindrot.jbcrypt.BCrypt;

public class UserService {


    private UserDAO userDAO = new UserDAO();
    

    // Đăng ký tài khoản người dùng mới
    public boolean registerUser(String username, String email, String password, String role, String phone ) throws SQLException {
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

        // Gọi DAO để lưu vào DB
        return userDAO.registerUserBasic(user);
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
        if (BCrypt.checkpw(password, user.getPassword())) {
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

    // Validate email: must end with @gmail.com
    private void validateEmail(String email) throws IllegalArgumentException {
        if (email == null || email.trim().isEmpty() || !email.endsWith("@gmail.com") || email.equals("@gmail.com")) {
            throw new IllegalArgumentException("Email phải có đuôi @gmail.com.");
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
  public boolean UpdateEmployee(UserDTO user) throws SQLException {
        try {
            // Validate required fields
            if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
                throw new SQLException("Họ và tên không được để trống.");
            }
            if (user.getDob() == null) {
                throw new SQLException("Ngày sinh không được để trống.");
            }
            if (user.getGender() == null || user.getGender().trim().isEmpty()) {
                throw new SQLException("Giới tính không được để trống.");
            }
            if (user.getSportLevel() == null || user.getSportLevel().trim().isEmpty()) {
                throw new SQLException("Chuyên khoa không được để trống.");
            }
            if (user.getStatus() == null || user.getStatus().trim().isEmpty()) {
                throw new SQLException("Trạng thái không được để trống.");
            }

            // Map gender to match database values
            String mappedGender = user.getGender().trim();
            if (mappedGender.equals("Nam")) {
                mappedGender = "Male";
            } else if (mappedGender.equals("Nữ")) {
                mappedGender = "Female";
            } else if (mappedGender.equals("Khác")) {
                mappedGender = "Other";
            } else {
                throw new SQLException("Giới tính không hợp lệ: " + user.getGender());
            }
            user.setGender(mappedGender);

            return userDAO.UpdateEmployee(user); // Call the existing updateUser method in DAO
        } catch (SQLException e) {
            throw new SQLException("Lỗi khi cập nhật nhân viên: " + e.getMessage(), e);
        }
    }
}