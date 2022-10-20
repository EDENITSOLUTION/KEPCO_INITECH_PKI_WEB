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
int totalPage = 1;
int startPage = ((pageIndex - 1) / BLOCK * BLOCK) + 1;
int endPage = ((pageIndex - 1) / BLOCK * BLOCK) + BLOCK;
int total = 0;
//************************************************
//     페이지 변수 선언 Start
//************************************************
//1. 한 페이지당 보일 레코드 수를 결정하고, 총 페이지 수를 구한다.
String gubun = request.getParameter("gubun");
String searchKeyfield = request.getParameter("searchKeyfield");
String searchKeyword = request.getParameter("searchKeyword");

if (gubun == null || gubun.equals("")) {
	gubun = "E";
}

if (searchKeyfield == null || searchKeyfield.equals("")) {
	searchKeyfield = "";
}

if (searchKeyword == null || searchKeyword.equals("")) {
	searchKeyword = "";
}

String queryString = "gubun="+gubun+"&searchKeyfield="+searchKeyfield+"&searchKeyword="+searchKeyword;


String baseCondQuery = "" ;


try {
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String strQuery = "" ;
	strQuery = strQuery + "		SELECT  COUNT(*) " ;
	strQuery = strQuery + "		  FROM  ( " ;
	strQuery = strQuery + "		SELECT  *" ;
	strQuery = strQuery + "		  FROM  MNG_USER A, V_INSA B" ;
	strQuery = strQuery + "		 WHERE  1=1" ;
	strQuery = strQuery + "		   AND  A.USERID = B.EMPNO" ;
	strQuery = strQuery + "		   AND  A.GUBUN = '"+gubun+"'" ;
	strQuery = strQuery + "			)  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		if (!"".equals(searchKeyfield)) {
			strQuery = strQuery + " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
		} else {
			strQuery = strQuery + " AND (C.USERID LIKE '%" + searchKeyword + "%' OR C.NAME LIKE '%" + searchKeyword + "%')" ;
		}
	}
	//out.print(strQuery);

	rs = stmt.executeQuery(strQuery);
	rs.next();
    total = rs.getInt(1);
	
	totalPage = (int)Math.ceil(total / ROWSIZE);
	if (endPage > totalPage) {
		endPage = totalPage;
	}

	strQuery = "";
	strQuery = strQuery + "SELECT X.* FROM (" ;
	strQuery = strQuery + "		SELECT  C.USERID " ;
	strQuery = strQuery + "			 ,  C.NAME " ;
	strQuery = strQuery + "			 ,  C.DEPTNO " ;
	strQuery = strQuery + "			 ,  C.MAILNO " ;
	strQuery = strQuery + "			 ,  C.CELLNO " ;
	strQuery = strQuery + "			 ,  C.LEVELNM " ;
	strQuery = strQuery + "			 ,  ROWNUM R " ;
	strQuery = strQuery + "			 ,  RANK() OVER (ORDER BY C.USERID DESC) AS RANKING " ;
	strQuery = strQuery + "		 FROM  ( " ;
	strQuery = strQuery + "				SELECT  A.USERID" ;
	strQuery = strQuery + "					 ,  B.NAME" ;
	strQuery = strQuery + "					 ,  B.DEPTNO" ;
	strQuery = strQuery + "					 ,  B.MAILNO" ;
	strQuery = strQuery + "					 ,  B.CELLNO" ;
	strQuery = strQuery + "					 ,  B.LEVELNM" ;
	strQuery = strQuery + "				  FROM  MNG_USER A, V_INSA B" ;
	strQuery = strQuery + "				 WHERE  1=1" ;
	strQuery = strQuery + "				   AND  A.USERID = B.EMPNO" ;
	strQuery = strQuery + "				   AND  A.GUBUN = '"+gubun+"'" ;
	strQuery = strQuery + "			   )  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		if (!"".equals(searchKeyfield)) {
			strQuery = strQuery + " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
		} else {
			strQuery = strQuery + " AND (C.USERID LIKE '%" + searchKeyword + "%' OR C.NAME LIKE '%" + searchKeyword + "%')" ;
		}
	}
	strQuery = strQuery + "  ORDER BY  C.USERID DESC " ; 
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

