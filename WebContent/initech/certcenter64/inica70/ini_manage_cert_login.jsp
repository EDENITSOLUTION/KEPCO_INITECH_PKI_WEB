<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%
//************************************************
//      ������ ���� üũ
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
if (adminLogin == null) {

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=11"/>
<title>�������� �̿�ȳ�</title>
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
		alert("�α��� ID�� �Է��Ͻʽÿ�");
		readForm.id.focus();
		return false;
	}
	if (readForm.pw.length ==0) 	{
		alert("�α��� ��й�ȣ�� �Է��Ͻʽÿ�");
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
		<li class="toptxtcon">�������� ������</li>
		<!--
		<li class="toptxtcon01" style="text-decoration:underline;width:150px;text-align:left;">������ �߱� ���� ��ȸ</li>
		<li class="toptxtcon01">&nbsp;</li>
		<li class="toptxtcon01">&nbsp;</li>
		-->
	</ul>
</div>


<div id="subissue">
	<ul>
		<li><img src="img/subtitle_manage.gif" alt="������ �α���"></li>
		<li class="stitle">&nbsp;<!-- <img src="img/subtitle0201.gif" alt="�������߱�_�Է�"> --></li>
		
		<li class="box" style="height:160px;">
			<form action="./ini_manage_cert_login_check.jsp" method="post" name="sendForm">
			<input type="hidden" name="INIpluginData" value="" />
			</form>
			<form name="readForm">
			<ul>
				<li class="sbtextbg"> - ������ �߱޳��� ��ȸ�� ���� ������ ID �� ��й�ȣ�� �Է��Ͻʽÿ�.</li>
				<li class="sbtextbg2">
					<b>����� ID</b> 
					<input type="text" name="id" maxlength="8" size="20" style="width:150px; border: 1px solid #dedede;" />
				</li>

				<li class="sbtextbg2">
					<b>��й�ȣ</b> 
				<input type="password" name="pw" maxlength="30" size="21" onkeydown="enterCheck();" style="margin-left:5px;width:150px;  border: 1px solid #dedede;" />
				</li>

				<li class="dotted1"></li>
				<li style="float:left; padding-left:80px; height:30px;">
					<img src="img/login_new.gif" border="0" alt="�α���" style="cursor:pointer;"  onclick="CheckSendForm();">
					<a href="#" onclick="document.readForm.reset();"><img src="img/btn_re-input_new.gif" alt="���Է�"></a>
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
<%
}else{
	response.sendRedirect("ini_manage_cert.jsp");
}
%>
