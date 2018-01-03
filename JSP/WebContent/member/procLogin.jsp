<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>
<%
	String inputId	= request.getParameter("inputId");
	String inputPw	= request.getParameter("inputPw");
	JSONObject jo	= new JSONObject();

	if(inputId != null && inputPw != null){
		//데이터베이스 아이디와 패스워드비교
		Class.forName("com.mysql.cj.jdbc.Driver");
		
		Connection 		   conn	= null;
		PreparedStatement  smt	= null;
		ResultSet  			rs	= null;
		
		String url		= "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
		String user 	= "root";
		String password	= "1q2w3e4r";
		
		String query	= "";
			   query += "SELECT COUNT(*) AS cnt FROM MEMBERS \n";
			   query += "WHERE M_ID = ? AND M_PASSWORD = SHA(?)";
			   
		System.out.println(query);	   
		
		try{
			conn 	= DriverManager.getConnection(url, user, password);
			smt		= conn.prepareStatement(query);
			smt.setString(1, inputId);
			smt.setString(2, inputPw);
			rs		= smt.executeQuery();
			
			if(rs.next()){
				int result = rs.getInt("cnt");
				
				if(result == 0){
					//회원이 아니거나, 잘못넣었어
					jo.put("result","109");
					jo.put("desc","not member or invalid param");
				} else {
					//로그인처리
					session.setAttribute("id", inputId);
					jo.put("result","200");
					jo.put("desc","login success");
				}
			}
			
		}catch(Exception e){
			jo.put("result","106");
			jo.put("desc","db select fail");
		}finally{
			if(rs != null) { rs.close();}
			if(smt != null) {smt.close();}
			if(conn != null) {conn.close();}
			
			out.print(jo);
			out.flush();
		}
	} else {
		jo.put("result", "100");
		jo.put("desc","param is null");
		out.print(jo);
		out.flush();
	}


%>