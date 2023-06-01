package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
	public Customer customerLogin(Customer customer, IdList idList) throws Exception {
		Customer loginCustomer = null;
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT id, cstm_name, cstm_address, cstm_email, cstm_birth, cstm_phone, cstm_gender,"
				+ " cstm_rank, cstm_point, cstm_last_login, cstm_agree"
				+ " FROM customer INNER JOIN id_list ON customer.id = id_list.id"
				+ " WHERE id = ? AND id_list.last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId());
		stmt.setString(2, idList.getLastPw());
		
		ResultSet rs = stmt.executeQuery();
		
		// DB 내용 불러오기
		if(rs.next()) {
			loginCustomer = new Customer();
			loginCustomer.setId(rs.getString("id")); // id 반환
			loginCustomer.setCstmName(rs.getString("cstm_name"));
			loginCustomer.setCstmAddress(rs.getString("cstm_address"));
			loginCustomer.setCstmEmail(rs.getString("cstm_email"));
			loginCustomer.setCstmBirth(rs.getString("cstm_birth"));
			loginCustomer.setCstmPhone(rs.getString("cstm_phone"));
			loginCustomer.setCstmGender(rs.getString("cstm_gender"));
			loginCustomer.setCstmRank(rs.getString("cstm_rank"));
			loginCustomer.setCstmPoint(rs.getInt("cstm_point"));
			loginCustomer.setCstmLastLogin(rs.getString("cstm_last_login"));
			loginCustomer.setCstmAgree(rs.getString("cstm_agree")); // 가입탈퇴여부 반환
		}
		
		return loginCustomer;
	}
	
	
	// 3) 회원정보 수정
	public Customer modifyCustomer(Customer customer) throws Exception {
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
	}
	
	// 4) 회원탈퇴
	public int removeCustomer(int id) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "DELETE FROM Customer WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, id);
		int row = stmt.executeUpdate();
		return row;
	}
}
