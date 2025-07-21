package models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingDetailDTO {
    private Long bookingDetailId;
    private Long bookingId;
    private Long courtId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private BigDecimal hourlyRate;
    private BigDecimal subtotal;
    private LocalDateTime createdAt;
    
    // Additional fields for display
    private String courtName;
    private String courtType;
    private int durationHours;
    
    private String startTimeStr;
    private String endTimeStr;
   
}