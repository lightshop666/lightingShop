package dao;
import vo.*;
import java.sql.*;
import java.util.*;
import util.DBUtil;
import java.time.LocalDate;

public class OrderDao {

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
        System.out.println(orderNo + "<--orderNo--selectOrdersOne");

	    // 결과를 저장할 HashMap
	    HashMap<String, Object> map = new HashMap<>();
	    // 주문 정보를 저장할 Orders 객체와 주문 상품 세부 정보를 저장할 리스트
	    Orders orders = null;
	    ArrayList<OrderProduct> orderProducts = new ArrayList<>();

	    // DBUtil 객체를 생성하고 데이터베이스 연결 수립
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    // 주문 정보와 주문 상품 세부 정보를 검색하기 위한 SQL 쿼리
	    String sql = "	SELECT  "
	    		+ "		o.order_no orderNo "
	    		+ "		, o.id id "
	    		+ "		, o.order_address orderAddress "
	    		+ "		, o.order_price orderPrice "
	    		+ "		, o.createdate orderDay "
	    		+ "		, op.order_product_no orderProductNo "
	    		+ "		, op.product_no productNo "
	    		+ "		, op.product_cnt productCnt "
	    		+ "		, op.delivery_status deliveryStatus "
	    		+ "	FROM orders o "
	    		+ "		INNER JOIN order_product op ON o.order_no = op.order_no "
	    		+ "	WHERE o.order_no = ?";
	    // SQL 쿼리를 실행하기 위한 PreparedStatement 객체 생성
	    PreparedStatement mainStmt = conn.prepareStatement(sql);
	    mainStmt.setInt(1, orderNo);
	    ResultSet rs = mainStmt.executeQuery();
        //System.out.println(rs + "<--rs--selectOrdersOne");

	    // 결과셋 가져오기
	    while (rs.next()) {
	        // 첫 번째 행인 경우에만 Orders 객체를 초기화하고 속성을 설정합니다.
	        if (map.get("orders") == null) {
	            orders = new Orders();
	            orders.setOrderNo(rs.getInt("orderNo"));
	            orders.setId(rs.getString("id"));
	            orders.setOrderAddress(rs.getString("orderAddress"));
	            orders.setOrderPrice(rs.getInt("orderPrice"));
	            orders.setCreatedate(rs.getString("orderDay"));
	           // System.out.println(orders.getOrderNo() + "<--orders.getOrderNo() --selectOrdersOne");

	        }
            System.out.println(orders.getOrderNo() + "<--orders.getOrderNo() if문 밖 --selectOrdersOne");

	        // OrderProduct 객체를 생성하고 속성을 설정합니다.
	        OrderProduct orderProduct = new OrderProduct();
	        orderProduct.setOrderProductNo(rs.getInt("orderProductNo"));
	        orderProduct.setProductNo(rs.getInt("productNo"));
	        orderProduct.setProductCnt(rs.getInt("productCnt"));
	        orderProduct.setDeliveryStatus(rs.getString("deliveryStatus"));

	        // 주문 상품 세부 정보를 리스트에 추가합니다.
	        orderProducts.add(orderProduct);
	    }
       // System.out.println(orders.getOrderNo() + "<--orders.getOrderNo() while문 밖 --selectOrdersOne");


	    // HashMap에 주문 정보와 주문 상품 세부 정보를 저장합니다.
	    map.put("orders", orders);
	    map.put("orderProducts", orderProducts);
        //System.out.println(map.get("orders") +"<--get orders--selectOrdersOne");
       System.out.println(map.get("orderProducts") +"<--get orderProducts--selectOrdersOne");

	    return map;
	}


//2) 그냥 orders만 + 페이징
	/*
SELECT
	order_no AS orderNo,
	order_address AS orderAddress,
	order_price AS orderPrice,
	createdate,
	updatedate
FROM orders
WHERE id = 'test2'
ORDER BY orderNo DESC
LIMIT 1, 5
	*/
	
	public ArrayList<Orders> justOrders(int beginRow, int rowPerPage, String loginMemberId) throws Exception {
		ArrayList<Orders> orderList = new ArrayList<Orders>();
		
	    // DB 연결을 위한 DBUtil 객체와 Connection 객체 생성
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    // 주문 및 주문 상품 정보를 조회하는 SQL문
	    String sql = "SELECT "
	    		+ "	order_no AS orderNo, "
	    		+ "	order_address AS orderAddress, "
	    		+ "	order_price AS orderPrice, "
	    		+ "	createdate, "
	    		+ "	updatedate "
	    		+ "FROM orders "
	    		+ "WHERE id = ? "
	    		+ "ORDER BY orderNo DESC "
	    		+ "LIMIT ?, ?";
	    // SQL문 실행을 위한 PreparedStatement 객체 생성
	    PreparedStatement mainStmt = conn.prepareStatement(sql);
		mainStmt.setString(1, loginMemberId);
		//페이징 처리를 위한 SQL 쿼리문에서의 인덱스는 0부터 시작하므로 beginRow를 1을 빼서 0부터 시작하도록 설정
		mainStmt.setInt(2, beginRow - 1);
		mainStmt.setInt(3, rowPerPage);
	    ResultSet rs = mainStmt.executeQuery();
	    
	    // 결과셋 받아오기
	    while (rs.next()) {
	    	Orders orders = new Orders();
	    	orders.setOrderNo(rs.getInt("orderNo"));
	    	orders.setOrderAddress(rs.getString("orderAddress"));
	    	orders.setOrderPrice(rs.getDouble("orderPrice"));
		    orders.setUpdatedate(rs.getString("updatedate"));
		    orders.setCreatedate(rs.getString("createdate"));
		    orderList.add(orders);
	    }
		return orderList;
	}


	
	
//3)orderNo 주문취소, 취소 철회
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
		public int oPNDeleiveryStatus(String deliStatus, int orderProductNo) throws Exception {
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
		
//4)주문하기
		public int addOrder(Orders orders ) throws Exception {
			int result = 0;
			DBUtil dbUtil = new DBUtil();
		    Connection conn = dbUtil.getConnection();

		    String sql = "INSERT INTO orders (id, order_address, order_price, createdate, updatedate) "
		    		+ "VALUES(?, ?, ?, NOW(), NOW())";
		    PreparedStatement stmt = conn.prepareStatement(sql,PreparedStatement.RETURN_GENERATED_KEYS);
		    stmt.setString(1, orders.getId());
		    stmt.setString(2, orders.getOrderAddress());
		    stmt.setDouble(3, orders.getOrderPrice());
		    stmt.executeUpdate();
		    
		    ResultSet keyRs = stmt.getGeneratedKeys(); // 저장된 키값을 반환
			if(keyRs.next()) {
				result = keyRs.getInt(1);
	            System.out.println(result +"<--pk-- addOrderDao");
			}
		    return result;		
		}

}
