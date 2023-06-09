package dao;

import java.sql.*;
import util.DBUtil;
import vo.*;

public class PointHistoryDao {
	
//1) 주문시 포인트 삽입
	/*
	INSERT INTO
	point_history (order_no, id, point_pm, point_info, point, createdate)
	SELECT 
		o.order_no,
		o.id,
		'P',
		'상품', 
		CASE c.cstm_rank
			WHEN '동' THEN o.order_price * 0.01
			WHEN '은' THEN o.order_price * 0.03
			WHEN '금' THEN o.order_price * 0.05
		END,
		o.createdate
	FROM orders o
	JOIN customer c ON o.id = c.id
	WHERE o.order_no = ?
	*/
	
	public int PointbyOrder(int orderNo) throws Exception {
		int row = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "INSERT INTO point_history (order_no, id, point_pm, point_info, point, createdate) SELECT  o.order_no, o.id, 'P', '상품', "
				+ "CASE c.cstm_rank "
				+ "			WHEN '동' THEN o.order_price * 0.01 "
				+ "			WHEN '은' THEN o.order_price * 0.03 "
				+ "			WHEN '금' THEN o.order_price * 0.05 END, "
				+ " o.createdate FROM orders o JOIN customer c ON o.id = c.id WHERE o.order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);		
		row = stmt.executeUpdate();
	    if (row !=0) {
	        System.out.println(row +"행 point_history 삽입 성공<--PointbyOrder");
         }else{
        	 row=0;
            System.out.println(row +"행 point_history 삽입 실패<--PointbyOrder");
         }
		
		return row;
	}

}
