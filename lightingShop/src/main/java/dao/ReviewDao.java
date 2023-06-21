package dao;
import java.sql.*;
import java.util.*;
import vo.*;
import util.*;
import java.io.File;


public class ReviewDao {
	
	
//1-1)마이리뷰 출력
	/*	JOIN 문
	SELECT
	    r.order_product_no AS orderProductNo,
	    r.review_title AS reviewTitle,
	    r.review_content AS reviewContent,
	    r.createdate AS createdate,
	    r.updatedate AS updatedate,
	    r.review_ori_filename AS reviewOriFilename,
	    r.review_save_filename AS reviewSaveFilename,
	    r.review_filetype AS reviewFiletype ,
	    r.review_path AS reviewPath,
	    p.product_name AS productName,
	    o.createdate AS orderDate
	FROM
	    review r
	    INNER JOIN order_product op ON r.order_product_no = op.order_product_no
	    INNER JOIN orders o ON op.order_no = o.order_no
	    INNER JOIN product p ON op.product_no = p.product_no
	WHERE
	    o.id = ?
	    AND r.review_written = 'Y'
	ORDER BY
	    r.createdate DESC
	LIMIT ?, ?	
	
	조건은 세션 로그인한 사용자가 본인의 제품만,  delevery_status가 구매 확정인 경우만  리뷰를 작성
	1)상품타이틀(product) --둘을 연결하기 위해 order_product 테이블--2)주문일자(order) 3)리뷰이미지(review_img) 4)리뷰내용(review) 5) 수정 삭제 버튼 끝
	 */
													//페이징을 위한 변수 2개, 사용자의 리뷰만 보여주기 위한 변수 받아온다
	public ArrayList<HashMap<String, Object>> selectReviewListByPage(int beginRow, int rowPerPage, String loginMemberId) throws Exception {
	    ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		//디비 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String mainSql = "SELECT r.order_product_no AS orderProductNo,"
		        + " r.review_title AS reviewTitle,"
		        + " r.review_content AS reviewContent,"
		        + " r.createdate AS createdate,"
		        + " r.updatedate AS updatedate,"
		        + " r.review_ori_filename AS reviewOriFilename,"
		        + " r.review_save_filename AS reviewSaveFilename,"
		        + " r.review_filetype AS reviewFiletype ,r.review_path AS reviewPath,"
		        + " p.product_name AS productName,"
		        + " o.createdate AS orderDate"
		        + " FROM review r"
		        + " INNER JOIN order_product op ON r.order_product_no = op.order_product_no"
		        + " INNER JOIN orders o ON op.order_no = o.order_no"
		        + " INNER JOIN product p ON op.product_no = p.product_no"
		        + " WHERE o.id = ?"
		        + " AND r.review_written = 'Y'"
		        + " ORDER BY r.createdate DESC"
		        + " LIMIT ?, ?";
		
		PreparedStatement mainStmt = conn.prepareStatement(mainSql);
		mainStmt.setString(1, loginMemberId);
		//페이징 처리를 위한 SQL 쿼리문에서의 인덱스는 0부터 시작하므로 beginRow를 1을 빼서 0부터 시작하도록 설정
		mainStmt.setInt(2, beginRow - 1);
		mainStmt.setInt(3, rowPerPage);
		
		ResultSet mainRs = mainStmt.executeQuery();
		
		//결과셋 받아오기
		while (mainRs.next()) {
	        HashMap<String, Object> reviewData = new HashMap<>();
	        reviewData.put("orderProductNo", mainRs.getInt("orderProductNo"));
	        reviewData.put("reviewTitle", mainRs.getString("reviewTitle"));
	        reviewData.put("reviewContent", mainRs.getString("reviewContent"));
	        reviewData.put("createdate", mainRs.getString("createdate"));
	        reviewData.put("updatedate", mainRs.getString("updatedate"));
	        reviewData.put("reviewOriFilename", mainRs.getString("reviewOriFilename"));
	        reviewData.put("reviewSaveFilename", mainRs.getString("reviewSaveFilename"));
	        reviewData.put("reviewFiletype", mainRs.getString("reviewFiletype"));
	        reviewData.put("reviewPath", mainRs.getString("reviewPath"));
	        reviewData.put("productName", mainRs.getString("productName"));
	        reviewData.put("orderDate", mainRs.getString("orderDate"));

	        list.add(reviewData);
	    }


		System.out.println(list+ "<--ArrayList-- ReviewDao.selectReviewListByPage");

		return list;
	}	
	
//1-2)마이리뷰 페이징 카운트
	/*
	SELECT COUNT(*) 
	FROM review r 
	WHERE EXISTS 												-- EXISTS 절을 사용하여 하위 쿼리의 결과가 존재하는지 확인		
	(SELECT 1 FROM order_product op 							-- 교차 엔티티 order_product 조인
		INNER JOIN orders o ON op.order_no = o.order_no 		-- 주문 테이블과 조인
		WHERE o.id = ? 											-- 주문 테이블의 id 필드를 입력 파라미터로 필터링
		AND r.review_written = 'Y'								-- 주문 상태가 '구매확정'인지 확인
		AND op.order_product_no = r.order_product_no 			-- 주문 상품 번호가 리뷰 테이블과 일치하는지 확인
	);
	 */
	public int selectUserReviewCnt(String loginMemberId) throws Exception {
	    int row = 0;
	    DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "SELECT COUNT(*) FROM review r WHERE EXISTS (SELECT 1 FROM order_product op INNER JOIN orders o ON op.order_no = o.order_no WHERE o.id = ? AND r.review_written = 'Y' AND op.order_product_no = r.order_product_no)";

	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, loginMemberId);
	    ResultSet rs = stmt.executeQuery();
	    if (rs.next()) {
	        row = rs.getInt(1);
	    }

