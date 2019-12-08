<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR" import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Test Page</title>
</head>
<body>
<%
	String firstString = "";
	try {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
		Connection conn = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/world?" + "user=root&password=root");
		PreparedStatement pst = conn.prepareStatement(
				"Select * from city where id<10;");
		//pst.setString(1, username);
		//pst.setString(2, password);
		ResultSet rs = pst.executeQuery();
		while(true){
			if (rs.next()){
				firstString = rs.getString("name");
				%><%=firstString%><br><%}
			else{
				firstString = "";
				break;
			}
		}
	} catch (Exception e) {
		System.out.println(e);
		out.println("Something went wrong !! Please try again");
	}
%>
</body>
</html>