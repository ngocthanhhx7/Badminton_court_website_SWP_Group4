package com.vnpay.common;

import dao.CourtScheduleDAO;
import dao.InvoiceDAO;
import dao.UserDAO;
import dao.BookingDAO;
import models.UserDTO;
import models.BookingDTO;
import models.BookingDetailDTO;
import utils.EmailUtils;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payment-result")
public class PaymentResultServlet extends HttpServlet {
    
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {        
        // Capture payment response
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // Verify signature
        String signValue = Config.hashAllFields(fields);
        boolean isValidSignature = signValue.equals(vnp_SecureHash);

        // Get parameters from request
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_BankCode = request.getParameter("vnp_BankCode");
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_PayDate = request.getParameter("vnp_PayDate");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");

        String status = "00".equals(vnp_ResponseCode) ? "SUCCESS" : "FAILURE";
        
        Long courtScheduleId = Long.parseLong(vnp_TxnRef);
        
        CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
        
        courtScheduleDAO.updateScheduleStatus(courtScheduleId, "Booked");
        
        // Gửi email xác nhận đặt sân khi thanh toán thành công
        if ("00".equals(vnp_ResponseCode)) {
            try {
                sendBookingConfirmationEmail(request, courtScheduleId, vnp_Amount, vnp_TxnRef);
            } catch (Exception e) {
                System.err.println("Failed to send confirmation email: " + e.getMessage());
                e.printStackTrace();
                // Không làm thất bại giao dịch nếu email gửi lỗi
            }
        }
        
        
        
//        InvoiceDAO invoiceDB = new InvoiceDAO();
//        int invoiceId = invoiceDB.getInvoiceIdByTxnRef(vnp_TxnRef);
//
//        // If invoice exists, store or update transaction in DB
//        if (invoiceId != -1) {
//            TransactionDBContext transactionDAO = new TransactionDBContext();
//            Transaction existingTransaction = transactionDAO.getTransactionByInvoiceId(invoiceId);
//
//            Invoice invoice = new Invoice();
//            invoice.setId(invoiceId);
//
//            Transaction transaction = new Transaction();
//            transaction.setInvoice(invoice);
//            transaction.setVnpTxnRef(vnp_TxnRef);
//            transaction.setBankCode(vnp_BankCode);
//            transaction.setPaymentMethod("VNPAYQR");
//            transaction.setPaymentUrl("https://sandbox.vnpayment.vn/transaction");
//            transaction.setStatus(status);
//            transaction.setTransactionDate(Timestamp.valueOf(LocalDateTime.now()));
//
//            if (existingTransaction != null) {
//                transactionDAO.update(transaction);
//            } else {
//                transactionDAO.insert(transaction);
//            }
//
//            if ("00".equals(vnp_ResponseCode)) {
//                invoice.setStatus("Paid");
//                invoiceDB.update(invoice);
//            }
//        }

        // Forward to JSP with payment details
        request.setAttribute("vnp_TxnRef", vnp_TxnRef);
//        request.setAttribute("invoiceId", invoiceId);
        request.setAttribute("vnp_TransactionNo", vnp_TransactionNo);
        request.setAttribute("vnp_BankCode", vnp_BankCode);
        request.setAttribute("vnp_ResponseCode", vnp_ResponseCode);
        request.setAttribute("vnp_PayDate", vnp_PayDate);
        request.setAttribute("vnp_Amount", vnp_Amount);
        request.setAttribute("vnp_OrderInfo", vnp_OrderInfo);
        request.setAttribute("status", isValidSignature ? status : "Invalid signature");

        request.getRequestDispatcher("/vnpay/vnpay_return.jsp").forward(request, response);
    }
    
    private void sendBookingConfirmationEmail(HttpServletRequest request, Long courtScheduleId, String vnp_Amount, String vnp_TxnRef) throws Exception {
        UserDAO userDAO = new UserDAO();
        BookingDAO bookingDAO = new BookingDAO();
        CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
        
        // Format số tiền
        BigDecimal amount = new BigDecimal(vnp_Amount).divide(new BigDecimal("100"));
        String formattedAmount = String.format("%,.0f", amount);
        
        // Lấy thông tin user từ session
        UserDTO user = (UserDTO) request.getSession().getAttribute("acc");
        
        String recipientEmail = "customer@gmail.com"; // Default
        String customerName = "Khách hàng"; // Default

        if (user != null) {
            // Lấy thông tin thực tế từ user
            recipientEmail = user.getEmail() != null ? user.getEmail() : "customer@gmail.com";
            customerName = user.getFullName() != null ? user.getFullName() : user.getUsername();
            
            System.out.println("Found user in session: " + customerName + " (" + recipientEmail + ")");
        } else {
            System.out.println("No user found in session, using default email info");
        }
        
        // Lấy thông tin schedule để biết court và thời gian
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
        
        // Thông tin court - có thể cải thiện bằng cách query từ courtScheduleId
        String courtName = "Sân cầu lông"; // Placeholder - cần lấy từ schedule
        String courtType = "Sân tiêu chuẩn"; // Placeholder - cần lấy từ schedule
        
        try {
            // Gửi email xác nhận với thông tin thực tế
            EmailUtils.sendBookingConfirmationEmail(
                recipientEmail,
                customerName,
                vnp_TxnRef, // Dùng transaction reference làm booking ID
                courtName,
                courtType,
                currentTime,
                currentTime,
                formattedAmount,
                "VNPay"
            );
            
            System.out.println("Booking confirmation email sent successfully to: " + recipientEmail + " for transaction: " + vnp_TxnRef);
            
        } catch (Exception e) {
            System.err.println("Failed to send confirmation email to " + recipientEmail + ": " + e.getMessage());
            throw new Exception("Email sending failed", e);
        }
    }
}
