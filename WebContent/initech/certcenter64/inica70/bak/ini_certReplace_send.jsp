<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>

<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certReplace"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_ca_send.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>

<html>
<head>
	<title>������ ��߱� ���</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript">
		var UserCert;
		<%=m_caCertString%>
	</script>
<style type="text/css">
<!--
.text {  font-family: "����"; font-size: 12px; text-decoration: none; line-height: 17px}
-->
</style>
</head>

<body OnLoad="InsertUserCert(UserCert);">
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>

<table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="107" align="center" valign="bottom"><font face="����" size="4"><b>- ������ ��߱� -</b></font><br>
      <br>
    </td>
  </tr>
  <tr> 
    <td align="center">
<div align="center">
<table border="0" cellspacing="1" width="370">
        <tr> 
          <td width="100%" align="left" class="text"> <%=m_CN%>���� �������� ���������� ��߱� �Ǿ����ϴ�.<br>
            <br>
            �������� ��ȿ�Ⱓ�� �߱��Ϸκ��� 1���̸�<br>
            ��ȿ�Ⱓ�� ���� �������� ����ϽǼ� �����ϴ�.<br>
            <br>
            <br>
            �̿��� �ּż� �����մϴ�. </td>
        </tr>
      </table>
</div>
    </td>
  </tr>
</table>

<% try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} %>
</body>
</html>
