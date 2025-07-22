/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.user;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;



import dao.CartItemDAO;
import dao.CourtScheduleDAO;
import dao.CartsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.CartItemsDTO;
import models.CourtScheduleDTO;
import models.CartsDTO;
import models.UserDTO;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            CartItemDAO cartItemDAO = new CartItemDAO();
            CourtScheduleDAO scheduleDAO = new CourtScheduleDAO();

            List<CartItemsDTO> cartItems = cartItemDAO.getListCartItemByUserID(user.getUserID());
            List<Integer> ids = cartItems.stream().map(CartItemsDTO::getScheduleID).toList();

            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

            // Map lịch theo ScheduleID từ cart
            Map<Integer, CourtScheduleDTO> scheduleMap = new HashMap<>();
            for (CartItemsDTO item : cartItems) {
                CourtScheduleDTO schedule = scheduleDAO.getScheduleById(item.getScheduleID());
                if (schedule != null) {
                    if (schedule.getStartTime() != null) {
                        schedule.setStartTimeStr(schedule.getStartTime().format(timeFormatter));
                    }
                    if (schedule.getEndTime() != null) {
                        schedule.setEndTimeStr(schedule.getEndTime().format(timeFormatter));
                    }

                    scheduleMap.put(item.getCartItemID(), schedule);
                }
            }

            String idString = ids.stream()
                     .map(String::valueOf)
                     .collect(Collectors.joining(","));
            request.setAttribute("courtScheduleIds", idString);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("scheduleMap", scheduleMap);

            request.getRequestDispatcher("view-cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
           
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");
        CartItemDAO cartItemDAO = new CartItemDAO();
        CartsDAO cartsDAO = new CartsDAO();

        try {
            if ("create".equalsIgnoreCase(action)) {
                Long scheduleId = Long.parseLong(request.getParameter("scheduleId"));
                Double price = Double.parseDouble(request.getParameter("price"));
                CartsDTO cart = cartsDAO.getActiveCartByUserId(user.getUserID());
                if (cart == null) {
                    cart = new CartsDTO();
                    cart.setUserID(user.getUserID());
                    cart.setStatus("Active");
                    cart.setCreatedAt(LocalDateTime.now());
                    int cartId = cartsDAO.createCart(cart);
                    cart.setCartID(cartId);
                }
                
                if(!cartsDAO.existsBySchedulerIdAndUserID(scheduleId.intValue(), user.getUserID())){
                    CartItemsDTO item = new CartItemsDTO();
                    item.setCartID(cart.getCartID());
                    item.setScheduleID(scheduleId.intValue());
                    item.setPrice(price);
                    item.setCreatedAt(LocalDateTime.now());
                    cartItemDAO.createCartItem(item);

                }
               
                response.sendRedirect("CartServlet");

            } else if ("delete".equalsIgnoreCase(action)) {
                int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
                cartItemDAO.deleteCartItem(cartItemId);
                response.sendRedirect("CartServlet");

            } else if ("clear".equalsIgnoreCase(action)) {
                // Tùy bạn có thêm hàm clearCartItemsByUserID nếu muốn
                // cartItemDAO.clearCartItemsByUserID(user.getUserID());
                response.sendRedirect("CartServlet");
            } else {
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
