package models;

import java.sql.Timestamp;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageDTO {
    private int MessageID;
    private int UserID;
    private String Content;
    private Timestamp SentAt;
    private String SenderType;
} 