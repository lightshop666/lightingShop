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

	//1) 상품관리페이지 상품 목록 메소드
	public ArrayList<Product> selectProductListByPage(String col, String ascDesc,int beginRow, int rowPerPage) throws Exception {
		ArrayList<Product> productList = new ArrayList<>();
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// PreparedStatement(select product 테이블 데이터)
		String productSql = "SELECT product_no, category_name, product_name, product_price, product_status,product_stock, product_info, createdate, updatedate from product ORDER BY " + col + " " + ascDesc + "LIMIT ?,?";
		PreparedStatement productStmt = conn.prepareStatement(productSql); 
		productStmt.setInt(1,beginRow); 	// beginRow 가져올 행(시작)
		productStmt.setInt(2,rowPerPage);	// 페이지별 보여줄 row 수 
		
		// ResultSet
		ResultSet productRs = productStmt.executeQuery();
		
		while(productRs.next()) {
			Product p = new Product();
			p.setProductNo(productRs.getInt("product_no"));
			p.setCategoryName(productRs.getString("categoryName"));
			p.setProductName(productRs.getString("productName"));	
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
		String productOneSql = "SELECT pi.product_ori_filename, pi.product_save_filename, pi.product_filetype, p.product_no, p.category_name, p.product_name, p.product_price, p.product_status, p.product_stock, p.product_info, p.createdate, p.updatedate from product p  left JOIN product_img pi On p.product_no = pi.product_no where product_no=?";

		PreparedStatement productOneStmt = conn.prepareStatement(productOneSql); 
		productOneStmt.setInt(1,productNo); 	
		
		// ResultSet
		ResultSet productOneRs = productOneStmt.executeQuery();
		
		HashMap<String, Object> product = null;
		if(productOneRs.next()) {
			product = new HashMap<>();
			product.put("productNo",productOneRs.getInt("product_no"));
			product.put("categoryName",productOneRs.getString("categoryName"));
			product.put("productName",productOneRs.getString("productName"));
			product.put("productPrice",productOneRs.getDouble("productPrice"));
			product.put("productStatus",productOneRs.getString("productStatus"));
			product.put("productStock",productOneRs.getString("productStock"));	
			product.put("productInfo",productOneRs.getString("productInfo"));			
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
		insertProductStmt.setString(5,product.getProductStock()); 
		insertProductStmt.setString(6,product.getProductInfo()); 	
		
		insertProductRow = insertProductStmt.executeUpdate();
		}
		return insertProductRow;
	}
	
	//3) 상품관리  상품이미치추가(product_img)메소드

	public int insertProductImg(HttpServletRequest request, ProductImg productImg, String productFile) throws Exception {
		//프로젝트안 upload폴더의 실제 물리적 위치를 반환
		
		
		
		
		String dir = request.getServletContext().getRealPath("/img/product"); 
		System.out.println(dir+"<--dir"); // commit 되기전 값이 저장되지만 war 파일로 만들면 위치가 고정된다.
		int maxFileSize = 1024*1024*10;
		
		// vo에 가져온 값들 넣어주기
		
		DefaultFileRenamePolicy fp = new DefaultFileRenamePolicy(); //rename cos API
		
		
		//MultipartRequest 클래스를 사용하여 원본 타입의 객체를 cos API로 래핑
		//MultipartRequest 생성자의 매개변수로는 원본 타입, 업로드 폴더 경로, 최대 파일 크기(byte), 인코딩 방식 등을 전달

		MultipartRequest mRequest = new MultipartRequest(request, dir, maxFileSize,"utf-8", fp);
		
		//업로드 파일이 PDF파일이 아니면
		 if(mRequest.getContentType(productFile).equals("image/jpeg")==false){
			 //이미 upload폴더에 저장된 파일을 삭제
			 System.out.println("image/jpeg파일이 아닙니다");
			 String saveFilename = mRequest.getFilesystemName(productFile); //저장된 파일네임 가져오기
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
		//delete 쿼리
		
		if(productImg!=null) {
		
		String productImgSql = "INSERT INTO produc_img(product_no, product_ori_filename, product_save_filename, product_filetype, createdate) VALUES(?, ?, ?, ?, NOW())";
		PreparedStatement productImgStmt = conn.prepareStatement(productImgSql);
		productImgStmt.setInt(1, productImg.getProductNo());
		productImgStmt.setString(2, productImg.getProductOriFilename());
		productImgStmt.setString(3, productImg.getProductSaveFilename());
		productImgStmt.setString(4, productImg.getProductFiletype());
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
	public int updateProduct(HttpServletRequest request,HashMap<String, Object> product, String productFile) throws Exception {
		int updateProductRow=0;
		if(product!=null) {
			DBUtil dbUtil = new DBUtil();
			Connection conn = dbUtil.getConnection(); 
			//Update 쿼리
			
			String updateProductSql = "UPDATE product SET category_name =?, product_name=?, product_price=?, product_status=?, product_stock=?, product_info=?, updatedate=now() Where product_no=?";
			PreparedStatement updateProductStmt = conn.prepareStatement(updateProductSql); 
			updateProductStmt.setString(1,(String)product.get("categoryName")); 	
			updateProductStmt.setString(2,(String)product.get("productName")); 
			updateProductStmt.setString(3,(String)product.get("productPrice")); 
			updateProductStmt.setString(4,(String)product.get("productStatus")); 
			updateProductStmt.setString(5,(String)product.get("productStock")); 
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
			return updateProductRow;
		}
		
		
		
		String dir = request.getServletContext().getRealPath("/img/product"); 
		System.out.println(dir+"<--dir"); // commit 되기전 값이 저장되지만 war 파일로 만들면 위치가 고정된다.
		int maxFileSize = 1024*1024*10;
		
		// vo에 가져온 값들 넣어주기
		
		DefaultFileRenamePolicy fp = new DefaultFileRenamePolicy(); //rename cos API
		
		
		//MultipartRequest 클래스를 사용하여 원본 타입의 객체를 cos API로 래핑
		//MultipartRequest 생성자의 매개변수로는 원본 타입, 업로드 폴더 경로, 최대 파일 크기(byte), 인코딩 방식 등을 전달

		MultipartRequest mRequest = new MultipartRequest(request, dir, maxFileSize,"utf-8", fp);
		
		

		//업로드 파일이 이미지 파일 여부 확인
		if(mRequest.getOriginalFileName(productFile) != null){
			String originFilename = mRequest.getOriginalFileName(productFile);
			
			if(mRequest.getContentType(productFile).equals("image/jpeg")==false){
				System.out.println("이미지파일이 아닙니다");
				 String saveFilename = mRequest.getFilesystemName(productFile); //저장된 파일네임 가져오기
				 File f = new File(dir+"/"+saveFilename); //파일 객체 f 를 가져온 파일명으로 지정 / = new File("d:/abc/uploadsign.파일명")
				 //역슬러쉬가 window 기본 포맷
				 if(f.exists()){
					 f.delete();
					 System.out.println(saveFilename+"새파일삭제");
				 }
			}else{
				//이미지파일인지 먼저 확인후 맞다면 이전파일 삭제, db수정(update)
				String type = mRequest.getContentType(productFile);
				originFilename =mRequest.getOriginalFileName(productFile); //prouduct img 테이블 저장용
				String saveFilename = mRequest.getFilesystemName(productFile);
				
				BoardFile boardFile = new BoardFile();
				boardFile.setBoardFileNo(boardFileNo); //check
				boardFile.setType(type);
				boardFile.setOriginFilename(originFilename);
				boardFile.setSaveFilename(saveFilename);
				
				 System.out.println(saveFilename+"새파일삭제");
				
				//2-2) 이전파일 삭제 
				String saveFilenameSql = "Select save_filename from board_file WHERE board_file_no =?";
				PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
				saveFilenameStmt.setInt(1,boardFile.getBoardFileNo());
				ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
				String prePath = null;
				String preSaveFilename = "";
				if(saveFilenameRs.next()){
					preSaveFilename = saveFilenameRs.getString("save_filename");
	
				}
				File f = new File(dir+"/"+preSaveFilename);
				if(f.exists()){
					f.delete();
					System.out.println(preSaveFilename+"이전파일삭제");
				}
				//2-3)수정된 파일의 정보로 db를 수정
				String boardFileSql = "UPDATE board_file SET origin_filename=?, save_filename=? WHERE board_file_no=?";
				PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
				boardFileStmt.setString(1, boardFile.getOriginFilename());
				boardFileStmt.setString(2, boardFile.getSaveFilename());
				boardFileStmt.setInt(3, boardFile.getBoardFileNo());
				
				System.out.println(boardFileStmt+"boardFileStmt");
				int boardFileRow = boardFileStmt.executeUpdate();
			}
		} 
		 return 0;
		
	}
	

	
	
	//5) 과목전체row 구하는 메소드
	public int selectSubjectCnt() throws Exception {
		int totalRow = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection(); 
		// PreparedStatement
				String subjectCntSql = "SELECT Count(*) from subject";
				PreparedStatement subjectCntStmt = conn.prepareStatement(subjectCntSql); 					
				
				// ResultSet
				ResultSet subjectCntRs = subjectCntStmt.executeQuery();
				
				if(subjectCntRs.next()){
					totalRow = subjectCntRs.getInt(1); //행이 하나일때 index 1사용
				}
		
		return totalRow; 
	}
}