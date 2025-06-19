package controllerAdmin;

import dao.UserDAO;
import models.UserDTO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="UserManagerController", urlPatterns={"/user-manager"})
public class UserManagerController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null || action.equals("list")) {
                listUsers(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("add")) {
                showAddForm(request, response);
            } else if (action.equals("toggleStatus")) {
                toggleUserStatus(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("user-manager.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null) {
                listUsers(request, response);
            } else if (action.equals("add")) {
                insertUser(request, response);
            } else if (action.equals("update")) {
                updateUser(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("user-manager.jsp").forward(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String search = request.getParameter("search");
        List<UserDTO> userList;
        if (search != null && !search.trim().isEmpty()) {
            userList = userDAO.searchUsers(search.trim());
        } else {
            userList = userDAO.getAllUsers();
        }
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("user-manager.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("id"));
        UserDTO user = userDAO.getUserByID(userId);
        request.setAttribute("editUser", user);
        listUsers(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        listUsers(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        UserDTO user = new UserDTO();
        user.setUsername(request.getParameter("username"));
        user.setEmail(request.getParameter("email"));
        user.setFullName(request.getParameter("fullname"));
        
        // Xử lý Date of Birth
        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                java.sql.Date dob = java.sql.Date.valueOf(dobStr);
                user.setDob(dob);
            } catch (Exception e) {
                // Nếu có lỗi parse date, bỏ qua
            }
        }
        
        // Xử lý Gender
        String gender = request.getParameter("gender");
        if (gender != null && !gender.trim().isEmpty()) {
            user.setGender(gender);
        }
        
        user.setRole(request.getParameter("role"));
        user.setStatus(request.getParameter("status"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        user.setSportLevel("Beginner");
        user.setPassword(request.getParameter("password")); // Nên hash ở thực tế
        boolean success = userDAO.addUserSimple(user);
        if (success) {
            request.setAttribute("successMessage", "Thêm user thành công!");
        } else {
            request.setAttribute("errorMessage", "Thêm user thất bại!");
        }
        listUsers(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("id"));
        UserDTO user = userDAO.getUserByID(userId);
        if (user != null) {
            user.setFullName(request.getParameter("fullname"));
            
            // Xử lý Date of Birth
            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    java.sql.Date dob = java.sql.Date.valueOf(dobStr);
                    user.setDob(dob);
                } catch (Exception e) {
                    // Nếu có lỗi parse date, bỏ qua
                }
            }
            
            // Xử lý Gender
            String gender = request.getParameter("gender");
            if (gender != null && !gender.trim().isEmpty()) {
                user.setGender(gender);
            }
            
            user.setRole(request.getParameter("role"));
            user.setStatus(request.getParameter("status"));
            user.setPhone(request.getParameter("phone"));
            user.setAddress(request.getParameter("address"));
            userDAO.updateUserSimple(user);
            request.setAttribute("successMessage", "Cập nhật user thành công!");
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy user!");
        }
        listUsers(request, response);
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("id"));
        UserDTO user = userDAO.getUserByID(userId);
        if (user != null) {
            String newStatus = user.getStatus() != null && user.getStatus().equals("Active") ? "Inactive" : "Active";
            user.setStatus(newStatus);
            userDAO.updateUserSimple(user);
            request.setAttribute("successMessage", "Đã đổi trạng thái user!");
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy user!");
        }
        listUsers(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