	    return row;
	}

//2-1)리뷰 테이블 전체 출력
	/*
	SELECT
	    r.order_product_no AS orderProductNo,
	    r.review_title AS reviewTitle,
	    r.review_content AS reviewContent,
	    r.review_filetype AS reviewFiletype,
	    r.createdate AS createdate,
	    r.updatedate AS updatedate,
	    r.review_save_filename AS reviewSaveFilename,
	    r.review_ori_filename AS reviewOriFilename, 
	    r.review_path AS reviewPath,
	    p.product_no AS productNo,
	    p.product_name AS productName,
	    p.product_info AS productInfo,
	    p.category_name AS categoryName,
	    p.product_price AS productPrice,
	    p.product_status AS productStatus,
	    o.order_no AS orderNo,
	    o.createdate AS orderDate,
	    op.delivery_status AS delivery,
	    pi.product_save_filename AS productSaveFilename,
	    pi.product_filetype AS productFileType
	FROM
	    review r
		     JOIN order_product op ON r.order_product_no = op.order_product_no
			    INNER JOIN orders o ON op.order_no = o.order_no
				    INNER JOIN product p ON op.product_no = p.product_no
				    	left JOIN product_img pi ON p.product_no = pi.product_no
	WHERE
	    r.review_written = 'Y'
	ORDER BY
	    r.createdate DESC
	LIMIT ?, ?	

	 * */
	public ArrayList<HashMap<String, Object>> allReviewListByPage(int beginRow, int rowPerPage, String category) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		//디비 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String mainSql = "SELECT r.order_product_no AS orderProductNo, r.review_title AS reviewTitle, r.review_content AS reviewContent, "
				+ "r.createdate AS createdate, r.updatedate AS updatedate, r.review_save_filename AS reviewSaveFilename, "
				+ "r.review_ori_filename AS reviewOriFilename,  r.review_filetype AS reviewFiletype, r.review_path AS reviewPath, p.product_no AS productNo, "
				+ "p.product_name AS productName, p.product_info AS productInfo, p.category_name AS categoryName, "
				+ "p.product_price AS productPrice, p.product_status AS productStatus, o.order_no AS orderNo, "
				+ "o.createdate AS orderDate, op.delivery_status AS delivery, pi.product_save_filename AS productSaveFilename, "
				+ "pi.product_filetype AS productFileType "
				+ "FROM review r "
				+ "JOIN order_product op ON r.order_product_no = op.order_product_no "
				+ "INNER JOIN orders o ON op.order_no = o.order_no "
				+ "INNER JOIN product p ON op.product_no = p.product_no "
				+ "LEFT JOIN product_img pi ON p.product_no = pi.product_no "
				+ "WHERE r.review_written = 'Y' "
				
				
				+ "ORDER BY r.createdate DESC "
				+ "LIMIT ?, ?";

		PreparedStatement mainStmt = conn.prepareStatement(mainSql);
		//페이징 처리를 위한 SQL 쿼리문에서의 인덱스는 0부터 시작하므로 beginRow를 1을 빼서 0부터 시작하도록 설정
		mainStmt.setInt(1, beginRow-1);
		mainStmt.setInt(2, rowPerPage);
		
		ResultSet mainRs = mainStmt.executeQuery();
		
		// 결과셋 받아오기
		while (mainRs.next()) {

		    HashMap<String, Object> reviewData = new HashMap<>();
		    reviewData.put("orderProductNo", mainRs.getInt("orderProductNo"));
		    reviewData.put("reviewTitle", mainRs.getString("reviewTitle"));
		    reviewData.put("reviewContent", mainRs.getString("reviewContent"));
		    reviewData.put("createdate", mainRs.getString("createdate"));
		    reviewData.put("updatedate", mainRs.getString("updatedate"));
		    reviewData.put("reviewSaveFilename", mainRs.getString("reviewSaveFilename"));
		    reviewData.put("reviewFiletype", mainRs.getString("reviewFiletype"));
	        reviewData.put("reviewPath", mainRs.getString("reviewPath"));
		    reviewData.put("productNo", mainRs.getInt("productNo"));
		    reviewData.put("productName", mainRs.getString("productName"));
		    reviewData.put("productInfo", mainRs.getString("productInfo"));
		    reviewData.put("productStatus", mainRs.getString("productStatus"));
		    reviewData.put("orderNo", mainRs.getInt("orderNo"));
		    reviewData.put("delivery", mainRs.getString("delivery"));
		    reviewData.put("orderDate", mainRs.getString("orderDate"));
		    reviewData.put("productSaveFilename", mainRs.getString("productSaveFilename"));
		    reviewData.put("productFileType", mainRs.getString("productFileType"));

		    list.add(reviewData);

		}

		System.out.println(list+ "<--ArrayList-- ReviewDao.allReviewListByPage");

		return list;
	}
	
	
