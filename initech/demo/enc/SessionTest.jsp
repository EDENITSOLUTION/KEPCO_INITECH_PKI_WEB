<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ include file ="../include/Init.jsp"%>
<html>
<head>
	<title>Script Test Result</title>
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>

<% 
	out.println(session.getAttribute("dt"));

%>


</body></html>
