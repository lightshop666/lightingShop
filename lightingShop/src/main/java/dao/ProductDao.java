package dao;
import util.DBUtil;
import vo.*;
import java.util.*;
import java.sql.*;

public class ProductDao {
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
			FROM product p
			LEFT JOIN product_img i
			ON p.product_no = i.product_no
				LEFT JOIN discount d
				ON p.product_no = d.product_no
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
	
	// 상품 이름 + 이미지 조회 (product, product_img join)
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
				i.product_save_filename productSaveFilename, -- 상품이미지 저장이름
				i.product_path productPath -- 상품 이미지 저장폴더
			FROM product p
			INNER JOIN product_img i
			ON p.product_no = i.product_no
			WHERE p.product_no = ?
		*/
		String sql = "SELECT p.product_no productNo, p.product_name productName, i.product_save_filename productSaveFilename, i.product_path productPath FROM product p INNER JOIN product_img i ON p.product_no = i.product_no WHERE p.product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("productNo"));
			product.setProductName(rs.getString("productName"));
			productImg.setProductSaveFilename(rs.getString("productSaveFilename"));
			productImg.setProductPath(rs.getString("productPath"));
		}
		map.put("product", product);
		map.put("productImg", productImg);
		return map;
	}
	
	/* 구현중....
	// (상품 상세페이지 리뷰 탭 클릭시) 해당 상품의 리뷰 리스트 + 리뷰 키워드 검색 기능
	public HashMap<String, Object> selectProductReviewList(int productNo) throws Exception {
		HashMap<String, Object> map = new HashMap<>();
		Review review = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		
		
		return map;
	}
	*/
	
	// (상품 상세페이지 문의 탭 클릭시) 해당 상품의 문의 리스트 + 페이징
	public ArrayList<Question> selectProductQuestionListByPage(int beginRow, int rowPerPage, int productNo) throws Exception {
		ArrayList<Question> list = new ArrayList<>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_no qNo, q_category qCategory, q_title qTitle, q_name qName, a_chk aChk, private_chk privateChk, createdate FROM question WHERE product_no = ? ORDER BY createdate DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
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
}
