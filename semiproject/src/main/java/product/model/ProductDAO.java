package product.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;

public interface ProductDAO {
	//임시: 제품 목록들 전부 출력해 가져오기(select)
	List<ProductDTO> selectProduct() throws SQLException;

	//제품에 대한 옵션 리스트로 전부 검색하기(select)
	//List<ProductOptionDTO> selectProductOption() throws SQLException;

	//받아온 상품코드(상품테이블)의 값을 이용해 제품정보 가져오기
	ProductDTO selectOne(String productCode) throws SQLException;
	
	//임시: 받아온 상품코드(상품테이블)의 값을 이용해 상품상세값 가져오기
	ProductOptionDTO selectOptionOne(String productCode) throws SQLException;

	//가져온 상품코드로 이에 맞는 옵션값들 리스트로 가져오기
	//List<ProductOptionDTO> selectProductOption(String productCode) throws SQLException;

	//상품페이지의 카드UI용 DTO를 이용해 상품정보 가져오기(상품코드,상품명,브랜드명,이미지경로,가격)
	List<ProductDTO> productCardList() throws SQLException;

	//제품코드에 따른 옵션 중 512GB의 추가금 리스트로 전부 가져오기
	//List<ProductOptionDTO> selectOptionPlusPrice() throws SQLException;
	Map<String, String> selectOptionPlusPrice() throws SQLException;
}
