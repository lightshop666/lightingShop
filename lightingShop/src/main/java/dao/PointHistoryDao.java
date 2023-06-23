package dao;

import java.sql.*;
import java.util.*;
import vo.*;
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
	
	public int pointByOrder(int orderNo) throws Exception {
		int result = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "INSERT INTO point_history (order_no, id, point_pm, point_info, point, createdate) " +
							"SELECT ?, o.id, 'P', '상품', " +
							"CASE c.cstm_rank " +
							"    WHEN '동' THEN o.order_price * 0.01 " +
							"    WHEN '은' THEN o.order_price * 0.03 " +
							"    WHEN '금' THEN o.order_price * 0.05 " +
							"END, " +
							"o.createdate " +
							"FROM orders o " +
							"JOIN customer c ON o.id = c.id " +
							"WHERE o.order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql,PreparedStatement.RETURN_GENERATED_KEYS);
		stmt.setInt(1, orderNo);
		stmt.setInt(2, orderNo);
		result = stmt.executeUpdate();
		
	    ResultSet keyRs = stmt.getGeneratedKeys(); // 저장된 키값을 반환
		if(keyRs.next()) {
			result = keyRs.getInt(1);
            System.out.println(result +"<--pk-- pointByOrder");
		}
	    return result;	
		
	}
//1-2) 주문시 포인트 삽입
	/*
	INSERT INTO
	point_history (order_no, id, point_pm, point_info, point, createdate)
	SELECT 
		o.order_no,
		o.id,
		'P',
		'상품', 
		CASE c.cstm_rank
			WHEN '동' THEN unselectedTotalPrice * 0.01
			WHEN '은' THEN unselectedTotalPrice * 0.03
			WHEN '금' THEN unselectedTotalPrice * 0.05
		END,
		o.createdate
	FROM orders o
	JOIN customer c ON o.id = c.id
	WHERE o.order_no = ?
	*/
	
	public int pointCancelP (int orderNo, int unselectedTotalPrice) throws Exception {
		int result = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "INSERT INTO point_history (order_no, id, point_pm, point_info, point, createdate) " +
							"SELECT ?, o.id, 'P', '상품', " +
							"CASE c.cstm_rank " +
							"    WHEN '동' THEN ? * 0.01 " +
							"    WHEN '은' THEN ? * 0.03 " +
							"    WHEN '금' THEN ? * 0.05 " +
							"END, " +
							"o.createdate " +
							"FROM orders o " +
							"JOIN customer c ON o.id = c.id " +
							"WHERE o.order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql,PreparedStatement.RETURN_GENERATED_KEYS);
		stmt.setInt(1, orderNo);
		stmt.setInt(2, unselectedTotalPrice);
		stmt.setInt(3, unselectedTotalPrice);
		stmt.setInt(4, unselectedTotalPrice);
		stmt.setInt(5, orderNo);
		result = stmt.executeUpdate();
		
	    ResultSet keyRs = stmt.getGeneratedKeys(); // 저장된 키값을 반환
		if(keyRs.next()) {
			result = keyRs.getInt(1);
            System.out.println(result +"<--pk-- pointByOrder");
		}
	    return result;	
		
	}
	
	
	
//1-3) 주문취소로 인한 포인트 환불(point P)
	/*
	INSERT INTO
		point_history (order_no, id, point_pm, point_info, point, createdate)
		SELECT 
			o.order_no,
			o.id,
			'P',
			'상품', 
			?,
			NOW()
	FROM orders o
	JOIN customer c ON o.id = c.id
	WHERE o.order_no = ?
 
	 */
	
	public int pointByCancel(int orderNo, int refundpoint) throws Exception {
		int result = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "	INSERT INTO "
				+ "		point_history (order_no, id, point_pm, point_info, point, createdate) "
				+ "		SELECT  "
				+ "			o.order_no, "
				+ "			o.id, "
				+ "			'P', "
				+ "			'상품',  "
				+ "			?, "
				+ "			NOW() "
				+ "	FROM orders o "
				+ "	JOIN customer c ON o.id = c.id "
				+ "	WHERE o.order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql,PreparedStatement.RETURN_GENERATED_KEYS);
		stmt.setInt(1, -(refundpoint));
		stmt.setInt(2, orderNo);
		result = stmt.executeUpdate();
		
	    ResultSet keyRs = stmt.getGeneratedKeys(); // 저장된 키값을 반환
		if(keyRs.next()) {
			result = keyRs.getInt(1);
            System.out.println(result +"<--pk-- pointByOrder");
		}
	    return result;	
		
	}
	
	
	
