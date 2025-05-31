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
public class BookingDetailDTO {
    private int BookingDetailID;
    private int BookingID;
    private int CourtID;
    private Timestamp StartTime;
    private Timestamp EndTime;
    private double HourlyRate;
    private Timestamp CreatedAt;
}
