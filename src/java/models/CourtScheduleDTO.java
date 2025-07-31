package models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourtScheduleDTO {
    private Long scheduleId;
    private Integer courtId;
    private LocalDate scheduleDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String status;
    private boolean isHoliday;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private double price;
    
    // Additional fields
    private String courtName;
    private String courtType;
    
    private String startTimeStr;
    private String endTimeStr;
    
    private CourtDTO courtDTO;
    
    private boolean isExpire;
}