//2)주문시 사용에 따른 포인트 차감
	/*
	INSERT INTO
	point_history (order_no, id, point_pm, point_info, point, createdate)
	SELECT 
		o.order_no,
		o.id,
		'M',
		'상품', 
		?,
		o.createdate
	FROM orders o
	JOIN customer c ON o.id = c.id
	WHERE o.order_no = ?
	 */
	
	public int usedPoint(int orderNo, int usedPoint) throws Exception {
		int result = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "INSERT INTO point_history (order_no, id, point_pm, point_info, point, createdate) " +
						"SELECT ?, o.id, 'M', '상품', ?, o.createdate " +
						"FROM orders o " +
						"JOIN customer c ON o.id = c.id " +
						"WHERE o.order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql,PreparedStatement.RETURN_GENERATED_KEYS);
		stmt.setInt(1, orderNo);	
		stmt.setInt(2, usedPoint);		
		stmt.setInt(3, orderNo);		
		result = stmt.executeUpdate();
		
	    ResultSet keyRs = stmt.getGeneratedKeys(); // 저장된 키값을 반환
		if(keyRs.next()) {
			result = keyRs.getInt(1);
            System.out.println(result +"<--pk-- usedPoint");
		}
	    return result;	
	}
	
	
	
//3) customer 테이블에 point 업데이트
	/*
	UPDATE customer c
	JOIN point_history ph ON c.id = ph.id
	SET 
		c.cstm_point = CASE ph.point_pm
		    WHEN 'P' THEN c.cstm_point + ph.point
		    WHEN 'M' THEN c.cstm_point - ph.point
		    ELSE c.cstm_point
		   END
	WHERE ph.point_no = ?
	*/
	public int cstmPointUpdate(int pointPk) throws Exception {
	int row = 0;
	DBUtil dbUtil = new DBUtil();
	Connection conn = dbUtil.getConnection();
	
	String sql = "	UPDATE customer c "
			+ "	JOIN point_history ph ON c.id = ph.id "
			+ "	SET  "
			+ "		c.cstm_point = CASE ph.point_pm "
			+ "		    WHEN 'P' THEN c.cstm_point + ph.point "
			+ "		    WHEN 'M' THEN c.cstm_point - ph.point "
			+ "		    ELSE c.cstm_point "
			+ "		   END "
			+ "	WHERE ph.point_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, pointPk);
	row = stmt.executeUpdate();
	
	if (row !=0) {
		System.out.println(row +"행 point 업데이트 성공<--PointHistoryDao.cstmPointUpdate");
	}else{
		row=0;
		System.out.println(row +"행 point 업데이트 실패<--PointHistoryDao.cstmPointUpdate");
	}
	    
	return row;
	}
	
	
	
// 4) 고객 - 최신주문 순서별 포인트 내역 확인
	/*
	SELECT
		point_no AS pointNo,
		order_no AS orderNo,
		id,
		point_pm AS pointPm,
		point_info AS pointInfo,
		point,
		createdate
	FROM point_history
	WHERE id = ?
	ORDER BY createdate DESC
	LIMIT ?, ?
	*/
	public ArrayList<PointHistory> customerPointList(String id, int beginRow, int rowPerPage) throws Exception {
		ArrayList<PointHistory> pointHistory = new ArrayList<PointHistory>();
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT point_no AS pointNo, order_no AS orderNo,	id,	point_pm AS pointPm,	point_info AS pointInfo, point,createdate	FROM point_history WHERE id = ? ORDER BY createdate DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		
	    while (rs.next()) {
	        PointHistory p = new PointHistory();
	        p.setPointNo(rs.getInt("pointNo"));
	        p.setOrderNo(rs.getInt("orderNo"));
	        p.setId(rs.getString("id"));
	        p.setPointPm(rs.getString("pointPm"));
	        p.setPointInfo(rs.getString("pointInfo"));
	        p.setPoint(rs.getInt("point"));
	        p.setCreatedate(rs.getString("createdate"));
	        pointHistory.add(p);
	    }
		return pointHistory;
	}
	
//6)orderNo별 포인트 내역
	public ArrayList<PointHistory> pointListByOrder(int orderNo) throws Exception {
		ArrayList<PointHistory> pointHistoryList = new ArrayList<PointHistory>();

		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT "
		        + "    point_no AS pointNo, "
		        + "    order_no AS orderNo, "
		        + "    id, "
		        + "    point_pm AS pointPm, "
		        + "    point_info AS pointInfo, "
		        + "    point, "
		        + "    createdate "
		        + "FROM point_history "
		        + "WHERE order_no = ?";			
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		ResultSet rs = stmt.executeQuery();
		
		while (rs.next()) {
			PointHistory p = new PointHistory();
			p.setPointNo(rs.getInt("pointNo"));
			p.setOrderNo(rs.getInt("orderNo"));
			p.setId(rs.getString("id"));
			p.setPointPm(rs.getString("pointPm"));
			p.setPointInfo(rs.getString("pointInfo"));
			p.setPoint(rs.getInt("point"));
			p.setCreatedate(rs.getString("createdate"));
			pointHistoryList.add(p);
		}

	    return pointHistoryList;
	}
	
	
	
	
	
	
	
}
