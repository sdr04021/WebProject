<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="com.oreilly.servlet.*" 
    import="com.oreilly.servlet.multipart.*" import="java.io.*"
    import="java.sql.*"%>
 <%
 //request.setCharacterEncoding("UTF-8");
 String path = application.getRealPath("");
 String rootPath = System.getProperty("user.dir");
 System.out.println(path);
 MultipartRequest mult = new MultipartRequest(request,rootPath,1024*1024*100,"utf-8",new DefaultFileRenamePolicy());
 String product_name = mult.getParameter("product_name");
 String product_price = mult.getParameter("product_price");
 String phone_number = mult.getParameter("phone_number");
 String trading_place = mult.getParameter("trading_place");
 String sell_type = mult.getParameter("sell_type");
 String expiration_date;
 String select_time;
 String select_min;
 String image_name = mult.getFilesystemName("uploadfile");
 String image_type = image_name.substring(image_name.indexOf('.'), image_name.length());
 String test_user = "admin";
 String exp_datetime = "null";
 String image_num = "";
 //String content_type = mult.getContentType("uploadfile");
 
 if(sell_type.equals("auction")){
	 expiration_date = mult.getParameter("expiration_date");
	 select_time = mult.getParameter("select_time");
	 select_min = mult.getParameter("select_min");
	 System.out.println(expiration_date);
	 System.out.println(select_time);
	 System.out.println(select_min);
	 exp_datetime = expiration_date + " " + select_time +":" + select_min + ":00";
 }
 try{
	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
	Connection conn = DriverManager
		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
	PreparedStatement pst = conn.prepareStatement(
			"insert into product(price, phone, prname, sellerid, status, due, image, place) values ('"
	+product_price+"','"+phone_number+"','"+product_name+"','"+test_user+"','"
			+sell_type+"','"+exp_datetime+"','"+image_type+"','"+trading_place+"')");
	pst.executeUpdate();
	pst = conn.prepareStatement("select max(prid) from product");
	ResultSet rs = pst.executeQuery();
	if(rs.next()){
		String new_name = rs.getString("max(prid)")+image_type;
		File oldFile = new File(rootPath.toString() + "/" + image_name);
		File newFile = new File(rootPath.toString() + "/" + new_name);
		oldFile.renameTo(newFile);
		//Go back to home
	}
 }catch(Exception e){
	 System.out.println(e);
 }

 %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>uploading...</title>
</head>
<body>
<%=product_name %>
<%=product_price %>
<%=phone_number %>
<%=trading_place %>
<%=sell_type %>
<br>
<%=image_name %>
</body>
</html>