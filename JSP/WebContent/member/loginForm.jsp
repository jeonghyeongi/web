<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<!doctype html>
<html>
	<head>
		<jsp:include page="/include/top.jsp" />
				
		<script type="text/javascript">
			//로딩 타입
			var current_effect = 'bounce';
			
			function run_waitMe(effect){
				$("#frmLogin").waitMe({
					effect: "win8",
					text: "잠시만 기다려주세요",
					bg: "rgba(255,255,255,0.7)",
					color: "#000",
					maxSize: "",
					waitTime: -1,
					source: "",
					textPos: "vertical",
					fontSize: "",
				});
			}

			function doLogin(){

				$("#btnLogin").click(function(){
					
					$("#frmLogin").validate({
						rules:{
							inputId: { 
										required: true,
										minlength: 5
									 },		
							inputPw: {
										required: true,
										minlength: 5	
									}

						},
						messages:{
							inputId: {
								required: "아이디를 입력해주세요",
								minlength: "아이디는 5자이상입니다."
							},
							inputPw: {
								required: "비밀번호를 입력해주세요",
								minlength: "비밀번호는 5자이상입니다."
							}
						},
						submitHandler: function(form){
							var inputId = $("#inputId").val();
							var inputPw = $("#inputPw").val();
							//로딩 시작
						run_waitMe(current_effect);
							$.ajax({
								url: "procLogin.jsp",
								type: "post",
								dataType: "json",
								data: {"inputId":inputId, "inputPw":inputPw},
								success: function(data){
									//로딩 종료
									$("#frmLogin").waitMe("hide");
									if(data.result == "200"){
										alert("로그인되셨습니다.");
										location.href="MyMain.jsp";
									} else {
										alert(1);
										alert(data.desc);
									}

									var isCheck = $("#saveId").prop("checked");

									if(isCheck){
										$.cookie("inputId", inputId);
									}else{
										$.removeCookie("inputId"); 
									}

								},
								error: function(data){
									alert("잠시후에 다시 이용해주세요.");
								}	
							});
							
						}
					});
				});
			}

			$(document).ready(function(){
				var inputId = $.cookie("inputId");
				
				if(inputId != undefined){
					$("#saveId").prop("checked","checked");
					$("#inputId").val(inputId);
				}

				doLogin();
						
			});
		</script>
		<style>
			#frmLogin label.error { color:red }
		</style>
	</head>

	<body>
	<!-- Horizontal Form -->
          <div class="box box-info">
            <div class="box-header with-border">
              <h3 class="box-title">로그인3</h3>
            </div>
			<form class="form-horizontal" id="frmLogin">
				<div class="box-body">
					<div class="form-group">
						<label for="inputId" class="col-sm-2 control-label">아이디</label>

						<div class="col-sm-4">
							<input type="text" class="form-control" id="inputId" placeholder="아이디를 입력해주세요" name="inputId" >
						</div>
					</div>

					<div class="form-group">
						<label for="inputPw" class="col-sm-2 control-label">비밀번호</label>

						<div class="col-sm-4">
							<input type="text" class="form-control" id="inputPw" placeholder="비밀번호를 입력해주세요" name="inputPw">
						</div>
					</div>
					<!--아이디 저장 시작-->
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<div class="checkbox">
								<label>
									<input type="checkbox" id="saveId" value="save">아이디 저장
								</label>
							</div>
						</div>
					</div>
					<!--아이디 저장 끝-->

					<!-- 로그인 버튼 시작-->
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-4">
							<button type="submit" class="btn btn-block btn-success btn-lg" id="btnLogin">로그인</button>
						</div>
					</div>
				    <!-- 로그인 버튼 끝-->

					<!-- 페이스북 로그인 버튼시작-->
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-4">
							<div class="fb-login-button" data-max-rows="1" data-size="large" data-button-type="login_with" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false" onlogin="checkLoginState();"></div>
						</div>
					</div>
					<!-- 페이스북 로그인 버튼 끝-->

				</div>
				<div>
			</form>
			
           
          </div>

	</body>
	<script>

	function statusChangeCallback(response){
		console.log(response);
		if(response.status == "connected"){
			FB.api("/me", function(data){
				console.log(data);
				$.ajax({
					url: "procLogin.jsp",
					type: "post",
					data: {"inputId" : data.name, "inputPw":""},
					success: function(data){
						console.log(data);
						if(data.result == "200"){
							location.href="MyMain.jsp";
						} else {
							alert(data.desc);
						}
					},
					error: function(data){
					
					}
				});
			});
		} else {
			alert("앱에 로그인해주세요. \n 관리자에게 문의바랍니다.");
		}
	}

	function checkLoginState() {
	  FB.getLoginStatus(function(response) {
		statusChangeCallback(response);
	  });
	}

  window.fbAsyncInit = function() {
    FB.init({
      appId      : '198016034089658',
      cookie     : true,
      xfbml      : true,
      version    : 'v2.11'
    });
      
    FB.AppEvents.logPageView();   
      
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "https://connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
</script>
</html>