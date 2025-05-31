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
public class CourtScheduleDTO {
    private int ScheduleID;
    private int CourtID;
    private Timestamp StartTime;
    private Timestamp EndTime;
    private String DayOfWeek;
    private String Status;
    private Integer CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
}

