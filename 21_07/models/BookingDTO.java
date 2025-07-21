package models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingDTO {
    private Long bookingId;
    private Long customerId;
    private String status;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Long createdBy;
    
    // Additional fields for display
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    
    private List<BookingDetailDTO> bookingDetails;
    private String createdAtStr;
    private String updatedAtStr;
    
    private boolean isCancel;
    private boolean isCanRating;
    private boolean isExpire;
}