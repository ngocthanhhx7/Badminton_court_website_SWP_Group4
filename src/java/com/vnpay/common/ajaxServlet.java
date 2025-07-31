/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.vnpay.common;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dal.BookingDAO;
import dal.CourtDAO;
import dal.CourtScheduleDAO;
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
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.stream.Collectors;
import models.BookingDTO;
import models.BookingDetailDTO;
import models.CourtScheduleDTO;
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
            String notes = req.getParameter("notes");
            String idsParam = req.getParameter("courtScheduleIds");
            notes = idsParam;

            List<Integer> scheduleIds = Arrays.stream(idsParam.split(","))
                    .map(String::trim)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            BookingDTO booking = BookingDTO.builder()
                    .customerId((long) user.getUserID())
                    .status("Pending")
                    .notes(notes)
                    .build();

            Long bookingId = bookingDAO.createBooking(booking);

            BigDecimal totalAmount = BigDecimal.ZERO;
            if (bookingId != null) {
                for (Integer scheduleId : scheduleIds) {
                    CourtScheduleDTO schedule = scheduleDAO.getScheduleById(scheduleId);
                    if (schedule != null) {
                        LocalDateTime start = LocalDateTime.of(schedule.getScheduleDate(), schedule.getStartTime());
                        LocalDateTime end = LocalDateTime.of(schedule.getScheduleDate(), schedule.getEndTime());

                        BigDecimal hourlyRate = new BigDecimal("100000");
                        long hours = java.time.Duration.between(schedule.getStartTime(), schedule.getEndTime()).toHours();
                        BigDecimal bookingPrice = hourlyRate.multiply(new BigDecimal(hours));

                        BookingDetailDTO detail = BookingDetailDTO.builder()
                                .bookingId(bookingId)
                                .courtId(schedule.getCourtId().longValue())
                                .startTime(start)
                                .endTime(end)
                                .hourlyRate(hourlyRate)
                                .build();

                        bookingDAO.addBookingDetail(detail);
                        totalAmount = totalAmount.add(bookingPrice);
                    }
                }
            }

            // Tạo thông tin thanh toán VNPay
            String vnp_TxnRef = String.valueOf(System.currentTimeMillis()); // unique ID
            session.setAttribute("bookingId", bookingId);
            session.setAttribute("scheduleIds", idsParam);
            session.setAttribute("vnp_TxnRef", vnp_TxnRef);

            // Tạo các param cho VNPay
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", "2.1.0");
            vnp_Params.put("vnp_Command", "pay");
            vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(totalAmount.multiply(new BigDecimal(100)).intValue()));
            vnp_Params.put("vnp_CurrCode", "VND");

            String bankCode = req.getParameter("bankCode");
            if (bankCode != null && !bankCode.isEmpty()) {
                vnp_Params.put("vnp_BankCode", bankCode);
            }

            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang: " + vnp_TxnRef);
            vnp_Params.put("vnp_OrderType", "other");

            String locate = req.getParameter("language");
            vnp_Params.put("vnp_Locale", (locate != null && !locate.isEmpty()) ? locate : "vn");
            vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", Config.getIpAddress(req));

            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));
            cld.add(Calendar.MINUTE, 15);
            vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

            // Build URL
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            for (Iterator<String> it = fieldNames.iterator(); it.hasNext();) {
                String field = it.next();
                String value = vnp_Params.get(field);
                hashData.append(field).append('=').append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                query.append(URLEncoder.encode(field, StandardCharsets.US_ASCII)).append('=')
                     .append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                if (it.hasNext()) {
                    hashData.append('&');
                    query.append('&');
                }
            }

            String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
            query.append("&vnp_SecureHash=").append(vnp_SecureHash);
            String paymentUrl = Config.vnp_PayUrl + "?" + query;

            resp.sendRedirect(paymentUrl);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("booking-form.jsp").forward(req, resp);
        }
    }
}

