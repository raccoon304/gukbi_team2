package payment.service;

import java.util.TimerTask;
import order.model.OrderDAO;
import order.model.OrderDAO_imple;

public class ReadyOrderCleanupTask extends TimerTask {
    
    @Override
    public void run() {
        try {
            OrderDAO odao = new OrderDAO_imple();
            
            // 10분 이상 지난 READY 상태 주문을 FAIL로 변경
            int count = odao.expireReadyOrders();
            
            if (count > 0) {
      //         
            }
            
        } catch (Exception e) {
      //     
            e.printStackTrace();
        }
    }
}