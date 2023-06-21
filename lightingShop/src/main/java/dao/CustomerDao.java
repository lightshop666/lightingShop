package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import util.DBUtil;
import vo.Address;
import vo.Cart;
import vo.Customer;
import vo.IdList;
import vo.PwHistory;

public class CustomerDao {
	
	// -------------------a.customer 관련---------------------

	// 1-1) 회원가입 시 아이디 중복여부 확인
	public boolean customerSigninIdCk(Customer customer) throws Exception {
		boolean customerAddCheckId = false;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		// id_list에서 탈퇴한 id의 id 중복체크
		String sql = "SELECT id FROM id_list WHERE id=? AND active= 'N'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId()); // 사용자로부터 입력받은 id로 조건 검색
		
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) { // 중복 아이디가 있는 경우
			customerAddCheckId = true;
		} 
		return customerAddCheckId;
	}
	
	// 1-2) 회원가입 - id_list -> 회원가입시 id_list, customer, address 3곳에 데이터 추가
	public int addIdList(IdList idList) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String addIdListSql = "INSERT INTO id_list(id, last_pw, active, createdate) VALUES(?, PASSWORD(?), ?, NOW())";
		PreparedStatement addIdListStmt = conn.prepareStatement(addIdListSql);
		// id_list 테이블에 새로운 ID 값 추가
		addIdListStmt.setString(1, idList.getId());
		addIdListStmt.setString(2, idList.getLastPw());
		addIdListStmt.setString(3, idList.getActive());
		
		int addIdList  = addIdListStmt.executeUpdate();
		return addIdList;
		
	}
	// 1-3) 회원가입 - customer
	public int addCustomer(Customer customer) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		// customer 테이블에 새로운 입력값 추가
	 	String addCustomerSql = "INSERT INTO customer(id, cstm_name, cstm_address, cstm_email, cstm_birth, cstm_phone, cstm_gender, "
				+ " cstm_rank, cstm_point, cstm_last_login, cstm_agree, createdate, updatedate) "
				+ " VALUES(?, ?, ?, ?, ?, ?, ?, ?, 100, NOW(), ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(addCustomerSql);
		stmt.setString(1, customer.getId());
		stmt.setString(2, customer.getCstmName());
		stmt.setString(3, customer.getCstmAddress());
		stmt.setString(4, customer.getCstmEmail());
		stmt.setString(5, customer.getCstmBirth());
		stmt.setString(6, customer.getCstmPhone());
		stmt.setString(7, customer.getCstmGender());
		stmt.setString(8, customer.getCstmRank());
		stmt.setString(9, customer.getCstmAgree());
		
		int addCustomer = stmt.executeUpdate();
		
		return addCustomer;
	}
	
	// 1-4) 회원가입 - address
	public int addAddress(Address address) throws Exception {
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		// customer 테이블에 새로운 입력값 추가
	 	String addCustomerSql = "INSERT INTO address(id, address_name, address, address_last_date, default_address,"
				+ " createdate, updatedate) "
				+ " VALUES(?, ?, ?, NOW(), 'Y', NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(addCustomerSql);
		stmt.setString(1, address.getId());
		stmt.setString(2, address.getAddressName() );
		stmt.setString(3, address.getAddress() );
		
		int addAddress = stmt.executeUpdate();
		
		return addAddress;
	}
	
	// 2) 로그인 - active여부는 loginAction에서 수행
	public HashMap<String, Object> loginMethod(IdList idList) throws Exception {
		// 반환 객체 생성
		HashMap<String, Object> loginIdList = new HashMap<>();
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		/*
			SELECT i.id, i.last_pw, i.active, e.emp_level
			FROM id_list i LEFT OUTER JOIN	employees e 
			ON i.id = e.id
			WHERE i.id = 'admin' AND i.last_pw = PASSWORD(1234)";
		*/
		
		String sql = "SELECT i.id id, i.last_pw lastPw, i.active active, e.emp_level empLevel FROM id_list i "
				+ " LEFT OUTER JOIN employees e ON i.id = e.id"
				+ " WHERE i.id = ? AND i.last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getId());
		stmt.setString(2, idList.getLastPw());
		
		ResultSet rs = stmt.executeQuery();
		
		// DB 내용 저장
		if(rs.next()) {
			loginIdList.put("id", rs.getString("id"));
			loginIdList.put("lastPw", rs.getString("lastPw")); 
			loginIdList.put("active" , rs.getString("active")); // 가입탈퇴여부 반환
			loginIdList.put("empLevel", rs.getString("empLevel")); // 레벨 권한 
		}
		
		return loginIdList;
	}
	
	// 2-1) 로그인 - customer(last_login) update
	public int lastLoginUpdate(IdList idList) throws Exception {
		int modifyLastLogin = 0;
		
		// 현재 시간 정보 생성 (java.util.Date 클래스 사용)
		Date now = new Date();
		Timestamp timestamp = new Timestamp(now.getTime());

		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "UPDATE customer SET cstm_last_login = ? WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setTimestamp(1, timestamp);
		stmt.setString(2, idList.getId());
		modifyLastLogin = stmt.executeUpdate();
		
		return modifyLastLogin;
	}
	
	// 3-1) 회원정보 수정 - id_list(id 수정불가)
	public int modifyIdListOne(IdList idList, IdList modifyIdList) throws Exception {
		int modifyIdListOne = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "UPDATE id_list SET last_pw = ? WHERE id = ? AND last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, modifyIdList.getLastPw());
		stmt.setString(2, idList.getId());
		stmt.setString(3, idList.getLastPw() );
		modifyIdListOne = stmt.executeUpdate();
		
		return modifyIdListOne;
	}
	
	// 3-2) 회원정보 수정 - customer(cstm_address는 수정못하도록함 - 배송지리스트 페이지에서 수정)
	public int modifyCustomerOne(Customer customer, Customer modifyCustomer) throws Exception {
		int modifyCustomerOne = 0;
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		String sql = "UPDATE customer SET cstm_name = ?, cstm_address = ?, cstm_email = ?, cstm_birth = ?, cstm_phone = ?,"
				+ " cstm_gender = ?, updatedate =  NOW() WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, modifyCustomer.getCstmName());
		stmt.setString(2, modifyCustomer.getCstmAddress());
		stmt.setString(3, modifyCustomer.getCstmEmail());
		stmt.setString(4, modifyCustomer.getCstmBirth());
		stmt.setString(5, modifyCustomer.getCstmPhone());
		stmt.setString(6, modifyCustomer.getCstmGender());
		stmt.setString(7, customer.getId());
		modifyCustomerOne = stmt.executeUpdate();
		
		return modifyCustomerOne;
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
	public boolean passwordCheck(IdList idList) throws Exception {
		
		// 반환 객체 생성
		boolean pwCk = false;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT id, last_pw FROM id_list WHERE last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getLastPw());
		// SQL 명령 실행
		ResultSet rs = stmt.executeQuery();
		
		// 데이터베이스 내용 불러오기
		if(rs.next()) {
			pwCk = true;
		}
		return pwCk;
	}
	
	// 5) CustomerOne - ( + 배송지, 기본배송지)
	public HashMap<String, Object> selectCustomerOne(Customer customer) throws Exception {
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		// SQL 명령, 명령 준비
		String sql = ("SELECT c.id, c.cstm_name, c.cstm_address, c.cstm_email, c.cstm_birth, c.cstm_phone, c.cstm_gender, c.cstm_rank, "
				+ " c.cstm_point, c.cstm_last_login, c.cstm_agree, c.createdate, a.address_name, a.default_address"
				+ " FROM customer c INNER JOIN address a "
				+ " ON c.id = a.id "
				+ " WHERE c.id = ?");
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId()); 	// Customer Id를 입력받는다.
		
		ResultSet rs = stmt.executeQuery();
		
		HashMap<String, Object> customerOne = new HashMap<>();
		if (rs.next()) {
			customerOne.put("c.id", rs.getString("c.id"));
			customerOne.put("c.cstm_name", rs.getString("c.cstm_name"));
			customerOne.put("c.cstm_address", rs.getString("c.cstm_address"));
			customerOne.put("c.cstm_email", rs.getString("c.cstm_email")); 
			customerOne.put("c.cstm_birth", rs.getString("c.cstm_birth"));
			customerOne.put("c.cstm_phone", rs.getString("c.cstm_phone"));
			customerOne.put("c.cstm_gender", rs.getString("c.cstm_gender"));
			customerOne.put("c.cstm_rank", rs.getString("c.cstm_rank")); 
			customerOne.put("c.cstm_point", rs.getInt("c.cstm_point")); 
			customerOne.put("c.cstm_last_login", rs.getString("c.cstm_last_login")); 
			customerOne.put("c.cstm_agree", rs.getString("c.cstm_agree")); 
			customerOne.put("c.createdate", rs.getString("c.createdate")); 
			customerOne.put("a.address_name", rs.getString("a.address_name"));
			customerOne.put("a.default_address", rs.getString("a.default_address"));
		}
		return customerOne;
	}
	
	// 5-1) CustomerOne 포인트 내역 출력
	public int selectPointCustomer(String id) throws Exception {
		
		int point = 0;
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		// SQL 명령, 명령 준비
		String sql = "SELECT cstm_point FROM customer WHERE id= ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id); 	// Customer Id를 입력받는다.
		
		ResultSet rs = stmt.executeQuery();
		
		if (rs.next()) {
			point = rs.getInt("cstm_point");
		}
		return point;
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
	
	// -------------------b.address 관련---------------------
	// 1) 회원주소목록 (내주소)
	public ArrayList<Address> myAddressList(Address address) throws Exception {
		ArrayList<Address> list = new ArrayList<Address>();
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		// 주소 불러오기
		String sql = "SELECT address_no, id, address_name, address, default_address FROM address WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getId());
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Address a = new Address();
			a.setAddressNo(rs.getInt("address_no"));
			a.setId(rs.getString("id"));
			a.setAddressName(rs.getString("address_name"));
			a.setAddress(rs.getString("address"));
			a.setDefaultAddress(rs.getString("default_address"));
			list.add(a);
		}
		
		return list;
	}
	
	// 1-1) 개별 주소 불러오기
	public Address myAddress(int addressNo) throws Exception {
		Address myAddress = new Address();
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT address_no, address_name, address, default_address, updatedate FROM address WHERE address_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, addressNo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			myAddress.setAddressNo(rs.getInt("address_no"));
			myAddress.setAddressName(rs.getString("address_name"));
			myAddress.setAddress(rs.getString("address"));
			myAddress.setDefaultAddress(rs.getString("default_address"));
		}
		return myAddress;
	}
		
	// 2) 주소추가 - 배송지 추가시, 위에 회원가입시 추가되는 메서드 있음.
	public int addMyAddress(Address address) throws Exception {
		int addMyAddress = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "INSERT INTO address("
				+ " id, address, address_name, address_last_date, default_address, createdate, updatedate)"
				+ " VALUES(?, ?, ?, NOW(), ?, NOW(), NOW())"; 
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getId());
		stmt.setString(2, address.getAddress());
		stmt.setString(3, address.getAddressName());
		stmt.setString(4, address.getDefaultAddress());
		
		addMyAddress = stmt.executeUpdate();
		
		return addMyAddress;
	}
	
	// 3) 주소변경 - 배송지명, 주소, 기본배송지 여부, 변경일
	public int modifyAddress(Address address) throws Exception {
		int modifyAddress = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "UPDATE address SET address_name = ?, address = ?, default_address = ?, updatedate = NOW() WHERE address_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getAddressName() );
		stmt.setString(2, address.getAddress());
		stmt.setString(3, address.getDefaultAddress() );
		stmt.setInt(4, address.getAddressNo() );
		
		modifyAddress = stmt.executeUpdate();
		
		return modifyAddress;
	}
	
	// 4) 주소삭제 - 개별삭제
	public int removeAddress(int addressNo) throws Exception {
		int removeAddress = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "DELETE FROM address WHERE address_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, addressNo);
		
		removeAddress = stmt.executeUpdate();
				
		return removeAddress;
	}
	
	// 4-1) 주소삭제 (id의 주소 전부삭제(== 회원탈퇴시 Address 삭제) -> 메소드만 구현)
	public void removeAllAddress(Address address) throws Exception {
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "DELETE FROM address WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getId());
		stmt.executeUpdate();
	}
	
	// 4-2) 주소삭제 (배송지 추가시 4개 이상일 경우 id와 생성일 기준으로 1개 삭제)
	public int removeOldAddress(Address address) throws Exception {
		int removeOldAddress = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "DELETE FROM address WHERE id = ? AND createdate = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getId());
		stmt.setString(2, address.getCreatedate());
		
		System.out.println("address.getId() : "+address.getId());
		System.out.println("address.getCreatedate() : "+address.getCreatedate());
		
		removeOldAddress = stmt.executeUpdate();
				
		return removeOldAddress;
	}
	
	// 5) 주소 총개수 - (최대 4개로 제한 - operateAddress 메서드에서 이용)
	public int ttlCntAddress(Address address) throws Exception {
		int ttlCntAddress = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM address WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getId());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			ttlCntAddress = rs.getInt("COUNT(*)");
		}
		return ttlCntAddress;
	}
	
	// 6) 배송지 추가시 address에 배송지 추가 및 최대 4개 넘을 시, 가장 오래된 배송지 자동삭제
	public int operateAddress(Address address) throws Exception {
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		// 배송지 이력 추가 유무를 확인하기 위한 변수 선언
		int operateAddress = 0;
		// 모델 생성
		CustomerDao cDao = new CustomerDao();
		// address 개수를 저장할 변수선언
		int cntAddress = 0;
		// 4개가 넘어갔을시 address를 삭제할 변수 선언
		int removeOldAddress = 0;
		// 가장 오래된 배송지를 불어올 객체 생성
		Address selectOldestAddress = new Address();
		System.out.println("[operateAddress]");
		
		// 주소지 총 개수
		cntAddress = cDao.ttlCntAddress(address);
		
		if(cntAddress < 4) { // 3개 이하일 경우, 배송지추가 진행
			System.out.println("배송지내역 4개 미만");
			operateAddress = addMyAddress(address);
		} else { // 4개 이상일 경우, 가장 오래된 주소지내역 삭제 후, 배송지추가 진행
			System.out.println("배송지내역 4개 이상");
			// 삭제할 가장오래된 배송지내역 하나 불러오기
			selectOldestAddress = cDao.selectOldestAddress(address);
			System.out.println("삭제할 배송지의 아이디명 :" + selectOldestAddress.getId());
			System.out.println("삭제할 배송지명 :" + selectOldestAddress.getAddressName());
			
			//가장 오래된 배송지 삭제
			removeOldAddress = cDao.removeOldAddress(selectOldestAddress);
			
			if(removeOldAddress == 1) { // old 배송지가 삭제된 경우 - 변경된 배송지 추가
				System.out.println("old 배송지내역 삭제 성공");
				// 배송지 추가
				operateAddress = cDao.addMyAddress(address);
			} else { // 삭제되지 않은경우
				System.out.println("old 배송지내역 삭제 실패");
			}
		}
		
		// 로직 진행 후 배송지내역 총개수
		cntAddress = cDao.ttlCntAddress(address);
		System.out.println("배송지내역 총 개수:" + cntAddress);
		
		// 배송지 추가가 됬다면 1반환
		return operateAddress;
	}
	
	// 7) 가장 오래된 address 1개 조회(createdate ASC순) - id와 createdate를 넣기위해 객체반환타입을 갖는다.
	public Address selectOldestAddress(Address address) throws Exception {
		// 객체 초기화
		Address selectOldestAddress = null;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT id, address_name, createdate FROM address WHERE id = ? ORDER BY createdate LIMIT 0,1";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		stmt.setString(1, address.getId());
		ResultSet rs = stmt.executeQuery();
		// 조회된 결과가 있다면 객체에 DB값 저장
		if(rs.next()) {
			selectOldestAddress = new Address();
			selectOldestAddress.setId(rs.getString("id"));
			selectOldestAddress.setAddressName(rs.getString("address_name"));
			selectOldestAddress.setCreatedate(rs.getString("createdate"));
		}
		
		return selectOldestAddress;
		
	}
	
	// 8) 배송지 추가 or 수정 시, 기본 배송지가 중복되지 않게 체크
	public boolean selectDefalutAddress(Address address) throws Exception {
		// 체크할 변수 선언
		boolean checkAddress = false;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		// id에 해당하는 기본배송지 정보 조회
		String sql = "SELECT default_address FROM Address WHERE id = ? AND default_address= 'Y'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getId());
		System.out.println("[Address중복체크dao]");
		System.out.println("id :"+address.getId());
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			checkAddress = true;
		}
		// 중복된 값이 있다면 - true 반환
		return checkAddress;
	}
	
	// -------------------c.pwHistory 관련---------------------
	// 1) pwHistory 이력 추가
	public int addPwHistory(PwHistory pwHistory) throws Exception {
		int addPwHistory = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "INSERT INTO pw_history(id, pw, createdate)"
					+ " VALUES(?, PASSWORD(?), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getId());
		stmt.setString(2, pwHistory.getPw());
		addPwHistory = stmt.executeUpdate();
		
		return addPwHistory;
	}
	
	// 2) (회원가입시 or 비밀번호 수정시) pwHistory에 비밀번호 추가 및 최대 4개 넘을 시, 가장 오래된 pw 자동삭제
	public int operatePwHistory(PwHistory pwHistory) throws Exception {
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		int operatePwHistory = 0;
		CustomerDao cDao = new CustomerDao();
		int cntPwHistory = 0;
		int removePwHistory = 0;
		PwHistory selectOldestPw = new PwHistory();
		System.out.println("[operatePwHistory]");
		
		// 비밀번호 총 개수
		cntPwHistory = cDao.ttlCntPwHistory(pwHistory);
		
		if(cntPwHistory < 4) { // 3개 이하일 경우, 이력추가 진행
			System.out.println("비밀번호내역 4개미만");
			operatePwHistory = cDao.addPwHistory(pwHistory);
		} else { // 4개 이상일 경우, 가장오래된 비밀번호내역 삭제 후, 이력추가 진행
			System.out.println("비밀번호내역 4개이상");
			// 삭제할 가장오래된 비밀번호내역 하나 불러오기
			selectOldestPw = cDao.selectOldestPw(pwHistory);
			System.out.println("삭제할 pw :" + selectOldestPw.getPw());
			System.out.println("삭제할 id : "+selectOldestPw.getId());
			
			// 오래된 비밀번호내역 삭제
			removePwHistory = cDao.removePwHistory(selectOldestPw);
			
			if(removePwHistory == 1) {
				System.out.println("old 비밀번호내역 삭제 성공");
				// 수정된 비밀번호 추가
				operatePwHistory = cDao.addPwHistory(pwHistory);
			} else {
				System.out.println("old 비밀번호내역 삭제 실패");
			}
		}
		// 로직 후 비밀번호 총개수
		cntPwHistory = cDao.ttlCntPwHistory(pwHistory);
		System.out.println("비밀번호내역 총 갯수 : "+ cntPwHistory);
		
		// 비밀번호 이력추가가 됬다면 1 반환 
		return operatePwHistory;
	}
	
	// 3) 비밀번호 데이터 총 개수(최대 4개로 제한)
	public int ttlCntPwHistory(PwHistory pwHistory) throws Exception {
		int ttlCntPwHistory = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM pw_history WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getId());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			ttlCntPwHistory = rs.getInt("COUNT(*)");
		}
		return ttlCntPwHistory;
	}
	
	// 4) 비밀번호 이력 삭제
	public int removePwHistory(PwHistory pwHistory) throws Exception {
		int removePwHistory = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "DELETE from pw_history WHERE id = ? AND createdate = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getId());
		stmt.setString(2, pwHistory.getCreatedate());
		System.out.println("pwHistory.getId() : "+pwHistory.getId());
		System.out.println("pwHistory.getCreatedate() : "+pwHistory.getCreatedate());
		
		removePwHistory = stmt.executeUpdate();
		
		return removePwHistory;
	}
	
	// 5) 가장오래된 pwHistory 1개 select (생성날짜 오름차순)
	public PwHistory selectOldestPw(PwHistory pwHistory) throws Exception {
		PwHistory selectOldestPw = null;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT id, createdate FROM pw_history"
					+ " WHERE id = ?"
					+ " ORDER BY createdate"
					+ " LIMIT 0,1";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		stmt.setString(1, pwHistory.getId());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			selectOldestPw = new PwHistory();
			selectOldestPw.setId(rs.getString("id"));
			selectOldestPw.setCreatedate(rs.getString("createdate"));
		}
		
		return selectOldestPw;
	}
	
	// 6) 회원탈퇴시 pwHistory 삭제 -> 메서드만 구현한 상태
	public int removePwHistoryByRemoveCustomer(Customer customer) throws Exception {
		int removePwHistory = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "DELETE FROM pw_history WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customer.getId());
		removePwHistory = stmt.executeUpdate();
		
		return removePwHistory;
	}
	
	// 7) 비밀번호 수정 시, 중복체크를 위한 select
	public boolean selectPwHistoryCk(Customer modifyCustomer, IdList modyfyIdList) throws Exception {
		boolean checkPw = false;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT * FROM pw_history WHERE id = ? AND pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, modifyCustomer.getId());
		stmt.setString(2, modyfyIdList.getLastPw());
		System.out.println("[pwHistory중복체크dao]");
		System.out.println("id :"+modifyCustomer.getId());
		System.out.println("ldList_pw : "+modyfyIdList.getLastPw());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			checkPw = true;
		}
		return checkPw;
	}
	
	//--------------------------d.cart 관련--------------------------------------
	
	// 1) cart 추가
	public int addCart(Cart cart) throws Exception {
		int row = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "INSERT INTO cart("
				+ " product_no"
				+ ", id"
				+ ", cart_cnt"
				+ ", createdate"
				+ ") VALUES (?, ?, ?, NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
		stmt.setInt(1, cart.getProductNo() );
		stmt.setString(2, cart.getId() );
		stmt.setInt(3, cart.getCartCnt() );
		row = stmt.executeUpdate();
		return row;
	}
	
	// 1-1) cart 중복체크
	public boolean cartListCk(Cart cart) throws Exception {
		boolean cartListCk = false;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT product_no"
					+ " FROM cart"
					+ " WHERE product_no = ? AND id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, cart.getCartNo() );
		stmt.setString(2, cart.getId() );
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) { // 중복 장바구니상품일경우, true반환
			cartListCk = true;
		}
		
		return cartListCk;
	}
	
	// 1-2) cartOne (1개의 물품 수량정보)
	public int cartOneQty(Cart cart) throws Exception {
		int cartOneQty = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT cart_cnt FROM cart"
					+ " WHERE product_no = ? AND id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1,  cart.getCartNo());
		stmt.setString(2, cart.getId());
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			cartOneQty = rs.getInt("cart_cnt");
		}
		
		return cartOneQty;
	}
	
	// 1-3) cart update
	public int modifyCart(int cartCnt, int productNo, String id) throws Exception {
		int row = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "UPDATE cart SET cart_cnt = ? WHERE product_no = ? AND id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, cartCnt);
		stmt.setInt(2, productNo);
		stmt.setString(3, id);
		row = stmt.executeUpdate();
		return row;
	}
	
	// 1-4) id별 cart 수량체크
	public int ttlCntCart(String id) throws Exception {
		int ttlCntCart = 0;
		
		DBUtil dbutil = new DBUtil();
		Connection conn = dbutil.getConnection();
		
		String sql = "SELECT COUNT(*) from cart WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			ttlCntCart = rs.getInt("COUNT(*)");
		}
		
		return ttlCntCart;
	}
}
