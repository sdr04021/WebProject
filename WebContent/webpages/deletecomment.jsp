<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%
//Check if user is seller or buyer
if(request.getSession(false) == null){
	response.sendRedirect("login.jsp");
}
String userclass = (String)session.getAttribute("class");
String userid = (String)session.getAttribute("userid");
if(userclass == null){
	response.sendRedirect("login.jsp");
}
int cid = Integer.parseInt((String)request.getParameter("cid"));
try{
  	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
  	Connection conn = DriverManager
  		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
	//Delete Comment
	PreparedStatement pst =  conn.prepareStatement("select userid from comment where cid="+cid+"");
	ResultSet rs = pst.executeQuery();
	if(rs.next()){
		if(rs.getString("userid").equals(userid)){
			pst = conn.prepareStatement("delete from comment where cid='"+cid+"'");
			pst.executeUpdate();
			out.println("<script>location.href = document.referrer; history.back();</script>");
		}
	}
	//response.sendRedirect("product.jsp?prid="+Integer.toString(prid)+"");
	out.println("<script>location.href = document.referrer; history.back();</script>");
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