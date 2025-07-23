package controller.user;

import com.vnpay.common.Config;
import dao.BookingDAO;
import dao.InvoiceDAO;
import dao.UserDAO;
import models.BookingDTO;
import models.BookingDetailDTO;
import models.InvoiceDTO;
import models.UserDTO;
import utils.EmailUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "VNPayReturnController", urlPatterns = {"/vnpay-return"})
public class VNPayReturnController extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private InvoiceDAO invoiceDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        invoiceDAO = new InvoiceDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Map<String, String> fields = new HashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String fieldName = entry.getKey();
            String fieldValue = entry.getValue()[0];
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }
        
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }
        
        String signValue = Config.hashAllFields(fields);
        
        HttpSession session = request.getSession();
        Long bookingId = (Long) session.getAttribute("bookingId");
        String storedTxnRef = (String) session.getAttribute("vnp_TxnRef");
        
        if (signValue.equals(vnp_SecureHash)) {
            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            String vnp_Amount = request.getParameter("vnp_Amount");
            String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
            String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
            
            if ("00".equals(vnp_ResponseCode)) {
                // Payment successful
                if (bookingId != null && vnp_TxnRef.equals(storedTxnRef)) {
                    // Update booking status
                    bookingDAO.updateBookingStatus(bookingId, "Confirmed");
                    
                    // Create invoice
                    BookingDTO booking = bookingDAO.getBookingById(bookingId);
                    if (booking != null) {
                        BigDecimal amount = new BigDecimal(vnp_Amount).divide(new BigDecimal("100"));
                        
                        InvoiceDTO invoice = InvoiceDTO.builder()
                            .bookingId(bookingId)
                            .customerId(booking.getCustomerId())
                            .totalAmount(amount)
                            .discount(BigDecimal.ZERO)
                            .tax(BigDecimal.ZERO)
                            .paymentMethod("VNPay")
                            .status("Paid")
                            .vnpTxnRef(vnp_TxnRef)
                            .vnpOrderInfo(vnp_OrderInfo)
                            .vnpResponseCode(vnp_ResponseCode)
                            .vnpTransactionNo(vnp_TransactionNo)
                            .build();
                        
                        invoiceDAO.createInvoice(invoice);

                    }
                    
                    request.setAttribute("message", "Payment successful! Your booking has been confirmed.");
                    request.setAttribute("bookingId", bookingId);
                    request.setAttribute("amount", new BigDecimal(vnp_Amount).divide(new BigDecimal("100")));
                } else {
                    request.setAttribute("error", "Invalid booking information");
                }
            } else {
                // Payment failed
                if (bookingId != null) {
                    bookingDAO.updateBookingStatus(bookingId, "Cancelled");
                }
                request.setAttribute("error", "Payment failed. Your booking has been cancelled.");
            }
        } else {
            request.setAttribute("error", "Invalid signature");
        }
        
        // Clear session data
        session.removeAttribute("bookingId");
        session.removeAttribute("vnp_TxnRef");
        
        request.getRequestDispatcher("payment-result.jsp").forward(request, response);
    }
}