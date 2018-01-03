<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.Calendar"%>

<!doctype html>
<html>
	<head>
		<jsp:include page="/include/top.jsp" />
		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>	
		
		<script type="text/javascript">
			function checkEmail(data){
				var reg = /^[a-z0-9A-Z]([.-_]?[a-z0-9A-Z])*@[a-z0-9A-Z]([.-_]?[a-z0-9A-Z])*\.[a-zA-Z]{2,3}$/;

				return reg.test(data);
			}

			function userIdCheck(){
				$("#btnIdCheck").click(function(){
					var userId = $("#inputId").val();
					if(userId == ""){
						alert("아이디를 입력해주세요");
						return false;
					}

					var reg = /^[a-z0-9]{5,8}$/;

					if(!reg.test(userId)){
						alert("아이디는 영문숫자 5-8자사이입니다");
						return false;
					}

					$.ajax({
						url:"procIDCheck.jsp",
						type: "post",
						dataType: "json",
						data: {"userId":userId},
						success: function(data){
							if(data.result == "200"){
								alert("사용가능한 아이디입니다.");
								$("#userIdFlag").val("ok");
							} else if(data.result == "108") {
								alert("존재하는 아이디입니다.");
								$("#inputId").val("");
							} else {
								alert("잘못된 값을 넘기셨습니다");
							}
						},
						error: function(data){
							alert("죄송합니다.");
						}
					});
				
				});
			}

			function openPost(){
				$("#btnPost").click(function() {
				
					new daum.Postcode({
						oncomplete: function(data) {
							$("#inputPost").val(data.zonecode);
							$("#inputAddress1").val(data.address);
						}
						
					}).open();
				});
			}

			function goRegister(){
				$("#btnRegister").click(function(){
					var userId		= $("#inputId").val();
					var userName	= $("#inputName").val();
					var userEmail	= $("#inputEmail").val();
					var userPassword = $("#inputPassword3").val();
					var userPassword2 = $("#inputPassword4").val();
					var userPost	 = $("#inputPost").val();
					var userAddress1 = $("#inputAddress1").val();
					var userAddress2 = $("#inputAddress2").val();

					if(userName == "") {
						alert("이름을 입력해주세요");
						return false;
					}

					if(userEmail == "") {
						alert("이메일을 입력해주세요");
						return false;
					}

					var mailReg = /^[a-z0-9A-Z-_.]+@[a-z0-9A-Z-_.]+\.[a-zA-Z]{2,5}$/;

					if(!mailReg.test(userEmail)){
						alert("메일형식이 잘못되었습니다.");
						return false;
					}
					
					var idCheckFlag = $("#userIdFlag").val();
					
					if(idCheckFlag != "ok"){
						alert("중복확인을 해주세요");
						return false;
					}

					if(userPassword == "") {
						alert("비밀번호를 입력해주세요");
						return false;
					}

					if(userPassword != userPassword2){
						alert("비밀번호가 일치하지 않습니다.");
						return false;
					}

					if(userPost == "") {
						alert("우편번호 검색을 해주세요");
						return false;
					}

					if(userAddress1 == "" || userAddress2 == ""){
						alert("주소를 입력해주세요");
						return false;
					}

					$.ajax({
						url: "procMemberRegister.jsp",
						type: "post",
						dataType: "json",
						data: {"userName":userName, "userEmail":userEmail, "userPassword":userPassword, "userPost":userPost, "userAddress1":userAddress1, "userAddress2":userAddress2, "userId":userId},
						success:function(data){
							if(data.result == '200'){
								alert("회원가입되셨습니다.");
								location.href='/MyMain.jsp';
							}else {
								alert(data.desc);
							}
						},
						error:function(data){
							//alert(data);
							alert("죄송합니다. 다시 해주세요");
						}
					});
				});
			}


			$(document).ready(function(){
						openPost();
						userIdCheck();
						goRegister();
						
			});
		</script>
	</head>

	<body>
	<!-- Horizontal Form -->
          <div class="box box-info">
            <div class="box-header with-border">
              <h3 class="box-title">회원 가입</h3>
            </div>
			
            <!-- /.box-header -->
            <!-- form start -->
            <form class="form-horizontal">
			<input type="hidden" id="userIdFlag" />
              <div class="box-body">
                <div class="form-group">
                  <label for="inputName" class="col-sm-2 control-label">이름</label>

                  <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputName" placeholder="이름을 입력해주세요">
                  </div>
                </div>

				<!-- select -->
                <div class="form-group">
                  <label class="col-sm-2 control-label">생년월일
				  </label>
				  <div class="col-sm-4">
					  <select class="form-control">
						<%
							Calendar cal = Calendar.getInstance();
							int year = cal.get(Calendar.YEAR);
							
							for(int i = year; i > 1930; i--) {
						%>
							<option><%=i%>년</option>
						<%
							}
						%>
					  </select>
				  </div>
				  <div class="col-sm-3">
					  <select class="form-control">
					  <%
						for(int i = 1; i < 13; i++) {
					  %>
						<option><%=i%>월</option>
					 <%
						}
					  %>	
					  </select>
				 </div>
				 <div class="col-sm-3">
					  <select class="form-control">
					  <%
						for(int i = 1; i < 32; i++) {
					  %>
						<option><%=i%>일</option>
					  <%
					    }
					  %>	
					  </select>
				  </div>
                </div>

				<div class="form-group">
                  <label for="inputEmail" class="col-sm-2 control-label">메일</label>

                  <div class="col-sm-10">
                    <input type="text" class="form-control" id="inputEmail" placeholder="메일를 입력해주세요">
                  </div>
                </div>

				<div class="form-group">
                  <label for="inputId" class="col-sm-2 control-label">아이디</label>

                  <div class="col-sm-8">
                    <input type="text" class="form-control" id="inputId" placeholder="아이디를 입력해주세요">
                  </div>

				  <div class="col-sm-2">
					<Button type="button" id="btnIdCheck" class="btn"><i class="fa fa-fw fa-check-circle-o"></i>중복확인</Button>
				  </div>
				  
                </div>

                <div class="form-group">
                  <label for="inputPassword3" class="col-sm-2 control-label">Password</label>

                  <div class="col-sm-10">
                    <input type="password" class="form-control" id="inputPassword3" placeholder="Password">
                  </div>
                </div>

				<div class="form-group">
                  <label for="inputPassword4" class="col-sm-2 control-label">Password 확인</label>

                  <div class="col-sm-10">
                    <input type="password" class="form-control" id="inputPassword4" placeholder="Password 확인">
                  </div>
                </div>
                
				<div class="form-group">
					<label for="inputPost" class="col-sm-2 control-label">우편번호</label>
					<div class="col-sm-2">
						<input type="text" class="form-control" id="inputPost" />
					</div>
					
					<div class="col-sm-2">
						<Button type="button" class="btn" id="btnPost"><i class="fa fa-fw fa-check-circle-o" ></i>검색</Button>
					</div>
				</div>

				<div class="form-group">
					<label for="inputAddress1" class="col-sm-2 control-label">기본주소</label>
					<div class="col-sm-5">
						<input type="text" id="inputAddress1" class="form-control" />
					</div>
				</div>

				<div class="form-group">
					<label for="inputAddress2" class="col-sm-2 control-label">상세주소</label>
					<div class="col-sm-5">
						<input type="text" id="inputAddress2" class="form-control" />
					</div>
				</div>



              </div>
              <!-- /.box-body -->
              <div class="box-footer">
                <button type="submit" class="btn btn-default">취소</button>
                <button type="submit" id="btnRegister" class="btn btn-info pull-right">회원가입</button>
              </div>
              <!-- /.box-footer -->
            </form>
          </div>

	</body>
</html>