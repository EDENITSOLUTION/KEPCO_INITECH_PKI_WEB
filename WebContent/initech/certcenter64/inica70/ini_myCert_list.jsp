<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
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
		<li class="stitle02">�߱޳�����ȸ</li>
		<li class="stitle">&nbsp;<!-- <img src="img/subtitle0201.gif" alt="�������߱�_�Է�"> --></li>
		
		<li class="box" style="height:160px;">
			<form action="./ini_myCert_check.jsp" method="post" name="sendForm">
			<input type="hidden" name="INIpluginData" value="" />
			</form>
			<form name="readForm">
			<ul>
				<li class="sbtextbg"> - ������ �߱޳��� ��ȸ�� ���� ����� ID �� ��й�ȣ�� �Է��Ͻʽÿ�.</li>
				<li class="sbtextbg2">
					<b>�����ȣ</b> 
					<input type="text" name="id" maxlength="8" size="20" style="width:150px; border: 1px solid #dedede;" />
				</li>

				<li class="sbtextbg2">
					<b>��й�ȣ</b> 
					<input type="password" name="pw" maxlength="30" size="21" onkeydown="enterCheck();" style="width:150px; border: 1px solid #dedede;" />
				</li>

				<li class="dotted1"></li>
				<li style="display:table; margin:0 auto; height:30px;">
					<img src="img/login_new.gif" border="0" alt="�α���" style="cursor:pointer;"  onclick="CheckSendForm();">
					<a href="#" onclick="document.readForm.reset();"><img src="img/btn_re-input_new.gif" alt="���Է�"></a>
				</li>
			</ul>
			</form>
		</li>
	</ul>

	
</div>


</body>
</html>
