package util;
import java.sql.*;

public class DBUtil {
	public Connection getConnection() throws Exception {
		
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3307/shop";
		String dbuser = "root";
		String dbpw = "java1234";
		
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		
		return conn;
	}
}
