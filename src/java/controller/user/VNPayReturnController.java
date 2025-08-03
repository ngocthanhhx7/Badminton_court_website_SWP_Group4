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

        try {
            System.out.println("VNPayReturnController - Processing payment return...");
            
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
            
            System.out.println("BookingId from session: " + bookingId);
            System.out.println("StoredTxnRef: " + storedTxnRef);
            
            // If no booking info in session, try to handle the payment result anyway
            if (bookingId == null) {
                System.out.println("WARNING: No bookingId found in session. Payment may be from external redirect.");
            }
            
            // Handle schedule IDs safely
            String idParams = (String) session.getAttribute("scheduleIds");
            if (idParams != null && bookingId != null) {
                try {
                    List<Integer> scheduleIds = Arrays.stream(idParams.split(","))
                                .map(String::trim)
                                .map(Integer::parseInt)
                                .collect(Collectors.toList());
                    
                    for (Integer scheduleId : scheduleIds) {
                        scheduleDAO.updateScheduleStatus(Long.valueOf(scheduleId), "Booked");
                    }
                    System.out.println("Updated schedule status for IDs: " + idParams);
                } catch (Exception e) {
                    System.err.println("Error updating schedule status: " + e.getMessage());
                }
            }

            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            
            System.out.println("VNP ResponseCode: " + vnp_ResponseCode);
            System.out.println("VNP TxnRef: " + vnp_TxnRef);
            
            // Check if payment was successful
            if ("00".equals(vnp_ResponseCode)) {
                System.out.println("Payment successful - ResponseCode: 00");
                
                if (bookingId != null && vnp_TxnRef != null && vnp_TxnRef.equals(storedTxnRef)) {
                    System.out.println("Processing booking with session data");
                    // Process with full session data - original logic
                    processBookingWithSession(request, bookingId, vnp_TxnRef, vnp_ResponseCode);
                } else {
                    System.out.println("Processing payment without complete session data");
                    // Handle case where session data is missing
                    processPaymentWithoutSession(request, vnp_TxnRef, vnp_ResponseCode);
                }
                
                request.setAttribute("message", "Thanh toán thành công. Đơn đặt sân của bạn đã được xác nhận.");
                System.out.println("Payment processed successfully");
            } else {
                System.out.println("Payment failed or invalid. ResponseCode: " + vnp_ResponseCode);
                request.setAttribute("error", "Thanh toán không thành công. Mã lỗi: " + vnp_ResponseCode);
            }
            
        } catch (Exception e) {
            System.err.println("Critical error in VNPayReturnController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi nghiêm trọng xảy ra: " + e.getMessage());
        }
        
        // Forward to payment result page
            request.getRequestDispatcher("payment-result-final.jsp").forward(request, response);
    }
    
    // Process booking when we have complete session data
    private void processBookingWithSession(HttpServletRequest request, Long bookingId, String vnp_TxnRef, String vnp_ResponseCode) {
        try {
            // Update booking status
            bookingDAO.updateBookingStatus(bookingId, "Completed");
            System.out.println("Updated booking status to Completed for booking: " + bookingId);

            BookingDTO booking = bookingDAO.getBookingById(bookingId);
            if (booking != null) {
                // Handle vnp_Amount safely
                String vnpAmountStr = request.getParameter("vnp_Amount");
                System.out.println("vnp_Amount parameter: " + vnpAmountStr);
                
                BigDecimal amount = BigDecimal.ZERO;
                if (vnpAmountStr != null && !vnpAmountStr.trim().isEmpty()) {
                    try {
                        amount = new BigDecimal(vnpAmountStr).divide(new BigDecimal(100));
                        System.out.println("Parsed amount: " + amount);
                    } catch (NumberFormatException e) {
                        System.err.println("Error parsing vnp_Amount: " + vnpAmountStr + " - " + e.getMessage());
                        amount = BigDecimal.ZERO;
                    }
                } else {
                    System.err.println("vnp_Amount parameter is null or empty, using zero");
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
                System.out.println("Created invoice for booking: " + bookingId);
                
                // Get complete booking information for display (with error handling)
                BookingDTO completeBooking = booking; // Default fallback
                try {
                    List<BookingDTO> customerBookings = bookingDAO.getAllBookingHistoryByCustomer(booking.getCustomerId());
                    completeBooking = customerBookings.stream()
                            .filter(b -> b.getBookingId().equals(bookingId))
                            .findFirst()
                            .orElse(booking);
                    System.out.println("Retrieved complete booking information");
                } catch (Exception e) {
                    System.err.println("Error getting complete booking info, using basic booking: " + e.getMessage());
                }
                
                // Send booking confirmation email after successful payment (with error handling)
                try {
                    sendBookingConfirmationEmail(booking, amount);
                    System.out.println("Email confirmation sent successfully");
                } catch (Exception e) {
                    System.err.println("Error sending confirmation email: " + e.getMessage());
                    e.printStackTrace();
                }
                
                // Set booking info for display on result page
                request.setAttribute("booking", completeBooking);
                request.setAttribute("amount", amount);
                request.setAttribute("paymentMethod", "VNPay");
                request.setAttribute("transactionNo", request.getParameter("vnp_TransactionNo"));
            }
        } catch (Exception e) {
            System.err.println("Error processing booking with session: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý thanh toán: " + e.getMessage());
        }
    }
    
    // Process payment when session data is missing (fallback)
    private void processPaymentWithoutSession(HttpServletRequest request, String vnp_TxnRef, String vnp_ResponseCode) {
        try {
            System.out.println("Attempting to process payment without complete session data");
            
            // Set basic payment info for display - handle null amount safely
            String vnpAmountStr = request.getParameter("vnp_Amount");
            System.out.println("vnp_Amount parameter: " + vnpAmountStr);
            
            // If vnp_Amount is null, try to parse from query string
            if (vnpAmountStr == null) {
                String queryString = request.getQueryString();
                if (queryString != null) {
                    System.out.println("Attempting to parse vnp_Amount from query string: " + queryString);
                    
                    // Try normal parsing first
                    String[] params = queryString.split("&");
                    for (String param : params) {
                        if (param.contains("vnp_Amount=")) {
                            String[] parts = param.split("=");
                            if (parts.length >= 2) {
                                vnpAmountStr = parts[1];
                                System.out.println("Extracted vnp_Amount: " + vnpAmountStr);
                                break;
                            }
                        }
                    }
                    
                    // If still null, try alternative parsing for malformed URLs like "np_Amount="
                    if (vnpAmountStr == null && queryString.contains("np_Amount=")) {
                        int startIndex = queryString.indexOf("np_Amount=") + 10;
                        int endIndex = queryString.indexOf("&", startIndex);
                        if (endIndex == -1) endIndex = queryString.length();
                        vnpAmountStr = queryString.substring(startIndex, endIndex);
                        System.out.println("Alternative extraction vnp_Amount: " + vnpAmountStr);
                    }
                }
            }
            
            BigDecimal amount = BigDecimal.ZERO;
            if (vnpAmountStr != null && !vnpAmountStr.trim().isEmpty()) {
                try {
                    amount = new BigDecimal(vnpAmountStr).divide(new BigDecimal(100));
                    System.out.println("Parsed amount: " + amount);
                } catch (NumberFormatException e) {
                    System.err.println("Error parsing vnp_Amount: " + vnpAmountStr + " - " + e.getMessage());
                    amount = BigDecimal.ZERO;
                }
            } else {
                System.err.println("vnp_Amount parameter is null or empty");
            }
            
            request.setAttribute("amount", amount);
            request.setAttribute("paymentMethod", "VNPay");
            request.setAttribute("transactionNo", request.getParameter("vnp_TransactionNo"));
            request.setAttribute("vnpTxnRef", vnp_TxnRef);
            
            System.out.println("Set basic payment information for display");
            
            // Try to find booking by vnp_TxnRef and update it
            try {
                if (vnp_TxnRef != null) {
                    // You can add logic here to search booking by transaction reference
                    // For now, we'll just log that we need this functionality
                    System.out.println("TODO: Search and update booking by vnp_TxnRef: " + vnp_TxnRef);
                }
            } catch (Exception e) {
                System.err.println("Error searching booking by vnp_TxnRef: " + e.getMessage());
            }
            
        } catch (Exception e) {
            System.err.println("Error processing payment without session: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý thông tin thanh toán: " + e.getMessage());
        }
    }
    
    // Helper method to send booking confirmation email after successful payment
    private void sendBookingConfirmationEmail(BookingDTO booking, BigDecimal amount) {
        try {
            // Get customer information
            UserDTO customer = userDAO.getUserByID(booking.getCustomerId().intValue());
            if (customer == null) {
                System.err.println("Customer not found for booking: " + booking.getBookingId());
                return;
            }
            
            // Get booking details to find court information
            List<BookingDetailDTO> bookingDetails = bookingDAO.getBookingDetails(booking.getBookingId());
            if (bookingDetails.isEmpty()) {
                System.err.println("No booking details found for booking: " + booking.getBookingId());
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
            
            // Send email confirmation to customer only
            EmailUtils.sendBookingConfirmationEmail(
                customer.getEmail(),
                customer.getFullName(),
                booking.getBookingId().toString(),
                courtName,
                courtType,
                startTimeFormatted,
                endTimeFormatted,
                String.format("%,.0f", amount),
                "VNPay"
            );
            
            System.out.println("Booking confirmation email sent to customer: " + customer.getEmail());
            
        } catch (Exception e) {
            System.err.println("Failed to send booking confirmation email: " + e.getMessage());
            e.printStackTrace();
            // Don't break the payment process if email fails
        }
    }

}