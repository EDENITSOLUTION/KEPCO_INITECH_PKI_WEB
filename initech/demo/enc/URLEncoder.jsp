<%@ page language="java" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.net.*" %>
<%
	String data = request.getParameter("data");
	String select = request.getParameter("select");
 	
 	if (select.equals("E"))
	{
		try
		{
			String encData = URLEncoder.encode( data, "UTF-8" );
			//String encData = URLEncoder.encode( data, "8859_1" );
			out.println("["+ encData +"]");
		} catch(Exception e) { 
			System.out.println("Exception"); 
			e.printStackTrace(); 
		} 
	} else if (select.equals("D")) {
		try
		{
			String decData = URLDecoder.decode( data, "UTF-8" );
			//String decData = URLDecoder.decode( data, "8859_1" );
			out.println("["+ decData +"]");
		} catch(Exception e) { 
			System.out.println("Exception"); 
			e.printStackTrace(); 
		}	
	}
%>

<html>
	<body>
<center><input type=button value="되돌아가기" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

</body>
</html>