//2-2)리뷰 테이블 전체 row

	public int selectReviewCnt() throws Exception {
	//검색을 하거나, 특정 where절이 있으면 입력값이 필요할 수 있다.
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM review WHERE review_written = 'Y'"; 
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("COUNT(*)");
		}
		System.out.println(row+ "<--ArrayList-- ReviewDao.selectReviewCnt");

		return row;
	}
	

//3) 유저별 리뷰 출력
	/*
	SELECT
	    r.review_no reviewNo,
	    r.order_product_no productNo,
	    r.review_title revieTitle,
	    r.review_content reviewContent,
	    r.review_written reviewWritten,
	    r.review_ori_filename reviewOriFilename,
	    r.review_save_filename reviewSaveFilename,
	    r.review_filetype reviewFiletype,
	    r.review_path reviewPath,
	    r.createdate createdate,
	    r.updatedate updatedate
	FROM review r
	    INNER JOIN order_product op ON r.order_product_no = op.order_product_no
	    	INNER JOIN orders o ON op.order_no = o.order_no
	WHERE o.id = ?
	 */
	public HashMap<String, Object> customerReview (String id) throws Exception {
		HashMap<String, Object> map = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT r.review_no reviewNo, r.order_product_no productNo, r.review_title revieTitle, r.review_content reviewContent,   r.review_written reviewWritten, r.review_ori_filename reviewOriFilename,  r.review_save_filename reviewSaveFilename,  r.review_filetype reviewFiletype,   r.review_path reviewPath,   r.createdate createdate,  r.updatedate updatedate FROM review r   INNER JOIN order_product op ON r.order_product_no = op.order_product_no INNER JOIN orders o ON op.order_no = o.order_no WHERE o.id = 'test2';";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		if (rs.next()){
			map = new HashMap<>();
			map.put("reviewNo", rs.getInt("reviewNo"));
			map.put("productNo", rs.getInt("productNo"));
			map.put("reviewTitle", rs.getString("revieTitle"));
			map.put("reviewContent", rs.getString("reviewContent"));
			map.put("reviewWritten", rs.getString("reviewWritten"));
			map.put("reviewOriFilename", rs.getString("reviewOriFilename"));
			map.put("reviewSaveFilename", rs.getString("reviewSaveFilename"));
			map.put("reviewFiletype", rs.getString("reviewFiletype"));
			map.put("reviewPath", rs.getString("reviewPath"));
			map.put("createdate", rs.getString("createdate"));
			map.put("updatedate", rs.getString("updatedate"));
		}
		
		return map;
	}



