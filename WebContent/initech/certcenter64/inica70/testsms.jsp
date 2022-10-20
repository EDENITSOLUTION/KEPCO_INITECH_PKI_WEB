<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="kepco.*" %>
<%@ include file="import/fncSMS.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
<title>Insert title here</title>
</head>
<body>
<%
String smsResultCode = "";
smsResultCode = sendSMS("certNew", "bbsadm07", "20170117191555") ; //인증서 발급
//smsResultCode = sendSMS("certRevoke", "ex09999", "") ; //인증서 발급
%>
smsResultCode : <%=smsResultCode%>
</body>
</html>
