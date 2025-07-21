

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import models.CartsDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import models.CartsDTO;
import utils.DBUtils;

public class CartsDAO {
    
     private static final String CREATE_CART = 
        "INSERT INTO Carts (UserID, Status, CreatedAt) VALUES (?, ?, ?)";

    public int createCart(CartsDTO cart) throws SQLException {
        int generatedCartId = -1;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(CREATE_CART, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, cart.getUserID());
            ps.setString(2, cart.getStatus());
            ps.setTimestamp(3, java.sql.Timestamp.valueOf(cart.getCreatedAt()));
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedCartId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedCartId;
    }
    
    public CartsDTO getActiveCartByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM Carts WHERE UserID = ? AND Status = 'Active'";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CartsDTO cart = new CartsDTO();
                    cart.setCartID(rs.getInt("CartID"));
                    cart.setUserID(rs.getInt("UserID"));
                    cart.setStatus(rs.getString("Status"));
                    cart.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    return cart;
                }
            }
        }
        return null;
    }

    

    public boolean existsBySchedulerIdAndUserID(int scheduleId, int userId) throws SQLException {
        String sql = "SELECT 1 FROM CartItems ci " +
                     "JOIN Carts c ON ci.CartID = c.CartID " +
                     "WHERE ci.ScheduleID = ? AND c.UserID = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, scheduleId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // if any row exists, return true
            }
        }
    }
}
