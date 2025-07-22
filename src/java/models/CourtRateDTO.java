package models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourtRateDTO {
    private Integer rateId;
    private Integer courtId;
    private Integer dayOfWeek; // 0=Chủ nhật, 1=Thứ 2, ...
    private LocalTime startHour;
    private LocalTime endHour;
    private BigDecimal hourlyRate;
    private Boolean isHoliday;
    private Timestamp createdAt;
} 