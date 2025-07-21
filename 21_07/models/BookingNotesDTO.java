/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.time.LocalDateTime;
import lombok.Data;


@Data
public class BookingNotesDTO {
    private int NoteID;
    private int BookingID;
    private int CustomerID;
    private String NoteType;
    private String NoteDetails;
    private int Rating;
    private String Status;
    private LocalDateTime CreatedAt;
    private int CreatedBy;
}
