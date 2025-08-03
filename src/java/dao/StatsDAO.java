package dao;

import models.DailyRevenueDTO;
import models.StatsDTO;
import utils.DBUtils;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for fetching aggregated stats and daily revenue from BookingDetails.
 */
public class StatsDAO {

    private final Connection conn;

    public StatsDAO() {
        this.conn = DBUtils.getConnection();
    }

    /**
     * Lấy số liệu thống kê từ fromDateTime đến toDateTime (inclusive).
     * @param fromDateTime bắt đầu (có giờ)
     * @param toDateTime kết thúc (có giờ)
     * @return StatsDTO bao gồm thống kê và doanh thu theo ngày
     */
    public StatsDTO getStats(LocalDateTime fromDateTime, LocalDateTime toDateTime) {
        if (fromDateTime.isAfter(toDateTime)) {
            throw new IllegalArgumentException("fromDateTime must not be after toDateTime");
        }

        try {
            StatsDTO.StatsDTOBuilder builder = StatsDTO.builder()
                    .fromDateTime(fromDateTime)
                    .toDateTime(toDateTime);

            // 1. Courts
            int totalCourts = 0, singleCount = 0, doubleCount = 0, vipCount = 0;
            String sqlCourts =
                    "SELECT CourtType, COUNT(*) AS cnt " +
                    "FROM Courts " +
                    "WHERE CreatedAt >= ? AND CreatedAt <= ? " +
                    "GROUP BY CourtType";
            try (PreparedStatement ps = conn.prepareStatement(sqlCourts)) {
                ps.setTimestamp(1, Timestamp.valueOf(fromDateTime));
                ps.setTimestamp(2, Timestamp.valueOf(toDateTime));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String type = rs.getString("CourtType");
                        int cnt = rs.getInt("cnt");
                        totalCourts += cnt;
                        switch (type) {
                            case "Single": singleCount = cnt; break;
                            case "Double": doubleCount = cnt; break;
                            case "VIP":    vipCount    = cnt; break;
                        }
                    }
                }
            }
            builder.totalCourts(totalCourts)
                   .singleCourtCount(singleCount)
                   .doubleCourtCount(doubleCount)
                   .vipCourtCount(vipCount);

            // 2. Blog Posts
            String sqlPosts =
                    "SELECT COUNT(*) FROM BlogPosts " +
                    "WHERE CreatedAt >= ? AND CreatedAt <= ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlPosts)) {
                ps.setTimestamp(1, Timestamp.valueOf(fromDateTime));
                ps.setTimestamp(2, Timestamp.valueOf(toDateTime));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) builder.totalPosts(rs.getInt(1));
                }
            }

            // 3. Blog Comments
            String sqlComments =
                    "SELECT COUNT(*) FROM BlogComments " +
                    "WHERE CreatedAt >= ? AND CreatedAt <= ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlComments)) {
                ps.setTimestamp(1, Timestamp.valueOf(fromDateTime));
                ps.setTimestamp(2, Timestamp.valueOf(toDateTime));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) builder.totalComments(rs.getInt(1));
                }
            }

            // 4. Daily Revenue from BookingDetails
            Map<LocalDateTime, BigDecimal> revenueMap = new HashMap<>();
            String sqlRevenue =
                    "SELECT CAST(bd.CreatedAt AS date) AS revenueDate, SUM(bd.Subtotal) AS totalSub " +
                    "FROM BookingDetails bd " +
                    "WHERE bd.CreatedAt >= ? AND bd.CreatedAt <= ? " +
                    "GROUP BY CAST(bd.CreatedAt AS date) " +
                    "ORDER BY revenueDate";
            try (PreparedStatement ps = conn.prepareStatement(sqlRevenue)) {
                ps.setTimestamp(1, Timestamp.valueOf(fromDateTime));
                ps.setTimestamp(2, Timestamp.valueOf(toDateTime));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LocalDateTime date = rs.getDate("revenueDate").toLocalDate().atStartOfDay();
                        revenueMap.put(date, rs.getBigDecimal("totalSub"));
                    }
                }
            }

            // 5. Tạo danh sách ngày đầy đủ
            List<DailyRevenueDTO> revenues = new ArrayList<>();
            LocalDateTime cursor = fromDateTime.toLocalDate().atStartOfDay();
            LocalDateTime endDay = toDateTime.toLocalDate().atStartOfDay();
            while (!cursor.isAfter(endDay)) {
                BigDecimal sub = revenueMap.getOrDefault(cursor, BigDecimal.ZERO);
                revenues.add(DailyRevenueDTO.builder().date(cursor).subtotal(sub).build());
                cursor = cursor.plusDays(1);
            }
            BigDecimal totalRev = revenues.stream()
                    .map(DailyRevenueDTO::getSubtotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            builder.dailyRevenues(revenues)
                   .totalRevenue(totalRev);

            return builder.build();

        } catch (SQLException ex) {
            throw new RuntimeException(
                "Error querying statistics: " + ex.getMessage() +
                ", SQL State: " + ex.getSQLState() +
                ", Error Code: " + ex.getErrorCode(), ex);
        }
    }

    public static void main(String[] args) {
        StatsDAO dao = new StatsDAO();
        LocalDateTime from = LocalDateTime.of(2025, 7, 1, 0, 0);
        LocalDateTime to   = LocalDateTime.of(2025, 7, 21, 23, 59, 59);
        StatsDTO stats = dao.getStats(from, to);
        System.out.println("=== Statistics from " + from + " to " + to + " ===");
        System.out.println("Total Courts: " + stats.getTotalCourts());
        System.out.println("Single: " + stats.getSingleCourtCount() + ", Double: " + stats.getDoubleCourtCount() + ", VIP: " + stats.getVipCourtCount());
        System.out.println("Total Posts: " + stats.getTotalPosts() + ", Comments: " + stats.getTotalComments());
        System.out.println("Total Revenue: " + stats.getTotalRevenue());
        System.out.println("Daily Revenues:");
        for (DailyRevenueDTO dr : stats.getDailyRevenues()) {
            System.out.println(dr.getDate() + " => " + dr.getSubtotal());
        }
    }
}
