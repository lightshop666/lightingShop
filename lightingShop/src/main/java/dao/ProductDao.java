package dao;
import util.DBUtil;
import vo.*;
import java.util.*;
import java.sql.*;

public class ProductDao {
	// 카테고리별 상품 리스트 조회 (product, product_img, discount join) + 정렬 선택, 페이징
	public ArrayList<HashMap<String, Object>> selectProductListByPage(String categoryName, String orderBy, int beginRow, int rowPerPage) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
 			SELECT
				p.product_no productNo, -- 상품번호
				p.category_name categoryName, -- 상품 카테고리명
				p.product_name productName, -- 상품이름
				p.product_price productPrice, -- 상품가격 (원가)
				p.product_status productStatus, -- 상품상태 (예약판매/판매중/품절)
				p.createdate createdate, -- 상품 등록일자
				p.updatedate updatedate, -- 상품 수정일자
				i.product_save_filename productImgSaveFilename, -- 상품 이미지파일 저장명
				i.product_path productImgPath, -- 상품 이미지파일 저장 폴더명
				COALESCE(d.discount_rate, 0) discountRate, -- 상품 할인율 (null이면 0 출력)
				(SELECT 
					CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW() 
						THEN p.product_price - (p.product_price * d.discount_rate) 
						ELSE p.product_price 
					END
				) discountedPrice -- 할인율이 적용된 최종 가격
			FROM
				product p
				LEFT JOIN product_img i ON p.product_no = i.product_no
				LEFT JOIN discount d ON p.product_no = d.product_no
			WHERE 1=1;
			
