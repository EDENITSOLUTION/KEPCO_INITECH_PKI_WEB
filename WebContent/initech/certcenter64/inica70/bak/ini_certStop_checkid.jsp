<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>

<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certStop"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_db_check.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>

<html>
<head>
	<title>������ ȿ������</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript" src="/initech/plugin/INIutil.js"></script>
	<script language="javascript">
	var bAutoSubmit = true;
	function CheckSendForm(readForm, sendForm)
	{
		bAutoSubmit = false;

		if (EncForm2(readForm, sendForm)) {
			ViewMsg();
			sendForm.submit();
			return false;
		}
		alert("������ ȿ������ ��û�� ��� �Ǿ����ϴ�.");
		return false;
	}

	function ViewMsg()
	{
		var msg = "������������ �������� ȿ�������� �Դϴ�. ��ø� ��ٸ��ʽÿ�.";
		setMsg(msg, 0, 200);
		showMsg();
	}

	function AutoSubmit()
	{
		if (bAutoSubmit)
			return CheckSendForm(readForm, sendForm);
	}

	function AutoRequest()
	{
		setTimeout("AutoSubmit()", 5000);
	}
	</script>
<style type="text/css">
<!--
.text {  font-family: "����"; font-size: 11px; text-decoration: none; line-height: 15px}
-->
</style>
</head>

<body onLoad="defaultStatus='';">
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>
<table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="107" align="center" valign="bottom"><font face="����" size="4"><b>- ������ ȿ������ -</b></font><br>
      <br>
    </td>
  </tr>
  <tr> 
    <td align="center">
<form name=sendForm method=POST action='./ini_certStop_send.jsp'>
	<input type=hidden name=INIpluginData value="">
</form>

<form name=readForm onsubmit='return CheckSendForm(this, sendForm);'>
	<input type=hidden name=id value="<%=m_ID%>">
	<input type=hidden name=regno value="<%=m_REGNO%>">
	<input type=hidden name=serialno value="<%=m_certserial%>">

	<div align="center">
      <table border="0" cellspacing="1" width="370">
        <tr> 
          <td width="100%" align="left" class="text"> 
              <%=m_ID%>���� �������� ȿ������ ��û���Դϴ�.<br>
              �Ʒ��� ȿ������ ��ư�� ������ <%=m_ID%>���� �������� ȿ�������˴ϴ�.<br>
          </td>
        </tr>
        <tr> 
          <td height="27">&nbsp;</td>
        </tr>
        <tr align="center"> 
          <td><input type="image" src="img/icon_8.gif" border="0" alt="Ȯ��"></td>
        </tr>
      </table>
	</div>
</form>
    </td>
  </tr>
</table>

<% try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} %>
</body>
</html>
