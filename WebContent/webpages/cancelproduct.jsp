<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%
//Check if user is seller
if(request.getSession(false) == null){
	response.sendRedirect("login.jsp");
}
String userclass = (String)session.getAttribute("class");
String userid = (String)session.getAttribute("userid");
if(userclass == null || !userclass.equals("seller")){
	response.sendRedirect("login.jsp");
}
int prid = Integer.parseInt((String) request.getParameter("prid"));

try{
  	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
  	Connection conn = DriverManager
  		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
	//Delete Product
	PreparedStatement pst =  conn.prepareStatement("select sellerid from product where prid="+prid+"");
	ResultSet rs = pst.executeQuery();
	if(rs.next()){
		if(rs.getString("sellerid").equals(userid)){
			pst = conn.prepareStatement("delete from product where prid='"+prid+"'");
			pst.executeUpdate();
			response.sendRedirect("sellerlist.jsp");
		}
	}
	else out.println("You are not seller of this product");
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