package dao;

import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class CartDao {
    // 장바구니 정보 조회 메서드
    public ArrayList<HashMap<String, Object>> cartListById(String id) throws Exception {
        ArrayList<HashMap<String, Object>> cartList = new ArrayList<>();
        DBUtil dbUtil = new DBUtil();
        Connection conn = dbUtil.getConnection();

        String sql = "SELECT c.cart_no, c.product_no, c.id, c.cart_cnt, c.createdate, c.updatedate, " +
                "p.product_name, pi.product_path, pi.product_ori_filename, pi.product_save_filename, pi.product_filetype " +
                "FROM cart c " +
                "JOIN product p ON c.product_no = p.product_no " +
                "LEFT JOIN product_img pi ON c.product_no = pi.product_no " +
                "WHERE c.id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, id);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            HashMap<String, Object> cart = new HashMap<>();
            cart.put("cartNo", rs.getInt("c.cart_no"));
            cart.put("productNo", rs.getInt("c.product_no"));
            cart.put("userId", rs.getString("c.id"));
            cart.put("cartCnt", rs.getInt("c.cart_cnt"));
            cart.put("createDate", rs.getString("c.createdate"));
            cart.put("updateDate", rs.getString("c.updatedate"));
            cart.put("productName", rs.getString("p.product_name"));
            cart.put("productPath", rs.getString("pi.product_path"));
            cart.put("productOriFilename", rs.getString("pi.product_ori_filename"));
            cart.put("productSaveFilename", rs.getString("pi.product_save_filename"));
            cart.put("productFileType", rs.getString("pi.product_filetype"));

            cartList.add(cart);
        }

        
        return cartList;
    }
    
	//1) 카트 상품One 메소드
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
			product.put("productName",productOneRs.getString("product_name"));
			product.put("productPrice",productOneRs.getDouble("product_price"));
			product.put("productPath",productOneRs.getString("product_path"));
			product.put("createdate",productOneRs.getString("createdate"));
			product.put("updatedate",productOneRs.getString("updatedate"));		
			product.put("saveFilename",productOneRs.getString("product_save_filename"));
			product.put("oriFilename",productOneRs.getString("product_ori_filename"));
			product.put("filetype",productOneRs.getString("product_filetype"));
			
		}
		
		return product;
	}
}