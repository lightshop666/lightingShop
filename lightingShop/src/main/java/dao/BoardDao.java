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
		
		String sql = "SELECT q_no qNo, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question ORDER BY createdate DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			Question q = new Question();
			q.setqNo(rs.getInt("qNo"));
			q.setqTitle(rs.getString("qTitle"));
			q.setId(rs.getString("qName"));
			q.setaChk(rs.getString("aChk"));
			q.setqPw(rs.getString("privateChk"));
			q.setCreatedate(rs.getString("createdate"));
			list.add(q);
		}
		return list;
	}
	
	// 문의글 비밀번호 일치 불일치 조회
	public boolean questionOnePwChk(int qNo, String inputPw) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_pw FROM question WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		
		String qPw = "";
		if(rs.next()) {
			qPw = rs.getString(1);
		}
		
		if(qPw.equals(inputPw)) {
			return true;
		} else {
			return false;
		}
	}
	
	// 문의글 상세보기 (문의내용 + 답변내용 join)
	public HashMap<String, Object> selectQuestionOne(int qNo) throws Exception {
		HashMap<String, Object> map = new HashMap<>();
		Question question = null;
		Answer answer = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT
				q.q_no qNo, -- 문의글 번호
				q.product_no productNo, -- 상품번호 (상품 미선택시 관리자 번호: 1)
				q.id qId, -- 문의글 작성자 아이디 (비회원은 guest)
				q.q_name qName, -- 문의글 작성자 이름
				q.q_category qCategory, -- 문의 카테고리 (상품/교환환불/결제/배송/기타)
				q.q_title qTitle, -- 문의글 제목
				q.q_content qContent, -- 문의글 내용
				q.private_chk qPrivateChk, -- 문의글 비공개 유무
				q.createdate qCreatedate, -- 문의글 작성일자
				q.updatedate qUpdatedate, -- 문의글 수정일자
				a.a_content aContent, -- 답변 내용
				a.createdate aCreatedate, -- 답변 작성일자
				a.updatedate aUpdatedate -- 답변 수정일자
			FROM question q
			LEFT JOIN answer a
			ON q.q_no = a.q_no
			WHERE q.q_no = ?
		*/
		String sql = "SELECT q.q_no qNo, q.product_no productNo, q.id qId, q.q_name qName, q.q_category qCategory, q.q_title qTitle, q.q_content qContent, q.private_chk qPrivateChk, q.createdate qCreatedate, q.updatedate qUpdatedate, a.a_content aContent, a.createdate aCreatedate, a.updatedate aUpdatedate FROM question q LEFT JOIN answer a ON q.q_no = a.q_no WHERE q.q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			question = new Question();
			answer = new Answer();
			question.setqNo(rs.getInt("qNo"));
			question.setProductNo(rs.getInt("productNo"));
			question.setId(rs.getString("qId"));
			question.setqName(rs.getString("qName"));
			question.setqCategory(rs.getString("qCategory"));
			question.setqTitle(rs.getString("qTitle"));
			question.setqContent(rs.getString("qContent"));
			question.setPrivateChk(rs.getString("qPrivateChk"));
			question.setCreatedate(rs.getString("qCreatedate"));
			question.setUpdatedate(rs.getString("qUpdatedate"));
			answer.setaContent(rs.getString("aContent"));
			answer.setCreatedate(rs.getString("aCreatedate"));
			answer.setUpdatedate(rs.getString("aUpdatedate"));
		}
		map.put("question", question);
		map.put("answer", answer);
		return map;
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
