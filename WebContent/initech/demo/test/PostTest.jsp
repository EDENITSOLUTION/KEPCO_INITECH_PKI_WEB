<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*,java.text.*" %>

<%
	out.println("<html><head><title>Result</title></head><body>");

	String data = "";
	data = request.getParameter("data");
	out.println("<br>size = [" + data.length() + "]byte");
	out.println("<br><br>" +  data );
	

	out.println("<br><br>");
	out.println("<center><input type=button value='되돌아가기' onClick='history.back();'></center>");
	out.println("<hr size='1' width='550' color='#CCCCCC'></p>");
	out.println("<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>");
	out.println("</body></html>");
%>

