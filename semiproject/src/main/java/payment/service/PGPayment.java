package payment.service;

public class PGPayment {
	
	 private boolean paid;
	    private int amount;

	    public boolean isPaid() {
	        return paid;
	    }

	    public void setPaid(boolean paid) {
	        this.paid = paid;
	    }

	    public int getAmount() {
	        return amount;
	    }

	    public void setAmount(int amount) {
	        this.amount = amount;
	    }
	}
