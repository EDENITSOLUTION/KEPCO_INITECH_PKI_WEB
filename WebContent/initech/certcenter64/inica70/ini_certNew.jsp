<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.String.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%!
public String getDateTime() {
	Locale locale = java.util.Locale.KOREA;
	SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale);
	String convertedTime = sdfr.format(new Date());
	return convertedTime;

}
%>
<%
String timeId = getDateTime() ;
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
function getStrDate(){
	Date.prototype.format = function(f) {    
    if (!this.valueOf()) return " ";     
        var weekName = ["�Ͽ���", "������", "ȭ����", "������", "�����", "�ݿ���", "�����"];    
        var d = this;         
        
        return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {        
            switch ($1) {            
               case "yyyy": return d.getFullYear();            
               case "yy": return (d.getFullYear() % 1000).zf(2);            
               case "MM": return (d.getMonth() + 1).zf(2);            
               case "dd": return d.getDate().zf(2);            
               case "E": return weekName[d.getDay()];            
               case "HH": return d.getHours().zf(2);            
               case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);            
               case "mm": return d.getMinutes().zf(2);            
               case "ss": return d.getSeconds().zf(2);            
               case "a/p": return d.getHours() < 12 ? "����" : "����";            
               default: return $1;        
             }    
        });}; 

    //���ڸ��ϰ�� �տ� 0�� �ٿ��ش�.
    String.prototype.string = function(len){
        var s = '', i = 0; 
        while (i++ < len) { s += this; } 
        return s;
    }; 
    String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
    Number.prototype.zf = function(len){return this.toString().zf(len);};

    
	return (new Date().format("yyyyMMddHHmmss"))
	// ���� 
    //2014�� 01�� 30�� ���� 01�� 45�� 02��
    //console.log(new Date().format("yyyy�� MM�� dd�� a/p hh�� mm�� ss��")); 
    //2014-01-30
    //console.log(new Date().format("yyyy-MM-dd")); 
    //'14 01.30
    //console.log(new Date().format("'yy MM.dd")); 
    //2014-01-30 �����
    //console.log(new Date().format("yyyy-MM-dd E")); 
    //����⵵ : 2014
    //console.log("����⵵ : " + new Date().format("yyyy"));
    

    //����ǥ���� �÷���
    //i : ��ҹ���  �������� ����
    //g : ������Ī ����, ù��° ��ġ���� ������ �ʰ� ��ġ�Ǵ� ��� ���� ã�´�.
    

    //alert(new Date()+"\r\n"
          //+new Date().format("yyyy�� MM�� dd�� a/p hh�� mm�� ss��")+"\r\n"
          //+new Date().format("yyyy-MM-dd"));

}








function MM_callJS(jsStr) 
{ //v2.0
	return eval(jsStr)
}

// ���� ���
String.prototype.bytes = function(){
	str = this != window ? this : str;
	var len = 0; //bug. �� ���ٶ����� �����.. �־��ּ���. -_-;; 
	for(j=0; j<str.length; j++) 
	{
		var chr = str.charAt(j);
		len += (chr.charCodeAt() > 128) ? 2 : 1
	}
	return len;
}

function isEmpty(input) {
	if (input.value == null || input.value.replace(/ /gi,"") == "") {
		return true;
	}
	return false;
}

