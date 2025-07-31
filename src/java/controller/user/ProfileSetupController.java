package controller.user;

import dal.UserDAO;
import models.UserDTO;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileSetupController", urlPatterns = {"/profile-setup-container"})
public class ProfileSetupController extends HttpServlet {
    
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(03|04|05|07|08|09)\\d{8}$");
    private static final Pattern NAME_PATTERN = Pattern.compile("^[\\p{L}\\s]{2,50}$");
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object sessionUser = session.getAttribute("currentUser");
        if (sessionUser == null) {
            sessionUser = session.getAttribute("acc");
        }
        
        if (sessionUser == null || !(sessionUser instanceof UserDTO)) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        request.getRequestDispatcher("profile-setup.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Object sessionUser = session.getAttribute("currentUser");
        if (sessionUser == null) {
            sessionUser = session.getAttribute("acc");
        }
        
        if (sessionUser == null || !(sessionUser instanceof UserDTO)) {
            response.sendRedirect("Login.jsp");
            return;
        }
        
        UserDTO user = (UserDTO) sessionUser;
        String result = validateAndUpdateUser(request, user);
        
        if (result.equals("SUCCESS")) {
            // Update user trong session
            session.setAttribute("currentUser", user);
            session.setAttribute("acc", user);
            
            // Chuyển hướng về trang home hoặc dashboard
            response.sendRedirect("home");
        } else {
            request.setAttribute("message", result);
            request.getRequestDispatcher("profile-setup.jsp").forward(request, response);
        }
    }
    
    private String validateAndUpdateUser(HttpServletRequest request, UserDTO user) {
        try {
            String fullname = request.getParameter("fullname");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String sportLevel = request.getParameter("sportlevel");
            
            // Validate fullname
            if (fullname == null || fullname.trim().isEmpty()) {
                return "Vui lòng nhập họ và tên";
            }
            fullname = fullname.trim();
            if (!NAME_PATTERN.matcher(fullname).matches()) {
                return "Họ và tên chỉ được chứa chữ cái và khoảng trắng (2-50 ký tự)";
            }
            
            // Validate date of birth
            if (dobStr == null || dobStr.trim().isEmpty()) {
                return "Vui lòng chọn ngày sinh";
            }
            Date dob;
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date utilDate = sdf.parse(dobStr);
                dob = new Date(utilDate.getTime());
                
                // Kiểm tra tuổi (phải ít nhất 13 tuổi)
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.add(java.util.Calendar.YEAR, -13);
                if (utilDate.after(cal.getTime())) {
                    return "Bạn phải ít nhất 13 tuổi để đăng ký";
                }
            } catch (ParseException e) {
                return "Ngày sinh không hợp lệ";
            }
            
            // Validate gender
            if (gender == null || gender.trim().isEmpty()) {
                return "Vui lòng chọn giới tính";
            }
            if (!gender.equals("Male") && !gender.equals("Female") && !gender.equals("Other")) {
                return "Giới tính không hợp lệ";
            }
            
            // Validate phone
            if (phone == null || phone.trim().isEmpty()) {
                return "Vui lòng nhập số điện thoại";
            }
            phone = phone.trim().replaceAll("\\s+", "");
            if (!PHONE_PATTERN.matcher(phone).matches()) {
                return "Số điện thoại không hợp lệ. Vui lòng nhập 10 chữ số bắt đầu bằng 03, 04, 05, 07, 08, 09";
            }
            
            // Validate address
            if (address == null || address.trim().isEmpty()) {
                return "Vui lòng nhập địa chỉ";
            }
            address = address.trim();
            if (address.length() < 5 || address.length() > 200) {
                return "Địa chỉ phải từ 5 đến 200 ký tự";
            }
            
            // Set sport level default if empty
            if (sportLevel == null || sportLevel.trim().isEmpty()) {
                sportLevel = "Beginner";
            }
            
            // Update user object
            user.setFullName(fullname);
            user.setDob(dob);
            user.setGender(gender);
            user.setPhone(phone);
            user.setAddress(address);
            user.setSportLevel(sportLevel);
            
            // Update in database
            if (userDAO.updateUserProfile1(user)) {
                return "SUCCESS";
            } else {
                return "Có lỗi xảy ra khi cập nhật thông tin. Vui lòng thử lại.";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.";
        }
    }
    
    public static boolean isProfileComplete(UserDTO user) {
        if (user == null) return false;
        
        return user.getFullName() != null && !user.getFullName().trim().isEmpty() &&
               user.getDob() != null &&
               user.getGender() != null && !user.getGender().trim().isEmpty() &&
               user.getPhone() != null && !user.getPhone().trim().isEmpty() &&
               user.getAddress() != null && !user.getAddress().trim().isEmpty();
    }
}
