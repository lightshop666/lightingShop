package dao;
import java.sql.*;
import java.util.*;
import vo.*;
import util.*;
import java.io.File;

public class OrderProductDao {
	
//1-1)모든 주문 리스트 출력
	/*
	SELECT 
		o.order_no orderNo
		, o.id id, o.createdate createdate
		, op.order_product_no orderProductNo
		, op.product_no productNo
		, op.delivery_status deliveryStatus
		, r.review_written reviewWritten
	FROM orders o
		JOIN order_product op ON o.order_no = op.order_no
			JOIN review r ON op.order_product_no = r.order_product_no
	WHERE o.id = 'test2'
	ORDER BY o.createdate DESC
	*/
	public ArrayList<HashMap<String, Object>> selectCustomerOrderList(int beginRow, int rowPerPage, String loginMemberId) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "SELECT  o.order_no orderNo, o.id id, o.createdate createdate, op.order_product_no orderProductNo, op.product_no productNo, op.delivery_status deliveryStatus, r.review_written reviewWritten FROM orders o JOIN order_product op ON o.order_no = op.order_no JOIN review r ON op.order_product_no = r.order_product_no WHERE o.id = ?"   	
			        + " ORDER BY o.createdate DESC"
			        + " LIMIT ?, ?";

	    PreparedStatement mainStmt = conn.prepareStatement(sql);
		mainStmt.setString(1, loginMemberId);
		//페이징 처리를 위한 SQL 쿼리문에서의 인덱스는 0부터 시작하므로 beginRow를 1을 빼서 0부터 시작하도록 설정
		mainStmt.setInt(2, beginRow - 1);
		mainStmt.setInt(3, rowPerPage);
		
		ResultSet mainRs = mainStmt.executeQuery();
		
		//결과셋 받아오기
		while (mainRs.next()) {
	        HashMap<String, Object> o = new HashMap<>();
	        o.put("orderNo", mainRs.getInt("orderNo"));
	        o.put("createdate", mainRs.getString("createdate"));
	        o.put("orderProductNo", mainRs.getInt("orderProductNo"));
	        o.put("productNo", mainRs.getInt("productNo"));
	        o.put("deliveryStatus", mainRs.getString("deliveryStatus"));
	        o.put("reviewWritten", mainRs.getString("reviewWritten"));

	        list.add(o);
	    }
		System.out.println(list+ "<--ArrayList-- ReviewDao.selectCustomerOrderList");
		return list;
	}
	
	
//1-2)모든 주문 리스트 페이징
	public int CustomerOrderListCnt(String loginMemberId) throws Exception {
	    int row = 0;
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "SELECT COUNT(*) FROM orders WHERE id=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, loginMemberId);
	    ResultSet rs = stmt.executeQuery();
	    if (rs.next()) {
	        row = rs.getInt(1);
	    }

	    return row;
	}
	
//2)orderProductNo 수취확인 구매확정 함수
	/*
	UPDATE order_product_no
	SET	delivery_status=?
	WHERE order_product_no=?
	*/
	public int OPNDeleiveryStatus(String deliStatus, int orderProductNo) throws Exception {
	    int row = 0;
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "UPDATE order_product   "
	    		+ "	SET	delivery_status=?     "
	    		+ "	WHERE order_product_no=? ";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, deliStatus);
	    stmt.setInt(2, orderProductNo);
	    row = stmt.executeUpdate();
	    
	    if (row !=0) {
	        System.out.println(row +"행 배송상태 수정 성공<--OPNDeleiveryStatus");
         }else{
        	 row=0;
            System.out.println(row +"행 배송상태 수정 실패<--OPNDeleiveryStatus");
         }
	    
	    return row;
	}
	
//3) 할인기간 적용하여 할인 된 가격 받아오기
	/*
	SELECT 
	       CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW() 
	            THEN p.product_price - (p.product_price * d.discount_rate) 
	            ELSE p.product_price 
	       END AS discountedPrice
	FROM product p 
		LEFT JOIN discount d ON p.product_no = d.product_no 
	WHERE p.product_no = 4

	*/
	public int discountedPrice(int productNo) throws Exception {
		int result = 0;
		
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	
	    String sql = "SELECT  "
	    		+ "       CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW()  "
	    		+ "            THEN p.product_price - (p.product_price * d.discount_rate)  "
	    		+ "            ELSE p.product_price  "
	    		+ "       END AS discountedPrice "
	    		+ "FROM product p LEFT JOIN discount d ON p.product_no = d.product_no WHERE p.product_no = ?";
	    PreparedStatement mainStmt = conn.prepareStatement(sql);
		mainStmt.setInt(1, productNo);
		ResultSet rs = mainStmt.executeQuery();
		
		//결과셋 받아오기
		if(rs.next()) {
			result = rs.getInt("discountedPrice");
		}
		return result;
	}
	
	
//4) 각각의 상품 추가
	public int addProductDao(int orderNo, int productNo, int productCnt) throws Exception {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "INSERT INTO order_product (order_no, product_no, product_cnt, delivery_status) "
	    		+ "VALUES (?, ?, ?, '주문확인중')";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, orderNo);
	    stmt.setInt(2, productNo);
	    stmt.setInt(3, productCnt);
	    row = stmt.executeUpdate();
	    
	    if (row !=0) {
	        System.out.println(row +"행 리뷰 추가 성공<--addProductDao");
         }else{
        	 row=0;
            System.out.println(row +"행 리뷰 추가 실패<--addProductDao");
         }
	    return row;		
	}
	
	
	
	
	
	
}
