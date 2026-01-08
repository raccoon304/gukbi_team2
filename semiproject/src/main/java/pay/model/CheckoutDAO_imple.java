package pay.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class CheckoutDAO_imple implements CheckoutDAO {

    private DataSource ds;

    public CheckoutDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    /**
     * 결제 직전 선택된 장바구니 1건 조회
     * - cartId + memberId로 이중 검증
     */
    @Override
    public Map<String, Object> selectCartItemForCheckout(int cartId, String memberId) {

        Map<String, Object> map = null;

        String sql = """
            SELECT
                c.cart_id,
                c.quantity,
                p.product_name,
                p.image_path,
                (p.price + o.plus_price) AS unit_price,
                (p.price + o.plus_price) * c.quantity AS total_price,
                o.option_name
            FROM tbl_cart c
            JOIN tbl_product_option o
              ON c.fk_option_id = o.option_id
            JOIN tbl_product p
              ON o.fk_product_code = p.product_code
            WHERE c.cart_id = ?
              AND c.fk_member_id = ?
        """;

        try (
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {

            pstmt.setInt(1, cartId);
            pstmt.setString(2, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    map = new HashMap<>();

                    map.put("cart_id", rs.getInt("cart_id"));
                    map.put("quantity", rs.getInt("quantity"));
                    map.put("product_name", rs.getString("product_name"));
                    map.put("image_path", rs.getString("image_path"));
                    map.put("unit_price", rs.getInt("unit_price"));
                    map.put("total_price", rs.getInt("total_price"));
                    map.put("option_name", rs.getString("option_name"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace(); // 로그
        }

        return map;
    }
}