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
1. �������� ��ȣȭ ������ ����� ���1<br>
<%=m_IP.isprint("your id and pw are valid", true)%><br>
<%=m_IP.isprint("your id and pw are valid", false)%><br>
2. �������� ��ȣȭ ������ ����� ���2<br>
---------------------------------------------------------<br>
<% out = m_IP.startEncrypt(out);%>
�Ʒ��� ������ ������ ��ȣȭ�Ͽ� ����ϴ� �����Դϴ�.<br>
<br>1. ��ȣȭ ������� ����<br>


<% out = m_IP.endEncrypt(out);%>
---------------------------------------------------------<br>











</body></html>