			1) 카테고리별 조회
				AND p.category_name = ?
			2) 정렬 선택 조회
			2-1) 신상품순
				ORDER BY createdate DESC LIMIT ?,?
			2-2) 낮은 가격순
				ORDER BY discountedPrice ASC LIMIT ?,?
			2-3) 높은 가격순
				ORDER BY discountedPrice DESC LIMIT ?,?
		*/
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.createdate createdate, p.updatedate updatedate, i.product_save_filename productImgSaveFilename, i.product_path productImgPath, d.discount_rate discountRate, (SELECT CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW() THEN p.product_price - (p.product_price * d.discount_rate) ELSE p.product_price END) discountedPrice FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE 1=1";
		// 1) 카테고리별 조회
		if(!categoryName.equals("")) {
			sql += " AND p.category_name = ?";
		}
		// 2) 정렬 선택 조회
		switch(orderBy) {
			case "newItem": // 1) 신상품순
				sql += " ORDER BY createdate DESC LIMIT ?,?";
				break;
			case "lowPrice": // 2) 낮은 가격순
				sql += " ORDER BY discountedPrice ASC LIMIT ?,?";
				break;
			case "highPrice": // 3) 높은 가격순
				sql += " ORDER BY discountedPrice DESC LIMIT ?,?";
				break;
			default:
				// 기본적으로 신상품순으로 정렬
				sql += " ORDER BY createdate DESC LIMIT ?,?";
				break;
		}
		PreparedStatement stmt = conn.prepareStatement(sql);
		int parameterIndex = 1; // 물음표 인덱스
		// 1)
		if(!categoryName.equals("")) {
			stmt.setString(parameterIndex++, categoryName);
		}
		// 2)
		stmt.setInt(parameterIndex++, beginRow);
		stmt.setInt(parameterIndex++, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("productNo", rs.getInt("productNo"));
			m.put("categoryName", rs.getString("categoryName"));
			m.put("productName", rs.getString("productName"));
			m.put("productPrice", rs.getInt("productPrice"));
			m.put("productStatus", rs.getString("productStatus"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			m.put("productImgSaveFilename", rs.getString("productImgSaveFilename"));
			m.put("productImgPath", rs.getString("productImgPath"));
			m.put("discountRate", rs.getDouble("discountRate"));
			m.put("discountedPrice", rs.getInt("discountedPrice"));
			list.add(m);
		}
		return list;
	}
	
	// 카테고리별 상품 수 (totalRow)
	public int selectProductCnt(String categoryName) throws Exception {
		int totalRow = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE 1=1";
		if(!categoryName.equals("")) {
			sql += " AND p.category_name = ?";
		}
		PreparedStatement stmt = conn.prepareStatement(sql);
		if(!categoryName.equals("")) {
			stmt.setString(1, categoryName);
		}
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
	
	// 할인 상품 상위 n개 조회 + 카테고리 선택
	public ArrayList<HashMap<String, Object>> selectDiscountProductTop(String categoryName, int n) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
 			SELECT
			    p.product_no productNo, -- 상품번호
			    p.product_name productName, -- 상품이름
			    p.product_price productPrice, -- 상품가격(원가)
			    p.product_status productStatus, -- 상품상태 (예약판매/판매중/품절)
			    i.product_save_filename productImgSaveFilename, -- 상품 이미지파일 저장 이름
			    i.product_path productImgPath, -- 상품 이미지파일 저장 폴더 이름
			    COALESCE(d.discount_rate, 0) discountRate, -- 상품 할인율
			    (SELECT
			            CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW()
			                THEN p.product_price - (p.product_price * d.discount_rate)
			                ELSE p.product_price
			            END
			    ) discountedPrice -- 할인율이 적용된 최종 가격
			FROM
			    product p
			    LEFT JOIN product_img i ON p.product_no = i.product_no
			    LEFT JOIN discount d ON p.product_no = d.product_no
			WHERE 1=1
			
			1) 카테고리 선택시
				AND p.category_name = ?
			2) 정렬(할인율 높은 순), 상위 N개만 조회(LIMIT)
				ORDER BY discountRate DESC LIMIT ?
		*/
		String sql = "SELECT p.product_no productNo, p.product_name productName, p.product_price productPrice, p.product_status productStatus, i.product_save_filename productImgSaveFilename, i.product_path productImgPath, COALESCE(d.discount_rate, 0) discountRate, (SELECT CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW() THEN p.product_price - (p.product_price * d.discount_rate) ELSE p.product_price END) discountedPrice FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE 1=1";
		// 1) 카테고리 선택
		if(!categoryName.equals("")) {
			sql += " AND p.category_name = ?";
		}
		// 2) 정렬(할인율 높은 순), 상위 N개만 조회(LIMIT)
		sql += " ORDER BY discountRate DESC LIMIT ?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		int parameterIndex = 1; // 물음표 인덱스
		// 1)
		if(!categoryName.equals("")) {
			stmt.setString(parameterIndex++, categoryName);
		}
		// 2)
		stmt.setInt(parameterIndex++, n);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("productNo", rs.getInt("productNo"));
			m.put("productName", rs.getString("productName"));
			m.put("productPrice", rs.getInt("productPrice"));
			m.put("productStatus", rs.getString("productStatus"));
			m.put("productImgSaveFilename", rs.getString("productImgSaveFilename"));
			m.put("productImgPath", rs.getString("productImgPath"));
			m.put("discountRate", rs.getDouble("discountRate"));
			m.put("discountedPrice", rs.getInt("discountedPrice"));
			list.add(m);
		}
		return list;
	}
	
	// 파격세일 상품 리스트 (product, product_img, discount join) + 카테고리별 선택 조회, 정렬 선택, 페이징
	public ArrayList<HashMap<String, Object>> selectDiscountProductListByPage(double dRate, String categoryName, String orderBy, int beginRow, int rowPerPage) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
 			SELECT
			    p.product_no productNo, -- 상품번호
			    p.category_name categoryName, -- 상품 카테고리명
			    p.product_name productName, -- 상품이름
			    p.product_price productPrice, -- 상품가격(원가)
			    p.product_status productStatus, -- 상품상태 (예약판매/판매중/품절)
			    p.createdate createdate, -- 상품 등록일자
			    i.product_save_filename productImgSaveFilename, -- 상품 이미지파일 저장 이름
			    i.product_path productImgPath, -- 상품 이미지파일 저장 폴더 이름
			    COALESCE(d.discount_rate, 0) discountRate, -- 상품 할인율
			    (SELECT
			            CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW()
			                THEN p.product_price - (p.product_price * d.discount_rate)
			                ELSE p.product_price
			            END
			    ) discountedPrice -- 할인율이 적용된 최종 가격
			FROM
			    product p
			    LEFT JOIN product_img i ON p.product_no = i.product_no
			    LEFT JOIN discount d ON p.product_no = d.product_no
			WHERE d.discount_rate >= ?
			
			1) 카테고리별 조회
				AND p.category_name = ?
			2) 정렬 선택 조회
			2-1) 신상품순
				ORDER BY createdate DESC LIMIT ?,?
			2-2) 낮은 가격순
				ORDER BY discountedPrice ASC LIMIT ?,?
			2-3) 높은 가격순
				ORDER BY discountedPrice DESC LIMIT ?,?
		*/
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.createdate createdate, i.product_save_filename productImgSaveFilename, i.product_path productImgPath, COALESCE(d.discount_rate, 0) discountRate, (SELECT CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW() THEN p.product_price - (p.product_price * d.discount_rate) ELSE p.product_price END) discountedPrice FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE d.discount_rate >= ?";
		// 1) 카테고리별 조회
		if(!categoryName.equals("")) {
			sql += " AND p.category_name = ?";
		}
		// 2) 정렬 선택 조회
		switch(orderBy) {
			case "newItem": // 1) 신상품순
				sql += " ORDER BY createdate DESC LIMIT ?,?";
				break;
			case "lowPrice": // 2) 낮은 가격순
				sql += " ORDER BY discountedPrice ASC LIMIT ?,?";
				break;
			case "highPrice": // 3) 높은 가격순
				sql += " ORDER BY discountedPrice DESC LIMIT ?,?";
				break;
			default:
				// 기본적으로 신상품순으로 정렬
				sql += " ORDER BY createdate DESC LIMIT ?,?";
				break;
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setDouble(1, dRate); // 할인율 몇퍼센트 이상의 제품부터 조회할지
		
		int parameterIndex = 2; // 물음표 인덱스
		// 1)
		if(!categoryName.equals("")) {
			stmt.setString(parameterIndex++, categoryName);
		}
		// 2)
		stmt.setInt(parameterIndex++, beginRow);
		stmt.setInt(parameterIndex++, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("productNo", rs.getInt("productNo"));
			m.put("categoryName", rs.getString("categoryName"));
			m.put("productName", rs.getString("productName"));
			m.put("productPrice", rs.getInt("productPrice"));
			m.put("productStatus", rs.getString("productStatus"));
			m.put("productImgSaveFilename", rs.getString("productImgSaveFilename"));
			m.put("productImgPath", rs.getString("productImgPath"));
			m.put("discountRate", rs.getDouble("discountRate"));
			m.put("discountedPrice", rs.getInt("discountedPrice"));
			list.add(m);
		}
		return list;
	}
	
	// (카테고리 선택에 따른) 파격세일 상품 totalRow
	public int selectDiscountProductCnt(double dRate, String categoryName) throws Exception {
		int totalRow = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE d.discount_rate >= ?";
		// categoryName 값이 있으면
		if(!categoryName.equals("")) {
			sql += " AND p.category_name = ?";
		}
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setDouble(1, dRate); // 할인율 몇퍼센트 이상의 제품부터 조회할지
		if(!categoryName.equals("")) {
			stmt.setString(2, categoryName);
		}
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
	
	// 상품 상세보기 (product, product_img, discount join)
	public HashMap<String, Object> selectProductAndImgOne(int productNo) throws Exception {
		HashMap<String, Object> map = new HashMap<>();
		Product product = null;
		ProductImg productImg = null;
		Discount discount = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT
				p.product_no productNo, -- 상품번호
				p.category_name categoryName, -- 상품 카테고리 (관리자/무드등/스탠드/실내조명/실외조명/파격세일/포인트조명)
				p.product_name productName, -- 상품이름
				p.product_price productPrice, -- 상품가격
				p.product_status productStatus, -- 상품상태 (예약판매/판매중/품절)
				p.product_stock productStock, -- 상품재고량
				p.product_info productInfo, -- 상품설명
				p.createdate productCreatedate, -- 상품등록일자
				p.updatedate productUpdatedate, -- 상품수정일자
				i.product_ori_filename productImgOriFilename, -- 상품이미지 원래 이름
				i.product_save_filename productImgSaveFilename, -- 상품이미지 저장 이름
				i.product_filetype productImgFiletype, -- 상품 이미지 파일 타입
				i.product_path productImgPath, -- 상품 이미지 저장 폴더명
				i.createdate productImgCreatedate, -- 상품 이미지 생성일자
				i.updatedate productImgUpdatedate, -- 상품 이미지 수정일자
				d.discount_start discountStart, -- 상품 할인 시작일
				d.discount_end discountEnd, -- 상품 할인 마지막일
				d.discount_rate discountRate -- 상품 할인율
			FROM
				product p
				LEFT JOIN product_img i ON p.product_no = i.product_no
				LEFT JOIN discount d ON p.product_no = d.product_no
			WHERE p.product_no = ?
		*/
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate productCreatedate, p.updatedate productUpdatedate, i.product_ori_filename productImgOriFilename, i.product_save_filename productImgSaveFilename, i.product_filetype productImgFiletype, i.product_path productImgPath, i.createdate productImgCreatedate, i.updatedate productImgUpdatedate, d.discount_start discountStart, d.discount_end discountEnd, d.discount_rate discountRate FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE p.product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			discount = new Discount();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getDouble("productPrice"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductInfo(rs.getString("productInfo"));
			product.setCreatedate(rs.getString("productCreatedate"));
			product.setUpdatedate(rs.getString("productUpdatedate"));
			productImg.setProductOriFilename(rs.getString("productImgOriFilename"));
			productImg.setProductSaveFilename(rs.getString("productImgSaveFilename"));
			productImg.setProductFiletype(rs.getString("productImgFiletype"));
			productImg.setProductPath(rs.getString("productImgPath"));
			productImg.setCreatedate(rs.getString("productImgCreatedate"));
			productImg.setUpdatedate(rs.getString("productImgUpdatedate"));
			discount.setDiscountStart(rs.getString("discountStart"));
			discount.setDiscountEnd(rs.getString("discountEnd"));
			discount.setDiscountRate(rs.getDouble("discountRate"));
		}
		map.put("product", product);
		map.put("productImg", productImg);
		map.put("discount", discount);
		return map;
	}
	
	// 상품 이름, 가격, 이미지 조회 (product, product_img join)
	public HashMap<String, Object> selectProductAndImg(int productNo) throws Exception {
		HashMap<String, Object> map = new HashMap<>();
		Product product = null;
		ProductImg productImg = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT 
				p.product_no productNo, -- 상품번호
				p.product_name productName, -- 상품이름
				p.product_price productPrice, -- 상품가격 (원가)
				i.product_save_filename productSaveFilename, -- 상품이미지 저장이름
				i.product_path productPath -- 상품 이미지 저장폴더
			FROM
				product p
				LEFT JOIN product_img i ON p.product_no = i.product_no
			WHERE p.product_no = ?
		*/
		String sql = "SELECT p.product_no productNo, p.product_name productName, p.product_price productPrice, i.product_save_filename productSaveFilename, i.product_path productPath FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no WHERE p.product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("productNo"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getDouble("productPrice"));
			productImg.setProductSaveFilename(rs.getString("productSaveFilename"));
			productImg.setProductPath(rs.getString("productPath"));
		}
		map.put("product", product);
		map.put("productImg", productImg);
		return map;
	}

	// (상품 상세페이지 리뷰 탭 클릭시) 해당 상품의 리뷰 리스트 + 페이징, 리뷰 키워드 검색(제목+내용)
	public ArrayList<HashMap<String, Object>> selectProductReviewList(int reviewBeginRow, int reviewRowPerPage, String searchWord, int productNo) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT
				r.review_title reviewTitle, -- 리뷰 제목
				r.review_content reviewContent, -- 리뷰 내용
				r.review_ori_filename reviewOriFilename, -- 리뷰 이미지파일 이름
				r.review_save_filename reviewSaveFilename, -- 리뷰 이미지파일 저장이름
				r.createdate reviewCreatedate, -- 리뷰 작성일자
				r.updatedate reviewUpdatedate, -- 리뷰 수정일자
				r.review_path reviewPath, -- 리뷰 이미지파일 저장 폴더 이름
				op.product_no productNo, -- 작성한 리뷰의 상품 번호
				o.id id -- 작성자 아이디
			FROM
				review r
				INNER JOIN order_product op ON r.order_product_no = op.order_product_no
				INNER JOIN orders o ON op.order_no = o.order_no
			WHERE op.product_no = ?
			
			1) searchWord 값이 있으면 (키워드 검색)
				AND CONCAT(r.review_title,' ',r.review_content) LIKE ?
			2) 정렬(리뷰 작성일자), 페이징
				ORDER BY r.createdate DESC LIMIT ?, ?
		*/
		String sql = "SELECT r.review_title reviewTitle, r.review_content reviewContent, r.review_ori_filename reviewOriFilename, r.review_save_filename reviewSaveFilename, r.createdate reviewCreatedate, r.updatedate reviewUpdatedate, r.review_path reviewPath, op.product_no productNo, o.id id FROM review r INNER JOIN order_product op ON r.order_product_no = op.order_product_no INNER JOIN orders o ON op.order_no = o.order_no WHERE op.product_no = ?";
		// 1) searchWord 값이 있으면 (키워드 검색)
		if(!searchWord.equals("")) {
			sql += " AND CONCAT(r.review_title,' ',r.review_content) LIKE ?";
		}
		// 2) 정렬(리뷰 작성일자), 페이징
		sql += " ORDER BY r.createdate DESC LIMIT ?, ?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		
		int parameterIndex = 2; // 물음표 인덱스
		// 1)
		if(!searchWord.equals("")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 2)
		stmt.setInt(parameterIndex++, reviewBeginRow);
		stmt.setInt(parameterIndex++, reviewRowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("reviewTitle", rs.getString("reviewTitle"));
			m.put("reviewContent", rs.getString("reviewContent"));
			m.put("reviewOriFilename",rs.getString("reviewOriFilename"));
			m.put("reviewSaveFilename", rs.getString("reviewSaveFilename"));
			m.put("reviewCreatedate", rs.getString("reviewCreatedate"));
			m.put("reviewUpdatedate", rs.getString("reviewUpdatedate"));
			m.put("reviewPath", rs.getString("reviewPath"));
			m.put("productNo", rs.getInt("productNo"));
			m.put("id", rs.getString("id"));
			list.add(m);
		}
		return list;
	}
	
	// (상품 상세페이지 리뷰 탭 클릭시) 해당 상품의 리뷰 수 (totalRow)
	public int selectProductReviewCnt(String searchWord, int productNo) throws Exception {
		int totalRow = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT COUNT(*)
			FROM
				review r
				INNER JOIN order_product op ON r.order_product_no = op.order_product_no
				INNER JOIN orders o ON op.order_no = o.order_no
			WHERE op.product_no = ?
			
			searchWord 값이 있으면 (키워드 검색)
				AND CONCAT(r.review_title,' ',r.review_content) LIKE ?
		*/
		String sql = "SELECT COUNT(*) FROM review r INNER JOIN order_product op ON r.order_product_no = op.order_product_no INNER JOIN orders o ON op.order_no = o.order_no WHERE op.product_no = ?";
		// searchWord 값이 있으면
		if(!searchWord.equals("")) {
			sql += " AND CONCAT(r.review_title,' ',r.review_content) LIKE ?";
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		if(!searchWord.equals("")) {
			stmt.setString(2, "%"+searchWord+"%");
		}
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
	
	// (상품 상세페이지 문의 탭 클릭시) 해당 상품의 문의 리스트 + 페이징
	public ArrayList<Question> selectProductQuestionListByPage(int questionBeginRow, int questionRowPerPage, int productNo) throws Exception {
		ArrayList<Question> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_no qNo, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question WHERE product_no = ? ORDER BY createdate DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		stmt.setInt(2, questionBeginRow);
		stmt.setInt(3, questionRowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Question q = new Question();
			q.setqNo(rs.getInt("qNo"));
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
	
	// (상품 상세페이지 문의 탭 클릭시) 해당 상품의 문의 수 (totalRow)
	public int selectProductQuestionCnt(int productNo) throws Exception {
		int totalRow = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM question WHERE product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
	
	// 상품 검색 결과 리스트 + 페이징, 검색단어(상품이름), 상품 카테고리 선택, 가격 범위 검색, 정렬 선택
	public ArrayList<HashMap<String, Object>> searchResultListByPage(String searchWord, String categoryName, int searchPrice1, int searchPrice2, String orderBy, int beginRow, int rowPerPage) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
			SELECT
				p.product_no productNo, -- 상품번호
				p.category_name categoryName, -- 상품 카테고리
				p.product_name productName, -- 상품이름
				p.product_price productPrice, -- 상품가격 (원가)
				p.product_status productStatus, -- 상품상태 (예약판매/판매중/품절)
				p.createdate createdate, -- 상품 등록일자
				p.updatedate updatedate, -- 상품 수정일자
				i.product_save_filename productImgSaveFilename, -- 상품 이미지파일 저장이름
				i.product_path productImgPath, -- 상품 이미지파일 저장 폴더이름
				COALESCE(d.discount_rate, 0) discountRate, -- 상품 할인율 (null이면 0 출력)
				(SELECT 
					CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW() 
						THEN p.product_price - (p.product_price * d.discount_rate) 
						ELSE p.product_price 
					END
				) discountedPrice -- 할인율이 적용된 최종 가격
			FROM
				product p
				LEFT JOIN product_img i ON p.product_no = i.product_no
				LEFT JOIN discount d ON p.product_no = d.product_no
			WHERE 1=1
			
			1) searchWord 값이 있을 때
				AND p.product_name LIKE ?
			2) categoryName 값이 있을 때
				AND p.category_name LIKE ?
			3) searchPrice1 또는 searchPrice2 값이 있을 때 (가격범위 조회)
				AND p.product_price > ?
				AND p.product_price < ?
				AND p.product_price BETWEEN ? AND ?
			4) orderBy 를 변경했을 때
				ORDER BY createdate DESC LIMIT ?,? 
				ORDER BY discountedPrice ASC LIMIT ?,?
				ORDER BY discountedPrice DESC LIMIT ?,?
		*/
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.createdate createdate, p.updatedate updatedate, i.product_save_filename productImgSaveFilename, i.product_path productImgPath, d.discount_rate discountRate, (SELECT CASE WHEN d.discount_start <= NOW() AND d.discount_end >= NOW() THEN p.product_price - (p.product_price * d.discount_rate) ELSE p.product_price END) discountedPrice FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE 1=1";
		// 1) searchWord 값이 있을 때
		if(!searchWord.equals("")) {
			sql += " AND p.product_name LIKE ?";
		}
		// 2) categoryName 값이 있을 때
		if(!categoryName.equals("")) {
			sql += " AND p.category_name LIKE ?";
		}
		// 3) searchPrice1 또는 searchPrice2 값이 있을 때 (가격범위 조회)
		if(searchPrice1 != 0 && searchPrice2 == 0) { // 최소가격만 입력
			sql += " AND p.product_price > ?";
		} else if(searchPrice1 == 0 && searchPrice2 != 0) { // 최대가격만 입력
			sql += " AND p.product_price < ?";
		} else if(searchPrice1 != 0 && searchPrice2 != 0) { // 둘다 입력
			sql += " AND p.product_price BETWEEN ? AND ?";
		}
		// 4) orderBy 를 변경했을 때
		switch(orderBy) {
			case "newItem": // 신상품순
				sql += " ORDER BY createdate DESC LIMIT ?,?";
				break;
			case "lowPrice": // 낮은 가격순
				sql += " ORDER BY discountedPrice ASC LIMIT ?,?";
				break;
			case "highPrice": // 높은 가격순
				sql += " ORDER BY discountedPrice DESC LIMIT ?,?";
				break;
			default:
				// 기본적으로 신상품순으로 정렬
				sql += " ORDER BY createdate DESC LIMIT ?,?";
				break;
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		int parameterIndex = 1; // 물음표 인덱스
		// 1)
		if(!searchWord.equals("")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 2)
		if(!categoryName.equals("")) {
			stmt.setString(parameterIndex++, categoryName);
		}
		// 3)
		if(searchPrice1 != 0 && searchPrice2 == 0) {
			stmt.setInt(parameterIndex++, searchPrice1);
		} else if(searchPrice1 == 0 && searchPrice2 != 0) {
			stmt.setInt(parameterIndex++, searchPrice2);
		} else if(searchPrice1 != 0 && searchPrice2 != 0) {
			stmt.setInt(parameterIndex++, searchPrice1);
			stmt.setInt(parameterIndex++, searchPrice2);
		}
		// 4)
		stmt.setInt(parameterIndex++, beginRow);
		stmt.setInt(parameterIndex++, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("productNo", rs.getInt("productNo"));
			m.put("categoryName", rs.getString("categoryName"));
			m.put("productName", rs.getString("productName"));
			m.put("productPrice", rs.getInt("productPrice"));
			m.put("productStatus", rs.getString("productStatus"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			m.put("productImgSaveFilename", rs.getString("productImgSaveFilename"));
			m.put("productImgPath", rs.getString("productImgPath"));
			m.put("discountRate", rs.getDouble("discountRate"));
			m.put("discountedPrice", rs.getInt("discountedPrice"));
			list.add(m);
		}
		return list;
	}
	
	// 상품 검색 결과에 따른 totalRow
	public int searchResultCnt(String searchWord, String categoryName, int searchPrice1, int searchPrice2) throws Exception {
		int totalRow = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM product p LEFT JOIN product_img i ON p.product_no = i.product_no LEFT JOIN discount d ON p.product_no = d.product_no WHERE 1=1";
		// 1) searchWord 값이 있을 때
		if(!searchWord.equals("")) {
			sql += " AND p.product_name LIKE ?";
		}
		// 2) categoryName 값이 있을 때
		if(!categoryName.equals("")) {
			sql += " AND p.category_name LIKE ?";
		}
		// 3) searchPrice1 또는 searchPrice2 값이 있을 때 (가격범위 조회)
		if(searchPrice1 != 0 && searchPrice2 == 0) {
			sql += " AND p.product_price > ?";
		} else if(searchPrice1 == 0 && searchPrice2 != 0) {
			sql += " AND p.product_price < ?";
		} else if(searchPrice1 != 0 && searchPrice2 != 0) {
			sql += " AND p.product_price BETWEEN ? AND ?";
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		int parameterIndex = 1; // 물음표 인덱스
		// 1)
		if(!searchWord.equals("")) {
			stmt.setString(parameterIndex++, "%"+searchWord+"%");
		}
		// 2)
		if(!categoryName.equals("")) {
			stmt.setString(parameterIndex++, categoryName);
		}
		// 3)
		if(searchPrice1 != 0 && searchPrice2 == 0) {
			stmt.setInt(parameterIndex++, searchPrice1);
		} else if(searchPrice1 == 0 && searchPrice2 != 0) {
			stmt.setInt(parameterIndex++, searchPrice2);
		} else if(searchPrice1 != 0 && searchPrice2 != 0) {
			stmt.setInt(parameterIndex++, searchPrice1);
			stmt.setInt(parameterIndex++, searchPrice2);
		}
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt(1);
		}
		return totalRow;
	}
}
