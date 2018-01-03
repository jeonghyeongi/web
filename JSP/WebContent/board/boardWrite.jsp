<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<!doctype html>
<html>
	<head>
		<head>
		
		<jsp:include page="/include/top.jsp" />
		
		<script src="/bootstrap/dist/js/bootstrap.min.js"></script>
		
		<script src="/ckeditor/ckeditor.js"></script>
				
		<script type="text/javascript">
			
			$(document).ready(function(){
				//$("#modal-default").modal("show");
				//$("#modal-default").modal("hide");

				CKEDITOR.replace('editor1');
				
				$("#openN").click(function(){
					$("#pwDisplay").css("display","inline");
				});

				$("#openY").click(function(){
					$("#pwDisplay").css("display","none");
				});

				//등록버튼
				$("#btnWrite").click(function(e){
					e.preventDefault();
					
					//제목
					var inputTitle = $("#inputTitle").val();
					
					//본문
					var inputContent = CKEDITOR.instances['editor1'].getData();

					//태그
					var inputTag = $("#inputTag").val();

					//비공개
					var openN = $("#openN").prop("checked");

					//비밀번호
					var inputPw;

					//공개
					var openY = $("#openY").prop("checked");

					//댓글설정
					var inputReplyYN = $("#inputReplyYN").prop("checked");

					if(inputTitle == "") {
						alert("제목을 입력해주세요");
						return false;
					}

					if(inputContent == "") {
						alert("내용을 입력해주세요");
						return false;
					}

					if(openY){
						openY = "Y";
						openN = "N";
					} else {
						inputPw = $("#inputPw").val();

						openY = "N";
						openN = "Y";

						if(inputPw == "") {
							alert("비공개를 선택하셨습니다. \n 비밀번호를 입력해주세요.");
							return false;
						}
					}

					if(inputReplyYN) {
						inputReplyYN = "Y";
					}else{
						inputReplyYN = "N";
					}

					var data = new FormData();
					data.append("inputTitle",inputTitle);
					data.append("inputContent",inputContent);
					data.append("inputTag",inputTag);
					data.append("openN",openN);
					data.append("openY",openY);
					//data.append("inputPw",inputPw);
					data.append("inputReplyYN",inputReplyYN);
					data.append("file", $("#file").prop("files")[0]);

					$.ajax({
						url: "procBoardWrite.jsp",
						type: "post",
						enctype: "multipart/form-data",
						dataType: "json",
						data: data,
						contentType: false,
						processData: false,
						success: function(data){
							console.log(data);
							if(data.result == "101"){
								$("#modalText").text("로그인이 필요합니다.");
								
								$("#modal-default").modal("show");
							} else if(data.result == "300") {
								$("#modalText").text("정상적인 요청이 아닙니다.");

								$("#modal-default").modal("show");

							} else if(data.result == "302") {
								$("#modalText").text("파일용량은 최대 30M까지 가능합니다.");

								$("#modal-default").modal("show");
							} else if(data.result == "301"){
								$("#modalText").text("이미지파일만 가능합니다.");

								$("#modal-default").modal("show");
							} else if(data.result == "200"){
								//정상처리
								$("#modalText").text("성공했습니다.");

								$("#modal-default").modal("show");
							}
						},
						error: function(data){
							alert(2);
						}
					});
				});
			});
		</script>
		
	</head>
	<body class="hold-transition skin-yellow layout-top-nav">
		<div class="wrapper">

  <!-- Main Header -->
  <header class="main-header">

    

    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
		<!-- Logo -->
		<a href="index2.html" class="logo">
		  <!-- mini logo for sidebar mini 50x50 pixels -->
		  <span class="logo-mini"><b>A</b>LT</span>
		  <!-- logo for regular state and mobile devices -->
		  <span class="logo-lg"><b>JHK</b>Home</span>
		</a>

      
      <!-- Navbar Right Menu -->
      <div class="navbar-custom-menu">
       <%
			String id = (String)session.getAttribute("id");
			
			if(id != null){
				out.print(id + "로그인 하셨습니다");
				out.print("<a class='btn btn-flat' href='procLogout.jsp' >");
				out.print("[로그아웃]");
				out.print("</a>");
			} else {
				out.print("<a href='loginForm.jsp' >");
				out.print("[로그인]");
				out.print("</a>");
			}
	   %>
      </div>
    </nav>
  </header>
  

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Page Header
        <small>Optional description</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
        <li class="active">Here</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content container-fluid">

      <!--------------------------
        | Your Page Content Here |
        -------------------------->
		<div class="box box-info">
			<div class="box-header with-border">
              <h3 class="box-title">글쓰기</h3>
            </div>

			<form class="form-horizontal">
				<div class="box-body">
					<!--제목 시작-->
					<div class="form-group">
					  <label for="inputTile" class="col-sm-2 control-label">제목</label>

					  <div class="col-sm-5">
						<input type="text" class="form-control" id="inputTitle" placeholder="제목을 입력해주세요">
					  </div>
					</div>
					<!--제목 끝-->

					<!-- 내용 시작-->
					<div class="form-group">
						<label for="inputContent" class="col-sm-2 control-label">내용</label>

						<div class="col-sm-6">
							
								<textarea id="editor1" name="editor1" rows="10" cols="150"
								>
                                </textarea>
							
						</div>
					</div>
					<!-- 내용 끝-->

					<!--파일첨부 시작-->
					<div class="form-group">
						<label for="inputFile" class="col-sm-2 control-label">파일첨부</label>

						<div class="col-sm-5">
							<input type="file" id="file" name="file" />
						</div>
					</div>
					<!--파일첨부 끝-->

					<!--태그 시작-->
					<div class="form-group">
						<label for="inputTag" class="col-sm-2 control-label">태그</label>

						<div class="col-sm-5">
							<input type="text" class="form-control" id="inputTag" placeholder="태그를 입력해주세요">
						</div>
					</div>
					<!--태그 끝-->

					<!--공개여부 시작-->
					<div class="form-group">
						<label for="inputOpenYN" class="col-sm-2 control-label">공개여부</label>

						<div class="col-sm-5">
							<div class="radio">
								<label>
									<input type="radio" name="openYN" id="openY" value="Y" checked="checked"/>공개
								</label>
								<label>
									<input type="radio" name="openYN" id="openN" value="N" />비공개
									<div id="pwDisplay" style="display:none" >
										<input type="text" id="inputPw" placeholder="비밀번호" />
									</div>
								</label>
							</div>
						</div>
					</div>
					<!--공개여부 끝-->

					<!--댓글여부 시작-->
					<div class="form-group">
						<label for="inputReplyYN" class="col-sm-2 control-label">댓글설정</label>

						<div class="col-sm-5">
							<div class="checkbox">
								<label>
									<input type="checkbox" id="inputReplyYN"
									checked="checked"
									/>
								</label>
							</div>
						</div>
					</div>
					<!--댓글여부 끝-->

					<!--버튼 시작-->
					<div class="form-group">
						<div class="col-sm-2" >
						</div>
						<div class="col-sm-5">
							<button type="button" id="btnCancel" class="btn btn-default" />취소</button>
							<button type="submit" id="btnWrite" class="btn btn-info pull-right" />글쓰기</button>
						</div>
					</div>
					<!--버튼 끝-->
				</div>
			</form>
		</div>

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

 <jsp:include page="/include/footer.jsp" />
  
	<!--디폴트 모달 영역 시작-->
	<div class="modal fade" id="modal-default">
	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			  <span aria-hidden="true">&times;</span></button>
			<h4 class="modal-title">알림!</h4>
		  </div>
		  <div class="modal-body">
			<p id="modalText"></p>
		  </div>
		  <div class="modal-footer">
			<button type="button" class="btn btn-primary pull-right" data-dismiss="modal">확인</button>
		  </div>
		</div>
	   </div>
	 </div>
	 <!--디폴트 모달 영역 끝-->
</div>
<!-- ./wrapper -->
	

	</body>
</html>