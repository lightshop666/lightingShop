package dao;
import vo.*;
import util.*;
import java.sql.*;
import java.util.*;

public class BoardDao {
	// 문의글 리스트 조회
	public ArrayList<Question> selectQuestionListByPage(int beginRow, int rowPerPage) throws Exception {
		ArrayList<Question> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_no qNo, q_title qTitle, id, a_chk aChk, q_pw qPw, createdate FROM question ORDER BY createdate DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			Question q = new Question();
			q.setqNo(rs.getInt("qNo"));
			q.setqTitle(rs.getString("qTitle"));
			q.setId(rs.getString("id"));
			q.setaChk(rs.getString("aChk"));
			q.setqPw(rs.getString("qPw"));
			q.setCreatedate(rs.getString("createdate"));
			list.add(q);
		}
		return list;
	}
	
	// 문의글 비밀번호 조회
	public String selectQuestionOnePw(int qNo) throws Exception {
		String qPw = "";
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_pw qPw FROM question WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			qPw = rs.getString(1);
		}
		
		return qPw;
	}
	
	// 문의글 상세보기
	public Question selectQuestionOne(int qNo) throws Exception {
		Question question = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_title qTitle, q_content qContent, a_chk aChk, createdate, updatedate FROM question WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			question = new Question();
			question.setqNo(rs.getInt("qNo"));
			question.setProductNo(rs.getInt("productNo"));
			question.setId(rs.getString("id"));
			question.setqCategory(rs.getString("qCategory"));
			question.setqTitle(rs.getString("qTitle"));
			question.setqContent(rs.getString("qContent"));
			question.setaChk(rs.getString("aChk"));
			question.setCreatedate(rs.getString("createdate"));
			question.setUpdatedate(rs.getString("updatedate"));
		}
		return question;
	}
	
	// 문의글 작성
	public int[] insertQuestion(Question question) throws Exception {
		int[] rowAndKey = new int[2];
		
		int productNo = question.getProductNo();
		String id = question.getId();
		String qCategory = question.getqCategory();
		String qTitle = question.getqTitle();
		String qContent = question.getqContent();
		String qPw = question.getqPw();
		String aChk = question.getaChk();
		String privateChk = question.getPrivateChk();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "INSERT INTO question(product_no, id, q_category, q_title, q_content, q_pw, a_chk, private_chk, createdate, updatedate) VALUES(?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
		// RETURN_GENERATED_KEYS -> 방금 insert한 키 값을 받아올 수 있다
		stmt.setInt(1, productNo);
		stmt.setString(2, id);
		stmt.setString(3, qCategory);
		stmt.setString(4, qTitle);
		stmt.setString(5, qContent);
		stmt.setString(6, qPw);
		stmt.setString(7, aChk);
		stmt.setString(8, privateChk);
		rowAndKey[0] = stmt.executeUpdate(); // 배열에 row값 저장
		
		// 키 값 (qNo) 받아오기
		ResultSet rs = stmt.getGeneratedKeys();
		int qNo = 0;
		if(rs.next()) {
			qNo = rs.getInt(1);
		}
		rowAndKey[1] = qNo; // 배열에 qNo값 저장
		
		return rowAndKey;
	}
	
	// 문의글 수정
	public int updateQuestion(Question question) throws Exception {
		int row = 0;
		
		int qNo = question.getqNo();
		String qCategory = question.getqCategory();
		String qTitle = question.getqTitle();
		String qContent = question.getqContent();
		String privateChk = question.getPrivateChk();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE question SET q_category = ?, q_title = ?, q_content = ?, private_chk = ?, updatedate = NOW() WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qCategory);
		stmt.setString(2, qTitle);
		stmt.setString(3, qContent);
		stmt.setString(4, privateChk);
		stmt.setInt(5, qNo);
		row = stmt.executeUpdate();
		
		return row;
	}
	
	// 문의글 삭제
	public int deleteQuestion(int qNo) throws Exception {
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "DELETE FROM question WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		row = stmt.executeUpdate();
		
		return row;
	}
}
