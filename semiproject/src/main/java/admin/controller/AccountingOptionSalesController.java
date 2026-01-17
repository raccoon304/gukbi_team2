package admin.controller;

import java.time.LocalDate;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import admin.domain.OptionAggDTO;
import admin.model.AccountingDAO;
import admin.model.AccountingDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AccountingOptionSalesController extends AbstractController {

	
	private AccountingDAO adao = new AccountingDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		
		    String productNo = request.getParameter("productNo");
	        String period = request.getParameter("period");
	        String startDate = request.getParameter("startDate");
	        String endDate = request.getParameter("endDate");

	        DateRange range = DateRange.from(period, startDate, endDate);

	        List<OptionAggDTO> optionList = adao.selectOptionSales(range.start, range.end, productNo);

	        JSONObject root = new JSONObject();
	        root.put("productNo", productNo);
	        root.put("rangeLabel", range.label);

	        JSONArray arr = new JSONArray();
	        for (OptionAggDTO o : optionList) {
	            JSONObject json = new JSONObject();
	            json.put("optionId", o.getOptionId());
	            json.put("color", o.getColor());
	            json.put("storageSize", o.getStorageSize());
	            json.put("qty", o.getQty());
	            json.put("amount", o.getAmount());
	            arr.put(json);
	        }
	        root.put("options", arr);

	        request.setAttribute("json", root.toString());
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
		
	}
	
	
	// AccountingDataController의 DateRange 그대로 가져다씀
    static class DateRange {
        public final LocalDate start;
        public final LocalDate end;
        public final String label;

        private DateRange(LocalDate start, LocalDate end, String label) {
            this.start = start;
            this.end = end;
            this.label = label;
        }

        public static DateRange from(String period, String startDate, String endDate) {
            LocalDate today = LocalDate.now();
            LocalDate s, e;

            switch (period == null ? "" : period) {
                case "TODAY":      s = today; e = today.plusDays(1); break;
                case "YESTERDAY":  s = today.minusDays(1); e = today; break;
                case "LAST_7":     s = today.minusDays(6); e = today.plusDays(1); break;
                case "LAST_30":    s = today.minusDays(29); e = today.plusDays(1); break;

                case "MTD":        s = today.withDayOfMonth(1); e = today.plusDays(1); break;
                case "LAST_MONTH": {
                    LocalDate firstThisMonth = today.withDayOfMonth(1);
                    s = firstThisMonth.minusMonths(1);
                    e = firstThisMonth;
                    break;
                }

                case "QTD": {
                    int m = today.getMonthValue();
                    int qStartMonth = ((m - 1) / 3) * 3 + 1;
                    s = LocalDate.of(today.getYear(), qStartMonth, 1);
                    e = today.plusDays(1);
                    break;
                }
                case "LAST_QUARTER": {
                    int m = today.getMonthValue();
                    int qStartMonth = ((m - 1) / 3) * 3 + 1;
                    LocalDate thisQStart = LocalDate.of(today.getYear(), qStartMonth, 1);
                    s = thisQStart.minusMonths(3);
                    e = thisQStart;
                    break;
                }

                case "YTD":        s = LocalDate.of(today.getYear(), 1, 1); e = today.plusDays(1); break;
                case "LAST_YEAR":  s = LocalDate.of(today.getYear()-1, 1, 1); e = LocalDate.of(today.getYear(), 1, 1); break;

                case "CUSTOM":
                    s = LocalDate.parse(startDate);
                    e = LocalDate.parse(endDate).plusDays(1);
                    break;

                default:
                    s = today.minusDays(6); e = today.plusDays(1);
            }

            String label = s.toString() + " ~ " + e.minusDays(1).toString();
            return new DateRange(s, e, label);
        }
    }// end of static class DateRange -------

}
