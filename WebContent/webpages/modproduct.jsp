<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR" import="com.oreilly.servlet.*"
	import="com.oreilly.servlet.multipart.*" import="java.io.*"
	import="java.sql.*"%>
<%
	//Check if user is seller
	if (request.getSession(false) == null) {
		response.sendRedirect("login.jsp");
	}
	String userclass = (String) session.getAttribute("class");
	String userid = (String) session.getAttribute("userid");
	if (userclass == null || !userclass.equals("seller")) {
		response.sendRedirect("login.jsp");
	}
	int prid = Integer.parseInt((String) request.getParameter("prid"));
%>

<%
	int price = 0;
	String path = "../images/";
	String phone = "";
	String prname = "";
	//String sellerid = "";
	String status = "";
	String due = "";
	String dues[] = null;
	String times[] = null;
	String image_type = "";
	String place = "";
	boolean isAuction = false;
	try {
		Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
		Connection conn = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
		PreparedStatement pst = conn.prepareStatement("select * from product where prid=" + prid + "");
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			price = rs.getInt("price");
			phone = rs.getString("phone");
			prname = rs.getString("prname");
			status = rs.getString("status");
			image_type = rs.getString("image");
			path = path + Integer.toString(prid) + image_type;
			place = rs.getString("place");
			if (status.equals("auction")) {
				isAuction = true;
				due = rs.getString("due");
				dues = due.split(" ");
				times = dues[1].split(":");
			}
		}
	} catch (Exception e) {
		System.out.println(e);
	}
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
<meta charset="utf-8">
<title></title>
<link rel="stylesheet" href="../css/navbarfix.css">
<!--Bootstrap CSS-->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
	integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
	crossorigin="anonymous">
</head>

<body>
	<!--Navigation Bar-->
	<div class="container">
		<nav
			class="navbar fixed-top navbar-expand-md navbar-dark bg-dark shadow-sm p-3 mb-5">
			<span class="navbar-brand mb-0 h1">Flea Market</span>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarTogglerDemo03"
				aria-controls="navbarTogglerDemo03" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarTogglerDemo03">
				<ul class="navbar-nav mr-auto mt-2 mt-lg-0">
					<li class="nav-item"><a class="nav-link" href="sellerlist.jsp">Product
							List<span class="sr-only">(current)</span>
					</a></li>
					<li class="nav-item"><a class="nav-link"
						href="uploadProduct.jsp">Register Product</a></li>
				</ul>
				<div class="flex-shrink-1 flex-grow-0 order-last">
					<button type="button" class="btn btn-outline-light" name="button"
						onClick="location.href='https://www.naver.com'">Log out</button>
				</div>
			</div>
		</nav>
	</div>

	<!--Product Upload-->
	<div class="container">
		<form class="fileupload" enctype="multipart/form-data" action="moding.jsp?prid=<%=prid%>" method="post">
			<div class="row mb-2">
				<div class="jumbotron col-sm-6">
          			<div class="custom-file">
						<input type="file" class="custom-file-input" name="uploadfile" id="uploadfile"
							aria-describedby="inputGroupFileAddon01" onchange="showImage()" accept=".gif, .jpg, .png">
						<label class="custom-file-label" for="inputGroupFile01">Choose Image</label>
					</div><br><br>
					<img src="<%=path%>" id="show_image" class="img-thumbnail mx-auto d-block">
					<script type="text/javascript">
						function showImage() {
							var imageBox = document
									.getElementById("show_image");
							var uploadedFile = document
									.getElementById("uploadfile").files[0];
							var reader = new FileReader();
							reader.onloadend = function() {
								imageBox.src = reader.result;
							};
							if (uploadedFile) {
								reader.readAsDataURL(uploadedFile);
							} else {
								//imageBox.src = "";
							}
							;
						}
					</script>
					<br>
				</div>
				<div class="col-sm-6">
					<label for="product_name">Product Name:</label>
					<input type="text" class="form-control" name="product_name" id="product_name" maxlength="45" required
						value="<%=prname%>">
					<br>
					<label for="product_price">Price:</label>
					<input type="number" class="form-control" name="product_price" id="product_price" min="0" max="2147483647" required value="<%=price%>">
					<br>
					<label for="phone_number">Phone Number:</label>
					<input type="number" class="form-control" name="phone_number" id="phone_number" maxlength="34" required value="<%=phone%>">
					<br>
					<label for="trading_place">Trading Place:</label>
					<input type="text" class="form-control" name="trading_place" id="trading_place" maxlength="45" required value="<%=place%>">
					<br>
					<div class="form-check form-check-inline">
						<input type="radio" name="sell_type" id="sell_type_1" class="form-check-input" value="fleaMarket" onclick="is_not_auction()"
							<%if (!status.equals("auction")) out.println("checked");%>>
						<label class="form-check-label" for="sell_type_1">Flea Market</label>
					</div>
					<div class="form-check form-check-inline">
						<input type="radio" name="sell_type" id="sell_type_2" class="form-check-input" value="auction" onclick="is_auction()"
							<%if (status.equals("auction")) { out.println("checked"); }%>>
						<label class="form-check-label" for="sell_type_2">Auction</label>
					</div>
					<br><br>
					<div class="auction_input" id="auction_input">
						<label for="expiration_date" id="exp_label">Expiration Date:</label>
						<input type="date" class="form-control" name="expiration_date" id="exp_date" <%if(isAuction) out.println("value='"+dues[0]+"'");%>>
						<br>
						<label for="select_time">Expiration Time:</label>
						<select class="custom-select custom-select-sm" style="width:100px" name="select_time">
						<%
							for(int i=0; i<24; i++){
								String snum = "";
								String si = Integer.toString(i);
								if(i<10) snum = "0";
								snum = snum + si;
								if(isAuction&&(times[0].equals(snum))){
									out.println("<option value='"+si+"' selected>"+snum+"</option>");
								}
								else{
									out.println("<option value='"+si+"'>"+snum+"</option>");
								}
							}
						%>
						</select> 
						: 
						<select class="custom-select custom-select-sm" style="width:100px" name="select_min">
						<%
							for(int i = 0; i<60; i++){
								String snum = "";
								String si = Integer.toString(i);
								if(i<10) snum = "0";
								snum = snum + si;
								if(isAuction&&(times[1].equals(snum))){
									out.println("<option value='"+si+"' selected>"+snum+"</option>");
								}
								else{
									out.println("<option value='"+si+"'>"+snum+"</option>");
								}
							}
						%>
						</select>
					</div>
					<script type="text/javascript">
						var auction_input = document
								.getElementById("auction_input");
						auction_input.style.display = "none";

						function is_auction() {
							auction_input.style.display = "block";
						}

						function is_not_auction() {
							auction_input.style.display = "none";
						}
					</script>
					<%
						if (status.equals("auction"))
							out.println("<script>is_auction()</script>");
					%>
					<br>
					<input type="submit" class="btn btn-primary" value="Registration" id="submit_button">
				</div>
			</div>
		</form>
	</div>
	
	<!--js-->
  	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
  	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>

</html>
