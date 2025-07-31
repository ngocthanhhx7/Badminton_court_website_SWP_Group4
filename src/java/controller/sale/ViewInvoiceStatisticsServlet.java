package controller.sale;

import dao.InvoiceDetailDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/invoice-statistics")
public class ViewInvoiceStatisticsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

       InvoiceDetailDAO dao = new InvoiceDetailDAO();
Map<String, Integer> itemQtyStats = dao.getItemNameTotalQuantity();
request.setAttribute("itemQtyStats", itemQtyStats);
request.getRequestDispatcher("invoice-statistics.jsp").forward(request, response);

    }
}