function fncPaging(pageNum){
	document.readForm.curPage.value=pageNum;
	CheckSendForm();
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
function set_checkbox(form,fname,val) {
	var _count=0;
	for(i=0;i<form.length;i++) {
		if(form[i].type=="checkbox" && form[i].name==fname) {
			if(val=='inv') {
				form[i].checked=!form[i].checked;
			} else {
				form[i].checked=val;
			}
			_count++;
		}
	}
	return _count;
}

function _checkbox(form,fname,val) {
	var Check_List=false;
	for(i=0;i<form.length;i++) {
		if(form[i].type=="checkbox" && form[i].name==fname) {
			if(form[i].checked==val) Check_List=true;
		}
	}
	return Check_List;
}

function check_action()
{
	if (!_checkbox(deleteSubmit, 'chk', true))
	{
		alert('선택해 주세요');
		return;
	}

	document.deleteSubmit.submit();
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
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_manage_user.jsp">예외직원관리</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">로그아웃</a></li>
		<li class="toptxtcon01">&nbsp;</li>
	</ul>
</div>

<form name="sendForm" method="post" action="ini_manage_user.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form action="ini_manage_user.jsp" name="readForm" method="post">
<input type="hidden" name="pageIndex" value="1" />
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable" style="border-bottom:1px solid #c5c5c5; margin:10px auto 10px auto;">
		<tr>
			<td class="wTableTdSearch1">
				<select name="searchKeyfield" id="searchKeyfield">
				<option value="">전체</option>
					<option value="C.USERID"<%if (searchKeyfield.equals("C.USERID")) {%> selected<%}%>>아이디</option>
					<option value="C.NAME"<%if (searchKeyfield.equals("C.NAME")) {%> selected<%}%>>이름</option>
				</select>
				<input type="text" name="searchKeyword" id="searchKeyword" value="<%=searchKeyword%>" style="border:1px solid #dedede; width:150px;" />
				<button type="submit">검색</button>
			</td>
		</tr>
	</table>
</form>
<form name="deleteSubmit" method="post" action="ini_manage_user_delete.jsp">
<p style="width:950px; margin:0 auto">전체 : <%=total%>건</p>
<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
	<tr>
		<th class="wTableTdHeader"><input type="checkbox" onclick="set_checkbox(this.form, 'chk', this.checked)" /></th>
		<th class="wTableTdHeader" scope="col">NO</th>
		<th class="wTableTdHeader" scope="col">이름</th>
		<th class="wTableTdHeader" scope="col">사번</th>
		<th class="wTableTdHeader" scope="col">직급</th>
	</tr>
<%
int no = (total - (ROWSIZE * (pageIndex-1)));
while (rs.next()) {		
%>

		<tr>
			<td class="wTableTdCell" style="text-align:center"><input type="checkbox" name="chk" value="<%=rs.getString("USERID")%>" /></td>
			<td class="wTableTdCell" style="text-align:center"><%=no%></td>
			<td class="wTableTdCell" style="text-align:center"><a href="ini_manage_user_write.jsp?userId=<%=rs.getString("USERID")%>"><%=rs.getString("NAME")%></a></td>
			<td class="wTableTdCell" style="text-align:center"><%=rs.getString("USERID")%></td>
			<td class="wTableTdCell" style="text-align:center">
				<% if (rs.getString("LEVELNM") != null) { %>
				<%=rs.getString("LEVELNM")%>
				<% } %>
			</td>
		</tr>
<%
	no--;
}
%>
<% if (total < 1) { %>
		<tr class="wTableTdSearch1">
			<td class="wTableTdCell" style="text-align:center" colspan="4">데이터가 없습니다.</td>
		</tr>
<% } %>
</table>
<div style="width:950px; margin:0 auto; height:60px;">
<button type="button" onclick="check_action();" style="left; width:80px; border:1px solid #dedede; background:#3068b0;   text-align:center; color:#fff; padding: 10px 10px; ">선택삭제</button>
<a href="ini_manage_user_write.jsp" style="float:right; width:50px; border:1px solid #dedede; background:#3068b0;   text-align:center; color:#fff; padding: 10px 10px; ">등록</a>
</div>


</form>


<% if (pageIndex > BLOCK) { %>
<a href="?pageIndex=1&<%=queryString%>">처음</a>
<a href="?pageIndex=<%=(startPage-1)%>&<%=queryString%>">이전</a>
<% } %>
<% 
for (int i = startPage; i <= endPage; i++ ) {
	if (i == pageIndex) {
%>
	<strong><%=i%></strong>
<%
	} else {
%>
	<a href="?pageIndex=<%=i%>&<%=queryString%>"><%=i%></a>
<%
	}
}
%>
<% if (endPage < totalPage) { %>
<a href="?pageIndex=<%=(endPage+1)%>&<%=queryString%>">다음</a>
<a href="?pageIndex=<%=totalPage%>&<%=queryString%>">마지막</a>
<% } %>


<%
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}
%>

<script language="javascript">dspCopyRight();</script>
