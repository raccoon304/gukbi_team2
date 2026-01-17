package admin.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
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

import admin.domain.AdminPageDTO;
import member.domain.MemberDTO;
import util.security.AES256;
import util.security.SecretMyKey;


public class AdminDAO_imple implements AdminDAO {
	
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public AdminDAO_imple() {
		
		try {
	    	Context initContext = new InitialContext();
	        Context envContext  = (Context)initContext.lookup("java:/comp/env");
	        ds = (DataSource)envContext.lookup("SemiProject");
	        
	        aes = new AES256(SecretMyKey.KEY);
	        // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
	        
    	} catch(NamingException e) {
    		e.printStackTrace();
    	} catch(UnsupportedEncodingException e) {
    		e.printStackTrace();
    	}
	}
	
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기
	 	private void close() {
	 		try {
	 			if(rs    != null) {rs.close();	  rs=null;}
	 			if(pstmt != null) {pstmt.close(); pstmt=null;}
	 			if(conn  != null) {conn.close();  conn=null;}
	 		} catch(SQLException e) {
	 			e.printStackTrace();
	 		}
	 	}// end of private void close()---------------

	 	
	 	
	// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총페이지수 알아오기 //
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws Exception {
		
		int totalPage = 0;

		try {
			conn = ds.getConnection();
			
			
			String sql = " SELECT ceil(count(*)/?) "
					   + " FROM tbl_member "
					   + " WHERE MEMBER_ID != 'admin' "
					   + " AND status = 0 "; 
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
			
			if("email".equals(colname) && !"".equals(searchWord)) {
				// 검색대상이 email 인 경우
				searchWord = aes.encrypt(searchWord);
			}
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				
				if("email".equals(colname)) {
					// 검색대상이 email 인 경우
					sql += " AND email = ? ";
				}
				else {
					// 검색대상이 email 이 아닌 경우
					sql += " AND "+colname+" LIKE '%'|| ? ||'%' ";
					// 컬럼명과 테이블명은 위치홀더(?)로 사용하면 꽝!!! 이다.
					// 위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!!
				}
			}
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
			
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				pstmt.setString(2, searchWord);
			}
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			totalPage = rs.getInt(1);
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {
			  e.printStackTrace();
		} finally {
			close();
		}		
		
