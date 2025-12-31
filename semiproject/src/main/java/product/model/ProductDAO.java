package product.model;

import java.sql.SQLException;
import java.util.List;

import product.domain.ProductDTO;
import product.domain.ProductDetailDTO;

public interface ProductDAO {
	//임시: 제품 목록들 출력해보기(select)
	List<ProductDTO> selectProduct() throws SQLException;

	//임시: 제품상세 목록들 출력해보기(select)
	List<ProductDetailDTO> selectProductOption() throws SQLException;

	//임시: 제품상세 정보 가져오기
	ProductDetailDTO selectDetailOne(String test) throws SQLException;
	//제품상세에 대해 부모테이블을 이용하여 제품명, 브랜드명, 설명을 가져오기
	ProductDTO selectOne(String test) throws SQLException;
}
