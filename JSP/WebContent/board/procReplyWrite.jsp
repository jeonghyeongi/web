<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>
<%
	String content = request.getParameter("content");
	String writer = request.getParameter("writer");
	String bno = request.getParameter("bno");
	
	JSONObject jo = new JSONObject();
	
	//로그인체크
	String id = (String)session.getAttribute("id");
	if(id == null) {
		jo.put("result","101");
		jo.put("desc","login is not");
		out.print(jo);
		out.flush();
	} else {
		
		//데이터베이스
		//Class.forName("com.mysql.cj.jdbc.Driver");
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String url = "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
		String user = "root";
		String userPassword = "1q2w3e4r";
		
		try{
			
			conn = DriverManager.getConnection(url, user, userPassword);
			
			String query = "INSERT INTO reply ";
					query += "(b_no, r_content, r_writer, reg_date) ";
					query += "VALUES ";
					query += "(?,?,?,current_timestamp)";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, Integer.parseInt(bno));
			pstmt.setString(2, content);
			pstmt.setString(3, writer);
			pstmt.executeUpdate();
			
			jo.put("result", "200");
			jo.put("desc","reply insert success");
					
		}catch(Exception e){
			jo.put("result","301");
			jo.put("desc","reply insert fail");
			e.printStackTrace();
		}finally{
			if(pstmt != null) { pstmt.close();}
			if(conn != null) { conn.close();}
			out.print(jo);
			out.flush();
		}
	}
%>
