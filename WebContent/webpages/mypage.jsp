<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*" import="java.util.*" import="java.text.*"%>
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
%>

<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <title>My Page</title>
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
            <a class="nav-link" href="search.jsp">Search<span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link active" href="mypage.jsp">Mypage</a>
          </li>
        </ul>
        <div class="flex-shrink-1 flex-grow-0 order-last">
          <button type="button" class="btn btn-outline-light" name="button" onClick="location.href='logout.jsp'">Log out</button>
        </div>
      </div>
    </nav>
  </div>

  <div class="container">
    <div class="jumbotron pt-3 pb-3 mb-1 bg-light">
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
        		//if(gap<0) System.out.println("passed");
        		//else System.out.println("not yet");
        		if(gap<0){
        			int prid = rs.getInt("prid");
        			pst = conn.prepareStatement("select * from history where prid="+prid+" order by price desc");
        			ResultSet rs_2 = pst.executeQuery();
        			if(rs_2.next()){ // change product status to purchased
        				String maxBidder = rs_2.getString("userid");
        				//new purchase info
        				pst = conn.prepareStatement("insert into purchase(userid, prid) values ('"+maxBidder+"',"+prid+")");
        				pst.executeUpdate();
        				//delete purchased product form users wishlist
        				pst = conn.prepareStatement("delete from wishlist where prid='"+prid+"'");
        				pst.executeUpdate();
        				//change product status to purchased
        				pst = conn.prepareStatement("update product set status = \"purchased\" where prid="+prid+"");
        				pst.executeUpdate();
        			}
        			else{
        				//delete expired product form users wishlist
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
        
        //load products in wish list
    	out.println("<h3 class=\"mb-4\">Wish List</h3>");
        pst = conn.prepareStatement("select * from wishlist where userid ='"+userid+"'");
        rs = pst.executeQuery();
        
        int count = 0;
        while(true){
            if(rs.next()){
                int prid = rs.getInt("prid");
                pst = conn.prepareStatement("select * from product where prid="+prid+"");
                ResultSet product = pst.executeQuery();
                if(product.next()){
            		String status = product.getString("status");
            		if(status.equals("expired")) continue;
            		String prname = product.getString("prname");
            		String price = product.getString("price");
            		String img_type = product.getString("image");
            		String img_src = "../images/" + Integer.toString(prid) + img_type;
            		String seller = product.getString("sellerid");
            		
               		if((count%5)==0){
            			out.println("<div class=\"card-deck mb-3 mx-auto\">");
            		}
            		out.println("<div class=\"card bg-white border-white shadow\">");
            		out.println("<div class=\"d-flex flex-grow-1 align-items-center\">");
            		out.println("<a href=\"product.jsp?prid="+Integer.toString(prid)+"\" class=\"stretched-link\"\"><img src=\""+img_src+"\" class=\"card-img-top\" alt=\"\"></a>");
            		out.println("</div>");
            		out.println("</div>");
            		if((count%5)==4){
            			out.println("</div>");
            		}
                }
            }
            else{
               	if(count==0) out.println("<h5 class = \"text-secondary\">Your wishlist is empty</h5>");
               	if(((count%5)!=4)&&(count!=0)) out.println("</div>");
            	break;
            }
            count++;
        }
        out.println("<br>");
        
        //load purchased info
        out.println("<h3 class=\"mb-4\">Purchased</h3>");
        pst = conn.prepareStatement("select * from purchase where userid ='"+userid+"'");
        rs = pst.executeQuery();
        
        int total_price = 0;
        count = 0;
        while(true){
        	if(rs.next()){
                int prid = rs.getInt("prid");
                pst = conn.prepareStatement("select * from product where prid="+prid+"");
                ResultSet product = pst.executeQuery();
                
                if(product.next()){
             		String prname = product.getString("prname");
             		String price = product.getString("price");
             		String img_type = product.getString("image");
             		String img_src = "../images/" + Integer.toString(prid) + img_type;
             		String seller = product.getString("sellerid");
             		total_price+=Integer.parseInt(price);
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
        	}
        	else{
               	if(count==0) out.println("<h5 class = \"text-secondary\">No Products</h5>");
               	if(((count%5)!=4)&&(count!=0)) {
               		out.println("<div class=\"container mt-3\"><h5>Total: "+total_price+"</h5></div>");
               		out.println("</div>");
               	}
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
