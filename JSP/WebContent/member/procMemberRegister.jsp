<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>
<%

	JSONObject jo 		= new JSONObject();
	String userName		= request.getParameter("userName"); /** 이름 */
	String userEmail	= request.getParameter("userEmail"); /** 이메일 */
	String userPassword = request.getParameter("userPassword"); /** 비밀번호 */
	String userPost		= request.getParameter("userPost"); /** 우편번호 */
	String userAddress1	= request.getParameter("userAddress1"); /** 주소1 */
	String userAddress2 = request.getParameter("userAddress2"); /** 주소2 */
	String userId		= request.getParameter("userId"); /** 아이디 */
	String userBirth	= "20171228";
	
	if(userId == null || userName == null) {
		jo.put("result", "105");
		jo.put("desc","id or name is null");
		out.print(jo);
		out.flush();
		
	} else {
		
		Class.forName("com.mysql.cj.jdbc.Driver"); /** 드라이버 로딩 */
		
		Connection conn = null;
		Statement smt 	= null;
		
		String url 		= "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC"; /** jdbc url */
		String user		= "root"; /** db 계정 */
		String password	= "1q2w3e4r"; /** db 비밀번호 */
		
		//먼저 해당아이디가 존재하는지 다시한번 체크해야함(서버에서!)
		
		String query 	= "";
			   query 	+= "INSERT INTO members \n";
			   query 	+= "(m_id,m_name,m_birth,m_email,m_password,m_post,m_address1,m_address2,reg_date) \n";
			   query 	+= "VALUES \n";
			   query 	+= "('"+userId+"','"+userName+"','"+userBirth+"','"+userEmail+"', sha('"+userPassword+"'),'"+userPost+"','"+userAddress1+"','"+userAddress2+"',current_timestamp)";
		
		//쿼리확인
		System.out.println(query);
		
		try{
			conn 		= DriverManager.getConnection(url, user, password); /** connection 객체 얻어옴*/
			smt 		= conn.createStatement(); /** statement 객체얻어옴 */
			int result 	= smt.executeUpdate(query); /** 쿼리문 실행 */
			
			//결과확인
			System.out.println("result == " + result);
			
			jo.put("result","200");
			jo.put("desc","db insert success");
			
		}catch(Exception e){
			jo.put("result","106");
			jo.put("desc","db insert fail");
		}finally {
			if(smt != null) { smt.close();}
			if(conn != null) {conn.close();}
			out.print(jo);
			out.flush();
		}
		
		
		
	}
	
	

	/*
	out.print(userName);
	out.print("<br>");
	out.print(userEmail);
	out.print("<br>");
	out.print(userPassword);
	out.print("<br>");
	out.print(userPost);
	out.print("<br>");
	out.print(userAddress1);
	out.print("<br>");
	out.print(userAddress2);
	out.print("<br>");
	out.print(userId);
	*/
%>