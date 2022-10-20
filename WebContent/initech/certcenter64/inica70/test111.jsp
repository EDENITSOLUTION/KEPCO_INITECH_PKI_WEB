<%@ page import="java.text.*" %>
<%
 long time = System.currentTimeMillis();
 SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss:SSS");
 out.print(dayTime.format(new java.util.Date(time)));
%>
