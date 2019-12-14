<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.sql.*"%>
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
  <title></title>
  <script type="text/javascript" src="uploadProduct.js">
  </script>
  <link rel="stylesheet" href="../css/navbarfix.css">
  <!--Bootstrap CSS-->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
</head>

<body>
  <!--Navigation Bar-->
  <div class="container">
    <nav class="navbar fixed-top navbar-expand-md navbar-dark bg-dark shadow-sm p-3 mb-5">
      <span class="navbar-brand mb-0 h1">Flea Market</span>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo03" aria-controls="navbarTogglerDemo03" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarTogglerDemo03">
        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="sellerlist.jsp">Product List<span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link active" href="uploadProduct.jsp">Register Product</a>
          </li>
        </ul>
        <div class="flex-shrink-1 flex-grow-0 order-last">
          <button type="button" class="btn btn-outline-light" name="button" onClick="location.href='https://www.naver.com'">Log out</button>
        </div>
      </div>
    </nav>
  </div>

  <!--Product Upload-->
  <div class="container">
    <form class="fileupload" enctype="multipart/form-data" action="uploading.jsp" method="post">
      <div class="row mb-2">
        <div class="jumbotron col-sm-6">
          <div class="custom-file">
            <input type="file" required class="custom-file-input" name="uploadfile" id="uploadfile" aria-describedby="inputGroupFileAddon01" onchange="showImage()" accept=".gif, .jpg, .png">
            <label class="custom-file-label" for="inputGroupFile01">Choose Image</label>
          </div>
          <br><br>
          <img src="" id="show_image" class="img-thumbnail mx-auto d-block" alt=" ">
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
        <div class="col-sm-6">
          <label for="product_name">Product Name:</label>
          <input type="text" class="form-control" name="product_name" id="product_name" maxlength="45" required>
          <br>
          <label for="product_price">Price:</label>
          <input type="number" class="form-control" name="product_price" id="product_price" min="0" max="2147483647" required>
          <br>
          <label for="phone_number">Phone Number:</label>
          <input type="number" class="form-control" name="phone_number" id="phone_number" maxlength="45" required>
          <br>
          <label for="trading_place">Trading Place:</label>
          <input type="text" class="form-control" name="trading_place" id="trading_place" maxlength="45" required>
          <br>
          <div class="form-check form-check-inline">
            <input type="radio" name="sell_type" id="sell_type_1" class="form-check-input" value="fleaMarket" onclick="is_not_auction()" checked>
            <label class="form-check-label" for="sell_type_1">Flea Market</label>
          </div>
          <div class="form-check form-check-inline">
            <input type="radio" name="sell_type" id="sell_type_2" class="form-check-input" value="auction" onclick="is_auction()">
            <label class="form-check-label" for="sell_type_2">Auction</label>
          </div>
          <br>
          <br>
          <div class="auction_input" id="auction_input">
            <label for="expiration_date" id="exp_label">Expiration Date:</label>
            <input type="date" class="form-control" name="expiration_date" id="exp_date">
            <br>
            <label for="select_time">Expiration Time:</label>
            <select class="custom-select custom-select-sm" style="width:100px" name="select_time">
              <option value="0">00</option>
              <option value="1">01</option>
              <option value="2">02</option>
              <option value="3">03</option>
              <option value="4">04</option>
              <option value="5">05</option>
              <option value="6">06</option>
              <option value="7">07</option>
              <option value="8">08</option>
              <option value="9">09</option>
              <option value="10">10</option>
              <option value="11">11</option>
              <option value="12">12</option>
              <option value="13">13</option>
              <option value="14">14</option>
              <option value="15">15</option>
              <option value="16">16</option>
              <option value="17">17</option>
              <option value="18">18</option>
              <option value="19">19</option>
              <option value="20">20</option>
              <option value="21">21</option>
              <option value="22">22</option>
              <option value="23">23</option>
            </select>
            :
            <select class="custom-select custom-select-sm" style="width:100px" name="select_min">
              <option value="0">00</option><option value="1">01</option><option value="2">02</option>
              <option value="3">03</option><option value="4">04</option><option value="5">05</option>
              <option value="6">06</option><option value="7">07</option><option value="8">08</option>
              <option value="9">09</option><option value="10">10</option><option value="11">11</option>
              <option value="12">12</option><option value="13">13</option><option value="14">14</option>
              <option value="15">15</option><option value="16">16</option><option value="17">17</option>
              <option value="18">18</option><option value="19">19</option><option value="20">20</option>
              <option value="21">21</option><option value="22">22</option><option value="23">23</option>
              <option value="24">24</option><option value="25">25</option><option value="26">26</option>
              <option value="27">27</option><option value="28">28</option><option value="29">29</option>
              <option value="30">30</option><option value="31">31</option><option value="32">32</option>
              <option value="33">33</option><option value="34">34</option><option value="35">35</option>
              <option value="36">36</option><option value="37">37</option><option value="38">38</option>
              <option value="39">39</option><option value="40">40</option><option value="41">41</option>
              <option value="42">42</option><option value="43">43</option><option value="44">44</option>
              <option value="45">45</option><option value="46">46</option><option value="47">47</option>
              <option value="48">48</option><option value="49">49</option><option value="50">50</option>
              <option value="51">51</option><option value="52">52</option><option value="53">53</option>
              <option value="54">54</option><option value="55">55</option><option value="56">56</option>
              <option value="57">57</option><option value="58">58</option><option value="59">59</option>
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
