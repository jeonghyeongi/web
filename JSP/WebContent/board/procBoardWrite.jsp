<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	JSONObject jo = new JSONObject();

	//사용자 로긴체크
	String id = (String)session.getAttribute("id");

	if(id == null) {
		jo.put("result", "101");
		jo.put("desc","login is not");
	} else {

	

	//전송된 enctype 이 multipart/form-data인지 확인
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	
	if(isMultipart){
		// Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// Set factory constraints
		factory.setSizeThreshold(1000000*50);
		String tmpDir = "D:/tomcat_service/ROOT/uploadTemp";
		File fileTmpDir = new File(tmpDir);
		if(!fileTmpDir.exists()){
			fileTmpDir.mkdir();
		}
		factory.setRepository(fileTmpDir);

		// Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);

		// Set overall request size constraint
		upload.setSizeMax(1000000*40);

		// Parse the request
		List<FileItem> items = upload.parseRequest(request);

		// Process the uploaded items
		Iterator<FileItem> iter = items.iterator();
		
		//데이터베이스 처리
		//Class.forName("com.mysql.cj.jdbc.Driver");
		
		Connection conn = null;
		PreparedStatement psmt = null;
		
		String url = "jdbc:mysql://localhost:3306/mysqltest?verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
		String user = "root";
		String password = "1q2w3e4r";
		
		String query = "";
				query += "INSERT INTO board	";
				query += "(b_title,b_content,b_image,b_tags,b_open,b_password,b_reply,b_read_cnt,reg_date) ";
				query += "VALUES ";
				query += "(?,?,?,?,?,?,?,?, current_timestamp)";
		
		conn = DriverManager.getConnection(url, user, password);
		psmt = conn.prepareStatement(query);
		String ext = "";
		
		while (iter.hasNext()) {
			FileItem item = iter.next();

			//일반적인 form의 데이터(ex:title,tag..etc)
			if (item.isFormField()) {
				String name = item.getFieldName();
				String value = item.getString();
				jo.put(name,new String(value.getBytes("ISO-8859-1"),"utf-8"));
			} else {
				//file 데이터
				String fieldName = item.getFieldName();
				String fileName = item.getName();
				String contentType = item.getContentType();
				boolean isInMemory = item.isInMemory();
				long sizeInBytes = item.getSize();

				if("image/jpeg".equals(contentType) || "image/png".equals(contentType) || "image/gif".equals(contentType)){

					if(sizeInBytes < 1000000*30) {
						String uploadDir = "D:/tomcat_service/ROOT/upload";
						File fileUploadDir = new File(uploadDir);

						if(!fileUploadDir.exists()){
							fileUploadDir.mkdir();
						}

						//확장자구하기
						int extInx = fileName.lastIndexOf(".");

						ext = fileName.substring(extInx+1);

						java.util.Date date = new java.util.Date();
						SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
						String convertFileName = 	sdf.format(date);
						String uploadFile = uploadDir + "/" + convertFileName + "." + ext; 

						File uploadedFile = new File(uploadFile);

						item.write(uploadedFile);

						jo.put("fileName",fileName);
						jo.put("convertFileName",convertFileName);
						jo.put("contentType",contentType);
						jo.put("fileSize", sizeInBytes);
					} else {
						jo.put("result","302");
						jo.put("desc","Over file size");
						break;
					}
				} else {
					jo.put("result","301");
					jo.put("desc","Don't allow file type");
					break;
				}

				
				
			}
		}
		
		if(jo.get("result") == null) {
			
			//데이터베이스 입력
			psmt.setString(1, (String)jo.get("inputTitle"));
			psmt.setString(2, (String)jo.get("inputContent"));
			psmt.setString(3, "/upload/" + (String)jo.get("convertFileName")+ "." + ext);
			psmt.setString(4, (String)jo.get("inputTag"));
			psmt.setString(5, "Y");
			psmt.setString(6, "");
			psmt.setString(7, (String)jo.get("inputReplyYN"));
			psmt.setInt(8, 0);
			
			psmt.executeUpdate();
			
			jo.put("result","200");
			jo.put("desc","success");
		}
				
	} else {
		jo.put("result","300");
		jo.put("desc","multipart is not");
	}
}

	out.print(jo);
	out.flush();
%>