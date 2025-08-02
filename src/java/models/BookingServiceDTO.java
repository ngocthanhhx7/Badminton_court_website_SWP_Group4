package models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingServiceDTO {
    private Long bookingServiceId;
    private Long bookingId;
    private Integer serviceId;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;
    private LocalDateTime createdAt;
    
    // Service information (for display purposes)
    private String serviceName;
    private String serviceType;
    private String description;
    private String unit;
    private String status;
    
    // Computed properties
    public BigDecimal calculateSubtotal() {
        if (unitPrice != null && quantity != null) {
            return unitPrice.multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }
    
    public void updateSubtotal() {
        this.subtotal = calculateSubtotal();
    }
}
