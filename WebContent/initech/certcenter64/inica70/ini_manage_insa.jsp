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

Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

// 페이징
final int ROWSIZE = 15;
final int BLOCK = 10;
int pageIndex = 1;
if (request.getParameter("pageIndex") != null) {
	try {
		pageIndex = Integer.parseInt(request.getParameter("pageIndex"));
	} catch (Exception e) {
	}
}

int start = (pageIndex * ROWSIZE) - (ROWSIZE - 1);
int end = (pageIndex * ROWSIZE);
int totalPage = 0;
int startPage = ((pageIndex - 1) / BLOCK * BLOCK) + 1;
int endPage = ((pageIndex - 1) / BLOCK * BLOCK) + BLOCK;
int total = 0;

////////////////////////////////////////////////////////////////////////////

String searchKeyfield = request.getParameter("searchKeyfield");
String searchKeyword = request.getParameter("searchKeyword");

if (searchKeyfield == null || searchKeyfield.equals("")) {
	searchKeyfield = "";
}

if (searchKeyword == null || searchKeyword.equals("")) {
	searchKeyword = "";
}

String queryString = "searchKeyfield="+searchKeyfield+"&searchKeyword="+searchKeyword;

////////////////////////////////////////////////////////////////////////////


try {
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String strQuery = "" ;
	strQuery = strQuery + "		SELECT  COUNT(*) " ;
	strQuery = strQuery + "		  FROM  ( " ;
	strQuery = strQuery + "				SELECT  *" ;
	strQuery = strQuery + "				  FROM  V_INSA A" ;
	strQuery = strQuery + "			 LEFT JOIN  LDAP_INFO B ON (A.EMPNO = B.USERID AND B.STATUS ='V')" ;
	strQuery = strQuery + "				 WHERE  1=1" ;
	strQuery = strQuery + "			)  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		if (!"".equals(searchKeyfield)) {
			strQuery = strQuery + " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
		} else {
			strQuery = strQuery + " AND (C.EMPNO LIKE '%" + searchKeyword + "%' OR C.NAME LIKE '%" + searchKeyword + "%')" ;
		}
	}

	rs = stmt.executeQuery(strQuery);
	rs.next();
    total = rs.getInt(1);
	
	totalPage = (int)Math.ceil(total / ROWSIZE);
	if (endPage > totalPage) {
		endPage = totalPage;
	}

	strQuery = "";
	strQuery = strQuery + "SELECT X.* FROM (" ;
	strQuery = strQuery + "		SELECT  C.EMPNO " ;
	strQuery = strQuery + "			 ,  C.NAME " ;
	strQuery = strQuery + "			 ,  C.DEPTNO " ;
	strQuery = strQuery + "			 ,  C.MAILNO " ;
	strQuery = strQuery + "			 ,  C.CELLNO " ;
	strQuery = strQuery + "			 ,  C.LEVELNM " ;
	strQuery = strQuery + "			 ,  TO_CHAR(C.ISSUEDATE,'YYYY-MM-DD') AS ISSUEDATE" ;
	strQuery = strQuery + "			 ,  TO_CHAR(C.EXPIREDATE,'YYYY-MM-DD') AS EXPIREDATE " ;
	strQuery = strQuery + "			 ,  ROWNUM R " ;
	strQuery = strQuery + "			 ,  RANK() OVER (ORDER BY C.NAME ASC) AS RANKING " ;
	strQuery = strQuery + "		 FROM  ( " ;
	strQuery = strQuery + "				SELECT  A.EMPNO" ;
	strQuery = strQuery + "					 ,  A.NAME" ;
	strQuery = strQuery + "					 ,  A.DEPTNO" ;
	strQuery = strQuery + "					 ,  A.MAILNO" ;
	strQuery = strQuery + "					 ,  A.CELLNO" ;
	strQuery = strQuery + "					 ,  A.LEVELNM" ;
	strQuery = strQuery + "					 ,  B.ISSUEDATE" ;
	strQuery = strQuery + "					 ,  B.EXPIREDATE" ;
	strQuery = strQuery + "				  FROM  V_INSA A" ;
	strQuery = strQuery + "			 LEFT JOIN  LDAP_INFO B ON (A.EMPNO = B.USERID AND B.STATUS ='V')" ;
	strQuery = strQuery + "				 WHERE  1=1" ;
	strQuery = strQuery + "			   )  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		if (!"".equals(searchKeyfield)) {
			strQuery = strQuery + " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
		} else {
			strQuery = strQuery + " AND (C.EMPNO LIKE '%" + searchKeyword + "%' OR C.NAME LIKE '%" + searchKeyword + "%')" ;
		}
	}
	strQuery = strQuery + "  ORDER BY  C.NAME ASC " ; 
	strQuery = strQuery + ") X " ; 
	strQuery = strQuery + "WHERE X.RANKING BETWEEN "+ (start-1) +" and "+ end ; 
	//out.print(strQuery);
	rs = stmt.executeQuery(strQuery);
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
function initPass(empNo) {
	var sendForm = document.sendForm;
	var readForm = document.readForm;

	if (!confirm('정말로 초기화하시겠습니까?'))
	{
		return;
	}

	readForm.empNo.value = empNo;

	if (EncForm2(readForm, sendForm))
	{

		sendForm.submit();
		return false;
	}

	return false;
}

function CheckSendForm() {

	var readForm = document.readForm;
	readForm.target="_self";
	//var sendForm = document.sendForm;

	//if (EncForm2(readForm, sendForm)) {
		//ViewMsg();
		readForm.submit();
		//return false;
	//}
	return false;
}
function ViewMsg()
{
	var msg = "조회 확인 중 입니다. 잠시만 기다리십시요.";
	setMsg(msg, 0, 200);
	showMsg();
}

