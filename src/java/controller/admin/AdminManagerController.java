/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dao.AdminDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.AdminDTO;

/**
 *
 * @author PC - ACER
 */
@WebServlet(name="AdminManagerController", urlPatterns={"/admin-manager"})
public class AdminManagerController extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null || action.equals("list")) {
                listAdmins(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("add")) {
                showAddForm(request, response);
            } else if (action.equals("toggleStatus")) {
                toggleAdminStatus(request, response);
            } else if (action.equals("delete")) {
                deleteAdmin(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("admin-manager.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null) {
                listAdmins(request, response);
            } else if (action.equals("add")) {
                insertAdmin(request, response);
            } else if (action.equals("update")) {
                updateAdmin(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("admin-manager.jsp").forward(request, response);
        }
    }

    private void listAdmins(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String search = request.getParameter("search");
        List<AdminDTO> adminList;
        if (search != null && !search.trim().isEmpty()) {
            adminList = adminDAO.searchAdmin(search.trim());
        } else {
            adminList = adminDAO.getAllAdmin();
        }
        request.setAttribute("adminList", adminList);
        request.getRequestDispatcher("admin-manager.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int adminId = Integer.parseInt(request.getParameter("id"));
        AdminDTO admin = adminDAO.getAdminByID(adminId);
        request.setAttribute("editAdmin", admin);
        listAdmins(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        listAdmins(request, response);
    }

    private void insertAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        AdminDTO admin = new AdminDTO();
        admin.setUsername(request.getParameter("username"));
        admin.setEmail(request.getParameter("email"));
        admin.setFullName(request.getParameter("fullname"));
        admin.setPassword(request.getParameter("password")); // Nên hash ở thực tế
        boolean success = adminDAO.addAdminSimple(admin);
        if (success) {
            request.setAttribute("successMessage", "Thêm admin thành công!");
        } else {
            request.setAttribute("errorMessage", "Thêm admin thất bại!");
        }
        listAdmins(request, response);
    }

    private void updateAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int adminId = Integer.parseInt(request.getParameter("id"));
        AdminDTO admin = adminDAO.getAdminByID(adminId);
        if (admin != null) {
            admin.setFullName(request.getParameter("fullname"));
            admin.setStatus(request.getParameter("status"));
            adminDAO.updateAdminSimple(admin);
            request.setAttribute("successMessage", "Cập nhật admin thành công!");
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy admin!");
        }
        listAdmins(request, response);
    }

    private void toggleAdminStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int adminId = Integer.parseInt(request.getParameter("id"));
        AdminDTO admin = adminDAO.getAdminByID(adminId);
        if (admin != null) {
            String newStatus = admin.getStatus() != null && admin.getStatus().equals("Active") ? "Inactive" : "Active";
            admin.setStatus(newStatus);
            adminDAO.updateAdminSimple(admin);
            request.setAttribute("successMessage", "Đã đổi trạng thái admin!");
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy admin!");
        }
        listAdmins(request, response);
    }

            private void deleteAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int adminId = Integer.parseInt(request.getParameter("id"));
        boolean success = adminDAO.deleteAdmin(adminId);
        if (success) {
            request.setAttribute("successMessage", "Đã xóa admin thành công!");
        } else {
            request.setAttribute("errorMessage", "Xóa admin thất bại!");
        }
        listAdmins(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
