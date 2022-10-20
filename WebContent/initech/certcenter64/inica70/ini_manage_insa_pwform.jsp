<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.*"%>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import="java.lang.String.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/func.jsp" %>
<%
//************************************************
//      관리자 세션 체크
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
String admin2Login = (String)session.getAttribute("admin2Login");
if (adminLogin == null && admin2Login == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('관리자 로그인 정보가 존재하지 않습니다.');");
	writer.println("location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}

String empNo = request.getParameter("empNo");

Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

String EMPNO = "";
String NAME = "";
String DEPTNO = "";
String MAILNO = "";
String CELLNO = "";
String LEVELNM = "";

try 
{
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String strQuery = "" ;
	strQuery = "";
	strQuery = strQuery + "				SELECT  A.EMPNO" ;
	strQuery = strQuery + "					 ,  A.NAME" ;
	strQuery = strQuery + "					 ,  A.DEPTNO" ;
	strQuery = strQuery + "					 ,  A.MAILNO" ;
	strQuery = strQuery + "					 ,  A.CELLNO" ;
	strQuery = strQuery + "					 ,  A.LEVELNM" ;
	strQuery = strQuery + "				  FROM  V_INSA A" ;
	strQuery = strQuery + "				 WHERE  A.EMPNO = '" + empNo + "'" ;

	rs = stmt.executeQuery(strQuery);
	if (!rs.isBeforeFirst()) {
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('사번("+ empNo +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("history.back(-1);");
		writer.println("</script>");
		writer.flush();
		return;			
	} 

	rs.next();

	EMPNO = rs.getString("EMPNO");
	NAME = rs.getString("NAME");
	DEPTNO = rs.getString("DEPTNO");
	MAILNO = rs.getString("MAILNO");
	CELLNO = rs.getString("CELLNO");
	if (CELLNO == null) {
		CELLNO = "";
	}

	LEVELNM = rs.getString("LEVELNM");
	if (LEVELNM == null) {
		LEVELNM = "";
	}

} 
catch(Exception e) 
{
	e.printStackTrace();
} 
finally 
{
	rs.close();
	conn.close();
}

%>


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
function isEmpty(input) {
	if (input.value == null || input.value.replace(/ /gi,"") == "") {
		return true;
	}
	return false;
}

function CheckSendForm() {

	var sendForm = document.sendForm;
	var readForm = document.readForm;

	/*
	if(readForm.password.value.length < 1)
	{
		alert("초기화 비밀번호를 입력해 주십시오");
		readForm.password.focus();
		return false;
	}
	
	if(isEmpty(readForm.password)) 	{
		alert("공백문자는 비밀번호로 사용할수 없습니다. 다시 입력해 주십시오");
		readForm.password.focus();
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
	
	for(intCnt =0; intCnt < readForm.password.value.length; intCnt++){
		
		strChar = readForm.password.value.charAt(intCnt);
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
		alert("초기화 비밀번호 입력란에 \n\n입력할 수 없는 특수문자(' , '', %, \)를 입력하셨거나, \n\n숫자, 영문, 특수문자를 필수로 조합하여 9자리 이상 입력하셔야합니다.");
		readForm.password.focus();
		return false;
	}

	if( readForm.password.value.length < 9 || readForm.password.value.length > 30 ) {
		alert("초기화 비밀번호는 최소 9자리이상 최대 30자리이하로 입력해 주십시오.\n현재 길이 " +  readForm.password.value.length + "자입니다.");
		readForm.password.focus();
		return;
	}
	if (readForm.password1.value.length ==0 ) {
		alert("초기화 비밀번호를 다시 한번 입력하십시오.");
		readForm.password1.focus();
		return false;
	}
	if (readForm.password.value != readForm.password1.value ) {
		
		alert("입력하신 두개의 비밀번호가 서로 일치하지 않습니다.");
		readForm.password1.value = "";
		readForm.password1.focus();
		return false;
	}
	*/

	if (!confirm('정말로 초기화하시겠습니까?'))
	{
		return false;
	}

	if (EncForm2(readForm, sendForm))
	{
		sendForm.submit();
		return false;
	}
	return false;
}
</script>
<style type="text/css">
.wTable {
	width:950px;
	border-top : solid 1px #c5c5c5;
	border-left : solid 1px #c5c5c5;
	margin:10px auto 10px auto;
}
.wTableTdHeader {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	text-align : center;
	font-weight : bold;
	background-color : #eeeeee ;
	padding :10px 8px;
}
.wTableTdCell {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffcc ;
	padding : 10px 8px 10px 12px;
	text-align:right;
}
.wTableTdCell02 {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #fff ;
	padding : 10px 8px;
}
.wTableTdSearch {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffff ;
	padding : 5px;
}
.wTableTdSearch1 {
	border-right : solid 1px #c5c5c5;
	
	font-weight : normal;
	background-color : #ffffff ;
	padding : 5px;
}
.tac {text-align:center;}

.paging > a { font-size:15px; }
.paging > strong {font-size:15px !important;}
</style>

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
		<li class="toptxtcon">인증센터 관리자</li>
		<li class="toptxtcon01" style="width:150px;text-align:left;"><a href="ini_manage_cert.jsp">인증서 발급 내역 조회</a></li>
		<li class="toptxtcon01"><a href="ini_manage_config.jsp">환경설정</a></li>
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_manage_insa.jsp">인사정보목록</a></li>
		<li class="toptxtcon01"><a href="ini_manage_user.jsp">예외직원관리</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">로그아웃</a></li>
		<li class="toptxtcon01">&nbsp;</li>
	</ul>
</div>
<form name="sendForm" method="post" action="./ini_manage_insa_pwok.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm" method="post">
	<input type="hidden" name="empNo" value="<%=empNo%>" />
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable" style="border-bottom:1px solid #c5c5c5;">
		<colgroup>
			<col width="20%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="wTableTdHeader" colspan="2">인증서 비밀번호 초기화</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				사번
			</td>
			<td class="wTableTdCell02">
				<%=EMPNO%>
			</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				이름
			</td>
			<td class="wTableTdCell02">
				 <%=NAME%>
			</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				메일
			</td>
			<td class="wTableTdCell02">
				<%=MAILNO%>@kepco.co.kr
			</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				직급
			</td>
			<td class="wTableTdCell02">
				<%=LEVELNM%>
			</td>
		</tr>
		<!--
		<tr>
			<td class="wTableTdCell">
				초기화 비밀번호
			</td>
			<td class="wTableTdCell02">
				<input type="password" style="border:1px solid #dedede; width:150px;" name="password" id="password" value="" />
			</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				초기화 비밀번호 확인
			</td>
			<td class="wTableTdCell02">
				<input type="password" style="border:1px solid #dedede; width:150px;" name="password1" id="password1" value="" />
			</td>
		</tr>
		-->
	</table>
	<div style="text-align:center;">
	<input type="button" style="display:inline-block; border:1px solid #dedede; background:#3068b0; color:#fff; padding: 10px 10px; " value="초기화" onclick="CheckSendForm();" />
	</div>
</form>
<script language="javascript">dspCopyRight();</script>
</body>
</html>