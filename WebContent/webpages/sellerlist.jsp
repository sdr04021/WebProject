<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*" import="java.util.*" import="java.text.*"%>
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
%>

<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <title>Product List</title>
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
            <a class="nav-link active" href="sellerlist.jsp">Product List<span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="uploadProduct.jsp">Register Product</a>
          </li>
        </ul>
        <div class="flex-shrink-1 flex-grow-0 order-last">
          <button type="button" class="btn btn-outline-light" name="button" onClick="location.href='logout.jsp'"">Log out</button>
        </div>
      </div>
    </nav>
  </div>

  <!--Table for Product List-->
  <div class="table-responsive">
    <h2>Product List</h2>
    <table class="table table-sm table-striped table-hover">
      <thead class="thead-dark">
        <tr>
          <th scope="col">Name</th>
          <th scope="col">Current Price</th>
          <th scope="col">Wishes</th>
          <th scope="col">Status</th>
          <th scope="col">History</th>
          <th scope="col">Product Page</th>
        </tr>
      </thead>
      <tbody>
      	<%
      	try{
          	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
          	Connection conn = DriverManager
          		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
          	
            //------------------------Auction Purchase Updater---------------------------------------
            SimpleDateFormat myFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            java.util.Date today = new java.util.Date();
            PreparedStatement pst = conn.prepareStatement("select * from product where status = 'auction'");
            ResultSet rs = pst.executeQuery();
            while(true){
            	if(rs.next()){
            		java.util.Date due = myFormat.parse(rs.getString("due"));
            		long gap = due.getTime() - today.getTime();
            		if(gap<0){
            			int prid = rs.getInt("prid");
            			pst = conn.prepareStatement("select * from history where prid="+prid+" order by price desc");
            			ResultSet rs_2 = pst.executeQuery();
            			if(rs_2.next()){ // change product status to purchased
            				String maxBidder = rs_2.getString("userid");
            				String maxPrice = rs_2.getString("price");
            				pst = conn.prepareStatement("update product set price="+maxPrice+" where prid="+prid+"");
            				pst.executeUpdate();
            				//new purchase info
            				pst = conn.prepareStatement("insert into purchase(userid, prid) values ('"+maxBidder+"',"+prid+")");
            				pst.executeUpdate();
            				//delete purchased product form users' wishlist
            				pst = conn.prepareStatement("delete from wishlist where prid='"+prid+"'");
            				pst.executeUpdate();
            				//change product status to purchased
            				pst = conn.prepareStatement("update product set status = \"purchased\" where prid="+prid+"");
            				pst.executeUpdate();
            			}
            			else{
            				//delete expired product form users' wishlist
            				PreparedStatement ps = conn.prepareStatement("delete from wishlist where prid='"+prid+"'");
            				ps.executeUpdate();
            				// change product status to expired
            				ps = conn.prepareStatement("update product set status = \"expired\" where prid="+prid+"");
            				ps.executeUpdate();
            			}
            		}
            	}
            	else break;
            }
            //-------------------------------------------------------------------------------------------
          	
          	pst = conn.prepareStatement("select * from product where sellerid ='"+userid+"'");
          	rs = pst.executeQuery();
          	int count = 1;
          	while(true){
          		if(rs.next()){
          			//load product information
          			int prid = rs.getInt("prid");
          			int wishes = 0;
          			String price = rs.getString("price");
          			String phone = rs.getString("phone");
          			String prname = rs.getString("prname");
          			String status = rs.getString("status");
          			pst = conn.prepareStatement("select count(*) from wishlist where prid="+prid+"");
          			ResultSet rst = pst.executeQuery();
          			if(rst.next()) wishes = rst.getInt("count(*)");
          			out.println("<tr>");
          			out.println("<td>"+prname+"</td>");
          			out.println("<td>"+price+"</td>");
          			out.println("<td>"+wishes+"</td>");
          			out.println("<td>"+status+"</td>");
          			out.println("<td><button type=\"button\" class=\"btn btn-info btn-sm\" data-toggle=\"modal\" data-target=\"#exampleModal"+count+"\" name=\"button\">Watch</button></td>");
          			out.println("<div class=\"modal fade\" id=\"exampleModal"+count+"\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"exampleModalLabel"+count+"\" aria-hidden=\"true\">");
          			out.println("<div class=\"modal-dialog\" role=\"document\">");
          			out.println("<div class=\"modal-content\">");
          			out.println("<div class=\"modal-header\">");
          			out.println("<h5 class=\"modal-title\" id=\"exampleModalLabel"+count+"\">History</h5>");
          			out.println("<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\">");
          			out.println("<span aria-hidden=\"true\">&times;</span>");
          			out.println("</button>");
          			out.println("</div>");
          			out.println("<div class=\"modal-body\">");
          			//load history of auction product
          			pst = conn.prepareStatement("select * from history where prid="+prid+"");
          			ResultSet rs_2 = pst.executeQuery();
          			out.println("<ul class=\"list-group\">");
          			while(true){
              			if(rs_2.next()){
              				String bidder = rs_2.getString("userid");
              				String bid_price = rs_2.getString("price");
              				out.println("<li class=\"list-group-item\"><b>"+bidder+"</b> : "+bid_price+"</li>");
              			}
              			else break;
          			}
          			out.println("</ul>");
          			out.println("</div>");
          			out.println("<div class=\"modal-footer\">");
          			out.println("<button type=\"button\" class=\"btn btn-secondary\" data-dismiss=\"modal\">Close</button>");
          			out.println("</div>");
          			out.println("</div>");
          			out.println("</div>");
          			out.println("</div>");
          			out.println("<td><button type=\"button\" class=\"btn btn-primary btn-sm\" name=\"mod_button\" onClick=\"location.href='product.jsp?prid="+prid+"'\">Go</button></td>");
          			out.println("</tr>");
          		}
          		else break;
              	count++;
          	}
      	} catch(Exception e){
      		System.out.println(e);
      	}
      	%>
      </tbody>
    </table>
  </div>
  
  <!-- footer -->
  <footer class="page-footer font-smallpt-4">
  	<hr>
  	<div class="footer-copyright text-center pb-3"> &copy 2019 SKKU Web Programming Lab t10</div>
  </footer>

  <!--Bootstrap js-->
  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>

</html>
