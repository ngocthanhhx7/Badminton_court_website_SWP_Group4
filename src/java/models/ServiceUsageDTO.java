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
public class ServiceUsageDTO {
    private int UsageID;
    private int BookingID;
    private int ServiceID;
    private int Quantity;
    private Timestamp UsedAt;
    private Integer RecordedBy;
}