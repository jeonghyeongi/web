<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.*" %>
<%
	JSONObject jo = new JSONObject();
	String userId = request.getParameter("userId");
	
	if(userId == null) {
		jo.put("result","107");
		jo.put("desc","param is null");
		out.print(jo);
		out.flush();
	} else {
		Class.forName("com.mysql.cj.jdbc.Driver");
		
		Connection conn = null;
		Statement smt 	= null;
		ResultSet rs 	= null;
		
		String url 			= "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
		String user 		= "root";
		String password 	= "1q2w3e4r";
		String query		= "";
			   query		+= "SELECT COUNT(*) as cnt FROM members \n";
			   query		+= "WHERE m_id = '"+userId+"'";
	
		System.out.println(query);
		
		try{
			conn 	= DriverManager.getConnection(url, user, password);
			smt 	= conn.createStatement();
			rs		= smt.executeQuery(query);
			
			if(rs.next()){
				int result = rs.getInt("cnt");
				
				if(result == 0){
					//사용할 수 있는 아이디
					jo.put("result","200");
					jo.put("desc","possible id");
				} else {
					//이미 있는 아이디
					jo.put("result","108");
					jo.put("desc","already id");
				}
			}
			
		}catch(Exception e){
			jo.put("result","106");
			jo.put("desc","db select fail");
		}finally{
			if(rs != null) { rs.close();}
			if(smt != null) { smt.close();}
			if(conn != null) { conn.close();}
			out.print(jo);
			out.flush();
		}
		
	}
%>