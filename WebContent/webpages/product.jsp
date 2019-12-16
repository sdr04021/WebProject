<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*" import="java.util.*" import="java.text.*"%>
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
int prid = Integer.parseInt((String)request.getParameter("prid"));
boolean wish = false; // is this product in wish list of buyer?
boolean isAuction = false; //is auction?
boolean isPurchased = false; //is purchased?
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <title></title>
  <link rel="stylesheet" href="../css/navbarfix.css">
  <!--Bootstrap CSS-->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
</head>

<body class="bg-light">
  <!--Navigation Bar-->
  <div class="container">
    <nav class="navbar fixed-top navbar-expand-md navbar-dark bg-dark shadow-sm p-3 mb-5">
      <span class="navbar-brand mb-0 h1">SKKU Flea Market</span>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo03" aria-controls="navbarTogglerDemo03" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarTogglerDemo03">
        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
          <li class="nav-item">
          	<%
          	if(userclass.equals("seller")){
          		out.println("<a class=\"nav-link\" href=\"sellerlist.jsp\">Product List<span class=\"sr-only\">(current)</span></a>");
          	}
          	else if(userclass.equals("buyer")){
          		out.println("<a class=\"nav-link\" href=\"search.jsp\">Search<span class=\"sr-only\">(current)</span></a>");
          	}
          	%>
          </li>
          <li class="nav-item">
          	<%
          	if(userclass.equals("seller")){
          		out.println("<a class=\"nav-link\" href=\"uploadProduct.jsp\">Register Product</a>");
          	}
          	else if(userclass.equals("buyer")){
          		out.println("<a class=\"nav-link\" href=\"mypage.jsp\">Mypage</a>");
          	}
          	%>
          </li>
        </ul>
        <div class="flex-shrink-1 flex-grow-0 order-last">
          <button type="button" class="btn btn-outline-light" name="button" onClick="location.href='logout.jsp'">Log out</button>
        </div>
      </div>
    </nav>
  </div>
  
  <%
  String img_src = "../images/";
  String price = "";
  String prname = "";
  String phone = "";
  String sellerid = "";
  String status = "";
  String image_type = "";
  String place = "";
  String due="";
  try{
    Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
    Connection conn = DriverManager
    	.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
    PreparedStatement pst = conn.prepareStatement("select * from product where prid ="+prid+"");
    ResultSet rs = pst.executeQuery();
    if(rs.next()){
		price = rs.getString("price");
		phone = rs.getString("phone");
		prname = rs.getString("prname");
		sellerid = rs.getString("sellerid");
		status = rs.getString("status");
		image_type = rs.getString("image");
		place = rs.getString("place");
		img_src = img_src + prid + image_type;
		if(status.equals("auction")){
			isAuction = true;
			due = rs.getString("due");
		}
		else if(status.equals("purchased")) isPurchased = true;
    }
    else out.println("ERROR");
    
    if(userclass.equals("buyer")){
        pst = conn.prepareStatement("select * from wishlist where userid='"+userid+"' and prid="+prid+"");
        rs = pst.executeQuery();
        if(rs.next()) wish = true;
    }
  } catch(Exception e){
	  System.out.println(e);
  }
  %>
  <!-- Product Information -->
  <div class="container">
    <div class="jumbotron pt-4 bg-white">
      <div class="row">
        <div class="col-sm">
          <img src="<%=img_src %>" class="img-thumbnail mx-auto d-block" alt="">
        </div>
        <div class="col-sm">
          <table class="table table-bordered">
            <tbody>
              <tr>
                <th class="table-light">Product Name</th>
                <td><%=prname %></td>
              </tr>
              <%
              	if(isAuction){
              		out.println("<tr>");
              		out.println("<th class=\"table-light\">Time Left</th>");
              		out.println("<td class=\"font-weight-bold\" id=\"timeleft\"></td>");
              		out.println("</tr>");
              	}
              %>
              <tr>
                <th class="table-light"><%if(isAuction) out.println("Current Price"); else out.println("Price");%></th>
                <td><%=price %></td>
              </tr>
              <tr>
                <th class="table-light">Seller | Phone</th>
                <td><%=sellerid + " | " + phone %></td>
              </tr>
              <tr>
                <th class="table-light">Trading Place</th>
                <td><%=place %></td>
              </tr>
            </tbody>
          </table>
          <div class="row">
            <div class="col-sm">
            <%
            	if(!isPurchased){
              		if(userid.equals(sellerid)){
              			out.println("<button type=\"button\" name=\"button\" class=\"btn btn-lg btn-primary\" style=\"width:100%\" onClick=\"location.href='modproduct.jsp?prid="+prid+"'\">Edit</button>");
              		}
              		else if(userclass.equals("buyer")){
              			if(wish) out.println("<button type=\"button\" name=\"button\" class=\"btn btn-lg btn-info\" style=\"width:100%\" onClick=\"location.href='deletewishlist.jsp?prid="+prid+"'\">Delete from wish list</button>");
              			else out.println("<button type=\"button\" name=\"button\" class=\"btn btn-lg btn-outline-info\" style=\"width:100%\" onClick=\"location.href='putwishlist.jsp?prid="+prid+"'\">Put wish list</button>");
              		}
            	}
            %>
            </div>
            <div class="col-sm">
            <% 
            	if(!isPurchased){
              		if(userid.equals(sellerid)){
              			out.println("<button type=\"button\" name=\"button\" class=\"btn btn-lg btn-danger\" style=\"width:100%\" onClick=\"location.href='cancelproduct.jsp?prid="+prid+"'\">Cancel</button>");
              		}
              		else if(userclass.equals("buyer")){
              			if(isAuction){
              				out.println("<form class=\"form-inline\" action=\"\" method=\"post\">");
              				out.println("<div class=\"input-group input-group-lg\">");
              				out.println("<input type=\"number\" class=\"form-control\" name=\"price\" placeholder=\"Price\" min="+price+" max=\"2147483647\" required>");
              				out.println("<div class=\"input-group-append\">");
              				out.println("<button type=\"submit\" id=\"bid_btn\" class=\"btn btn-primary\" name=\"button\">Bid</button>");
              				out.println("</div>");
              				out.println("</div>");
              				out.println("</form>");
              			}
              			else out.println("<button type=\"button\" name=\"button\" class=\"btn btn-lg btn-primary\" style=\"width:100%\" onClick=\"location.href='purchase.jsp?prid="+prid+"'\">Buy</button>");
              		}
            	}
            %>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script>
    <%
    if(isAuction){
    	String due_datetime[] = due.split(" ");
    	String due_date[] = due_datetime[0].split("-");
    	String due_time[] = due_datetime[1].split(":");
    	due_date[1] = Integer.toString(Integer.parseInt(due_date[1]) - 1);
    	out.println("var timeleft = document.getElementById(\"timeleft\");");
    	out.println("var bidbutton = document.getElementById(\"bid_btn\");");
    	out.println("function clock(){");
    	out.println("var dueDate = new Date("+due_date[0]+","+due_date[1]+","+due_date[2]+","+due_time[0]+","+due_time[1]+","+due_time[2]+");");
    	out.println("var curDate = new Date();");
    	out.println("var sec = 1000;");
    	out.println("var min = sec * 60;");
    	out.println("var hour = min * 60;");
    	out.println("if ((dueDate.getTime() - curDate.getTime()) > 0) {");
    	out.println("var gap = dueDate.getTime() - curDate.getTime();");
    	out.println("var left_hour = Math.floor(gap / hour);");
    	out.println("var left_min = Math.floor(((gap % hour) / min));");
    	out.println("var left_sec = Math.floor((((gap % hour) % min) / sec));");
    	out.println("if(left_hour<10) left_hour = \"0\" + String(left_hour);");
    	out.println("if(left_min<10) left_min = \"0\" + String(left_min);");
    	out.println("if(left_sec<10) left_sec = \"0\" + String(left_sec);");
    	out.println("timeleft.innerText = left_hour + \":\" + left_min + \":\" + left_sec;");
    	out.println("} else {");
    	out.println("timeleft.innerText = \"Expired\";");
    	out.println("bidbutton.disabled = true;");
    	out.println("}");
    	out.println("}");
    	out.println("function update_clock() {");
    	out.println("clock();");
    	out.println("setInterval(clock, 1000);");
    	out.println("}");
    	out.println("update_clock();");
    }
    %>           
    </script>
  </div>
  
  <!--Bootstrap js-->
  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>

</html>
