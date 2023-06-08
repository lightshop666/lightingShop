package dao;
import util.DBUtil;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.io.*;
import vo.*;
import com.oreilly.servlet.*;
import com.oreilly.servlet.multipart.*; 

public class EmpDao {
	//----------a.상품관리--------------------------
	//1) 상품관리페이지 상품 목록 메소드
	public ArrayList<Product> selectProductListByPage(String col, String ascDesc, int beginRow, int rowPerPage, String searchCol, String searchWord, String category) throws Exception {
	    ArrayList<Product> productList = new ArrayList<>();
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    // 검색 및 정렬 조건에 따른 쿼리문 분기
	    String productSql = "SELECT product_no, category_name, product_name, product_price, product_status, product_stock, product_info, createdate, updatedate FROM product ";

	    if (!category.equals("All")) {
	        productSql += "WHERE category_name = ?"; // 카테고리 선택 조건이 "All"이 아닌 경우 WHERE 절 추가

	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productSql += " AND " + searchCol + " LIKE ?"; // 검색어와 검색 컬럼이 모두 존재하는 경우 추가적인 조건문으로 AND 연산자 사용
	        }
	    } else {
	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productSql += " WHERE " + searchCol + " LIKE ?"; // 검색어와 검색 컬럼이 모두 존재하는 경우 WHERE 절 추가
	        }
	    }

	    if (!col.equals("") && !ascDesc.equals("")) {
	        productSql += " ORDER BY " + col + " " + ascDesc; // 정렬 조건이 존재하는 경우 ORDER BY 절 추가
	    }

	    productSql += " LIMIT ?, ?"; // 페이징 처리를 위한 LIMIT 절

	    PreparedStatement productStmt = conn.prepareStatement(productSql);

	    int parameterIndex = 1; // 파라미터 인덱스 값 지정하기(분기문에따라 +해서 대입예정)

	    if (!category.equals("All")) {
	        productStmt.setString(parameterIndex, category);
	        parameterIndex++;

	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
	            parameterIndex++;
	        }
	    } else {
	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
	            parameterIndex++;
	        }
	    }

	    productStmt.setInt(parameterIndex, beginRow); // LIMIT의 첫 번째 매개변수
	    productStmt.setInt(parameterIndex + 1, rowPerPage); // LIMIT의 두 번째 매개변수
	    
	    // ResultSet
	    ResultSet productRs = productStmt.executeQuery();
	    
	    while (productRs.next()) {
	        Product p = new Product();
	        p.setProductNo(productRs.getInt("product_no"));
	        p.setCategoryName(productRs.getString("category_name"));
	        p.setProductName(productRs.getString("product_name"));    
	        p.setProductStatus(productRs.getString("product_status"));
	        p.setCreatedate(productRs.getString("createdate"));
	        p.setUpdatedate(productRs.getString("updatedate"));        
	        productList.add(p);
	    }
	    
	    return productList;
	}
	

	
	//2) 상품관리 상품상세 페이지 상품One 메소드
	public HashMap<String, Object> selectProductOne(int productNo) throws Exception {
		
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection(); 
		// PreparedStatement
		String productOneSql = "SELECT pi.product_ori_filename, pi.product_save_filename, pi.product_filetype, p.product_no, p.category_name, p.product_name, p.product_price, p.product_status, p.product_stock, p.product_info, p.createdate, p.updatedate from product p  Left JOIN product_img pi On p.product_no = pi.product_no where p.product_no=?";

		PreparedStatement productOneStmt = conn.prepareStatement(productOneSql); 
		productOneStmt.setInt(1,productNo); 	
		
		// ResultSet
		ResultSet productOneRs = productOneStmt.executeQuery();
		
		HashMap<String, Object> product = null;
		if(productOneRs.next()) {
			product = new HashMap<>();
			product.put("productNo",productOneRs.getInt("product_no"));
			product.put("categoryName",productOneRs.getString("category_name"));
			product.put("productName",productOneRs.getString("product_name"));
			product.put("productPrice",productOneRs.getDouble("product_price"));
			product.put("productStatus",productOneRs.getString("product_status"));
			product.put("productStock",productOneRs.getString("product_stock"));	
			product.put("productInfo",productOneRs.getString("product_info"));
			product.put("createdate",productOneRs.getString("createdate"));
			product.put("updatedate",productOneRs.getString("updatedate"));		
			product.put("originFilename",productOneRs.getString("product_ori_filename"));
			
		}
		
		return product;
	}
	
	//2) 상품관리 상품추가 메소드
	
	public int insertProduct(Product product) throws Exception {
		int insertProductRow = 0;
		//유효성 여부
		if(product!=null) {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//insert 쿼리
		String insertProductSql = "Insert INTO product(category_name, product_name, product_price, product_status,product_stock, product_info, createdate, updatedate Values(?,?,?,?,?,?,now(),now())";
		PreparedStatement insertProductStmt = conn.prepareStatement(insertProductSql);
		insertProductStmt.setString(1,product.getCategoryName()); 	
		insertProductStmt.setString(2,product.getProductName()); 	
		insertProductStmt.setDouble(3,product.getProductPrice()); 	
		insertProductStmt.setString(4,product.getProductStatus()); 	
		insertProductStmt.setInt(5,product.getProductStock()); 
		insertProductStmt.setString(6,product.getProductInfo()); 	
		
		insertProductRow = insertProductStmt.executeUpdate();
		}
		return insertProductRow;
	}
	
	//3) 상품관리  상품이미치추가(product_img)메소드

	public int insertProductImg(HashMap<Object,String> productImg, int productNo) throws Exception {
		
		
		//업로드 파일이 PDF파일이 아니면
		 if(productImg.get("productFileType").equals("image/jpeg")==false){
			 //이미 upload폴더에 저장된 파일을 삭제
			 System.out.println("image/jpeg파일이 아닙니다");
			 String saveFilename = (String)productImg.get("productSaveFilename"); //저장된 파일네임 가져오기
			 File f = new File(productImg.get("dir")+"/"+saveFilename); //파일 객체 f 를 가져온 파일명으로 지정 / = new File("d:/abc/uploadsign.파일명")
			 //역슬러쉬가 window 기본 포맷
			 if(f.exists()){
				 f.delete();
				 System.out.println(saveFilename+"파일삭제");
			 }
			 return 0;
		 }
		
		int insertProductImgRow = 0;
		
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection(); 
		//delete 쿼리
		
		if(productImg!=null) {
		
		
		String productImgSql = "INSERT INTO produc_img(product_no, product_ori_filename, product_save_filename, product_filetype, createdate) VALUES(?, ?, ?, ?, NOW())";
		PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
		productImgStmt.setInt(1,productNo);
		productImgStmt.setString(2, productImg.get("productOriFilename"));
		productImgStmt.setString(3, productImg.get("productSaveFilename"));
		productImgStmt.setString(4, productImg.get("productFiletype"));
		productImgStmt.executeUpdate(); // board_file 입력	
		
			if(insertProductImgRow==1) {
				System.out.println("추가성공");
			}else{
				insertProductImgRow=0;
				System.out.println("추가실패");
			}
		}	
		
		return insertProductImgRow;
		
	}
	
	
	//4) 상품상세 수정
	public int updateProduct(HashMap<String, Object> product) throws Exception {
		int updateProductRow=0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection(); 
	
			//4-1)Update 상품정보 쿼리
			String updateProductSql = "UPDATE product SET category_name =?, product_name=?, product_price=?, product_status=?, product_stock=?, product_info=?, updatedate=now() Where product_no=?";
			PreparedStatement updateProductStmt = conn.prepareStatement(updateProductSql); 
			updateProductStmt.setString(1,(String)product.get("categoryName")); 	
			updateProductStmt.setString(2,(String)product.get("productName")); 
			updateProductStmt.setDouble(3,(Double)product.get("productPrice")); 
			updateProductStmt.setString(4,(String)product.get("productStatus")); 
			updateProductStmt.setInt(5,(Integer)product.get("productStock")); 
			updateProductStmt.setString(6,(String)product.get("productInfo")); 
			updateProductStmt.setInt(7,(Integer)product.get("productNo")); 
			// Row 
			updateProductRow = updateProductStmt.executeUpdate();
			if(updateProductRow==1) {
				System.out.println("수정성공");
			}else{
				updateProductRow=0;
				System.out.println("수정실패");
			}
			//파일 정보값 가져오기 
			String contentType = (String)product.get("contentType");
			String saveFilename = (String)product.get("saveFilename");
			String dir = (String)product.get("dir");
			
		//4-2)Update 상품이미지 쿼리 및 실제 파일삭제
		//업로드 파일이 이미지 파일 여부 확인
			if((String)product.get("originalFileName")!= null){
				String originFilename =(String)product.get("originalFileName");
				if(contentType.equals("image/jpeg")==false){
					System.out.println("이미지파일이 아닙니다");
					 File f = new File(dir+"/"+saveFilename); //파일 객체 f 를 가져온 파일명으로 지정 / = new File("d:/abc/uploadsign.파일명")
					 if(f.exists()){
						 f.delete();
						 System.out.println(saveFilename+"새파일삭제");
						 }
					}else{
						//이미지파일인지 먼저 확인후 맞다면 이전파일 삭제, db수정(update)
						
						
						//4-2-2) 이전파일 삭제 
						String saveFilenameSql = "Select product_save_filename from product_img WHERE product_no =?";
						PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
						saveFilenameStmt.setInt(1,(Integer)product.get("productNo"));
						
						ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
						
						String preSaveFilename = "";
					
						if(saveFilenameRs.next()){
							preSaveFilename = saveFilenameRs.getString("product_save_filename");
			
						}
						File f = new File(dir+"/"+preSaveFilename);
						if(f.exists()){
							f.delete();
							System.out.println(preSaveFilename+"이전파일삭제");
						}
						//4-2-3)수정된 파일의 정보로 db를 수정
						String productImgSql = "UPDATE product_img SET product_ori_filename=?, product_save_filename=?, product_filetype=?,updatedate=NOw() WHERE product_no=?";
						PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
						productImgStmt.setString(1,originFilename);
						productImgStmt.setString(2,saveFilename);
						productImgStmt.setString(3,contentType);
						productImgStmt.setInt(4,(Integer)product.get("productNo"));
					
						System.out.println(productImgStmt+"boardFileStmt");
						updateProductRow = productImgStmt.executeUpdate();
					}
				}
				return updateProductRow;
				
			}
	
	//5) 상품 전체 row 구하는 매소드
	public int selectProductCnt(String searchCol, String searchWord, String category) throws Exception {
	    int totalRow = 0;
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	
	    // 쿼리문 조건에 따른 분기
	    String productCntSql = "SELECT COUNT(*) FROM product ";
	
	    // 카테고리 선택 조건에 따라 WHERE 절 추가
	    if (!category.equals("All")) {
	        productCntSql += "WHERE category_name = ?";
	        
	        // 검색 조건이 존재하는 경우 AND 연산자를 사용하여 추가 조건문 생성
	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productCntSql += " AND " + searchCol + " LIKE ?";
	        }
	    } else {
	        // 검색 조건이 존재하는 경우 WHERE 절 추가
	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productCntSql += " WHERE " + searchCol + " LIKE ?";
	        }
	    }
	
	    PreparedStatement productCntStmt = conn.prepareStatement(productCntSql);
	
	    int parameterIndex = 1;
	
	    if (!category.equals("All")) {
	        productCntStmt.setString(parameterIndex, category);
	        parameterIndex++;
	
	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productCntStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
	        }
	    } else {
	        if (!searchWord.equals("") && !searchCol.equals("")) {
	            productCntStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
	        }
	    }
	
	    // ResultSet
	    ResultSet productCntRs = productCntStmt.executeQuery();
	
	    if (productCntRs.next()) {
	        totalRow = productCntRs.getInt(1);
	    }
	
	    return totalRow;
	}		
	
	//----------b.회원관리--------------------------//
	////1) 회원목록
	public ArrayList< HashMap<String, Object>> selectCustomerListByPage(String col, String ascDesc,int beginRow, int rowPerPage,String searchCol, String searchWord) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement customerStmt = null; 			
			// PreparedStatement
		String customerSql = "SELECT c.id, c.cstm_name, c.cstm_last_login, c.createdate, il.active FROM customer c INNER JOIN id_list il ON c.id = il.id ";
			
		// 검색 및 정렬 조건에 따른 쿼리문 분기	
	
        if (!searchWord.equals("") && !searchCol.equals("")) {
        	if (!searchWord.equals("") && !searchCol.equals("")) {
        	    if (searchCol.equals("id")) {
        	        customerSql += " WHERE c.id LIKE ?"; //searchCol에 id가 저장되는 경우에는 WHERE 절에서 모호성 오류가 발생(조인문 사용으로인한)
        	    } else {
        	        customerSql += " WHERE " + searchCol + " LIKE ?";
        	    }
        	}
        }  //like 절에서 searchWord를 바로 가져오면 문자값이 아니므로(쿼리문에서는) ''를 붙여줘야해서 더 복잡 
        if (!col.equals("") && !ascDesc.equals("")) {
        	customerSql += " ORDER BY " + col + " " + ascDesc; // 정렬 조건이 존재하는 경우 ORDER BY 절 추가
        }

        customerSql += " LIMIT ?, ?";

		customerStmt = conn.prepareStatement(customerSql); 		
		 int parameterIndex = 1; // 파라미터 인덱스 값 지정하기(분기문에따라 +해서 대입예정)
  

		 if (!searchWord.equals("") && !searchCol.equals("")) {
			 customerStmt = conn.prepareStatement(customerSql); 
			 customerStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
		      parameterIndex++;
		 }

		 customerStmt.setInt(parameterIndex, beginRow); // LIMIT의 첫 번째 매개변수
		 customerStmt.setInt(parameterIndex + 1, rowPerPage); // LIMIT의 두 번째 매개변수
		
		 // ResultSet
		ResultSet customerRs = customerStmt.executeQuery();		
		ArrayList<HashMap<String, Object>> customerList = new ArrayList<HashMap<String, Object>>();
		while(customerRs.next()) {
			HashMap<String, Object> customer = new HashMap<String, Object>();
			customer = new HashMap<>();
			customer.put("id",customerRs.getString("id"));
			customer.put("cstmName",customerRs.getString("cstm_name"));
			customer.put("cstmLastLogin",customerRs.getString("cstm_last_login"));
			customer.put("active",customerRs.getString("active"));
			customer.put("createdate",customerRs.getString("createdate"));	
			customerList.add(customer);
		}				
		return customerList;
	}
	//2)회원 목록: 활성/비활성화 action 매소드
			public int activeCustomer(String active,String id) throws Exception {
				DBUtil dbUtil = new DBUtil();
				Connection conn = dbUtil.getConnection(); 
				
				int activeRow = 0;
				
				// PreparedStatement
				String activeSql = "Update id_list Set active=? where id= ?";
				PreparedStatement activeStmt = conn.prepareStatement(activeSql); 
				activeStmt.setString(1, active); 	
				activeStmt.setString(2, id); 	
				
				// row값 가져오기				
				activeRow = activeStmt.executeUpdate();
				if(activeRow==1) {
					System.out.println("비활성성공");
				}else{
					activeRow=0;
					System.out.println("비활성실패");
				}
				
				return activeRow;
			}
		

	//3)회원 하나 상세 매소드
		public Customer selectCustomerOne(String id) throws Exception {
			Customer customer = null;
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection(); 
			// PreparedStatement
			String customerOneSql = "SELECT id, cstm_name, cstm_address,cstm_email, cstm_birth,cstm_phone,cstm_gender, cstm_rank,cstm_point,cstm_last_login,cstm_agree, createdate,updatedate from customer where id= ?";
			PreparedStatement customerOneStmt = conn.prepareStatement(customerOneSql); 
			customerOneStmt.setString(1, id); 	
			
			// ResultSet
			ResultSet customerOneRs = customerOneStmt.executeQuery();
			
			if(customerOneRs.next()) {
				customer = new Customer();
				customer.setId(customerOneRs.getString("id"));
				customer.setCstmName(customerOneRs.getString("cstm_name"));
				customer.setCstmAddress(customerOneRs.getString("cstm_address"));
				customer.setCstmEmail(customerOneRs.getString("cstm_email"));
				customer.setCstmBirth(customerOneRs.getString("cstm_birth"));
				customer.setCstmPhone(customerOneRs.getString("cstm_phone"));
				customer.setCstmGender(customerOneRs.getString("cstm_gender"));
				customer.setCstmRank(customerOneRs.getString("cstm_rank"));
				customer.setCstmPoint(customerOneRs.getInt("cstm_point"));
				customer.setCstmLastLogin(customerOneRs.getString("cstm_last_login"));
				customer.setCstmAgree(customerOneRs.getString("cstm_agree"));
				customer.setCreatedate(customerOneRs.getString("createdate"));
				customer.setUpdatedate(customerOneRs.getString("updatedate"));
			}	
			return customer;
		}
	
	//4)회원 정보(레벨) 수정 action 매소드	
		
	public int updateCustomer(Customer customer) throws Exception {
		int updateCustomerRow=0;
		if(customer!=null) {
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection(); 
			//Update 쿼리
			String updateCustomerSql = "UPDATE customer SET cstm_point=?, cstm_rank= ?, updatedate=Now() Where id= ? ";
			PreparedStatement updateCustomerStmt = conn.prepareStatement(updateCustomerSql); 	
			updateCustomerStmt.setInt(1,customer.getCstmPoint());
			updateCustomerStmt.setString(2,customer.getCstmRank());
			updateCustomerStmt.setString(3,customer.getId());
			// Row 
			updateCustomerRow = updateCustomerStmt.executeUpdate();
			if(updateCustomerRow==1) {
				System.out.println("수정성공");
			}else{
				updateCustomerRow=0;
				System.out.println("수정실패");
			}
		}
		return updateCustomerRow;
			
	}	
	
	//5)회원 전체 row구하는 쿼리(검색조건에따라 분기)
	public int selectCustomerCnt(String searchCol, String searchWord) throws Exception {
	    int totalRow = 0;
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	
	    // 쿼리문 조건에 따른 분기
	    String productCntSql = "SELECT COUNT(*) FROM customer ";
	
	   //searchWord있으면 where절 추가
	    if (!searchWord.equals("") && !searchCol.equals("")) {
	            productCntSql += " WHERE " + searchCol + " LIKE ?";
	    }
	    
	
	    PreparedStatement productCntStmt = conn.prepareStatement(productCntSql);
	
	    int parameterIndex = 1;	
	    //조건문 이 있다면 parameterIndext값 넣어서 set
	    if (!searchWord.equals("") && !searchCol.equals("")) {
	         productCntStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
	    }
	   
	
	    // ResultSet
	    ResultSet productCntRs = productCntStmt.executeQuery();
	
	    if (productCntRs.next()) {
	        totalRow = productCntRs.getInt(1);
	    }
	
	    return totalRow;
	}
	
	
	//----------c.직원관리--------------------------//
	
	////1) 직원목록
	public ArrayList<HashMap<String, Object>> selectEmpListByPage(String col, String ascDesc,int beginRow, int rowPerPage,String searchCol, String searchWord) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement empStmt = null; 
		
		String empSql = "SELECT e.id,e.emp_level, e.emp_name, il.last_pw,e.emp_phone, e.createdate, e.updatedate, il.active FROM employees e INNER JOIN id_list il ON e.id = il.id ";
		
		if (!searchWord.equals("") && !searchCol.equals("")) {
			 if (searchCol.equals("id")) {
				 empSql += " WHERE e.id LIKE ?"; //searchCol에 id가 저장되는 경우에는 WHERE 절에서 모호성 오류가 발생(조인문 사용으로인한)
     	    } else {
     	    	empSql += " WHERE " + searchCol + " LIKE ?";
     	    }
        }  
		
		//like 절에서 searchWord를 바로 가져오면 문자값이 아니므로(쿼리문에서는) ''를 붙여줘야해서 더 복잡 
        if (!col.equals("") && !ascDesc.equals("")) {
        	empSql += " ORDER BY " + col + " " + ascDesc; // 정렬 조건이 존재하는 경우 ORDER BY 절 추가
        }

        empSql += " LIMIT ?, ?";

		empStmt = conn.prepareStatement(empSql); 		
		 int parameterIndex = 1; // 파라미터 인덱스 값 지정하기(분기문에따라 +해서 대입예정)
  

		 if (!searchWord.equals("") && !searchCol.equals("")) {
			 empStmt = conn.prepareStatement(empSql); 
			 empStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
		      parameterIndex++;
		 }

		 empStmt.setInt(parameterIndex, beginRow); // LIMIT의 첫 번째 매개변수
		 empStmt.setInt(parameterIndex + 1, rowPerPage); // LIMIT의 두 번째 매개변수
		
		// ResultSet
		ResultSet empRs = empStmt.executeQuery();
		
		HashMap<String, Object> employees = null;	
		
		ArrayList<HashMap<String, Object>> empList = new ArrayList<HashMap<String, Object>>();
		while(empRs.next()) {
			employees = new HashMap<>();
			employees.put("id",empRs.getString("id"));
			employees.put("empName",empRs.getString("emp_name"));
			employees.put("empLevel",empRs.getString("emp_level"));
			employees.put("empPhone",empRs.getString("emp_phone"));
			employees.put("lastPw",empRs.getString("last_pw"));
			employees.put("active",empRs.getString("active"));
			employees.put("createdate",empRs.getString("createdate"));	
			employees.put("updatedate",empRs.getString("updatedate"));	
			empList.add(employees);
		}				
		return empList;
	}
	//2)직원 목록: 비활성화 action 매소드
			public int activeEmp(String active,String id) throws Exception {
				DBUtil dbUtil = new DBUtil();
				Connection conn = dbUtil.getConnection(); 
				
				int activeRow = 0;
				
				// PreparedStatement
				String activeSql = "Update id_list Set active=?,updatedate=? where id= ?";
				PreparedStatement activeStmt = conn.prepareStatement(activeSql); 
				activeStmt.setString(1, active); 	
				activeStmt.setString(1, id); 	
				
				// row값 가져오기				
				activeRow = activeStmt.executeUpdate();
				if(activeRow==1) {
					System.out.println("비활성성공");
				}else{
					activeRow=0;
					System.out.println("비활성실패");
				}
				
				return activeRow;
			}
		
	//3)직원 하나 상세 매소드
		public Employees selectEmpOne(String id) throws Exception {
			Employees emp = null;
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection(); 
			// PreparedStatement
			String empOneSql = "SELECT id, emp_name, emp_level, emp_phone, createdate,updatedate from employees where id= ?";
			PreparedStatement empOneStmt = conn.prepareStatement(empOneSql); 
			empOneStmt.setString(1, id); 	
			
			// ResultSet
			ResultSet empOneRs = empOneStmt.executeQuery();
			
			if(empOneRs.next()) {
				emp = new Employees();
				emp.setId(empOneRs.getString("id"));
				emp.setEmpName(empOneRs.getString("emp_name"));
				emp.setEmpLevel(empOneRs.getString("emp_level"));
				emp.setEmpPhone(empOneRs.getString("emp_phone"));
				emp.setCreatedate(empOneRs.getString("createdate"));
				emp.setUpdatedate(empOneRs.getString("updatedate"));
			}	
			return emp;
		}
	
	//4)직원 정보 수정 action 매소드	
		
	public int updateEmp(Employees emp) throws Exception {
		int updateEmpRow=0;
		if(emp!=null) {
			DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection(); 
			//Update 쿼리
			String updateEmpSql = "UPDATE employees SET emp_name=?, emp_phone=?, emp_level=?, updatedate=NOW() Where id= ? ";
			PreparedStatement updateEmpStmt = conn.prepareStatement(updateEmpSql); 
			updateEmpStmt.setString(1,emp.getEmpName()); 	
			updateEmpStmt.setString(2,emp.getEmpPhone());
			updateEmpStmt.setString(3,emp.getEmpLevel());
			updateEmpStmt.setString(4,emp.getId());
			// Row 
			updateEmpRow = updateEmpStmt.executeUpdate();
			if(updateEmpRow==1) {
				System.out.println("수정성공");
			}else{
				updateEmpRow=0;
				System.out.println("수정실패");
			}
		}
		return updateEmpRow;
			
	}
	//5) 아이디(아이디리스트) 추가 매소드  
	public int insertId(IdList id) throws Exception {
		int insertIdRow = 0;
		//유효성 여부
		if(id!=null) {
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection();
			
			String idCkSql ="Select id from id_list Where id=?";			
			PreparedStatement idCkStmt = conn.prepareStatement(idCkSql);
			idCkStmt.setString(1,id.getId()); 
			ResultSet ckIdRs = idCkStmt.executeQuery();
			if(ckIdRs.next()) { //동일한 아이디가 있으면 employees테이블에 해당 아이디가 있으면 addEmp로 리다이렉트
				//테이블에 해당아이디가 없으면 emp정보추가 페이지로 리다이렉트를 위한 임의의 row값 반환
				String empCkSql ="Select id from employees Where id=?";
				PreparedStatement empCkStmt = conn.prepareStatement(empCkSql);
				empCkStmt.setString(1,id.getId()); 
				ResultSet ckEmpRs = empCkStmt.executeQuery();
				if(ckEmpRs.next()) { 
					insertIdRow = 2; //2일경우 addEmp페이지로 다시 보냄 
				}	
				insertIdRow =3; //3일경우(id리스트에는 있는데 emp테이블에는 없는경우 empInfo 페이지로 보냄
				return insertIdRow;
			}
			
			//insert 쿼리
			String insertIdSql = "INSERT INTO id_list (id, last_pw, active, createdate) VALUES (?, ?, ?, NOW())";
			PreparedStatement insertIdStmt = conn.prepareStatement(insertIdSql);
			insertIdStmt.setString(1, id.getId()); 	
			insertIdStmt.setString(2, id.getLastPw()); 	
			insertIdStmt.setString(3, id.getActive()); 	
			insertIdRow = insertIdStmt.executeUpdate();
	
		}
		return insertIdRow;
	}
	
	
	//6) 직원정보추가 action 매소드
	public int insertEmp(Employees emp) throws Exception {
		int insertEmpRow = 0;
		//유효성 여부
		if(emp!=null) {
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection();
			//insert 쿼리
			String insertEmpSql = "INSERT INTO employees (id, emp_name, emp_phone, emp_level, createdate, updatedate) VALUES (?, ?, ?, ?, now(), now())";
			PreparedStatement insertEmpStmt = conn.prepareStatement(insertEmpSql);
			insertEmpStmt.setString(1, emp.getId());
			insertEmpStmt.setString(2, emp.getEmpName());
			insertEmpStmt.setString(3, emp.getEmpPhone());
			insertEmpStmt.setString(4, emp.getEmpLevel()); 		
			
			insertEmpRow = insertEmpStmt.executeUpdate();
		}
		return insertEmpRow;
	}
	
	
	//5) 직원전체row 구하는 메소드
	public int selectEmpCnt(String searchCol, String searchWord) throws Exception {
	    int totalRow = 0;
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    // 쿼리문 조건에 따른 분기
	    String empCntSql = "SELECT COUNT(*) FROM employees ";
	    
	    // searchWord가 존재하면 WHERE 절 추가
	    if (searchWord != null && !searchWord.equals("") && searchCol != null && !searchCol.equals("")) {
	        empCntSql += " WHERE " + searchCol + " LIKE ?";
	    }
	    
	    PreparedStatement empCntStmt = conn.prepareStatement(empCntSql);
	    
	    // 조건문이 존재하면 parameterIndex 값을 넣어서 set
	    if (searchWord != null && !searchWord.equals("") && searchCol != null && !searchCol.equals("")) {
	        empCntStmt.setString(1, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
	    }
	    
	    // ResultSet
	    ResultSet empCntRs = empCntStmt.executeQuery();
	    
	    if (empCntRs.next()) {
	        totalRow = empCntRs.getInt(1); // 행이 하나일 때 index 1 사용
	    }
	    
	    return totalRow;
	}
	
	//----------d.주문관리--------------------------//
	
	//1) // 주문관리페이지 주문 목록 메소드
	public ArrayList<HashMap<String, Object>> selectOrdersListByPage(String col, String ascDesc, int beginRow, int rowPerPage, String searchCol, String searchWord, String deliveryStatus) throws Exception {
	    ArrayList<HashMap<String, Object>> orderList = new ArrayList<>();
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    
	    // 쿼리문 조건에 따른 분기
	    String orderSql = "SELECT o.createdate, o.id, o.order_address, op.order_product_no, op.order_no, op.product_no, op.product_cnt, op.delivery_status " +
	                      "FROM order_product op " +
	                      "LEFT JOIN orders o ON o.order_no = op.order_no ";

	    if (!searchWord.equals("") && searchCol != null) {
	        // 검색 조건이 있는 경우
	        if (searchCol.equals("id")) {
	            orderSql += "WHERE o.id LIKE ? "; // 주문자 ID 검색 조건
	        } else {
	            orderSql += "WHERE op." + searchCol + " LIKE ? "; // 다른 컬럼 검색 조건
	        }
	        
	        if (deliveryStatus != null && !deliveryStatus.equals("")) {
	            orderSql += "AND op.delivery_status = ? "; // 배송 상태 검색 조건
	        }
	    } else {
	        if (deliveryStatus != null && !deliveryStatus.equals("")) {
	            orderSql += "WHERE op.delivery_status = ? "; // 배송 상태 검색 조건
	        }
	    }

	    if (!col.equals("") && !ascDesc.equals("")) {
	        orderSql += "ORDER BY " + col + " " + ascDesc + " "; // 정렬 조건
	    }

	    orderSql += "LIMIT ?, ?"; // 페이징 처리

	    PreparedStatement orderStmt = conn.prepareStatement(orderSql);
	    int parameterIndex = 1;
	    
	    // 검색 조건 파라미터 설정
	    if (!searchWord.equals("") && searchCol != null) {
	        if (searchCol.equals("id")) {
	            orderStmt.setString(parameterIndex, "%" + searchWord + "%"); // 주문자 ID 검색어
	            parameterIndex++;
	        } else {
	            orderStmt.setString(parameterIndex, "%" + searchWord + "%"); // 다른 컬럼 검색어
	            parameterIndex++;
	        }
	    }
	    
	    // 배송 상태 파라미터 설정
	    if (deliveryStatus != null && !deliveryStatus.equals("")) {
	        orderStmt.setString(parameterIndex, deliveryStatus); // 배송 상태
	        parameterIndex++;
	    }

	    orderStmt.setInt(parameterIndex, beginRow); // LIMIT의 첫 번째 매개변수
	    parameterIndex++;
	    orderStmt.setInt(parameterIndex, rowPerPage); // LIMIT의 두 번째 매개변수
	    
	    // ResultSet
	    ResultSet orderRs = orderStmt.executeQuery();

	    while (orderRs.next()) {
	        HashMap<String, Object> order = new HashMap<>();
	        order.put("id", orderRs.getString("id")); // 주문자 ID
	        order.put("orderProductNo", orderRs.getString("order_product_no")); // 주문상품 번호
	        order.put("orderNo", orderRs.getString("order_no")); // 주문 번호
	        order.put("createdate", orderRs.getString("createdate")); // 주문 생성일
	        order.put("deliveryStatus", orderRs.getString("delivery_status")); // 배송 상태
	        orderList.add(order);
	    }
	    
	    return orderList;
	}

		
		//2) 주문관리 주문상세 페이지 상품One 메소드
		public HashMap<String, Object> selectOrderOne(int orderProductNo) throws Exception {
			
			
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection(); 
			// PreparedStatement
			String orderOneSql = "SELECT o.createdate, o.id, o.order_address, op.order_product_no, op.order_no, op.product_no, op.product_cnt, op.delivery_status from order_product op  LEFT Join orders o On o.order_no=op.order_no where order_product_no=?";

			PreparedStatement orderOneStmt = conn.prepareStatement(orderOneSql); 
			orderOneStmt.setInt(1,orderProductNo); 	
			
			// ResultSet
			ResultSet orderOneRs = orderOneStmt.executeQuery();
			
			HashMap<String, Object> order = null;
			if(orderOneRs.next()) {
				order = new HashMap<>();
				order.put("createdate",orderOneRs.getString("createdate"));
				order.put("id",orderOneRs.getString("id"));
				order.put("orderAddress",orderOneRs.getString("order_address"));
				order.put("orderProductNo",orderOneRs.getInt("order_product_no"));
				order.put("productNo",orderOneRs.getInt("product_no"));
				order.put("productCnt",orderOneRs.getInt("product_cnt"));	
				order.put("deliveryStatus",orderOneRs.getString("delivery_status"));							
			}
			
			return order; 
		}
		
		
		//3) 주문상태 수정 Action 매소드
		public int updateOrder(String deliveryStatus, int orderProductNo) throws Exception {
			int updateOrderRow=0;
			
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection(); 
		
				//4-1)Update 상품정보 쿼리
				String updateOrderSql = "UPDATE order_product SET delivery_status =? Where order_product_no=?";
				PreparedStatement updateOrderStmt = conn.prepareStatement(updateOrderSql); 
				updateOrderStmt.setString(1,deliveryStatus); 	
				updateOrderStmt.setInt(2,orderProductNo); 
				
				// Row 
				updateOrderRow = updateOrderStmt.executeUpdate();
				if(updateOrderRow==1) {
					System.out.println("수정성공");
				}else{
					updateOrderRow=0;
					System.out.println("수정실패");
				}
			return updateOrderRow;
		}	
			
		
		// 4) 주문 전체 row 구하는 메소드
		public int selectOrderCnt(String searchCol, String searchWord, String deliveryStatus) throws Exception {
		    int totalRow = 0;
		    DBUtil dbUtil = new DBUtil();
		    Connection conn = dbUtil.getConnection();

		    // 쿼리문 조건에 따른 분기
		    String orderCntSql = "SELECT COUNT(*) FROM order_product ";

		    // 검색어 조건이 존재하는 경우 WHERE 절 추가
		    if (searchWord != null && !searchWord.equals("") && searchCol != null && !searchCol.equals("")) {
		        orderCntSql += " WHERE " + searchCol + " LIKE ?";
		    }
		    
		    // 배송 상태 조건이 존재하는 경우 WHERE 절 추가
		    if (deliveryStatus != null && !deliveryStatus.equals("")) {
		        if (searchWord != null && !searchWord.equals("") && searchCol != null && !searchCol.equals("")) {
		            orderCntSql += " AND delivery_status = ?";
		        } else {
		            orderCntSql += " WHERE delivery_status = ?";
		        }
		    }

		    PreparedStatement orderCntStmt = conn.prepareStatement(orderCntSql);

		    int parameterIndex = 1;
		    
		    // 검색어 조건이 존재하는 경우 parameterIndex 값을 넣어서 set
		    if (searchWord != null && !searchWord.equals("") && searchCol != null && !searchCol.equals("")) {
		        orderCntStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
		        parameterIndex++;
		    }
		    
		    // 배송 상태 조건이 존재하는 경우 parameterIndex 값을 넣어서 set
		    if (deliveryStatus != null && !deliveryStatus.equals("")) {
		        orderCntStmt.setString(parameterIndex, deliveryStatus);
		    }

		    // ResultSet
		    ResultSet orderCntRs = orderCntStmt.executeQuery();

		    if (orderCntRs.next()) {
		        totalRow = orderCntRs.getInt(1); // 행이 하나일 때 index 1 사용
		    }

		    return totalRow;
		}
}