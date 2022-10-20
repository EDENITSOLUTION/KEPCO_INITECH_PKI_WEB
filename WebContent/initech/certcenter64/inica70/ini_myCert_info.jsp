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


	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script src="/initech/plugin/cert.js"></script>
	<script src="/initech/plugin/install.js"></script>
<script language="javascript">
function CheckSendFormVerify(readForm, sendForm) {
	InitCache();
	if (EncFormVerify2(readForm, sendForm)) {
		sendForm.submit();
		return;
	} else {
		//alert("보안상 문제가 생겨 전송이 취소 되었습니다.");
	}
	return;
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
		<li class="toptxtcon01"><a href="ini_certNew.jsp">인증서 발급</a></li>
		<li class="toptxtcon01"><a href="ini_certRevoke.jsp">인증서 폐기</a></li>
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_myCert_info.jsp">인증서 관리</a></li>
	</ul>
</div>
<div id="subissue">
	<ul>
		<li><img src="img/subtitle_mycertInfo.gif" alt="나의 인증서 조회"></li>
		<li class="stitle">&nbsp;<!-- <img src="img/subtitle0201.gif" alt="인증서발급_입력"> --></li>
		
		<li class="box" style="height:160px;">
			<form name="readForm">
				<input type="hidden" name="INIpluginData">
			</form>
			<form name="sendForm1" action="ini_myCert_info_view.jsp" method="post">
				<input type="hidden" name="INIpluginData">
			</form>
			<ul>
				<li class="sbtextbg"> - 나의 인증서 조회를 위하여 인증서 조회 버튼을 클릭하십시오.</li>
				
				<li style="float:left; padding-left:80px; height:30px;">
					<img src="img/btn_myCert_info.gif" border="0" alt="나의 인증서 조회" style="cursor:pointer;"  onclick="CheckSendFormVerify(document.readForm, document.sendForm1);">
					<a href="#" onclick="location.href='index.jsp';"><img src="img/btn_myCert_info_cancel.gif" alt="인증서 조회 취소"></a>
				</li>
			</ul>
		</li>
	</ul>

	<div style="height:90px;"></div>
</div>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

</body>
</html>
