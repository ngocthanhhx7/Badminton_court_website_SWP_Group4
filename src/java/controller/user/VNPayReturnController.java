package controller.user;

import com.vnpay.common.Config;
import dal.BookingDAO;
import dal.CourtScheduleDAO;
import dal.InvoiceDAO;
import models.BookingDTO;
import models.InvoiceDTO;

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
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import models.BookingDetailDTO;
import models.CourtScheduleDTO;

@WebServlet(name = "VNPayReturnController", urlPatterns = {"/vnpay-return"})
public class VNPayReturnController extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private InvoiceDAO invoiceDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        invoiceDAO = new InvoiceDAO();
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
        
        String idParams = (String) session.getAttribute("scheduleIds");
        List<Integer> scheduleIds = Arrays.stream(idParams.split(","))
                    .map(String::trim)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
        if (bookingId != null) {
            for (Integer scheduleId : scheduleIds) {
                scheduleDAO.updateScheduleStatus(Long.valueOf(scheduleId), "Booked");
            }
         }
        

            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            if (bookingId != null && vnp_TxnRef.equals(storedTxnRef)) {
                    bookingDAO.updateBookingStatus(bookingId, "Completed");

                    BookingDTO booking = bookingDAO.getBookingById(bookingId);
                    if (booking != null) {
                        BigDecimal amount = new BigDecimal(request.getParameter("vnp_Amount")).divide(new BigDecimal(100));

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
                    }

                    request.setAttribute("message", "Thanh toán thành công. Đơn đặt sân của bạn đã được xác nhận.");
           }
        
        request.getRequestDispatcher("payment-result.jsp").forward(request, response);
    }

}