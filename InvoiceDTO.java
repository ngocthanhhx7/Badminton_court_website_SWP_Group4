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
public class InvoiceDTO {
    private Long invoiceId;
    private Long bookingId;
    private Long customerId;
    private BigDecimal totalAmount;
    private BigDecimal discount;
    private BigDecimal tax;
    private BigDecimal finalAmount;
    private String paymentMethod;
    private String status;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // VNPay fields
    private String vnpTxnRef;
    private String vnpOrderInfo;
    private String vnpResponseCode;
    private String vnpTransactionNo;
}