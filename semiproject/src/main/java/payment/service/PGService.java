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
}