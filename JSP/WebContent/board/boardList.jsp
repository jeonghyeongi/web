<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>	
<% 
	//데이터베이스2
	//Class.forName("com.mysql.cj.jdbc.Driver");

	Connection 			conn 	= null;
	PreparedStatement 	pstmt 	= null;
	ResultSet 			rs 		= null;
	
	String url 	= "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
	String user = "root";
	String userPassword = "1q2w3e4r";
	
	try{
		
		conn = DriverManager.getConnection(url, user, userPassword);
		String query = "";
				query += "SELECT b_no, b_title, b_read_cnt, reg_date \n";
				query += "FROM board \n";
				query += "ORDER BY reg_date desc \n";
		System.out.print(query);		
		pstmt = conn.prepareStatement(query);
				
		rs = pstmt.executeQuery();		
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<jsp:include page="/include/top.jsp" />

</head>
<body>
	<div class="box box-info">
		<div class="box-header with-border">
			<h3 class="box-title">글리스트</h3>
		</div>
		
		<div class="box-body">
			<table class="table table-bordered">
				<tr>
					<th style="width:40px">번호</th>
					<th style="width:200px">제목</th>
					<th style="width:40px">조회수</th>
					<th style="width:80px">등록일</th>
				</tr>
				<%
					int no = 0;
					while(rs.next()){
						no++;
				%>
					<tr>
						<td><%=no %></td>
						<td><a href="/board/boardView.jsp?no=<%=rs.getInt("b_no")%>"><%=rs.getString("b_title")%></a></td>
						<td><%=rs.getInt("b_read_cnt")%></td>
						<td><%=rs.getString("reg_date")%></td>
					</tr>
				<% 
					}
				%>
			</table>
		</div>
	</div>
</body>
</html>
<%				
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(rs != null) {rs.close();}
		if(pstmt != null) {pstmt.close();}
		if(conn != null) {conn.close();}
	}

%>