<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ include file="import/iniplugin_init.jsp" %>

<%!
	String numberStr = "";
	public static int getCheckNum(int[] arr)
	{
		int total = 0;
		for (int i = 0; i < arr.length - 1; i++)
		{
			total += (i % 8 + 2) * arr[i];
		}

		int y =  11 - (total % 11) % 10;

		if (y > 9) y -= 10;

		return y;
	}

	public String getNumber()
	{
		String result = "";
		int[] number = new int[13];
		java.util.Random r = new java.util.Random();
		int tmp;

		tmp = r.nextInt(50) + 50;
		number[0] = tmp / 10;
		number[1] = tmp % 10;

		tmp = r.nextInt(13);
		number[2] = tmp / 10;
		number[3] = tmp % 10;

		tmp = r.nextInt(32);
		number[4] = tmp / 10;
		number[5] = tmp % 10;
		number[6] = r.nextInt(2) + 1;
		number[7] = r.nextInt(10);
		number[8] = r.nextInt(10);

		tmp = r.nextInt(1000);
		number[9] = tmp / 100;
		number[10] = tmp % 100 / 10;
		number[11] = tmp % 100 % 10;
		number[12] = getCheckNum(number);

		for (int i = 0; i < 13; i++)
		{
			result += number[i] + "";
		}

		numberStr = result;

		return result;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>인증센터 이용안내</title>
<link rel="stylesheet" type="text/css" href="css/import.css" />
<link rel="stylesheet" type="text/css" href="css/main.css" />

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.flexslider-min.js"></script>
<script type="text/javascript" src="js/jquery.als-1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>

<script type="text/javascript" src="/initech/plugin/INIplugin.js"></script>
<script type="text/javascript" src="/initech/plugin/INIutil.js"></script>

<script language="javascript">
function CheckSendForm() {

	//alert(readForm);
	var readForm = document.readForm;
	var sendForm = document.sendForm;
	//alert(readForm.id.value);

	//readForm.pw.value = encodeURI(readForm.pw.value);
	//alert(readForm.pw.value);

	if (EncForm2(readForm, sendForm))
	{
		//ViewMsg();
		sendForm.submit();
		return false;
	}
	return false;
}

</script>

<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body>

<div id="header">
	<!-- MAIN MENU START -->
	<script language="javascript">dspMainMenu();</script>
	<!-- MAIN MENU END -->
</div>

<div style="height:10px;"></div>
<div id="subtop">
	<ul class="subtoptxt">
		<li class="toptxtcon">인증센터 이용하기</li>
		<li class="toptxtcon01" style="text-decoration:underline;">인증서 발급</li>
		<li class="toptxtcon01">인증서 폐기</li>
		<li class="toptxtcon01">인증서 관리</li>
	</ul>
</div>

<%=request.getRemoteAddr()%>
<div id="subissue">
	<ul>
		<li><img src="img/subtitle0101.gif" alt="인증서발급_인증서를 발급해드립니다."></li>
		<li class="stitle"><img src="img/subtitle0201.gif" alt="인증서발급_입력"></li>
		
		<li class="box">
			<form action="./ini_cs_checkid.jsp" method="post" name="sendForm">
			<input type="hidden" name="INIpluginData" value="" />
			</form>
			<form name="readForm">
			<ul>
				<li class="sbtextbg"> - 신분확인에 필요한 아래의 정보를 입력하십시오.</li>
				<li class="sbtextbg2">
					<b>사원번호</b> 
					<!-- <input type="text" name="id" maxlength="8" onkeypress="return KeyCheckID(event);"  size="20" style="border: 1px solid #dedede;"> -->
					<input type="text" name="id" maxlength="8" value="ex099129" size="20" style="border: 1px solid #dedede;" />
				</li>

				<li class="sbtextbg2">
					<b>비밀번호</b> 
					<input type="text" name="pw" maxlength="30" value="ex099129!" size="20" style="border: 1px solid #dedede;" />
				</li>
				<li class="sbtextbg2">
					<b>syncKey</b> 
					<input type="text" name="syncKey" value="5ac1bb6d4172409089a7df3aa6ec91c2"  size="20" style="border: 1px solid #dedede;" />
				</li>

				<li class="dotted1"></li>
				<li style="float:right; padding-right:22px; height:30px;">
					<img src="img/btn_issue.gif" border="0" alt="발급" style="cursor:pointer;"  onclick="CheckSendForm();">
					<a href="#" onclick="document.readForm.reset();"><img src="img/btn_re-input.gif" alt="재입력"></a>
				</li>
			</ul>
			</form>
		</li>
	</ul>

	<div style="height:90px;"></div>
</div>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

</body>
</html>
