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
public class BookingDTO {
    private int BookingID;
    private Integer CustomerID;
    private int CourtID;
    private Timestamp BookingTime;
    private int DurationHours;
    private String Status;
    private Integer CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
}
