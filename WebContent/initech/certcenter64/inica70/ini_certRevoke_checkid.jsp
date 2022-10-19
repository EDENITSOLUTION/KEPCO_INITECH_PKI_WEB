<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certRevoke"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_db_check.jsp" %>
<%@ include file="import/inica70_userSet.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>
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
	var bAutoSubmit = true;
	function CheckSendForm(readForm, sendForm)
	{
		bAutoSubmit = false;

		if (EncForm2(readForm, sendForm)) {
			ViewMsg();
			sendForm.submit();
			return false;
		}
		alert("인증서 폐기신청이 취소 되었습니다.");
		return false;
	}

	function ViewMsg()
	{
		var msg = "인증서버에서 인증서를 폐기중 입니다. 잠시만 기다리십시요.";
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

<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body onload="defaultStatus='';">
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>

<div id="header"> 
	<!-- MAIN MENU START -->
	<script language="javascript">dspMainMenu();</script>
	<!-- MAIN MENU END -->
</div>

<div style="height:10px;"></div>
<div id="subtop">
	<ul class="subtoptxt">
		<li class="toptxtcon">인증센터 이용하기</li>
		<li class="toptxtcon01">인증서 발급</li>
		<li class="toptxtcon01" style="text-decoration:underline;">인증서 폐기</li>
		<li class="toptxtcon01">인증서 관리</li>
	</ul>
</div>
<form name="sendForm" method="post" action="./ini_certRevoke_send.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm" onsubmit="return CheckSendForm(this, sendForm);">
	<input type="hidden" name="id" value="<%=m_ID%>">
	<input type="hidden" name="pw" value="<%=m_pw%>">
	<input type="hidden" name="regno" value="<%=m_REGNO%>" />
	<input type="hidden" name="serialno" value="<%=m_certserial%>" />
	<input type="hidden" name="strBrg" value="N" />
<div id="sub2issue">
	<ul>
		<li><img src="img/subtitle0102.gif" alt="인증서폐기_인증서 분실(인증서 비밀번호를 잊어버린 경우, 이용하는 컴퓨터가 변경된 경우, 인증서가 삭제 된 경우)시 다시 인증서를 발급받
으시면 사용 가능합니다."></li>
		<li class="stitle"><img src="img/subtitle0205.gif" alt="인증서폐기_진행"></li>
		<li class="box">
			<ul>
				<li class="sbtextbg"> - <b class="txblue"><%=certUserNm%>(<%=m_ID%>)</b>님의 인증서를 폐기하고자 합니다.</li>
				<li class="sbtextbg2" style="padding-top:10px; padding-left:21px;"><img src="img/bullet_list.gif" align="center"> 인증서를 폐기하시겠습니까?</li>
				<!-- <li class="sbtextbg2" style="padding-top:10px; padding-left:21px;"><img src="img/bullet_list.gif" align="center"> 이 페이지는 1초 후 <a href="sub01_02_02.html">다음페이지로 자동으로 이동</a>됩니다.</li> -->
				<li class="dotted1"></li>
				<li style="float:right; padding:8px 22px 0px 0px;"></li>
				<li class="sbtextbg2" style="padding-top:10px; text-align:center;">
					<input type="image" src="img/btn_disuse_new.gif" align="center">
				</li>
				<li class="sbtextbg2">&nbsp;</li>
			</ul>
		</li>
		
	</ul>
	<div style="height:90px;"></div>
</div>
</form>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

<% try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} %>
</body>
</html>