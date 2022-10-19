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
//      ������ ���� üũ
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
if (adminLogin == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('������ �α��� ������ �������� �ʽ��ϴ�.');");
	writer.println("parent.location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}


String fileName="" ;





int totalRecord = 0; //�� ������ ������ ������ ����
int totalPage = 0;  //�� ���������� ������ ����



//************************************************
//     ������ ���� ���� End
//************************************************

//�˻�����
//String m_searchGb = null ; //�⺻ �˻��Ⱓ�� ����
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


String hour = ""; //�ð��� ���Ѵ�
if( now.get(Calendar.AM_PM) == Calendar.PM){
  hour = df.format(now.get(Calendar.HOUR)+12); //Calendar.PM�̸� 12�� ���Ѵ�
} else {
  hour = df.format(now.get(Calendar.HOUR));
}

String minute = df.format(now.get(Calendar.MINUTE)); //���� ���Ѵ�
String second = df.format(now.get(Calendar.SECOND)); //�ʸ� ���Ѵ�


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

String CurTime = nowYear+"�� " + nowMonth +"�� " + nowDay + "�� " + hour + ":" + minute +":" + second ;


String baseDatCol = "A.ISSUE_DATE";
String baseCondQuery = "" ;
if (m_searchGb.equals("T")) { //����
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
	fileName = fileName + "���Ϲ߱޳���";
}
else if (m_searchGb.equals("Y")) { //����
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate-1,'YYYY-MM-DD') ";
	fileName = fileName + "�����߱޳���";
}
else if (m_searchGb.equals("TM")) { //�̹���	
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate,'YYYY-MM') || '-01' And    to_char("+ baseDatCol +",'YYYY-MM-DD')";
	fileName = fileName + "�̹��޹߱޳���";
}
else if (m_searchGb.equals("M1")) { //1����
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-30,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
	fileName = fileName + "1�������ǹ߱޳���";
}
else if (m_searchGb.equals("M3")) { //3����
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-90,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
	fileName = fileName + "3�������ǹ߱޳���";
}
else if (m_searchGb.equals("B")) { //�Ⱓ��
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char('"+ f_yyyy +"-"+f_mm+"-"+f_dd +"') And    to_char('"+ t_yyyy +"-"+t_mm+"-"+t_dd +"') ";
	fileName = fileName + "�Ⱓ���߱޳���("+f_yyyy+"."+f_mm+"."+f_dd+"_"+t_yyyy+"."+t_mm+"."+t_dd+")";
}
else{
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
	fileName = fileName + "���Ϲ߱޳���";
}
//��ȿ(I) / ���(R)
if (STATUS.equals("I") || STATUS.equals("R")){
	baseCondQuery = baseCondQuery + " AND  A.STATUS = '"+ STATUS +"' ";
}
if (STATUS.equals("I")){
	fileName = fileName + "_��ȿ������";
}else if (STATUS.equals("R")){
	fileName = fileName + "_���������";
}else{
	fileName = fileName + "_��ü";
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
strTotQuerey = strTotQuerey + "			SELECT DISTINCT(nvl(USERNAME,'TEST�����'))  " ;
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
strTotQuerey = strTotQuerey + "              WHEN 'I' THEN '��ȿ' " ;
strTotQuerey = strTotQuerey + "              WHEN 'R' THEN '���' " ;
strTotQuerey = strTotQuerey + "              WHEN 'S' THEN 'ȿ������' " ;
strTotQuerey = strTotQuerey + "              ELSE '��ȿ' " ;
strTotQuerey = strTotQuerey + "          END " ;
strTotQuerey = strTotQuerey + "        ) AS STATUSNM " ;
strTotQuerey = strTotQuerey + "   ,  ( " ;
strTotQuerey = strTotQuerey + "        CASE A.LASTSTATUS " ;
strTotQuerey = strTotQuerey + "            WHEN '10' THEN '�߱�' " ;
strTotQuerey = strTotQuerey + "            WHEN '15' THEN '��߱�' " ;
strTotQuerey = strTotQuerey + "            WHEN '20' THEN '����' " ;
strTotQuerey = strTotQuerey + "            WHEN '30' THEN '���' " ;
strTotQuerey = strTotQuerey + "            WHEN '40' THEN 'ȿ������' " ;
strTotQuerey = strTotQuerey + "            WHEN '41' THEN 'ȿ��ȸ��' " ;
strTotQuerey = strTotQuerey + "            WHEN '45' THEN 'ȯ�����' " ;
strTotQuerey = strTotQuerey + "            ELSE '�߱�' " ;
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
strQuery = strQuery + "    , NVL(C.DN,'���') AS DN " ;
strQuery = strQuery + "    , ROWNUM R " ;
strQuery = strQuery + "    , RANK() OVER (ORDER BY C.SERIAL DESC) AS RANKING " ;
strQuery = strQuery + " FROM ( " ;

strQuery = strQuery + "SELECT " ;
strQuery = strQuery + "        A.SERIAL " ;
strQuery = strQuery + "    ,   A.USERID " ;
strQuery = strQuery + "    ,   ( " ;
strQuery = strQuery + "			SELECT DISTINCT(nvl(USERNAME,'TEST�����'))  " ;
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
strQuery = strQuery + "              WHEN 'I' THEN '��ȿ' " ;
strQuery = strQuery + "              WHEN 'R' THEN '���' " ;
strQuery = strQuery + "              WHEN 'S' THEN 'ȿ������' " ;
strQuery = strQuery + "              ELSE '��ȿ' " ;
strQuery = strQuery + "          END " ;
strQuery = strQuery + "        ) AS STATUSNM " ;
strQuery = strQuery + "   ,  ( " ;
strQuery = strQuery + "        CASE A.LASTSTATUS " ;
strQuery = strQuery + "            WHEN '10' THEN '�߱�' " ;
strQuery = strQuery + "            WHEN '15' THEN '��߱�' " ;
strQuery = strQuery + "            WHEN '20' THEN '����' " ;
strQuery = strQuery + "            WHEN '30' THEN '���' " ;
strQuery = strQuery + "            WHEN '40' THEN 'ȿ������' " ;
strQuery = strQuery + "            WHEN '41' THEN 'ȿ��ȸ��' " ;
strQuery = strQuery + "            WHEN '45' THEN 'ȯ�����' " ;
strQuery = strQuery + "            ELSE '�߱�' " ;
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
    totalRecord = rsu.getInt(1); //�� ī��Ʈ��
%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>������ �߱� ����</title>


 <%

response.setHeader("Content-Type", "application/vnd.ms-excel;charset=euc-kr");
response.setHeader("Content-Description", "stype=mso-number-format:'\\@'");  
response.setHeader("Content-Disposition", "attachment; filename=CertificateList_"+CurYYYMMDDHHMMSS+".xls");  
response.setHeader("Content-Description", "Certificates List");  

%>
<style type="text/css">
.default {
	font-size: 8pt;
	font-family:"���� ���", Dotum, Gulim, Verdana, AppleGothic, sans-serif;

}

.wTable {
	border-top : solid 1px #c5c5c5;
	border-left : solid 1px #c5c5c5;
}
.wTableTdHeader {
	font-size: 8pt;
	font-family:"���� ���", Dotum, Gulim, Verdana, AppleGothic, sans-serif;
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	text-align : center;
	font-weight : bold;
	background-color : #eeeeee ;
	padding : 4px;
}
.wTableTdCell {
	font-size: 8pt;
	font-family:"���� ���", Dotum, Gulim, Verdana, AppleGothic, sans-serif;
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
			<td colspan="11" class="default"><%=fileName%> (<%=CurTime%> ����)</td>
		</tr>
	</table>
	<table cellSpacing="0" cellPadding="0" style="width:2000px;" border="0">
		<tr>
			<td colspan="11" class="default" style="text-align:right;">
				�� <span style="font-weight:bold;color:#ff0033;"><%=totalRecord%></span>���� ������ �߱޳����� �����մϴ�.
			</td>
		</tr>
	</table>
	<table cellSpacing="0" cellPadding="0" style="width:2000px;" border="0" class="wTable">
		<tr>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="4">����� ����</td>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="7">������ ����</td>
		</tr>
		<tr>
			<td class="wTableTdHeader" style="width:45px;">����</td>
			<td class="wTableTdHeader" style="width:55px;">����</td>
			<td class="wTableTdHeader" style="width:50px;">���</td>
			<td class="wTableTdHeader" style="width:80px;">����IP</td>
			<td class="wTableTdHeader" style="width:80px;">������<br>�ø���</td>
			<td class="wTableTdHeader" style="width:120px;">�������߱���</td>
			<td class="wTableTdHeader" style="width:400px;">������ ��ȿ�Ⱓ ������ ~ ������</td>
			<td class="wTableTdHeader" style="width:1025px;">������ Subject DN��</td>
			<td class="wTableTdHeader" style="width:65px;">��밡��<br />�����ϼ�</td>
			<td class="wTableTdHeader" style="width:40px;">������<br>����</td>
			<td class="wTableTdHeader" style="width:40px;">������<br>����<br>����</td>
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
				<%=getDateDiff(convertedToday, rsu.getString("EXPIRE_DATE"))%>/<%=getDateDiff(rsu.getString("ISSUE_DATE"), rsu.getString("EXPIRE_DATE"))%>��
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