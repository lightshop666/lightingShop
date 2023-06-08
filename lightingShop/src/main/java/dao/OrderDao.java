package dao;
import vo.*;
import java.sql.*;
import java.util.*;
import util.DBUtil;

public class OrderDao {
	
//1)특정 주문 조회One
	/*
	SELECT *
	FROM orders o
	   INNER JOIN order_product op ON o.order_no = op.order_no
	      INNER JOIN product p ON p.product_no = p.product_no
	         INNER JOIN product_img pim ON p.product_no = pim.product_no
	WHERE o.order_no = 1
	
	지금 결과 2개가 아니라 여러개 나와서 봐야합니다.
	 */
	public ArrayList<HashMap<String, Object>> selectOrdersOne(String loginMemberId, int orderNo) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "";

	    PreparedStatement mainStmt = conn.prepareStatement(sql);
		mainStmt.setString(1, loginMemberId);
		//페이징 처리를 위한 SQL 쿼리문에서의 인덱스는 0부터 시작하므로 beginRow를 1을 빼서 0부터 시작하도록 설정
		mainStmt.setInt(2, orderNo);
		
		ResultSet mainRs = mainStmt.executeQuery();
		
		//결과셋 받아오기
		while (mainRs.next()) {
	        HashMap<String, Object> o = new HashMap<>();
	        o.put("orderNo", mainRs.getInt("orderNo"));

	        list.add(o);
	    }
		System.out.println(list+ "<--ArrayList-- ReviewDao.selectCustomerOrderList");
		return list;
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
