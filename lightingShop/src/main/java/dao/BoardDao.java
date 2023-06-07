package dao;
import vo.*;
import util.*;
import java.sql.*;
import java.util.*;

public class BoardDao {
	
	// 문의글 리스트 조회 + 페이징, 검색단어(작성자,제목+내용), 카테고리 선택
	public ArrayList<Question> selectQuestionListByPage(int beginRow, int rowPerPage, String qCategory, String searchCategory, String searchWord) throws Exception {
		ArrayList<Question> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			정렬 : 최신순 (생성일자 내림차순)
			선택 가능 값 : qCategory(select태그 사용), searchWord
			경우의 수 :
			1) 둘다 null
			SELECT * FROM question ORDER BY createdate DESC LIMIT ?, ?
			2) qCategory만 선택
			SELECT * FROM question WHERE q_category = ? ORDER BY createdate DESC LIMIT ?, ?
			3) searchCategory : qName
		 	SELECT * FROM question WHERE q_name LIKE ? ORDER BY createdate DESC LIMIT ?, ?
			4) searchCategory : qtitleAndContent
			SELECT * FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ? ORDER BY createdate DESC LIMIT ?, ?
			5) qCategory + searchCategory : qName
			SELECT * FROM question WHERE q_category = ? AND q_name LIKE ? ORDER BY createdate DESC LIMIT ?, ?
			6) qCategory + searchCategory : qtitleAndContent
			SELECT * FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ? ORDER BY createdate DESC LIMIT ?, ?
		*/
		String sql = "";
		PreparedStatement stmt = null;
		
		// 1) 둘다 null
		if(qCategory.equals("") && searchCategory.equals("")) {
			sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question ORDER BY createdate DESC LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
		// 2) qCategory만 선택
		} else if(!qCategory.equals("") && searchCategory.equals("")) {
			sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question WHERE q_category = ? ORDER BY createdate DESC LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, qCategory);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
		// 3) searchCategory : qName
		} else if(searchCategory.equals("qName") && qCategory.equals("")) {
			sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question WHERE q_name LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
		// 4) searchCategory : qtitleAndContent
		} else if(searchCategory.equals("qtitleAndContent") && qCategory.equals("")) {
			sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
		// 5) qCategory + searchCategory : qName
		} else if(!qCategory.equals("") && searchCategory.equals("qName")) {
			sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question WHERE q_category = ? AND q_name LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, qCategory);
			stmt.setString(2, "%"+searchWord+"%");
			stmt.setInt(3, beginRow);
			stmt.setInt(4, rowPerPage);
		// 6) qCategory + searchCategory : qtitleAndContent
		} else if(!qCategory.equals("") && searchCategory.equals("qtitleAndContent")) { 
			sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, qCategory);
			stmt.setString(2, "%"+searchWord+"%");
			stmt.setInt(3, beginRow);
			stmt.setInt(4, rowPerPage);
		}
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Question q = new Question();
			q.setqNo(rs.getInt("qNo"));
			q.setId(rs.getString("id"));
			q.setqCategory(rs.getString("qCategory"));
			q.setqTitle(rs.getString("qTitle"));
			q.setqName(rs.getString("qName"));
			q.setaChk(rs.getString("aChk"));
			q.setPrivateChk(rs.getString("privateChk"));
			q.setCreatedate(rs.getString("createdate"));
			list.add(q);
		}
		return list;
	}
	
	// 검색단어, 카테고리 선택에 따른 문의글 전체 수 (totalRow)
	public int selectQuestionCnt(String qCategory, String searchCategory, String searchWord) throws Exception {
		int totalRow = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			경우의 수 :
			1) 둘다 null
			SELECT COUNT(*) FROM question
			2) qCategory만 선택
			SELECT COUNT(*) FROM question WHERE q_category = ?
			3) searchCategory : qName
		 	SELECT COUNT(*) FROM question question WHERE q_name LIKE ?
			4) searchCategory : qtitleAndContent
			SELECT COUNT(*) FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ?
			5) qCategory + searchCategory : qName
			SELECT COUNT(*) FROM question WHERE q_category = ? AND q_name LIKE ?
			6) qCategory + searchCategory : qtitleAndContent
			SELECT COUNT(*) FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ?
		*/
		String sql = "";
		PreparedStatement stmt = null;
		
		// 1) 둘다 null
		if(qCategory.equals("") && searchCategory.equals("")) {
			sql = "SELECT COUNT(*) FROM question";
			stmt = conn.prepareStatement(sql);
		// 2) qCategory만 선택
		} else if(!qCategory.equals("") && searchCategory.equals("")) {
			sql = "SELECT COUNT(*) FROM question WHERE q_category = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, qCategory);
		// 3) searchCategory : qName
		} else if(searchCategory.equals("qName") && qCategory.equals("")) {
			sql = "SELECT COUNT(*) FROM question question WHERE q_name LIKE ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
		// 4) searchCategory : qtitleAndContent
		} else if(searchCategory.equals("qtitleAndContent") && qCategory.equals("")) {
			sql = "SELECT COUNT(*) FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
		// 5) qCategory + searchCategory : qName
		} else if(!qCategory.equals("") && searchCategory.equals("qName")) {
			sql = "SELECT COUNT(*) FROM question WHERE q_category = ? AND q_name LIKE ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, qCategory);
			stmt.setString(2, "%"+searchWord+"%");
		// 6) qCategory + searchCategory : qtitleAndContent
		} else if(!qCategory.equals("") && searchCategory.equals("qtitleAndContent")) {
			sql = "SELECT COUNT(*) FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, qCategory);
			stmt.setString(2, "%"+searchWord+"%");
		}
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
	
	// 특정 아이디의 문의글 리스트 조회 (마이페이지 내 문의 관리)
	public ArrayList<Question> selectMyQuestionList(String loginId) throws Exception {
		ArrayList<Question> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_no qNo, product_no productNo, q_category qCategory, q_title qTitle, a_chk aChk, createdate FROM question WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, loginId);
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			Question q = new Question();
			q.setqNo(rs.getInt("qNo"));
			q.setProductNo(rs.getInt("productNo"));
			q.setqCategory(rs.getString("qCategory"));
			q.setqTitle(rs.getString("qTitle"));
			q.setaChk(rs.getString("aChk"));
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
	
	// 문의글 상세보기 (문의내용 + 답변내용 + 상품이름 + 상품이미지 join)
	public HashMap<String, Object> selectQuestionOne(int qNo) throws Exception {
		HashMap<String, Object> map = new HashMap<>();
		Question question = null;
		Answer answer = null;
		Product product = null;
		ProductImg productImg = null;
		
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
				a.updatedate aUpdatedate, -- 답변 수정일자
				p.product_name productName, -- 상품이름
				i.product_save_filename productSaveFilename, -- 상품이미지 저장이름
				i.product_path productPath -- 상품 이미지 저장폴더
			FROM question q
			LEFT JOIN answer a
			ON q.q_no = a.q_no
				LEFT JOIN product p
				ON q.product_no = p.product_no
					LEFT JOIN product_img i
					on p.product_no = i.product_no
			WHERE q.q_no = ?
		*/
		String sql = "SELECT q.q_no qNo, q.product_no productNo, q.id qId, q.q_name qName, q.q_category qCategory, q.q_title qTitle, q.q_content qContent, q.private_chk qPrivateChk, q.createdate qCreatedate, q.updatedate qUpdatedate, a.a_content aContent, a.createdate aCreatedate, a.updatedate aUpdatedate, p.product_name productName, i.product_save_filename productSaveFilename, i.product_path productPath FROM question q LEFT JOIN answer a ON q.q_no = a.q_no LEFT JOIN product p ON q.product_no = p.product_no LEFT JOIN product_img i ON p.product_no = i.product_no WHERE q.q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			question = new Question();
			answer = new Answer();
			product = new Product();
			productImg = new ProductImg();
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
			product.setProductName(rs.getString("productName"));
			productImg.setProductSaveFilename(rs.getString("productSaveFilename"));
			productImg.setProductPath(rs.getString("productPath"));
		}
		map.put("question", question);
		map.put("answer", answer);
		map.put("product", product);
		map.put("productImg", productImg);
		return map;
	}
	
	// 문의글 작성
	public int[] insertQuestion(Question question) throws Exception {
		int[] rowAndKey = new int[2];
		
		int productNo = question.getProductNo();
		String id = question.getId();
		String qName = question.getqName();
		String qCategory = question.getqCategory();
		String qTitle = question.getqTitle();
		String qContent = question.getqContent();
		String qPw = question.getqPw();
		String aChk = question.getaChk();
		String privateChk = question.getPrivateChk();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "INSERT INTO question(product_no, id, q_name, q_category, q_title, q_content, q_pw, a_chk, private_chk, createdate, updatedate) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
		// RETURN_GENERATED_KEYS -> 방금 insert한 키 값을 받아올 수 있다
		stmt.setInt(1, productNo);
		stmt.setString(2, id);
		stmt.setString(3, qName);
		stmt.setString(4, qCategory);
		stmt.setString(5, qTitle);
		stmt.setString(6, qContent);
		stmt.setString(7, qPw);
		stmt.setString(8, aChk);
		stmt.setString(9, privateChk);
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
