package review.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import member.domain.MemberDTO;
import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;
import review.domain.ReviewDTO;

public class ReviewDAO_imple implements ReviewDAO {

	
	private DataSource ds;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 기본 생성자
	public ReviewDAO_imple() {
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
	
	
	
	// 리뷰 총 개수 (선택 상품 기준)
    @Override
    public int getTotalReviewCount(Map<String, String> paraMap) throws SQLException {

    	int totalCount = 0;
        String productCode = paraMap.get("productCode");

        boolean isAll = (productCode == null || productCode.trim().isEmpty() || "ALL".equalsIgnoreCase(productCode.trim()));

        try {
            conn = ds.getConnection();

            String sql = " SELECT count(*) "
                       + " FROM tbl_review r "
                       + " JOIN tbl_product_option po ON po.option_id = r.fk_option_id "
                       + " WHERE r.deleted_yn = 0 ";

            if(!isAll) {
                sql += " AND po.fk_product_code = ? ";
            }

            pstmt = conn.prepareStatement(sql);

            if(!isAll) {
                pstmt.setString(1, productCode);
            }

            rs = pstmt.executeQuery();
            rs.next();
            totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }// end of public int getTotalReviewCount(Map<String, String> paraMap) throws SQLException -------

    
    // 총 페이지 수
    @Override
    public int getTotalPage(Map<String, String> paraMap) throws SQLException {

        int totalPage = 0;

        int totalCount = getTotalReviewCount(paraMap);
        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));

        totalPage = (int) Math.ceil((double) totalCount / sizePerPage);

        if(totalPage == 0) totalPage = 1;

        return totalPage;
    }// end of public int getTotalPage(Map<String, String> paraMap) throws SQLException -------

    
    // 통계(총개수/평균/별점분포)
    @Override
    public Map<String, Object> getReviewStat(Map<String, String> paraMap) throws SQLException {

    	 Map<String, Object> stat = new HashMap<>();
    	    String productCode = paraMap.get("productCode");

    	    boolean isAll = (productCode == null || productCode.trim().isEmpty() || "ALL".equalsIgnoreCase(productCode.trim()));

    	    try {
    	        conn = ds.getConnection();

    	        String sql = " SELECT count(*) AS total_cnt "
    	                   + "      , nvl(round(avg(r.rating), 1), 0) AS avg_rating "
    	                   + "      , sum(case when round(r.rating) = 5 then 1 else 0 end) AS cnt5 "
    	                   + "      , sum(case when round(r.rating) = 4 then 1 else 0 end) AS cnt4 "
    	                   + "      , sum(case when round(r.rating) = 3 then 1 else 0 end) AS cnt3 "
    	                   + "      , sum(case when round(r.rating) = 2 then 1 else 0 end) AS cnt2 "
    	                   + "      , sum(case when round(r.rating) = 1 then 1 else 0 end) AS cnt1 "
    	                   + " FROM tbl_review r "
    	                   + " JOIN tbl_product_option po ON po.option_id = r.fk_option_id "
    	                   + " WHERE r.deleted_yn = 0 ";

    	        if(!isAll) {
    	            sql += " AND po.fk_product_code = ? ";
    	        }

    	        pstmt = conn.prepareStatement(sql);

    	        if(!isAll) {
    	            pstmt.setString(1, productCode);
    	        }

    	        rs = pstmt.executeQuery();

    	        if (rs.next()) {
    	            stat.put("totalCnt", rs.getInt("total_cnt"));
    	            stat.put("avgRating", rs.getDouble("avg_rating"));
    	            stat.put("cnt5", rs.getInt("cnt5"));
    	            stat.put("cnt4", rs.getInt("cnt4"));
    	            stat.put("cnt3", rs.getInt("cnt3"));
    	            stat.put("cnt2", rs.getInt("cnt2"));
    	            stat.put("cnt1", rs.getInt("cnt1"));
    	        }

    	    } finally {
    	        close();
    	    }

    	    return stat;
    }// end of public Map<String, Object> getReviewStat(Map<String, String> paraMap) throws SQLException -------

    
    // 리뷰 리스트(페이징처리)
    @Override
    public List<ReviewDTO> selectReviewPaging(Map<String, String> paraMap) throws SQLException {

    	 List<ReviewDTO> list = new ArrayList<>();

    	    String productCode = paraMap.get("productCode");
    	    String sort = paraMap.get("sort"); // latest / high / low

    	    
    	    
    	    boolean isAll = (productCode == null || productCode.trim().isEmpty() || "ALL".equalsIgnoreCase(productCode.trim()));

    	    int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
    	    int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));

    	    int startRno = (currentShowPageNo - 1) * sizePerPage + 1;
    	    int endRno = currentShowPageNo * sizePerPage;

    	    String orderBy = " r.writeday desc, r.review_number desc "; // 최신순
    	    
			if ("old".equals(sort)) {
			    orderBy = " r.writeday asc, r.review_number asc ";       // 오래된순
			} 
			else if ("high".equals(sort)) {
    	        orderBy = " r.rating desc, r.writeday desc, r.review_number desc "; // 별점높은순
    	    }
			else if ("low".equals(sort)) {
    	        orderBy = " r.rating asc, r.writeday desc, r.review_number desc "; // 별점낮은순
    	    }

    	    try {
    	        conn = ds.getConnection();

    	        String sql = " SELECT review_number, option_id, order_detail_id, rating, review_title, review_content "
    	                + "      , writeday, member_id, member_name "
    	                + "      , brand_name, product_name, color, storage_size "
    	                + "      , thumb_path "
    	                + " FROM ( "
    	                + "   SELECT ROW_NUMBER() OVER(ORDER BY " + orderBy + ") AS rno "
    	                + "        , r.review_number "
    	                + "        , r.fk_option_id AS option_id "
    	                + "        , r.fk_order_detail_id AS order_detail_id "
    	                + "        , r.rating "
    	                + "        , r.review_title "
    	                + "        , r.review_content "
    	                + "        , to_char(r.writeday, 'yyyy-mm-dd') AS writeday "
    	                + "        , m.member_id AS member_id "
    	                + "        , m.name AS member_name "
    	                + "        , p.brand_name AS brand_name "
    	                + "        , p.product_name AS product_name "
    	                + "        , po.color AS color "
    	                + "        , po.storage_size AS storage_size "
    	                + "        , (SELECT ri.image_path "
    	                + "             FROM tbl_review_image ri "
    	                + "            WHERE ri.fk_review_number = r.review_number "
    	                + "            ORDER BY ri.sort_no ASC, ri.review_image_id ASC "
    	                + "            fetch first 1 rows only "
    	                + "          ) AS thumb_path "
    	                + "   FROM tbl_review r "
    	                + "   JOIN tbl_product_option po ON po.option_id = r.fk_option_id "
    	                + "   JOIN tbl_product p ON p.product_code = po.fk_product_code "
    	                + "   JOIN tbl_order_detail od ON od.order_detail_id = r.fk_order_detail_id "
    	                + "   JOIN tbl_orders o ON o.order_id = od.fk_order_id "
    	                + "   JOIN tbl_member m ON m.member_id = o.fk_member_id "
    	                + "   WHERE r.deleted_yn = 0 ";

    	        if(!isAll) {
    	        		sql += " AND po.fk_product_code = ? ";
    	        }

    	        sql += " ) WHERE rno BETWEEN ? AND ? ";

    	        pstmt = conn.prepareStatement(sql);

    	        int idx = 1;

    	        if(!isAll) {
    	            pstmt.setString(idx++, productCode);
    	        }

    	        pstmt.setInt(idx++, startRno);
    	        pstmt.setInt(idx++, endRno);

    	        rs = pstmt.executeQuery();

    	        while (rs.next()) {
    	            ReviewDTO dto = new ReviewDTO();
    	            ProductDTO pdto = new ProductDTO();
    	            ProductOptionDTO podto = new ProductOptionDTO();

    	            dto.setReviewNumber(rs.getInt("review_number"));
    	            dto.setOptionId(rs.getInt("option_id"));
    	            dto.setOrderDetailId(rs.getInt("order_detail_id"));

    	            dto.setRating(rs.getDouble("rating"));
    	            dto.setReviewContent(rs.getString("review_content"));
    	            dto.setWriteday(rs.getString("writeday"));

    	            MemberDTO mdto = new MemberDTO();
    	            
    	            mdto.setMemberid(rs.getString("member_id"));
    	            mdto.setName(rs.getString("member_name"));
    	            
    	            dto.setMdto(mdto);
    	            
    	            dto.setThumbPath(rs.getString("thumb_path"));

    	            dto.setReviewTitle(rs.getString("review_title"));
    	            
    	            pdto.setBrandName(rs.getString("brand_name"));
    	            pdto.setProductName(rs.getString("product_name"));
    	            
    	            podto.setColor(rs.getString("color"));
    	            podto.setStorageSize(rs.getString("storage_size"));
    	            
    	            dto.setPdto(pdto);
    	            dto.setPodto(podto);
    	            
    	            list.add(dto);
    	        }

    	    } finally {
    	        close();
    	    }

    	    return list;
    }// end of public List<ReviewDTO> selectReviewPaging(Map<String, String> paraMap) throws SQLException -------
	
	
	
 // 내 구매(PAID)인지, 이미 리뷰 있는지 확인
    @Override
    public boolean canWriteReview(String memberId, int orderDetailId) throws Exception {
    	boolean ok = false;

        try {
            conn = ds.getConnection();

            String sql = " SELECT CASE WHEN count(*) = 1 THEN 1 ELSE 0 END AS ok "
                       + " FROM tbl_order_detail od "
                       + " JOIN tbl_orders o ON o.order_id = od.fk_order_id "
                       + " WHERE od.order_detail_id = ? "
                       + "   AND o.fk_member_id = ? "
                       + "   AND o.order_status = 'PAID' "
                       + "   AND o.delivery_status = 2 " 
                       + "   AND NVL(od.is_review_written,0) = 0 "
                       + "   AND NOT EXISTS ( "
                       + "        SELECT 1 "
                       + "        FROM tbl_review r "
                       + "        WHERE r.fk_order_detail_id = od.order_detail_id "
                       + "          AND NVL(r.deleted_yn,0) = 0 "
                       + "   ) ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderDetailId);
            pstmt.setString(2, memberId);

            rs = pstmt.executeQuery();
            if(rs.next()) {
                ok = (rs.getInt("ok") == 1);
            }

        } finally {
            close();
        }

        return ok;
    }// end of public boolean canWriteReview(String memberId, int orderDetailId) throws Exception -------

    
    // 리뷰 작성 - 안쓸것같음
    @Override
    public int insertReview(int optionId, int orderDetailId, String content, double rating) throws Exception {

    	 int reviewNumber = 0;

    	    try {
    	        conn = ds.getConnection();
    	        conn.setAutoCommit(false); // 수동커밋

    	        // PK 채번하기
    	        String sql1 = " SELECT seq_tbl_review_review_number.nextval AS review_number "
    	        		        + " FROM dual ";
    	        pstmt = conn.prepareStatement(sql1);
    	        rs = pstmt.executeQuery();
    	        
    	        if(rs.next()) {
    	        		reviewNumber = rs.getInt("review_number");
    	        }
    	        rs.close(); rs = null;
    	        pstmt.close(); pstmt = null;

    	        // 리뷰 insert
    	        String sql2 =
    	            " INSERT INTO tbl_review " +
    	            " (review_number, fk_option_id, fk_order_detail_id, review_content, rating) " +
    	            " VALUES (?, ?, ?, ?, ?) ";

    	        pstmt = conn.prepareStatement(sql2);
    	        pstmt.setInt(1, reviewNumber);
    	        pstmt.setInt(2, optionId);
    	        pstmt.setInt(3, orderDetailId);
    	        pstmt.setString(4, content);
    	        pstmt.setDouble(5, rating);

    	        int n1 = pstmt.executeUpdate();
    	        pstmt.close(); pstmt = null;

    	        if(n1 != 1) {
    	            conn.rollback();
    	            throw new SQLException("리뷰 작성 실패");
    	        }

    	        // 주문상세 is_review_written 업데이트
    	        String sql3 = " update tbl_order_detail "
    	        			    + " set is_review_written = 1 "
    	        			    + " where order_detail_id = ? "
    	        			    + "   and is_review_written = 0 ";

    	        pstmt = conn.prepareStatement(sql3);
    	        pstmt.setInt(1, orderDetailId);

    	        int n2 = pstmt.executeUpdate();
    	        pstmt.close(); pstmt = null;

    	        if(n2 != 1) {
    	            conn.rollback();
    	            throw new SQLException("주문상세 리뷰작성 업데이트 실패");
    	        }

    	        conn.commit(); // 커밋
    	    } catch(Exception e) {
    	        if(conn != null) conn.rollback(); // 실패하면 롤백
    	        throw e;
    	    } finally {
    	        if(conn != null) conn.setAutoCommit(true); // 다시 오토커밋으로
    	        close();
    	    }

    	    return reviewNumber;
    }// end of  public int insertReview(int optionId, int orderDetailId, String content, double rating) throws Exception -------

    
    // 리뷰에 이미지 insert - 안쓸것같음
    @Override
    public int insertReviewImage(int reviewNumber, String imagePath, int sortNo) throws Exception {

        int n = 0;

        try {
            conn = ds.getConnection();

            String sql = " INSERT INTO tbl_review_image "
            			   + " (review_image_id, fk_review_number, image_path, sort_no) "
                       + " VALUES (seq_tbl_review_image_number_id.nextval, ?, ?, ?) ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reviewNumber);
            pstmt.setString(2, imagePath);
            pstmt.setInt(3, sortNo);

            n = pstmt.executeUpdate();
        } finally {
            close();
        }

        return n;
    }


    // 리뷰 작성 + 이미지 업로드
    @Override
    public int insertReviewWithImages(String memberId, int optionId, int orderDetailId, String title, String content, double rating,
                                      List<Map<String, Object>> images) throws Exception {

    	int reviewNumber = 0;

        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false); // 수동커밋으로 전환

            
            if(title == null) title = "";
            title = title.trim();

            // === 작성 가능 여부 검증 ===
            String sql0 = " SELECT CASE WHEN count(*) = 1 THEN 1 ELSE 0 END AS ok "
                        + " FROM tbl_order_detail od "
                        + " JOIN tbl_orders o ON o.order_id = od.fk_order_id "
                        + " WHERE od.order_detail_id = ? "
                        + "   AND o.fk_member_id = ? "
                        + "   AND o.order_status = 'PAID' "
                        + "   AND o.delivery_status = 2 "
                        + "   AND NVL(od.is_review_written,0) = 0 "
                        + "   AND NOT EXISTS ( "
                        + "        SELECT 1 FROM tbl_review r "
                        + "        WHERE r.fk_order_detail_id = od.order_detail_id "
                        + "          AND NVL(r.deleted_yn,0) = 0 "
                        + "   ) ";

            pstmt = conn.prepareStatement(sql0);
            pstmt.setInt(1, orderDetailId);
            pstmt.setString(2, memberId);
            rs = pstmt.executeQuery();

            int ok = 0;
            if(rs.next()) ok = rs.getInt("ok");

            rs.close(); rs=null;
            pstmt.close(); pstmt=null;

            if(ok != 1) {
                conn.rollback();
                throw new SQLException("리뷰 작성 불가");
            }

            // === 리뷰번호 채번 ===
            String sql1 = " SELECT seq_tbl_review_review_number.nextval AS review_number "
            		        + " FROM dual ";
            pstmt = conn.prepareStatement(sql1);
            rs = pstmt.executeQuery();

            if(rs.next()) reviewNumber = rs.getInt("review_number");

            rs.close(); rs=null;
            pstmt.close(); pstmt=null;

            if(reviewNumber == 0) {
                conn.rollback();
                throw new SQLException("리뷰번호 채번 실패");
            }

            // === 리뷰 insert ===
            String sql2 = " INSERT INTO tbl_review "
                        + " (review_number, fk_option_id, fk_order_detail_id, review_title, review_content, rating) "
                        + " VALUES (?, ?, ?, ?, ?, ?) ";

            pstmt = conn.prepareStatement(sql2);
            pstmt.setInt(1, reviewNumber);
            pstmt.setInt(2, optionId);
            pstmt.setInt(3, orderDetailId);
            pstmt.setString(4, title);
            pstmt.setString(5, content);
            pstmt.setDouble(6, rating);

            int n1 = pstmt.executeUpdate();
            pstmt.close(); pstmt=null;

            if(n1 != 1) {
                conn.rollback();
                throw new SQLException("리뷰 insert 실패");
            }

            // === 리뷰 이미지 insert ===
            if(images != null && !images.isEmpty()) {

                String sqlImg = " INSERT INTO tbl_review_image "
                              + " (review_image_id, fk_review_number, image_path, sort_no) "
                              + " VALUES (seq_tbl_review_image_number_id.nextval, ?, ?, ?) ";

                pstmt = conn.prepareStatement(sqlImg);

                for(Map<String, Object> img : images) {

                    String imagePath = (String) img.get("imagePath");
                    Integer sortNoObj = (Integer) img.get("sortNo");  // 컨트롤러에서 Integer로 넣는다고 가정

                    if(imagePath == null || imagePath.isBlank()) continue;
                    if(sortNoObj == null || sortNoObj.intValue() <= 0) continue;

                    pstmt.setInt(1, reviewNumber);
                    pstmt.setString(2, imagePath);
                    pstmt.setInt(3, sortNoObj);

                    int nImg = pstmt.executeUpdate();
                    if(nImg != 1) {
                        conn.rollback();
                        throw new SQLException("리뷰이미지 insert 실패");
                    }
                }

                pstmt.close(); pstmt=null;
            }

            // === 주문상세 is_review_written 업데이트 ===
            String sql3 = " UPDATE tbl_order_detail "
                        + " SET is_review_written = 1 "
                        + " WHERE order_detail_id = ? "
                        + "   AND NVL(is_review_written,0) = 0 ";

            pstmt = conn.prepareStatement(sql3);
            pstmt.setInt(1, orderDetailId);

            int n2 = pstmt.executeUpdate();
            pstmt.close(); pstmt=null;

            if(n2 != 1) {
                conn.rollback(); // 롤백
                throw new SQLException("주문상세 업데이트 실패");
            }

            conn.commit(); // 커밋

        } catch(Exception e) {
            if(conn != null) conn.rollback();
            throw e;

        } finally {
            if(conn != null) conn.setAutoCommit(true); // 오토커밋으로 전환
            close();
        }

        return reviewNumber;
    }
    
    
	@Override
	public List<Map<String, Object>> getWritableOrderDetailList(String memberId, String productCode) throws SQLException {
		
		List<Map<String, Object>> list = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT od.order_detail_id "
	                   + "      , od.fk_option_id "
	                   + "      , ( NVL(p.brand_name,'') || ' ' || NVL(p.product_name,'') || ' / ' "
	                   + "         || NVL(po.color,'') || ' / ' || NVL(po.storage_size,'') ) AS option_name "
	                   + "      , ( NVL(p.price,0) + NVL(po.plus_price,0) ) AS option_total_price "
	                   + "      , po.fk_product_code AS product_code "
	                   + " FROM tbl_order_detail od "
	                   + " JOIN tbl_orders o "
	                   + "   ON o.order_id = od.fk_order_id "
	                   + " JOIN tbl_product_option po "
	                   + "   ON po.option_id = od.fk_option_id "
	                   + " JOIN tbl_product p "
	                   + "   ON p.product_code = po.fk_product_code "
	                   + " WHERE o.fk_member_id = ? "
	                   + "   AND o.order_status = 'PAID' "
	                   + "   AND o.delivery_status = 2 "
	                   + "   AND NVL(od.is_review_written, 0) = 0 "
	                   + "   AND NOT EXISTS ( "
	                   + "        SELECT 1 FROM tbl_review r "
	                   + "        WHERE r.fk_order_detail_id = od.order_detail_id "
	                   + "          AND NVL(r.deleted_yn,0) = 0 "
	                   + "   ) ";

	        // ALL이면 상품코드 조건을 빼고, 특정 상품이면 조건을 붙임
	        boolean isAll = (productCode == null || productCode.trim().isEmpty() || "ALL".equalsIgnoreCase(productCode.trim()));

	        if(!isAll) {
	            sql += " AND po.fk_product_code = ? ";
	        }

	        sql += " ORDER BY od.order_detail_id DESC ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, memberId);

	        if(!isAll) {
	            pstmt.setString(2, productCode.trim());
	        }

	        rs = pstmt.executeQuery();
	        while(rs.next()) {

	            Map<String, Object> map = new HashMap<>();
	            map.put("orderDetailId", rs.getInt("order_detail_id"));
	            map.put("optionId", rs.getInt("fk_option_id"));
	            map.put("optionName", rs.getString("option_name"));
	            map.put("optionTotalPrice", rs.getInt("option_total_price"));
	            map.put("productCode", rs.getString("product_code"));

	            list.add(map);
	        }

	    } finally {
	        close();
	    }

	    return list;
	}// end of public List<Map<String, Object>> getWritableOrderDetailList(String memberId, String productCode) throws SQLException -------
    
    
	// ORDER_DETAIL_ID 로 OPTION_ID 조회
	@Override
    public int getOptionIdByOrderDetailId(String memberId, int orderDetailId) throws SQLException {

        int optionId = 0;

        try {
            conn = ds.getConnection();

            String sql = " SELECT od.fk_option_id "
                       + " FROM tbl_order_detail od "
                       + " JOIN tbl_orders o ON o.order_id = od.fk_order_id "
                       + " WHERE od.order_detail_id = ? "
                       + "   AND o.fk_member_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderDetailId);
            pstmt.setString(2, memberId);

            rs = pstmt.executeQuery();
            if(rs.next()) {
                optionId = rs.getInt(1);
            }

        } finally {
            close();
        }

        return optionId;
    }// end of public int getOptionIdByOrderDetailId(...) -------
	
	
	
	// 리뷰 상세 1건 조회
	@Override
	public ReviewDTO selectReviewDetail(int reviewNumber) throws SQLException {

	    ReviewDTO dto = null;

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT r.review_number, r.review_title, r.review_content, r.rating "
	                   + "      , to_char(r.writeday, 'yyyy-mm-dd') AS writeday "
	                   + "      , m.member_id AS member_id "
	                   + "      , p.brand_name AS brand_name "
	                   + "      , p.product_name AS product_name "
	                   + "      , po.color AS color "
	                   + "      , po.storage_size AS storage_size "
	                   + " FROM tbl_review r "
	                   + " JOIN tbl_product_option po ON po.option_id = r.fk_option_id "
	                   + " JOIN tbl_product p ON p.product_code = po.fk_product_code "
	                   + " JOIN tbl_order_detail od ON od.order_detail_id = r.fk_order_detail_id "
	                   + " JOIN tbl_orders o ON o.order_id = od.fk_order_id "
	                   + " JOIN tbl_member m ON m.member_id = o.fk_member_id "
	                   + " WHERE r.review_number = ? "
	                   + "   AND r.deleted_yn = 0 ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, reviewNumber);

	        rs = pstmt.executeQuery();

	        if(rs.next()) {
	            dto = new ReviewDTO();
	            dto.setReviewNumber(rs.getInt("review_number"));
	            dto.setReviewTitle(rs.getString("review_title"));
	            dto.setReviewContent(rs.getString("review_content"));
	            dto.setRating(rs.getDouble("rating"));
	            dto.setWriteday(rs.getString("writeday"));

	            MemberDTO mdto = new MemberDTO();
	            
	            mdto.setMemberid(rs.getString("member_id"));
	            dto.setMdto(mdto);
	            
	            ProductDTO pdto = new ProductDTO();
	            
	            pdto.setBrandName(rs.getString("brand_name"));
	            pdto.setProductName(rs.getString("product_name"));
	            dto.setPdto(pdto);
	            
	            ProductOptionDTO podto = new ProductOptionDTO();
	            
	            podto.setColor(rs.getString("color"));
	            podto.setStorageSize(rs.getString("storage_size"));
	            dto.setPodto(podto);
	        }

	    } finally {
	        close();
	    }

	    return dto;
	}

	
	// 리뷰 이미지 전체 조회
	@Override
	public List<String> selectReviewImageList(int reviewNumber) throws SQLException {

	    List<String> imgList = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT image_path "
	                   + " FROM tbl_review_image "
	                   + " WHERE fk_review_number = ? "
	                   + " ORDER BY sort_no ASC, review_image_id ASC ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, reviewNumber);

	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            imgList.add(rs.getString("image_path"));
	        }

	    } finally {
	        close();
	    }

	    return imgList;
	}


	// 리뷰 삭제(소프트삭제) + 이미지 삭제 + 주문상세 주문상세 is_review_written=0
	@Override
	public int deleteReview(String memberid, int reviewNumber) throws SQLException {
	
	    int n = 0;
	    int orderDetailId = 0;

	    try {
	        conn = ds.getConnection();
	        conn.setAutoCommit(false); // 수동커밋으로

	      
	        String sql1 = " SELECT r.fk_order_detail_id AS order_detail_id "
			            + " FROM tbl_review r "
			            + " JOIN tbl_order_detail od ON od.order_detail_id = r.fk_order_detail_id "
			            + " JOIN tbl_orders o ON o.order_id = od.fk_order_id "
			            + " WHERE r.review_number = ? "
			            + "   AND r.deleted_yn = 0 "
			            + "   AND o.fk_member_id = ? ";

	        pstmt = conn.prepareStatement(sql1);
	        pstmt.setInt(1, reviewNumber);
	        pstmt.setString(2, memberid);
	        rs = pstmt.executeQuery();

	        if(rs.next()) {
	            orderDetailId = rs.getInt("order_detail_id");
	        }

	        rs.close(); rs=null;
	        pstmt.close(); pstmt=null;

	        if(orderDetailId == 0) { // 삭제할 수 없는 상태(권한없음/글없음)
	            conn.rollback(); // 롤백
	            return 0;
	        }

	        // 리뷰 이미지 삭제
	        String sql2 = " DELETE FROM tbl_review_image "
	                    + " WHERE fk_review_number = ? ";
	        pstmt = conn.prepareStatement(sql2);
	        pstmt.setInt(1, reviewNumber);
	        pstmt.executeUpdate();
	        pstmt.close(); pstmt=null;

	        // 리뷰 삭제(소프트삭제)
	        String sql3 = " UPDATE tbl_review " 
			            + " SET deleted_yn = 1, deleted_at = SYSDATE, deleted_by = ? "
			            + " WHERE review_number = ? "
			            + " AND deleted_yn = 0 ";
	        pstmt = conn.prepareStatement(sql3);
	        pstmt.setString(1, memberid);
	        pstmt.setInt(2, reviewNumber);

	        n = pstmt.executeUpdate();
	        pstmt.close(); pstmt=null;

	        if(n != 1) {
	            conn.rollback(); // 롤백
	            return 0;
	        }

	        // 주문상세에 다시 리뷰 작성 가능하도록 is_review_written 값 0으로
	        String sql4 = " UPDATE tbl_order_detail "
	            		   + " SET is_review_written = 0 "
	            		   + " WHERE order_detail_id = ? ";
	        pstmt = conn.prepareStatement(sql4);
	        pstmt.setInt(1, orderDetailId);
	        pstmt.executeUpdate();
	        pstmt.close(); pstmt=null;

	        conn.commit(); // 커밋

	    } catch(Exception e) {
	        if(conn != null) conn.rollback(); // 롤백
	        throw e;
	    } finally {
	        if(conn != null) conn.setAutoCommit(true); // 오토커밋으로
	        close();
	    }

	    return n;
		

		
	}


	// 수정용: 내 리뷰 1건 가져오기
	@Override
	public Map<String, String> getReviewForEdit(int reviewNumber, String memberId) throws SQLException {
		

	    Map<String, String> map = null;

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT r.review_number "
	                   + "      , r.review_title "
	                   + "      , r.review_content "
	                   + "      , to_char(r.writeday,'yyyy-mm-dd') AS writeday "
	                   + "      , r.rating "
	                   + " FROM tbl_review r "
	                   + " JOIN tbl_order_detail od ON od.order_detail_id = r.fk_order_detail_id "
	                   + " JOIN tbl_orders o ON o.order_id = od.fk_order_id "
	                   + " WHERE r.review_number = ? "
	                   + "   AND r.deleted_yn = 0 "
	                   + "   AND o.fk_member_id = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, reviewNumber);
	        pstmt.setString(2, memberId);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            map = new java.util.HashMap<>();
	            map.put("reviewNumber", String.valueOf(rs.getInt("review_number")));
	            map.put("reviewTitle", rs.getString("review_title"));
	            map.put("reviewContent", rs.getString("review_content"));
	            map.put("writeday", rs.getString("writeday"));
	            map.put("rating", String.valueOf(rs.getDouble("rating")));
	        }

	    } finally {
	        close();
	    }

	    return map;
		

	}// end of public Map<String, String> getReviewForEdit(int reviewNumber, String memberId) throws SQLException -------


	// 리뷰 수정
	@Override
	public boolean updateReview(int reviewNumber, String memberId, String title, String content, double rating) throws SQLException {
		
	    int n = 0;

	    try {
	        conn = ds.getConnection();

	        String sql = " UPDATE tbl_review r "
	                   + " SET r.review_title = ? "
	                   + "   , r.review_content = ? "
	                   + "   , r.rating = ? "
	                   + " WHERE r.review_number = ? "
	                   + " AND r.deleted_yn = 0 "
	                   + " AND EXISTS ( "
	                   + "       SELECT 1 "
	                   + "       FROM tbl_order_detail od "
	                   + "       JOIN tbl_orders o ON o.order_id = od.fk_order_id "
	                   + "       WHERE od.order_detail_id = r.fk_order_detail_id "
	                   + "       AND o.fk_member_id = ? "
	                   + "   ) ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, title);
	        pstmt.setString(2, content);
	        pstmt.setDouble(3, rating);
	        pstmt.setInt(4, reviewNumber);
	        pstmt.setString(5, memberId);

	        n = pstmt.executeUpdate();

	    } finally {
	        close();
	    }

	    return (n == 1);
	
	}// end of public boolean updateReview(int reviewNumber, String memberId, String title, String content, double rating) throws SQLException -------
	
	
	

	
	
}
