<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
<%
//Check if user is admin
if(request.getSession(false) == null){
	response.sendRedirect("login.jsp");
}
String userclass = (String)session.getAttribute("class");
if(userclass == null || !userclass.equals("admin")){
	response.sendRedirect("login.jsp");
}
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <title>Member List</title>
  <link rel="stylesheet" href="../css/navbarfix.css">
  <!--Bootstrap CSS-->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
</head>

<body>
  <!--Navigation Bar-->
  <div class="container">
    <nav class="navbar fixed-top navbar-expand-md navbar-dark bg-dark shadow-sm p-3 mb-5">
      <div class="d-flex flex-grow-1">
        <span class="navbar-brand mb-0 h1">Flea Market</span>
      </div>
      <div class="flex-shrink-1 flex-grow-0 order-last">
        <button type="button" class="btn btn-outline-light" name="button" onClick="location.href='logout.jsp'">Log out</button>
      </div>
    </nav>
  </div>

  <!--Table for Member List-->
  <div class="table-responsive">
    <h2>Member List</h2>
    <table class="table table-sm table-striped">
      <thead class="thead-dark">
        <tr>
          <th scope="col">User id</th>
          <th scope="col">Password</th>
          <th scope="col">Name</th>
          <th scope="col">Buy/Sell</th>
          <th scope="col">Email</th>
          <th scope="col">Mod/Del</th>
        </tr>
      </thead>
      <tbody>
        <%
        try{
          	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
          	Connection conn = DriverManager
          		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
          	PreparedStatement pst = conn.prepareStatement("select * from user");
          	ResultSet rs = pst.executeQuery();
          	while(true){
             	if(rs.next()){
              		String userid = rs.getString("userid");
              		String username = rs.getString("name");
              		String password = rs.getString("password");
              		String memberclass = rs.getString("class");
              		if(memberclass.equals("admin")) continue;
              		String email = rs.getString("email");
              		out.println("<tr>");
              		out.println("<form class=\"\" action=\"modmember.jsp\" method=\"post\">");
              		out.println("<td>");
              		out.println("<input type=\"text\" class=\"form-control form-control-sm\" name=\"userid\" value='"+userid+"' required>");
              		out.println("</td>");
              		out.println("<td>");
              		out.println("<input type=\"text\" class=\"form-control form-control-sm\" name=\"password\" value='"+password+"' required>");
              		out.println("</td>");
              		out.println("<td>");
              		out.println("<input type=\"text\" class=\"form-control form-control-sm\" name=\"username\" value='"+username+"' required>");
              		out.println("</td>");
              		out.println("<td>");
              		out.println("<select class=\"custom-select custom-select-sm\" name=\"select_class\">");
              		if(memberclass.equals("seller")){
                  		out.println("<option value=\"buyer\">Buyer</option>");
                  		out.println("<option value=\"seller\" selected>Seller</option>");
              		}
              		else{
                  		out.println("<option value=\"buyer\" selected>Buyer</option>");
                  		out.println("<option value=\"seller\">Seller</option>");
              		}
              		out.println("</select>");
              		out.println("</td>");
              		out.println("<td>");
              		out.println("<input type=\"email\" class=\"form-control form-control-sm\" name=\"email\" value='"+email+"' required>");
              		out.println("</td>");
              		out.println("<td>");
              		out.println("<button type=\"submit\" class=\"btn btn-outline-dark btn-sm\" name=\"mod_button\">Mod</button>");
              		out.println("<button type=\"submit\" class=\"btn btn-outline-dark btn-sm\" name=\"del_button\">Del</button>");
              		out.println("</td>");
              		out.println("<input type=\"hidden\" name=\"original\" value='"+userid+"'>");
              		out.println("</form>");
              		out.println("</tr>");
              	}
              	else break;
          	}
        } catch (Exception e) {
          		System.out.println(e);
        }
        %>
      </tbody>
    </table>
  </div>

  <!--Bootstrap js-->
  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>

</html>
