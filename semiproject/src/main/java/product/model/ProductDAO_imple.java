package product.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import product.domain.ProductDTO;
import product.domain.ProductDetailDTO;

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
		List<ProductDTO> proList = new ArrayList<>();
		try {
			conn = ds.getConnection();
			String sql = " select product_code, product_name, brand_name, product_desc, sale_status "
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
				proList.add(proDto);
			}
			
		} finally {close();}
		return proList;
	}//end of public List<ProductDTO> selectProduct() throws SQLException-----


	//임시--------- 제품상세 목록 테스트해보기
	@Override
	public List<ProductDetailDTO> selectProductOption() throws SQLException {
		List<ProductDetailDTO> proOptionList = new ArrayList<>();
		try {
			conn = ds.getConnection();
			String sql = " SELECT option_id,fk_product_code,color,storage_size,price,stock_qty,image_path "
						+" FROM tbl_product_option ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDetailDTO proDetailDto = new ProductDetailDTO();
				proDetailDto.setOptionId(rs.getInt("option_id"));
				proDetailDto.setFkProductCode(rs.getString("fk_product_code"));
				proDetailDto.setColor(rs.getString("color"));
				proDetailDto.setStorageSize(rs.getString("storage_size"));
				proDetailDto.setPrice(rs.getInt("price"));
				proDetailDto.setStockQty(rs.getInt("stock_qty"));
				proDetailDto.setImagePath(rs.getString("image_path"));

				proOptionList.add(proDetailDto);
			}
		} finally {close();}
		return proOptionList;
	}//end of public List<ProductDTO> selectProductOption() throws SQLException-----
	
	
	
	
	
	
}
