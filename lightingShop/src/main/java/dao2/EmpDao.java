package dao2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import util.*;
import vo.Answer;

public class EmpDao {
	//----------------- e.문의관리------------------------
	
	// 1-1) 관리자 문의 list count
	public int questionCount() throws Exception {
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		int count = 0;
		String sql = "SELECT COUNT(*) FROM question";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			count = rs.getInt(1);
		}
		return count;
	}
	
	// 1-2) 관리자 - 문의 list 조회 (문의게시판의 카테고리 검색 + 페이징)
	public ArrayList<HashMap<String, Object>> questionByAdmin(int beginRow, int rowPerPage, String category) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// LEFT JOIN - 답변이 없고 질문만 있는 경우에도 조회
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		String sql = "SELECT"
				+ " q.q_no qNo"
				+ ", q.q_category qCategory"
				+ ", q.q_title qTitle"
				+ ", q.q_content qContent"
				+ ", q.createdate createdate"
				+ ", o.order_no orderNo"
				+ ", o.id id"
				+ ", p.product_no productNo"
				+ ", p.product_name productName"
				+ ", img.product_save_filename productSaveFilename"
				+ ", a.a_no aNo"
				+ " FROM question q INNER JOIN order_product op"
				+ " ON q.product_no = op.product_no"
				+ " INNER JOIN orders o"
				+ " ON op.order_no = o.order_no"
				+ " INNER JOIN product p"
				+ " ON op.product_no = p.product_no"
				+ " INNER JOIN product_img img"
				+ " ON p.product_no = img.product_no"
				+ " LEFT JOIN answer a"
				+ " ON q.q_no = a.q_no"
				+ " WHERE q.q_category LIKE ?"
				+ " ORDER BY q.q_no DESC"
				+ " LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%" + category + "%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("qNo", rs.getInt("qNo"));
			m.put("qCategory", rs.getString("qCategory"));
			m.put("qTitle", rs.getString("qTitle"));
			m.put("qContent", rs.getString("qContent"));
			m.put("createdate", rs.getString("createdate"));
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("id", rs.getString("id"));
			m.put("productNo", rs.getInt("productNo"));
			m.put("productName", rs.getString("productName"));
			m.put("productSaveFilename", rs.getString("productSaveFilename"));
			m.put("aNo", rs.getInt("aNo"));
			list.add(m);
		}
		return list;
	}
	
	// 2) QuestionOne
	public ArrayList<HashMap<String, Object>> questionOne(int qNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		String sql = "SELECT"
				+ " q.q_no qNo"
				+ ", q.q_category qCategory"
				+ ", q.q_title qTitle"
				+ ", q.q_content qContent"
				+ ", q.createdate createdate"
				+ ", o.order_no orderNo"
				+ ", o.id id"
				+ ", p.product_name productName"
				+ ", img.product_save_filename productSaveFilename"
				+ " FROM question q INNER JOIN order_product op"
				+ " ON q.product_no = op.product_no"
				+ " INNER JOIN orders o"
				+ " ON op.order_no = o.order_no"
				+ " INNER JOIN product p"
				+ " ON op.product_no = p.product_no"
				+ " INNER JOIN product_img img"
				+ " ON p.product_no = img.product_no"
				+ " WHERE q.q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("qNo", rs.getInt("qNo"));
			m.put("qCategory", rs.getString("qCategory"));
			m.put("qTitle", rs.getString("qTitle"));
			m.put("qContent", rs.getString("qContent"));
			m.put("createdate", rs.getString("createdate"));
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("id", rs.getString("id"));
			m.put("productName", rs.getString("productName"));
			m.put("productSaveFilename", rs.getString("productSaveFilename"));
			list.add(m);
		}
		return list;
	}
	
	// 3) questionDelete - 해당 넘버에 해당하는 문의글 개별삭제
	public int removeQuestion(int qNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		int removeQuestion = 0;
		String sql = "DELETE FROM question WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		removeQuestion = stmt.executeUpdate();
		return removeQuestion;
	}
	
	// 4-1) answerInsert 
	public int insertAnswer(Answer answer) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		int insertAnswer = 0;
		String sql = "INSERT INTO answer(q_no, id, a_content, createdate) VALUES (?,?,?, NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, answer.getqNo() );
		stmt.setString(2,answer.getId() );
		stmt.setString(3,answer.getaContent() );
		insertAnswer = stmt.executeUpdate();
		return insertAnswer;
	}
	
	// 4-2) answerInsert 체크 -> q_no 조회로 답변유무 체크
	public boolean answerInsertCheck(int qNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		boolean answerCheck = false;
		String sql = "SELECT a.a_no aNo , a.q_no qNo, a.id id, a.a_content aContent, a.createdate createdate, a.updatedate updatedate "
				+ " FROM answer a "
				+ " WHERE a.q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		// 답변이 존재할경우
		if(rs.next()) {
			answerCheck = true;
		}
		return answerCheck;
	}
	
	// 5) 답변내용 개별가져오기
	public ArrayList<HashMap<String, Object>> answerOne(int qNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		String sql = "SELECT q_no qNo, id, a_content aContent, createdate FROM answer WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("qNo", rs.getInt("qNo"));
			m.put("id", rs.getString("id"));
			m.put("aContent", rs.getString("aContent"));
			m.put("createdate", rs.getString("createdate"));
			list.add(m);
		}
		return list;
	}
	
	// 6) 답변내용 전체가져오기
	public ArrayList<HashMap<String, Object>> answerAll() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		String sql = "SELECT a.a_no aNo, q.q_no qNo" 
				+ " FROM answer a INNER JOIN question q" 
				+ " ON a.q_no = q.q_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("aNo", rs.getInt("aNo"));
			m.put("qNo", rs.getInt("qNo"));
			list.add(m);
		}
		return list;
	}
	
	// 7) 답변내용 수정
	public int modifyAnswer(Answer answer) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		int modifyAnswer = 0;
		String sql = "UPDATE answer SET q_no = ?, id = ?, a_content = ?, updatedate = NOW() WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, answer.getqNo() );
		stmt.setString(2,answer.getId() );
		stmt.setString(3,answer.getaContent() );
		stmt.setInt(4, answer.getqNo() );
		modifyAnswer = stmt.executeUpdate();
		return modifyAnswer;
	}
	
}
