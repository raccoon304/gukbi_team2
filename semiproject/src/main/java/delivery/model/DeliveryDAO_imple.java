package delivery.model;

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

import delivery.domain.DeliveryDTO;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class DeliveryDAO_imple implements DeliveryDAO {

	
	private DataSource ds;//(context.xml내) javax.sql.DataSource아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	public DeliveryDAO_imple() { //기본생성자 
		Context initContext;
		try {
			initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("SemiProject");
		    
		    // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
		    aes = new AES256(SecretMyKey.KEY);
 
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
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
	
	

	// 배송지 목록 가져오기 
	@Override
	public List<DeliveryDTO> selectDeliveryList(String memberid) throws SQLException {
		List<DeliveryDTO> deliveryList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();
			
			String sql = " select delivery_address_id, recipient_name, recipient_phone, address, address_detail, is_default, postal_code, address_name "
					+ " from tbl_delivery "
					+ " where fk_member_id = ? ";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, memberid);
			rs = pstmt.executeQuery();
			
			
			while(rs.next()) {
				DeliveryDTO dDto = new DeliveryDTO();
				dDto.setDeliveryAddressId(rs.getInt("delivery_address_id"));
				dDto.setRecipientName(rs.getString("recipient_name"));
				
				String recipientPhone = rs.getString("recipient_phone");
				dDto.setRecipientPhone(aes.decrypt(recipientPhone));
				
				dDto.setAddress(rs.getString("address"));
				dDto.setAddressDetail(rs.getString("address_detail"));
				dDto.setIsDefault(rs.getInt("is_default"));
				dDto.setPostalCode(rs.getString("postal_code"));
				dDto.setAddressName(rs.getString("address_name"));
				
				deliveryList.add(dDto);
			}// EoP while
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		
		return deliveryList;
	}
	
	// 배송지 삭제 메서드
    @Override
	public int deleteDelivery(Map<String, String> paraMap) throws SQLException {

        int n = 0;

        String memberid = paraMap.get("memberid");

        // paraMap 에서 selectAddId_0, selectAddId_1 ... 뽑아서 리스트로 만들기
        List<String> idList = new ArrayList<>();
        int i = 0;
        while (true) {
            String key = "selectAddId_" + i;
            String val = paraMap.get(key);
            
            if (val == null) break;
            idList.add(val);
            i++;
        }

        StringBuilder sb = new StringBuilder();
        for (int j = 0; j < idList.size(); j++) {
            sb.append("?");
            if (j < idList.size() - 1) sb.append(", ");
        }

        try {
            conn = ds.getConnection();

            String sql = " delete from tbl_delivery "
                       + " where fk_member_id = ? "
                       + " and delivery_address_id in (" + sb.toString() + ") ";

            pstmt = conn.prepareStatement(sql);

            int idx = 1;
            pstmt.setString(idx++, memberid);

            for (String deliveryAddressId : idList) {
                pstmt.setString(idx++, deliveryAddressId);
            }

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }

    // 체크박스 내 기본배송지가 있는지 확인해주는 메서드 
    @Override
    public boolean hasDefaultAddressInSelection(Map<String, String> paraMap) throws SQLException {

    	String memberid = paraMap.get("memberid");

        // selectAddId_0,1,2... 수집
        List<String> idList = new ArrayList<>();
        
        int i = 0;
        
        while (true) {
            String val = paraMap.get("selectAddId_" + i);
            if (val == null) break;
            idList.add(val);
            i++;
        }

        StringBuilder sb = new StringBuilder();
        for (int j = 0; j < idList.size(); j++) {
            sb.append("?");
            if (j < idList.size() - 1) sb.append(", ");
        }

        boolean hasDefault = false;

        try {
            conn = ds.getConnection();

            String sql = " select count(*) "
                       + " from tbl_delivery "
                       + " where fk_member_id = ? "
                       + "   and is_default = 1 "
                       + "   and delivery_address_id in (" + sb.toString() + ") ";

            pstmt = conn.prepareStatement(sql);

            int idx = 1;
            pstmt.setString(idx++, memberid);
            for (String id : idList) {
                pstmt.setString(idx++, id);
            }

            rs = pstmt.executeQuery();
            rs.next();

            hasDefault = (rs.getInt(1) > 0);

        } finally {
            close();
        }

        return hasDefault;
    }

    // 배송지 추가일 경우 
	@Override
	public int insertDelivery(Map<String, String> paraMap) throws SQLException {
				
	    int result = 0;

	    try {
	        conn = ds.getConnection();
	        conn.setAutoCommit(false);

	        String sql2 = " INSERT INTO tbl_delivery(DELIVERY_ADDRESS_ID, FK_MEMBER_ID, ADDRESS_NAME, RECIPIENT_NAME, RECIPIENT_PHONE, " 
	                    + " 	ADDRESS, ADDRESS_DETAIL, IS_DEFAULT, POSTAL_CODE) " 
	                    + " VALUES(SEQ_TBL_DELIVERY_DELIVERY_ADDRESS_ID.nextval, ?, ?, ?, ?, ?, ?, ?, ?) ";

	        pstmt = conn.prepareStatement(sql2); 

	        pstmt.setString(1, paraMap.get("memberId"));
	        pstmt.setString(2, paraMap.get("addressName"));
	        pstmt.setString(3, paraMap.get("recipientName"));
	        
	        String recipientPhone = aes.encrypt(paraMap.get("recipientPhone"));
	        pstmt.setString(4, recipientPhone);
	        
	        pstmt.setString(5, paraMap.get("address"));
	        pstmt.setString(6, paraMap.get("addressDetail"));
	        pstmt.setInt(7, 0);
	        pstmt.setString(8, paraMap.get("postalCode"));

	        result += pstmt.executeUpdate();

	        conn.commit();
	        return result;

	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw new SQLException(e);
	    } finally {
	        close();
	    }
	}

	@Override
	public int updateDelivery(Map<String, String> paraMap) throws SQLException {
		int n = 0;

        try {
            conn = ds.getConnection();

            String sql = " update tbl_delivery "
                       + "    set address_name   = ? "
                       + "      , recipient_name = ? "
                       + "      , postal_code    = ? "
                       + "      , recipient_phone= ? "
                       + "      , address        = ? "
                       + "      , address_detail = ? "
                       + "  where delivery_address_id = ? and fk_member_id = ? ";

            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, paraMap.get("addressName"));
            pstmt.setString(2, paraMap.get("recipientName"));
            pstmt.setString(3, paraMap.get("postalCode"));

            String recipientPhone = aes.encrypt(paraMap.get("recipientPhone"));
            pstmt.setString(4, recipientPhone);

            pstmt.setString(5, paraMap.get("address"));
            pstmt.setString(6, paraMap.get("addressDetail"));

            pstmt.setInt(7, Integer.parseInt(paraMap.get("deliveryAddressId")));
            pstmt.setString(8, paraMap.get("memberId"));

            n = pstmt.executeUpdate();

        } catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} finally {
            close();
        }
        return n;
	}
	
	// 기본배송지를 변경 하는 메서드 
	@Override
	public int setDefaultDelivery(Map<String, String> paraMap) throws SQLException {
		int result = 0;

	    try {
	        conn = ds.getConnection();
	        conn.setAutoCommit(false);

	        // 해당 회원 배송지 기본값 전체 해제
	        String sql1 = " update tbl_delivery "
	                    + " set is_default = 0 "
	                    + " where fk_member_id = ? ";

	        pstmt = conn.prepareStatement(sql1);
	        pstmt.setString(1, paraMap.get("memberId"));
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 선택한 배송지를 기본값으로 설정 (회원 소유 검증 포함)
	        String sql2 = " update tbl_delivery "
	                    + " set is_default = 1 "
	                    + " where delivery_address_id = ? and fk_member_id = ? ";

	        pstmt = conn.prepareStatement(sql2);
	        pstmt.setInt(1, Integer.parseInt(paraMap.get("deliveryAddressId")));
	        pstmt.setString(2, paraMap.get("memberId"));

	        result = pstmt.executeUpdate(); // 1이면 성공

	        conn.commit();
	    }
	    catch(SQLException e) {
	        if (conn != null) conn.rollback();
	        throw e;
	    }
	    finally {
	        if (conn != null) conn.setAutoCommit(true);
	        close();
	    }

	    return result;
	}
}
