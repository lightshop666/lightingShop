package dao;
import vo.*;
import util.*;
import java.sql.*;
import java.util.*;

public class BoardDao {
	
	// 문의글 전체 리스트 조회 + 페이징, 검색단어(작성자,제목+내용), 문의 유형 카테고리 선택
	public ArrayList<Question> selectQuestionListByPage(int beginRow, int rowPerPage, String qCategory, String searchCategory, String searchWord) throws Exception {
		ArrayList<Question> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT
				q_no qNo, -- 문의글 번호
				id id, -- 작성자 아이디 (비회원은 guest)
				q_category qCategory, -- 문의 유형 카테고리
				q_title qTitle, -- 문의글 제목
				q_name qName, -- 작성자 이름
				a_chk aChk, -- 답변유무 (Y/N)
				private_chk privateChk, -- 비공개유무 (Y/N)
				createdate createdate -- 작성일자
			FROM question
			WHERE 1=1
			
			1) qCategory만 선택
				AND q_category = ?
			2) searchCategory가 qName일 때
		 		AND q_name LIKE ?
			3) searchCategory가 qtitleAndContent일 때
				AND CONCAT(q_title,' ',q_content) LIKE ?
			4) 정렬(신상품순), 페이징
				ORDER BY q_no DESC LIMIT ?, ?
		*/
		String sql = "SELECT q_no qNo, id id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate createdate FROM question WHERE 1=1";
		// 1) qCategory만 선택
		if(!qCategory.equals("")) {
			sql += " AND q_category = ?";
		}
		// 2) searchCategory가 qName일 때
		if(searchCategory.equals("qName")) {
			sql += " AND q_name LIKE ?";
		}
		// 3) searchCategory가 qtitleAndContent일 때
		if(searchCategory.equals("qtitleAndContent")) {
			sql += " AND CONCAT(q_title,' ',q_content) LIKE ?";
		}
		// 4) 정렬(신상품순), 페이징
		sql += " ORDER BY q_no DESC LIMIT ?, ?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		int parameterIndex = 1; // 물음표 인덱스
		// 1)
		if(!qCategory.equals("")) {
			stmt.setString(parameterIndex++, qCategory);
		}
		// 2)
		if(searchCategory.equals("qName")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 3)
		if(searchCategory.equals("qtitleAndContent")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 4)
		stmt.setInt(parameterIndex++, beginRow);
		stmt.setInt(parameterIndex++, rowPerPage);
		
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
		
		String sql = "SELECT COUNT(*) FROM question WHERE 1=1";
		// 1) qCategory만 선택
		if(!qCategory.equals("")) {
			sql += " AND q_category = ?";
		}
		// 2) searchCategory가 qName일 때
		if(searchCategory.equals("qName")) {
			sql += " AND q_name LIKE ?";
		}
		// 3) searchCategory가 qtitleAndContent일 때
		if(searchCategory.equals("qtitleAndContent")) {
			sql += " AND CONCAT(q_title,' ',q_content) LIKE ?";
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		int parameterIndex = 1; // 물음표 인덱스
		// 1)
		if(!qCategory.equals("")) {
			stmt.setString(parameterIndex++, qCategory);
		}
		// 2)
		if(searchCategory.equals("qName")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 3)
		if(searchCategory.equals("qtitleAndContent")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
	
	// 특정 아이디의 문의글 리스트 조회 (마이페이지 내 문의 관리) + 페이징, 기간별조회, 검색단어(제목,내용)
	public ArrayList<Question> selectMyQuestionList(int beginRow, int rowPerPage, String loginId, String beginDate, String endDate, String searchCategory, String searchWord) throws Exception {
		ArrayList<Question> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT
				q_no qNo, -- 문의글 번호
				q_category qCategory, -- 문의 유형 카테고리
				q_name qName, -- 작성자 이름
				q_title qTitle, -- 문의글 제목
				private_chk privateChk, -- 비공개유무 (Y/N)
				createdate createdate -- 작성일자
				a_chk aChk, -- 답변유무 (Y/N)
			FROM question
			WHERE id = ?
			
			1) beginDate 또는 endDate 값이 있을 때 (기간별 조회)
				AND createdate > ?
				AND createdate < ?
				AND createdate BETWEEN ? AND ?
			2) searchCategory가 qTitle일 때
		 		AND q_name LIKE ?
			3) searchCategory가 qContent일 때
				AND CONCAT(q_title,' ',q_content) LIKE ?
			4) 정렬(신상품순), 페이징
				ORDER BY createdate DESC LIMIT ?, ?
		*/
		String sql = "SELECT q_no qNo, q_category qCategory, q_name qName, q_title qTitle, private_chk privateChk, createdate, a_chk aChk FROM question WHERE id = ?";
		// 1) beginDate 또는 endDate 값이 있을 때 (기간별 조회)
		if(!beginDate.equals("") && endDate.equals("")) { // 시작날짜만 입력
			sql += " AND createdate > ?";
		} else if(beginDate.equals("") && !endDate.equals("")) { // 끝날짜만 입력
			sql += " AND createdate < ?";
		} else if(!beginDate.equals("") && !endDate.equals("")) { // 둘다 입력
			sql += " AND createdate BETWEEN ? AND ?";
		}
		// 2) searchCategory가 qTitle일 때
		if(searchCategory.equals("qTitle")) {
			sql += " AND q_name LIKE ?";
		}
		// 3) searchCategory가 qContent일 때
		if(searchCategory.equals("qContent")) {
			sql += " AND CONCAT(q_title,' ',q_content) LIKE ?";
		}
		// 4) 정렬(신상품순), 페이징
		sql += " ORDER BY createdate DESC LIMIT ?, ?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, loginId);
		
		int parameterIndex = 2; // 물음표 인덱스
		// 1) 
		if(!beginDate.equals("") && endDate.equals("")) {
			stmt.setString(parameterIndex++, beginDate+" 00:00:00");
		} else if(beginDate.equals("") && !endDate.equals("")) {
			stmt.setString(parameterIndex++, endDate+" 23:59:59");
		} else if(!beginDate.equals("") && !endDate.equals("")) {
			stmt.setString(parameterIndex++, beginDate+" 00:00:00");
			stmt.setString(parameterIndex++, endDate+" 23:59:59");
		}
		// 2) 
		if(searchCategory.equals("qTitle")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 3)
		if(searchCategory.equals("qContent")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 4)
		stmt.setInt(parameterIndex++, beginRow);
		stmt.setInt(parameterIndex++, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Question q = new Question();
			q.setqNo(rs.getInt("qNo"));
			q.setqCategory(rs.getString("qCategory"));
			q.setqName(rs.getString("qName"));
			q.setqTitle(rs.getString("qTitle"));
			q.setPrivateChk(rs.getString("privateChk"));
			q.setaChk(rs.getString("aChk"));
			q.setCreatedate(rs.getString("createdate"));
			list.add(q);
		}
		return list;
	}
	
	// 검색단어, 조회기간 선택에 따른 특정 아이디의 문의글 전체 수 (totalRow)
	public int selectMyQuestionCnt(int beginRow, int rowPerPage, String loginId, String beginDate, String endDate, String searchCategory, String searchWord) throws Exception {
		int totalRow = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM question WHERE id = ?";
		// 1) beginDate 또는 endDate 값이 있을 때 (기간별 조회)
		if(!beginDate.equals("") && endDate.equals("")) { // 시작날짜만 입력
			sql += " AND createdate > ?";
		} else if(beginDate.equals("") && !endDate.equals("")) { // 끝날짜만 입력
			sql += " AND createdate < ?";
		} else if(!beginDate.equals("") && !endDate.equals("")) { // 둘다 입력
			sql += " AND createdate BETWEEN ? AND ?";
		}
		// 2) searchCategory가 qTitle일 때
		if(searchCategory.equals("qTitle")) {
			sql += " AND q_name LIKE ?";
		}
		// 3) searchCategory가 qContent일 때
		if(searchCategory.equals("qContent")) {
			sql += " AND CONCAT(q_title,' ',q_content) LIKE ?";
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, loginId);
		
		int parameterIndex = 2; // 물음표 인덱스
		// 1) 
		if(!beginDate.equals("") && endDate.equals("")) {
			stmt.setString(parameterIndex++, beginDate+" 00:00:00");
		} else if(beginDate.equals("") && !endDate.equals("")) {
			stmt.setString(parameterIndex++, endDate+" 23:59:59");
		} else if(!beginDate.equals("") && !endDate.equals("")) {
			stmt.setString(parameterIndex++, beginDate+" 00:00:00");
			stmt.setString(parameterIndex++, endDate+" 23:59:59");
		}
		// 2) 
		if(searchCategory.equals("qTitle")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 3)
		if(searchCategory.equals("qContent")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
	
	// 문의글 비밀번호 일치 불일치 조회
	public boolean questionOnePwChk(int qNo, String inputPw) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM question WHERE q_no = ? AND q_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qNo);
		stmt.setString(2, inputPw);
		ResultSet rs = stmt.executeQuery();
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		
		if(row == 1) {
			return true;
		} else {
			return false;
		}
	}
	
	// 문의글 상세보기 (question, answer, product, product_img join)
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
			FROM
				question q
				LEFT JOIN answer a ON q.q_no = a.q_no
				LEFT JOIN product p ON q.product_no = p.product_no
				LEFT JOIN product_img i on p.product_no = i.product_no
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
		int[] rowAndKey = new int[2]; // row와 key값을 받아오기 위한 배열 생성
		
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
		
		String sql = "INSERT INTO question(product_no, id, q_name, q_category, q_title, q_content, q_pw, a_chk, private_chk, createdate, updatedate) VALUES(?, ?, ?, ?, ?, ?, PASSWORD(?), ?, ?, NOW(), NOW())";
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
	
	// 문의글 삭제 (+ 마이페이지에서 접근시 다중 선택 후 일괄 삭제 가능)
	public int deleteQuestion(int[] intCkQno) throws Exception {
		int row = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement stmt = null;
		
		// 1) 쿼리 작성
		// 기본쿼리는 물음표 1개를 넣고 시작
		String sql = "DELETE FROM question WHERE q_no IN(?";
		// 쿼리에 물음표가 몇개 들어갈지 셋팅
		for(int i=1; i<intCkQno.length; i++) {
			sql += ",?";
		}
		sql += ")"; // length만큼 물음표가 출력되고 마지막에 괄호 닫기
		stmt = conn.prepareStatement(sql);
		
		// 2) 물음표에 들어갈 값 넣기
		for(int i=0; i<intCkQno.length; i++) {
			stmt.setInt(i+1, intCkQno[i]);
			// 첫번째 물음표(i+1)에 배열의 값(인덱스 0부터) 순서대로 넣어주기
		}
		row = stmt.executeUpdate();
		
		return row;
	}
}
