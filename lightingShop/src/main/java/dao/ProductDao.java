package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;

import util.DBUtil;
import vo.*;

public class ProductDao {
	// 상품 상세보기 + 상품 이미지 (product, product_img, discount join)
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
		String sql = "";
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
}
