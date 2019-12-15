<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<% 
//Check if user is buyer
if(request.getSession(false) == null){
	response.sendRedirect("login.jsp");
}
String userclass = (String)session.getAttribute("class");
String userid = (String)session.getAttribute("userid");
if(userclass == null || !userclass.equals("buyer")){
	response.sendRedirect("login.jsp");
}
int prid = Integer.parseInt((String) request.getParameter("prid"));
try{
  	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
  	Connection conn = DriverManager
  		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
	//Delete Product
	PreparedStatement pst = conn.prepareStatement("delete from wishlist where userid='"+userid+"' and prid="+prid+"");
	pst.executeUpdate();
	response.sendRedirect("product.jsp?prid="+Integer.toString(prid)+"");
}catch(Exception e){
	System.out.println(e);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>

</body>
</html>