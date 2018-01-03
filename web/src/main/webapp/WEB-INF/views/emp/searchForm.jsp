<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="/emp/searchJob" method="post" >
	<input type="text" name="ename" />
	<button type="submit" >검색</button>
</form>
<c:forEach var="emp" items="${jobList }">
	${emp.ename } - ${emp.job }
</c:forEach>
</body>
</html>