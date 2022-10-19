<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR"%>
<%--@ page contentType="text/html" --%>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init2.jsp"%>

<%
	//인증이 필요한 페이지 인지 체크
	String strClientAuth = null;
	String certInfo = "";
	if (m_IP.isClientAuth()==false)
		strClientAuth = "사용자 인증이 필요합니다.";
	else {
		strClientAuth = "사용자 인증이된 페이지입니다.";

		X509Certificate userCert = m_IP.getClientCertificate();
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// 인증서 발급일
		Date NotAfter = userCert.getNotAfter();		// 인증서 만기일
		Date currentTime = new Date();				// 현재 시간
		int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>발급자 : " + userCert.getIssuerDN().toString();
		certInfo += "<br>발급대상 : " + userCert.getSubjectDN().toString();
		certInfo += "<br>발급일 : " + myDate.format(NotBefore);
		certInfo += "<br>만료일 : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>현재시간 : " + myDate.format(currentTime);
		certInfo += "<br>고객님의 인증서는 ";
		certInfo += date;
		certInfo += "일 후에 만료가 됩니다.";

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

<br><br><b> m_IP.getParameterNames로 복호화 한 값입니다.</b>
<%= sb.toString() %>

<br><br><b> IP.getDecryptParameter().toString() </b>
<%= m_IP.getDecryptParameter().toString() %><BR>
<br><br><b> Time </b>
<%= strTime %>
<br><br>
<center><input type=button value="되돌아가기" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

</body></html>
