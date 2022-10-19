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

	//인증이 필요한 페이지 인지 체크
	String strClientAuth = null;
	String certInfo = "";
	String serial="";
	if (m_IP.isClientAuth()==false)
		strClientAuth = "사용자 인증이 필요합니다.";
	else {
		strClientAuth = "사용자 인증이된 페이지입니다.";

		X509Certificate userCert = m_IP.getClientCertificate();
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// 인증서 발급일
		Date NotAfter = userCert.getNotAfter();		// 인증서 만기일
		Date currentTime = new Date();				// 현재 시간
		int dateformat = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>발급자 : " + userCert.getIssuerDN().toString();
		certInfo += "<br>발급대상 : " + userCert.getSubjectDN().toString();
		certInfo += "<br>발급일 : " + myDate.format(NotBefore);
		certInfo += "<br>만료일 : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>현재시간 : " + myDate.format(currentTime);
		certInfo += "<br>고객님의 인증서는 ";
		certInfo += dateformat;
		certInfo += "일 후에 만료가 됩니다.";
		
		serial=userCert.getSerialNumber().toString(10);

	}
//	out.println(request.getParameter("INIpluginData"));

	//환경설정 변수 읽어오는 예제
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
<p><b>아래의 내용은 INIpluginData입니다.</b>
<br>[<%=request.getParameter("INIpluginData")%>]<br>

<p><b>아래의 내용은 INIplugin SDK가 사용하는 환경변수를 읽는 예제입니다.</b>
<br>m_IP.getProperty("DataEncryptAlg") = <%=strEncAlg%>
<br>m_IP.getProperty("INIplugin.js") = <%=strIniJS%>
<br>m_IP.getProperty("TimeDifference") = <%=strTime%>

<br><br><b> m_IP.getParameterNames로 복호화 한 값입니다.</b>
<%= sb.toString() %>

<br><br><b> IP.getDecryptParameter().toString() </b>
<%= m_IP.getDecryptParameter().toString() %>

<br><br>
<center><input type=button value="되돌아가기" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

<% if (bEncrypt) out = m_IP.endEncrypt(out); %>
</body></html>
