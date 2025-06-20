/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.sale;

import dao.BookingDAO;
import models.BookingView;
import java.util.List;

public class ViewBookingController {
    public static void main(String[] args) {
        BookingDAO dao = new BookingDAO();
        List<BookingView> bookings = dao.getAllBookingViews();

        for (BookingView b : bookings) {
            System.out.println(b);
        }
    }
}


