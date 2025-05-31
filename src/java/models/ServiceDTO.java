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
public class ServiceDTO {
    private int ServiceID;
    private String ServiceName;
    private String Description;
    private double Price;
    private String Status;
    private String ServiceType;
    private Integer CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
}
