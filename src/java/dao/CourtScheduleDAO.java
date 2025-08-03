package dao;

import models.CourtScheduleDTO;
import utils.DBUtils;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class CourtScheduleDAO {
    
public List<CourtScheduleDTO> getAvailableSchedules(Integer courtId, LocalDate date) {
        String sql = "SELECT cs.*, c.CourtName, c.CourtType " +
            "FROM CourtSchedules cs " +
            "JOIN Courts c ON cs.CourtID = c.CourtID " +
            "WHERE cs.CourtID = ? AND cs.ScheduleDate = ? AND cs.Status = 'Available' " +
            "ORDER BY cs.StartTime";
        
        List<CourtScheduleDTO> schedules = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, courtId);
            ps.setDate(2, Date.valueOf(date));
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CourtScheduleDTO schedule = CourtScheduleDTO.builder()
                    .scheduleId(rs.getLong("ScheduleID"))
                    .courtId(rs.getInt("CourtID"))
                    .price(getPrice(rs.getLong("ScheduleID")))
                    .scheduleDate(rs.getDate("ScheduleDate").toLocalDate())
                    .startTime(rs.getTime("StartTime").toLocalTime())
                    .endTime(rs.getTime("EndTime").toLocalTime())
                    .status(rs.getString("Status"))
                    .isHoliday(rs.getBoolean("IsHoliday"))
                    .courtName(rs.getString("CourtName"))
                    .courtType(rs.getString("CourtType"))
                    .build();
                schedules.add(schedule);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    public List<CourtScheduleDTO> getAllAvailableSchedules(LocalDate date) {
        String sql = "SELECT cs.*, c.CourtName, c.CourtType " +
            "FROM CourtSchedules cs " +
            "JOIN Courts c ON cs.CourtID = c.CourtID " +
            "WHERE cs.ScheduleDate = ?  " +
            "ORDER BY c.CourtName, cs.StartTime";
        
        List<CourtScheduleDTO> schedules = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setDate(1, Date.valueOf(date));
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CourtScheduleDTO schedule = CourtScheduleDTO.builder()
                    .scheduleId(rs.getLong("ScheduleID"))
                    .courtId(rs.getInt("CourtID"))
                    .scheduleDate(rs.getDate("ScheduleDate").toLocalDate())
                     .price(getPrice(rs.getLong("ScheduleID")))
                    .startTime(rs.getTime("StartTime").toLocalTime())
                    .endTime(rs.getTime("EndTime").toLocalTime())
                    .status(rs.getString("Status"))
                    .isHoliday(rs.getBoolean("IsHoliday"))
                    .courtName(rs.getString("CourtName"))
                    .courtType(rs.getString("CourtType"))
                    .build();
                schedules.add(schedule);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    public boolean updateScheduleStatus(Long scheduleId, String status) {
        String sql = "UPDATE CourtSchedules SET Status = ?, UpdatedAt = GETDATE() WHERE ScheduleID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setLong(2, scheduleId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
        public boolean isTimeSlotAvailable(Long courtScheduleId) {
         String sql = "SELECT Status FROM CourtSchedules WHERE scheduleId = ?";

         try (Connection connection = DBUtils.getConnection();
              PreparedStatement ps = connection.prepareStatement(sql)) {

             ps.setLong(1, courtScheduleId);

             ResultSet rs = ps.executeQuery();
             if (rs.next()) {
                 String status = rs.getString("Status");
                 return "Available".equalsIgnoreCase(status);
             }
         } catch (Exception e) {
             e.printStackTrace();
         }
         return false;
     }
        
        
    public List<CourtScheduleDTO> getSchedulesByCourtAndDate(Integer courtId, LocalDate date) {
        String sql = "SELECT s.*, c.CourtName, c.CourtType " +
             "FROM CourtSchedules s " +
             "JOIN Courts c ON s.CourtID = c.CourtID " +
             "WHERE s.CourtID = ? AND s.ScheduleDate = ? " +
             "ORDER BY c.CourtName, s.StartTime";


        List<CourtScheduleDTO> schedules = new ArrayList<>();

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, courtId);
            preparedStatement.setDate(2, Date.valueOf(date));

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                CourtScheduleDTO schedule = CourtScheduleDTO.builder()
                    .scheduleId(rs.getLong("ScheduleID"))
                    .courtId(rs.getInt("CourtID"))
                    .scheduleDate(rs.getDate("ScheduleDate").toLocalDate())
                     .price(getPrice(rs.getLong("ScheduleID")))
                    .startTime(rs.getTime("StartTime").toLocalTime())
                    .endTime(rs.getTime("EndTime").toLocalTime())
                    .status(rs.getString("Status"))
                    .isHoliday(rs.getBoolean("IsHoliday"))
                    .courtName(rs.getString("CourtName"))
                    .courtType(rs.getString("CourtType"))
                    .build();
                schedules.add(schedule);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return schedules;
    }   


    public CourtScheduleDTO getScheduleById(int scheduleId) {
        String sql = "SELECT cs.*, c.CourtName, c.CourtType " +
                     "FROM CourtSchedules cs " +
                     "JOIN Courts c ON cs.CourtID = c.CourtID " +
                     "WHERE cs.ScheduleID = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return CourtScheduleDTO.builder()
                        .scheduleId(rs.getLong("ScheduleID"))
                        .courtId(rs.getInt("CourtID"))
                        .scheduleDate(rs.getDate("ScheduleDate").toLocalDate())
                        .price(getPrice(rs.getLong("ScheduleID")))
                        .startTime(rs.getTime("StartTime").toLocalTime())
                        .endTime(rs.getTime("EndTime").toLocalTime())
                        .status(rs.getString("Status"))
                        .isHoliday(rs.getBoolean("IsHoliday"))
                        .courtName(rs.getString("CourtName"))
                        .courtType(rs.getString("CourtType"))
                        .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public List<CourtScheduleDTO> getSchedulesByIds(List<Integer> scheduleIds) {
        List<CourtScheduleDTO> schedules = new ArrayList<>();
        if (scheduleIds == null || scheduleIds.isEmpty()) return schedules;

        String placeholders = scheduleIds.stream()
            .map(id -> "?")
            .collect(Collectors.joining(","));

          CourtDAO courtDAO = new CourtDAO();
        
        String sql = "SELECT cs.*, c.CourtName, c.CourtType " +
                     "FROM CourtSchedules cs " +
                     "JOIN Courts c ON cs.CourtID = c.CourtID " +
                     "WHERE cs.ScheduleID IN (" + placeholders + ")";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < scheduleIds.size(); i++) {
                ps.setInt(i + 1, scheduleIds.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CourtScheduleDTO schedule = CourtScheduleDTO.builder()
                        .scheduleId(rs.getLong("ScheduleID"))
                        .courtId(rs.getInt("CourtID"))
                        .scheduleDate(rs.getDate("ScheduleDate").toLocalDate())
                        .startTime(rs.getTime("StartTime").toLocalTime())
                        .price(getPrice(rs.getLong("ScheduleID")))
                        .endTime(rs.getTime("EndTime").toLocalTime())
                        .status(rs.getString("Status"))
                        .isHoliday(rs.getBoolean("IsHoliday"))
                        .courtName(rs.getString("CourtName"))
                        .courtType(rs.getString("CourtType"))
                        .build();
                
                 schedule.setCourtDTO(courtDAO.getCourtById(schedule.getCourtId()));

                // Set formatted time strings
                DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HH:mm");
                schedule.setStartTimeStr(schedule.getStartTime().format(timeFormat));
                schedule.setEndTimeStr(schedule.getEndTime().format(timeFormat));

                schedules.add(schedule);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return schedules;
    }
    
    
    public double getPrice(Long scheduleId) {
        String sql = "SELECT TOP 1 cr.HourlyRate " +
                     "FROM CourtSchedules cs " +
                     "JOIN CourtRates cr ON cs.CourtID = cr.CourtID " +
                     "AND cs.IsHoliday = cr.IsHoliday " +
                     "AND cr.DayOfWeek = DATEPART(WEEKDAY, cs.ScheduleDate) " +
                     "AND cs.StartTime >= cr.StartHour " +
                     "AND cs.StartTime < cr.EndHour " +
                     "WHERE cs.ScheduleID = ? " +
                     "ORDER BY ABS(DATEDIFF(MINUTE, cr.StartHour, cs.StartTime))";  // ưu tiên giá theo khung giờ sớm nhất nếu trùng

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, scheduleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("HourlyRate");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 100000;
    }

    // === CRUD & FILTER/PAGINATION METHODS ===
    public boolean addSchedule(CourtScheduleDTO schedule) {
        String sql = "INSERT INTO CourtSchedules (CourtID, ScheduleDate, StartTime, EndTime, Status, IsHoliday, CreatedBy, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, schedule.getCourtId());
            ps.setDate(2, java.sql.Date.valueOf(schedule.getScheduleDate()));
            ps.setTime(3, java.sql.Time.valueOf(schedule.getStartTime()));
            ps.setTime(4, java.sql.Time.valueOf(schedule.getEndTime()));
            ps.setString(5, schedule.getStatus());
            ps.setBoolean(6, schedule.isHoliday());
            ps.setLong(7, schedule.getCreatedBy() != null ? schedule.getCreatedBy() : 1L);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSchedule(CourtScheduleDTO schedule) {
        String sql = "UPDATE CourtSchedules SET CourtID=?, ScheduleDate=?, StartTime=?, EndTime=?, Status=?, IsHoliday=?, UpdatedAt=GETDATE() WHERE ScheduleID=?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, schedule.getCourtId());
            ps.setDate(2, java.sql.Date.valueOf(schedule.getScheduleDate()));
            ps.setTime(3, java.sql.Time.valueOf(schedule.getStartTime()));
            ps.setTime(4, java.sql.Time.valueOf(schedule.getEndTime()));
            ps.setString(5, schedule.getStatus());
            ps.setBoolean(6, schedule.isHoliday());
            ps.setLong(7, schedule.getScheduleId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSchedule(Long scheduleId) {
        String sql = "DELETE FROM CourtSchedules WHERE ScheduleID = ?";
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CourtScheduleDTO> getSchedulesWithFilters(Integer courtId, String status, String courtType, LocalDate scheduleDate, String sortBy, String sortOrder, int page, int pageSize) {
        // Validate and sanitize parameters
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (pageSize > 100) pageSize = 100;
        String[] allowedSortFields = {"ScheduleID", "CourtID", "ScheduleDate", "StartTime", "EndTime", "Status", "IsHoliday", "CreatedAt"};
        boolean isValidSortField = false;
        for (String field : allowedSortFields) {
            if (field.equals(sortBy)) {
                isValidSortField = true;
                break;
            }
        }
        if (!isValidSortField) sortBy = "ScheduleID";
        if (!"ASC".equalsIgnoreCase(sortOrder) && !"DESC".equalsIgnoreCase(sortOrder)) sortOrder = "DESC";
        StringBuilder sql = new StringBuilder("SELECT cs.*, c.CourtName, c.CourtType FROM CourtSchedules cs JOIN Courts c ON cs.CourtID = c.CourtID WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (courtId != null) {
            sql.append(" AND cs.CourtID = ?");
            params.add(courtId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND cs.Status = ?");
            params.add(status.trim());
        }
        if (courtType != null && !courtType.trim().isEmpty()) {
            sql.append(" AND c.CourtType = ?");
            params.add(courtType.trim());
        }
        if (scheduleDate != null) {
            sql.append(" AND cs.ScheduleDate = ?");
            params.add(java.sql.Date.valueOf(scheduleDate));
        }
        sql.append(" ORDER BY cs.").append(sortBy).append(" ").append(sortOrder);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        List<CourtScheduleDTO> schedules = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CourtScheduleDTO schedule = CourtScheduleDTO.builder()
                        .scheduleId(rs.getLong("ScheduleID"))
                        .courtId(rs.getInt("CourtID"))
                        .scheduleDate(rs.getDate("ScheduleDate").toLocalDate())
                        .startTime(rs.getTime("StartTime").toLocalTime())
                        .endTime(rs.getTime("EndTime").toLocalTime())
                        .status(rs.getString("Status"))
                        .isHoliday(rs.getBoolean("IsHoliday"))
                        .courtName(rs.getString("CourtName"))
                        .courtType(rs.getString("CourtType"))
                        .build();
                schedules.add(schedule);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public int getFilteredSchedulesCount(Integer courtId, String status, String courtType, LocalDate scheduleDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM CourtSchedules cs JOIN Courts c ON cs.CourtID = c.CourtID WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (courtId != null) {
            sql.append(" AND cs.CourtID = ?");
            params.add(courtId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND cs.Status = ?");
            params.add(status.trim());
        }
        if (courtType != null && !courtType.trim().isEmpty()) {
            sql.append(" AND c.CourtType = ?");
            params.add(courtType.trim());
        }
        if (scheduleDate != null) {
            sql.append(" AND cs.ScheduleDate = ?");
            params.add(java.sql.Date.valueOf(scheduleDate));
        }
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean generateCourtSchedules7Days() {
        String sql = "EXEC [dbo].[sp_GenerateCourtSchedules7Days]";
        try (Connection connection = utils.DBUtils.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {
            cs.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}