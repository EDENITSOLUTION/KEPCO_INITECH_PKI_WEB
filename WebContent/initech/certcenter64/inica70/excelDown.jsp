<%@ page language="java" contentType="application/vnd.ms-excel;charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.*"%>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import="java.lang.String.*" %>

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
	writer.println("parent.location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}


String fileName="" ;





int totalRecord = 0; //총 데이터 개수를 저장할 변수
int totalPage = 0;  //총 페이지수를 저장할 변수



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

DecimalFormat df = new DecimalFormat("00");
Calendar now = Calendar.getInstance();
String nowYear = String.valueOf(now.get(Calendar.YEAR));
String nowMonth = String.valueOf(now.get(Calendar.MONTH)+1);
String nowDay = String.valueOf(now.get(Calendar.DATE));


String hour = ""; //시간을 구한다
if( now.get(Calendar.AM_PM) == Calendar.PM){
  hour = df.format(now.get(Calendar.HOUR)+12); //Calendar.PM이면 12를 더한다
} else {
  hour = df.format(now.get(Calendar.HOUR));
}

String minute = df.format(now.get(Calendar.MINUTE)); //분을 구한다
String second = df.format(now.get(Calendar.SECOND)); //초를 구한다


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


String CurYYYMMDDHHMMSS = nowYear + nowMonth + nowDay + hour + minute + second ;

String CurTime = nowYear+"년 " + nowMonth +"월 " + nowDay + "일 " + hour + ":" + minute +":" + second ;


String baseDatCol = "A.ISSUE_DATE";
String baseCondQuery = "" ;
if (m_searchGb.equals("T")) { //금일
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
	fileName = fileName + "금일발급내역";
}
else if (m_searchGb.equals("Y")) { //어제
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate-1,'YYYY-MM-DD') ";
	fileName = fileName + "어제발급내역";
}
else if (m_searchGb.equals("TM")) { //이번달	
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate,'YYYY-MM') || '-01' And    to_char("+ baseDatCol +",'YYYY-MM-DD')";
	fileName = fileName + "이번달발급내역";
}
else if (m_searchGb.equals("M1")) { //1개월
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-30,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
	fileName = fileName + "1개월간의발급내역";
}
else if (m_searchGb.equals("M3")) { //3개월
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-90,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
	fileName = fileName + "3개월간의발급내역";
}
else if (m_searchGb.equals("B")) { //기간별
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char('"+ f_yyyy +"-"+f_mm+"-"+f_dd +"') And    to_char('"+ t_yyyy +"-"+t_mm+"-"+t_dd +"') ";
	fileName = fileName + "기간별발급내역("+f_yyyy+"."+f_mm+"."+f_dd+"_"+t_yyyy+"."+t_mm+"."+t_dd+")";
}
else{
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
	fileName = fileName + "금일발급내역";
}
//유효(I) / 폐기(R)
if (STATUS.equals("I") || STATUS.equals("R")){
	baseCondQuery = baseCondQuery + " AND  A.STATUS = '"+ STATUS +"' ";
}
if (STATUS.equals("I")){
	fileName = fileName + "_유효인증서";
}else if (STATUS.equals("R")){
	fileName = fileName + "_폐기인증서";
}else{
	fileName = fileName + "_전체";
}

fileName = fileName ;//+ "_" + CurYYYMMDDHHMMSS ;

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


