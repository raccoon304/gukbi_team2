package payment.service;

import java.util.Timer;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class OrderCleanupScheduler implements ServletContextListener {
    
    private Timer cleanupTimer;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        cleanupTimer = new Timer("ReadyOrderCleanup", true);
        
        // 5분마다 실행
        cleanupTimer.scheduleAtFixedRate(
            new ReadyOrderCleanupTask(), 
            0,              
            5 * 60 * 1000   // 5분마다
        );
        
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (cleanupTimer != null) {
            cleanupTimer.cancel();
   
        }
    }
}