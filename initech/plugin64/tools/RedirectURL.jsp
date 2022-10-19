<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%
//	response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
//	response.setHeader("Pragma", "no-cache");
//	response.setHeader("Expires", "0");
	String RedirectURL = request.getParameter("RedirectURL");
	if ( (RedirectURL == null) || (RedirectURL.equals("")) ) RedirectURL = "/err.jsp";
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language=javascript src="/initech/plugin/INIplugin.js"></script>
	<script>
	function encrypt_submit() 
	{
		var url = '<%=RedirectURL%>';
		alert(url);
		//alert(EncLocation(url));
		//location = EncLocation(url);
		location.replace(EncLocation(url));
	}
	</script>
</head>
<body onload="encrypt_submit();">
</body>

