package dao;
import java.sql.*;
import java.util.*;
import util.*;
import vo.*;
import java.io.*;
import com.oreilly.servlet.*;
import com.oreilly.servlet.multipart.*;


public class ReviewDao {
	
	
//리뷰+리뷰 이미지 테이블 출력
	/*	JOIN 문
	SELECT
		b.order_no orderNo
		, b.review_title reviewTitle
		, b.review_content reviewContent
		, b.createdate createdate
		, b.updatedate updatedate
		, i.review_ori_filename reviewOriFilename
		, i.review_save_filename reviewSaveFilename
		, i.review_filetype reviewFiletype
	FROM review b INNER JOIN review_img i
	ON b.order_no = i.order_no
	ORDER BY b.createdate DESC LIMIT ?, ?
	 */
	public ArrayList<HashMap<String, Object>>  selectReviewListByPage(int beginRow, int rowPerPage) throws Exception {
	   String dir = request.getServletContext().getRealPath("/img/review");
	   System.out.println(dir+ "<-- dir");
	   int maxFileSize = 1024 * 1024 * 100; // 아래와 마찬가지로 100Mbyte로 읽는다	--> 성의있게 느껴짐
	   // 하루 1000ms * 60초 * 60분 * 24	--> 계산해서 쓰지 말고 이렇게 쓰여있으면 대부분 하루라고 읽는다
	   
	   // 업로드 폴더내 동일한 이름이 있으면 뒤에 숫자를 추가 
	   DefaultFileRenamePolicy fp = new DefaultFileRenamePolicy();
	   
	   MultipartRequest mreq 
	      = new MultipartRequest(request, dir, maxFileSize, "utf-8", fp);

		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String mainSql = "SELECT b.order_no orderNo, b.review_title reviewTitle, b.review_content reviewContent, b.createdate createdate, b.updatedate updatedate, i.review_ori_filename reviewOriFilename, i.review_save_filename reviewSaveFilename, i.review_filetype reviewFiletype FROM review b INNER JOIN review_img i ON b.order_no = i.order_no ORDER BY b.createdate DESC LIMIT ?, ?";
		PreparedStatement mainStmt = conn.prepareStatement(mainSql);
		//페이징 처리를 위한 SQL 쿼리문에서의 인덱스는 0부터 시작하므로 beginRow를 1을 빼서 0부터 시작하도록 설정

		mainStmt.setInt(1, beginRow - 1);
		mainStmt.setInt(2, rowPerPage);
		
		ResultSet mainRs = mainStmt.executeQuery();
		while(mainRs.next()){
			HashMap<String, Object> w = new HashMap<String, Object>();
			w.put("reviewTitle", mainRs.getString("reviewTitle"));
			
			list.add(w);
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
