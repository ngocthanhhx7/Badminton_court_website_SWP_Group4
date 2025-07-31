package controller.sale;

import dal.InvoiceDetailDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/update-status")
public class UpdateStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String page = request.getParameter("page");

        InvoiceDetailDAO dao = new InvoiceDetailDAO();
        dao.updateStatus(id, status);  // Cập nhật vào DB

        // Chuyển hướng về trang chính với từ khóa và trang hiện tại
        response.sendRedirect("view-invoice-details?page=" + page + "&keyword=" + keyword);
    }
}
