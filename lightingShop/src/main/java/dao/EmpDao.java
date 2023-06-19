package dao;
import util.DBUtil;
import java.util.*;
import java.sql.*;
import java.io.*;
import vo.*;


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
		String productOneSql = "SELECT pi.product_path, pi.product_ori_filename, pi.product_save_filename, pi.product_filetype, p.product_no, p.category_name, p.product_name, p.product_price, p.product_status, p.product_stock, p.product_info, p.createdate, p.updatedate from product p  Left JOIN product_img pi On p.product_no = pi.product_no where p.product_no=?";

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
			product.put("productPath",productOneRs.getString("product_path"));
			product.put("createdate",productOneRs.getString("createdate"));
			product.put("updatedate",productOneRs.getString("updatedate"));		
			product.put("saveFilename",productOneRs.getString("product_save_filename"));
			
		}
		
		return product;
	}
	
	//3) 상품관리 상품추가 메소드
	
	public int insertProduct(Product product) throws Exception {
		int insertProductRow = 0;
		//유효성 여부
		if(product!=null) {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//insert 쿼리
		String insertProductSql = "Insert INTO product(category_name, product_name, product_price, product_status,product_stock, product_info, createdate, updatedate) Values(?,?,?,?,?,?,now(),now())";
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

	public int insertProductImg(ProductImg productImg, String dir) throws Exception {
		
		
		//업로드 파일이 PDF파일이 아니면
		if (!productImg.getProductFiletype().equals("image/jpeg") && !productImg.getProductFiletype().equals("image/png")) {
			// 이미 upload 폴더에 저장된 파일을 삭제
			System.out.println("이미지 파일이 아닙니다.");
			 String saveFilename = productImg.getProductSaveFilename(); //저장된 파일네임 가져오기
			 File f = new File(dir+"/"+saveFilename); //파일 객체 f 를 가져온 파일명으로 지정 / = new File("d:/abc/uploadsign.파일명")
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
		
		if(productImg!=null) {
		
		
		String productImgSql = "INSERT INTO product_img(product_no, product_ori_filename, product_save_filename, product_filetype, createdate,updatedate,product_path) VALUES(?, ?, ?, ?, NOW(),NOW(),'productImg')";
		PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
		productImgStmt.setInt(1, productImg.getProductNo());
		productImgStmt.setString(2, productImg.getProductOriFilename());
		productImgStmt.setString(3, productImg.getProductSaveFilename());
		productImgStmt.setString(4, productImg.getProductFiletype());
		productImgStmt.executeUpdate(); 
		
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
				if (!contentType.equals("image/jpeg") && !contentType.equals("image/png")) {
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
					System.out.println("활성여부 수정성공");
				}else{
					activeRow=0;
					System.out.println("활성여부 수정실패");
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
			//아이디 중복확인
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
				}else{
					insertIdRow =3; //3일경우(id리스트에는 있는데 emp테이블에는 없는경우 empInfo 페이지로 보냄
				}
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
		
		//----------------- e.문의관리------------------------
	      
	      // 1-1) 관리자 문의 list count -> 검색단어, 카테고리 선택에 따른 문의글 전체 수 (totalRow)
	      public int selectQuestionCnt(String qCategory, String searchCategory, String searchWord, String aChk) throws Exception {
	         int totalRow = 0;
	         
	         DBUtil dbUtil = new DBUtil();
	         Connection conn = dbUtil.getConnection();
	         String sql = "";
	         PreparedStatement stmt = null;
	         
	         // 1) 셋다 null
	         if(qCategory.equals("") && searchCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question";
	            stmt = conn.prepareStatement(sql);
	         }
	         // 2) 답변유무만 선택
	         else if(qCategory.equals("") && searchCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE a_chk = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, aChk);
	         }
	         // 3) qCategory만 선택
	         else if(!qCategory.equals("") && searchCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE q_category = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	         }
	         // 4) searchCategory : qName만 선택
	         else if(searchCategory.equals("qName") && qCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question question WHERE q_name LIKE ? ";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	         }
	         // 5) searchCategory : qtitleAndContent만 선택
	         else if(searchCategory.equals("qtitleAndContent") && qCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ? ";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	         }
	         // 6) qCategory + 답변유무
	         else if(!qCategory.equals("") && searchCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE q_category = ? AND a_chk = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, aChk);
	         }
	         // 7) searchCategory : qName + 답변유무
	         else if(searchCategory.equals("qName") && qCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question question WHERE q_name LIKE ? AND a_chk = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	            stmt.setString(2, aChk);
	         }
	         // 8) searchCategory : qtitleAndContent + 답변유무
	         else if(searchCategory.equals("qtitleAndContent") && qCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ? AND a_chk = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	            stmt.setString(2, aChk);
	         }
	         // 9) qCategory + searchCategory : qName
	         else if(!qCategory.equals("") && searchCategory.equals("qName") && aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE q_category = ? AND q_name LIKE ? ";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	         }
	         // 10) qCategory + searchCategory : qtitleAndContent
	         else if(!qCategory.equals("") && searchCategory.equals("qtitleAndContent") && aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ? ";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	         }
	         // 11) qCategory + searchCategory : qName + 답변유무
	         else if(!qCategory.equals("") && searchCategory.equals("qName") && !aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE q_category = ? AND q_name LIKE ? AND a_chk = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	            stmt.setString(3, aChk);
	         }
	         // 12) qCategory + searchCategory : qtitleAndContent + 답변유무
	         else if(!qCategory.equals("") && searchCategory.equals("qtitleAndContent") && !aChk.equals("")) {
	            sql = "SELECT COUNT(*) FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ? AND a_chk = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	            stmt.setString(3, aChk);
	         }
	         ResultSet rs = stmt.executeQuery();
	         if(rs.next()) {
	            totalRow = rs.getInt(1);
	         }
	         return totalRow;
	      }
	      
	      // 문의글 리스트 조회 + 페이징, 검색단어(작성자,제목+내용), 카테고리 선택
	      public ArrayList<Question> selectQuestionListByPage(int beginRow, int rowPerPage, String qCategory, String searchCategory, String searchWord, String aChk) throws Exception {
	         ArrayList<Question> list = new ArrayList<>();
	         
	         DBUtil dbUtil = new DBUtil();
	         Connection conn = dbUtil.getConnection();
	         /*
	            정렬 : 최신순 (생성일자 내림차순)
	            선택 가능 값 : qCategory(select태그 사용), searchWord, aChk(select태그 사용)
	            경우의 수 :
	         */
	         String sql = "";
	         PreparedStatement stmt = null;
	         
	         // 1) 셋다 null
	         if(qCategory.equals("") && searchCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setInt(1, beginRow);
	            stmt.setInt(2, rowPerPage);
	         }
	         // 2) 답변유무만 선택
	         else if(qCategory.equals("") && searchCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE a_chk = ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, aChk);
	            stmt.setInt(2, beginRow);
	            stmt.setInt(3, rowPerPage);
	         }
	         // 3) qCategory만 선택
	         else if(!qCategory.equals("") && searchCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE q_category = ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setInt(2, beginRow);
	            stmt.setInt(3, rowPerPage);
	         }
	         // 4) searchCategory : qName만 선택
	         else if(searchCategory.equals("qName") && qCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question question WHERE q_name LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	            stmt.setInt(2, beginRow);
	            stmt.setInt(3, rowPerPage);
	         }
	         // 5) searchCategory : qtitleAndContent만 선택
	         else if(searchCategory.equals("qtitleAndContent") && qCategory.equals("") && aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	            stmt.setInt(2, beginRow);
	            stmt.setInt(3, rowPerPage);
	         }
	         // 6) qCategory + 답변유무
	         else if(!qCategory.equals("") && searchCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE q_category = ? AND a_chk = ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, aChk);
	            stmt.setInt(3, beginRow);
	            stmt.setInt(4, rowPerPage);
	         }
	         // 7) searchCategory : qName + 답변유무
	         else if(searchCategory.equals("qName") && qCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question question WHERE q_name LIKE ? AND a_chk = ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	            stmt.setString(2, aChk);
	            stmt.setInt(3, beginRow);
	            stmt.setInt(4, rowPerPage);
	         }
	         // 8) searchCategory : qtitleAndContent + 답변유무
	         else if(searchCategory.equals("qtitleAndContent") && qCategory.equals("") && !aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE CONCAT(q_title,' ',q_content) LIKE ? AND a_chk = ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, "%"+searchWord+"%");
	            stmt.setString(2, aChk);
	            stmt.setInt(3, beginRow);
	            stmt.setInt(4, rowPerPage);
	         }
	         // 9) qCategory + searchCategory : qName
	         else if(!qCategory.equals("") && searchCategory.equals("qName") && aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE q_category = ? AND q_name LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	            stmt.setInt(3, beginRow);
	            stmt.setInt(4, rowPerPage);
	         }
	         // 10) qCategory + searchCategory : qtitleAndContent
	         else if(!qCategory.equals("") && searchCategory.equals("qtitleAndContent") && aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	            stmt.setInt(3, beginRow);
	            stmt.setInt(4, rowPerPage);
	         }
	         // 11) qCategory + searchCategory : qName + 답변유무
	         else if(!qCategory.equals("") && searchCategory.equals("qName") && !aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE q_category = ? AND q_name LIKE ? AND a_chk = ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	            stmt.setString(3, aChk);
	            stmt.setInt(4, beginRow);
	            stmt.setInt(5, rowPerPage);
	         }
	         // 12) qCategory + searchCategory : qtitleAndContent + 답변유무
	         else if(!qCategory.equals("") && searchCategory.equals("qtitleAndContent") && !aChk.equals("")) {
	            sql = "SELECT q_no qNo, id, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate"
	                  + " FROM question WHERE q_category = ? AND CONCAT(q_title,' ',q_content) LIKE ? AND a_chk = ? ORDER BY createdate DESC LIMIT ?, ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, qCategory);
	            stmt.setString(2, "%"+searchWord+"%");
	            stmt.setString(3, aChk);
	            stmt.setInt(4, beginRow);
	            stmt.setInt(5, rowPerPage);
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
	      
	      // 2) QuestionOne (문의내용 + 답변내용 + 상품이름 + 상품이미지 join)
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
	      
	      // 3) questionDelete - 해당 넘버에 해당하는 문의글 삭제
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
	         String sql = "INSERT INTO answer(q_no, id, a_content, createdate, updatedate) VALUES (?,?,?, NOW(), NOW())";
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
	      public HashMap<String, Object> answerOne(int qNo) throws Exception {
	         DBUtil dbUtil = new DBUtil();
	         Connection conn = dbUtil.getConnection();
	         
	         String sql = "SELECT q_no qNo, id, a_content aContent, createdate FROM answer WHERE q_no = ?";
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         stmt.setInt(1, qNo);
	         ResultSet rs = stmt.executeQuery();
	         
	         HashMap<String, Object> map = new HashMap<>();
	         if(rs.next()) {
	            map.put("qNo", rs.getInt("qNo"));
	            map.put("id", rs.getString("id"));
	            map.put("aContent", rs.getString("aContent"));
	            map.put("createdate", rs.getString("createdate"));
	         }
	         return map;
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
	      }        //------> empDao2 추가된 부분입니다.[김영훈]
		
		//----------f.포인트관리--------------------------
		//1) 포인트관리페이지 포인트 목록 메소드
		public ArrayList<HashMap<String, Object>> selectPointListByPage(String col, String ascDesc, int beginRow, int rowPerPage, String searchCol, String searchWord, String pointInfo) throws Exception {
		    ArrayList<HashMap<String, Object>> pointList = new ArrayList<>();
		    DBUtil dbUtil = new DBUtil();
		    Connection conn = dbUtil.getConnection();
		    
		    // 쿼리문 조건에 따른 분기
		    String pointSql = "SELECT point_no, order_no, id, point_info,  point_pm, point, createdate " +
	                  "FROM point_history ";

		    if (!searchWord.equals("") && searchCol != null) {
		        // 검색 조건이 있는 경우
		        if (searchCol.equals("id")) {
		        	pointSql += "WHERE id LIKE ? "; // 주문자 ID 검색 조건
		        } else {
		        	pointSql += "WHERE " + searchCol + " LIKE ? "; // 다른 컬럼 검색 조건
		        }
		        
		        if (pointInfo != null && !pointInfo.equals("")) {
		        	pointSql += "AND point_info = ? "; // 포인트 설명 검색 조건
		        }
		    } else {
		        if (pointInfo != null && !pointInfo.equals("")) {
		        	pointSql += "WHERE point_info = ? "; // 포인트 설명 검색 조건
		        }
		    }

		    if (!col.equals("") && !ascDesc.equals("")) {
		    	pointSql += "ORDER BY " + col + " " + ascDesc + " "; // 정렬 조건
		    }

		    pointSql += "LIMIT ?, ?"; // 페이징 처리

		    PreparedStatement pointStmt = conn.prepareStatement(pointSql);
		    int parameterIndex = 1;
		    
		    // 검색 조건 파라미터 설정
		    if (!searchWord.equals("") && searchCol != null) {
		        if (searchCol.equals("id")) {
		        	pointStmt.setString(parameterIndex, "%" + searchWord + "%"); // 주문자 ID 검색어
		            parameterIndex++;
		        } else {
		        	pointStmt.setString(parameterIndex, "%" + searchWord + "%"); // 다른 컬럼 검색어
		            parameterIndex++;
		        }
		    }
		    
		    // 포인트 설명 파라미터 설정
		    if (pointInfo!= null && !pointInfo.equals("")) {
		    	pointStmt.setString(parameterIndex, pointInfo); // 포인트 설명
		        parameterIndex++;
		    }

		    pointStmt.setInt(parameterIndex, beginRow); // LIMIT의 첫 번째 매개변수
		    parameterIndex++;
		    pointStmt.setInt(parameterIndex, rowPerPage); // LIMIT의 두 번째 매개변수
		    
		    // ResultSet
		    ResultSet pointRs = pointStmt.executeQuery();

		    while (pointRs.next()) {
		        HashMap<String, Object> point = new HashMap<>();
		        point.put("pointNo", pointRs.getInt("point_no")); 
		        point.put("orderNo", pointRs.getInt("order_no")); 
		        point.put("id", pointRs.getString("id")); 
		        point.put("pointInfo", pointRs.getString("point_info")); 
		        point.put("pointPm", pointRs.getString("point_pm")); 
		        point.put("point", pointRs.getInt("point")); 
		        point.put("createdate", pointRs.getString("createdate")); 
		        pointList.add(point);
		    }
		    
		    return pointList;
		 }

			
			//2) 포인트관리 포인트상세 페이지 pointOne 메소드
			public HashMap<String, Object> selectPointOne(int pointNo) throws Exception {
				
				
				DBUtil dbUtil = new DBUtil();
				Connection conn = dbUtil.getConnection(); 
				// PreparedStatement
				String pointOneSql = "Select point_no, order_no, id, point from point_history where point_no=?";

				PreparedStatement pointOneStmt = conn.prepareStatement(pointOneSql); 
				pointOneStmt.setInt(1,pointNo); 	
				
				// ResultSet
				ResultSet pointOneRs = pointOneStmt.executeQuery();
				
				HashMap<String, Object> point = null;
				if(pointOneRs.next()) {
					point = new HashMap<>();
					point.put("id",pointOneRs.getString("id"));
					point.put("pointNo",pointOneRs.getInt("point_no"));
					point.put("orderNo",pointOneRs.getInt("order_no"));					
				}
				
				return point; 
			}
			
			////3) 포인트관리 포인트내역 insert 및 실제 회원 포인트 지급/차감 method
			public int insertPoint(HashMap<String, Object>  pointOne) throws Exception {
				int insertPointRow = 0;
				int updatePointRow = 0;
				//유효성 여부
				if(pointOne!=null) {
					DBUtil dbUtil = new DBUtil();
					Connection conn = dbUtil.getConnection();
					//insert 쿼리
					String insertPointSql = "INSERT INTO point_history (order_no, id, point_info,  point_pm, point, createdate) VALUES (?, ?, ?, ?, ?, now())";
					PreparedStatement insertPointStmt = conn.prepareStatement(insertPointSql);
					insertPointStmt.setInt(1, (Integer)pointOne.get("orderNo"));
					insertPointStmt.setString(2, (String)pointOne.get("id"));
					insertPointStmt.setString(3, (String)pointOne.get("pointInfo"));
					insertPointStmt.setString(4, (String)pointOne.get("pointPm"));
					insertPointStmt.setInt(5, (Integer)pointOne.get("point"));
					insertPointRow = insertPointStmt.executeUpdate();
					
					int intPoint = (Integer)pointOne.get("point");
					
					String selectPointSql = "select cstm_point FROM customer where id =?";
					PreparedStatement selectPointStmt = conn.prepareStatement(selectPointSql);
					selectPointStmt.setString(1, (String)pointOne.get("id"));
					
					// ResultSet
				    ResultSet pointRs = selectPointStmt.executeQuery();
					int totalPoint = 0; 
				    if (pointRs.next()) {
						 totalPoint = pointRs.getInt("cstm_point");
						 
					 }
				    if("P".equals(pointOne.get("point_pm"))) {
						totalPoint += intPoint;
					}else {
						totalPoint -= intPoint;
					}
					
					
					String updatePointSql = "Update customer SET cstm_point=?, updatedate=NOW() where id =?";
					PreparedStatement updatePointStmt = conn.prepareStatement(updatePointSql);
					
					
					updatePointStmt.setInt(1, totalPoint);
					updatePointStmt.setString(2, (String)pointOne.get("id"));
					
					updatePointRow = updatePointStmt.executeUpdate();
				}
				return updatePointRow;
			}
			
			//4) 포인트리스트 전체 row 구하는 매소드
			public int selectPointCnt(String searchCol, String searchWord, String pointInfo) throws Exception {
			    int totalRow = 0;
			    DBUtil dbUtil = new DBUtil();
			    Connection conn = dbUtil.getConnection();
			
			    // 쿼리문 조건에 따른 분기
			    String productPointSql = "SELECT COUNT(*) FROM point_history ";
			
			    // 카테고리 선택 조건에 따라 WHERE 절 추가
			    if (!pointInfo.equals("")) {
			    	productPointSql += "WHERE point_info = ?";
			        
			        // 검색 조건이 존재하는 경우 AND 연산자를 사용하여 추가 조건문 생성
			        if (!searchWord.equals("") && !searchCol.equals("")) {
			        	productPointSql += " AND " + searchCol + " LIKE ?";
			        }
			    } else {
			        // 검색 조건이 존재하는 경우 WHERE 절 추가
			        if (!searchWord.equals("") && !searchCol.equals("")) {
			        	productPointSql += " WHERE " + searchCol + " LIKE ?";
			        }
			    }
			
			    PreparedStatement pointCntStmt = conn.prepareStatement(productPointSql);
			
			    int parameterIndex = 1;
			
			    if (!pointInfo.equals("")) {
			    	pointCntStmt.setString(parameterIndex, pointInfo);
			        parameterIndex++;
			
			         if (!searchWord.equals("") && !searchCol.equals("")) {
			        	pointCntStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
			        }
			    } else {
			        if (!searchWord.equals("") && !searchCol.equals("")) {
			        	pointCntStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
			        }
			    }
			
			    // ResultSet
			    ResultSet pointCntRs = pointCntStmt.executeQuery();
			
			    if (pointCntRs.next()) {
			        totalRow = pointCntRs.getInt(1);
			    }
			
			    return totalRow;
			}
			//----------g.할인관리--------------------------//
			
			// 1) 할인목록 조회 메소드 (기간 범위에 할인이 포함된 할인 목록)
			public ArrayList<Discount> selectDiscountListByPage(String col, String ascDesc, int beginRow, int rowPerPage, String searchCol, String searchWord, String startDate, String endDate) throws Exception {
			    DBUtil dbUtil = new DBUtil();
			    Connection conn = dbUtil.getConnection();
			    PreparedStatement dcStmt = null;

			    String dcSql = "SELECT discount_no, product_no, discount_start, discount_end, discount_rate, createdate, updatedate FROM discount";

			    // 검색 조건이 존재하는 경우 WHERE 절 추가
			    if (!searchWord.equals("") && !searchCol.equals("")) {
			        dcSql += " WHERE " + searchCol + " LIKE ?";
			    }

			    // startDate와 endDate가 존재하는 경우, 해당 기간에 할인이 포함된 할인 정보만 조회
			    if (startDate != null && !startDate.equals("") && endDate != null && !endDate.equals("")) {
			        if (!searchWord.equals("") && !searchCol.equals("")) {
			            dcSql += " AND discount_end >= ? AND discount_end <= ?";
			        } else {
			            dcSql += " WHERE discount_end>= ? AND discount_end <= ?";
			        }
			    }

			    // 정렬 조건이 존재하는 경우 ORDER BY 절 추가
			    if (!col.equals("") && !ascDesc.equals("")) {
			        dcSql += " ORDER BY " + col + " " + ascDesc;
			    }

			    dcSql += " LIMIT ?, ?";

			    dcStmt = conn.prepareStatement(dcSql);
			    int parameterIndex = 1; // 파라미터 인덱스 값 지정하기(분기문에 따라 +해서 대입 예정)

			    if (!searchWord.equals("") && !searchCol.equals("")) {
			        dcStmt.setString(parameterIndex, "%" + searchWord + "%"); // LIKE 연산자를 사용하기 위해 검색어 앞뒤에 % 추가
			        parameterIndex++;
			    }

			    // startDate와 endDate가 존재하는 경우, 파라미터 설정
			    if (startDate != null && !startDate.equals("") && endDate != null && !endDate.equals("")) {
			        dcStmt.setString(parameterIndex, startDate);
			        parameterIndex++;
			        dcStmt.setString(parameterIndex, endDate);
			        parameterIndex++;
			    }

			    dcStmt.setInt(parameterIndex, beginRow); // LIMIT의 첫 번째 매개변수
			    dcStmt.setInt(parameterIndex + 1, rowPerPage); // LIMIT의 두 번째 매개변수

			    // ResultSet
			    ResultSet dcRs = dcStmt.executeQuery();

			    ArrayList<Discount> discountList = new ArrayList<Discount>();
			    while (dcRs.next()) {
			        Discount discount = new Discount();
			        discount.setDiscountNo(dcRs.getInt("discount_no"));
			        discount.setProductNo(dcRs.getInt("product_no"));
			        discount.setDiscountStart(dcRs.getString("discount_start"));
			        discount.setDiscountEnd(dcRs.getString("discount_end"));
			        discount.setDiscountRate(dcRs.getDouble("discount_rate"));
			        discount.setCreatedate(dcRs.getString("createdate"));
			        discount.setUpdatedate(dcRs.getString("updatedate"));
			        discountList.add(discount);
			    }

			    return discountList;
			}
			
				
			// 2)할인 정보 상세보기 메소드
			public Discount selectDiscountOne(int discountNo) throws Exception {
			    DBUtil dbUtil = new DBUtil();
			    Connection conn = dbUtil.getConnection();
			    PreparedStatement selectDiscountStmt = null;
			    ResultSet discountRs = null;

			    String selectDiscountSql = "SELECT discount_no, product_no, discount_start, discount_end, discount_rate, createdate, updatedate FROM discount WHERE discount_no = ?";

			    selectDiscountStmt = conn.prepareStatement(selectDiscountSql);
			    selectDiscountStmt.setInt(1, discountNo);

			    discountRs = selectDiscountStmt.executeQuery();

			    Discount discount = null;
			    if (discountRs.next()) {
			        discount = new Discount();
			        discount.setDiscountNo(discountRs.getInt("discount_no"));
			        discount.setProductNo(discountRs.getInt("product_no"));
			        discount.setDiscountStart(discountRs.getString("discount_start"));
			        discount.setDiscountEnd(discountRs.getString("discount_end"));
			        discount.setDiscountRate(discountRs.getDouble("discount_rate"));
			        discount.setCreatedate(discountRs.getString("createdate"));
			        discount.setUpdatedate(discountRs.getString("updatedate"));
			    }

			    return discount;
			}
			
		    //3) 할인 정보 추가 메소드
			public int insertDiscount(Discount discount) throws Exception {
			    int insertDiscountRow = 0;
			        
			    if (discount != null) {
			         DBUtil dbUtil = new DBUtil();
			         Connection conn = dbUtil.getConnection();
			            
		            String insertDiscountSql = "INSERT INTO discount (product_no, discount_start, discount_end, discount_rate, createdate, updatedate) VALUES (?, ?, ?, ?, NOW(), NOW())";
		            PreparedStatement insertDiscountStmt = conn.prepareStatement(insertDiscountSql);
		            
		            insertDiscountStmt.setInt(1, discount.getProductNo());
		            insertDiscountStmt.setString(2, discount.getDiscountStart());
		            insertDiscountStmt.setString(3, discount.getDiscountEnd());
		            insertDiscountStmt.setDouble(4, discount.getDiscountRate());
		            
		            insertDiscountRow = insertDiscountStmt.executeUpdate();
		        }
			        
			        return insertDiscountRow;
		    }
			    
		    //4) 할인 정보 수정 메소드
		    public int updateDiscount(Discount discount) throws Exception {
		        int updateDiscountRow = 0;
		        
		        if (discount != null) {
		            DBUtil dbUtil = new DBUtil();
		            Connection conn = dbUtil.getConnection();
		            
		            String updateDiscountSql = "UPDATE discount SET product_no=?, discount_start=?, discount_end=?, discount_rate=?, updatedate=NOW() WHERE discount_no=?";
		            PreparedStatement updateDiscountStmt = conn.prepareStatement(updateDiscountSql);
		            
		            updateDiscountStmt.setInt(1, discount.getProductNo());
		            updateDiscountStmt.setString(2, discount.getDiscountStart());
		            updateDiscountStmt.setString(3, discount.getDiscountEnd());
		            updateDiscountStmt.setDouble(4, discount.getDiscountRate());
		            updateDiscountStmt.setInt(5, discount.getDiscountNo());
		            
		            updateDiscountRow = updateDiscountStmt.executeUpdate();
		        }
		        
		        return updateDiscountRow;
		    }
		    
		    //5) 할인 정보 삭제 메소드
		    public int deleteDiscount(int discountNo) throws Exception {
		        int deleteDiscountRow = 0;
		        
		        DBUtil dbUtil = new DBUtil();
		        Connection conn = dbUtil.getConnection();
		        
		        String deleteDiscountSql = "DELETE FROM discount WHERE discount_no=?";
		        PreparedStatement deleteDiscountStmt = conn.prepareStatement(deleteDiscountSql);
		        deleteDiscountStmt.setInt(1, discountNo);
		        
		        deleteDiscountRow = deleteDiscountStmt.executeUpdate();
		        
		        return deleteDiscountRow;
		    }
		    
		 //6) 할인 정보 전체 행 수 조회 메소드
		    public int selectDiscountCnt(String searchCol, String searchWord) throws Exception {
		        int totalCount = 0;

		        DBUtil dbUtil = new DBUtil();
		        Connection conn = dbUtil.getConnection();
		        PreparedStatement selectCountStmt = null;
		        ResultSet countRs = null;

		        String selectCountSql = "SELECT COUNT(*) FROM discount";

		        // 검색 조건이 존재하는 경우 WHERE 절 추가
		        if (searchCol != null && !searchCol.equals("") && searchWord != null && !searchWord.equals("")) {
		            selectCountSql += " WHERE " + searchCol + " LIKE ?";
		        }

		        selectCountStmt = conn.prepareStatement(selectCountSql);

		        // 검색 조건이 존재하는 경우 파라미터 설정
		        if (searchCol != null && !searchCol.equals("") && searchWord != null && !searchWord.equals("")) {
		            selectCountStmt.setString(1, "%" + searchWord + "%");
		        }

		        countRs = selectCountStmt.executeQuery();

		        if (countRs.next()) {
		            totalCount = countRs.getInt(1); //index 1 사용
		        }

		        return totalCount;
		    }
			
} 