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


//************************************************
//      변수 선언 및 입력정보 복호화
//************************************************
	
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");


//암호화여부 : 리얼적용시 반드시true로 변경해야함..
//boolean m_bEncrypt = true;


//************************************************
//     페이지 변수 선언 Start
//************************************************
//1. 한 페이지당 보일 레코드 수를 결정하고, 총 페이지 수를 구한다.

String strNumPerPage = request.getParameter("strNumPerPage") ;
if (strNumPerPage == null || strNumPerPage.equals("")){
	strNumPerPage = "20" ;
}


int numPerPage = Integer.parseInt(strNumPerPage); // 한 페이지당 보일 레코드 수 결정
int totalRecord = 0; //총 데이터 개수를 저장할 변수
int totalPage = 0;  //총 페이지수를 저장할 변수


//2. 첫번째 레코드 번호와 마지막 레코드 번호를 구하고 출력한다.
int curPage = (request.getParameter("curPage") == null) ? 1 :
Integer.parseInt(request.getParameter("curPage"));
// 시작 레코드 계산 .....
int start = ( curPage - 1 ) * numPerPage + 1;
// 마지막 레코드 계산 .....
int end = start + numPerPage - 1;

int block = 10;
int startPage = ((curPage - 1) / block * block) + 1;
int endPage = ((curPage - 1) / block * block) + block;


//************************************************
//     페이지 변수 선언 End
//************************************************

//검색조건
//String m_searchGb = null ; //기본 검색기간은 금일
//m_searchGb = m_IP.getParameter("searchGb");
String m_searchGb = request.getParameter("searchGb");

if (m_searchGb == null || m_searchGb.equals("")) {
	m_searchGb = "T";
}
String f_yyyy = request.getParameter("f_yyyy"); 
String f_mm = request.getParameter("f_mm"); 
String f_dd = request.getParameter("f_dd"); 
String t_yyyy = request.getParameter("t_yyyy"); 
String t_mm = request.getParameter("t_mm"); 
String t_dd = request.getParameter("t_dd");
String STATUS = request.getParameter("STATUS");
if (STATUS == null || STATUS.equals("")) {
	STATUS = "I";
}
String gb = request.getParameter("gb");
if (gb == null || gb.equals("")) {
	gb = "C.USERNAME";
}
String strKeyword = request.getParameter("strKeyword");
if (strKeyword == null || strKeyword.equals("") || strKeyword.equals("null")) {
	strKeyword = "";
}

Calendar now = Calendar.getInstance();
String nowYear = String.valueOf(now.get(Calendar.YEAR));
String nowMonth = String.valueOf(now.get(Calendar.MONTH)+1);
String nowDay = String.valueOf(now.get(Calendar.DATE));

if (f_yyyy == null || f_yyyy.equals("") || t_yyyy == null || t_yyyy.equals("") ) {
	f_yyyy = nowYear ;
	t_yyyy = nowYear ;
}




if (f_mm == null || f_mm.equals("") || t_mm == null || t_mm.equals("") ) {
	if (nowMonth.length() < 2 ) {
		f_mm = "0" + nowMonth ;
		t_mm = "0" + nowMonth ;
	}else{
		f_mm = nowMonth ;
		t_mm = nowMonth ;
	}
}

if (f_dd == null || f_dd.equals("") || t_dd == null || t_dd.equals("") ) {
	if (nowDay.length() < 2 ) {
		f_dd = "0" + nowDay ;
		t_dd = "0" + nowDay ;
	}else{
		f_dd = nowDay ;
		t_dd = nowDay ;
	}
}

