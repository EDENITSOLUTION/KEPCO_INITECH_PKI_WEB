<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ include file="import/iniplugin_init.jsp" %>

<% m_How = "certSearch"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_ca_send.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>

<html>
<head>
	<title>인증서 조회 결과</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
<style type="text/css">
<!--
.text {  font-family: "돋움"; font-size: 12px; text-decoration: none; line-height: 17px}
-->
</style>
</head>

<body>
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>

<table width="570" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td height="107" align="center" valign="bottom"><font face="돋움" size="4"><b>- 인증서 조회 -</b></font><br>
		<br>
		<br>
		</td>
	</tr>
</table>

<table width="800" border="1" cellspacing="1" cellpadding="1">
	<tr align="center"><td><b>필드명</b></td><td><b>데이터</b></td></tr>
	<tr><td>등록대행기관코드</td><td><%=m_seCACODE%></td></tr>
	<tr><td>단말기운영자ID</td><td><%=m_seMANAGERID%></td></tr>
	<tr><td>인증정책식별코드</td><td><%=m_seCERTPOLICY%></td></tr>
	<tr><td>인증서일련번호</td><td><%=m_seCERTSERIAL%></td></tr>
	<tr><td>가입자ID</td><td><%=m_seUSERID%></td></tr>
	<tr><td>가입자DN명</td><td><%=m_seSUBJECTDN%></td></tr>
	<tr><td>주민(사업자)등록번호</td><td><%=m_seIDNO%></td></tr>
	<tr><td>유효기간시작</td><td><%=m_seSVDATE%></td></tr>
	<tr><td>유효기간종료</td><td><%=m_seEVDATE%></td></tr>
	<tr><td>인증서상태</td><td><%=m_seCERTSTATUS%></td></tr>
	<tr><td>총레코드수</td><td><%=m_seTOTALRECORDNUM%></td></tr>
	<tr><td>현레코드번호</td><td><%=m_seCURRENTRECORNUM%></td></tr>
</table>

<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>
</body>
</html>
