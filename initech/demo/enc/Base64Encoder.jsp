<%@ page language="java" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="javax.servlet.*,java.io.*,sun.misc.*" %>

		
<% 
	String data = request.getParameter("data");
	String select = request.getParameter("select");
	
	//out.println(data);
	//out.println(select);
	
	if (select.equals("E"))
	{
		BASE64Encoder base64Encoder = new BASE64Encoder(); 
		ByteArrayInputStream bin = new ByteArrayInputStream(data.getBytes()); 
		ByteArrayOutputStream bout = new ByteArrayOutputStream(); 
		byte[] buf = null; 
		try 
		{ 
			base64Encoder.encodeBuffer(bin, bout); 
		} catch(Exception e) { 
			System.out.println("Exception"); 
			e.printStackTrace(); 
		} 
		buf = bout.toByteArray(); 
		out.println("["+ new String(buf).trim() +"]");
	} else if (select.equals("D")) 
	{
		BASE64Decoder base64Decoder = new BASE64Decoder(); 
		ByteArrayInputStream bin = new ByteArrayInputStream(data.getBytes()); 
		ByteArrayOutputStream bout = new ByteArrayOutputStream(); 
		byte[] buf = null; 
		try 
		{ 
			base64Decoder.decodeBuffer(bin, bout); 
		} catch(Exception e) { 
			System.out.println("Exception"); 
			e.printStackTrace(); 
		} 
		buf = bout.toByteArray(); 
		//out.println(buf); 
		out.println("["+ new String(buf).trim() +"]");
	}
%>

<html>
	<body>
<center><input type=button value="되돌아가기" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

</body>
</html>
	