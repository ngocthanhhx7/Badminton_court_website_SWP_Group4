package models;

import java.sql.Timestamp;
import lombok.*;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingNoteDTO {
    private int NoteID;
    private int BookingID;
    private int CustomerID;
    private String NoteDetails;
    private String Status;
    private String NoteType;
    private Integer Rating;
    private Integer CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
}
