/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.vnpay.common;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.BookingDAO;
import dao.CourtDAO;
import dao.CourtScheduleDAO;
import java.io.IOException;import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Date;
import models.BookingDTO;
import models.BookingDetailDTO;
import models.CourtDTO;
import models.UserDTO;

/**
 *
 * @author CTT VNPAY
 */
@WebServlet("/vnpayajax")
public class ajaxServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
         HttpSession session = req.getSession();
         UserDTO user = (UserDTO) session.getAttribute("acc");
         CourtScheduleDAO scheduleDAO = new CourtScheduleDAO();
         BookingDAO bookingDAO = new BookingDAO();
        if (user == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }
        try {
            Integer courtId = Integer.parseInt(req.getParameter("courtId"));
            String dateStr = req.getParameter("bookingDate");
            String startTimeStr = req.getParameter("startTime");
            String endTimeStr = req.getParameter("endTime");
            String notes = req.getParameter("notes");
            Long courtScheduleId = Long.parseLong(req.getParameter("courtScheduleId"));
            LocalDate bookingDate = LocalDate.parse(dateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);
            
            if (!scheduleDAO.isTimeSlotAvailable(courtScheduleId)) {
                req.setAttribute("error", "Selected time slot is not available");
                showBookingForm(req, resp);
                return;
            }
            // Create booking
            BookingDTO booking = BookingDTO.builder()
                .customerId(Long.valueOf(user.getUserID()))
                .status("Pending")
                .notes(notes)
                .build();
            
            Long bookingId = bookingDAO.createBooking(booking);
            
            if (bookingId != null) {
                // Create booking detail
                LocalDateTime startDateTime = LocalDateTime.of(bookingDate, startTime);
                LocalDateTime endDateTime = LocalDateTime.of(bookingDate, endTime);
                
                BookingDetailDTO detail = BookingDetailDTO.builder()
                    .bookingId(bookingId)
                    .courtId(courtId.longValue())
                    .startTime(startDateTime)
                    .endTime(endDateTime)
                    .hourlyRate(new BigDecimal("100000"))
                    .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            showBookingForm(req, resp);
        }
        
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String orderType = "other";
        
        
        long amount = 10000 * 100;
        String bankCode = req.getParameter("bankCode");
        
        String vnp_TxnRef = String.valueOf(req.getParameter("courtScheduleId"));
        String vnp_IpAddr = Config.getIpAddress(req);

        String vnp_TmnCode = Config.vnp_TmnCode;
        
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        
        if (bankCode != null && !bankCode.isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode);
        }
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);

        String locate = req.getParameter("language");
        if (locate != null && !locate.isEmpty()) {
            vnp_Params.put("vnp_Locale", locate);
        } else {
            vnp_Params.put("vnp_Locale", "vn");
        }
        vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        
        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
        resp.sendRedirect(paymentUrl);
    }
    
     private void showBookingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        CourtDAO courtDAO = new CourtDAO();
         
        String courtIdParam = request.getParameter("courtId");
        String dateParam = request.getParameter("date");
        String startTimeParam = request.getParameter("startTime");
        String endTimeParam = request.getParameter("endTime");
        String courtScheduleId = request.getParameter("courtScheduleId");
        
        if (courtIdParam != null) {
            try {
                Integer courtId = Integer.parseInt(courtIdParam);
                CourtDTO court = courtDAO.getCourtById(courtId);
                request.setAttribute("court", court);

                if (dateParam != null && !dateParam.isEmpty()) {
                    request.setAttribute("selectedDate", dateParam);
                }
                if (startTimeParam != null && !startTimeParam.isEmpty()) {
                    request.setAttribute("selectedStartTime", startTimeParam);
                }
                if (endTimeParam != null && !endTimeParam.isEmpty()) {
                    request.setAttribute("selectedEndTime", endTimeParam);
                }

                if (dateParam != null && startTimeParam != null && endTimeParam != null) {
                    request.setAttribute("fromSchedule", true);
                }
                if(courtScheduleId != null && !courtScheduleId.isEmpty()){
                    request.setAttribute("courtScheduleId", courtScheduleId);
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid court ID");
            }
        }

        request.setAttribute("now", new Date());
        request.getRequestDispatcher("booking-form.jsp").forward(request, response);
    }

}
