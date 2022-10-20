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
//************************************************
//     페이지 변수 선언 Start
//************************************************
//1. 한 페이지당 보일 레코드 수를 결정하고, 총 페이지 수를 구한다.

String gubun = request.getParameter("gubun");
String searchKeyfield = request.getParameter("searchKeyfield");
String searchKeyword = request.getParameter("searchKeyword");
String status = request.getParameter("status");

if (gubun == null || gubun.equals("")) {
	gubun = "";
}

if (searchKeyfield == null || searchKeyfield.equals("")) {
	searchKeyfield = "C.USERID";
}

if (searchKeyword == null || searchKeyword.equals("") || searchKeyword.equals("null")) {
	searchKeyword = "";
}

if (status == null || status.equals("")) {
	status = "I";
}

String queryString = "gubun="+gubun+"&searchKeyfield="+searchKeyfield+"&searchKeyword="+searchKeyword+"&status="+status;


String baseCondQuery = "" ;

if (status.equals("I") || status.equals("R")){
	baseCondQuery += " AND  A.STATUS = '"+ status +"' ";
}

try {
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String strQuery = "" ;
	strQuery = strQuery + "SELECT COUNT(*) " ;
	strQuery = strQuery + "FROM ( " ;
	strQuery = strQuery + "SELECT C.SERIAL " ;
	strQuery = strQuery + "    , C.USERID " ;
	strQuery = strQuery + "    , C.USERNAME " ;
	strQuery = strQuery + "    , C.USERIP " ;
	strQuery = strQuery + "    , C.ISSUER_CODE " ;
	strQuery = strQuery + "    , C.STATUS " ;
	strQuery = strQuery + "    , C.STATUSNM " ;
	strQuery = strQuery + "    , C.LASTSTATUSNM " ;
	strQuery = strQuery + "    , C.LASTSTATUS " ;
	strQuery = strQuery + "    , C.ISSUE_DATE " ;
	strQuery = strQuery + "    , C.EXPIRE_DATE " ;
	strQuery = strQuery + "    , C.EVENT_DATE " ;
	strQuery = strQuery + "    , C.GUBUN " ;
	strQuery = strQuery + "    , NVL(C.DN,'폐기') AS DN " ;
	strQuery = strQuery + "    , ROWNUM R " ;
	strQuery = strQuery + "    , RANK() OVER (ORDER BY C.SERIAL DESC) AS RANKING " ;
	strQuery = strQuery + " FROM ( " ;
	strQuery = strQuery + "SELECT " ;
	strQuery = strQuery + "        A.SERIAL " ;
	strQuery = strQuery + "    ,   A.USERID " ;
	strQuery = strQuery + "    ,   ( " ;
	strQuery = strQuery + "			SELECT DISTINCT(nvl(USERNAME,'TEST사용자'))  " ;
	strQuery = strQuery + "			FROM USER_PWD  " ;
	strQuery = strQuery + "			WHERE USERID=A.USERID " ;
	strQuery = strQuery + "			) AS USERNAME " ;
	strQuery = strQuery + "    ,   ( " ;
	strQuery = strQuery + "			SELECT NVL(USERIP,'&nbsp;')  " ;
	strQuery = strQuery + "			FROM USER_PWD  " ;
	strQuery = strQuery + "			WHERE USERID=A.USERID " ;
	strQuery = strQuery + "			) AS USERIP " ;
	strQuery = strQuery + "    ,   A.ISSUER_CODE " ;
	strQuery = strQuery + "    ,   A.STATUS " ;
	strQuery = strQuery + "    ,  ( " ;
	strQuery = strQuery + "          CASE A.STATUS " ;
	strQuery = strQuery + "              WHEN 'I' THEN '유효' " ;
	strQuery = strQuery + "              WHEN 'R' THEN '폐기' " ;
	strQuery = strQuery + "              WHEN 'S' THEN '효력정지' " ;
	strQuery = strQuery + "              ELSE '유효' " ;
	strQuery = strQuery + "          END " ;
	strQuery = strQuery + "        ) AS STATUSNM " ;
	strQuery = strQuery + "   ,  ( " ;
	strQuery = strQuery + "        CASE A.LASTSTATUS " ;
	strQuery = strQuery + "            WHEN '10' THEN '발급' " ;
	strQuery = strQuery + "            WHEN '15' THEN '재발급' " ;
	strQuery = strQuery + "            WHEN '20' THEN '갱신' " ;
	strQuery = strQuery + "            WHEN '30' THEN '폐기' " ;
	strQuery = strQuery + "            WHEN '40' THEN '효력정지' " ;
	strQuery = strQuery + "            WHEN '41' THEN '효력회복' " ;
	strQuery = strQuery + "            WHEN '45' THEN '환불폐기' " ;
	strQuery = strQuery + "            ELSE '발급' " ;
	strQuery = strQuery + "        END " ;
	strQuery = strQuery + "        ) AS LASTSTATUSNM " ;
	strQuery = strQuery + "    ,   A.LASTSTATUS " ;
	strQuery = strQuery + "    ,   A.ISSUE_DATE " ;
	strQuery = strQuery + "    ,   A.EXPIRE_DATE " ;
	strQuery = strQuery + "    ,   A.EVENT_DATE    " ;
	strQuery = strQuery + "    ,   NVL((SELECT DECODE(GUBUN,null,'S',GUBUN) FROM MNG_USER WHERE USERID = A.USERID),'S') AS GUBUN    " ;
	strQuery = strQuery + "    ,  (SELECT DN FROM LDAP_INFO WHERE SERIAL=A.SERIAL) AS DN  " ;
	strQuery = strQuery + " FROM CERTS A" ;
	strQuery = strQuery + " WHERE A.USERID IS NOT NULL " ;
	strQuery = strQuery + baseCondQuery ;
	strQuery = strQuery + "    ) C WHERE 1=1" ;
	if (searchKeyword != "") {
		strQuery = strQuery + "    AND "+searchKeyfield+" like '%"+ searchKeyword +"%' " ;
	}
	if (gubun != null && !"".equals(gubun)) {
		strQuery = strQuery + " AND  C.GUBUN = '"+ gubun +"' ";
	}
	strQuery = strQuery + " ORDER BY C.SERIAL DESC " ; 
	strQuery = strQuery + ") X " ; 

	rs = stmt.executeQuery(strQuery);
	rs.next();
    total = rs.getInt(1);
	
	totalPage = (int)Math.ceil(total / ROWSIZE);
	if (endPage > totalPage) {
		endPage = totalPage;
	}

	strQuery = "";
	strQuery = strQuery + "SELECT X.* " ;
	strQuery = strQuery + "FROM ( " ;
	strQuery = strQuery + "SELECT C.SERIAL " ;
	strQuery = strQuery + "    , C.USERID " ;
	strQuery = strQuery + "    , C.USERNAME " ;
	strQuery = strQuery + "    , C.USERIP " ;
	strQuery = strQuery + "    , C.ISSUER_CODE " ;
	strQuery = strQuery + "    , C.STATUS " ;
	strQuery = strQuery + "    , C.STATUSNM " ;
	strQuery = strQuery + "    , C.LASTSTATUSNM " ;
	strQuery = strQuery + "    , C.LASTSTATUS " ;
	strQuery = strQuery + "    , C.ISSUE_DATE " ;
	strQuery = strQuery + "    , C.EXPIRE_DATE " ;
	strQuery = strQuery + "    , C.EVENT_DATE " ;
	strQuery = strQuery + "    , C.GUBUN " ;
	strQuery = strQuery + "    , NVL(C.DN,'폐기') AS DN " ;
	strQuery = strQuery + "    , ROWNUM R " ;
	strQuery = strQuery + "    , RANK() OVER (ORDER BY C.SERIAL DESC) AS RANKING " ;
	strQuery = strQuery + " FROM ( " ;
	strQuery = strQuery + "SELECT " ;
	strQuery = strQuery + "        A.SERIAL " ;
	strQuery = strQuery + "    ,   A.USERID " ;
	strQuery = strQuery + "    ,   ( " ;
	strQuery = strQuery + "			SELECT DISTINCT(nvl(USERNAME,'TEST사용자'))  " ;
	strQuery = strQuery + "			FROM USER_PWD  " ;
	strQuery = strQuery + "			WHERE USERID=A.USERID " ;
	strQuery = strQuery + "			) AS USERNAME " ;
	strQuery = strQuery + "    ,   ( " ;
	strQuery = strQuery + "			SELECT NVL(USERIP,'&nbsp;')  " ;
	strQuery = strQuery + "			FROM USER_PWD  " ;
	strQuery = strQuery + "			WHERE USERID=A.USERID " ;
	strQuery = strQuery + "			) AS USERIP " ;
	strQuery = strQuery + "    ,   A.ISSUER_CODE " ;
	strQuery = strQuery + "    ,   A.STATUS " ;
	strQuery = strQuery + "    ,  ( " ;
	strQuery = strQuery + "          CASE A.STATUS " ;
	strQuery = strQuery + "              WHEN 'I' THEN '유효' " ;
	strQuery = strQuery + "              WHEN 'R' THEN '폐기' " ;
	strQuery = strQuery + "              WHEN 'S' THEN '효력정지' " ;
	strQuery = strQuery + "              ELSE '유효' " ;
	strQuery = strQuery + "          END " ;
	strQuery = strQuery + "        ) AS STATUSNM " ;
	strQuery = strQuery + "   ,  ( " ;
	strQuery = strQuery + "        CASE A.LASTSTATUS " ;
	strQuery = strQuery + "            WHEN '10' THEN '발급' " ;
	strQuery = strQuery + "            WHEN '15' THEN '재발급' " ;
	strQuery = strQuery + "            WHEN '20' THEN '갱신' " ;
	strQuery = strQuery + "            WHEN '30' THEN '폐기' " ;
	strQuery = strQuery + "            WHEN '40' THEN '효력정지' " ;
	strQuery = strQuery + "            WHEN '41' THEN '효력회복' " ;
	strQuery = strQuery + "            WHEN '45' THEN '환불폐기' " ;
	strQuery = strQuery + "            ELSE '발급' " ;
	strQuery = strQuery + "        END " ;
	strQuery = strQuery + "        ) AS LASTSTATUSNM " ;
	strQuery = strQuery + "    ,   A.LASTSTATUS " ;
	strQuery = strQuery + "    ,   A.ISSUE_DATE " ;
	strQuery = strQuery + "    ,   A.EXPIRE_DATE " ;
	strQuery = strQuery + "    ,   A.EVENT_DATE    " ;
	strQuery = strQuery + "    ,   NVL((SELECT DECODE(GUBUN,null,'S',GUBUN) FROM MNG_USER WHERE USERID = A.USERID),'S') AS GUBUN   " ;
	strQuery = strQuery + "    ,  (SELECT DN FROM LDAP_INFO WHERE SERIAL=A.SERIAL) AS DN  " ;
	strQuery = strQuery + " FROM CERTS A" ;
	strQuery = strQuery + " WHERE A.USERID IS NOT NULL " ;
	strQuery = strQuery + baseCondQuery ;
	strQuery = strQuery + "    ) C WHERE 1=1" ;
	if (searchKeyword != "") {
		strQuery = strQuery + "    AND "+searchKeyfield+" like '%"+ searchKeyword +"%' " ;
	}
	if (gubun != null && !"".equals(gubun)) {
		strQuery = strQuery + " AND  C.GUBUN = '"+ gubun +"' ";
	}
	strQuery = strQuery + " ORDER BY C.SERIAL DESC " ; 
	strQuery = strQuery + ") X " ; 
	strQuery = strQuery + " WHERE X.RANKING BETWEEN "+ (start-1) +" and "+ end ; 

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


</script>
</head>
<body>

<form name="sendForm" method="post" action="ini_manage_cert2.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form action="ini_manage_cert2.jsp" name="readForm" method="post">
<input type="hidden" name="pageIndex" value="1" />
		
	<select name="gubun" id="gubun">
		<option value="">전체</option>
		<option value="S"<%if (gubun.equals("S")) {%> selected<%}%>>직원</option>
		<option value="E"<%if (gubun.equals("E")) {%> selected<%}%>>예외</option>
		<option value="H"<%if (gubun.equals("H")) {%> selected<%}%>>협력업체</option>
	</select>
	<select name="status" id="status">
		<option value="T"<%if (status.equals("T")) {%> selected<%}%>>인증서상태(전체)</option>
		<option value="I"<%if (status.equals("I")) {%> selected<%}%>>유효</option>
		<option value="R"<%if (status.equals("R")) {%> selected<%}%>>폐기</option>
	</select>	
	<select name="searchKeyfield" id="searchKeyfield">
		<option value="C.USERID"<%if (searchKeyfield.equals("C.USERID")) {%> selected<%}%>>아이디</option>
		<option value="C.USERNAME"<%if (searchKeyfield.equals("C.USERNAME")) {%> selected<%}%>>이름</option>
	</select>
	<input type="text" name="searchKeyword" id="searchKeyword" value="<%=searchKeyword%>" />
	<button type="submit">검색</button>
</form>

전체 : <%=total%>건
<table>
	<tr>
		<th scope="col">NO</th>
		<th scope="col">이름</th>
		<th scope="col">사번</th>
		<th scope="col">부서</th>
		<th scope="col">발급일</th>
		<th scope="col">만료일</th>
		<th scope="col">상태</th>
	</tr>


<%
int no = (total - (ROWSIZE * (pageIndex-1)));
while (rs.next()) {		
%>

		<tr>
			<td><%=no%></td>
			<td><a href="ini_manage_cert2_issue.jsp?userId=<%=rs.getString("USERID")%>"><%=rs.getString("USERNAME")%></a></td>
			<td><%=rs.getString("USERID")%></td>
			<td></td>
			<td><%=rs.getString("ISSUE_DATE")%></td>
			<td><%=rs.getString("EXPIRE_DATE")%></td>
			<td><%=rs.getString("STATUSNM")%></td>
			<td><a href="ini_manage_cert2_pwform.jsp?userId=<%=rs.getString("USERID")%>">비밀번호초기화</a></td>
		</tr>
<%
	no--;
}
%>
<% if (total < 1) { %>
		<tr>
			<td colspan="7">데이터가 없습니다.</td>
		</tr>
<% } %>
</table>


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