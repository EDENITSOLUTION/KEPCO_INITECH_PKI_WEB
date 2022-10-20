<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="Progma" content="no-cache">
	<title>인증서 효력회복 - 사용자 신분확인 정보입력</title>	

	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript" src="/initech/plugin/INIutil.js"></script>
	<script language="JavaScript">

	function CheckSendForm(readForm, sendForm)
	{
		if (readForm.id.value.length < 4) {
			var text1 = "4자리 이상의 ID를 입력하십시요.\n\n확인하신후 다시 입력해 주세요.";
			alert(text1);
			readForm.id.focus();
			return false;
		}
		if (readForm.regno.value.length != 13) {
			var text2 = "13자리의 주민등록번호를 입력하십시요.\n\n확인하신후 다시 입력해 주세요.";
			alert(text2);
			readForm.regno.focus();
			return false;
		}
		if (readForm.serialno.value.length == 0) {
			var text3 = "인증서 일련번호를 입력하십시요.\n\n확인하신후 다시 입력해 주세요.";
			alert(text3);
			readForm.serialno.focus();
			return false;
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
        var msg = "사용자 확인중 입니다. 잠시만 기다리십시요.";
        setMsg(msg, 0, 200);
        showMsg();
	}

	</script>
<style type="text/css">
<!--
.text {  font-family: "돋움"; font-size: 11px; text-decoration: none; line-height: 15px}
-->
</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form action="./ini_certStart_checkid.jsp" method=POST name=sendForm>
    <input type=hidden name=INIpluginData value="">
</form>

<form name="readForm" onsubmit="return CheckSendForm(this, sendForm)">
<div align="left">
<table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="107" align="center" valign="bottom"><font face="돋움" size="4"><b>- 인증서 효력회복 -</b></font><br>
      <br>
    </td>
  </tr>
  <tr> 
    <td align="center"> 
      <table border="0" cellspacing="1" width="350">
        <tr> 
          <td width="100%" align="left" colspan="2"> 
            <p> <font face="돋움" size="2" color="#3366FF">신분확인에 필요한 아래의 정보를 입력하십시요.</font> 
          </td>
        </tr>
        <tr> 
          <td width="120" align="center" bgcolor="C2C0C1"> 
            <p> <font face="돋움" size="2">ID</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7"> 
            <p> <font face="돋움" size="2"> 
              <input type="text" name="id" 
			maxlength="30" size=" 33"onKeyPress="return KeyCheckID(event);">
              </font> 
          </td>
        </tr>
        <tr>
          <td width="120" align="center" bgcolor="C2C0C1">
            <p> <font face="돋움" size="2">주민등록번호</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7">
            <p> <font face="돋움" size="2">
              <input type="text" name="regno" 
			maxlength="13" size="33" onKeyPress="return KeyCheckNum(event);">
              </font>
          </td>
        </tr>
        <tr>
          <td width="120" align="center" bgcolor="C2C0C1">
            <p> <font face="돋움" size="2">인증서 일련번호</font> 
          </td>
          <td width="250" align="left" bgcolor="F7F7F7">
            <p> <font face="돋움" size="2">
              <input type="text" name="serialno" 
			maxlength="12" size="33" onKeyPress="return KeyCheckNum(event);">
              </font>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
	  <td colspan="2" align="center">
	    <input type=image src="img/icon_8.gif" border="0" alt="취소" name="image" >
	  </td>
        </tr>
      </table>
    </td>
  </tr>
</table></div></form>
</body>
</html>
