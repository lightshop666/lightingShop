package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;

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
	// 2) 고객 - 최신주문 순서별 포인트 내역 확인
	public ArrayList<HashMap<String, Object>> CustomerPointList(int beginRow, int rowPerPage) throws Exception {
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = " SELECT p.order_no orderNo, p.point_info pointInfo, p.point point, p.createdate createdate" 
				+ " FROM customer c INNER JOIN orders o ON  c.id = o.id" 
				+ " INNER JOIN point_history p ON o.order_no = p.order_no" 
				+ " WHERE c.id = ? ORDER BY p.createdate DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("pointInfo", rs.getString("pointInfo") );
			m.put("point", rs.getString("point") );
			m.put("createdate", rs.getString("createdate") );
			list.add(m);	
		}
		return list;
	}

}
