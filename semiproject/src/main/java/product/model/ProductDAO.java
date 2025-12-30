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
}
