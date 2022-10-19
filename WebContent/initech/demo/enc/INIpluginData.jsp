<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR"%>
<%--@ page contentType="text/html" --%>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init2.jsp"%>

<%
	//������ �ʿ��� ������ ���� üũ
	String strClientAuth = null;
	String certInfo = "";
	if (m_IP.isClientAuth()==false)
		strClientAuth = "����� ������ �ʿ��մϴ�.";
	else {
		strClientAuth = "����� �����̵� �������Դϴ�.";

		X509Certificate userCert = m_IP.getClientCertificate();
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// ������ �߱���
		Date NotAfter = userCert.getNotAfter();		// ������ ������
		Date currentTime = new Date();				// ���� �ð�
		int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>�߱��� : " + userCert.getIssuerDN().toString();
		certInfo += "<br>�߱޴�� : " + userCert.getSubjectDN().toString();
		certInfo += "<br>�߱��� : " + myDate.format(NotBefore);
		certInfo += "<br>������ : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>����ð� : " + myDate.format(currentTime);
		certInfo += "<br>������ �������� ";
		certInfo += date;
		certInfo += "�� �Ŀ� ���ᰡ �˴ϴ�.";

	}
//	out.println(request.getParameter("INIpluginData"));
	String strTime = "";
	StringBuffer sb = new StringBuffer();
	Enumeration e = m_IP.getParameterNames();
	while (e.hasMoreElements()) {
		String name = (String)e.nextElement();
		String value = m_IP.getParameter(name);
		sb.append("<br>[" + name + "] = [" + value + "]");
		if(name.equals("__INIts__"))
		{
			java.text.SimpleDateFormat fmt1= new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
        	long time1 = (Long.parseLong(value,10))*1000;
        	strTime = fmt1.format(new java.util.Date(time1));
		}
	}
%>

<html>
<head>
	<title>Crypto Test Result</title>	
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>

<br><b><%=strClientAuth%></b>
<%=certInfo%>
<br>

<br><br><b> m_IP.getParameterNames�� ��ȣȭ �� ���Դϴ�.</b>
<%= sb.toString() %>

<br><br><b> IP.getDecryptParameter().toString() </b>
<%= m_IP.getDecryptParameter().toString() %><BR>
<br><br><b> Time </b>
<%= strTime %>
<br><br>
<center><input type=button value="�ǵ��ư���" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

</body></html>
