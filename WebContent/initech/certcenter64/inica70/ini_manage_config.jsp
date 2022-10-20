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
if (adminLogin == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('관리자 로그인 정보가 존재하지 않습니다.');");
	writer.println("location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}

Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

String command = "insert";

String POLICY_DEFAULT = "";
String POLICY_EXCEPTN1 = "";
String POLICY_EXCEPTN2 = "";
String NOTICE_GUBUN = "";
String NOTICE_DAY = "";
try {
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String q = "";
	q += "		SELECT  POLICY_DEFAULT";
	q += "			 ,  POLICY_EXCEPTN1";
	q += "			 ,  POLICY_EXCEPTN2";
	q += "			 ,  NOTICE_GUBUN";
	q += "			 ,  NOTICE_DAY";
	q += "		  FROM  MNG_CONFIG";
	q += "		 WHERE  ROWNUM = 1";
	rs = stmt.executeQuery(q);
	//사용자아이디로 카운트하여 0보다 크면 재발급하고 0이면 발급
	
	if (rs.isBeforeFirst()) {
		rs.next();
		command = "update";
		POLICY_DEFAULT = nullConvefrt(rs.getString("POLICY_DEFAULT"));
		POLICY_EXCEPTN1 = nullConvefrt(rs.getString("POLICY_EXCEPTN1"));
		POLICY_EXCEPTN2 = nullConvefrt(rs.getString("POLICY_EXCEPTN2"));
		NOTICE_GUBUN = nullConvefrt(rs.getString("NOTICE_GUBUN"));
		NOTICE_DAY = nullConvefrt(rs.getString("NOTICE_DAY"));
	}

		
} catch(Exception e) {
	e.printStackTrace();
} finally {
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
function CheckSendForm() {

	var sendForm = document.sendForm;
	var readForm = document.readForm;

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
	margin:20px auto 0 auto;
}
.wTableTdHeader {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	text-align : center;
	font-weight : bold;
	background-color : #eeeeee ;
	padding : 10px 8px;
}
.wTableTdCell {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	text-align:right;
	background-color : #ffffcc ;
	padding : 10px 8px 10px 12px;
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
		<li class="toptxtcon01" style="width:150px;text-align:left; color:#000;"><a href="ini_manage_cert.jsp">인증서 발급 내역 조회</a></li>
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_manage_config.jsp">환경설정</a></li>
		<li class="toptxtcon01"><a href="ini_manage_insa.jsp">인사정보목록</a></li>
		<li class="toptxtcon01"><a href="ini_manage_user.jsp">예외직원관리</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">로그아웃</a></li>
		<li class="toptxtcon01">&nbsp;</li>
	</ul>
</div>
<form name="sendForm" method="post" action="./ini_manage_config_ok.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm" method="post">
	<input type="hidden" name="command" value="<%=command%>"/>
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable" style="border-bottom:1px solid #c5c5c5;">
		<colgroup>
			<col width="20%"/>
			<col width="*"/>
		</colgroup>
		<tr>		
			<td class="wTableTdHeader" colspan="2">인증서 유효기간</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				직원
			</td>
			<td class="wTableTdCell02">
				<select name="policyDefault" id="policyDefault">
					<option value="69" <% if ("69".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>1개월</option>
					<option value="70" <% if ("70".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>2개월</option>
					<option value="71" <% if ("71".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>3개월</option>
					<option value="72" <% if ("72".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>4개월</option>
					<option value="73" <% if ("73".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>5개월</option>
					<option value="74" <% if ("74".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>6개월</option>
					<option value="75" <% if ("75".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>7개월</option>
					<option value="76" <% if ("76".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>8개월</option>
					<option value="77" <% if ("77".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>9개월</option>
					<option value="78" <% if ("78".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>10개월</option>
					<option value="79" <% if ("79".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>11개월</option>
					<option value="80" <% if ("80".equals(POLICY_DEFAULT)) { %>selected="selected"<% } %>>12개월</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				예외직원
			</td>
			<td class="wTableTdCell02">
				<select name="policyExceptn1" id="policyExceptn1">
					<option value="69" <% if ("69".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>1개월</option>
					<option value="70" <% if ("70".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>2개월</option>
					<option value="71" <% if ("71".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>3개월</option>
					<option value="72" <% if ("72".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>4개월</option>
					<option value="73" <% if ("73".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>5개월</option>
					<option value="74" <% if ("74".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>6개월</option>
					<option value="75" <% if ("75".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>7개월</option>
					<option value="76" <% if ("76".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>8개월</option>
					<option value="77" <% if ("77".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>9개월</option>
					<option value="78" <% if ("78".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>10개월</option>
					<option value="79" <% if ("79".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>11개월</option>
					<option value="80" <% if ("80".equals(POLICY_EXCEPTN1)) { %>selected="selected"<% } %>>12개월</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="wTableTdHeader" colspan="2">인증서 만료안내 메세지</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				전송방법
			</td>
			<td class="wTableTdCell02">
				<select name="noticeGubun" id="noticeGubun">
				<option value="S" <% if ("S".equals(NOTICE_GUBUN)) { %>selected="selected"<% } %>>SMS</option>
				<!--
				<option value="M" <% if ("M".equals(NOTICE_GUBUN)) { %>selected="selected"<% } %>>EMAIL</option>
				<option value="P" <% if ("P".equals(NOTICE_GUBUN)) { %>selected="selected"<% } %>>PUSH</option>
				-->
				</select>
			</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				전송날짜
			</td>
			<td class="wTableTdCell02">
				<input type="text" style="border:1px solid #dedede; width:150px; margin-bottom:5px;"  name="noticeDay" id="noticeDay" value="<%=NOTICE_DAY%>" />일 전부터 안내
				<br />예) 14,7,1
			</td>
		</tr>
	</table>
	<input type="button" style="display:block; width:50px; border:1px solid #dedede; background:#3068b0; margin:10px auto 0 auto;  text-align:center; color:#fff; padding: 10px 10px; " value="확인" onclick="CheckSendForm();" />
	
	<!--
	<div>
		협력업체
		<select name="policyExceptn2" id="policyExceptn2">
		<option value="71" <% if ("71".equals(POLICY_EXCEPTN2)) { %>selected="selected"<% } %>>3개월</option>
		<option value="72" <% if ("72".equals(POLICY_EXCEPTN2)) { %>selected="selected"<% } %>>4개월</option>
		<option value="73" <% if ("73".equals(POLICY_EXCEPTN2)) { %>selected="selected"<% } %>>5개월</option>
		</select>
	</div>
	-->
</form>
<script language="javascript">dspCopyRight();</script>
</body>
</html>