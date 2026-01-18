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

	//상품코드에 해당하는 옵션 값들 DB에 넣어주기
	//int insertProductOption(Map<String, String> paraMap) throws SQLException;

	//선택한 옵션(용량, 색상)이 중복옵션인지, 새 옵션인지 알아와서 update/insert 해주기
	int selectInsertOrUpdateOption(Map<String, String> paraMap) throws SQLException;

	//새로운 상품을 테이블에 삽입해주기(추가 이미지는 트랙잭션 처리하여 같이 넣기)
	int insertProduct(ProductDTO proDto) throws SQLException;
	//새로운 상품에 대한 옵션들 삽입해주기
	int selectInsertOption(Map<String, String> paraMap) throws SQLException;
	
	//추가 이미지를 테이블에 삽입해주기
	int insertProductImages(String productCode, String subImage) throws SQLException;

	//제품 코드에 따른 옵션들 모두 가져오기
	List<ProductOptionDTO> selectAllOption(String productCode) throws SQLException;

	//제품의 추가 이미지 가져오기
	List<String> selectPlusImage(String productCode) throws SQLException;

}
