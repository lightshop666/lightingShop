package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBUtil;
import vo.Customer;

public class CustomerDao {

	// 1-1) 회원가입
	public int addCustomer(Customer customer) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "INSERT INTO customer(id, cstm_name, cstm_address, cstm_email, cstm_birth, cstm_phone, cstm_gender, "
				+ " cstm_rank, cstm_point, cstm_last_login, cstm_agree, createdate, updatedate) "
				+ " VALUES(?, ?, ?, ?, ?, ?, ?, 동, 100, NOW(), NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId());
		stmt.setString(2, customer.getCstmName());
		stmt.setString(3, customer.getCstmAddress());
		stmt.setString(4, customer.getCstmEmail());
		stmt.setString(5, customer.getCstmBirth());
		stmt.setString(6, customer.getCstmPhone());
		stmt.setString(7, customer.getCstmGender());
		
		int addCustomer = stmt.executeUpdate();
		
		return addCustomer;
	}
	
	// 1-2) 회원가입 - 중복검사
	public boolean customerLoginChk(Customer customer) throws Exception {
		boolean customerLoginChk = false;
		
		
		
		
		return customerLoginChk;
	}
	
	// 2) 로그인
	public Customer customerLogin(Customer customer) throws Exception {
		Customer loginCustomer = null;
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "SELECT * "
				+ "FROM customer INNER JOIN id_list ON customer.id = id_list.id"
				+ "WHERE id = ? AND id_list.last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId());
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			loginCustomer = new Customer();
			loginCustomer.setId(rs.getString("id"));
			loginCustomer.setCstmName(rs.getString("cstm_name"));
			loginCustomer.setCstmAddress(rs.getString("cstm_address"));
			loginCustomer.setCstmEmail(rs.getString("cstm_email"));
			loginCustomer.setCstmBirth(rs.getString("cstm_birth"));
			loginCustomer.setCstmPhone(rs.getString("cstm_phone"));
			loginCustomer.setCstmGender(rs.getString("cstm_gender"));
			loginCustomer.setCstmRank(rs.getString("cstm_rank"));
			loginCustomer.setCstmPoint(rs.getInt("cstm_point"));
			loginCustomer.setCstmLastLogin(rs.getString("cstm_last_login"));
			loginCustomer.setCstmAgree(rs.getString("cstm_agree"));
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
