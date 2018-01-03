<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>
<% 
	String bno = request.getParameter("bno");
	JSONObject jo = new JSONObject(); //큰범위 json {"result",200, desc:"", "list": xxx}
	JSONObject sjo = null; //덧글개별 json {"rno":xxx, "content": xxx, "writer":xxx, "reg_date": xxxx}
	JSONArray ja = new JSONArray(); //덧글개별 json 담을 배열
	

	if(bno == null) {
		jo.put("result", "303");
		jo.put("desc","param is null");
		out.print(jo);
		out.flush();
	} else {
		
		//데이터베이스
		//Class.forName("com.mysql.cj.jdbc.Driver");
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String url = "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
		String user = "root";
		String userPassword = "1q2w3e4r";
		
		try{
			
			conn = DriverManager.getConnection(url, user, userPassword);
			
			String query = "SELECT r_no, r_content, r_writer, reg_date ";
					query += "FROM reply ";
					query += "WHERE b_no = ? ";
					query += "ORDER BY reg_date desc ";
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, Integer.parseInt(bno));
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				sjo = new JSONObject();
				sjo.put("rno", rs.getInt("r_no"));
				sjo.put("content", rs.getString("r_content"));
				sjo.put("writer", rs.getString("r_writer"));
				sjo.put("reg_date", rs.getString("reg_date"));
				
				ja.add(sjo);
			}
			
			jo.put("result", "200");
			jo.put("desc","select success");
			jo.put("list", ja);
			
			
		}catch(Exception e){
			jo.put("result","301");
			jo.put("desc","select fail");
			e.printStackTrace(); // 톰캣로그에서 확인가능
		}finally{
			if(rs != null) { rs.close();}
			if(pstmt != null) { pstmt.close();}
			if(conn != null) {conn.close();}
			
			out.print(jo);
			out.flush();

		}
		
	}
%>