try {
	connu = dsu.getConnection();
	//Creat Query and get results
	stmtu = connu.createStatement();

	rsu = stmtu.executeQuery(strTotQuerey);
	rsu.next();
    totalRecord = rsu.getInt(1); //총 카운트수
%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>인증서 발급 내역</title>


 <%

response.setHeader("Content-Type", "application/vnd.ms-excel;charset=euc-kr");
response.setHeader("Content-Description", "stype=mso-number-format:'\\@'");  
response.setHeader("Content-Disposition", "attachment; filename=CertificateList_"+CurYYYMMDDHHMMSS+".xls");  
response.setHeader("Content-Description", "Certificates List");  

%>
<style type="text/css">
.default {
	font-size: 8pt;
	font-family:"맑은 고딕", Dotum, Gulim, Verdana, AppleGothic, sans-serif;

}

.wTable {
	border-top : solid 1px #c5c5c5;
	border-left : solid 1px #c5c5c5;
}
.wTableTdHeader {
	font-size: 8pt;
	font-family:"맑은 고딕", Dotum, Gulim, Verdana, AppleGothic, sans-serif;
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	text-align : center;
	font-weight : bold;
	background-color : #eeeeee ;
	padding : 4px;
}
.wTableTdCell {
	font-size: 8pt;
	font-family:"맑은 고딕", Dotum, Gulim, Verdana, AppleGothic, sans-serif;
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffff ;
	padding : 4px;
}
</style>

</head> 
<body>
	<table cellSpacing="0" cellPadding="0" style="width:2000px;" border="0">
		<tr>
			<td colspan="11" class="default"><%=fileName%> (<%=CurTime%> 기준)</td>
		</tr>
	</table>
	<table cellSpacing="0" cellPadding="0" style="width:2000px;" border="0">
		<tr>
			<td colspan="11" class="default" style="text-align:right;">
				총 <span style="font-weight:bold;color:#ff0033;"><%=totalRecord%></span>건의 인증서 발급내역이 존재합니다.
			</td>
		</tr>
	</table>
	<table cellSpacing="0" cellPadding="0" style="width:2000px;" border="0" class="wTable">
		<tr>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="4">사용자 정보</td>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="7">인증서 정보</td>
		</tr>
		<tr>
			<td class="wTableTdHeader" style="width:45px;">순번</td>
			<td class="wTableTdHeader" style="width:55px;">성명</td>
			<td class="wTableTdHeader" style="width:50px;">사번</td>
			<td class="wTableTdHeader" style="width:80px;">접속IP</td>
			<td class="wTableTdHeader" style="width:80px;">인증서<br>시리얼</td>
			<td class="wTableTdHeader" style="width:120px;">인증서발급일</td>
			<td class="wTableTdHeader" style="width:400px;">인증서 유효기간 시작일 ~ 종료일</td>
			<td class="wTableTdHeader" style="width:1025px;">인증서 Subject DN값</td>
			<td class="wTableTdHeader" style="width:65px;">사용가능<br />남은일수</td>
			<td class="wTableTdHeader" style="width:40px;">인증서<br>상태</td>
			<td class="wTableTdHeader" style="width:40px;">인증서<br>변경<br>내용</td>
		</tr>
<%
Locale locale = java.util.Locale.KOREA;
SimpleDateFormat sdfr = new SimpleDateFormat("yyyy-MM-dd", locale);
java.util.Date today  = new java.util.Date(); 
String convertedToday = sdfr.format(today);

rsu = stmtu.executeQuery(strQuery);

int irs = 1 ;
while( rsu.next() ) {		

%>
		<tr>
			<td class="wTableTdCell"><%=irs%></td>
			<td class="wTableTdCell"><%=rsu.getString("USERNAME")%></td>
			<td class="wTableTdCell" style="mso-number-format:'\@';"><%=rsu.getString("USERID")%></td>
			<td class="wTableTdCell"><%=rsu.getString("USERIP")%></td>
			<td class="wTableTdCell" style="text-align:center;mso-number-format:'\@';"><%=rsu.getString("SERIAL")%></td>
			<td class="wTableTdCell"><%=rsu.getString("ISSUE_DATE")%></td>
			<td class="wTableTdCell"><%=rsu.getString("ISSUE_DATE")%> ~ <%=rsu.getString("EXPIRE_DATE")%></td>
			<td class="wTableTdCell"><%=rsu.getString("DN")%></td>
			<td class="wTableTdCell" style="text-align:center;">
				<%if (rsu.getString("STATUS").equals("I")) {%>
				<%=getDateDiff(convertedToday, rsu.getString("EXPIRE_DATE"))%>/<%=getDateDiff(rsu.getString("ISSUE_DATE"), rsu.getString("EXPIRE_DATE"))%>일
				<%}else{%>
				<%}%>
			</td>
			<td class="wTableTdCell" style="text-align:center;"><%=rsu.getString("STATUSNM")%></td>
			<td class="wTableTdCell" style="text-align:center;"><%=rsu.getString("LASTSTATUSNM")%></td>
		</tr>

		
<%
	irs++;
}
%>
						
	</table>
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