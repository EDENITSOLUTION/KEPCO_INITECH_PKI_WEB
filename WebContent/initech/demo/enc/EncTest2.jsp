<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR"%>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init.jsp"%>
<%
	boolean bEncrypt = false;
	String tmp = m_IP.getParameter("encrypt");
	if ((tmp != null) && tmp.equals("on")) bEncrypt = true;

	//������ �ʿ��� ������ ���� üũ
	String strClientAuth = null;
	String certInfo = "";
	String serial="";
	if (m_IP.isClientAuth()==false)
		strClientAuth = "����� ������ �ʿ��մϴ�.";
	else {
		strClientAuth = "����� �����̵� �������Դϴ�.";

		X509Certificate userCert = m_IP.getClientCertificate();
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// ������ �߱���
		Date NotAfter = userCert.getNotAfter();		// ������ ������
		Date currentTime = new Date();				// ���� �ð�
		int dateformat = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>�߱��� : " + userCert.getIssuerDN().toString();
		certInfo += "<br>�߱޴�� : " + userCert.getSubjectDN().toString();
		certInfo += "<br>�߱��� : " + myDate.format(NotBefore);
		certInfo += "<br>������ : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>����ð� : " + myDate.format(currentTime);
		certInfo += "<br>������ �������� ";
		certInfo += dateformat;
		certInfo += "�� �Ŀ� ���ᰡ �˴ϴ�.";
		
		serial=userCert.getSerialNumber().toString(10);

	}
//	out.println(request.getParameter("INIpluginData"));

	//ȯ�漳�� ���� �о���� ����
	String strEncAlg = m_IP.getProperty("DataEncryptAlg");
	String strIniJS = m_IP.getProperty("INIplugin.js");
	String strTime = m_IP.getProperty("TimeDifference");

	StringBuffer sb = new StringBuffer();
	Enumeration enumlist = m_IP.getParameterNames();
	while (enumlist.hasMoreElements()) {
		String nameval = (String)enumlist.nextElement();
		String value = m_IP.getParameter(nameval);
		sb.append("<br>[" + nameval + "] = [" + value + "]");
	}
	

%>

<html>
<head>
	<title>Crypto Test Result</title>	
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>
<% if (bEncrypt) out = m_IP.startEncrypt(out); %>

<br><b><%=strClientAuth%></b>
<%=certInfo%>
<br>
<%=serial%>
<br>
<p><b>�Ʒ��� ������ INIpluginData�Դϴ�.</b>
<br>[<%=request.getParameter("INIpluginData")%>]<br>

<p><b>�Ʒ��� ������ INIplugin SDK�� ����ϴ� ȯ�溯���� �д� �����Դϴ�.</b>
<br>m_IP.getProperty("DataEncryptAlg") = <%=strEncAlg%>
<br>m_IP.getProperty("INIplugin.js") = <%=strIniJS%>
<br>m_IP.getProperty("TimeDifference") = <%=strTime%>

<br><br><b> m_IP.getParameterNames�� ��ȣȭ �� ���Դϴ�.</b>
<%= sb.toString() %>

<br><br><b> IP.getDecryptParameter().toString() </b>
<%= m_IP.getDecryptParameter().toString() %>

<br><br>
<center><input type=button value="�ǵ��ư���" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

<% if (bEncrypt) out = m_IP.endEncrypt(out); %>
</body></html>
