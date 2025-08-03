package models;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for aggregated statistics including date-time ranges and revenue details.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsDTO {
    private int totalCourts;
    private int totalPosts;
    private int totalComments;

    private int singleCourtCount;
    private int doubleCourtCount;
    private int vipCourtCount;

    /**
     * Start of the statistics period (inclusive).
     */
    private LocalDateTime fromDateTime;

    /**
     * End of the statistics period (inclusive).
     */
    private LocalDateTime toDateTime;

    private BigDecimal totalRevenue;

    /**
     * Daily revenue breakdown within the period.
     */
    private List<DailyRevenueDTO> dailyRevenues;
}
