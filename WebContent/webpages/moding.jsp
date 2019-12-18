<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="com.oreilly.servlet.*" 
    import="com.oreilly.servlet.multipart.*" import="java.io.*"
    import="java.sql.*"%>
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
%>
<%
String path = application.getRealPath("") + "\\images";
MultipartRequest mult = new MultipartRequest(request,path,1024*1024*100,"utf-8",new DefaultFileRenamePolicy());
String product_name = mult.getParameter("product_name");
String product_price = mult.getParameter("product_price");
String phone_number = mult.getParameter("phone_number");
String trading_place = mult.getParameter("trading_place");
String sell_type = mult.getParameter("sell_type");
String expiration_date;
String select_time;
String select_min;
String image_name = mult.getFilesystemName("uploadfile");
String image_type = "";
String exp_datetime = "1000-01-01 00:00:00";
String image_num = "";

if(sell_type.equals("auction")){
	 expiration_date = mult.getParameter("expiration_date");
	 select_time = mult.getParameter("select_time");
	 select_min = mult.getParameter("select_min");
	 exp_datetime = expiration_date + " " + select_time +":" + select_min + ":00";
}
try{
	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
	Connection conn = DriverManager
		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
	PreparedStatement pst = conn.prepareStatement(
			"update product set  price='"+product_price+"', phone='"+phone_number+"', prname='"+product_name+"',status='"
			+sell_type+"', due='"+exp_datetime+"', place='"+trading_place+"' where prid="+prid+"");
	pst.executeUpdate();

	//if image is changed
	if(image_name!=null){
		image_type = image_name.substring(image_name.indexOf('.'), image_name.length());
		pst = conn.prepareStatement("update product set image='"+image_type+"' where prid="+prid+"");
		pst.executeUpdate();
		String new_name = Integer.toString(prid)+image_type;
		File oldFile = new File(path.toString() + "/" + image_name);
		File newFile = new File(path.toString() + "/" + new_name);
		newFile.delete();
		oldFile.renameTo(newFile);	
	}
	response.sendRedirect("product.jsp?prid="+prid+"");
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