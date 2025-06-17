package dao;

import models.OfferDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OfferDAO {

    private static final String GET_ALL_OFFERS = "SELECT * FROM Offers ORDER BY OfferID DESC";
    private static final String GET_ACTIVE_OFFERS = "SELECT * FROM Offers WHERE IsActive = 1 ORDER BY OfferID ASC";
    private static final String GET_OFFER_BY_ID = "SELECT * FROM Offers WHERE OfferID = ?";
    private static final String ADD_OFFER = "INSERT INTO Offers (Title, Subtitle, Description, ImageUrl, Capacity, IsVIP, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_OFFER = "UPDATE Offers SET Title = ?, Subtitle = ?, Description = ?, ImageUrl = ?, Capacity = ?, IsVIP = ?, IsActive = ? WHERE OfferID = ?";
    private static final String DELETE_OFFER = "DELETE FROM Offers WHERE OfferID = ?";
    private static final String TOGGLE_STATUS = "UPDATE Offers SET IsActive = ~IsActive WHERE OfferID = ?";
    
    // Queries for pagination, filtering, and search (SQL Server)
    private static final String COUNT_ALL_OFFERS = "SELECT COUNT(*) FROM Offers";
    private static final String COUNT_FILTERED_OFFERS = "SELECT COUNT(*) FROM Offers WHERE (? IS NULL OR IsActive = ?) AND (? IS NULL OR Title LIKE ?) AND (? IS NULL OR IsVIP = ?)";
    private static final String GET_OFFERS_WITH_FILTERS = "SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY %s) AS RowNum, * FROM Offers WHERE (? IS NULL OR IsActive = ?) AND (? IS NULL OR Title LIKE ?) AND (? IS NULL OR IsVIP = ?)) AS PagedResults WHERE RowNum BETWEEN ? AND ?";

    public List<OfferDTO> getAllOffers() throws SQLException {
        List<OfferDTO> offers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_ALL_OFFERS);
            rs = ptm.executeQuery();
            while (rs.next()) {
                offers.add(mapResultSetToOffer(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return offers;
    }

    public List<OfferDTO> getActiveOffers() throws SQLException {
        List<OfferDTO> offers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_ACTIVE_OFFERS);
            rs = ptm.executeQuery();
            while (rs.next()) {
                offers.add(mapResultSetToOffer(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return offers;
    }

    public OfferDTO getOfferById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(GET_OFFER_BY_ID);
            ptm.setInt(1, id);
            rs = ptm.executeQuery();
            if (rs.next()) {
                return mapResultSetToOffer(rs);
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return null;
    }

    public boolean addOffer(OfferDTO offer) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(ADD_OFFER);
            ptm.setString(1, offer.getTitle());
            ptm.setString(2, offer.getSubtitle());
            ptm.setString(3, offer.getDescription());
            ptm.setString(4, offer.getImageUrl());
            ptm.setInt(5, offer.getCapacity());
            ptm.setBoolean(6, offer.getIsVIP());
            ptm.setBoolean(7, offer.getIsActive());
            ptm.setTimestamp(8, offer.getCreatedAt());
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean updateOffer(OfferDTO offer) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(UPDATE_OFFER);
            ptm.setString(1, offer.getTitle());
            ptm.setString(2, offer.getSubtitle());
            ptm.setString(3, offer.getDescription());
            ptm.setString(4, offer.getImageUrl());
            ptm.setInt(5, offer.getCapacity());
            ptm.setBoolean(6, offer.getIsVIP());
            ptm.setBoolean(7, offer.getIsActive());
            ptm.setInt(8, offer.getOfferID());
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean deleteOffer(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(DELETE_OFFER);
            ptm.setInt(1, id);
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    public boolean toggleOfferStatus(int offerId) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(TOGGLE_STATUS);
            ptm.setInt(1, offerId);
            return ptm.executeUpdate() > 0;
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
    }

    // Methods for pagination, filtering, and search
    
    public int getTotalOffers() throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(COUNT_ALL_OFFERS);
            rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return 0;
    }
    
    public int getFilteredOffersCount(Boolean isActive, String searchTitle, Boolean isVIP) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(COUNT_FILTERED_OFFERS);
            ptm.setObject(1, isActive);
            ptm.setObject(2, isActive);
            ptm.setObject(3, searchTitle);
            ptm.setObject(4, searchTitle != null ? "%" + searchTitle + "%" : null);
            ptm.setObject(5, isVIP);
            ptm.setObject(6, isVIP);
            rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return 0;
    }
    
    public List<OfferDTO> getOffersWithFilters(Boolean isActive, String searchTitle, Boolean isVIP, String sortBy, String sortOrder, int page, int pageSize) throws SQLException {
        List<OfferDTO> offers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtils.getConnection();
            
            // Validate and set sort parameters
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "OfferID";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Validate sortBy to prevent SQL injection
            String[] allowedSortFields = {"OfferID", "Title", "Capacity", "IsVIP", "IsActive", "CreatedAt"};
            boolean isValidSortField = false;
            for (String field : allowedSortFields) {
                if (field.equals(sortBy)) {
                    isValidSortField = true;
                    break;
                }
            }
            if (!isValidSortField) {
                sortBy = "OfferID";
            }
            
            // Validate sortOrder
            if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) {
                sortOrder = "DESC";
            }
            
            // Calculate row numbers for SQL Server pagination
            int startRow = (page - 1) * pageSize + 1;
            int endRow = page * pageSize;
            
            String query = String.format(GET_OFFERS_WITH_FILTERS, sortBy + " " + sortOrder);
            ptm = conn.prepareStatement(query);
            
            int paramIndex = 1;
            ptm.setObject(paramIndex++, isActive);
            ptm.setObject(paramIndex++, isActive);
            ptm.setObject(paramIndex++, searchTitle);
            ptm.setObject(paramIndex++, searchTitle != null ? "%" + searchTitle + "%" : null);
            ptm.setObject(paramIndex++, isVIP);
            ptm.setObject(paramIndex++, isVIP);
            ptm.setInt(paramIndex++, startRow);
            ptm.setInt(paramIndex++, endRow);
            
            rs = ptm.executeQuery();
            while (rs.next()) {
                offers.add(mapResultSetToOffer(rs));
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return offers;
    }
    
    private OfferDTO mapResultSetToOffer(ResultSet rs) throws SQLException {
        return OfferDTO.builder()
                .OfferID(rs.getInt("OfferID"))
                .Title(rs.getString("Title"))
                .Subtitle(rs.getString("Subtitle"))
                .Description(rs.getString("Description"))
                .ImageUrl(rs.getString("ImageUrl"))
                .Capacity(rs.getInt("Capacity"))
                .IsVIP(rs.getBoolean("IsVIP"))
                .IsActive(rs.getBoolean("IsActive"))
                .CreatedAt(rs.getTimestamp("CreatedAt"))
                .build();
    }

    public List<OfferDTO> searchOffers(String keyword) {
        String sql = "SELECT * FROM Offers WHERE Title LIKE ? OR Subtitle LIKE ? OR Description LIKE ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            String likeKeyword = "%" + keyword + "%";
            preparedStatement.setString(1, likeKeyword);
            preparedStatement.setString(2, likeKeyword);
            preparedStatement.setString(3, likeKeyword);

            ResultSet resultSet = preparedStatement.executeQuery();
            List<OfferDTO> offers = new ArrayList<>();

            while (resultSet.next()) {
                OfferDTO offer = OfferDTO.builder()
                        .OfferID(resultSet.getInt("OfferID"))
                        .Title(resultSet.getString("Title"))
                        .Subtitle(resultSet.getString("Subtitle"))
                        .Description(resultSet.getString("Description"))
                        .ImageUrl(resultSet.getString("ImageUrl"))
                        .Capacity(resultSet.getInt("Capacity"))
                        .IsVIP(resultSet.getBoolean("IsVIP"))
                        .IsActive(resultSet.getBoolean("IsActive"))
                        .CreatedAt(resultSet.getTimestamp("CreatedAt"))
                        .build();
                offers.add(offer);
            }

            return offers;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        OfferDAO dao = new OfferDAO();
        try {
            List<OfferDTO> list = dao.getAllOffers();
            if (list != null) {
                list.forEach(System.out::println);
            } else {
                System.out.println("No offers found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 