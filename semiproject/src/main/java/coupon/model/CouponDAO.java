package coupon.model;

import java.sql.SQLException;
import java.util.List;

import coupon.domain.CouponDTO;

public interface CouponDAO {

	// 쿠폰 생성 메서드
	int CouponCreate(CouponDTO cpDto) throws SQLException;

	// 쿠폰 리스트를 보여주는 메서드
	List<CouponDTO> selectCouponList() throws SQLException;

}