//4-1)리뷰 insert
	/*
	INSERT INTO review
		(order_product_no, review_title, review_content,
		review_written, review_ori_filename, review_save_filename, review_filetype, createdate, updatedate)
	VALUES
		(?,?,?,'Y',?,?,?, now(), now())
	
	 * 
	 */
	public int addReview(Review review ) throws Exception {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "INSERT INTO review (order_product_no, review_title, review_content, review_written, review_ori_filename, review_save_filename, review_filetype, review_path, createdate, updatedate)"+
	    			" VALUES (?,?,?,'Y',?,?,?,?, now(), now())";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, review.getOrderProductNo());
	    stmt.setString(2, review.getReviewTitle());
	    stmt.setString(3, review.getReviewContent());
	    stmt.setString(4, review.getReviewOriFilename());
	    stmt.setString(5, review.getReviewSaveFilename());
	    stmt.setString(6, review.getReviewFiletype());
	    stmt.setString(7, "reviewImg");
	    row = stmt.executeUpdate();
	    
	    if (row !=0) {
	        System.out.println(row +"행 리뷰 추가 성공<--addReview");
         }else{
        	 row=0;
            System.out.println(row +"행 리뷰 추가 실패<--addReview");
         }
	    return row;		
	}
	
	
//5) 리뷰 파일 삭제
    public void deleteInvalidFile(String saveFilename, String dir) throws Exception  {
    	File f = new File(dir+"/"+saveFilename);
		//이미 파일은 업데이트가 됐기 때문에 파일이 진짜로 있다면
		if(f.exists()){
			//파일삭제
			f.delete();
		}
    }
    
//6-1)리뷰 파일 업로드 안됐을 때 수정 
    
    public int updateReviewWithoutFile(Review review)throws Exception {
    	int row = 0;
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "UPDATE review SET review_title = ?, review_content = ?, updatedate=NOW() WHERE order_product_no = ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, review.getReviewTitle());
	    stmt.setString(2, review.getReviewContent());
	    stmt.setInt(3, review.getOrderProductNo());
	    row = stmt.executeUpdate();
	    
	    if (row !=0) {
	        System.out.println(row +"행 리뷰 수정 성공<--addReview");
         }else{
        	 row=0;
            System.out.println(row +"행 리뷰 수정 실패<--addReview");
         }
    	return row;
    }
	

//6-2)리뷰 파일 업로드하며 수정 updateReviewWithFile
    public int updateReviewWithFile(Review review)throws Exception {
    	int row = 0;
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "UPDATE review SET review_title = ?, review_content = ?, review_filetype = ?, review_ori_filename = ?, review_save_filename = ?, updatedate = NOW() WHERE order_product_no = ?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, review.getReviewTitle());
	    stmt.setString(2, review.getReviewContent());
	    stmt.setString(3, review.getReviewFiletype());
	    stmt.setString(4, review.getReviewOriFilename());
	    stmt.setString(5, review.getReviewSaveFilename());
	    stmt.setInt(6, review.getOrderProductNo());
	    row = stmt.executeUpdate();

	    
	    if (row !=0) {
	        System.out.println(row +"행 리뷰 수정 성공<--addReview");
         }else{
        	 row=0;
            System.out.println(row +"행 리뷰 수정 실패<--addReview");
         }
    	return row;
    }
	
    
//7)리뷰 컬럼 삭제
    public int deleteReview(int orderProductNo)throws Exception {
    	int row = 0;
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();

	    String sql = "DELETE FROM review WHERE order_product_no=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, orderProductNo);
	    row = stmt.executeUpdate();
	    
	    if (row !=0) {
	        System.out.println(row +"행 리뷰 삭제 성공<--deleteReview");
         }else{
        	 row=0;
            System.out.println(row +"행 리뷰 삭제 실패<--deleteReview");
         }
    	return row;
    }
	
	
	
	
	
	
	
	
}