String baseDatCol = "A.ISSUE_DATE";
String baseCondQuery = "" ;
if (m_searchGb.equals("T")) { //금일
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("Y")) { //어제
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate-1,'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("TM")) { //이번달	
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate,'YYYY-MM') || '-01' And    to_char("+ baseDatCol +",'YYYY-MM-DD')";
}
else if (m_searchGb.equals("M1")) { //1개월
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-30,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("M3")) { //3개월
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-90,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("B")) { //기간별
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char('"+ f_yyyy +"-"+f_mm+"-"+f_dd +"') And    to_char('"+ t_yyyy +"-"+t_mm+"-"+t_dd +"') ";
}
else{
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
}
//유효(I) / 폐기(R)
if (STATUS.equals("I") || STATUS.equals("R")){
	baseCondQuery = baseCondQuery + " AND  A.STATUS = '"+ STATUS +"' ";
}

String queryString = "";


Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
ResultSet rsu = null;

Connection connu = null;
Statement stmtu = null;
PreparedStatement pstmtu = null;


String strTotQuerey = "" ;
strTotQuerey = strTotQuerey + "SELECT COUNT(*) AS CNT " ;
strTotQuerey = strTotQuerey + "FROM ( " ;

strTotQuerey = strTotQuerey + "SELECT " ;
strTotQuerey = strTotQuerey + "        A.SERIAL " ;
strTotQuerey = strTotQuerey + "    ,   A.USERID " ;
strTotQuerey = strTotQuerey + "    ,   ( " ;
strTotQuerey = strTotQuerey + "			SELECT DISTINCT(nvl(USERNAME,'TEST사용자'))  " ;
strTotQuerey = strTotQuerey + "			FROM USER_PWD  " ;
strTotQuerey = strTotQuerey + "			WHERE USERID=A.USERID " ;
strTotQuerey = strTotQuerey + "			) AS USERNAME " ;
strTotQuerey = strTotQuerey + "    ,   ( " ;
strTotQuerey = strTotQuerey + "			SELECT NVL(USERIP,'&nbsp;')   " ;
strTotQuerey = strTotQuerey + "			FROM USER_PWD  " ;
strTotQuerey = strTotQuerey + "			WHERE USERID=A.USERID " ;
strTotQuerey = strTotQuerey + "			) AS USERIP " ;
strTotQuerey = strTotQuerey + "    ,   A.ISSUER_CODE " ;
strTotQuerey = strTotQuerey + "    ,   A.STATUS " ;
strTotQuerey = strTotQuerey + "    ,  ( " ;
strTotQuerey = strTotQuerey + "          CASE A.STATUS " ;
strTotQuerey = strTotQuerey + "              WHEN 'I' THEN '유효' " ;
strTotQuerey = strTotQuerey + "              WHEN 'R' THEN '페기' " ;
strTotQuerey = strTotQuerey + "              WHEN 'S' THEN '효력정지' " ;
strTotQuerey = strTotQuerey + "              ELSE '유효' " ;
strTotQuerey = strTotQuerey + "          END " ;
strTotQuerey = strTotQuerey + "        ) AS STATUSNM " ;
strTotQuerey = strTotQuerey + "   ,  ( " ;
strTotQuerey = strTotQuerey + "        CASE A.LASTSTATUS " ;
strTotQuerey = strTotQuerey + "            WHEN '10' THEN '발급' " ;
strTotQuerey = strTotQuerey + "            WHEN '15' THEN '재발급' " ;
strTotQuerey = strTotQuerey + "            WHEN '20' THEN '갱신' " ;
strTotQuerey = strTotQuerey + "            WHEN '30' THEN '폐기' " ;
strTotQuerey = strTotQuerey + "            WHEN '40' THEN '효력정지' " ;
strTotQuerey = strTotQuerey + "            WHEN '41' THEN '효력회복' " ;
strTotQuerey = strTotQuerey + "            WHEN '45' THEN '환불폐기' " ;
strTotQuerey = strTotQuerey + "            ELSE '발급' " ;
strTotQuerey = strTotQuerey + "        END " ;
strTotQuerey = strTotQuerey + "        ) AS LASTSTATUSNM " ;
strTotQuerey = strTotQuerey + "    ,   A.LASTSTATUS " ;
strTotQuerey = strTotQuerey + "    ,   A.ISSUE_DATE " ;
strTotQuerey = strTotQuerey + "    ,   A.EXPIRE_DATE " ;
strTotQuerey = strTotQuerey + "    ,   A.EVENT_DATE    " ;
strTotQuerey = strTotQuerey + "    ,  (SELECT DN FROM LDAP_INFO WHERE SERIAL=A.SERIAL) AS DN  " ;
strTotQuerey = strTotQuerey + " FROM CERTS A " ;
strTotQuerey = strTotQuerey + " WHERE A.USERID IS NOT NULL " ;
strTotQuerey = strTotQuerey + baseCondQuery ;
strTotQuerey = strTotQuerey + "    ) C " ;
if ( strKeyword != "" ) {
	strTotQuerey = strTotQuerey + "    WHERE "+gb+" like '%"+ strKeyword +"%' " ;
}


