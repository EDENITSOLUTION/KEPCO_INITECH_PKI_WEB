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
	<title>������ ��ȸ ���</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
<style type="text/css">
<!--
.text {  font-family: "����"; font-size: 12px; text-decoration: none; line-height: 17px}
-->
</style>
</head>

<body>
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>

<table width="570" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td height="107" align="center" valign="bottom"><font face="����" size="4"><b>- ������ ��ȸ -</b></font><br>
		<br>
		<br>
		</td>
	</tr>
</table>

<table width="800" border="1" cellspacing="1" cellpadding="1">
	<tr align="center"><td><b>�ʵ��</b></td><td><b>������</b></td></tr>
	<tr><td>��ϴ������ڵ�</td><td><%=m_seCACODE%></td></tr>
	<tr><td>�ܸ�����ID</td><td><%=m_seMANAGERID%></td></tr>
	<tr><td>������å�ĺ��ڵ�</td><td><%=m_seCERTPOLICY%></td></tr>
	<tr><td>�������Ϸù�ȣ</td><td><%=m_seCERTSERIAL%></td></tr>
	<tr><td>������ID</td><td><%=m_seUSERID%></td></tr>
	<tr><td>������DN��</td><td><%=m_seSUBJECTDN%></td></tr>
	<tr><td>�ֹ�(�����)��Ϲ�ȣ</td><td><%=m_seIDNO%></td></tr>
	<tr><td>��ȿ�Ⱓ����</td><td><%=m_seSVDATE%></td></tr>
	<tr><td>��ȿ�Ⱓ����</td><td><%=m_seEVDATE%></td></tr>
	<tr><td>����������</td><td><%=m_seCERTSTATUS%></td></tr>
	<tr><td>�ѷ��ڵ��</td><td><%=m_seTOTALRECORDNUM%></td></tr>
	<tr><td>�����ڵ��ȣ</td><td><%=m_seCURRENTRECORNUM%></td></tr>
</table>

<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>
</body>
</html>
