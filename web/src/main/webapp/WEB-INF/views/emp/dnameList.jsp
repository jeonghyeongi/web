<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script>
	function doModify(deptno, empno){
		if(confirm("정말 수정하겠습니까?")) {
			$("#deptno").val(deptno);
			var dname = $("#"+empno).val();
			$("#dname").val(dname);
			$("#frm").submit();
		}
		
	}
	
	$(document).ready(function(){
		
	});
</script>
</head>
<body>
<form id="frm" action="/emp/updateDname" method="post">
	<input type="hidden" id="deptno" name="deptno" />
	<input type="hidden" id="dname" name="dname" />
</form>
<c:forEach var="vo" items="${list }">
${vo.ename } - ${vo.job } - <input type="text" id="${vo.empno }" value="${vo.dname }" /> <button type="button" onclick="doModify(${vo.deptno},${vo.empno })"> 수정</button> <br>
</c:forEach>






</body>
</html>