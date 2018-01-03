<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
	$(document).ready(function(){
		$("#btnLogin").click(function(){
			var mId = $("#mId").val();
			var mPassword = $("#mPassword").val();
			
			$.ajax({
				url: "/member/procLogin",
				type: "post",
				dataType: "json",
				data:{"mId":mId, "mPassword":mPassword},
				success: function(data){
					if(data.result == "200") {
						location.href="/member/loginComplete";	
					} else {
						location.href="/member/loginForm";
					}
					
				},
				error: function(data){
					console.log(data);
					
				}	
			});
			
		});
	});
</script>
</head>
<body>
<input type="text" id="mId" name="mId" /> <br>
<input type="password" id="mPassword" name="mPassword" /> <br>
<button type="button" id="btnLogin" >로그인</button>
</body>
</html>