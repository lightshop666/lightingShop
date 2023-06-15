package dao;
import java.sql.*;
import java.util.*;
import java.util.Date;

import vo.*;
import util.*;
import java.io.File;

public class OrderProductDao {
	
//1-1)orderNo에 따른 상품
	/*
	SELECT 
		o.order_no AS orderNo,
		o.id AS id,
		o.createdate AS createdate,
		op.order_product_no AS orderProductNo,
		op.product_no AS productNo,
		op.delivery_status AS deliveryStatus,
		COALESCE(r.review_written, 'N') AS reviewWritten
	FROM orders o
		JOIN order_product op ON o.order_no = op.order_no
			LEFT JOIN review r ON op.order_product_no = r.order_product_no
	WHERE o.order_no = ?
	 */
	public ArrayList<HashMap<String, Object>> selectOrderNoByOrderProductNo(int orderNo) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "	SELECT  "
	    		+ "		o.order_no AS orderNo, "
	    		+ "		o.id AS id, "
	    		+ "		o.createdate AS createdate, "
	    		+ "		op.order_product_no AS orderProductNo, "
	    		+ "		op.product_no AS productNo, "
	    		+ "		op.delivery_status AS deliveryStatus, "
	    		+ "		COALESCE(r.review_written, 'N') AS reviewWritten "
	    		+ "	FROM orders o "
	    		+ "		JOIN order_product op ON o.order_no = op.order_no "
	    		+ "		LEFT JOIN review r ON op.order_product_no = r.order_product_no "
	    		+ "	WHERE o.order_no = ?";

	    PreparedStatement mainStmt = conn.prepareStatement(sql);
		mainStmt.setInt(1, orderNo);
		
		ResultSet mainRs = mainStmt.executeQuery();
		
		//결과셋 받아오기
		while (mainRs.next()) {
			HashMap<String, Object> o = new HashMap<>();
			o.put("orderNo", mainRs.getInt("orderNo"));
			o.put("id", mainRs.getString("id"));
			o.put("createdate", mainRs.getString("createdate"));
			o.put("orderProductNo", mainRs.getInt("orderProductNo"));
			o.put("productNo", mainRs.getInt("productNo"));
			o.put("deliveryStatus", mainRs.getString("deliveryStatus"));
			o.put("reviewWritten", mainRs.getString("reviewWritten"));
			
	        list.add(o);
	    }
		System.out.println(list+ "<--ArrayList-- OrderProductDao.selectCustomerOrderList");
		return list;
	}
	
	
//1-2)모든 주문 리스트 페이징
	public int customerOrderListCnt(String loginMemberId) throws Exception {
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
	public int oPNDeleiveryStatus(String deliStatus, int orderProductNo) throws Exception {
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
	
//3-1)주문 시점의 할인기간 적용하여 할인 된 가격 받아오기
	/*
	SELECT 
	       CASE WHEN d.discount_start <= ? AND d.discount_end >= NOW() 
	            THEN p.product_price - (p.product_price * d.discount_rate) 
	            ELSE p.product_price 
	       END AS discountedPrice
	FROM product p 
		LEFT JOIN discount d ON p.product_no = d.product_no 
	WHERE p.product_no = ?
	*/
	public int discountedByOrders(int productNo, String createdate) throws Exception {
		int result = 0;
		
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	
	    String sql = "	SELECT  "
	    		+ "	       CASE WHEN d.discount_start <= ? AND d.discount_end >= NOW()  "
	    		+ "	            THEN p.product_price - (p.product_price * d.discount_rate)  "
	    		+ "	            ELSE p.product_price  "
	    		+ "	       END AS discountedPrice "
	    		+ "	FROM product p  "
	    		+ "		LEFT JOIN discount d ON p.product_no = d.product_no  "
	    		+ "	WHERE p.product_no = ?";
	    PreparedStatement mainStmt = conn.prepareStatement(sql);
	    mainStmt.setString(1, createdate);
	    mainStmt.setInt(2, productNo);
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
	        System.out.println(row +"행 주문-상품 추가 성공<--addProductDao");
         }else{
        	 row=0;
            System.out.println(row +"행 주문-상품 추가 실패<--addProductDao");
         }
	    return row;		
	}
	
//5-1)리뷰는 orders 테이블의 주문날짜(createdate)로부터 31일 이내에만, 리뷰를 아직 쓰지 않은 사람만 쓸 수 있다.
	/*
	SELECT 
		op.order_no orderNo
		, op.delivery_status deleveryStatus
		, o.createdate createdate
		, NOW() as todaydate
	FROM orders o
		INNER JOIN order_product op ON o.order_no=op.order_no
	WHERE op.order_product_no = ?
	 */
	public HashMap<String, Object> selectOrderProduct(int orderProductNo) throws Exception {
	    // 반환할 결과를 담을 HashMap
	    HashMap<String, Object> map = new HashMap<>();
	    
	    // DB 연결을 위한 DBUtil 객체와 Connection 객체 생성
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    // 주문 및 주문 상품 정보를 조회하는 SQL문
	    String sql = "SELECT  op.order_no orderNo, op.delivery_status deleveryStatus, o.createdate createdate,  NOW() as todaydate FROM orders o INNER JOIN order_product op ON o.order_no=op.order_no WHERE op.order_product_no =?";
	    // SQL문 실행을 위한 PreparedStatement 객체 생성
	    PreparedStatement mainStmt = conn.prepareStatement(sql);
	    mainStmt.setInt(1, orderProductNo);
	    ResultSet rs = mainStmt.executeQuery();
	    
	    // 결과셋 받아오기
	    while (rs.next()) {
	    	map.put("orderNo", rs.getInt("orderNo"));
	    	map.put("deleveryStatus", rs.getString("deleveryStatus"));
			// createdate와 todaydate를 Date 타입으로 변환하여 저장
			Date createDate = rs.getDate("createdate");
			Date todayDate = rs.getDate("todaydate");
			map.put("createdate", createDate);
			map.put("todaydate", todayDate);
	    }
	    
	    return map;
	}
//5-2 리뷰 작성 기간 체크
	public boolean checkReviewEligibility(Date createDate, Date todayDate) throws Exception {	    
		// createDate와 todayDate를 비교하여 리뷰 작성 가능 여부를 판단
		long diff = todayDate.getTime() - createDate.getTime();
		long daysDiff = diff / (24 * 60 * 60 * 1000); // 밀리초를 일 단위로 변환
		
		if (daysDiff < 32) {
			// 32일 이내이므로 리뷰 작성 가능
			return true;
		} else {
			// 32일 이상이므로 리뷰 작성 불가능
			return false;
		}
	}


	
	
	
	
	
	
//orderProduct 넘버로 받아오는 orderProduct 테이블
	
	
	
	
	
}
