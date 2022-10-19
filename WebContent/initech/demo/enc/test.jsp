<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="com.initech.iniplugin.*" %>  
<%@ include file ="../include/Init.jsp"%>

<% 

	String m_A = m_IP.getParameter("A");
	String m_B = m_IP.getParameter("B");
	String m_C = m_IP.getParameter("C");

%>
<html>
<head>
<script language="javascript" src="/initech/plugin/INIplugin.js"> </script>
</head>
<body>
<%=m_A%><br>
<%=m_B%><br>
<%=m_C%><br>
1. 서버에서 암호화 데이터 만드는 방식1<br>
<%=m_IP.isprint("your id and pw are valid", true)%><br>
<%=m_IP.isprint("your id and pw are valid", false)%><br>
2. 서버에서 암호화 데이터 만드는 방식2<br>
---------------------------------------------------------<br>
<% out = m_IP.startEncrypt(out);%>
아래의 내용은 서버가 암호화하여 출력하는 예제입니다.<br>
<br>1. 암호화 사용하지 않음<br>


<% out = m_IP.endEncrypt(out);%>
---------------------------------------------------------<br>











</body></html>
