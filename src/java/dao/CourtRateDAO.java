package dao;

import models.CourtRateDTO;
import utils.DBUtils;
import java.sql.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class CourtRateDAO {
    public boolean addRate(CourtRateDTO rate) {
        String sql = "INSERT INTO CourtRates (CourtID, DayOfWeek, StartHour, EndHour, HourlyRate, IsHoliday, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rate.getCourtId());
            ps.setInt(2, rate.getDayOfWeek());
            ps.setTime(3, Time.valueOf(rate.getStartHour()));
            ps.setTime(4, Time.valueOf(rate.getEndHour()));
            ps.setBigDecimal(5, rate.getHourlyRate());
            if (rate.getIsHoliday() != null) ps.setBoolean(6, rate.getIsHoliday()); else ps.setNull(6, Types.BIT);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateRate(CourtRateDTO rate) {
        String sql = "UPDATE CourtRates SET CourtID=?, DayOfWeek=?, StartHour=?, EndHour=?, HourlyRate=?, IsHoliday=? WHERE RateID=?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rate.getCourtId());
            ps.setInt(2, rate.getDayOfWeek());
            ps.setTime(3, Time.valueOf(rate.getStartHour()));
            ps.setTime(4, Time.valueOf(rate.getEndHour()));
            ps.setBigDecimal(5, rate.getHourlyRate());
            if (rate.getIsHoliday() != null) ps.setBoolean(6, rate.getIsHoliday()); else ps.setNull(6, Types.BIT);
            ps.setInt(7, rate.getRateId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteRate(Integer rateId) {
        String sql = "DELETE FROM CourtRates WHERE RateID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rateId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<CourtRateDTO> getRatesWithFilters(Integer courtId, Integer dayOfWeek, Boolean isHoliday, String sortBy, String sortOrder, int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (pageSize > 100) pageSize = 100;
        String[] allowedSortFields = {"RateID", "CourtID", "DayOfWeek", "StartHour", "EndHour", "HourlyRate", "IsHoliday", "CreatedAt"};
        boolean isValidSortField = false;
        for (String field : allowedSortFields) {
            if (field.equals(sortBy)) { isValidSortField = true; break; }
        }
        if (!isValidSortField) sortBy = "RateID";
        if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) sortOrder = "DESC";
        StringBuilder sql = new StringBuilder("SELECT * FROM CourtRates WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (courtId != null) { sql.append(" AND CourtID = ?"); params.add(courtId); }
        if (dayOfWeek != null) { sql.append(" AND DayOfWeek = ?"); params.add(dayOfWeek); }
        if (isHoliday != null) { sql.append(" AND IsHoliday = ?"); params.add(isHoliday); }
        sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortOrder);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        List<CourtRateDTO> rates = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) { ps.setObject(i + 1, params.get(i)); }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CourtRateDTO rate = CourtRateDTO.builder()
                        .rateId(rs.getInt("RateID"))
                        .courtId(rs.getInt("CourtID"))
                        .dayOfWeek(rs.getInt("DayOfWeek"))
                        .startHour(rs.getTime("StartHour").toLocalTime())
                        .endHour(rs.getTime("EndHour").toLocalTime())
                        .hourlyRate(rs.getBigDecimal("HourlyRate"))
                        .isHoliday(rs.getObject("IsHoliday") != null ? rs.getBoolean("IsHoliday") : null)
                        .createdAt(rs.getTimestamp("CreatedAt"))
                        .build();
                rates.add(rate);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return rates;
    }

    public int getFilteredRatesCount(Integer courtId, Integer dayOfWeek, Boolean isHoliday) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM CourtRates WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (courtId != null) { sql.append(" AND CourtID = ?"); params.add(courtId); }
        if (dayOfWeek != null) { sql.append(" AND DayOfWeek = ?"); params.add(dayOfWeek); }
        if (isHoliday != null) { sql.append(" AND IsHoliday = ?"); params.add(isHoliday); }
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) { ps.setObject(i + 1, params.get(i)); }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
} 