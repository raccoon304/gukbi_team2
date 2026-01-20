package product.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;

public class ProductDAO_imple implements ProductDAO {
	// DataSource ds ==> 아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private DataSource ds;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 기본 생성자
	public ProductDAO_imple() {
		try {
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			ds = (DataSource)envContext.lookup("SemiProject");
		} catch (NamingException e) {e.printStackTrace();}
	}//end of public ProductDAO_imple()-----
	
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기
	private void close() {
		try {
			if(rs    != null) {rs.close();     rs=null;}
		    if(pstmt != null) {pstmt.close(); pstmt=null;}
		    if(conn  != null) {conn.close();  conn=null;} // DBCP는 자원반납을 해주어야지만 다른 사용자가 사용할 수 있음
		} catch(SQLException e) {e.printStackTrace();}
	}// end of private void close()---------------


	
	//임시--------- 제품 목록 테스트해보기
	@Override
	public List<ProductDTO> selectProduct() throws SQLException {
		List<ProductDTO> productList = new ArrayList<>();
		try {
			conn = ds.getConnection();
			String sql = " select product_code, product_name, brand_name, product_desc, sale_status, image_path "
						+" from tbl_product ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO proDto = new ProductDTO();
				proDto.setProductCode(rs.getString("product_code"));
				proDto.setProductName(rs.getString("product_name"));
				proDto.setBrandName(rs.getString("brand_name"));
				proDto.setProductDesc(rs.getString("product_desc"));
				proDto.setSaleStatus(rs.getString("sale_status"));
				proDto.setImagePath(rs.getString("image_path"));
				productList.add(proDto);
			}
			
		} finally {close();}
		return productList;
	}//end of public List<ProductDTO> selectProduct() throws SQLException-----

	
	
	//받아온 상품코드(상품테이블)의 값을 이용해 제품정보 가져오기(제품명,브랜드,제품설명,제품이미지)
	//여기서 productCode는 상품코드
	@Override
	public ProductDTO selectOne(String productCode) throws SQLException {
		ProductDTO proDto = new ProductDTO();
		
		try {
			conn = ds.getConnection();
			String sql = " SELECT product_code, product_name, brand_name, product_desc, sale_status, image_path, price "
						+" FROM tbl_product "
						+" WHERE product_code = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productCode);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				proDto.setProductCode(rs.getString("product_code"));
				proDto.setProductName(rs.getString("product_name"));
				proDto.setBrandName(rs.getString("brand_name"));
				proDto.setProductDesc(rs.getString("product_desc"));
				proDto.setSaleStatus(rs.getString("sale_status"));
				proDto.setImagePath(rs.getString("image_path"));
				proDto.setPrice(rs.getInt("price"));
			}
		} finally {
			close();
		}
		return proDto;
	}//end of public ProductDetailDTO selectOne(String test) throws SQLException-----
	
	
	
	
	//제품상세 정보 가져오기(여기서 받아온 데이터는 상품테이블의 상품코드값)
	//폼태그로 받아온 productCode를 이용해 상품옵션정보 가져오기
	@Override
	public ProductOptionDTO selectOptionOne(String productCode) throws SQLException {
		ProductOptionDTO proDetilDto = new ProductOptionDTO();
		try {
			conn = ds.getConnection();
			String sql = " SELECT option_id, fk_product_code, P.product_name, color, storage_size, stock_qty, image_path, "
						+"	       brand_name, price, product_desc, (price + plus_price) as total_price, plus_price "
						+" FROM tbl_product_option O "
						+" JOIN tbl_product P "
						+" ON O.fk_product_code = P.product_code "
						+" WHERE product_code = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productCode);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				proDetilDto.setOptionId(rs.getInt("option_id"));
				proDetilDto.setFkProductCode(rs.getString("fk_product_code"));
				proDetilDto.setColor(rs.getString("color"));
				proDetilDto.setStorageSize(rs.getString("storage_size"));
				proDetilDto.setStockQty(rs.getInt("stock_qty"));
				proDetilDto.setTotalPrice(rs.getInt("total_price"));
				proDetilDto.setPlusPrice(rs.getInt("plus_price"));
				
				ProductDTO proDto = new ProductDTO();
				proDto.setProductName(rs.getString("product_name")); //상품명
				proDto.setPrice(rs.getInt("price"));  //상품기본가격(256GB)
				proDto.setBrandName(rs.getString("brand_name"));
				proDto.setProductDesc(rs.getString("product_desc"));
				proDto.setImagePath(rs.getString("image_path"));

				proDetilDto.setProDto(proDto);
			}
		} finally {
			close();
		}
		return proDetilDto;
	}//end of public ProductDetailDTO selectOne(String test) throws SQLException-----

	
	
	//상품페이지의 카드UI용 DTO를 이용해 상품정보 가져오기(상품코드,상품명,브랜드명,이미지경로,가격)
	@Override
	public List<ProductDTO> productCardList() throws SQLException {
		List<ProductDTO> productCardList = new ArrayList<ProductDTO>();
		try {
			conn = ds.getConnection();
			String sql = " SELECT product_code, product_name, brand_name, image_path, price, option_id, color, storage_size "
					+ " FROM tbl_product P "
					+ " JOIN tbl_product_option O "
					+ " ON P.product_code = O.fk_product_code "
					+ " WHERE sale_status = '판매중' "
					+" ORDER BY "
					+" CASE storage_size "
					+"    WHEN '256GB' THEN 1 "
					+"    WHEN '512GB' THEN 2 "
					+"    WHEN '1T' THEN 3 "
					+" END, "
					+" color ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			Map<String, ProductDTO> map = new LinkedHashMap<String, ProductDTO>();
			
			while(rs.next()) {
				String productCode = rs.getString("product_code");
				
				ProductDTO proDto = map.get(productCode);
				if(proDto == null) {
					proDto = new ProductDTO();
					proDto.setProductCode(rs.getString("product_code"));
					proDto.setProductName(rs.getString("product_name"));
					proDto.setBrandName(rs.getString("brand_name"));
					proDto.setImagePath(rs.getString("image_path"));
					proDto.setPrice(rs.getInt("price"));
					proDto.setColorList(new ArrayList<String>());
					proDto.setStorageList(new ArrayList<String>());
					map.put(productCode, proDto);
				}
				
				String color = rs.getString("color");
				String storageSize = rs.getString("storage_size");
				
				if(!proDto.getColorList().contains(color)) {
					proDto.getColorList().add(color);
				}
				if(!proDto.getStorageList().contains(storageSize)) {
					proDto.getStorageList().add(storageSize);
				}
			}
			
			productCardList.addAll(map.values());
		} 
		finally {close();}
		return productCardList;
	}//end of public List<ProductListDTO> productCardList() throws SQLException-----


	
	//제품코드에 따른 추가금을 가져오기(512GB만 추가금이 있으므로 그것만 가져오기
	@Override
	public int selectOptionPlusPrice(String productCode) throws SQLException {
		int plusPrice = 0;
		try {
			conn = ds.getConnection();
			String sql = " SELECT distinct fk_product_code, plus_price "
						+" FROM tbl_product_option "
						+" WHERE storage_size = '512GB' AND fk_product_code = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productCode);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				plusPrice = rs.getInt("plus_price");
			}
			
		} finally {close();}
		return plusPrice;
	}//end of public int selectOptionPlusPrice(String productCode) throws SQLException-----

	
	//장바구니 테이블의 상품에 대해 있는지 없는지 확인하기
	@Override
	public boolean isCartProduct(Map<String, String> paraMap) throws SQLException {
		boolean isCartProduct = false;
		try {
			conn = ds.getConnection();
			String sql = " SELECT * from tbl_cart "
						+" WHERE fk_member_id = ? AND fk_option_id = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("loginUserId"));
			pstmt.setString(2, paraMap.get("productOptionId"));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				isCartProduct = true;
			}
		} finally {close();}
		return isCartProduct;
	}//end of public boolean isCartProduct(Map<String, String> paraMap) throws SQLException-----

	
	//장바구니 테이블에 값 삽입하기 fk_member_id(회원아이디), fk_option_id(옵션아이디), quantity(재고량)
	@Override
	public int insertProductCart(Map<String, String> paraMap) throws SQLException {
		int result = 0;
		try {
			conn = ds.getConnection();
			String sql = " insert into tbl_cart(cart_id, fk_member_id, fk_option_id, quantity) "
						+" values(seq_tbl_cart_cart_id.nextval, ?, ?, ?) ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("loginUserId"));
			pstmt.setString(2, paraMap.get("productOptionId"));
			pstmt.setString(3, paraMap.get("quantity"));
			
			result = pstmt.executeUpdate();
		} finally {close();}
		
		return result;
	}//end of public CartDTO insertProductCart(Map<String, String> paraMap) throws SQLException-----

	
	
	//장바구니 테이블에 재고량 업데이트하기 fk_member_id(회원아이디), fk_option_id(옵션아이디), quantity(재고량)
	@Override
	public int updateProductCart(Map<String, String> paraMap) throws SQLException {
		int result = 0;
		try {
			conn = ds.getConnection();
			String sql = " UPDATE tbl_cart SET quantity = quantity + ? "
						+" WHERE fk_member_id = ? AND fk_option_id = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("quantity"));
			pstmt.setString(2, paraMap.get("loginUserId"));
			pstmt.setString(3, paraMap.get("productOptionId"));

			result = pstmt.executeUpdate();
		} finally {close();}
		
		return result;
	}//end of public void updateProductCart(Map<String, String> paraMap) throws SQLException-----


	
	//상품코드 중복 확인하기(상품코드가 중복된다면 그게 해당하는 옵션[용량,색상,추가금,재고량] 알아오기)
	@Override
	public boolean ckProductCode(String productCode) throws SQLException {
		boolean isProductCode = false;
		
		try {
			conn = ds.getConnection();
			String sql = " SELECT product_code "
						+" FROM tbl_product "
						+" WHERE product_code = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productCode);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				isProductCode = true;
			}
			
		} finally {close();}
		return isProductCode;
	}//end of public boolean ckProductCode(String productCode) throws SQLException-----


	
	//상품명 중복 확인하기
	@Override
	public boolean ckProductName(String productName) throws SQLException {
		boolean isProductName = false;
		
		try {
			conn = ds.getConnection();
			String sql = " SELECT product_name "
						+" FROM tbl_product "
						+" WHERE REPLACE(UPPER(product_name) , ' ', '') = REPLACE(UPPER(?), ' ', '') ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productName);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				isProductName = true;
			}
		} finally {close();}
		return isProductName;
	}//end of public boolean ckProductName(String productName) throws SQLException-----


	
	//상품코드에 해당하는 옵션 값들 DB에 넣어주기
	/*
	@Override
	public int insertProductOption(Map<String, String> paraMap) throws SQLException {
		int result = 0;
		try {
			conn = ds.getConnection();
			String sql = " insert into tbl_product_option(option_id, fk_product_code, color, storage_size, stock_qty, plus_price) "
					+ " values(seq_product_option_id.nextval, ? , ? , ? , ? , ?) ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("productCode"));
			pstmt.setString(1, paraMap.get("color"));
			pstmt.setString(1, paraMap.get("storage"));
			pstmt.setString(1, paraMap.get("stock"));
			pstmt.setString(1, paraMap.get("additionalPrice"));
			
			result = pstmt.executeUpdate();
		}
		finally {close();}
		return result;
	}//end of public int insertProductOption(Map<String, String> paraMap) throws SQLException-----
	*/


	//선택한 옵션(용량, 색상)이 중복옵션인지, 새 옵션인지 알아와서 update/insert 해주기
	@Override
	public int selectInsertOrUpdateOption(Map<String, String> paraMap) throws SQLException {
		int result = 0;
		boolean isDuplicate = false;
		
		try {
			conn = ds.getConnection();
			
			String sql = " select color, storage_size, fk_product_code, stock_qty "
					+ " from tbl_product_option "
					+ " where fk_product_code = ? AND storage_size = ? AND color = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("productCode"));
			pstmt.setString(2, paraMap.get("storage"));
			pstmt.setString(3, paraMap.get("color"));
			
			rs = pstmt.executeQuery();
			isDuplicate = rs.next(); //가져온 행이 있다면 true
			
			if(isDuplicate) {
				//가져온 행이 있음(중복된 행 => 재고량안 update)
				sql = " UPDATE tbl_product_option SET stock_qty = stock_qty + ? "
					+ " WHERE fk_product_code = ? AND storage_size = ? AND color = ? ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, paraMap.get("stock"));
				pstmt.setString(2, paraMap.get("productCode"));
				pstmt.setString(3, paraMap.get("storage"));
				pstmt.setString(4, paraMap.get("color"));
				result = pstmt.executeUpdate();
				
			} else {
				//가져온 행이 없음(새로운 행 => 옵션 등록)
				sql = " insert into tbl_product_option(option_id, fk_product_code, color, storage_size, stock_qty, plus_price) "
						+ " values(seq_product_option_id.nextval, ? , ? , ? , ? , ?) ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, paraMap.get("productCode"));
				pstmt.setString(2, paraMap.get("color"));
				pstmt.setString(3, paraMap.get("storage"));
				pstmt.setString(4, paraMap.get("stock"));
				pstmt.setString(5, paraMap.get("additionalPrice"));
				
				result = pstmt.executeUpdate();
			}//end of if~else()-----
			
		}
		finally {close();}
		return result;
	}//end of public boolean selectDuplicateOption(Map<String, String> paraMap) throws SQLException-----


	//새로운 상품을 테이블에 삽입해주기(추가 이미지는 트랙잭션 처리하여 같이 넣기)
	@Override
	public int insertProduct(ProductDTO proDto) throws SQLException {
		int n = 0;
		try {
			conn = ds.getConnection();
			String sql = " insert into tbl_product(product_code, product_name, brand_name, product_desc, sale_status, image_path, price) "
						+" values(?, ?, ?, ?, ?, ?, ?) ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, proDto.getProductCode());
			pstmt.setString(2, proDto.getProductName());
			pstmt.setString(3, proDto.getBrandName());
			pstmt.setString(4, proDto.getProductDesc());
			pstmt.setString(5, proDto.getSaleStatus());
			pstmt.setString(6, proDto.getImagePath());
			pstmt.setInt(7, proDto.getPrice());
			
			n = pstmt.executeUpdate();
		}
		finally {close();}
		return n;
	}//end of public int insertProduct(ProductDTO proDto) throws SQLException-----

	//새로운 상품에 대한 옵션들 삽입해주기
	@Override
	public int selectInsertOption(Map<String, String> paraMap) throws SQLException {
		int result = 0;
		try {
			conn = ds.getConnection();
			//가져온 행이 없음(새로운 행 => 옵션 등록)
			String sql = " insert into tbl_product_option(option_id, fk_product_code, color, storage_size, stock_qty, plus_price) "
					+ " values(seq_product_option_id.nextval, ? , ? , ? , ? , ?) ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("productCode"));
			pstmt.setString(2, paraMap.get("color"));
			pstmt.setString(3, paraMap.get("storage"));
			pstmt.setString(4, paraMap.get("stock"));
			pstmt.setString(5, paraMap.get("additionalPrice"));
			
			result = pstmt.executeUpdate();
		} 
		finally {close();}
		return result;
	}//end of public int selectInsertOption(Map<String, String> paraMap) throws SQLException-----


	//제품 코드에 따른 옵션들 모두 가져오기
	@Override
	public List<ProductOptionDTO> selectAllOption(String productCode) throws SQLException {
		List<ProductOptionDTO> proOptionList = new ArrayList<ProductOptionDTO>();
		try {
			conn = ds.getConnection();
			String sql = " SELECT fk_product_code, option_id, color, storage_size, plus_price, stock_qty "
						+" FROM tbl_product_option "
						+" WHERE fk_product_code = ? "
						+" ORDER BY "
						+" CASE storage_size "
						+"    WHEN '256GB' THEN 1 "
						+"    WHEN '512GB' THEN 2 "
						+"    WHEN '1T' THEN 3 "
						+" END, "
						+" color ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productCode);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ProductOptionDTO proOptionDto = new ProductOptionDTO();
				proOptionDto.setOptionId(rs.getInt("option_id"));
				proOptionDto.setColor(rs.getString("color"));
				proOptionDto.setStorageSize(rs.getString("storage_size"));
				proOptionDto.setPlusPrice(rs.getInt("plus_price"));
				proOptionDto.setStockQty(rs.getInt("stock_qty"));
				
				proOptionList.add(proOptionDto);
			}//end of while()-----
			
		}
		finally {close();}
		return proOptionList;
	}//end of public List<ProductOptionDTO> selectAllOption(String productCode) throws SQLException-----


	//제품의 추가 이미지 가져오기
	@Override
	public List<String> selectPlusImage(String productCode) throws SQLException {
		List<String> plusProductImages = new ArrayList<String>();
		try {
			conn = ds.getConnection();
			String sql = " SELECT product_code, plus_image_path "
					+ " FROM tbl_product P "
					+ " JOIN tbl_product_image I "
					+ " ON P.product_code = I.fk_product_code_image "
					+ " WHERE product_code = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productCode);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				plusProductImages.add(rs.getString("plus_image_path"));
			}
		}
		
		finally {close();}
		return plusProductImages;
	}//end of public List<ProductDTO> selectPlusImage(String productCode) throws SQLException-----


	//추가 이미지를 테이블에 삽입해주기
	@Override
	public int insertProductImages(String productCode, String subImage) throws SQLException {
		int n1 = 0;
		try {
			conn = ds.getConnection();
			String sql = " INSERT INTO tbl_product_image(image_id, fk_product_code_image, plus_image_path) "
						+" VALUES(SEQ_PRODUCT_IMAGE.nextval, ?, ?) ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, productCode);
			pstmt.setString(2, subImage);
			n1 = pstmt.executeUpdate();
			
		}
		finally {close();}
		return n1;
	}//end of public int insertProductImages(Map<String, String> paraMap) throws SQLException-----


	
	
	
	
}
