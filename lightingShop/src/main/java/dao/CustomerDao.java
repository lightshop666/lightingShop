package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.Customer;
import vo.IdList;
import vo.PwHistory;

public class CustomerDao {

	// 1-1) 회원가입 시 아이디 중복여부 확인
	public IdList selectCustomerIdCk(String id) throws Exception {
		IdList idList = null;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		// customer, id_list, pw_history의 id가 중복되지 않은 경우를 파악
		String sql = "SELECT id FROM (SELECT id FROM customer union SELECT id FROM id_list union SELECT id FROM pw_history) t WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getId());
		
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) { // 중복 아이디가 있는 경우
			idList = new IdList();
			idList.setId(rs.getString("id"));
		}
		// 최종 데이터 반환
		return idList;
	}
	
	// 1-2) 회원가입 - id_list
	public int addIdList(IdList idList) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String addIdListSql = "INSERT INTO id_list(id, last_pw, active, createdate) VALUES(?, PASSWORD(?), Y, NOW())";
		PreparedStatement addIdListStmt = conn.prepareStatement(addIdListSql);
		// id_list 테이블에 새로운 ID 값 추가
		addIdListStmt.setString(1, idList.getId());
		addIdListStmt.setString(2, idList.getLastPw());
		
		int result = addIdListStmt.executeUpdate();
		return result;
	}
	// 1-3) 회원가입 - customer
	public int addCustomer(Customer customer) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		// customer 테이블에 새로운 입력값 추가
	 	String addCustomerSql = "INSERT INTO customer(id, cstm_name, cstm_address, cstm_email, cstm_birth, cstm_phone, cstm_gender, "
				+ " cstm_rank, cstm_point, cstm_last_login, cstm_agree, createdate, updatedate) "
				+ " VALUES(?, ?, ?, ?, ?, ?, ?, 동, 100, NOW(), Y, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(addCustomerSql);
		stmt.setString(1, customer.getId());
		stmt.setString(2, customer.getCstmName());
		stmt.setString(3, customer.getCstmAddress());
		stmt.setString(4, customer.getCstmEmail());
		stmt.setString(5, customer.getCstmBirth());
		stmt.setString(6, customer.getCstmPhone());
		stmt.setString(7, customer.getCstmGender());
		
		int result = stmt.executeUpdate();
		
		return result;
	}
	// 1-4) 회원가입 - pwHistory
	public int addPwHistory(PwHistory pwHistory) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		// pw_history 테이블에 새로운 입력값 추가
	 	String addPwHistorySql = "INSERT INTO pw_history(id, pw, createdate)"
				+ " VALUES(?, PASSWORD(?), NOW())";
		PreparedStatement stmt = conn.prepareStatement(addPwHistorySql);
		stmt.setString(1, pwHistory.getId());
		stmt.setString(2, pwHistory.getPw());
		
		int result = stmt.executeUpdate();
		
		return result;
	}
	
	// 2) 로그인
	public IdList loginMethod(IdList idList) throws Exception {
		// 반환 객체 생성
		IdList loginIdList = null;
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT id, last_pw, active FROM id_list WHERE id = ? AND last_pw = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getId());
		stmt.setString(2, idList.getLastPw());
		
		ResultSet rs = stmt.executeQuery();
		
		// DB 내용 불러오기
		if(rs.next()) {
			loginIdList = new IdList();
			loginIdList.setId(rs.getString("id")); // id 반환
			loginIdList.setLastPw(rs.getString("last_pw")); // 비밀번호 반환
			loginIdList.setActive(rs.getString("Y")); // 가입탈퇴여부 반환
			/*
			loginCustomer.setCstmEmail(rs.getString("cstm_email"));
			loginCustomer.setCstmBirth(rs.getString("cstm_birth"));
			loginCustomer.setCstmPhone(rs.getString("cstm_phone"));
			loginCustomer.setCstmGender(rs.getString("cstm_gender"));
			loginCustomer.setCstmRank(rs.getString("cstm_rank"));
			loginCustomer.setCstmPoint(rs.getInt("cstm_point"));
			loginCustomer.setCstmLastLogin(rs.getString("cstm_last_login"));
			loginCustomer.setCstmAgree(rs.getString("cstm_agree")); // 가입탈퇴여부 반환
			*/	
		}
		
		// null -> 로그인 실패, 값이 존재 -> 로그인 성공 
		return loginIdList;
	}
	
	
	// 3) 회원정보 수정
	public HashMap<String, Object> modifyCustomer(Customer customer, IdList idList) throws Exception {
		
		/*
		// Customer,IdList 타입으로 분산 저장
		Customer c1 = new Customer();
		c1.setId(c1.getId());
		c1.setCstmName(c1.getCstmName());
		c1.setCstmAddress(c1.getCstmAddress());
		c1.setCstmEmail(c1.getCstmEmail());
		c1.setCstmBirth(c1.getCstmBirth());
		c1.setCstmPhone(c1.getCstmPhone());
		c1.setCstmGender(c1.getCstmGender());
		
		IdList i1 = new IdList();
		i1.setLastPw(i1.getLastPw());
		
		// HashMap 타입으로 저장
		HashMap<String, Object> map = new HashMap<>();
		map.put("c1", c1);
		map.put("i1", i1);
		*/
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "UPDATE customer SET id = ?, cstm_name = ?, cstm_address = ?, cstm_email = ?, cstm_birth = ?, cstm_phone = ?,"
				+ " cstm_gender = ?, updatedate =  NOW() WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId());
		stmt.setString(2, customer.getCstmName());
		stmt.setString(3, customer.getCstmAddress());
		stmt.setString(4, customer.getCstmEmail());
		stmt.setString(5, customer.getCstmBirth());
		stmt.setString(6, customer.getCstmPhone());
		stmt.setString(7, customer.getCstmGender());
		stmt.setString(8, customer.getCstmGender());
		
		return null;
	}
	
	// 4-1) 회원탈퇴 - active를 N으로 변경
	public void updateIdListActive(IdList idList) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "UPDATE id_list SET active = 'N' WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getId());
		stmt.executeUpdate();
	}
	
	// 4-2) 회원탈퇴시 비밀번호 일치여부 확인
	public IdList passwordCheck(IdList idList) throws Exception {
		
		// 반환 객체 생성
		IdList returnIdList = null;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT id, last_pw FROM id_list WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getLastPw());
		// SQL 명령 실행
		ResultSet rs = stmt.executeQuery();
		
		// 데이터베이스 내용 불러오기
		while(rs.next()) {
			returnIdList = new IdList(); // 멤버 객체 생성
			returnIdList.setId(rs.getString("id"));	// 아이디 반환
			returnIdList.setLastPw("lastPw"); // 패스워드 반환
		}
		return returnIdList;
	}
	
	// 5) Customer 상세페이지 검색용
	public Customer selectCustomerOne(Customer customer) throws Exception {
		
		Customer customerOne = null;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		// SQL 명령, 명령 준비
		String sql = ("select c.id, c.cstm_name, c.cstm_address, c.cstm_email, c.cstm_birth, c.cstm_phone, c.cstm_gender, c.cstm_rank, "
				+ " c.cstm_point, c.cstm_last_login, c.cstm_agree, c.createdate, c.updatedate FROM customer c "
				+ " WHERE c.id = ? ");
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId()); 	// Customer Id를 입력받는다.
		
		ResultSet rs = stmt.executeQuery();
		
		if (rs.next()) {
			customer.setId(rs.getString("c.id"));
			customer.setCstmName(rs.getString("c.cstm_name"));
			customer.setCstmAddress(rs.getString("c.cstm_address"));
			customer.setCstmEmail(rs.getString("c.cstm_email"));
			customer.setCstmBirth(rs.getString("c.cstm_birth"));
			customer.setCstmPhone(rs.getString("c.cstm_phone"));
			customer.setCstmGender(rs.getString("c.cstm_gender"));
			customer.setCstmRank(rs.getString("c.cstm_rank"));
			customer.setCstmPoint(rs.getInt("c.cstm_point"));
			customer.setCstmLastLogin(rs.getString("c.cstm_last_login"));
			customer.setCstmAgree(rs.getString("c.cstm_agree"));
			customer.setCreatedate(rs.getString("c.createdate"));
			customer.setUpdatedate(rs.getString("c.updatedate"));
		}
		return customerOne;
	}
	
	// 6) Customer 전체 행 출력 메소드
	public int selectCustomerCnt() throws Exception {
		// 검색 or 특정 where절이 있으면 입력값이 필요할 수 있다.
		int row = 0;
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM customer";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	
	// 7) 회원주소목록
	public ArrayList<CustomerAddress> myAddressList(Connection conn, CustomerAddress cusAddress) throws Exception {
		ArrayList<CustomerAddress> list = new ArrayList<CustomerAddress>();
		
		// 주소 불러오기
		String sql = "SELECT address_code, customer_id, address FROM customer_address WHERE customer_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, cusAddress.getCustomerId());
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			CustomerAddress ca = new CustomerAddress();
			ca.setAddressCode(rs.getInt("address_code"));
			ca.setCustomerId(rs.getString("customer_id"));
			ca.setAddress(rs.getString("address"));
			list.add(ca);
		}
		
		return list;
	}
	
	// 7-1) 개별 주소 불러오기
	public String myAddress(Connection conn, int addressCode) throws Exception {
		String myAddress = null;
		
		String sql = "SELECT address FROM customer_address WHERE address_code = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, addressCode);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			myAddress = rs.getString("address");
		}
		
		return myAddress;
	}
		
	// 8) 주소추가
	public int addMyAddress(Connection conn, CustomerAddress cusAddress) throws Exception {
		int addMyAddress = 0;
		
		String sql = "INSERT INTO customer_address("
				+ "customer_id, address, createdate"
				+ ") VALUES (?,?,NOW())"; // point는 기본값 100포인트 부여
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, cusAddress.getCustomerId());
		stmt.setString(2, cusAddress.getAddress());
		
		addMyAddress = stmt.executeUpdate();
		
		return addMyAddress;
	}
	
	// 9) 주소삭제
	public int removeAddress(Connection conn, CustomerAddress cusAddress) throws Exception {
		int removeAddress = 0;
		
		String sql = "DELETE from customer_address WHERE customer_id = ? AND address = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, cusAddress.getCustomerId());
		stmt.setString(2, cusAddress.getAddress());
		
		removeAddress = stmt.executeUpdate();
				
		return removeAddress;
	}
	
	// 9-1) 주소삭제 
	public void removeAllAddress(Connection conn, Customer customerOne) throws Exception {
		String sql = "DELETE FROM customer_address WHERE customer_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customerOne.getCustomerId());
		stmt.executeUpdate();
	}
	
	// 10) 주소 총개수
	public int ttlCntAddress(Connection conn, CustomerAddress cusAddress) throws Exception {
		int ttlAddress = 0;
		
		String sql = "SELECT COUNT(*) FROM customer_address WHERE customer_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, cusAddress.getCustomerId());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			ttlAddress = rs.getInt("COUNT(*)");
		}
		
		return ttlAddress;
	}
	
	// 11) pwHistory 이력 추가
	public int addPwHistory(Connection conn, PwHistory pwHistory) throws Exception {
		int addPwHistory = 0;
		
		String sql = "INSERT INTO pw_history(customer_id, pw, createdate)"
					+ " VALUES(?,PASSWORD(?),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getCustomerId());
		stmt.setString(2, pwHistory.getPw());
		addPwHistory = stmt.executeUpdate();
		
		return addPwHistory;
	}
	
	// 12) 데이터 총 개수(최대 3개로 제한)
	public int ttlCntPwHistory(Connection conn, PwHistory pwHistory) throws Exception {
		int ttlCntPwHistory = 0;
		
		String sql = "SELECT COUNT(*) FROM pw_history WHERE customer_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getCustomerId());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			ttlCntPwHistory = rs.getInt("COUNT(*)");
		}
		return ttlCntPwHistory;
	}
	
	// 13) 이력 삭제
	public int removePwHistory(Connection conn, PwHistory pwHistory) throws Exception {
		int removePwHistory = 0;
		
		String sql = "DELETE from pw_history WHERE customer_id = ? AND createdate = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getCustomerId());
		stmt.setString(2, pwHistory.getCreatedate());
		System.out.println("[pwHistoryDao]");
		System.out.println("(1)pwHistory.getCustomerId() : "+pwHistory.getCustomerId());
		System.out.println("(2)pwHistory.getCreatedate() : "+pwHistory.getCreatedate());
		
		removePwHistory = stmt.executeUpdate();
		System.out.println(removePwHistory);
		
		return removePwHistory;
	}
	
	// 14) pwHistory select (생성날짜 오름차순)
	public PwHistory selectOldestPw(Connection conn, PwHistory pwHistory) throws Exception {
		PwHistory selectOldestPw = null;
		
		String sql = "SELECT customer_id, createdate FROM pw_history"
					+ " WHERE customer_id = ?"
					+ " ORDER BY createdate"
					+ " LIMIT 0,1";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		stmt.setString(1, pwHistory.getCustomerId());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			selectOldestPw = new PwHistory();
			selectOldestPw.setCustomerId(rs.getString("customer_id"));
			selectOldestPw.setCreatedate(rs.getString("createdate"));
		}
		
		return selectOldestPw;
	}
	
	// 15) 회원탈퇴시 pwHistory 삭제
	public int removePwHistoryByRemoveCustomer(Connection conn, Customer customer) throws Exception {
		int removePwHistory = 0;
		
		String sql = "DELETE FROM pw_history WHERE customer_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getCustomerId());
		removePwHistory = stmt.executeUpdate();
		
		return removePwHistory;
	}
	
	// 16) 비밀번호 수정 시, 중복체크를 위한 select
	public boolean selectPwHistoryCk(Connection conn, Customer customer) throws Exception {
		boolean checkPw = false;
		
		String sql = "SELECT * FROM pw_history WHERE customer_id = ? AND pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getCustomerId());
		stmt.setString(2, customer.getCustomerPw());
		System.out.println("[pwHistory중복체크dao]");
		System.out.println("customer_id : "+customer.getCustomerId());
		System.out.println("customer_pw : "+customer.getCustomerPw());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			checkPw = true;
		}
		return checkPw;
	}
}
