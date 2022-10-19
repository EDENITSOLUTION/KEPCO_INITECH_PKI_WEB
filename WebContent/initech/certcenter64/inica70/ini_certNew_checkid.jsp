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
if (isCert.equals("Y")) { //�̹� ������ �߱޹��� ������ �ִٸ� ����������� ������
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
  <title>������ �߱�</title>
	<script type="text/javascript" src="/initech/plugin/INIplugin.js"></script>
	<script type="text/javascript" src="/initech/plugin/INIutil.js"></script>
	<script type="text/javascript">
	<!--
	function CheckSendForm() {
		//alert("<%=certUserNm%>(<%=m_CN%>)�Բ����� ���� �߱޹��� �������� �����մϴ�.\n\n���� �߱޹��� �������� �����ϰ� �űԷ� �߱��մϴ�.");
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
		var msg = "����� Ȯ���� �Դϴ�. ��ø� ��ٸ��ʽÿ�.";
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
}else{ //���� �߱޳����� ���ٸ� �ٷ� �߱�ó��
	
	//�űԺ�й�ȣ�� ���� ��й�ȣ ��
	if ( userPwdCheck.equals("Y") ) {

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
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
var bAutoSubmit = true;

//�н����带 ������������ �ޱ� ���� �߰� ����
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
	
	//������ ��й�ȣ �Է� ui ǥ�õ��� �ʵ��� ����
	//������ ���� UI�� ǥ�õ��� �����Ƿ� �ϵ��ũ�� ������.
	SetProperty("InputPwdSkipForCertReq","true");
	
	req = obj.CertRequest(InitechPackage, "HDD", dn, "<%=m_IP.getParameter("certpass")%>"); 
	
	if(req=="") return false;
	form.req.value = req;
	
	return true;		
}
//�н����带 ������������ �ޱ� ���� �߰� ����

function CheckSendForm(readForm, sendForm)
{
	bAutoSubmit = false;
	
	// 1024, 2048 ����
	//var bits = (document.forms["readForm"].keybits[0].checked)?"1024":"2048";
	var bits = "2048";
	SetProperty("SetBitPKCS10CertRequest", bits);
	
	// p10 �׽�Ʈ�� ���� DN�� ����
	// var dn = CertRequest_DN(readForm);
	//alert(dn);
	
	//if(CertRequest(readForm))
	if(CertRequest_NoUI(readForm))
		if (EncForm2(readForm, sendForm)) {
			ViewMsg();
			sendForm.submit();
			return false;
		}
	alert("������ ��û�� ��� �Ǿ����ϴ�.");
	return false;
}

function ViewMsg()
{
	var msg = "������������ �������� �޾ƿ��� ���Դϴ�. ��ø� ��ٸ��ʽÿ�.";
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
		<li class="toptxtcon">�������� �̿��ϱ�</li>
		<li class="toptxtcon01" style="text-decoration:underline;">������ �߱�</li>
		<li class="toptxtcon01">������ ���</li>
		<li class="toptxtcon01">������ ����</li>
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
		<li><img src="img/subtitle0101.gif" alt="�������߱�_�������� �߱��ص帳�ϴ�."></li>
		<li class="stitle"><img src="img/subtitle0202.gif" alt="�������߱�_����"></li>
		<li class="box">
			<ul>
				<li class="sbtextbg">
					- <b class="txblue"><%=certUserNm%>(<%=m_ID%>)</b> ���� �������� �Ʒ��� ���� ������ �߱��մϴ�.		<span style="color:#ffffff;">67</span>		
				</li>
				<li class="sbtextbg">
					&nbsp;&nbsp;&gt; �߱ޱ��� : <b class="txblue"><%=CertGb%></b><br />
					&nbsp;&nbsp;&gt; ������ ����Ű ���� : <b class="txblue">2048 Bit</b><br />
					&nbsp;&nbsp;&gt; ������ �߱ޱ�� : <b class="txblue"><%=m_O%> <!-- <%=m_OU%> --></b>
				</li>
				<li class="sbtextbg2">&nbsp;</li>
				<li class="sbtextbg2"><b>�߱�����</b></li>
				<li class="textimg"><img src="img/sub_page02.gif" alt="�߱�����"></li>
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
	} else { //���� ��й�ȣ�� ���ٸ� �ٽ� �߱� ��������
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>�������� �̿�ȳ�</title>
<link rel="stylesheet" type="text/css" href="css/import.css" />
<link rel="stylesheet" type="text/css" href="css/main.css" />

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.flexslider-min.js"></script>
<script type="text/javascript" src="js/jquery.als-1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>

<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
<script language="javascript">
	function fncAlert() {
		alert("������ �߱޹����� ������ ��й�ȣ�� �����մϴ�.\n\n������ �߱޹����� ������ ��й�ȣ�� �ٸ� ��й�ȣ�� �Է��Ͽ� �ֽʽÿ�!");
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
} //���� �߱޳����� ���� �ٷ� �߱�//
%>