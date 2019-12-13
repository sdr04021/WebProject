<!DOCTYPE html>
<%@ page import = "java.sql.*" %>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>sign up</title>
    <link rel="stylesheet" href="../css/login.css">
    <link href="https://fonts.googleapis.com/css?family=Noto+Sans&display=swap" rel="stylesheet">
  </head>
  <body>
<% try{
	String userid=request.getParameter("userid");
	String password=request.getParameter("password");
	String name=request.getParameter("name");
	String email=request.getParameter("email");
	String userclass=request.getParameter("userclass");
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/webproject?"+"user=root&password=root");
	String sql="insert into user(userid,password,name,class,email)values(?,?,?,?,?)";
	
	//Check if new user ID exists
	PreparedStatement pst = conn.prepareStatement("select userid from user where userid='"+userid+"'");
	ResultSet rs = pst.executeQuery();
	if(rs.next()){
		out.println("<script>alert(\"User ID already exists\");</script>");
		out.println("<script>history.back();</script>");
	}
	
	PreparedStatement ps=null;
	ps=conn.prepareStatement(sql);
	ps.setString(1,userid);
	ps.setString(2,password);
	ps.setString(3,name);
	ps.setString(4,userclass);
	ps.setString(5,email);
	ps.executeUpdate();
	response.sendRedirect("login.html");
}
catch(Exception e){
	out.println("Database error. Contact server manager.");
}
%>
    <br><br><br>
    <div class="Welcm">
      <h1>Sign yourself in now!</h1>
      <h4>And explore all kinds of goodies you can find!</h4>
    </div>
    <div class="signup">

      <form class="" action="registration.jsp" method="post">
        <table>
          <tr>
            <td>ID</td>
            <td> <input type="text" name="userid" value=""> </td>
          </tr>
          <tr>
            <td>PASSWORD</td>
            <td> <input type="text" name="password" value=""> </td>
          </tr>
          <tr>
            <td>NAME</td>
            <td>  <input type="text" name="name" value=""> </td>
          </tr>
          <tr>
            <td>EMAIL</td>
            <td> <input type="email" name="email" value=""> </td>
          </tr>
          <tr>
            <td>Sign up as..</td>
            <td> <select class="userclass" name="userclass">
              <option value="buyer">Buyer</option>
              <option value="seller">Seller</option>
            </select> </td>
          </tr>
        </table><br>
        <button type="submit" name="button">SUBMIT!</button>

      </form>
      <br>

    </div>

  </body>
</html>
