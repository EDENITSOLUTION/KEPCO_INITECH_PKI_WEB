<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certNew"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_db_check.jsp" %>
<%@ include file="import/inica70_userSet.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>

<%
if (isCert.equals("Y")) { //이미 이전에 발급받은 정보가 있다면 폐기페이지로 보내고
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
  <title>인증서 발급</title>
	<script type="text/javascript" src="/initech/plugin/INIplugin.js"></script>
	<script type="text/javascript" src="/initech/plugin/INIutil.js"></script>
	<script type="text/javascript">
	<!--
	function CheckSendForm() {
		//alert("<%=certUserNm%>(<%=m_CN%>)님께서는 이전 발급받은 인증서가 존재합니다.\n\n이전 발급받은 인증서를 삭제하고 신규로 발급합니다.");
		var readForm = document.readForm;
		var sendForm = document.sendForm;
		if (EncForm2(readForm, sendForm)) {
			ViewMsg();
			sendForm.submit();
			return false;
		}
		return false;
	}
	function ViewMsg()	{
		var msg = "사용자 확인중 입니다. 잠시만 기다리십시요.";
		setMsg(msg, 0, 200);
		showMsg();
	}
	//-->
	</script>
 </head>
 <body onload="CheckSendForm();">
 <form name="sendForm" method="post" action="./ini_cert_bridge.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm">
<input type="hidden" name="id" value="<%=m_ID%>" />
<input type="hidden" name="regno" value="<%=m_REGNO%>" />
<input type="hidden" name="C" value="<%=m_C%>" />
<input type="hidden" name="L" value="<%=m_L%>" />
<input type="hidden" name="O" value="<%=m_O%>" />
<input type="hidden" name="OU" value="<%=m_OU%>" />
<input type="hidden" name="CN" value="<%=m_CN%>" />
<input type="hidden" name="EMAIL" value="<%=m_MAIL%>" />
<input type="hidden" name="req" value="" />
<input type="hidden" name="keybits" value="2048" />
<input type="hidden" name="pw" value="<%=m_pw%>" />
<input type="hidden" name="sms" value="<%=m_sms%>" />
<input type="hidden" name="certpass" value="<%=m_IP.getParameter("certpass")%>" />
<input type="hidden" name="strBrg" value="Y" />
<input type="hidden" name="tmid" value="<%=m_tmid%>" />
</form>  
 </body>
</html>



<%
}else{ //이전 발급내용이 없다면 바로 발급처리
	
	//신규비밀번호와 이전 비밀번호 비교
	if ( userPwdCheck.equals("Y") ) {

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
var bAutoSubmit = true;

//패스워드를 웹페이지에서 받기 위해 추가 시작
function CertRequest_NoUI(form)
{
	var dn="";
	var temp=""
	len = form.elements.length;

	form.req.value="";

	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	for (i = 0; i < len; i++) 
	{
		var name = form.elements[i].name.toUpperCase();
		var temp = form.elements[i].value;
		if(name == "C")	dn = dn + "C=" + obj.URLEncode(temp) + "&";
	//	if(name == "L")	dn = dn + "L=" + obj.URLEncode(temp) + "&";
		if(name == "O")	dn = dn + "O=" + obj.URLEncode(temp) + "&";
		if(name == "OU") dn = dn + "OU=" + obj.URLEncode(temp) + "&";
		if(name == "CN") dn = dn + "CN=" + obj.URLEncode(temp) + "&";
		if(name == "EMAIL")
		{
			if(temp=="") temp = " ";

			dn = dn + "EMAIL=" + obj.URLEncode(temp) + "&";
		}
	}
	
	//인증서 비밀번호 입력 ui 표시되지 않도록 설정
	//인증서 저장 UI가 표시되지 않으므로 하드디스크에 저장함.
	SetProperty("InputPwdSkipForCertReq","true");
	
	req = obj.CertRequest(InitechPackage, "HDD", dn, "<%=m_IP.getParameter("certpass")%>"); 
	
	if(req=="") return false;
	form.req.value = req;
	
	return true;		
}
//패스워드를 웹페이지에서 받기 위해 추가 종료

function CheckSendForm(readForm, sendForm)
{
	bAutoSubmit = false;
	
	// 1024, 2048 설정
	//var bits = (document.forms["readForm"].keybits[0].checked)?"1024":"2048";
	var bits = "2048";
	SetProperty("SetBitPKCS10CertRequest", bits);
	
	// p10 테스트를 위한 DN값 추출
	// var dn = CertRequest_DN(readForm);
	//alert(dn);
	
	//if(CertRequest(readForm))
	if(CertRequest_NoUI(readForm))
		if (EncForm2(readForm, sendForm)) {
			ViewMsg();
			sendForm.submit();
			return false;
		}
	alert("인증서 신청이 취소 되었습니다.");
	return false;
}

function ViewMsg()
{
	var msg = "인증서버에서 인증서를 받아오는 중입니다. 잠시만 기다리십시요.";
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
		<li class="toptxtcon01" style="text-decoration:underline;">인증서 발급</li>
		<li class="toptxtcon01">인증서 폐기</li>
		<li class="toptxtcon01">인증서 관리</li>
	</ul>
</div>
<form name="sendForm" method="post" action="./ini_certNew_send.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm" onsubmit="return CheckSendForm(this, sendForm);">
<input type="hidden" name="id" value="<%=m_ID%>" />
<input type="hidden" name="regno" value="<%=m_REGNO%>" />
<input type="hidden" name="C" value="<%=m_C%>" />
<input type="hidden" name="L" value="<%=m_L%>" />
<input type="hidden" name="O" value="<%=m_O%>" />
<input type="hidden" name="OU" value="<%=m_OU%>" />
<input type="hidden" name="CN" value="<%=m_CN%>" />
<input type="hidden" name="EMAIL" value="<%=m_MAIL%>" />
<input type="hidden" name="req" value="" />
<input type="hidden" name="keybits" value="2048" />
<input type="hidden" name="pw" value="<%=m_pw%>" />
<input type="hidden" name="sms" value="<%=m_sms%>" />
<input type="hidden" name="strBrg" value="N" />
<input type="hidden" name="tmid" value="<%=m_tmid%>" />
<div id="subissue">
	<ul>
		<li><img src="img/subtitle0101.gif" alt="인증서발급_인증서를 발급해드립니다."></li>
		<li class="stitle"><img src="img/subtitle0202.gif" alt="인증서발급_진행"></li>
		<li class="box">
			<ul>
				<li class="sbtextbg">
					- <b class="txblue"><%=certUserNm%>(<%=m_ID%>)</b> 님의 인증서를 아래와 같은 정보로 발급합니다.		<span style="color:#ffffff;">67</span>		
				</li>
				<li class="sbtextbg">
					&nbsp;&nbsp;&gt; 발급구분 : <b class="txblue"><%=CertGb%></b><br />
					&nbsp;&nbsp;&gt; 인증서 공개키 길이 : <b class="txblue">2048 Bit</b><br />
					&nbsp;&nbsp;&gt; 인증서 발급기관 : <b class="txblue"><%=m_O%> <!-- <%=m_OU%> --></b>
				</li>
				<li class="sbtextbg2">&nbsp;</li>
				<li class="sbtextbg2"><b>발급절차</b></li>
				<li class="textimg"><img src="img/sub_page02.gif" alt="발급절차"></li>
				<li class="dotted1"></li>
				<li style="float:right; padding:8px 22px 0px 0px;"></li>
				<li class="sbtextbg2" style="padding-top:10px; text-align:center;">
					<input type="image" src="img/btn_issue_new.gif" align="center">
				</li>
				<li class="sbtextbg2">&nbsp;</li>
			</ul>
		</li>
		
	</ul>
	<div style="height:30px;"></div>
</div>
</form>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->
<% try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} %>
</body>
</html>

<%
	} else { //이전 비밀번호와 같다면 다시 발급 페이지로
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

<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
<script language="javascript">
	function fncAlert() {
		alert("이전에 발급받으신 인증서 비밀번호와 동일합니다.\n\n이전에 발급받으신 인증서 비밀번호와 다른 비밀번호를 입력하여 주십시오!");
		location.href="/initech/certcenter64/inica70/index.jsp" ;
	}
</script>
</head> 

<body onload="fncAlert();">
</body>
</html>
<%
	}
%>

<%
} //이전 발급내용이 없어 바로 발급//
%>
