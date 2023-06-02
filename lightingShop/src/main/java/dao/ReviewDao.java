package dao;

import java.sql.*;
import java.util.*;
import vo.*;
import util.*;
import java.io.File;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class ReviewDao {
	
	
//리뷰+리뷰 이미지 테이블 출력
	/*	JOIN 문
	SELECT
	    r.order_no orderNo,
	    r.review_title reviewTitle,
	    r.review_content reviewContent,
	    r.createdate createdate,
	    r.updatedate updatedate,
	    r.review_ori_filename reviewOriFilename,
	    r.review_save_filename reviewSaveFilename,
	    r.review_filetype reviewFiletype,
	    p.product_name productName,
	    o.order_date orderDate
	FROM
	    review r
		    INNER JOIN orders o ON r.order_no = o.order_no
		    	INNER JOIN order_product op ON r.order_no = op.order_no
		    		INNER JOIN product p ON op.product_no = p.product_no
	WHERE
	    o.id = ? -- 로그인한 사용자 아이디를 조건으로 걸어 필터링
	    AND o.delivery_status = '구매확정'
	ORDER BY
	    r.createdate DESC
	LIMIT ?, ?	
	조건은 세션 로그인한 사용자가 본인의 제품만,  delevery_status가 구매 확정인 경우만  리뷰를 작성
	1)상품타이틀(product) --둘을 연결하기 위해 order_product 테이블--2)주문일자(order) 3)리뷰이미지(review_img) 4)리뷰내용(review) 5) 수정 삭제 버튼 끝
	 */
													//페이징을 위한 변수 2개, 사용자의 리뷰만 보여주기 위한 변수 받아온다
	public ArrayList<Object>  selectReviewListByPage(int beginRow, int rowPerPage, String loginMemberId) throws Exception {
		//vo + 해시맵 다 넣는 배열 선언을 위해 Object로만 선언
		ArrayList<Object> list = new ArrayList<>();
		//디비 호출
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String mainSql ="SELECT r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.createdate createdate, r.updatedate updatedate,  r.review_ori_filename reviewOriFilename, r.review_save_filename reviewSaveFilename, r.review_filetype reviewFiletype, p.product_name productName, o.order_date orderDate FROM review r INNER JOIN orders o ON r.order_no = o.order_no INNER JOIN order_product op ON r.order_no = op.order_no INNER JOIN product p ON op.product_no = p.product_no\r\n"
				+ "WHERE  o.id = ?  AND o.delivery_status = '구매확정' ORDER BY r.createdate DESC LIMIT ?, ?";
		PreparedStatement mainStmt = conn.prepareStatement(mainSql);
		//페이징 처리를 위한 SQL 쿼리문에서의 인덱스는 0부터 시작하므로 beginRow를 1을 빼서 0부터 시작하도록 설정
		mainStmt.setString(1, loginMemberId);
		mainStmt.setInt(2, beginRow - 1);
		mainStmt.setInt(3, rowPerPage);
		
		ResultSet mainRs = mainStmt.executeQuery();
		
		//결과셋 받아오기
		while(mainRs.next()){
			//리뷰vo에 한번에 담기 위한 변수 선언
		    Review review = new Review();
		    review.setOrderNo(mainRs.getInt("orderNo"));
		    review.setReviewTitle(mainRs.getString("reviewTitle"));
		    review.setReviewContent(mainRs.getString("reviewContent"));
		    review.setCreatedate(mainRs.getString("createdate"));
		    review.setUpdatedate(mainRs.getString("updatedate"));
		    review.setReviewOriFilename(mainRs.getString("reviewOriFilename"));
		    review.setReviewSaveFilename(mainRs.getString("reviewSaveFilename"));
		    review.setReviewFiletype(mainRs.getString("reviewFiletype"));
		    //리뷰vo에 담기지 않는 리스트를 위한 해시맵 변수 생성
		    HashMap<String, Object> hashMap = new HashMap<>();
		    hashMap.put("productName", mainRs.getString("productName"));
		    hashMap.put("orderDate", mainRs.getString("orderDate"));
		    
		    ArrayList<Object> row = new ArrayList<>();
		    row.add(review);
		    row.add(hashMap);
		    
		    list.add(row);
		}

		System.out.println(list+ "<--ArrayList-- ReviewDao.selectReviewListByPage");

		return list;
	}	
	
//리뷰 테이블 전체 row
	public int selectReviewCnt() throws Exception {
	//검색을 하거나, 특정 where절이 있으면 입력값이 필요할 수 있다.
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM review"; 
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("COUNT(*)");
		}
		
		return row;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
