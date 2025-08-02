package scheduler;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.Timer;
import java.util.TimerTask;

@WebListener
public class AppContextListener implements ServletContextListener {

    private Timer timer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        timer = new Timer(true); // true = daemon thread (chạy ngầm)
        
        // Lên lịch chạy task tự động publish bài viết
        timer.scheduleAtFixedRate(new AutoPublishTask(), 0, 5 * 1000); // mỗi 60 giây
        
        System.out.println("🔁 AutoPublishTask started...");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel(); // Hủy timer khi ứng dụng shutdown
            System.out.println("⛔ AutoPublishTask stopped.");
        }
    }
}
