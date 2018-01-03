<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//1. 드라이버 로딩
	Class.forName("com.mysql.cj.jdbc.Driver");
	
	

	ServletInputStream sls = request.getInputStream();
	Connection 	conn 	= null; //데이터베이스 커넥션 객체
	Statement 	smt 	= null; //쿼리생성 객체
	ResultSet	rs		= null; //궈리응답 결과를 담는 객체(select 문에서 사용!)
	
	try{
		String jdbcDriver 	= "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
		String dbUser 		= "root";
		String dbPassword 	= "1q2w3e4r";
		
		//2. 데이터베이스 커넥션 구함
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPassword);
		
		//3.쿼리실행을 위한 statement 객체 생성
		smt = conn.createStatement();
		
		//4.쿼리 실행(executeQuery 는 select 문 실행할 때.)
		rs = smt.executeQuery("SELECT empno, ename, job FROM emp");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1">
		<tr>
			<td>직번</td>
			<td>이름</td>
			<td>업무</td>
		</tr>
		<% 
			//5.쿼리실행결과(resultset) 사용
			while(rs.next()) {
		%>	
		<tr>
			<td><%=rs.getInt("empno")%></td>
			<td><%=rs.getString("ename")%></td>
			<td><%=rs.getString("job") %></td>
		</tr>	
		<% 
			}
		%>
	</table>
</body>
</html>
<%		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		//6. statement 종료
		if(smt != null){smt.close();}
		//7. 데이터베이스 커넥션 종료
		if(conn != null) {conn.close();}
	}
	
%>    