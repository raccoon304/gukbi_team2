package admin.model;

import java.time.LocalDate;
import java.util.List;

import admin.domain.DailyAggDTO;
import admin.domain.OptionAggDTO;
import admin.domain.ProductAggDTO;
import admin.domain.TotalsDTO;

public interface AccountingDAO {

	// 상단 카드 합계금액 구하기
	TotalsDTO selectTotals(LocalDate start, LocalDate end) throws Exception;

	// 기간별 집계(일별)
	List<DailyAggDTO> selectDaily(LocalDate start, LocalDate end) throws Exception;
	
	// 기간별 집계(월별)
	List<DailyAggDTO> selectMonthly(LocalDate start, LocalDate end) throws Exception;

	// 상품별 집계
	List<ProductAggDTO> selectProducts(LocalDate start, LocalDate end, String sort) throws Exception;
	
	// 상품별 옵션 상세 집계
	List<OptionAggDTO> selectOptionSales(LocalDate start, LocalDate end, String productNo) throws Exception;

	

	
}
