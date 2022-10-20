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

String userId = request.getParameter("userId");
if (userId == null || userId.equals("")) {
	userId = "";
}

String gubun = request.getParameter("gubun");
if (gubun == null || gubun.equals("")) {
	gubun = "E";
}
String searchKeyfield = request.getParameter("searchKeyfield");
if (searchKeyfield == null || searchKeyfield.equals("")) {
	searchKeyfield = "C.USERID";
}

String searchKeyword = request.getParameter("searchKeyword");
if (searchKeyword == null || searchKeyword.equals("")) {
	searchKeyword = "";
}


String queryString = "gubun="+gubun+"&searchKeyfield="+searchKeyfield+"&searchKeyword="+searchKeyword;

String command = (userId != null && !"".equals(userId)) ? "update" : "insert";


String USERID = userId;
String REPLACE_CELLNO = "";
String NAME = "";
String DEPTNO = "";
String MAILNO = "";
String CELLNO = "";
String LEVELNM = "";
if ("update".equals(command)) {
	Context ict = new InitialContext();
	DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
	ResultSet rs = null;

	Connection conn = null;
	Statement stmt = null;

	try {
		conn = ds.getConnection();
		stmt = conn.createStatement();

		String strQuery = "" ;
		strQuery = "";
		strQuery = strQuery + "				SELECT  A.USERID" ;
		strQuery = strQuery + "					 ,  A.REPLACE_CELLNO" ;
		strQuery = strQuery + "					 ,  B.NAME" ;
		strQuery = strQuery + "					 ,  B.DEPTNO" ;
		strQuery = strQuery + "					 ,  B.MAILNO" ;
		strQuery = strQuery + "					 ,  B.CELLNO" ;
		strQuery = strQuery + "					 ,  B.LEVELNM" ;
		strQuery = strQuery + "				  FROM  MNG_USER A, V_INSA B" ;
		strQuery = strQuery + "				 WHERE  1=1" ;
		strQuery = strQuery + "				   AND  A.USERID = B.EMPNO" ;
		strQuery = strQuery + "				   AND  A.GUBUN = '"+gubun+"'" ;
		strQuery = strQuery + "				   AND  A.USERID = '"+userId+"'" ;

		rs = stmt.executeQuery(strQuery);
		if (!rs.isBeforeFirst()) {
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('사번("+ userId +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
			writer.println("history.back(-1);");
		    writer.println("</script>");
			writer.flush();
			return;			
		} 

		rs.next();

		NAME = rs.getString("NAME");
		REPLACE_CELLNO = rs.getString("REPLACE_CELLNO");
		if (REPLACE_CELLNO == null) {
			REPLACE_CELLNO = "";
		}
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

	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		rs.close();
		conn.close();
	}
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
		return true;
	}

	return false;
}

function DeleteSendForm() {

	if (!confirm('정말로 삭제하시겠습니까?'))
	{
		return false;
	}

	var sendForm = document.sendForm;
	var readForm = document.readForm;

	sendForm.action = "ini_manage_user_delete.jsp";
	if (EncForm2(readForm, sendForm))
	{
		sendForm.submit();
		return true;
	}
}

function SearchComplete(data) {
	$('#userId').val(data.empNo);
	$('#txtUserId').text(data.empNo);
	$('#txtLevelNm').text(data.levelNm);
	$('#txtName').text(data.name);
	$('#txtCellNo').text(data.cellNo);
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
	padding :10px 8px;
}
.wTableTdCell {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffcc ;
	text-align:right;
	padding :10px 8px 10px 12px;
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
		<li class="toptxtcon01"><a href="ini_manage_insa.jsp">인사정보목록</a></li>
		<li class="toptxtcon01"><a href="ini_manage_user.jsp">예외직원관리</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">로그아웃</a></li>
		<li class="toptxtcon01">&nbsp;</li>
	</ul>
</div>
<form name="sendForm" method="post" action="ini_manage_user_writeok.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm" method="post">
	<input type="hidden" name="command" value="<%=command%>"/>
	<input type="hidden" name="userId" id="userId" value="<%=userId%>"/>
	<input type="hidden" name="gubun" value="<%=gubun%>"/>
	<input type="hidden" name="queryString" value="<%=queryString%>"/>

	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
		<colgroup>
			<col width="20%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="wTableTdHeader" colspan="2">인증서 유효기간</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				사번
			</td>
			<td class="wTableTdCell02">
			<% if ("update".equals(command)) { %>
			 <span id="txtUserId"><%=USERID%></span>
			<% } else { %>
			 <span id="txtUserId"></span> <button type="button" onclick="window.open('ini_manage_user_search.jsp', 'a', 'width=600, height=400, scrollbars=yes')">검색</button>
			<% } %>
			</td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				이름
			</td>
			<td class="wTableTdCell02"><span id="txtName"><%=NAME%></span></td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				직급
			</td>
			<td class="wTableTdCell02"><span id="txtLevelNm"><%=LEVELNM%></span></td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				핸드폰1
			</td>
			<td class="wTableTdCell02"><span id="txtCellNo"><%=CELLNO%></span></td>
		</tr>
		<tr>
			<td class="wTableTdCell">
				핸드폰2
			</td>
			<td class="wTableTdCell02"><input type="text" name="REPLACE_CELLNO" id="REPLACE_CELLNO" style="border:1px solid #dedede; width:150px;" value="<%=REPLACE_CELLNO%>" /></td>
		</tr>
	</table>
	
	<div style="display:table; margin:10px auto 0 auto; height:50px;">
	<input type="button" value="확인" style="display:block; width:50px; border:1px solid #dedede; background:#3068b0; float:left;  text-align:center; color:#fff; padding: 10px 10px; " onclick="CheckSendForm();" />

	<!--<<% if ("update".equals(command)) { %>
	<button type="button" style="display:block; width:50px; border:1px solid #dedede; background:#3068b0; float:left;  text-align:center; color:#fff; padding: 10px 10px;" onclick="DeleteSendForm();">삭제</button>
	<% } %>-->
	</div>
</form>
<script language="javascript">dspCopyRight();</script>
</body>
</html>