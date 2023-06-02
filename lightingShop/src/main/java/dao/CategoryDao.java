package dao;
import java.sql.*;
import java.util.*;
import util.*;

public class CategoryDao {
	
    // 카테고리 목록 조회
    public List<String> getCategoryList() throws Exception {
    	//리스트 선언
        List<String> categoryList = new ArrayList<>();
        //디비연결
        DBUtil dbUtil = new DBUtil();
        Connection conn = dbUtil.getConnection();
        //목록 조회
        String sql = "SELECT category_name FROM category";
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        //이름 반환
        while (rs.next()) {
            categoryList.add(rs.getString("category_name"));
        }

        return categoryList;
    }
}