function CheckSendForm() {

	var readForm = document.readForm;
	var sendForm = document.sendForm;
	
	if (readForm.id.value.length < 8) {
		alert("8�ڸ� �̻��� ����� �Է��Ͻʽÿ�.");
		readForm.id.focus();
		return false;
	}
	//if (readForm.regno.value.length != 13) {
		//var text2 = "13�ڸ��� �ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
		//alert(text2);
		//readForm.regno.focus();
		//return false;
	//}

	if (readForm.CN.value.length < 2) {
		var text4 = "2�ڸ� �̻��� �̸��� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
		alert(text4);
		readForm.CN.focus();
		return false;
	}
	if (readForm.EMAIL.value.length < 7) {
		var text5 = "7�ڸ� �̻��� E-Mail�̳� ��ȭ��ȣ�� �Է��Ͻʽÿ�.\n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.";
		alert(text5);
		readForm.EMAIL.focus();
		return false;
	}
	
	

	if(readForm.certpass.value.length < 1)
	{
		alert("������ ��й�ȣ�� �Է��� �ֽʽÿ�");
		readForm.certpass.focus();
		return false;
	}
	
	if(isEmpty(readForm.certpass)) 	{
		alert("���鹮�ڴ� ��й�ȣ�� ����Ҽ� �����ϴ�. �ٽ� �Է��� �ֽʽÿ�");
		readForm.certpass.focus();
		return false;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Ư������ üũ ����
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	var strTest = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~`!@#$^&*()-_+={[}]|:;<>,.?/";
	var isOk = false;
	var EngSum = false;
	var NumSum = false;
	var SstrSum = false;
	
	for(intCnt =0; intCnt < readForm.certpass.value.length; intCnt++){
		
		strChar = readForm.certpass.value.charAt(intCnt);
		if(strTest.indexOf(strChar) < 0 ){
			isOk = false;
			//alert("�Է��� �� ���� Ư������(' , '', %, \)�� �Է��ϼ̽��ϴ�."); 
			break;
		}	

		if (strChar.match(/[a-zA-Z]/)) {
			var EngSum = 1;
		}
		if (strChar.match(/[0-9]/)) {
			var NumSum = 1;
		}
		if (strChar.match(/[\~\`\!\@\#\$\^\&\*\(\)\-\_\+\=\[\]\{\}\|\:\;\,\.\<\>\?\/]/)) {
			var SstrSum = 1;
		}
		if(EngSum == true && NumSum == true && SstrSum == true ){
			isOk = true;
		}
		
	}

	if( ! isOk ){
		alert("������ ��й�ȣ �Է¶��� \n\n�Է��� �� ���� Ư������(' , '', %, \)�� �Է��ϼ̰ų�, \n\n����, ����, Ư�����ڸ� �ʼ��� �����Ͽ� 9�ڸ� �̻� �Է��ϼž��մϴ�.");
		readForm.certpass.focus();
		return false;
	}

	if( readForm.certpass.value.bytes() < 9 || readForm.certpass.value.bytes() > 30 ) {
		alert("��й�ȣ�� �ּ� 9�ڸ��̻� �ִ� 30�ڸ����Ϸ� �Է��� �ֽʽÿ�.\n���� ���� " +  readForm.certpass.value.bytes() + "���Դϴ�.");
		readForm.certpass.focus();
		return;
	}
	if (readForm.certpass1.value.length ==0 ) {
		alert("������ ��й�ȣ�� �ٽ� �ѹ� �Է��Ͻʽÿ�.");
		readForm.certpass1.focus();
		return false;
	}
	if (readForm.certpass.value != readForm.certpass1.value ) {
		
		alert("�Է��Ͻ� �ΰ��� ������ ��й�ȣ�� ���� ��ġ���� �ʽ��ϴ�.");
		readForm.certpass1.value = "";
		readForm.certpass1.focus();
		return false;
	}
<%
if (is_smsChk) {
%>	
	if (readForm.sms.value.length !=6) {
		alert("���� Ȯ���� ���Ͽ�, SMS �Ǵ� �̸��� ������ �����մϴ�");
		goOpenSms();
		return false;
	}
	//if (readForm.smschk.value.length !=6) {
		//alert("SMS���������� �����ʾҽ��ϴ�.\n\nSMS ������ �����մϴ�..");
		//goOpenSms();
		//return false;
	//}

	
	//if (readForm.sms.value != readForm.smschk.value)
	//{
		//alert("������ȣ�� �ùٸ��� �ʽ��ϴ�. �ٽ� Ȯ���� �Է��� �ֽʽÿ�.");
		//readForm.sms.value="";
		//readForm.sms.disabled=true;
		//return false ;
	//}

<%
}
%>
	readForm.CN.value = readForm.id.value;
	readForm.pw.value = readForm.certpass.value;


	if (EncForm2(readForm, sendForm))
	{
		ViewMsg();
                checkBtn();
		sendForm.submit();
		return false;
	}
	return false;
}

function checkBtn() {
  document.getElementById("reqBtn").style.display="none";
}

function ViewMsg()
{
	var msg = "����� Ȯ���� �Դϴ�. ��ø� ��ٸ��ʽÿ�.";
	setMsg(msg, 0, 200);
	showMsg();
}
function setTimerOn()
{
	setTimeout('setInputNo()',300000);
}
function setInputNo()
{
	aa();
	var text1 = "������ȣ �Է½ð��� �ʰ��Ǿ����ϴ�. \n������ȣ�� �ٽ� �������� �������� �߱� ��������."
	alert(text1);
	//readForm.smschk.value="";
	location.href="ini_certNew.jsp";
	//return;
}
function aa()
{
	readForm.sms.style.background="#eeeeee";
	readForm.sms.disabled=true;
}
<%
if (is_smsChk) {
%>	
function goOpenSms()
{
	var	url=null;
	var tid = getStrDate();
	var form = document.readForm;
	form.tmid.value = tid ;
	//alert("tmid : "+ form.tmid.value + " / tid=" + tid);
	//if (readForm.id.value.length !=8 )
	//{
		//alert("8�ڸ��� ����� �Է��� �ֽʽÿ�.");
		//readForm.id.focus();
		//return ;
	//}
	//if (readForm.certpass.value.length < 8) {
		//alert("8�ڸ� �̻��� ������ �н����带 �Է��Ͻʽÿ� \n\nȮ���Ͻ��� �ٽ� �Է��� �ּ���.");
		//readForm.certpass.focus();
		//return false;
	//}
	//if( readForm.certpass.value.bytes() < 9 || readForm.certpass.value.bytes() > 30 ) {
		//alert("��й�ȣ�� �ּ� 9�ڸ��̻� �ִ� 30�ڸ����Ϸ� �Է��� �ֽʽÿ�.\n���� ���� " +  readForm.certpass.value.bytes() + "���Դϴ�.");
		//readForm.certpass.focus();
		//return;
	//}
	//if (readForm.certpass1.value.length ==0 ) {
		//var text8 = "������ ��й�ȣ�� �ٽ� �ѹ� �Է��Ͻʽÿ�.";
		//alert(text8);
		//readForm.certpass1.focus();
		//return false;
	//}
	//if (readForm.certpass.value != readForm.certpass1.value ) {
		
		//alert("�Է��Ͻ� �ΰ��� ������ ��й�ȣ�� ���� ��ġ���� �ʽ��ϴ�.");
		//readForm.certpass1.value = "";
		//readForm.certpass1.focus();
		//return false;
	//}
	url="http://idmake.kepco.co.kr:8080/idmake_sms/websmsform.jsp?empno="+form.id.value+"&tmid="+tid  ;
	window.open(url, "sms", "WIDTH=330,HEIGHT=460,TOP=0,LEFT=0");
}
<%
}
%>
</script>

<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body onload="aa();document.readForm.id.focus();defaultStatus='';">

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


<div id="subissue">
	<ul>
		<li><img src="img/subtitle0101.gif" alt="�������߱�_�������� �߱��ص帳�ϴ�."></li>
		<li class="stitle"><img src="img/subtitle0201.gif" alt="�������߱�_�Է�"></li>
		
		<li class="box" style="height:280px;">
			<form action="./ini_certNew_checkid.jsp" method="post" name="sendForm">
			<input type="hidden" name="INIpluginData" value="" />
			</form>
			<form name="readForm">
			<input type="hidden" name="regno" value="0000000000000" />
			<input type="hidden" name="CN" value="���������" />
			<input type="hidden" name="EMAIL" value="mailto@initech.com" />
			<input type="hidden" name="pw" value="" />
			<input type="hidden" name="tmid" value="<%=timeId%>" />
			<ul>
				<li class="sbtextbg"> <!--<a href="#" onclick="getStrDate();"> -</a> �ź�Ȯ�ο� �ʿ��� �Ʒ��� ������ �Է��Ͻʽÿ�. --></li>
				<li class="sbtextbg2" style="height:170px;">

					<table cellSpacing="0" cellPadding="0" width="100%" border="0" style="table-layout:fixed;">
						<colgroup>
							<col style="width:140px;">
							<col style="width:126px;">
							<col>
						</colgroup>
						<tr>
							<td style="width:140px; text-align:right;padding:3px;"><b>�����ȣ</b></td>
							<td style="padding:3px;" colspan="2"><input type="text" name="id" size="20" style="border: 1px solid #dedede; width:120px;" /></td>
						</tr>
						<tr>
							<td style="text-align:right;padding:3px;"><b>��й�ȣ</b></td>
							<td style="padding:3px;width:126px;">
								<input type="password" name="certpass" maxlength="30" size="20" style="border: 1px solid #dedede; width:120px;" />
							</td>
							<td style="text-align:left;padding-left:3px;" rowspan="2">
							<span style="color:#6600ff">
								&nbsp;�������� ��й�ȣ�� �ݵ�� ����,����,Ư�����ڷ� �����ϼž� �մϴ�.<br />
								&nbsp;�������� ��й�ȣ�� Ư������ <span style="font-weight:bold;color:#ff3333;">����ǥ(')</span> , <span style="font-weight:bold;color:#ff3333;">�ֵ���ǥ(")</span>, <span style="font-weight:bold;color:#ff3333;">�ۼ�Ʈ(%)</span>, <span style="font-weight:bold;color:#ff3333;">��������(\)</span>�� <br />&nbsp;&nbsp;����Ҽ������ϴ�.</span>
							</td>
						</tr>
						<tr>
							<td style="text-align:right;padding:3px;"><b>��й�ȣ Ȯ��</b></td>
							<td style="padding:3px;">
								<input type="password" name="certpass1" maxlength="30" size="20" style="border: 1px solid #dedede; width:120px;" />
							</td>
						</tr>
						<%
						if (is_smsChk) {
						%>
						<tr>
							<td style="text-align:right;padding:3px;"><b>������ȣ</b></td>
							<td style="padding:3px;">
								<input type="text" name="sms" maxlength="6" size="20" style="border: 1px solid #dedede; width:120px;" />
							</td>
							<td style="text-align:left;"><img src="img/btn_phnb.gif" alt="������ȣ�ޱ�" align="center" style="cursor:pointer;" onclick="CheckSendForm();"><!-- goOpenSms() --></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td style="padding:3px;" colspan="2">
								<img src="img/bullet_list.gif" align="center"> ������ȣ�� ��û �� 5�� �̳��� �Է��ؾ� ��ȿ�մϴ�.
								<br />
								<img src="img/bullet_list.gif" align="center"> SMS ���� ���ڴ�
								<br />
								&nbsp;&nbsp;&nbsp;- <span style="color:#6600ff;">&quot;[���� ���ͳݸ�]������ �߱޿� ������ȣ�� [000000]�Դϴ�.&quot;</span> ��� ���·� ���۵Ǹ�,
								<br />
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�߽Ź�ȣ�� <span style="color:#6600ff;">&quot;061-345-1166&quot;</span>�Դϴ�.
								<br />
								<img src="img/bullet_list.gif" align="center"> SMS ���� ���ڸ� ���Ź��� ���Ͻ� ����, <span style="color:#ff0033;font-weight:bold;">�߽Ź�ȣ �Ǵ� �� ����</span>�� ���� �ܾ�� ���ԵǾ� �ִ��� Ȯ���Ͻñ� �ٶ��ϴ�. 
							</td>
						</tr>
						<%
						}else{
						%>
							<input type="hidden" name="sms" maxlength="6" value="000000" size="20" style="border: 1px solid #dedede;" />
						<%
						}
						%>
					</table>




				<li class="dotted1"></li>
				<li style="float:left; padding-left:160px; height:60px;">
					<img src="img/btn_issue_new.gif" id="reqBtn" name="reqBtn" border="0" alt="�߱�" style="cursor:pointer;"  onclick="CheckSendForm();">
					<a href="#" onclick="document.readForm.reset();"><img src="img/btn_re-input_new.gif" alt="���Է�"></a>
				</li>
			</ul>
			</form>
		</li>
	</ul>

	<div style="height:20px;"></div>
</div>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

</body>
</html>