		return totalPage;
	}


	// 페이징 처리를 한 모든 회원 또는 검색한 회원 목록 보여주기
	@Override
	public List<MemberDTO> selectMemberPaging(Map<String, String> paraMap) throws Exception{
		
		List<MemberDTO> memberList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = " SELECT member_id, name, email, gender, to_char(created_at, 'yyyy-mm-dd') AS created_at "
					   + " FROM tbl_member "
					   + " WHERE member_id != 'admin' "
					   + " AND status = 0 "; 
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
			
			
			if("email".equals(colname) && !"".equals(searchWord)) {
				// 검색대상이 email 인 경우
				searchWord = aes.encrypt(searchWord);
			}
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				
				if("email".equals(colname)) {
					// 검색대상이 email 인 경우
					sql += " AND email = ? ";
				}
				else {
					// 검색대상이 email 이 아닌 경우
					sql += " AND "+colname+" LIKE '%'|| ? ||'%' ";
					// 컬럼명과 테이블명은 위치홀더(?)로 사용하면 꽝!!! 이다.
					// 위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!!
				}
			}
			
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
			int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
			
			sql += " ORDER BY userseq DESC "   // ORDER BY 다음에 나오는 컬럼의 값은 반드시 고유해야 한다.!!!
				 + " OFFSET (?-1)*? ROW "
				 + " FETCH NEXT ? ROW ONLY ";
			
			pstmt = conn.prepareStatement(sql);
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				pstmt.setString(1, searchWord);
				pstmt.setInt(2, currentShowPageNo);
				pstmt.setInt(3, sizePerPage);
				pstmt.setInt(4, sizePerPage);
			}
			else {
				// 검색대상 및 검색어가 없는 경우
				pstmt.setInt(1, currentShowPageNo);
				pstmt.setInt(2, sizePerPage);
				pstmt.setInt(3, sizePerPage);
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
			
				MemberDTO mbrDto = new MemberDTO();
				// userid, name, email, gender
				
				mbrDto.setMemberid(rs.getString("member_id"));
				mbrDto.setName(rs.getString("name"));
				mbrDto.setEmail(aes.decrypt(rs.getString("email"))); // 복호화 
				mbrDto.setGender(rs.getInt("gender"));
				mbrDto.setRegisterday(rs.getString("created_at"));				
				memberList.add(mbrDto);
			}// end of while(rs.next())-----------------
			
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {
			  e.printStackTrace();
		} finally {
			close();
		}
		
		return memberList;
	}


	
	/* >>> 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 
    검색이 있는 또는 검색이 없는 회원의 총개수 알아오기 시작 <<< */
	@Override
	public int getTotalMemberCount(Map<String, String> paraMap) throws Exception {
		
		int totalMemberCount = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " SELECT count(*) "
					   + " FROM tbl_member "
					   + " WHERE member_id != 'admin'"
					   + " AND status = 0 "; 
			
			String colname = paraMap.get("searchType");
			String searchWord = paraMap.get("searchWord");
			
			if("email".equals(colname) && !"".equals(searchWord)) {
				// 검색대상이 email 인 경우
				searchWord = aes.encrypt(searchWord);
			}
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				
				if("email".equals(colname)) {
					// 검색대상이 email 인 경우
					sql += " AND email = ? ";
				}
				else {
					// 검색대상이 email 이 아닌 경우
					sql += " AND "+colname+" LIKE '%'|| ? ||'%' ";
					// 컬럼명과 테이블명은 위치홀더(?)로 사용하면 꽝!!! 이다.
					// 위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!!
				}
			}
			
			pstmt = conn.prepareStatement(sql);
			
			if(!"".equals(colname) && !"".equals(searchWord)) {
				// 검색대상 및 검색어가 있는 경우
				pstmt.setString(1, searchWord);
			}
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			totalMemberCount = rs.getInt(1);
			
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {
			  e.printStackTrace();
		} finally {
			close();
		}		
		
		return totalMemberCount;
	}

	
	
	// 쿠폰을 발행해 줄 수 있는 회원 리스트(정렬기능 포함)
	public List<MemberDTO> selectMemberPagingForCoupon(Map<String, String> paraMap) throws Exception {

	    List<MemberDTO> memberList = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String searchType = paraMap.get("searchType");
	        String searchWord = paraMap.get("searchWord");

	        if (searchType == null) searchType = "";
	        if (searchWord == null) searchWord = "";

	        boolean hasSearch = !searchType.isBlank() && !searchWord.isBlank();

	        String sortKey = paraMap.get("sortKey"); // "order_cnt" or "real_pay_sum"
	        String sortDir = paraMap.get("sortDir"); // "desc" or ""
	        if (sortKey == null) sortKey = "";
	        if (sortDir == null) sortDir = "";

	        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
	        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));


	        boolean searchByMemberId = "member_id".equals(searchType);
	        boolean searchByName     = "name".equals(searchType);
	        boolean searchByEmail    = "email".equals(searchType);

	        // 허용되지 않은 searchType이면 검색 안함 처리
	        if (hasSearch && !(searchByMemberId || searchByName || searchByEmail)) {
	            hasSearch = false;
	        }

	        // email 검색이면 암호화 후 비교
	        if (hasSearch && searchByEmail) {
	            searchWord = aes.encrypt(searchWord);
	        }

	     
	        String orderBy = " m.userseq DESC ";

	        if ("desc".equals(sortDir)) {
	            if ("order_cnt".equals(sortKey)) {
	                orderBy = " NVL(o.order_cnt, 0) DESC, m.userseq DESC ";
	            } else if ("real_pay_sum".equals(sortKey)) {
	                orderBy = " NVL(o.real_pay_sum, 0) DESC, m.userseq DESC ";
	            }
	        }

	      
	        String sql =
	              " SELECT m.member_id, m.name, m.email, m.gender, to_char(m.created_at, 'yyyy-mm-dd') AS created_at "
	            + " FROM tbl_member m "
	            + " LEFT JOIN ( "
	            + "     SELECT fk_member_id, "
	            + "            COUNT(*) AS order_cnt, "
	            + "            NVL(SUM(NVL(total_amount,0) - NVL(discount_amount,0)), 0) AS real_pay_sum "
	            + "     FROM tbl_orders "
	            + "     GROUP BY fk_member_id "
	            + " ) o "
	            + "   ON o.fk_member_id = m.member_id "
	            + " WHERE m.member_id != 'admin' "
	            + "   AND m.status = 0 ";

	      
	        if (hasSearch) {
	            if (searchByEmail) {
	                sql += " AND m.email = ? ";
	            } else if (searchByMemberId) {
	                sql += " AND m.member_id LIKE '%'|| ? ||'%' ";
	            } else if (searchByName) {
	                sql += " AND m.name LIKE '%'|| ? ||'%' ";
	            }
	        }

	        // 정렬 + 페이징
	        sql += " ORDER BY " + orderBy
	             + " OFFSET (?-1)*? ROW "
	             + " FETCH NEXT ? ROW ONLY ";

	        pstmt = conn.prepareStatement(sql);

	       
	        if (hasSearch) {
	            pstmt.setString(1, searchWord);
	            pstmt.setInt(2, currentShowPageNo);
	            pstmt.setInt(3, sizePerPage);
	            pstmt.setInt(4, sizePerPage);
	        } else {
	            pstmt.setInt(1, currentShowPageNo);
	            pstmt.setInt(2, sizePerPage);
	            pstmt.setInt(3, sizePerPage);
	        }

	       
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            MemberDTO mbrDto = new MemberDTO();

	            mbrDto.setMemberid(rs.getString("member_id"));
	            mbrDto.setName(rs.getString("name"));
	            mbrDto.setEmail(aes.decrypt(rs.getString("email"))); // 복호화
	            mbrDto.setGender(rs.getInt("gender"));
	            mbrDto.setRegisterday(rs.getString("created_at"));

	            memberList.add(mbrDto);
	        }

	    } catch (GeneralSecurityException | UnsupportedEncodingException e) {
	        e.printStackTrace();
	    } finally {
	        close();
	    }

	    return memberList;
	}
	
	
	
	// 쿠폰을 발급 받을 수 있는 총 회원 수 (정렬기능포함)
	public int getTotalCountMemberForCoupon(Map<String, String> paraMap) throws Exception {

	    int totalCount = 0;

	    try {
	        conn = ds.getConnection();

	        
	        String searchType = paraMap.get("searchType");   // member_id , name , email
	        String searchWord = paraMap.get("searchWord");

	        if (searchType == null) searchType = "";
	        if (searchWord == null) searchWord = "";

	        boolean hasSearch = !searchType.isBlank() && !searchWord.isBlank();
     
	        boolean searchByMemberId = "member_id".equals(searchType);
	        boolean searchByName     = "name".equals(searchType);
	        boolean searchByEmail    = "email".equals(searchType);

	        if (hasSearch && !(searchByMemberId || searchByName || searchByEmail)) {
	            hasSearch = false;
	        }

	        // email 검색이면 암호화 후 비교
	        if (hasSearch && searchByEmail) {
	            searchWord = aes.encrypt(searchWord);
	        }

	       
	        String sql = " SELECT COUNT(*) "
	                   + " FROM tbl_member m "
	                   + " WHERE m.member_id != 'admin' "
	                   + "   AND m.status = 0 ";

	        if (hasSearch) {
	            if (searchByEmail) {
	                sql += " AND m.email = ? ";
	            } else if (searchByMemberId) {
	                sql += " AND m.member_id LIKE '%'|| ? ||'%' ";
	            } else if (searchByName) {
	                sql += " AND m.name LIKE '%'|| ? ||'%' ";
	            }
	        }

	        pstmt = conn.prepareStatement(sql);
	      
	        if (hasSearch) {
	            pstmt.setString(1, searchWord);
	        }

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            totalCount = rs.getInt(1);
	        }

	    } catch (GeneralSecurityException | UnsupportedEncodingException e) {
	        e.printStackTrace();
	    } finally {
	        close();
	    }

	    return totalCount;
	}
	
	
	

	// 결제금액, 주문건수 구하기
	@Override
	public Map<String, Map<String, Long>> orderCountAndPaymentAmount(List<String> memberIds) throws Exception {
		
		Map<String, Map<String, Long>> statMap = new HashMap<>();

	    if (memberIds == null || memberIds.isEmpty()) {
	        return statMap;
	    }

	    try {
	        conn = ds.getConnection();

	        StringBuilder sb = new StringBuilder();
	        for (int i = 0; i < memberIds.size(); i++) {
	            if (i > 0) sb.append(",");
	            sb.append("?");
	        }
	        String placeholders = sb.toString();

	        String sql = " SELECT fk_member_id "
	        			   + "      , COUNT(*) AS order_cnt " 
	        			   + "      , NVL(SUM(NVL(total_amount,0) - NVL(discount_amount,0)), 0) AS real_pay_sum " 
	        			   + " FROM tbl_orders "
	        			   + " WHERE fk_member_id IN (" + placeholders + ") " 
	        			   + " GROUP BY fk_member_id ";

	        pstmt = conn.prepareStatement(sql);

	        int idx = 1;
	        for (String id : memberIds) {
	            pstmt.setString(idx++, id);
	        }

	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            String memberId = rs.getString("fk_member_id");

	            Map<String, Long> one = new HashMap<>();
	            one.put("order_cnt", rs.getLong("order_cnt"));
	            one.put("real_pay_sum", rs.getLong("real_pay_sum"));

	            statMap.put(memberId, one);
	        }

	    } finally {
	        close();
	    }

	    return statMap;
	}


	// 회원 1명 상세 정보
	@Override
	public Map<String, String> memberDetail(String memberId) throws Exception {
		
		Map<String, String> map = new HashMap<>();

	    try {
	        conn = ds.getConnection();

	        String sql =
	            " SELECT m.member_id, m.name, m.email, m.gender "
	          + "      , to_char(m.created_at, 'yyyy-mm-dd') AS created_at "
	          + "      , m.mobile_phone "
	          + "      , m.idle, m.status "
	          + "      , d.postal_code, d.address, d.address_detail "
	          + " FROM tbl_member m "
	          + " LEFT JOIN ( "
	          + "     SELECT fk_member_id, postal_code, address, address_detail "
	          + "     FROM ( "
	          + "         SELECT d.* "
	          + "              , row_number() over( "
	          + "                   partition by fk_member_id "
	          + "                   order by is_default desc, delivery_address_id desc "
	          + "                ) AS rn "
	          + "         FROM tbl_delivery d "
	          + "     ) "
	          + "     WHERE rn = 1 "
	          + " ) d "
	          + "   ON d.fk_member_id = m.member_id "
	          + " WHERE m.member_id = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, memberId);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {

	            map.put("member_id", rs.getString("member_id"));
	            map.put("name", rs.getString("name"));
	            map.put("email", aes.decrypt(rs.getString("email")));

	            int gender = rs.getInt("gender"); // 0 남, 1 여
	            map.put("gender_text", (gender == 0 ? "남" : "여"));

	            map.put("created_at", rs.getString("created_at"));

	            // 회원 전화번호
	            map.put("mobile_phone", aes.decrypt(rs.getString("mobile_phone")));

	            int idle = rs.getInt("idle");       // 0 활동중, 1 휴면
	            int status = rs.getInt("status");   // 0 가입중, 1 탈퇴(사용불능)
	            map.put("idle_text", (idle == 1 ? "휴면" : "활동중"));
	            map.put("status_text", (status == 1 ? "탈퇴" : "가입중"));

	            // 주소(기본배송지 1건 조합)
	            String postal = rs.getString("postal_code");
	            String addr1  = rs.getString("address");
	            String addr2  = rs.getString("address_detail");
	           

	            String fullAddr = "";
	            if (addr1 != null) {
	                fullAddr = (postal != null ? "(" + postal + ") " : "")
	                         + addr1
	                         + (addr2 != null ? " " + addr2 : "");
	                      
	            }
	            map.put("full_address", fullAddr);
	        }

	    } finally {
	        close();
	    }

	    return map;
	
	}


	// 회원 1명 주문 정보
	@Override
	public Map<String, Long> orderStatOne(String memberId) throws Exception {
		
		Map<String, Long> map = new HashMap<>();
	    map.put("order_cnt", 0L);
	    map.put("real_pay_sum", 0L);

	    try {
	        conn = ds.getConnection();

	        String sql =
	            " SELECT COUNT(*) AS order_cnt " +
	            "      , NVL(SUM(NVL(total_amount,0) - NVL(discount_amount,0)), 0) AS real_pay_sum " +
	            " FROM tbl_orders " +
	            " WHERE fk_member_id = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, memberId);

	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	            map.put("order_cnt", rs.getLong("order_cnt"));
	            map.put("real_pay_sum", rs.getLong("real_pay_sum"));
	        }

	    } finally {
	        close();
	    }

	    return map;
	}


	// 오늘 가입한 회원 리스트
	@Override
	public List<MemberDTO> todayNewMembers() throws Exception {
		
		List<MemberDTO> list = new ArrayList<>();

	    String sql =
	        " select member_id, name, email, to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at " +
	        " from tbl_member " +
	        " where trunc(created_at) = trunc(sysdate) " +
	        " order by created_at desc ";

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);
	

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            MemberDTO mbrDto = new MemberDTO();
	            mbrDto.setMemberid(rs.getString("member_id"));
	            mbrDto.setName(rs.getString("name"));
	            mbrDto.setEmail(aes.decrypt(rs.getString("email")));
	            mbrDto.setRegisterday(rs.getString("created_at"));
	            list.add(mbrDto);
	        }
	    } finally {
	        close();
	    }
	    return list;
	}


	// 품절 임박 상품 리스트
	@Override
	public List<AdminPageDTO> lowStockProducts() throws Exception {
		
		List<AdminPageDTO> list = new ArrayList<>();

	    String sql =
	        " select p.PRODUCT_NAME, p.BRAND_NAME, o.COLOR, o.STORAGE_SIZE, o.STOCK_QTY " +
	        " from TBL_PRODUCT p " +
	        " join TBL_PRODUCT_OPTION o on p.PRODUCT_CODE = o.FK_PRODUCT_CODE " +
	        " where o.STOCK_QTY < 10 " +
	        " and p.SALE_STATUS = '판매중'" +
	        " order by o.STOCK_QTY asc, p.PRODUCT_NAME asc ";

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            AdminPageDTO dto = new AdminPageDTO();
	            dto.setProductName(rs.getString("PRODUCT_NAME"));
	            dto.setBrandName(rs.getString("BRAND_NAME"));
	            dto.setColor(rs.getString("COLOR"));
	            dto.setStorageSize(rs.getString("STORAGE_SIZE"));
	            dto.setStockQty(rs.getInt("STOCK_QTY"));
	            list.add(dto);
	        }
	    } finally {
	        close();
	    }
	    return list;
	}


	// 최근 주문 5건
	@Override
	public List<AdminPageDTO> currentOrders() throws Exception {
		
		List<AdminPageDTO> list = new ArrayList<>();

	    String sql = " WITH recent_orders AS( "
	    			   + "     SELECT "
	    			   + "         ORDER_ID, "
	    			   + "         FK_MEMBER_ID, "
	    			   + "         ORDER_DATE, "
	    			   + "         TOTAL_AMOUNT, "
	    			   + "         DISCOUNT_AMOUNT "
	    			   + "     FROM TBL_ORDERS "
	    			   + "     WHERE order_status = 'PAID' "
	    			   + "     ORDER BY ORDER_DATE DESC, ORDER_ID DESC "
	    			   + "     FETCH FIRST 5 ROWS ONLY "
	    			   + " ), "
	    			   + " detail_ranked AS ( "
	    			   + "     SELECT "
	    			   + "         od.FK_ORDER_ID, "
	    			   + "         od.PRODUCT_NAME, "
	    			   + "         od.BRAND_NAME, "
	    			   + "         od.QUANTITY, "
	    			   + "         od.UNIT_PRICE, "
	    			   + "         ROW_NUMBER() OVER ( "
	    			   + "             PARTITION BY od.FK_ORDER_ID "
	    			   + "             ORDER BY od.UNIT_PRICE DESC, od.ORDER_DETAIL_ID DESC "
	    			   + "         ) AS rn, "
	    			   + "         COUNT(*) OVER (PARTITION BY od.FK_ORDER_ID) AS detail_cnt "
	    			   + "     FROM TBL_ORDER_DETAIL od "
	    			   + " ) "
	    			   + " SELECT "
	    			   + "     ro.ORDER_ID, "
	    			   + "     ro.FK_MEMBER_ID AS MEMBER_ID, "
	    			   + "     m.NAME, "
	    			   + "     dr.PRODUCT_NAME, "
	    			   + "     dr.BRAND_NAME, "
	    			   + "     dr.QUANTITY, "
	    			   + "     TO_CHAR(ro.ORDER_DATE, 'YYYY-MM-DD HH24:MI') AS ORDER_DATE, "
	    			   + "     (ro.TOTAL_AMOUNT - ro.DISCOUNT_AMOUNT) AS PAY_AMOUNT, "
	    			   + "     dr.detail_cnt AS DETAIL_CNT "
	    			   + " FROM recent_orders ro "
	    			   + " JOIN TBL_MEMBER m "
	    			   + "   ON m.MEMBER_ID = ro.FK_MEMBER_ID "
	    			   + " JOIN detail_ranked dr "
	    			   + "   ON dr.FK_ORDER_ID = ro.ORDER_ID "
	    			   + "  AND dr.rn = 1 "
	    			   + " ORDER BY ro.ORDER_DATE DESC, ro.ORDER_ID DESC ";

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            AdminPageDTO dto = new AdminPageDTO();
	            dto.setOrderId(rs.getInt("ORDER_ID"));
	            dto.setMemberId(rs.getString("MEMBER_ID"));
	            dto.setName(rs.getString("NAME"));
	            dto.setProductName(rs.getString("PRODUCT_NAME"));
	            dto.setBrandName(rs.getString("BRAND_NAME"));
	            dto.setQuantity(rs.getInt("QUANTITY"));
	            dto.setOrderDate(rs.getString("ORDER_DATE"));
	            dto.setPayAmount(rs.getInt("PAY_AMOUNT"));
	            dto.setDetailCnt(rs.getInt("DETAIL_CNT"));
	            list.add(dto);
	        }
	    } finally {
	        close();
	    }
	    return list;
		
	}


	// 오늘 주문 수
	@Override
	public int todayOrderCount() throws Exception {
		
		int cnt = 0;

	    String sql =	 " select count(*) as CNT "
	               + " from TBL_ORDERS "
	               + " where trunc(ORDER_DATE) = trunc(sysdate) "
	               + " and order_status = 'PAID' ";

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            cnt = rs.getInt("CNT");
	        }
	    } finally {
	        close();
	    }

	    return cnt;
		
	}


	// 오늘 매출액
	@Override
	public long todaySales() throws Exception {
		
		long sales = 0;

	    String sql =	 " select nvl(sum(total_amount - discount_amount),0) as real_amount "
	    		       + " from tbl_orders "
	    		       + " where trunc(ORDER_DATE) = trunc(sysdate) "
	    		       + "   and order_status = 'PAID' ";

	    try {
	        conn = ds.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            sales = rs.getLong("real_amount");
	        }
	    } finally {
	        close();
	    }

	    return sales;
		
	}
	

}
