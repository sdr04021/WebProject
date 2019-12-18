<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>flea market front</title>
    <link rel="stylesheet" href="../css/login.css">
    <link href="https://fonts.googleapis.com/css?family=Noto+Sans&display=swap" rel="stylesheet">
  </head>
  <body>
    <br><br><br><br><br><br>
    <div class="Welcm">
      <h1>Welcome to the SKKU flea market!</h1>
      <h4>We provide you the safest place to trade your goods<br>please sign in. </h4>
    </div>
    <div class="signin">

      <form class="" action="login.jsp" method="post">
        <label for="userid">USERID</label> <label for="password">PASSWORD</label> <br>
        <input Id="userid" type="text" name="userid" value="">
        <input type="password" name="password" value="">
        <p style="color:red">
        <% try{
			String userid=request.getParameter("userid");
			if(!(userid==null)){
				String password=request.getParameter("password");
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/webproject?" +"user=root&password=root");
				PreparedStatement pst=conn.prepareStatement("Select userid,password,class from user where userid=? and password=?");
				pst.setString(1,userid);
				pst.setString(2,password);
				ResultSet rs=pst.executeQuery();
				if(rs.next()){
					String userclass= rs.getString("class");
					if(userclass.equals("admin")){
						session.setAttribute("userid",userid);
						session.setAttribute("class","admin");
						response.sendRedirect("admin.jsp");
					}
					else if(userclass.equals("seller")){
						session.setAttribute("userid",userid);
						session.setAttribute("class","seller");
						response.sendRedirect("sellerlist.jsp");
					}
					else if(userclass.equals("buyer")){
						session.setAttribute("userid",userid);
						session.setAttribute("class","buyer");
						response.sendRedirect("search.jsp");
					}
					else out.println("Unknown error");
				}
				else{
					if(!(userid.equals("")&&password.equals(""))){
						out.println("Incorrect userid or password");
					}
				}
			}
  		} catch(Exception e){
		System.out.println(e);
		out.println("Database error. Contact server manager.");
  		}
  		%>
  		</p>
        <button type="submit" name="button">Sign in</button>
      </form>
      <p>new here? <a href="registration.html" style="color:skyblue">Sign up</a></p>
    </div>

  </body>
</html>
