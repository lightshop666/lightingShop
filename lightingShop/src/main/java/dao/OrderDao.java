package dao;
import vo.*;
import java.sql.*;
import java.util.*;
import util.DBUtil;
import java.time.LocalDate;

public class OrderDao {
	
	//주문일부터 한 달 지나면 리뷰를 못쓰게 하기 위한 오늘 날짜
	public class DateDao {
	    public LocalDate getCurrentDate() {
	        return LocalDate.now();
	    }
	}
	
//1)특정 주문 조회One
	/*
	SELECT 
		o.order_no orderNo
		, o.id id
		, o.order_address orderAddress
		, o.order_price orderPrice
		, o.createdate orderDay
		, op.order_product_no orderProductNo
		, op.product_no productNo
		, op.product_cnt productCnt
		, op.delivery_status deliveryStatus
	FROM orders o
		INNER JOIN order_product op ON o.order_no = op.order_no
	WHERE o.order_no = ?

	 */
	public HashMap<String, Object> selectOrdersOne(int orderNo) throws Exception {
		HashMap<String, Object> map = new HashMap<>();
		Orders orders = null;
		OrderProduct orderProduct = null;
		
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "SELECT  o.order_no orderNo, o.id id, o.order_address orderAddress, o.order_price orderPrice, o.createdate orderDay, op.order_product_no orderProductNo, op.product_no productNo, op.product_cnt productCnt, op.delivery_status deliveryStatus FROM orders o INNER JOIN order_product op ON o.order_no = op.order_no WHERE o.order_no = ?";

	    PreparedStatement mainStmt = conn.prepareStatement(sql);
		mainStmt.setInt(1, orderNo);
		ResultSet rs = mainStmt.executeQuery();
		
		//결과셋 받아오기
		if(rs.next()) {
			orders = new Orders();
			orderProduct = new OrderProduct();
			orders.setOrderNo(rs.getInt("orderNo"));
			orders.setId(rs.getString("id"));
			orders.setOrderAddress(rs.getString("orderAddress"));
			orders.setOrderPrice(rs.getInt("orderPrice"));
			orders.setCreatedate(rs.getString("orderDay"));
			orderProduct.setOrderProductNo(rs.getInt("orderProductNo"));
			orderProduct.setProductNo(rs.getInt("productNo"));
			orderProduct.setProductCnt(rs.getInt("productCnt"));
			orderProduct.setDeliveryStatus(rs.getString("deliveryStatus"));
		}
		map.put("orders", orders);
		map.put("orderProduct", orderProduct);
		return map;
	}
	
	
	//2)orderNo 주문취소, 취소 철회
		/*
		-- 배송 상태에 따른 버튼 (주문확인 중 주문 취소 버튼을 눌렀다)
		UPDATE orders o
		   JOIN order_product op ON o.order_no = op.order_no
		      JOIN customer c ON o.id = c.id
		         JOIN point_history ph ON o.order_no = ph.order_no
		SET 
		   o.updatedate = NOW()
		   , op.delivery_status = '취소완료'
		   , c.cstm_point = ?   -- 고객의 총 포인트 변동 후 최종 포인트 select 고객
		   , ph.point_info ='상품'
		   , ph.point_pm = 'M'
		   , ph.point = ?         -- 이번 주문 취소로 인한 변동 포인트 select 주문서(order_no)
		WHERE o.order_no = ?      -- 주문번호 

		*/
		public int OPNDeleiveryStatus(String deliStatus, int orderProductNo) throws Exception {
		    int row = 0;
		    DBUtil dbUtil = new DBUtil();
		    Connection conn = dbUtil.getConnection();

		    String sql = "";
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

}
