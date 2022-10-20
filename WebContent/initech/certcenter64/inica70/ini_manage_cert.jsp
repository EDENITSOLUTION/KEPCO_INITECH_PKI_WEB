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
//      ������ ���� üũ
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
if (adminLogin == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('������ �α��� ������ �������� �ʽ��ϴ�.');");
	writer.println("location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}


//************************************************
//      ���� ���� �� �Է����� ��ȣȭ
//************************************************
	
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");


//��ȣȭ���� : ��������� �ݵ��true�� �����ؾ���..
//boolean m_bEncrypt = true;


//************************************************
//     ������ ���� ���� Start
//************************************************
//1. �� �������� ���� ���ڵ� ���� �����ϰ�, �� ������ ���� ���Ѵ�.

String strNumPerPage = request.getParameter("strNumPerPage") ;
if (strNumPerPage == null || strNumPerPage.equals("")){
	strNumPerPage = "20" ;
}


int numPerPage = Integer.parseInt(strNumPerPage); // �� �������� ���� ���ڵ� �� ����
int totalRecord = 0; //�� ������ ������ ������ ����
int totalPage = 0;  //�� ���������� ������ ����


//2. ù��° ���ڵ� ��ȣ�� ������ ���ڵ� ��ȣ�� ���ϰ� ����Ѵ�.
int curPage = (request.getParameter("curPage") == null) ? 1 :
Integer.parseInt(request.getParameter("curPage"));
// ���� ���ڵ� ��� .....
int start = ( curPage - 1 ) * numPerPage + 1;
// ������ ���ڵ� ��� .....
int end = start + numPerPage - 1;

int block = 10;
int startPage = ((curPage - 1) / block * block) + 1;
int endPage = ((curPage - 1) / block * block) + block;


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
if (m_searchGb.equals("T")) { //����
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("Y")) { //����
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate-1,'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("TM")) { //�̹���	
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate,'YYYY-MM') || '-01' And    to_char("+ baseDatCol +",'YYYY-MM-DD')";
}
else if (m_searchGb.equals("M1")) { //1����
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-30,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("M3")) { //3����
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char(sysdate-90,'YYYY-MM-DD') And    to_char("+ baseDatCol +",'YYYY-MM-DD') ";
}
else if (m_searchGb.equals("B")) { //�Ⱓ��
	baseCondQuery = " AND  to_char("+ baseDatCol +",'YYYY-MM-DD') between to_char('"+ f_yyyy +"-"+f_mm+"-"+f_dd +"') And    to_char('"+ t_yyyy +"-"+t_mm+"-"+t_dd +"') ";
}
else{
	baseCondQuery = " AND to_char("+ baseDatCol +",'YYYY-MM-DD') = to_char(sysdate,'YYYY-MM-DD') ";
}
//��ȿ(I) / ���(R)
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
strQuery = strQuery + ") X " ; 
//strQuery = strQuery + " WHERE X.R BETWEEN "+ start +" and "+ end ; 
strQuery = strQuery + " WHERE X.RANKING BETWEEN "+ start +" and "+ end ; 


try {
	connu = dsu.getConnection();
	//Creat Query and get results
	stmtu = connu.createStatement();

	rsu = stmtu.executeQuery(strTotQuerey);
	rsu.next();
    totalRecord = rsu.getInt(1); //�� ī��Ʈ��
	

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
<title>�������� �̿�ȳ�</title>
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
	var msg = "��ȸ Ȯ�� �� �Դϴ�. ��ø� ��ٸ��ʽÿ�.";
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
		<li class="toptxtcon">�������� ������</li>
		<li class="toptxtcon01" style="text-decoration:underline;width:150px;text-align:left; font-weight:bold; color:#000;"><a href="ini_manage_cert.jsp">������ �߱� ���� ��ȸ</a></li>
		<li class="toptxtcon01"><a href="ini_manage_config.jsp">ȯ�漳��</a></li>
		<li class="toptxtcon01"><a href="ini_manage_insa.jsp">�λ��������</a></li>
		<li class="toptxtcon01"><a href="ini_manage_user.jsp">������������</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">�α׾ƿ�</a></li>
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
				<input type="radio" name="searchGb" value="T" <%if (m_searchGb.equals("T")){%>checked="checked"<%}%> onclick="CheckSendForm();">���� �߱޳���
				<input type="radio" name="searchGb" value="Y" <%if (m_searchGb.equals("Y")){%>checked="checked"<%}%> onclick="CheckSendForm();">���� �߱޳���
				<input type="radio" name="searchGb" value="TM" <%if (m_searchGb.equals("TM")){%>checked="checked"<%}%> onclick="CheckSendForm();">�̹��� �߱޳��� 
				<input type="radio" name="searchGb" value="M1" <%if (m_searchGb.equals("M1")){%>checked="checked"<%}%> onclick="CheckSendForm();">1�������� �߱޳��� 
				<input type="radio" name="searchGb" value="M3" <%if (m_searchGb.equals("M3")){%>checked="checked"<%}%> onclick="CheckSendForm();">3�������� �߱� ���� 
			</td>
			<td class="wTableTdSearch1" style="width:130px;text-align:center;border-bottom : solid 1px #c5c5c5;" rowspan="3">
				<img src="./img/exceldown.gif" border="0" style="cursor:pointer;" onclick="excelDown();" />
			</td>
		</tr>
		<tr>
			<td class="wTableTdSearch1" style="border-right : solid 1px #ffffff;">
				<input type="radio" name="searchGb" value="B" <%if (m_searchGb.equals("B")){%>checked="checked"<%}%> onclick="CheckSendForm();">�Ⱓ�� ��ȸ
				<select name="f_yyyy" id="f_yyyy"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
					<option value="2014"<%if (f_yyyy.equals("2014")) {%> selected<%}%>>2014��</option>
					<option value="2015"<%if (f_yyyy.equals("2015")) {%> selected<%}%>>2015��</option>
					<option value="2016"<%if (f_yyyy.equals("2016")) {%> selected<%}%>>2016��</option>
					<option value="2017"<%if (f_yyyy.equals("2017")) {%> selected<%}%>>2017��</option>
					<option value="2018"<%if (f_yyyy.equals("2018")) {%> selected<%}%>>2018��</option>
					<option value="2019"<%if (f_yyyy.equals("2019")) {%> selected<%}%>>2019��</option>
					<option value="2020"<%if (f_yyyy.equals("2020")) {%> selected<%}%>>2020��</option>
                                        <option value="2021"<%if (f_yyyy.equals("2021")) {%> selected<%}%>>2021��
</option>
                                        <option value="2022"<%if (f_yyyy.equals("2022")) {%> selected<%}%>>2022��
</option>
                                        <option value="2023"<%if (f_yyyy.equals("2023")) {%> selected<%}%>>2023��
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
					<option value="<%=fMM%>" <%if (fMM.equals(f_mm)) {%> selected<%}%>><%=fMM%>��</option>
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
					<option value="<%=fDD%>"<%if (fDD.equals(f_dd)) {%> selected<%}%>><%=fDD%>��</option>
				<%
				}
				%>
				</select>
				~
				<select name="t_yyyy" id="t_yyyy"<%if (m_searchGb.equals("B")){%> <%}else{%> disabled<%}%>>
					<option value="2014"<%if (t_yyyy.equals("2014")) {%> selected<%}%>>2014��</option>
					<option value="2015"<%if (t_yyyy.equals("2015")) {%> selected<%}%>>2015��</option>
					<option value="2016"<%if (t_yyyy.equals("2016")) {%> selected<%}%>>2016��</option>
					<option value="2017"<%if (t_yyyy.equals("2017")) {%> selected<%}%>>2017��</option>
					<option value="2018"<%if (t_yyyy.equals("2018")) {%> selected<%}%>>2018��</option>
					<option value="2019"<%if (t_yyyy.equals("2019")) {%> selected<%}%>>2019��</option>
					<option value="2020"<%if (t_yyyy.equals("2020")) {%> selected<%}%>>2020��</option>
                                        <option value="2021"<%if (f_yyyy.equals("2021")) {%> selected<%}%>>2021��
</option>
                                        <option value="2022"<%if (f_yyyy.equals("2022")) {%> selected<%}%>>2022��
</option>
                                        <option value="2023"<%if (f_yyyy.equals("2023")) {%> selected<%}%>>2023��
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
					<option value="<%=tMM%>" <%if (tMM.equals(t_mm)) {%> selected<%}%>><%=tMM%>��</option>
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
					<option value="<%=tDD%>"<%if (tDD.equals(t_dd)) {%> selected<%}%>><%=tDD%>��</option>
				<%
				}
				%>
				</select>
		
			</td>
		</tr>
		<tr>
			<td class="wTableTdSearch" style="border-right : solid 1px #ffffff;">
				<select name="STATUS" id="STATUS" onchange="CheckSendForm();">
					<option value="T"<%if (STATUS.equals("T")) {%> selected<%}%>>����������(��ü)</option>
					<option value="I"<%if (STATUS.equals("I")) {%> selected<%}%>>��ȿ</option>
					<option value="R"<%if (STATUS.equals("R")) {%> selected<%}%>>���</option>
				</select>
				<select name="gb" id="gb">
					<option value="C.USERNAME"<%if (gb.equals("C.USERNAME")) {%> selected<%}%>>����� ����</option>
					<option value="C.USERID"<%if (gb.equals("C.USERID")) {%> selected<%}%>>����� ���</option>
					<option value="C.USERIP"<%if (gb.equals("C.USERIP")) {%> selected<%}%>>����� IP</option>
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
				�� <span style="font-weight:bold;color:#ff0033;"><%=totalRecord%></span>���� ������ �߱޳����� �����մϴ�.
			</td>
			<td style="text-align:right; padding-right:10px; padding-bottom:5px;">
				�� ������ ��� ��
				<select name="strNumPerPage" id="strNumPerPage" onchange="CheckSendForm();">
					<option value="5"<%if (strNumPerPage.equals("5")) {%> selected<%}%>>5�Ǿ� ����</option>
					<option value="10"<%if (strNumPerPage.equals("10")) {%> selected<%}%>>10�Ǿ� ����</option>
					<option value="15"<%if (strNumPerPage.equals("15")) {%> selected<%}%>>15�Ǿ� ����</option>
					<option value="20"<%if (strNumPerPage.equals("20")) {%> selected<%}%>>20�Ǿ� ����</option>
					<option value="30"<%if (strNumPerPage.equals("30")) {%> selected<%}%>>30�Ǿ� ����</option>
					<option value="50"<%if (strNumPerPage.equals("50")) {%> selected<%}%>>50�Ǿ� ����</option>
					<option value="100"<%if (strNumPerPage.equals("100")) {%> selected<%}%>>100�Ǿ� ����</option>
					<option value="<%=totalRecord%>"<%if (strNumPerPage.equals(Integer.toString(totalRecord))) {%> selected<%}%>>��ü����</option>
				</select>
			</td>
		</tr>
	</table>
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
		<tr>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="4">����� ����</td>
			<td class="wTableTdHeader" style="background-color:#d9d9d9" colspan="6">������ ����</td>
		</tr>
		<tr>
			<td class="wTableTdHeader" style="width:45px;" rowspan="2">����</td>
			<td class="wTableTdHeader" style="width:55px;" rowspan="2">����</td>
			<td class="wTableTdHeader" style="width:50px;" rowspan="2">���</td>
			<td class="wTableTdHeader" style="width:80px;" rowspan="2">����IP</td>
			<td class="wTableTdHeader" style="width:80px;" rowspan="2">������<br>�ø���</td>
			<td class="wTableTdHeader" style="width:120px;">�������߱���</td>
			<td class="wTableTdHeader">������ ��ȿ�Ⱓ ������ ~ ������</td>
			<td class="wTableTdHeader" style="width:65px;" rowspan="2">��밡��<br />�����ϼ�</td>
			<td class="wTableTdHeader" style="width:40px;" rowspan="2">������<br>����</td>
			<td class="wTableTdHeader" style="width:40px;" rowspan="2">������<br>����<br>����</td>
		</tr>
		<tr>
			<td class="wTableTdHeader" colspan="2">������ Subject DN��</td>
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
				<%=getDateDiff(convertedToday, rsu.getString("EXPIRE_DATE"))%>/<%=getDateDiff(rsu.getString("ISSUE_DATE"), rsu.getString("EXPIRE_DATE"))%>��
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

// 3. �� �������� ���� ���� �̵� ��ũ�� �����.
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
<li><a href="javascript:fncPaging(1);">ó��</a></li>
<li><a href="javascript:fncPaging(<%=(startPage-1)%>);">����</a></li>
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
<li><a href="javascript:fncPaging(<%=(endPage+1)%>);">����</a></li>
<li><a href="javascript:fncPaging(<%=totalPage%>);">������</a></li>
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
