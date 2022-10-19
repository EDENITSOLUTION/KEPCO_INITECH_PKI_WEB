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
function getStrDate(){
	Date.prototype.format = function(f) {    
    if (!this.valueOf()) return " ";     
        var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];    
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
               case "a/p": return d.getHours() < 12 ? "오전" : "오후";            
               default: return $1;        
             }    
        });}; 

    //한자리일경우 앞에 0을 붙여준다.
    String.prototype.string = function(len){
        var s = '', i = 0; 
        while (i++ < len) { s += this; } 
        return s;
    }; 
    String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
    Number.prototype.zf = function(len){return this.toString().zf(len);};

    
	return (new Date().format("yyyyMMddHHmmss"))
	// 예제 
    //2014년 01월 30일 오후 01시 45분 02초
    //console.log(new Date().format("yyyy년 MM월 dd일 a/p hh시 mm분 ss초")); 
    //2014-01-30
    //console.log(new Date().format("yyyy-MM-dd")); 
    //'14 01.30
    //console.log(new Date().format("'yy MM.dd")); 
    //2014-01-30 목요일
    //console.log(new Date().format("yyyy-MM-dd E")); 
    //현재년도 : 2014
    //console.log("현재년도 : " + new Date().format("yyyy"));
    

    //정규표현식 플래그
    //i : 대소문자  구별하지 않음
    //g : 전역매칭 수행, 첫번째 매치에서 끝내지 않고 매치되는 모든 것을 찾는다.
    

    //alert(new Date()+"\r\n"
          //+new Date().format("yyyy년 MM월 dd일 a/p hh시 mm분 ss초")+"\r\n"
          //+new Date().format("yyyy-MM-dd"));

}








function MM_callJS(jsStr) 
{ //v2.0
	return eval(jsStr)
}

// 길이 계산
String.prototype.bytes = function(){
	str = this != window ? this : str;
	var len = 0; //bug. 이 한줄때문에 고생을.. 넣어주세요. -_-;; 
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
		alert("8자리 이상의 사번을 입력하십시요.");
		readForm.id.focus();
		return false;
	}
	//if (readForm.regno.value.length != 13) {
		//var text2 = "13자리의 주민등록번호를 입력하십시요.\n\n확인하신후 다시 입력해 주세요.";
		//alert(text2);
		//readForm.regno.focus();
		//return false;
	//}

	if (readForm.CN.value.length < 2) {
		var text4 = "2자리 이상의 이름을 입력하십시요.\n\n확인하신후 다시 입력해 주세요.";
		alert(text4);
		readForm.CN.focus();
		return false;
	}
	if (readForm.EMAIL.value.length < 7) {
		var text5 = "7자리 이상의 E-Mail이나 전화번호를 입력하십시요.\n\n확인하신후 다시 입력해 주세요.";
		alert(text5);
		readForm.EMAIL.focus();
		return false;
	}
	
	

	if(readForm.certpass.value.length < 1)
	{
		alert("인증서 비밀번호를 입력해 주십시오");
		readForm.certpass.focus();
		return false;
	}
	
	if(isEmpty(readForm.certpass)) 	{
		alert("공백문자는 비밀번호로 사용할수 없습니다. 다시 입력해 주십시오");
		readForm.certpass.focus();
		return false;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 특수문자 체크 시작
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
			//alert("입력할 수 없는 특수문자(' , '', %, \)를 입력하셨습니다."); 
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
		alert("인증서 비밀번호 입력란에 \n\n입력할 수 없는 특수문자(' , '', %, \)를 입력하셨거나, \n\n숫자, 영문, 특수문자를 필수로 조합하여 9자리 이상 입력하셔야합니다.");
		readForm.certpass.focus();
		return false;
	}

	if( readForm.certpass.value.bytes() < 9 || readForm.certpass.value.bytes() > 30 ) {
		alert("비밀번호는 최소 9자리이상 최대 30자리이하로 입력해 주십시오.\n현재 길이 " +  readForm.certpass.value.bytes() + "자입니다.");
		readForm.certpass.focus();
		return;
	}
	if (readForm.certpass1.value.length ==0 ) {
		alert("인증서 비밀번호를 다시 한번 입력하십시오.");
		readForm.certpass1.focus();
		return false;
	}
	if (readForm.certpass.value != readForm.certpass1.value ) {
		
		alert("입력하신 두개의 인증서 비밀번호가 서로 일치하지 않습니다.");
		readForm.certpass1.value = "";
		readForm.certpass1.focus();
		return false;
	}
