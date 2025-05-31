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
public class CourtRateDTO {
    private int RateID;
    private int CourtID;
    private int DayOfWeek;
    private java.sql.Time StartTime;
    private java.sql.Time EndTime;
    private double HourlyRate;
    private Boolean IsHoliday;
}
