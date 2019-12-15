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

//Get
String product_name = (String)request.getParameter("name");
if(product_name == null) product_name = "";
String product_seller = (String)request.getParameter("seller");
if(product_seller == null) product_seller = "";
String min_price = (String)request.getParameter("min");
if(min_price==null) min_price="";
String max_price = (String)request.getParameter("max");
if(max_price==null) max_price="";
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

<body>
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
            <a class="nav-link active" href="search.jsp">Search<span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="mypage.jsp">Mypage</a>
          </li>
        </ul>
        <div class="flex-shrink-1 flex-grow-0 order-last">
          <button type="button" class="btn btn-outline-light" name="button" onClick="location.href='logout.jsp'">Log out</button>
        </div>
      </div>
    </nav>
  </div>

  <!-- Search&Result -->
  <div class="container">
    <div class="jumbotron pt-3 bg-light">
    
      <!-- Search Inputs -->
      <h3 class="mb-4">Search</h3>
      <form class="form-row mb-4" action="search.jsp" method="get">
        <div class="col">
          <input type="text" name="name" class="form-control" placeholder="Product" maxlength="45" value="<%=product_name%>">
        </div>
        <div class="col-3">
          <input type="text" name="seller" class="form-control" placeholder="Seller" maxlength="45" value="<%=product_seller%>">
        </div>
        <div class="col-2">
          <input type="number" name="min" placeholder="Minimum Price" class="form-control" min="0" max="2147483647" value="<%=min_price%>">
        </div>
        <span class="py-1"><b>~</b></span>
        <div class="col-2">
          <input type="number" name="max" placeholder="Maximum Price" class="form-control" min="0" max="2147483647" value="<%=max_price%>">
        </div>
        <div class="col-1">
          <button type="submit" class="btn btn-primary" name="button">Search</button>
        </div>
      </form>
      
      <!-- Product cards -->
      <h3 class="mb-4">Products</h3>
      <%
      try{
        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
        Connection conn = DriverManager
        		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root"); 
        String searchQuery = "select * from product where prname like \'%"+product_name+"%\' and sellerid like \'%"+product_seller+"%\'";
        if(min_price!=""){
        	searchQuery = searchQuery + "and (price>="+Integer.parseInt(min_price)+"";        
        	if(max_price!="") searchQuery = searchQuery + " and price<="+Integer.parseInt(max_price)+"";
        	searchQuery = searchQuery + ")";
        }
        else if(max_price!="") searchQuery = searchQuery + "and (price<="+Integer.parseInt(max_price)+")";
        
        PreparedStatement pst = conn.prepareStatement(searchQuery);
        ResultSet rs = pst.executeQuery();
        
        int count = 0;
        while(true){
        	if(rs.next()){
        		int prid = rs.getInt("prid");
        		String prname = rs.getString("prname");
        		String price = rs.getString("price");
        		String img_type = rs.getString("image");
        		String img_src = "../images/" + Integer.toString(prid) + img_type;
        		String seller = rs.getString("sellerid");
        		if((count%5)==0){
        			out.println("<div class=\"card-deck mb-3 mx-auto\">");
        		}
        		out.println("<div class=\"card bg-white border-white shadow\">");
        		out.println("<div class=\"d-flex flex-grow-1 align-items-center\">");
        		out.println("<img src=\""+img_src+"\" class=\"card-img-top\" alt=\"\">");
        		out.println("</div>");
        		out.println("<div class=\"card-body d-flex flex-shrink-1 flex-grow-0 order-last flex-column-reverse\">");
        		out.println("<a href=\"product.jsp?prid="+Integer.toString(prid)+"\" class=\"btn btn-dark stretched-link\" style=\"width:100%\">"+price+"</a>");
        		out.println("<div>");
        		out.println("<h5 class=\"card-title\">"+prname+"<span class=\"badge badge-pill badge-primary ml-1\">"+seller+"</span></h5>");
        		out.println("</div>");
        		out.println("</div>");
        		out.println("</div>");
        		if((count%5)==4){
        			out.println("</div>");
        		}
        	}
        	else {
        		if(count==0) out.println("<h5 class = \"text-secondary\">No Result</h5>");
        		if((count%5)!=4) out.println("</div>");
        		break;
        	}
        	count++;
        }
      } catch(Exception e){
    	  System.out.println(e);
      }
      %>
    </div>
  </div>

  <!--Bootstrap js-->
  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>

</html>
