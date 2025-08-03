package controller.user;

import com.vnpay.common.Config;
import dao.BookingDAO;
import dao.CourtDAO;
import dao.CourtScheduleDAO;
import dao.InvoiceDAO;
import dao.UserDAO;
import models.BookingDTO;
import models.InvoiceDTO;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import models.BookingDetailDTO;
import models.BookingServiceDTO;
import models.CourtDTO;
import models.CourtScheduleDTO;
import models.UserDTO;

@WebServlet(name = "VNPayReturnController", urlPatterns = {"/vnpay-return"})
public class VNPayReturnController extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private InvoiceDAO invoiceDAO;
    private CourtDAO courtDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        invoiceDAO = new InvoiceDAO();
        courtDAO = new CourtDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, String> fields = new HashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            fields.put(entry.getKey(), entry.getValue()[0]);
        }

        String vnp_SecureHash = fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        String signValue = Config.hashAllFields(fields);
        CourtScheduleDAO scheduleDAO = new CourtScheduleDAO();

        HttpSession session = request.getSession();
        Long bookingId = (Long) session.getAttribute("bookingId");
        String storedTxnRef = (String) session.getAttribute("vnp_TxnRef");
        
        // Handle schedule IDs
        String idParams = (String) session.getAttribute("scheduleIds");
        if (idParams != null && bookingId != null) {
            List<Integer> scheduleIds = Arrays.stream(idParams.split(","))
                        .map(String::trim)
                        .map(Integer::parseInt)
                        .collect(Collectors.toList());
            
            for (Integer scheduleId : scheduleIds) {
                scheduleDAO.updateScheduleStatus(Long.valueOf(scheduleId), "Booked");
            }
        }

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        
        // Check if payment was successful
        if ("00".equals(vnp_ResponseCode)) {
            if (bookingId != null && vnp_TxnRef != null && vnp_TxnRef.equals(storedTxnRef)) {
                // Process booking
                BookingDTO booking = bookingDAO.getBookingById(bookingId);
                if (booking != null) {
                    bookingDAO.updateBookingStatus(bookingId, "Completed");
                    
                    // Handle vnp_Amount
                    String vnpAmountStr = request.getParameter("vnp_Amount");
                    BigDecimal amount = BigDecimal.ZERO;
                    if (vnpAmountStr != null && !vnpAmountStr.trim().isEmpty()) {
                        amount = new BigDecimal(vnpAmountStr).divide(new BigDecimal(100));
                    }

                    // Create invoice
                    InvoiceDTO invoice = InvoiceDTO.builder()
                            .bookingId(bookingId)
                            .customerId(booking.getCustomerId())
                            .totalAmount(amount)
                            .discount(BigDecimal.ZERO)
                            .tax(BigDecimal.ZERO)
                            .paymentMethod("VNPay")
                            .status("Paid")
                            .vnpTxnRef(vnp_TxnRef)
                            .vnpOrderInfo(request.getParameter("vnp_OrderInfo"))
                            .vnpResponseCode(vnp_ResponseCode)
                            .vnpTransactionNo(request.getParameter("vnp_TransactionNo"))
                            .build();

                    invoiceDAO.createInvoice(invoice);
                    
                    // Send booking confirmation email
                    sendBookingConfirmationEmail(booking, amount);
                    
                    request.setAttribute("booking", booking);
                    request.setAttribute("amount", amount);
                    request.setAttribute("paymentMethod", "VNPay");
                    request.setAttribute("transactionNo", request.getParameter("vnp_TransactionNo"));
                }
            }
            
            request.setAttribute("message", "Thanh toán thành công. Đơn đặt sân của bạn đã được xác nhận.");
        } else {
            request.setAttribute("error", "Thanh toán không thành công. Mã lỗi: " + vnp_ResponseCode);
        }
        
        request.getRequestDispatcher("payment-result-final.jsp").forward(request, response);
    }
    
    private void sendBookingConfirmationEmail(BookingDTO booking, BigDecimal amount) {
        try {
            // Get customer information
            UserDTO customer = userDAO.getUserByID(booking.getCustomerId().intValue());
            if (customer == null) {
                return;
            }
            
            // Get booking details to find court information
            List<BookingDetailDTO> bookingDetails = bookingDAO.getBookingDetails(booking.getBookingId());
            if (bookingDetails.isEmpty()) {
                return;
            }
            
            // Get first booking detail (assuming one court per booking for now)
            BookingDetailDTO firstDetail = bookingDetails.get(0);
            CourtDTO court = courtDAO.getCourtById(firstDetail.getCourtId().intValue());
            
            String courtName = court != null ? court.getCourtName() : "Unknown Court";
            String courtType = court != null ? court.getCourtType() : "Unknown Type";
            
            // Format time strings
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
            String startTimeFormatted = firstDetail.getStartTime().format(timeFormatter);
            String endTimeFormatted = firstDetail.getEndTime().format(timeFormatter);
            
            // Format amount
            String formattedAmount = String.format("%,.0f", amount);
            
            // Send email confirmation to customer only
            EmailUtils.sendBookingConfirmationEmail(
                customer.getEmail(),
                customer.getFullName(),
                booking.getBookingId().toString(),
                courtName,
                courtType,
                startTimeFormatted,
                endTimeFormatted,
                formattedAmount,
                "VNPay"
            );
            
        } catch (Exception e) {
            System.err.println("Failed to send booking confirmation email: " + e.getMessage());
            // Don't break the payment process if email fails
        }
    }
}