package controller.sale;

import dao.InvoiceDetailDAO;
import models.InvoiceDetailView;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/view-invoice-details")
public class ViewInvoiceDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        final int PAGE_SIZE = 5;

        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");
        int page = 1;

        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        InvoiceDetailDAO dao = new InvoiceDetailDAO();
        List<InvoiceDetailView> list;
        int totalItems;
        int totalPages;

        if (keyword != null && !keyword.trim().isEmpty()) {
            totalItems = dao.countSearchResults(keyword);
            totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
            if (page > totalPages) page = totalPages;
            if (page < 1) page = 1;

            list = dao.searchByCustomerName(keyword, page, PAGE_SIZE);
        } else {
            totalItems = dao.getTotalInvoiceDetailCount();
            totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
            if (page > totalPages) page = totalPages;
            if (page < 1) page = 1;

            list = dao.getInvoiceDetailsByPage(page, PAGE_SIZE);
        }

        request.setAttribute("invoiceDetails", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("view-invoice-details.jsp").forward(request, response);
    }
}



