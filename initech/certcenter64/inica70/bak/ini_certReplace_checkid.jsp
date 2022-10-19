<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>

<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certReplace"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_db_check.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>

<html>
<head>
	<title>������ ��߱� ��û</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript" src="/initech/plugin/INIutil.js"></script>
	<script language="javascript">
	var bAutoSubmit = true;
	function CheckSendForm(readForm, sendForm)
	{
		bAutoSubmit = false;

		// 1024, 2048 ����
		var bits = (document.forms["readForm"].keybits[0].checked)?"1024":"2048";
		SetProperty("SetBitPKCS10CertRequest", bits);

		if(CertRequest(readForm))
			if (EncForm2(readForm, sendForm)) {
				ViewMsg();
				sendForm.submit();
				return false;
			}
		alert("������ ��û�� ��� �Ǿ����ϴ�.");
		return false;
	}

	function ViewMsg()
	{
		var msg = "������������ �������� �޾ƿ��� ���Դϴ�. ��ø� ��ٸ��ʽÿ�.";
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
.text {  font-family: "����"; font-size: 12px; text-decoration: none; line-height: 17px}
-->
</style>
</head>

<body onLoad="defaultStatus='';">
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>

<table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="107" align="center" valign="bottom"><font face="����" size="4"><b>- ������ ��߱� -</b></font><br>
      <br>
    </td>
  </tr>
  <tr> 
    <td align="center">

<form name=sendForm method=POST action='./ini_certReplace_send.jsp'>
	<input type=hidden name=INIpluginData value="">
</form>

<form name=readForm onsubmit='return CheckSendForm(this, sendForm);'>
	<input type=hidden name=id value="<%=m_ID%>">
	<input type=hidden name=regno value="<%=m_REGNO%>">
	<input type=hidden name=C value="<%=m_C%>">
	<input type=hidden name=L value="<%=m_L%>">
	<input type=hidden name=O value="<%=m_O%>">
	<input type=hidden name=OU value="<%=m_OU%>">
	<input type=hidden name=CN value="<%=m_CN%>">
	<input type=hidden name=EMAIL value="<%=m_MAIL%>">
	<input type=hidden name=serialno value="<%=m_certserial%>">
	<input type=hidden name=req value="">

	<div align="center">
	<table border="0" cellspacing="1" width="370">
        <tr> 
          <td width="100%" align="left"> 
            <p> <font face="����" size="2"><span class="text"><%=m_CN%>���� �������� ��߱� ��û���Դϴ�.<br>
              �Ʒ��� ���� ��ư�� ������ ������ ���� ��߱� ������ ������ �˴ϴ�.</span></font><span class="text"><font face="����" size="2" color="#3366FF"><br>
                KeyBits: <input type=radio name=keybits value="1024"> 1024 <input type=radio name=keybits value="2048" checked> 2048<br>
              <br>
              <b>*��߱�����</b><br>
              </font><font face="����" size="2"> (1) PC�� ������ ������ ��ȣ �Է�<br>
              (2) ������� ����Ű ����<br>
              (3) ���������� ������ ��߱� ��û<br>
              (4) ������ ��߱�</font></span> 
          </td>
        </tr>
        <tr> 
          <td height="27">&nbsp;</td>
        </tr>
        <tr align="center"> 
          <td><input type="image" src="img/icon_8.gif" border="0" alt="Ȯ��"></td>
        </tr>
      </table>
</form>
    </td>
  </tr>
</table>

<% try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} %>
</body>
</html>