</script>
<style type="text/css">
.wTable {
	width:950px;
	border-top : solid 1px #c5c5c5;
	border-left : solid 1px #c5c5c5;
	margin:0 auto;
}
.wTableTdHeader {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	text-align : center;
	font-weight : bold;
	background-color : #eeeeee ;
	padding :10px 4px;
}
.wTableTdCell {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffff ;
	padding :10px 4px;
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
.paging_box {
	display:table; 
	background:#F6F6F6; 
	margin:0 auto; 
	border:1px solid #999;
	border-radius:5px;

}
.paging_box > li {
	float:left;
	font-size:16px;
	color:#000;
	font-weight:bold;
	padding:10px 15px 9px 15px;
	border-right:1px solid #999;
}
.paging_box > li:last-child {
	border-right:none;
}
.tac {text-align:center;}


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
		<% if (admin2Login != null) { %>
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_manage_insa.jsp">인사정보목록</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">로그아웃</a></li>
		<li class="toptxtcon01">&nbsp;</li>
		<% } else { %>
		<li class="toptxtcon01" style="width:150px;text-align:left;"><a href="ini_manage_cert.jsp">인증서 발급 내역 조회</a></li>
		<li class="toptxtcon01"><a href="ini_manage_config.jsp">환경설정</a></li>
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_manage_insa.jsp">인사정보목록</a></li>
		<li class="toptxtcon01"><a href="ini_manage_user.jsp">예외직원관리</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">로그아웃</a></li>
		<li class="toptxtcon01">&nbsp;</li>
		<% } %>
	</ul>
</div>
<form action="ini_manage_insa.jsp" method="post">
<input type="hidden" name="pageIndex" value="1" />
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable" style="border-bottom:1px solid #c5c5c5; margin:10px auto 10px auto;">
	<tr>
		<td class="wTableTdSearch1">
			<select name="searchKeyfield" id="searchKeyfield">
				<option value="">전체</option>
				<option value="C.EMPNO"<%if (searchKeyfield.equals("C.EMPNO")) {%> selected<%}%>>아이디</option>
				<option value="C.NAME"<%if (searchKeyfield.equals("C.NAME")) {%> selected<%}%>>이름</option>
			</select>
			<input type="text" name="searchKeyword" id="searchKeyword"  style="border:1px solid #dedede; width:150px;"value="<%=searchKeyword%>" />
			<button type="submit">검색</button>
		</td>
	</tr>
	</table>
</form>

<form name="sendForm" method="post" action="./ini_manage_insa_pwok.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm" method="post">
	<input type="hidden" name="empNo" value="" />
	<input type="hidden" name="param" value="pageIndex=<%=pageIndex%>&<%=queryString%>" />
</form>

<p style="width:950px; margin:0 auto;">전체 : <%=total%>건</p>
<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
	<tr>
		<td class="wTableTdHeader" scope="col">NO</td>
		<td class="wTableTdHeader" scope="col">사번</td>
		<td class="wTableTdHeader" scope="col">성명</td>
		<td class="wTableTdHeader" scope="col">직급</td>
		<td class="wTableTdHeader" scope="col">인증서<br/>발급일</td>
		<td class="wTableTdHeader" scope="col">인증서<br/>만료일</td>
		<td class="wTableTdHeader" scope="col">비밀번호<br/>초기화</td>
	</tr>
<%
int no = (total - (ROWSIZE * (pageIndex-1)));
while (rs.next()) {		
%>

		<tr>
			<td class="wTableTdCell tac"><%=no%></td>
			<td class="wTableTdCell tac"><%=rs.getString("EMPNO")%></td>
			<td class="wTableTdCell tac"><%=rs.getString("NAME")%></td>
			<td class="wTableTdCell tac"><%=(rs.getString("LEVELNM") != null ? rs.getString("LEVELNM") : "")%></td>
			<td class="wTableTdCell tac"><%=(rs.getString("ISSUEDATE") != null ? rs.getString("ISSUEDATE") : "")%></td>
			<td class="wTableTdCell tac"><%=(rs.getString("EXPIREDATE") != null ? rs.getString("EXPIREDATE") : "")%></td>
			<td class="wTableTdCell tac"><a href="javascript:initPass('<%=rs.getString("EMPNO")%>');" style="padding:6px 5px 3px 5px; color:#000; background:#ccc; border:1px solid #999; border-radius:5px;">초기화</a></td>
		</tr>
<%
	no--;
}
%>
<% if (total < 1) { %>
		<tr>
			<td class="wTableTdCell tac" colspan="7" style="text-align:center;">데이터가 없습니다.</td>
		</tr>
<% } %>
</table>

<ul class="paging_box" style="margin-top:15px;">
<% if (pageIndex > BLOCK) { %>
<li><a href="?pageIndex=1&<%=queryString%>">처음</a></li>
<li><a href="?pageIndex=<%=(startPage-1)%>&<%=queryString%>">이전</a></li>
<% } %>
<% 
for (int i = startPage; i <= endPage; i++ ) {
	if (i == pageIndex) {
%>
	<li><strong style="color:red; font-weight:bold;"><%=i%></strong></li>
<%
	} else {
%>
	<li><a href="?pageIndex=<%=i%>&<%=queryString%>"><%=i%></a></li>
<%
	}
}
%>
<% if (endPage < totalPage) { %>
<li><a href="?pageIndex=<%=(endPage+1)%>&<%=queryString%>">다음</a></li>
<li><a href="?pageIndex=<%=totalPage%>&<%=queryString%>">마지막</a></li>
<% } %>
</ul>
<%
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}
%>
<script language="javascript">dspCopyRight();</script>
</body>
</html>