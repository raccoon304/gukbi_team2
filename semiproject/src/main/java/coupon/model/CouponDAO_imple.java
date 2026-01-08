package coupon.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import coupon.domain.CouponDTO;
import coupon.domain.CouponIssueDTO;


public class CouponDAO_imple implements CouponDAO {

	private DataSource ds;//(context.xml내) javax.sql.DataSource아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public CouponDAO_imple() { // 기본생성자
		Context initContext;
		try {
			initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("SemiProject");
		    
		    // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
		    
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}
	
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기
	private void close() {
		try {
			if(rs    != null) {rs.close();     rs=null;}
			if(pstmt != null) {pstmt.close(); pstmt=null;}
			if(conn  != null) {conn.close();  conn=null;}
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}// end of private void close()---------------
	
	
	// 쿠폰 생성 메서드
	@Override
	public int CouponCreate(CouponDTO cpDto) throws SQLException {
		
		int result = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " insert into tbl_coupon(COUPON_CATEGORY_NO, COUPON_NAME, DISCOUNT_TYPE, DISCOUNT_VALUE) "
					   + " values(SEQ_TBL_COUPON_COUPON_CATEGORY_NO.nextval, ?, ?, ?) ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, cpDto.getCouponName());
			pstmt.setInt(2, cpDto.getDiscountType());
			pstmt.setInt(3, cpDto.getDiscountValue());
			
			
			result = pstmt.executeUpdate();
			
		}finally {
			close();
		}
		
		return result;
	}


