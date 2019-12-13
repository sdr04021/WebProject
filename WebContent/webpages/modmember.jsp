<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title></title>
</head>
<body>
<%
//Check if user is admin
if(request.getSession(false) == null){
	response.sendRedirect("login.jsp");
}
else{
	String userclass = (String)session.getAttribute("class");
	if(userclass == null || !userclass.equals("admin")){
		response.sendRedirect("login.jsp");
	}
}
%>

<%
try{
  	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
  	Connection conn = DriverManager
  		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
  	String original = request.getParameter("original");
	if(!(request.getParameter("mod_button")==null)){
		//Modify Member Information
		
		//Check if new user ID exists
		PreparedStatement pst = conn.prepareStatement("select userid from user where userid='"+original+"'");
		ResultSet rs = pst.executeQuery();
		if(rs.next()){
			out.println("<script>alert(\"User ID already exists\");</script>");
			out.println("<script>history.back();</script>");
		}
		//Modify
		String userid = request.getParameter("userid");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String memberclass= request.getParameter("select_class");
		pst = conn.prepareStatement("update user set userid='"+userid+
				"', name='"+username+"', password='"+password+"', class='"+memberclass+
				"', email='"+email+"' where userid ='"+original+"'");
		pst.executeUpdate();
		response.sendRedirect("admin.jsp");
	}
	else if(!(request.getParameter("del_button")==null)){
		//Delete Member
		PreparedStatement pst = conn.prepareStatement("delete from user where userid='"+original+"'");
		pst.executeUpdate();
		response.sendRedirect("admin.jsp");
	}
} catch(Exception e){
	System.out.println(e);
}

%>
</body>
</html>