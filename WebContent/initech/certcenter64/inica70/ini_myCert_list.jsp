<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=11"/>
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

	var readForm = document.readForm;
	var sendForm = document.sendForm;
	
	if (readForm.id.value.length ==0) 	{
		alert("로그인 ID를 입력하십시오");
		readForm.id.focus();
		return false;
	}
	if (readForm.pw.length ==0) 	{
		alert("로그인 비밀번호를 입력하십시오");
		readForm.pw.focus();
		return false;
	}
	

	if (EncForm2(readForm, sendForm))
	{
		sendForm.submit();
		return false;
	}
	return false;
}
function enterCheck(){

		if(event.keyCode == 13){
			CheckSendForm();
		} 

}
</script>
<style>
	#subissue {width:100%;}
	.sbtextbg {width:100%; padding-left:0; text-align:center;}
	.sbtextbg2 {width:37%;}
	.sbtextbg2 > b {font-size:16px;margin-right:10px;}
	.dotted1 {width:100%;}
	.box {width:100%;}
	.stitle02 {font-size:24px; padding-left:15px; font-weight:bold; color:#000;}

</style>
<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body>



<div id="subissue">
	<ul>
		<li class="stitle02">발급내역조회</li>
		<li class="stitle">&nbsp;<!-- <img src="img/subtitle0201.gif" alt="인증서발급_입력"> --></li>
		
		<li class="box" style="height:160px;">
			<form action="./ini_myCert_check.jsp" method="post" name="sendForm">
			<input type="hidden" name="INIpluginData" value="" />
			</form>
			<form name="readForm">
			<ul>
				<li class="sbtextbg"> - 인증서 발급내역 조회를 위한 사용자 ID 및 비밀번호를 입력하십시오.</li>
				<li class="sbtextbg2">
					<b>사원번호</b> 
					<input type="text" name="id" maxlength="8" size="20" style="width:150px; border: 1px solid #dedede;" />
				</li>

				<li class="sbtextbg2">
					<b>비밀번호</b> 
					<input type="password" name="pw" maxlength="30" size="21" onkeydown="enterCheck();" style="width:150px; border: 1px solid #dedede;" />
				</li>

				<li class="dotted1"></li>
				<li style="display:table; margin:0 auto; height:30px;">
					<img src="img/login_new.gif" border="0" alt="로그인" style="cursor:pointer;"  onclick="CheckSendForm();">
					<a href="#" onclick="document.readForm.reset();"><img src="img/btn_re-input_new.gif" alt="재입력"></a>
				</li>
			</ul>
			</form>
		</li>
	</ul>

	
</div>


</body>
</html>