	// 쿠폰 리스트를 보여주는 메서드
	@Override
	public List<CouponDTO> selectCouponList() throws SQLException {
		
		List<CouponDTO> couponList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = " SELECT coupon_category_no, coupon_name, discount_type, discount_value, usable "
					   + " FROM tbl_coupon "
					   + " ORDER BY coupon_category_no DESC ";

			pstmt = conn.prepareStatement(sql);
			
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				CouponDTO cpDto = new CouponDTO();
				
				cpDto.setCouponCategoryNo(rs.getInt("coupon_category_no"));
				cpDto.setCouponName(rs.getString("coupon_name"));
				cpDto.setDiscountType(rs.getInt("discount_type"));
				cpDto.setDiscountValue(rs.getInt("discount_value"));
				cpDto.setUsable(rs.getInt("usable"));
				
				couponList.add(cpDto);
				
			}// end of while(rs.next()) -------
			
		}finally {
			close();
		}
		
		return couponList;
	}
	
	// 쿠폰 리스트를 보여주는 메서드
	   @Override
	   public List<CouponDTO> selectCouponList(String userid) throws SQLException {
	      
	      List<CouponDTO> couponList = new ArrayList<>();
	      
	      try {
	         conn = ds.getConnection();
	         
	         String sql = " SELECT coupon_category_no, coupon_name, discount_type, discount_value, usable "
	                  + " FROM tbl_coupon "
	                  + " WHERE member_id = ? "
	                  + " ORDER BY coupon_category_no DESC ";

	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, userid);
	         
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	            
	            CouponDTO cpDto = new CouponDTO();
	            
	            cpDto.setCouponCategoryNo(rs.getInt("coupon_category_no"));
	            cpDto.setCouponName(rs.getString("coupon_name"));
	            cpDto.setDiscountType(rs.getInt("discount_type"));
	            cpDto.setDiscountValue(rs.getInt("discount_value"));
	            cpDto.setUsable(rs.getInt("usable"));
	            
	            couponList.add(cpDto);
	            
	         }// end of while(rs.next()) -------
	         
	      }finally {
	         close();
	      }
	      
	      return couponList;
	   }


	// 쿠폰 총 페이지수
	@Override
	public int getTotalPageCoupon(Map<String,String> paraMap) throws SQLException {
		
		int totalPage = 0;
		String type = paraMap.get("type");
		
	    try {
	        conn = ds.getConnection();
	        String sql = " SELECT ceil(count(*)/?) "
	        		   + " FROM tbl_coupon "
	        		   + " WHERE 1 = 1 ";
	        
	        if(type != null && !type.isBlank()) {
	            sql += " AND discount_type = ? ";
	        }
	        		
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
	        
	        if(type != null && !type.isBlank()) {
	        	pstmt.setInt(2, Integer.parseInt(type));
	        }
	        
	        rs = pstmt.executeQuery();
	        
	        if(rs.next()) totalPage = rs.getInt(1);
	        
	    } finally {
	        close();
	    }
	    return totalPage;
	}


	// 페이지별 쿠폰 리스트 가져오기
	@Override
	public List<CouponDTO> selectCouponPaging(Map<String, String> paraMap) throws SQLException {
		
		List<CouponDTO> list = new ArrayList<>();

	    int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
	    int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
	    String type = paraMap.get("type");
	    String sort = paraMap.get("sort");

	    int begin = (currentShowPageNo - 1) * sizePerPage + 1;
	    int end   = begin + sizePerPage - 1;
	    
	    String orderBy = " COUPON_CATEGORY_NO desc ";
	    
	    if("valueDesc".equals(sort)) {
	      orderBy = " discount_value DESC, coupon_category_no DESC ";
	    } else if("valueAsc".equals(sort)) {
	      orderBy = " discount_value ASC, coupon_category_no DESC ";
	    }


	    try {
	        conn = ds.getConnection();

	        String sql =
	            " SELECT coupon_category_no, coupon_name, discount_type, discount_value, usable "
	          + " FROM ( "
	          + "   SELECT row_number() over(order by "+orderBy+") AS rno, "
	          + "          coupon_category_no, coupon_name, discount_type, discount_value, usable "
	          + "   FROM tbl_coupon "
	          + "   WHERE 1 = 1 ";

	        
	        if(type != null && !type.isBlank()) {
	            sql += " AND discount_type = ? ";
	          }

	        sql += " ) ";
	        sql += " WHERE rno between ? and ? ";
	        
	        pstmt = conn.prepareStatement(sql);
	        
	        if(type != null && !type.isBlank()) {
	            pstmt.setInt(1, Integer.parseInt(type));
	            pstmt.setInt(2, begin);
		        pstmt.setInt(3, end);
	        }
	        else {
	        	pstmt.setInt(1, begin);
		        pstmt.setInt(2, end);
	        }
	        
	        
	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            CouponDTO dto = new CouponDTO();
	            dto.setCouponCategoryNo(rs.getInt("COUPON_CATEGORY_NO"));
	            dto.setCouponName(rs.getString("COUPON_NAME"));
	            dto.setDiscountType(rs.getInt("DISCOUNT_TYPE"));
	            dto.setDiscountValue(rs.getInt("DISCOUNT_VALUE"));
	            dto.setUsable(rs.getInt("USABLE"));
	            list.add(dto);
	        }
	    } finally {
	        close();
	    }

	    return list;
	}


	// 쿠폰을 발급 받은 회원 목록 조회
	@Override
	public List<CouponIssueDTO> selectIssuedMembersByCouponCategoryNo(int couponCategoryNo) throws SQLException {
		
		 List<CouponIssueDTO> list = new ArrayList<>();

		    try {
		        conn = ds.getConnection();

		        String sql =
		              " select ci.fk_coupon_category_no as coupon_category_no "
		            + "      , ci.coupon_id "
		            + "      , ci.fk_member_id          as member_id "
		            + "      , m.name                   as member_name "
		            + "      , to_char(ci.issue_date,  'yyyy-mm-dd') as issue_date "
		            + "      , to_char(ci.expire_date, 'yyyy-mm-dd') as expire_date "
		            + "      , ci.used_yn "
		            + " from tbl_coupon_issue ci "
		            + " join tbl_member m "
		            + "  on m.member_id = ci.fk_member_id "
		            + " where ci.fk_coupon_category_no = ? "
		            + " order by ci.coupon_id desc ";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, couponCategoryNo);

		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            CouponIssueDTO dto = new CouponIssueDTO();
		            dto.setCouponCategoryNo(rs.getInt("coupon_category_no"));
		            dto.setCouponId(rs.getInt("coupon_id"));
		            dto.setMemberId(rs.getString("member_id"));
		            dto.setMemberName(rs.getString("member_name"));
		            dto.setIssueDate(rs.getString("issue_date"));
		            dto.setExpireDate(rs.getString("expire_date"));
		            dto.setUsedYn(rs.getInt("used_yn"));

		            list.add(dto);
		        }

		    } finally {
		        close();
		    }

		    return list;
	}


	// 회원에게 쿠폰을 전송하는 메서드
	@Override
	public int issueCouponToMembers(int couponCategoryNo, List<String> memberIdList, String expireDateStr) throws SQLException {
		
		int issuedCount = 0;
	    PreparedStatement pstmtExists = null;
	    PreparedStatement pstmtIns = null;

	    try {
	        conn = ds.getConnection();
	        conn.setAutoCommit(false);

	        // LOCK
	        String lockSql = " select coupon_category_no "
	        		           + " from tbl_coupon "
	        		           + " where coupon_category_no = ? for update ";
	        pstmt = conn.prepareStatement(lockSql);
	        pstmt.setInt(1, couponCategoryNo);
	        rs = pstmt.executeQuery();

	        if(!rs.next()) {
	            conn.rollback();
	            return 0;
	        }

	        rs.close(); rs=null;
	        pstmt.close(); pstmt=null;

	        // nextId
	        int nextId = 1;
	        String maxSql = " select nvl(max(coupon_id), 0) "
	        		          + "from tbl_coupon_issue "
	        		          + " where fk_coupon_category_no = ? ";
	        pstmt = conn.prepareStatement(maxSql);
	        pstmt.setInt(1, couponCategoryNo);
	        rs = pstmt.executeQuery();
	        if(rs.next()) nextId = rs.getInt(1) + 1;

	        rs.close(); rs=null;
	        pstmt.close(); pstmt=null;

	        // SQL
	        String existsSql =
	              " select count(*) "
	            + " from tbl_coupon_issue "
	            + " where fk_coupon_category_no = ? "
	            + "   and fk_member_id = ? "
	            + "   and used_yn = 0 "
	            + "   and expire_date >= sysdate ";

	        String insSql =
	              " insert into tbl_coupon_issue "
	            + " (fk_coupon_category_no, coupon_id, fk_member_id, issue_date, expire_date) "
	            + " values (?, ?, ?, sysdate, to_date(?, 'yyyy-mm-dd') + (86399/86400)) ";

	        pstmtExists = conn.prepareStatement(existsSql);
	        pstmtIns = conn.prepareStatement(insSql);

	        for(String memberId : memberIdList) {

	            pstmtExists.setInt(1, couponCategoryNo);
	            pstmtExists.setString(2, memberId);

	            ResultSet rs2 = pstmtExists.executeQuery();
	            rs2.next();
	            int cnt = rs2.getInt(1);
	            rs2.close();

	            if(cnt > 0) continue;

	            pstmtIns.setInt(1, couponCategoryNo);
	            pstmtIns.setInt(2, nextId);
	            pstmtIns.setString(3, memberId);
	            pstmtIns.setString(4, expireDateStr);
	            pstmtIns.addBatch();

	            issuedCount++;
	            nextId++;
	        }

	        // addBatch 된게 있을 때만 실행
	        if(issuedCount > 0) {
	            pstmtIns.executeBatch();
	        }

	        conn.commit();
	        return issuedCount;

	    } catch(SQLException e) {
	        if(conn != null) conn.rollback();
	        throw e;

	    } finally {
	        // 지역 pstmt 닫기
	        try { if(pstmtExists != null) pstmtExists.close(); } catch(Exception ignore) {}
	        try { if(pstmtIns != null) pstmtIns.close(); } catch(Exception ignore) {}

	        try { if(conn != null) conn.setAutoCommit(true); } catch(Exception ignore) {}
	        close(); // rs/pstmt/conn (this.*) 닫기
	    }
	}


	// 전체 회원 조회
	@Override
	public List<String> selectMemberIdsForIssue(Map<String, String> paraMap) throws SQLException {
		
		List<String> list = new ArrayList<>();

	    String searchType = paraMap.get("searchType");
	    String searchWord = paraMap.get("searchWord");

	    try {
	        conn = ds.getConnection();

	        StringBuilder sql = new StringBuilder();
	        sql.append(" select m.member_id ");           
	        sql.append(" from tbl_member m ");
	        sql.append(" where m.status = 0 "); // 탈퇴회원 제외

	        // 검색 조건
	        if (searchType != null && !searchType.isBlank() && searchWord != null && !searchWord.isBlank()) {
	            if ("member_id".equals(searchType)) {
	                sql.append(" and m.member_id like '%'||?||'%' ");  // 컬럼명 맞춰서 수정
	            } else if ("name".equals(searchType)) {
	                sql.append(" and m.name like '%'||?||'%' ");
	            } else if ("email".equals(searchType)) {
	                sql.append(" and m.email like '%'||?||'%' ");
	            }
	        }

	        sql.append(" order by m.registerday desc ");

	        pstmt = conn.prepareStatement(sql.toString());

	        int idx = 1;
	        if (searchType != null && !searchType.isBlank() && searchWord != null && !searchWord.isBlank()) {
	            pstmt.setString(idx++, searchWord.trim());
	        }

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            list.add(rs.getString(1));
	        }

	    } finally {
	        close();
	    }

	    return list;
	}


	// 쿠폰 발급 받은 회원 총 페이지수
	@Override
	public int getTotalPageIssuedMembers(int couponCategoryNo, int sizePerPage, String filter) throws SQLException {
		
		int totalPage = 0;
		
		String cond = "";
		  if("unused".equals(filter)) {
		    cond = " and used_yn = 0 and expire_date >= sysdate ";
		  } else if("used".equals(filter)) {
		    cond = " and used_yn = 1 ";
		  } else if("expired".equals(filter)) {
		    cond = " and used_yn = 0 and expire_date < sysdate ";
		  }

	    try {
	        conn = ds.getConnection();

	        String sql = " select ceil(count(*)/?) "
	                   + " from tbl_coupon_issue "
	                   + " where fk_coupon_category_no = ? "
	                   + cond;

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, sizePerPage);
	        pstmt.setInt(2, couponCategoryNo);

	        rs = pstmt.executeQuery();
	        if(rs.next()) totalPage = rs.getInt(1);

	    } finally {
	        close();
	    }
	    return totalPage;
	}

	
	// 페이지별 쿠폰을 발급 받은 회원 리스트 가져오기
	@Override
	public List<CouponIssueDTO> selectIssuedMembersPaging(Map<String, String> paraMap) throws SQLException {
		
		List<CouponIssueDTO> list = new ArrayList<>();

	    int couponCategoryNo = Integer.parseInt(paraMap.get("couponCategoryNo"));
	    int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
	    int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
	    
	    String filter = paraMap.get("filter"); // "all" , "unused"
	    String cond = "";
	    if("unused".equals(filter)) {
	      cond = " and ci.used_yn = 0 and ci.expire_date >= sysdate ";
	    } else if("used".equals(filter)) {
	      cond = " and ci.used_yn = 1 ";
	    } else if("expired".equals(filter)) {
	      cond = " and ci.used_yn = 0 and ci.expire_date < sysdate ";
	    }

	    int begin = (currentShowPageNo - 1) * sizePerPage + 1;
	    int end   = begin + sizePerPage - 1;

	    try {
	        conn = ds.getConnection();

	        String sql =
	          " select coupon_category_no, coupon_id, member_id, member_name, issue_date, expire_date, used_yn " +
	          " from ( " +
	          "   select row_number() over(order by ci.coupon_id desc) as rno, " +
	          "          ci.fk_coupon_category_no as coupon_category_no, " +
	          "          ci.coupon_id, " +
	          "          ci.fk_member_id as member_id, " +
	          "          m.name as member_name, " +
	          "          to_char(ci.issue_date, 'yyyy-mm-dd') as issue_date, " +
	          "          to_char(ci.expire_date, 'yyyy-mm-dd hh24:mi:ss') as expire_date, " +
	          "          ci.used_yn " +
	          "   from tbl_coupon_issue ci " +
	          "   join tbl_member m " +
	          "     on m.member_id = ci.fk_member_id " +
	          "   where ci.fk_coupon_category_no = ? " +
	              cond +
	          " ) " +
	          " where rno between ? and ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, couponCategoryNo);
	        pstmt.setInt(2, begin);
	        pstmt.setInt(3, end);

	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            CouponIssueDTO dto = new CouponIssueDTO();
	            dto.setCouponCategoryNo(rs.getInt("coupon_category_no"));
	            dto.setCouponId(rs.getInt("coupon_id"));
	            dto.setMemberId(rs.getString("member_id"));
	            dto.setMemberName(rs.getString("member_name"));
	            dto.setIssueDate(rs.getString("issue_date"));
	            dto.setExpireDate(rs.getString("expire_date"));
	            dto.setUsedYn(rs.getInt("used_yn"));
	            list.add(dto);
	        }

	    } finally {
	        close();
	    }

	    return list;
	}


	// 쿠폰 사용 안함 처리
	@Override
	public int disableCoupon(int couponCategoryNo) throws SQLException {
		
		int n = 0;

 	    String sql = " update TBL_COUPON set USABLE = 0 where COUPON_CATEGORY_NO = ? ";

	    try {
	      conn = ds.getConnection();
	      pstmt = conn.prepareStatement(sql);
	      pstmt.setInt(1, couponCategoryNo);
	      n = pstmt.executeUpdate();
	    } finally {
	      close();
	    }
	    return n;
	    
	}


	// 미사용 발급건수(만료전)
	@Override
	public int getUnusedIssuedCount(int couponCategoryNo) throws SQLException {
		
		 int cnt = 0;

		  String sql =
		      " select count(*) as cnt " +
		      " from TBL_COUPON_ISSUE " +
		      " where FK_COUPON_CATEGORY_NO = ? " +
		      "   and USED_YN = 0 " +
		      "   and EXPIRE_DATE >= trunc(sysdate) ";

		  try {
		    conn = ds.getConnection();
		    pstmt = conn.prepareStatement(sql);
		    pstmt.setInt(1, couponCategoryNo);
		    rs = pstmt.executeQuery();
		    if (rs.next()) cnt = rs.getInt("cnt");
		  } finally {
		    close();
		  }
		  return cnt;
	}


	@Override
	public int enableCoupon(int couponCategoryNo) throws SQLException {
		
		 int n = 0;
	    String sql = " update TBL_COUPON set USABLE = 1 "
	    		       + " where COUPON_CATEGORY_NO = ? ";

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, couponCategoryNo);
	        n = pstmt.executeUpdate();
	    } finally {
	        close();
	    }
	    return n;
		
	}


	// 쿠폰의 총개수 알아오기
	@Override
	public int getTotalCouponCount(Map<String, String> paraMap) throws SQLException {
		
		int totalCouponCount = 0;
		
		try {
			
			String type = paraMap.get("type");
		//	String sort = paraMap.get("sort");
			
			conn = ds.getConnection();
			
			String sql = " SELECT count(*) "
					   + " FROM tbl_coupon "
					   + " Where 1 = 1 ";
			
			if(type != null && !type.isBlank()) {
	            sql += " AND discount_type = ? ";
	        }
			
			pstmt = conn.prepareStatement(sql);
			
			if(type != null && !type.isBlank()) {
				pstmt.setInt(1, Integer.parseInt(type));
	        }
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			totalCouponCount = rs.getInt(1);
		}finally {
			close();
		}
		return totalCouponCount;
		
	}// end of public int getTotalCouponCount(Map<String, String> paraMap) throws SQLException -------

}
