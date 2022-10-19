<%-- noframe.jsp --%>

<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ include file ="./include/Init.jsp"%>
<%
	String strA = request.getParameter("A");
	String strB = request.getParameter("B");
	String strC = request.getParameter("C");
	String strCheck = request.getParameter("check");

	Properties InData = m_IP.getDecryptParameter();
	String notParseData = m_IP.getNotParsedData();
	String encALL = InData.toString();
	String encA = m_IP.getParameter("A");
	String encB = m_IP.getParameter("B");
	String encC = m_IP.getParameter("C");
	String encCheck = m_IP.getParameter("check");

/*	String value = null;
	StringBuffer sb = new StringBuffer();
	Enumeration e = m_IP.getParameterNames();
	while(e.hasMoreElements()){
		String name = (String)e.nextElement();
		sb.append("<br>[" + name + "] = [" + value + "]");
	}
	String outData = sb.toString();
	out.println(outData);
*/
	//out.println(m_IP.getParameterValues("C"));

	String encOutT = m_IP.isprint(encALL, true);
	String encOutF = m_IP.isprint(encALL, false);
%>

<html>
<head>
	<title>Script Test Result</title>	
	<script language="javascript" src="/initech/plugin1/cert.js"></script>
	<script language="javascript" src="/initech/plugin1/install.js"></script>
	<script language="javascript" src="/initech/plugin1/INIplugin.js"></script>
	<script language="javascript" src="/initech/plugin1/noframe.js"></script>
</head>

<body>
<% out = m_IP.startEncrypt(out); %>

<br><b> �Ʒ��� ���� �������� ��ȣȭ�Ͽ� ������ INIpluginData ���Դϴ�.</b>
<br> request.getParameter("INIpluginData") = [<%=request.getParameter("INIpluginData")%>]

<br><br><b> �Ʒ��� ���� null�� ���;� �մϴ�.</b>
<br> request.getParameter("A") = [<%=strA%>]
<br> request.getParameter("B") = [<%=strB%>]
<br> request.getParameter("C") = [<%=strC%>]
<br> request.getParameter("check") = [<%=strCheck%>]

<br><br><b> �Ʒ��� ���� ������ �Է��� ���� ���;� �մϴ�.</b>
<br> IP.getNotParseData = [<%=notParseData%>]
<br> IP.getDecryptParameter().toString() = [<%=encALL%>]
<br> IP.getParameter("A") = [<%=encA%>]
<br> IP.getParameter("B") = [<%=encB%>]
<br> IP.getParameter("C") = [<%=encC%>]
<br> IP.getParameter("check") = [<%=encCheck%>]

<br><br><b>�Ʒ��� ������ ������ ��ȣȭ�Ͽ� ����ϴ� �����Դϴ�.</b>

<br><br><b>1. IP.isprint(OutData, true) ���</b><br>
<%=encOutT%>

<br><br><b>2. IP.isprint(OutData, false) ���</b><br>
<%=encOutF%>

<br><br>
<center><input type=button value="�ǵ��ư���" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

<% out = m_IP.endEncrypt(out); %>
</body></html>
