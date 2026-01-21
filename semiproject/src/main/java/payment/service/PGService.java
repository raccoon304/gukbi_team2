package payment.service;

public class PGService {

	public PGPayment verify(String pgTid, int serverAmount) {

	    PGPayment payment = new PGPayment();

	    if (pgTid != null && !pgTid.isBlank()) {
	        payment.setPaid(true);
	        payment.setAmount(serverAmount);
	    } else {
	        payment.setPaid(false);
	    }

	    return payment;
	}

	// 결제 정보 조회
	public PGPayment getPaymentInfo(String impUid) {
		 PGPayment payment = new PGPayment();
		 if (impUid != null && !impUid.isBlank()) {
	        payment.setPaid(true);
	        payment.setAmount(100); // 실제로는 API에서 조회
	     } else {
	        payment.setPaid(false);
	     }
		    
		 return payment;
	}	
}