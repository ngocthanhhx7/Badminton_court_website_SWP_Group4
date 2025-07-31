package scheduler;

import dal.BlogPostDAO;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.TimerTask;

public class AutoPublishTask extends TimerTask {

    @Override
    public void run() {
        try {
            BlogPostDAO dao = new BlogPostDAO();
            dao.autoPublishScheduledPosts(Timestamp.valueOf(LocalDateTime.now()));
            System.out.println("✅ Auto publish task executed.");
        } catch (Exception e) {
            System.err.println("❌ Auto publish error: " + e.getMessage());
        }
    }
}
