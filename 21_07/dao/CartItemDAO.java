/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.CartItemsDTO;
import models.CartsDTO;
import utils.DBUtils;
/**
 *
 * @author Admin
 */
public class CartItemDAO {
     private static final String CREATE_CART_ITEM =
        "INSERT INTO CartItems (CartID, ScheduleID, Price, CreatedAt) VALUES (?, ?, ?, ?)";

    private static final String DELETE_CART_ITEM =
        "DELETE FROM CartItems WHERE CartItemID = ?";

    private static final String GET_CART_ITEMS_BY_USER_ID = 
        "SELECT ci.* FROM CartItems ci " +
        "JOIN Carts c ON ci.CartID = c.CartID " +
        "WHERE c.UserID = ? AND c.Status = 'Active'"; // bạn có thể đổi điều kiện này tùy theo logic hệ thống

    // Tạo mới 1 cart item
    public int createCartItem(CartItemsDTO item) throws SQLException {
        int generatedId = -1;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(CREATE_CART_ITEM, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, item.getCartID());
            ps.setInt(2, item.getScheduleID());
            ps.setDouble(3, item.getPrice());
            ps.setTimestamp(4, Timestamp.valueOf(item.getCreatedAt()));

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedId;
    }

    // Xóa cart item theo ID
    public boolean deleteCartItem(int cartItemId) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_CART_ITEM)) {

            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;
        }
    }

    // Lấy danh sách cart items theo userID
    public List<CartItemsDTO> getListCartItemByUserID(int userId) throws SQLException {
        List<CartItemsDTO> list = new ArrayList<>();

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_CART_ITEMS_BY_USER_ID)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItemsDTO item = new CartItemsDTO();
                    item.setCartItemID(rs.getInt("CartItemID"));
                    item.setCartID(rs.getInt("CartID"));
                    item.setScheduleID(rs.getInt("ScheduleID"));
                    item.setPrice(rs.getDouble("Price"));
                    item.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());

                    list.add(item);
                }
            }
        }

        return list;
    }
}
