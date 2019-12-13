<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="com.oreilly.servlet.*" 
    import="com.oreilly.servlet.multipart.*" import="java.io.*"
    import="java.sql.*"%>
<%
int test_id = 4;
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
try{
	Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL database connection 
	Connection conn = DriverManager
		.getConnection("jdbc:mysql://localhost:3306/webproject?" + "user=root&password=root");
	PreparedStatement pst = conn.prepareStatement("select * from product where prid='"+test_id+"'");
	ResultSet rs = pst.executeQuery();
	if(rs.next()){
		price = rs.getInt("price");
		phone = rs.getString("phone");
		prname = rs.getString("prname");
		status = rs.getString("status");
		image_type = rs.getString("image");
		path = path + Integer.toString(test_id) + image_type;
		place = rs.getString("place");
		if(status.equals("auction")){
			due = rs.getString("due");
			dues = due.split(" ");
			times = dues[1].split(":");
		}
	}
}catch(Exception e){
	System.out.println(e);
}
%>
<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <title></title>
  <script type="text/javascript" src="uploadProduct.js">
  </script>
  <link rel="stylesheet" href="../css/uploadProduct.css">
</head>

<body>
  <form class="fileupload" enctype="multipart/form-data" action="" method="post">
    <div class="upload_base">
      <div class="product_photo">
        <input type="file" name="uploadfile" id="uploadfile" onchange="showImage()">
        <br><br>
        <img src="<%=path%>" id="show_image" width="350em">
        <script type="text/javascript">
          function showImage() {
            var imageBox = document.getElementById("show_image");
            var uploadedFile = document.getElementById("uploadfile").files[0];
            var reader = new FileReader();
            reader.onloadend = function() {
              imageBox.src = reader.result;
            };
            if (uploadedFile) {
              reader.readAsDataURL(uploadedFile);
            } else {
              //imageBox.src = "";
            };
          }
        </script>
        <br>
      </div>
      <div class="product_input">
        <label for="product_name">Product Name:</label>
        <input type="text" name="product_name" id="product_name" maxlength="255" value="<%=prname%>">
        <br>
        <label for="product_price">Price:</label>
        <input type="number" name="product_price" id="product_price" maxlength="255" value="<%=price%>">
        <br>
        <label for="phone_number">Phone Number:</label>
        <input type="number" name="phone_number" id="phone_number" maxlength="255" value="<%=phone%>">
        <br>
        <label for="trading_place">Trading Place:</label>
        <input type="text" name="trading_place" id="trading_place" maxlength="255" value="<%=place%>">
        <br>
        <input type="radio" name="sell_type" value="flea_market" onclick="is_not_auction()" <%
        if(!status.equals("auction")) out.println("checked");
        %>>Flea Market</input>
        <input type="radio" name="sell_type" value="auction" onclick="is_auction()" <%
        if(status.equals("auction")) {out.println("checked");}
        %>>Auction</input>
        <br>
        <div class="auction_input" id="auction_input">
          <label for="expiration_date" id="exp_label">Expiration Date:</label>
          <input type="date" name="expiration_date" id="exp_date" value="<%=dues[0]%>">
          <br>Expiration Time:
          <select class="select_time" name="select_time">
            <option value="0" <%if(times[0].equals("00")) out.println("selected");%>>00</option>
            <option value="1" <%if(times[0].equals("01")) out.println("selected");%>>01</option>
          </select>
          :
          <select class="select_min" name="select_min">
            <option value="0" <%if(times[1].equals("00")) out.println("selected ");%>>00</option>
            <option value="1" <%if(times[1].equals("01")) out.println("selected ");%>>01</option>
          </select>
        </div>
        <script type="text/javascript">
          var auction_input = document.getElementById("auction_input");
          auction_input.style.display = "none";

          function is_auction() {
            auction_input.style.display = "block";
          }

          function is_not_auction() {
            auction_input.style.display = "none";
          }
        </script>
        <%
        if(status.equals("auction")) out.println("<script>is_auction()</script>");
        %>
        <br>
        <input type="submit" value="Registration" id="submit_button">
      </div>
    </div>
  </form>
</body>

</html>
