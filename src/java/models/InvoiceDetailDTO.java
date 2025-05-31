/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.sql.Timestamp;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InvoiceDetailDTO {
    private int InvoiceDetailID;
    private int InvoiceID;
    private Integer ServiceID;
    private String ItemName;
    private int Quantity;
    private double UnitPrice;
    private double Subtotal;
    private String Status;
    private Boolean IsServiceIncludedInBooking;
    private Integer CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
}
