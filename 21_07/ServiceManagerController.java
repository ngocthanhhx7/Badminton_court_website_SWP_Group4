package controller.admin;

import dao.ServiceDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ServiceDTO;

@WebServlet(name = "ServiceManagerController", urlPatterns = {"/service-manager"})
public class ServiceManagerController extends HttpServlet {

    private ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null || action.equals("list")) {
                listServices(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("add")) {
                showAddForm(request, response);
            } else if (action.equals("toggleStatus")) {
                toggleServiceStatus(request, response);
            
            } else if (action.equals("delete")) {
                deleteService(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("service-manager.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null) {
                listServices(request, response);
            } else if (action.equals("add")) {
                insertService(request, response);
            } else if (action.equals("update")) {
                updateService(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("service-manager.jsp").forward(request, response);
        }
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String search = request.getParameter("search");
        List<ServiceDTO> serviceList;
        if (search != null && !search.trim().isEmpty()) {
            serviceList = serviceDAO.searchServices(search.trim());
        } else {
            serviceList = serviceDAO.getAllServices();
        }
        request.setAttribute("serviceList", serviceList);
        request.getRequestDispatcher("service-manager.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int serviceId = Integer.parseInt(request.getParameter("id"));
        ServiceDTO user = serviceDAO.getServiceByID(serviceId);
        request.setAttribute("editUser", user);
        listServices(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        listServices(request, response);
    }

    private void insertService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        ServiceDTO service = new ServiceDTO();
        service.setServiceName(request.getParameter("servicename"));
        service.setServiceType(request.getParameter("servicetype"));
        service.setDescription(request.getParameter("description"));
        service.setUnit(request.getParameter("unit"));

        String priceStr = request.getParameter("price");
        if (priceStr == null || priceStr.trim().isEmpty()) {
            System.err.println("Giá không được để trống.");
        } else {
            try {
                double price = Double.parseDouble(priceStr.trim());
                if (price < 1000) {
                    System.err.println("Giá phải từ 1000 trở lên.");
                } else if (price % 1000 != 0) {
                    System.err.println("Giá phải là số tròn nghìn.");
                } else {
                    service.setPrice(price);
                }
            } catch (NumberFormatException e) {
                System.err.println("Giá trị price không hợp lệ: " + priceStr);
            }
        }

        service.setStatus(request.getParameter("status"));
        boolean success = serviceDAO.addServiceSimple(service);
        if (success) {
            request.setAttribute("successMessage", "Thêm service thành công!");
        } else {
            request.setAttribute("errorMessage", "Thêm service thất bại!");
        }
        listServices(request, response);
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int serviceId = Integer.parseInt(request.getParameter("id"));
        ServiceDTO service = serviceDAO.getServiceByID(serviceId);

        if (service != null) {
            service.setServiceName(request.getParameter("servicename"));
            service.setServiceType(request.getParameter("servicetype"));
            service.setDescription(request.getParameter("description"));
            service.setUnit(request.getParameter("unit"));

            String priceStr = request.getParameter("price");
            if (priceStr == null || priceStr.trim().isEmpty()) {
                System.err.println("Giá không được để trống.");
            } else {
                try {
                    double price = Double.parseDouble(priceStr.trim());
                    if (price < 1000) {
                        System.err.println("Giá phải từ 1000 trở lên.");
                    } else if (price % 1000 != 0) {
                        System.err.println("Giá phải là số tròn nghìn.");
                    } else {
                        service.setPrice(price);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Giá trị price không hợp lệ: " + priceStr);
                }
            }

            service.setStatus(request.getParameter("status"));

            serviceDAO.updateServiceSimple(service);
            request.setAttribute("successMessage", "Cập nhật service thành công!");
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy service!");
        }

        listServices(request, response);
    }

    private void toggleServiceStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int serviceId = Integer.parseInt(request.getParameter("id"));
        ServiceDTO service = serviceDAO.getServiceByID(serviceId);
        if (service != null) {
            String newStatus = service.getStatus() != null && service.getStatus().equals("Active") ? "Inactive" : "Active";
            service.setStatus(newStatus);
            serviceDAO.updateServiceSimple(service);
            request.setAttribute("successMessage", "Đã đổi trạng thái service!");
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy service!");
        }
        listServices(request, response);
    }
    
    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int serviceId = Integer.parseInt(request.getParameter("id"));
        boolean success = serviceDAO.deleteService(serviceId);
        if (success) {
            request.setAttribute("successMessage", "Đã xóa service thành công!");
        } else {
            request.setAttribute("errorMessage", "Xóa service thất bại!");
        }
        listServices(request, response);
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
