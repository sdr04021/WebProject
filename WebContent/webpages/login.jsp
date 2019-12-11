<!DOCTYPE html>
<%@ page import = "java.sql.*" %>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>flea market front</title>
    <link rel="stylesheet" href="css/login.css">
    <link href="https://fonts.googleapis.com/css?family=Noto+Sans&display=swap" rel="stylesheet">
  </head>
  <body>
    <% try{
	  String userid=request.getParameter("userid");
	  String password=request.getParameter("password");
	  Class.forName("com.mysql.cj.jdbc.Driver");
	  Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/webproject?" +"user=root&password=root");
	  PreparedStatement pst=conn.prepareStatement("Select userid,password from user where userid=? and password=?");
	  pst.setString(1,userid);
	  pst.setString(2,password);
	  ResultSet rs=pst.executeQuery();		  
  }
  catch(Exception e){
	  out.println("Database error. Contact server manager.");
  }
  %>
    <br><br><br><br><br><br>
    <div class="Welcm">
      <h1>Welcome to the SKKU flea market!</h1>
      <h4>We provide you the safest place to trade your goods<br>please sign in. </h4>
    </div>
    <div class="signin">

      <form class="" action="login.jsp" method="post">
        <label for="id">USERNAME</label> <label for="pswd">PASSWORD</label> <br>
        <input type="text" name="userid" value="">
        <input type="password" name="password" value="">
      </form>
      <p>new here? <a href="registration.html">Sign up</a></p>
      <button type="submit" name="button">Sign in</button>
    </div>

  </body>
</html>
