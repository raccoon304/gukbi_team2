package product.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;

public interface ProductDAO {
	//임시: 제품 목록들 전부 출력해 가져오기(select)
	List<ProductDTO> selectProduct() throws SQLException;

	//받아온 상품코드(상품테이블)의 값을 이용해 제품정보 가져오기
	ProductDTO selectOne(String productCode) throws SQLException;
	
	//임시: 받아온 상품코드(상품테이블)의 값을 이용해 상품상세값 가져오기
	ProductOptionDTO selectOptionOne(String productCode) throws SQLException;

	//상품페이지의 카드UI용 DTO를 이용해 상품정보 가져오기(상품코드,상품명,브랜드명,이미지경로,가격)
	List<ProductDTO> productCardList() throws SQLException;

	//제품코드에 따른 추가금을 가져오기(512GB만 추가금이 있으므로 그것만 가져오기
	int selectOptionPlusPrice(String productCode) throws SQLException;
	
	//장바구니 테이블의 상품에 대해 있는지 없는지 확인하기
	boolean isCartProduct(Map<String, String> paraMap) throws SQLException;

	//장바구니에 값 삽입하기 fk_member_id(회원아이디), fk_option_id(옵션아이디), quantity(재고량)
	int insertProductCart(Map<String, String> paraMap) throws SQLException;

	//장바구니에 값 업데이트하기 fk_member_id(회원아이디), fk_option_id(옵션아이디), quantity(재고량)
	int updateProductCart(Map<String, String> paraMap) throws SQLException;

	//상품코드 중복 확인하기
	boolean ckProductCode(String productCode) throws SQLException;

	//상품명 중복 확인하기
	boolean ckProductName(String productName) throws SQLException;

	//구매하기에 값 삽입하기 
	//int insertProductPay(Map<String, String> paraMap);
}
