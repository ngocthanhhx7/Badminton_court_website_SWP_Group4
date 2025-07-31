/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author nguye
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourtDTO {
    private Integer courtId;
    private String courtName;
    private String description;
    private String courtType;
    private String status;
    private Integer createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String courtImage;
}

