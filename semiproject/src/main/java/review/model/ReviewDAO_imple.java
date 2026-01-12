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

        try {
            conn = ds.getConnection();

            String sql = " SELECT count(*) " 
            			   + " FROM tbl_review r "
            			   + " JOIN tbl_product_option po ON po.option_id = r.fk_option_id "
            			   + " WHERE po.fk_product_code = ? "
            			   + "   AND r.deleted_yn = 0 ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productCode);

            rs = pstmt.executeQuery();
            rs.next();
            totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }

    
    // 총 페이지 수
    @Override
    public int getTotalPage(Map<String, String> paraMap) throws SQLException {

        int totalPage = 0;

        int totalCount = getTotalReviewCount(paraMap);
        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));

        totalPage = (int) Math.ceil((double) totalCount / sizePerPage);

        if(totalPage == 0) totalPage = 1;

        return totalPage;
    }

    // 통계(총개수/평균/별점분포)
    @Override
    public Map<String, Object> getReviewStat(Map<String, String> paraMap) throws SQLException {

        Map<String, Object> stat = new HashMap<>();
        String productCode = paraMap.get("productCode");

        try {
            conn = ds.getConnection();

            // 0.5 단위 평점은 반올림해서 보여줌
            String sql = " SELECT count(*) AS total_cnt "
            			   + "      , nvl(round(avg(r.rating), 1), 0) AS avg_rating "
            			   + "      , sum(case when round(r.rating) = 5 then 1 else 0 end) AS cnt5 "
            			   + "      , sum(case when round(r.rating) = 4 then 1 else 0 end) AS cnt4 "
		               + "      , sum(case when round(r.rating) = 3 then 1 else 0 end) AS cnt3 "
		               + "      , sum(case when round(r.rating) = 2 then 1 else 0 end) AS cnt2 "
		               + "      , sum(case when round(r.rating) = 1 then 1 else 0 end) AS cnt1 "
		               + " FROM tbl_review r "
		               + " JOIN tbl_product_option po ON po.option_id = r.fk_option_id "
		               + " WHERE po.fk_product_code = ? "
		               + "   AND r.deleted_yn = 0 ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productCode);

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
    }

    
    // 리뷰 리스트(페이징처리)
    @Override
    public List<ReviewDTO> selectReviewPaging(Map<String, String> paraMap) throws SQLException {

        List<ReviewDTO> list = new ArrayList<>();

        String productCode = paraMap.get("productCode");
        String sort = paraMap.get("sort"); // latest / high / low

        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));

        int startRno = (currentShowPageNo - 1) * sizePerPage + 1;
        int endRno = currentShowPageNo * sizePerPage;

        String orderBy = " r.writeday desc, r.review_number desc ";
        if ("high".equals(sort)) {
            orderBy = " r.rating desc, r.writeday desc, r.review_number desc ";
        } else if ("low".equals(sort)) {
            orderBy = " r.rating asc, r.writeday desc, r.review_number desc ";
        }

        try {
            conn = ds.getConnection();

            String sql = " SELECT review_number, option_id, order_detail_id, rating, review_content, writeday, member_id, member_name, thumb_path "
            			   + " FROM ( "
            			   + "   SELECT ROW_NUMBER() OVER(ORDER BY " + orderBy + ") AS rno "
            			   + "        , r.review_number "
            			   + "        , r.fk_option_id AS option_id "
            			   + "        , r.fk_order_detail_id AS order_detail_id "
            			   + "        , r.rating "
            			   + "        , r.review_content "
            			   + "        , to_char(r.writeday, 'yyyy-mm-dd') AS writeday "
            			   + "        , m.member_id AS member_id "
            			   + "        , m.name AS member_name "
            			   + "        , (SELECT ri.image_path "
            			   + "             FROM tbl_review_image ri "
            			   + "             WHERE ri.fk_review_number = r.review_number "
            			   + "             ORDER BY ri.sort_no ASC, ri.review_image_id ASC "
            			   + "             fetch first 1 rows only "
            			   + "          ) AS thumb_path "
            			   + "   FROM tbl_review r "
            			   + "   JOIN tbl_product_option po ON po.option_id = r.fk_option_id "
            			   + "   JOIN tbl_order_detail od ON od.order_detail_id = r.fk_order_detail_id "
            			   + "   JOIN tbl_orders o ON o.order_id = od.fk_order_id "
            			   + "   JOIN tbl_member m ON m.member_id = o.fk_member_id "
            			   + "   WHERE po.fk_product_code = ? "
            			   + "     AND r.deleted_yn = 0 "
            			   + " ) "
            			   + " WHERE rno BETWEEN ? AND ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productCode);
            pstmt.setInt(2, startRno);
            pstmt.setInt(3, endRno);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewDTO dto = new ReviewDTO();

                dto.setReviewNumber(rs.getInt("review_number"));
                dto.setOptionId(rs.getInt("option_id"));
                dto.setOrderDetailId(rs.getInt("order_detail_id"));

                dto.setRating(rs.getDouble("rating"));
                dto.setReviewContent(rs.getString("review_content"));
                dto.setWriteday(rs.getString("writeday"));

                dto.setMemberId(rs.getString("member_id"));
                dto.setName(rs.getString("member_name"));
                dto.setThumbPath(rs.getString("thumb_path"));

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }
	
	
	
	
}
