<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<title>������ ���� - ����� �ź�Ȯ�� �����Է�</title>	

	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript" src="/initech/plugin/INIutil.js"></script>
	<script language="JavaScript">
	function CheckSendForm(readForm, sendForm)
	{
		if (readForm.id.value.length < 4) {
			var text1 = "4�ڸ� �̻��� ID�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
			alert(text1);
			readForm.id.focus();
			return false;
		}
		if (readForm.regno.value.length != 13) {
			var text2 = "13�ڸ��� �ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
			alert(text2);
			readForm.regno.focus();
			return false;
		}

		if (readForm.CN.value.length < 2) {
			var text4 = "2�ڸ� �̻��� �̸��� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
			alert(text4);
			readForm.CN.focus();
			return false;
		}
		if (readForm.EMAIL.value.length < 7) {
			var text5 = "7�ڸ� �̻��� E-Mail�̳� ��ȭ��ȣ�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
			alert(text5);
			readForm.EMAIL.focus();
			return false;
		}

		if (EncForm2(readForm, sendForm))
		{
			ViewMsg();
			sendForm.submit();
			return false;
		}
		return false;
	}

	function ViewMsg()
	{
        var msg = "����� Ȯ���� �Դϴ�. ��ø� ��ٸ��ʽÿ�.";
        setMsg(msg, 0, 200);
        showMsg();
	}

	</script>
<style type="text/css">
<!--
.text {  font-family: "����"; font-size: 11px; text-decoration: none; line-height: 15px}
-->
</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<form action="./ini_certRenew_checkid.jsp" method=POST name=sendForm>
    <input type=hidden name=INIpluginData value="">
</form>

<form name="readForm" onsubmit="return CheckSendForm(this, sendForm)">

<div align="left">
<table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="107" align="center" valign="bottom"><font face="����" size="4"><b>- ������ ���� -</b></font><br>
      <br>
    </td>
  </tr>
  <tr> 
    <td align="center"> 
      <table border="0" cellspacing="1" width="350">
        <tr> 
          <td width="100%" align="left" colspan="2"> 
            <p> <font face="����" size="2" color="#3366FF">�ź�Ȯ�ο� �ʿ��� �Ʒ��� ������ �Է��Ͻʽÿ�.</font> 
          </td>
        </tr>
        <tr> 
          <td width="100" align="center" bgcolor="C2C0C1"> 
            <p> <font face="����" size="2">ID</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7"> 
            <p> <font face="����" size="2"> 
              <input type="text" name="id" 
			maxlength="30" size=" 33"onKeyPress="return KeyCheckID(event);">
              </font> 
          </td>
        </tr>
        <tr>
          <td width="100" align="center" bgcolor="C2C0C1">
            <p> <font face="����" size="2">�ֹε�Ϲ�ȣ</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7">
            <p> <font face="����" size="2">
              <input type="text" name="regno" 
			maxlength="13" size="33" onKeyPress="return KeyCheckNum(event);">
              </font>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td width="100%" align="left" colspan="2"> 
            <p> <font face="����" size="2" color="#3366FF">�������� ���Ե� �Ʒ��� DN������ �Է��Ͻʽÿ�.</font> 
          </td>
        </tr>
        <tr> 
          <td width="100" align="center" bgcolor="C2C0C1"> 
            <p> <font face="����" size="2">�̸�(CN)</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7"> 
            <p> <font face="����" size="2"> 
              <input type="text" name="CN" value="ȫ�浿" 
			maxlength="30" size="33" >
              </font> 
          </td>
        </tr>
        <tr> 
          <td width="100" align="center" bgcolor="C2C0C1"> 
            <p> <font face="����" size="2">E-Mail</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7"> 
            <p> <font face="����" size="2"> 
              <input type="text" name="EMAIL" value="mailto@initech.com" 
			maxlength="30" size="33" onKeyPress="return KeyCheckEMAIL(event);">
              </font> 
          </td>
        </tr>
        <tr> 
          <td width="100%" align="left" colspan="2"> 
            <p><font color="#009900" size="2" face="����">�� E-Mail�� �����ź��� ��ȭ��ȣ�� 
              �Է��Ͻʽÿ�.</font> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr align="center"> 
	  <td colspan="2">
	    <input type=image src="img/icon_8.gif" border="0" alt="�߱�" name="image">
	  </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>

</form>

</body>
</html>
