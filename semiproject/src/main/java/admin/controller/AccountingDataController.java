package admin.controller;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import admin.domain.DailyAggDTO;
import admin.domain.ProductAggDTO;
import admin.domain.TotalsDTO;
import admin.model.AccountingDAO;
import admin.model.AccountingDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AccountingDataController extends AbstractController {

		
	private AccountingDAO adao = new AccountingDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
        String period = request.getParameter("period");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String sort = request.getParameter("sort");
        
        if (sort == null || sort.isBlank()) {
        		sort = "revenue";
        }

        DateRange range = DateRange.from(period, startDate, endDate);
       
        // 상단 카드 합계금액 구하기
        TotalsDTO totals = adao.selectTotals(range.start, range.end);
        
        // 월별 여부 결정 결정
	    boolean useMonthly = range.start.plusMonths(3).isBefore(range.end);
        
        // 기간별 집계
        List<DailyAggDTO> dailyList = useMonthly
                                    ? adao.selectMonthly(range.start, range.end)
                                    : adao.selectDaily(range.start, range.end);
        
        // 상품별 집계
        List<ProductAggDTO> productList = adao.selectProducts(range.start, range.end, sort);

        // JSON
        JSONObject jsonObjRoot = new JSONObject();
        jsonObjRoot.put("rangeLabel", range.label);

        JSONObject jsonObjTotals = new JSONObject();
        jsonObjTotals.put("orders", totals.getOrders());
        jsonObjTotals.put("qty", totals.getQty());
        jsonObjTotals.put("gross", totals.getGross());
        jsonObjTotals.put("discount", totals.getDiscount());
        jsonObjTotals.put("net", totals.getNet());
        jsonObjRoot.put("totals", jsonObjTotals);
        
        // 헤더 문구 바꾸게 내려주기
        jsonObjRoot.put("unit", useMonthly ? "MONTH" : "DAY");

        JSONArray jsonArrDaily = new JSONArray();
        
        for (DailyAggDTO ddto : dailyList) {
        	
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("baseDate", ddto.getBaseDate());
            jsonObj.put("orders", ddto.getOrders());
            jsonObj.put("qty", ddto.getQty());
            jsonObj.put("amount", ddto.getAmount());
            jsonArrDaily.put(jsonObj);
        }
        jsonObjRoot.put("daily", jsonArrDaily);

        JSONArray jsonArrProd = new JSONArray();
        
        for (ProductAggDTO pdto : productList) {
        	
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("productNo", pdto.getProductNo());
            jsonObj.put("productName", pdto.getProductName());
            jsonObj.put("brand", pdto.getBrand());
            jsonObj.put("qty", pdto.getQty());
            jsonObj.put("amount", pdto.getAmount());
            jsonArrProd.put(jsonObj);
        }
        jsonObjRoot.put("products", jsonArrProd);

        // JSON 문자열
        String json = jsonObjRoot.toString();

        // json view로 forward
        request.setAttribute("json", json);
       
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/admin_jsonview.jsp");
    }

    
    
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
		
    }

}
