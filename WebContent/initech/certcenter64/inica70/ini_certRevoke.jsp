<%@ page contentType="text/html;charset=EUC-KR" %>
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
	function CheckSendForm()
	{
		
		//alert(readForm);
		var readForm = document.readForm;
		var sendForm = document.sendForm;
		//alert(readForm.id.value);

		if (readForm.id.value.length == 0) {
			var text1 = "사번을 입력하십시요.\n\n확인하신후 다시 입력해 주세요.";
			alert(text1);
			readForm.id.focus();
			return false;
		}
		
		if (readForm.pw.value.length == 0) {
			var text2 = "인증서 비밀번호를 입력해 주세요.";
			alert(text2);
			readForm.pw.focus();
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
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_certRevoke.jsp">인증서 폐기</a></li>
		<li class="toptxtcon01"><a href="ini_myCert_info.jsp">인증서 관리</a></li>
	</ul>
</div>
<form action="./ini_certRevoke_checkid.jsp" method="post" name="sendForm">
    <input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm">
	<input type="hidden" name="regno" value="0000000000000" />	
	<input type="hidden" name="strBrg" value="N" />

<div id="sub2issue">
	<ul>
		<li><img src="img/subtitle0102.gif" alt="인증서폐기_인증서 분실(인증서 비밀번호를 잊어버린 경우, 이용하는 컴퓨터가 변경된 경우, 인증서가 삭제 된 경우)시 다시 인증서를 발급받
으시면 사용 가능합니다."></li>
		<li class="stitle"><img src="img/subtitle0204.gif" alt="인증서폐기_입력"></li>
		<li class="box" style="height:160px;">
			<ul>
				<li class="sbtextbg"> - 신분확인에 필요한 아래의 정보를 입력하십시오.</li>
				<li class="sbtextbg2"><b>사원번호</b> 
					<!-- <input name="id" onkeypress="return KeyCheckID(event);" type="text"  size="20" style="border: 1px solid #dedede;" /> -->
					<input type="text" name="id"  size="20" style="border: 1px solid #dedede;width:145px;" />
				</li>
				<li class="sbtextbg2"><b>비밀번호</b>
					<input type="password" name="pw"  size="20" style="border: 1px solid #dedede;width:145px;" />
				</li>
				
				<li class="dotted1"></li>
				<li style="float:left; padding-left:80px;">
					<!-- <a href="sub01_02_01.html"><img src="img/btn_disuse.gif" alt="폐기"></a> -->
					<img src="img/btn_disuse_new.gif" alt="폐기" border="0"  style="cursor:pointer;"  onclick="CheckSendForm();" />
					<a href="#" onclick="document.readForm.reset();"><img src="img/btn_re-input_new.gif" alt="재입력"></a>
				</li>
			</ul>
		</li>
		
	</ul>
	<div style="height:90px;"></div>
</div>
</form>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

</body>
</html>

