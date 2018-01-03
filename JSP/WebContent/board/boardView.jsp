<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String b_no = request.getParameter("no");
	int no = 0;
	if (b_no != null) {
		no = Integer.parseInt(b_no);
	}

	//데이터베이스
	//Class.forName("com.mysql.cj.jdbc.Driver");

	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement updatePstmt = null;
	ResultSet rs = null;

	String url = "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
	String user = "root";
	String userPassword = "1q2w3e4r";

	String title = "";
	String content = "";
	int readCnt = 0;
	String regDate = "1999-01-01";
	String tag = "";
	String image = "";

	try {

		conn = DriverManager.getConnection(url, user, userPassword);

		//조회수 증가.
		String updateQuery = "";
		updateQuery += "UPDATE board \n";
		updateQuery += "SET b_read_cnt = b_read_cnt + 1 \n";
		updateQuery += "WHERE b_no = ? \n";

		updatePstmt = conn.prepareStatement(updateQuery);
		updatePstmt.setInt(1, no);
		updatePstmt.executeUpdate();

		//해당 게시글 하나.
		String query = "";
		query += " SELECT b_no, b_title, b_content, b_read_cnt, reg_date, b_image, b_tags ";
		query += " FROM board ";
		query += " where b_no = ? ";
		pstmt = conn.prepareStatement(query);
		pstmt.setInt(1, no);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			title = rs.getString("b_title");
			content = rs.getString("b_content");
			readCnt = rs.getInt("b_read_cnt");
			regDate = rs.getString("reg_date");
			tag = rs.getString("b_tags");
			image = rs.getString("b_image");
		}
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<jsp:include page="/include/top.jsp" />
<script>
	function replyList(){
		var bno = "<%=no%>";
		
		if(bno == "") {
			alert("잘못된 요청입니다.");
			return false;
		}
		
		$.ajax({
			url: "procReplyList.jsp",
			type: "post",
			dataType: "json",
			data:{"bno":bno},
			success:function(data){
				console.log(data);
				for(var i=0; i<data.list.length; i++){
					var html = "<tr>";
					html += "<td>"+data.list[i].content+"</td>";
					html += "<td>"+data.list[i].writer+"</td>";
					html += "<td>"+data.list[i].reg_date+"</td>";
					html += "</tr>";
					
					$("#replyList").append(html);
				}
				
			},
			error:function(data){
				alert(2);
			}
			
		});	
	}
	
	function registerReply() {
		$("#btnReply").click(function(){
			
			var content = $("#inputReply").val();
			var writer = "${sessionScope.id}";
			var bno = "<%=no%>";
			
			if(writer == "") {
				alert("로그인해주세요");
				return false;
			}
			
			if(bno == "") {
				alert("잘못된 요청입니다.");
				return false;
			}
			
			if(content == ""){
				alert("댓글내용을 입력해주세요.");
				return false;
			}
			
			$.ajax({
				url: "procReplyWrite.jsp",
				type: "post",
				dataType: "json",
				data:{"content":content,"writer":writer,"bno":bno},
				success:function(data){
					console.log(data);
					if(data.result="200"){
						alert("등록되셨습니다.");
						$("#replyList tr").remove();
						replyList();
						$("#inputReply").val("");
					}else{
						alert("다시 등록해주세요");
					}
				},
				error:function(data){
					alert(1);
				}
					
				
			});
			
		});
		
	}

	$(document).ready(function() {
		replyList();
		registerReply();
	});
</script>
</head>
<body>
	<div class="box box-info">
		<div class="box-header with-border">
			<h3 class="box-title">글보기</h3>
		</div>

		<form class="form-horizontal">
			<div class="box-body">
				<!--제목 시작-->
				<div class="form-group">
					<label for="inputTile" class="col-sm-2 control-label">제목</label>

					<div class="col-sm-5">
						<div id="inputTile" class="form-control"><%=title%></div>
					</div>
				</div>
				<!--제목 끝-->

				<!-- 내용 시작-->
				<div class="form-group">
					<label for="inputContent" class="col-sm-2 control-label">내용</label>

					<div class="col-sm-6">
						<div id="inputContent" class="form-control"
							style="height: 400px; overflow: scroll;"><%=content%></div>
					</div>
				</div>
				<!-- 내용 끝-->

				<!--태그 시작-->
				<div class="form-group">
					<label for="inputTag" class="col-sm-2 control-label">태그</label>

					<div class="col-sm-5">
						<div id="inputTag" class="form-control"><%=tag%></div>
					</div>
				</div>
				<!--태그 끝-->

				<!--댓글 시작-->
				<div class="form-group">
					<label for="inputReply" class="col-sm-2 control-label">댓글</label>

					<div class="col-sm-5">
						<input type="text" class="form-control" id="inputReply"
							placeholder="댓글을 입력해주세요">
					</div>
					<button type="button" class="btn btn-info" id="btnReply">등록</button>
				</div>
				<!--댓글 끝-->

				<!-- 댓글 리스트 시작-->
				<div class="form-group">
					<div class="col-sm-2"></div>
					<div class="col-sm-5">
						<table id="replyList">
							
						</table>
					</div>
				</div>
				<!-- 댓글 리스트 끝 -->
			</div>
		</form>
	</div>
</body>
</html>
<%
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) {
			rs.close();
		}
		if (updatePstmt != null) {
			updatePstmt.close();
		}
		if (pstmt != null) {
			pstmt.close();
		}
		if (conn != null) {
			conn.close();
		}
	}
%>