<%
if (is_smsChk) {
%>	
	if (readForm.sms.value.length !=6) {
		alert("본인 확인을 위하여, SMS 또는 이메일 인증을 수행합니다");
		goOpenSms();
		return false;
	}
	//if (readForm.smschk.value.length !=6) {
		//alert("SMS인증절차를 밟지않았습니다.\n\nSMS 인증을 수행합니다..");
		//goOpenSms();
		//return false;
	//}

	
	//if (readForm.sms.value != readForm.smschk.value)
	//{
		//alert("인증번호가 올바르지 않습니다. 다시 확인후 입력해 주십시오.");
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
	var msg = "사용자 확인중 입니다. 잠시만 기다리십시요.";
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
	var text1 = "인증번호 입력시간이 초과되었습니다. \n인증번호를 다시 받으신후 인증서를 발급 받으세요."
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
		//alert("8자리의 사번을 입력해 주십시오.");
		//readForm.id.focus();
		//return ;
	//}
	//if (readForm.certpass.value.length < 8) {
		//alert("8자리 이상의 인증서 패스워드를 입력하십시요 \n\n확인하신후 다시 입력해 주세요.");
		//readForm.certpass.focus();
		//return false;
	//}
	//if( readForm.certpass.value.bytes() < 9 || readForm.certpass.value.bytes() > 30 ) {
		//alert("비밀번호는 최소 9자리이상 최대 30자리이하로 입력해 주십시오.\n현재 길이 " +  readForm.certpass.value.bytes() + "자입니다.");
		//readForm.certpass.focus();
		//return;
	//}
	//if (readForm.certpass1.value.length ==0 ) {
		//var text8 = "인증서 비밀번호를 다시 한번 입력하십시오.";
		//alert(text8);
		//readForm.certpass1.focus();
		//return false;
	//}
	//if (readForm.certpass.value != readForm.certpass1.value ) {
		
		//alert("입력하신 두개의 인증서 비밀번호가 서로 일치하지 않습니다.");
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
		<li class="toptxtcon">인증센터 이용하기</li>
		<li class="toptxtcon01" style="text-decoration:underline;">인증서 발급</li>
		<li class="toptxtcon01">인증서 폐기</li>
		<li class="toptxtcon01">인증서 관리</li>
	</ul>
</div>


<div id="subissue">
	<ul>
		<li><img src="img/subtitle0101.gif" alt="인증서발급_인증서를 발급해드립니다."></li>
		<li class="stitle"><img src="img/subtitle0201.gif" alt="인증서발급_입력"></li>
		
		<li class="box" style="height:280px;">
			<form action="./ini_certNew_checkid.jsp" method="post" name="sendForm">
			<input type="hidden" name="INIpluginData" value="" />
			</form>
			<form name="readForm">
			<input type="hidden" name="regno" value="0000000000000" />
			<input type="hidden" name="CN" value="한전사용자" />
			<input type="hidden" name="EMAIL" value="mailto@initech.com" />
			<input type="hidden" name="pw" value="" />
			<input type="hidden" name="tmid" value="<%=timeId%>" />
			<ul>
				<li class="sbtextbg"> <!--<a href="#" onclick="getStrDate();"> -</a> 신분확인에 필요한 아래의 정보를 입력하십시오. --></li>
				<li class="sbtextbg2" style="height:170px;">

					<table cellSpacing="0" cellPadding="0" width="100%" border="0" style="table-layout:fixed;">
						<colgroup>
							<col style="width:140px;">
							<col style="width:126px;">
							<col>
						</colgroup>
						<tr>
							<td style="width:140px; text-align:right;padding:3px;"><b>사원번호</b></td>
							<td style="padding:3px;" colspan="2"><input type="text" name="id" size="20" style="border: 1px solid #dedede; width:120px;" /></td>
						</tr>
						<tr>
							<td style="text-align:right;padding:3px;"><b>비밀번호</b></td>
							<td style="padding:3px;width:126px;">
								<input type="password" name="certpass" maxlength="30" size="20" style="border: 1px solid #dedede; width:120px;" />
							</td>
							<td style="text-align:left;padding-left:3px;" rowspan="2">
							<span style="color:#6600ff">
								&nbsp;※인증서 비밀번호는 반드시 숫자,영문,특수문자로 조합하셔야 합니다.<br />
								&nbsp;※인증서 비밀번호에 특수문자 <span style="font-weight:bold;color:#ff3333;">따옴표(')</span> , <span style="font-weight:bold;color:#ff3333;">쌍따옴표(")</span>, <span style="font-weight:bold;color:#ff3333;">퍼센트(%)</span>, <span style="font-weight:bold;color:#ff3333;">역슬러시(\)</span>는 <br />&nbsp;&nbsp;사용할수없습니다.</span>
							</td>
						</tr>
						<tr>
							<td style="text-align:right;padding:3px;"><b>비밀번호 확인</b></td>
							<td style="padding:3px;">
								<input type="password" name="certpass1" maxlength="30" size="20" style="border: 1px solid #dedede; width:120px;" />
							</td>
						</tr>
						<%
						if (is_smsChk) {
						%>
						<tr>
							<td style="text-align:right;padding:3px;"><b>인증번호</b></td>
							<td style="padding:3px;">
								<input type="text" name="sms" maxlength="6" size="20" style="border: 1px solid #dedede; width:120px;" />
							</td>
							<td style="text-align:left;"><img src="img/btn_phnb.gif" alt="인증번호받기" align="center" style="cursor:pointer;" onclick="CheckSendForm();"><!-- goOpenSms() --></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td style="padding:3px;" colspan="2">
								<img src="img/bullet_list.gif" align="center"> 인증번호는 요청 후 5분 이내에 입력해야 유효합니다.
								<br />
								<img src="img/bullet_list.gif" align="center"> SMS 인증 문자는
								<br />
								&nbsp;&nbsp;&nbsp;- <span style="color:#6600ff;">&quot;[한전 인터넷망]인증서 발급용 인증번호는 [000000]입니다.&quot;</span> 라는 형태로 전송되며,
								<br />
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;발신번호는 <span style="color:#6600ff;">&quot;061-345-1166&quot;</span>입니다.
								<br />
								<img src="img/bullet_list.gif" align="center"> SMS 인증 문자를 수신받지 못하실 때는, <span style="color:#ff0033;font-weight:bold;">발신번호 또는 위 문자</span>가 금지 단어로 포함되어 있는지 확인하시기 바랍니다. 
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
					<img src="img/btn_issue_new.gif" id="reqBtn" name="reqBtn" border="0" alt="발급" style="cursor:pointer;"  onclick="CheckSendForm();">
					<a href="#" onclick="document.readForm.reset();"><img src="img/btn_re-input_new.gif" alt="재입력"></a>
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
