<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<title>������ ��ȸ - ����� ��ȸ���� �����Է�</title>	

	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript" src="/initech/plugin/INIutil.js"></script>
	<script language="JavaScript">

	function CheckSendForm(readForm, sendForm)
	{
		if (readForm.searchcode.value == "1")
		{
			if (readForm.searchcontents.value.length == 0)
			{
				var text1 = "������ �Ϸù�ȣ�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
				alert(text1);
				readForm.searchcontents.focus();
				return false;
			}
		}
		else if (readForm.searchcode.value == "2")
		{
			if (readForm.searchcontents.value.length < 4)
			{
				var text2 = "4�ڸ� �̻��� ID�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
				alert(text2);
				readForm.searchcontents.focus();
				return false;
			}
		}
		else if (readForm.searchcode.value == "3")
		{
			if (readForm.searchcontents.value.length != 13)
			{
				var text3 = "13�ڸ��� �ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
				alert(text3);
				readForm.searchcontents.focus();
				return false;
			}
		}

		if (EncForm2(readForm, sendForm)) {
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
<form action="./ini_certSearch_checkid.jsp" method=POST name=sendForm>
    <input type=hidden name=INIpluginData value="">
</form>

<form name="readForm" onsubmit="return CheckSendForm(this, sendForm)">
<div align="left">
<table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="107" align="center" valign="bottom"><font face="����" size="4"><b>- ������ ��ȸ -</b></font><br>
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
          <td width="120" align="center" bgcolor="C2C0C1"> 
            <p> <font face="����" size="2">������ ��ȸ ����</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7"> 
            <p> <font face="����" size="2"> 
				<select name="searchcode">
					<option value="1">������ �Ϸ� ��ȣ</option>
					<option value="2">������ ID</option>
					<option value="3">�ֹ�(�����) ��� ��ȣ</option>
				</select>
              </font> 
          </td>
        </tr>
        <tr>
          <td width="120" align="center" bgcolor="C2C0C1">
            <p> <font face="����" size="2">������ ��ȸ��</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7">
            <p> <font face="����" size="2">
              <input type="text" name="searchcontents" 
			maxlength="24" size="33">
              </font>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
	  <td colspan="2" align="center">
	    <input type=image src="img/icon_8.gif" border="0" alt="���" name="image" >
	  </td>
        </tr>
      </table>
    </td>
  </tr>
</table></div></form>
</body>
</html>