String strQuery = "" ;
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
strQuery = strQuery + "              WHEN 'R' THEN '페기' " ;
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
strQuery = strQuery + "    ,  (SELECT DN FROM LDAP_INFO WHERE SERIAL=A.SERIAL) AS DN  " ;
strQuery = strQuery + " FROM CERTS A " ;
strQuery = strQuery + " WHERE A.USERID IS NOT NULL " ;
strQuery = strQuery + baseCondQuery ;
strQuery = strQuery + "    ) C " ;
if ( strKeyword != "" ) {
	strQuery = strQuery + "    WHERE "+gb+" like '%"+ strKeyword +"%' " ;
}
strQuery = strQuery + " ORDER BY C.SERIAL DESC " ; 
strQuery = strQuery + ") X " ; 
//strQuery = strQuery + " WHERE X.R BETWEEN "+ start +" and "+ end ; 
strQuery = strQuery + " WHERE X.RANKING BETWEEN "+ start +" and "+ end ; 


try {
	connu = dsu.getConnection();
	//Creat Query and get results
	stmtu = connu.createStatement();

	rsu = stmtu.executeQuery(strTotQuerey);
	rsu.next();
    totalRecord = rsu.getInt(1); //총 카운트수
	

	if ( totalRecord != 0 ) {
		if ( ( totalRecord % numPerPage ) == 0 ) {
			totalPage = ( totalRecord / numPerPage );
		} else {
			totalPage = (totalRecord / numPerPage + 1 );
		}
		if (endPage > totalPage) {
			endPage = totalPage;
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

function excelDown(){
	var exForm = document.exForm;
	exForm.target="hdnFrame";
	exForm.action="excelDown.jsp";
	exForm.submit();
}
</script>

<style type="text/css">
.wTable {
	width:950px;
	border-top : solid 1px #c5c5c5;
	border-left : solid 1px #c5c5c5;
}
.wTableTdHeader {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	text-align : center;
	font-weight : bold;
	background-color : #eeeeee ;
	padding : 4px;
}
.wTableTdCell {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffff ;
	padding : 4px;
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
</style>

<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body>
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>
<div id="header"> 
	<!-- MAIN MENU START -->
	<script language="javascript">dspMainMenu();</script>
	<!-- MAIN MENU END -->
</div>
<div style="height:10px;"></div>
<div id="subtop">
	<ul class="subtoptxt">
		<li class="toptxtcon">인증센터 관리자</li>
		<li class="toptxtcon01" style="text-decoration:underline;width:150px;text-align:left; font-weight:bold; color:#000;"><a href="ini_manage_cert.jsp">인증서 발급 내역 조회</a></li>
		<li class="toptxtcon01"><a href="ini_manage_config.jsp">환경설정</a></li>
		<li class="toptxtcon01"><a href="ini_manage_insa.jsp">인사정보목록</a></li>
		<li class="toptxtcon01"><a href="ini_manage_user.jsp">예외직원관리</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">로그아웃</a></li>
		<li class="toptxtcon01">&nbsp;</li>
	</ul>
</div>
<form name="sendForm" method="post" action="./ini_manage_cert.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm" method="post">
<input type="hidden" name="curPage" value="1" />
<div style="width:960px; margin:16px auto 16px; font-weight:normal;">
	
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
		<tr>
			<td class="wTableTdSearch1" style="border-right : solid 1px #ffffff;">
				<input type="radio" name="searchGb" value="T" <%if (m_searchGb.equals("T")){%>checked="checked"<%}%> onclick="CheckSendForm();">금일 발급내역
				<input type="radio" name="searchGb" value="Y" <%if (m_searchGb.equals("Y")){%>checked="checked"<%}%> onclick="CheckSendForm();">어제 발급내역
				<input type="radio" name="searchGb" value="TM" <%if (m_searchGb.equals("TM")){%>checked="checked"<%}%> onclick="CheckSendForm();">이번달 발급내역 
				<input type="radio" name="searchGb" value="M1" <%if (m_searchGb.equals("M1")){%>checked="checked"<%}%> onclick="CheckSendForm();">1개월간의 발급내역 
				<input type="radio" name="searchGb" value="M3" <%if (m_searchGb.equals("M3")){%>checked="checked"<%}%> onclick="CheckSendForm();">3개월간의 발급 내역 
			</td>
			<td class="wTableTdSearch1" style="width:130px;text-align:center;border-bottom : solid 1px #c5c5c5;" rowspan="3">
				<img src="./img/exceldown.gif" border="0" style="cursor:pointer;" onclick="excelDown();" />
			</td>
		</tr>
		<tr>
			<td class="wTableTdSearch1" style="border-right : solid 1px #ffffff;">
				<input type="radio" name="searchGb" value="B" <%if (m_searchGb.equals("B")){%>checked="checked"<%}%> onclick="CheckSendForm();">기간별 조회
				<select name="f_yyyy" id="f_yyyy"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
					<option value="2014"<%if (f_yyyy.equals("2014")) {%> selected<%}%>>2014년</option>
					<option value="2015"<%if (f_yyyy.equals("2015")) {%> selected<%}%>>2015년</option>
					<option value="2016"<%if (f_yyyy.equals("2016")) {%> selected<%}%>>2016년</option>
					<option value="2017"<%if (f_yyyy.equals("2017")) {%> selected<%}%>>2017년</option>
					<option value="2018"<%if (f_yyyy.equals("2018")) {%> selected<%}%>>2018년</option>
					<option value="2019"<%if (f_yyyy.equals("2019")) {%> selected<%}%>>2019년</option>
					<option value="2020"<%if (f_yyyy.equals("2020")) {%> selected<%}%>>2020년</option>
                                        <option value="2021"<%if (f_yyyy.equals("2021")) {%> selected<%}%>>2021년
</option>
                                        <option value="2022"<%if (f_yyyy.equals("2022")) {%> selected<%}%>>2022년
</option>
                                        <option value="2023"<%if (f_yyyy.equals("2023")) {%> selected<%}%>>2023년
</option>                       
				</select>
				<select name="f_mm" id="f_mm"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
				<%
				String fMM  = "" ;
				for (int i = 1; i<=12 ; i++) {
					if (i < 10 ){
						fMM = "0" + Integer.toString(i);
					}else{
						fMM = Integer.toString(i);
					}
				%>
					<option value="<%=fMM%>" <%if (fMM.equals(f_mm)) {%> selected<%}%>><%=fMM%>월</option>
				<%
				}
				%>
				</select>
				<select name="f_dd" id="f_dd"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
				<%
				String fDD  = "" ;
				for (int i = 1; i<=31 ; i++) {
					if (i < 10 ){
						fDD = "0" + Integer.toString(i);
					}else{
						fDD = Integer.toString(i);
					}
				%>
					<option value="<%=fDD%>"<%if (fDD.equals(f_dd)) {%> selected<%}%>><%=fDD%>일</option>
				<%
				}
				%>
				</select>
				~
				<select name="t_yyyy" id="t_yyyy"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
					<option value="2014"<%if (t_yyyy.equals("2014")) {%> selected<%}%>>2014년</option>
					<option value="2015"<%if (t_yyyy.equals("2015")) {%> selected<%}%>>2015년</option>
					<option value="2016"<%if (t_yyyy.equals("2016")) {%> selected<%}%>>2016년</option>
					<option value="2017"<%if (t_yyyy.equals("2017")) {%> selected<%}%>>2017년</option>
					<option value="2018"<%if (t_yyyy.equals("2018")) {%> selected<%}%>>2018년</option>
					<option value="2019"<%if (t_yyyy.equals("2019")) {%> selected<%}%>>2019년</option>
					<option value="2020"<%if (t_yyyy.equals("2020")) {%> selected<%}%>>2020년</option>
                                        <option value="2021"<%if (f_yyyy.equals("2021")) {%> selected<%}%>>2021년
</option>
                                        <option value="2022"<%if (f_yyyy.equals("2022")) {%> selected<%}%>>2022년
</option>
                                        <option value="2023"<%if (f_yyyy.equals("2023")) {%> selected<%}%>>2023년
</option>                       
				</select>
				<select name="t_mm" id="t_mm"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
				<%
				String tMM  = "" ;
				for (int i = 1; i<=12 ; i++) {
					if (i < 10 ){
						tMM = "0" + Integer.toString(i);
					}else{
						tMM = Integer.toString(i);
					}
				%>
					<option value="<%=tMM%>" <%if (tMM.equals(t_mm)) {%> selected<%}%>><%=tMM%>월</option>
				<%
				}
				%>
				</select>
				<select name="t_dd" id="t_dd"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
				<%
				String tDD  = "" ;
				for (int i = 1; i<=31 ; i++) {
					if (i < 10 ){
						tDD = "0" + Integer.toString(i);
					}else{
						tDD = Integer.toString(i);
					}
				%>
					<option value="<%=tDD%>"<%if (tDD.equals(t_dd)) {%> selected<%}%>><%=tDD%>일</option>
				<%
				}
				%>
				</select>
		
			</td>
		</tr>
		<tr>
			<td class="wTableTdSearch" style="border-right : solid 1px #ffffff;">
				<select name="STATUS" id="STATUS" onchange="CheckSendForm();">
					<option value="T"<%if (STATUS.equals("T")) {%> selected<%}%>>인증서상태(전체)</option>
					<option value="I"<%if (STATUS.equals("I")) {%> selected<%}%>>유효</option>
					<option value="R"<%if (STATUS.equals("R")) {%> selected<%}%>>폐기</option>
				</select>
				<select name="gb" id="gb">
					<option value="C.USERNAME"<%if (gb.equals("C.USERNAME")) {%> selected<%}%>>사용자 성명</option>
					<option value="C.USERID"<%if (gb.equals("C.USERID")) {%> selected<%}%>>사용자 사번</option>
					<option value="C.USERIP"<%if (gb.equals("C.USERIP")) {%> selected<%}%>>사용자 IP</option>
				</select>
				<input type="text" name="strKeyword" id="strKeyword"  style="width:150px; border: 1px solid #dedede;" value="<%=strKeyword%>">
				<input type="image" src="./img/retrieve.jpg" border="0" style="marging:0px;cursor:pointer;" onclick=" CheckSendForm();" />
				
			</td>
		</tr>
	</table>
	<br />
	<table cellSpacing="0" cellPadding="0" width="100%" border="0">
		<tr>
			<td style="width:50%; color:#6600ff;">
				총 <span style="font-weight:bold;color:#ff0033;"><%=totalRecord%></span>건의 인증서 발급내역이 존재합니다.
			</td>
			<td style="text-align:right; padding-right:10px; padding-bottom:5px;">
				한 페이지 목록 수
				<select name="strNumPerPage" id="strNumPerPage" onchange="CheckSendForm();">
					<option value="5"<%if (strNumPerPage.equals("5")) {%> selected<%}%>>5건씩 보기</option>
					<option value="10"<%if (strNumPerPage.equals("10")) {%> selected<%}%>>10건씩 보기</option>
					<option value="15"<%if (strNumPerPage.equals("15")) {%> selected<%}%>>15건씩 보기</option>
					<option value="20"<%if (strNumPerPage.equals("20")) {%> selected<%}%>>20건씩 보기</option>
					<option value="30"<%if (strNumPerPage.equals("30")) {%> selected<%}%>>30건씩 보기</option>
					<option value="50"<%if (strNumPerPage.equals("50")) {%> selected<%}%>>50건씩 보기</option>
					<option value="100"<%if (strNumPerPage.equals("100")) {%> selected<%}%>>100건씩 보기</option>
					<option value="<%=totalRecord%>"<%if (strNumPerPage.equals(Integer.toString(totalRecord))) {%> selected<%}%>>전체보기</option>
				</select>
			</td>
		</tr>
	</table>
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
		<tr>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="4">사용자 정보</td>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="6">인증서 정보</td>
		</tr>
		<tr>
			<td class="wTableTdHeader" style="width:45px;" rowspan="2">순번</td>
			<td class="wTableTdHeader" style="width:55px;" rowspan="2">성명</td>
			<td class="wTableTdHeader" style="width:50px;" rowspan="2">사번</td>
			<td class="wTableTdHeader" style="width:80px;" rowspan="2">접속IP</td>
			<td class="wTableTdHeader" style="width:80px;" rowspan="2">인증서<br>시리얼</td>
			<td class="wTableTdHeader" style="width:120px;">인증서발급일</td>
			<td class="wTableTdHeader">인증서 유효기간 시작일 ~ 종료일</td>
			<td class="wTableTdHeader" style="width:65px;" rowspan="2">사용가능<br />남은일수</td>
			<td class="wTableTdHeader" style="width:40px;" rowspan="2">인증서<br>상태</td>
			<td class="wTableTdHeader" style="width:40px;" rowspan="2">인증서<br>변경<br>내용</td>
		</tr>
		<tr>
			<td class="wTableTdHeader" colspan="2">인증서 Subject DN값</td>
		</tr>
<%
Locale locale = java.util.Locale.KOREA;
SimpleDateFormat sdfr = new SimpleDateFormat("yyyy-MM-dd", locale);
java.util.Date today  = new java.util.Date(); 
String convertedToday = sdfr.format(today);

rsu = stmtu.executeQuery(strQuery);

int irs = (totalRecord - (numPerPage * (curPage-1)));
while( rsu.next() ) {		

%>
		<tr>
			<td class="wTableTdCell" style="text-align:center;background-color:#ffffcc;" rowspan="2"><%=irs%></td>
			<td class="wTableTdCell" style="text-align:center;background-color:#ffffcc;" rowspan="2"><%=rsu.getString("USERNAME")%></td>
			<td class="wTableTdCell" style="text-align:center;background-color:#ffffcc;" rowspan="2"><%=rsu.getString("USERID")%></td>
			<td class="wTableTdCell" style="text-align:center;background-color:#ffffcc;" rowspan="2"><%=rsu.getString("USERIP")%></td>
			<td class="wTableTdCell" style="text-align:center;" rowspan="2"><%=rsu.getString("SERIAL")%></td>
			<td class="wTableTdCell"><%=rsu.getString("ISSUE_DATE")%></td>
			<td class="wTableTdCell">
				<%=rsu.getString("ISSUE_DATE")%> ~ <%=rsu.getString("EXPIRE_DATE")%> 
			</td>
			<td class="wTableTdCell" style="text-align:center;" rowspan="2">
				<%if (rsu.getString("STATUS").equals("I")) {%>
				<%=getDateDiff(convertedToday, rsu.getString("EXPIRE_DATE"))%>/<%=getDateDiff(rsu.getString("ISSUE_DATE"), rsu.getString("EXPIRE_DATE"))%>일
				<%}else{%>
					&nbsp;
				<%}%>
			</td>
			<td class="wTableTdCell" style="text-align:center;" rowspan="2"><%=rsu.getString("STATUSNM")%></td>
			<td class="wTableTdCell" style="text-align:center;" rowspan="2"><%=rsu.getString("LASTSTATUSNM")%></td>
		</tr>

		<tr>
			<td class="wTableTdCell" colspan="2"><%=rsu.getString("DN")%></td>
		</tr>
<%
	irs--;
}
%>
						
	</table><br />
	<!--
	<table cellSpacing="0" cellPadding="0" width="100%" border="0">
		<tr>
			<td style="text-align:center;padding:5px; border-top: dotted 1px #666666;border-bottom: dotted 1px #666666;">
			<%

// 3. 각 페이지에 대한 직접 이동 링크를 만든다.
for ( int i = 1;i <= totalPage;i++ ) {
%>
    <span onclick="fncPaging(<%=i%>)" style="cursor:pointer; padding:5px;<%if (i==curPage){%>font-weight:bold; color:#ff3333;<%}%>"><%=i%></span>
<%
}
%>

			</td>
		</tr>
	</table>
	-->
<ul class="paging_box">
<% if (curPage > block) { %>
<li><a href="javascript:fncPaging(1);">처음</a></li>
<li><a href="javascript:fncPaging(<%=(startPage-1)%>);">이전</a></li>
<% } %>
<% 
for (int i = startPage; i <= endPage; i++ ) {
	if (i == curPage) {
%>
	<li><strong style="color:red; font-weight:bold"><%=i%></strong></li>
<%
	} else {
%>
	<li><a href="javascript:fncPaging(<%=i%>);"><%=i%></a></li>
<%
	}
}
%>
<% if (endPage < totalPage) { %>
<li><a href="javascript:fncPaging(<%=(endPage+1)%>);">다음</a></li>
<li><a href="javascript:fncPaging(<%=totalPage%>);">마지막</a></li>
<% } %>				
</ul>		
				
				
</div>
</form>
<form name="exForm" method="post" action="excelDown.jsp">
<input type="hidden" name="searchGb" value="<%=m_searchGb%>" />	
<input type="hidden" name="f_yyyy" value="<%=f_yyyy%>" />	
<input type="hidden" name="f_mm" value="<%=f_mm%>" />		
<input type="hidden" name="f_dd" value="<%=f_dd%>" />		
<input type="hidden" name="t_yyyy" value="<%=t_yyyy%>" />	
<input type="hidden" name="t_mm" value="<%=t_mm%>" />		
<input type="hidden" name="t_dd" value="<%=t_dd%>" />	
<input type="hidden" name="STATUS" value="<%=STATUS%>" />	
<input type="hidden" name="gb" value="<%=gb%>" />
<input type="hidden" name="strKeyword" value="<%=strKeyword%>" />
<input type="hidden" name="curPage" value="1" />
<input type="hidden" name="strNumPerPage" value="<%=totalRecord%>" />		
</form>
<iframe name="hdnFrame" id="hdnFrame" src="blank.html" width="1000" height="1000" style="display:none" scrolling="no" frameborder="0"></iframe>
<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->
<% try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} %>
</body>
</html>
<%
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rsu.close();
	connu.close();
}
%>
<%!
public static int getDateDiff(String startDate, String endDate) {

	startDate = startDate.substring(0,10).replace("-","")+"000000";
	endDate = endDate.substring(0,10).replace("-","")+"000000";
	long diffMillis = 0l;
	int diff = 0;	
	try{
		java.util.Date endDay = new SimpleDateFormat("yyyyMMddHHmmss").parse(endDate);
		Calendar endDayCal = new GregorianCalendar();
		endDayCal.setTime(endDay);
	 
		java.util.Date startDay = new SimpleDateFormat("yyyyMMddHHmmss").parse(startDate);
		Calendar startDayCal = new GregorianCalendar();
		startDayCal.setTime(startDay);
		 
		diffMillis = endDayCal.getTimeInMillis() - startDayCal.getTimeInMillis();
		
		diff = (int) (diffMillis/ (24 * 60 * 60 * 1000));
	}catch(Exception e)    {
		e.printStackTrace(System.out);
	}
	
	return diff;

}
%>
