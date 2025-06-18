package dao;

import models.CourtScheduleDTO;
import utils.DBUtils;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

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
            "WHERE cs.ScheduleDate = ? " +
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



}