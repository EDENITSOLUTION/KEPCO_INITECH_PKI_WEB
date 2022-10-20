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

// ����¡
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
//     ������ ���� ���� Start
//************************************************
//1. �� �������� ���� ���ڵ� ���� �����ϰ�, �� ������ ���� ���Ѵ�.

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


</script>
</head>
<body>

<form name="sendForm" method="post" action="ini_manage_cert2.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form action="ini_manage_cert2.jsp" name="readForm" method="post">
<input type="hidden" name="pageIndex" value="1" />
		
	<select name="gubun" id="gubun">
		<option value="">��ü</option>
		<option value="S"<%if (gubun.equals("S")) {%> selected<%}%>>����</option>
		<option value="E"<%if (gubun.equals("E")) {%> selected<%}%>>����</option>
		<option value="H"<%if (gubun.equals("H")) {%> selected<%}%>>���¾�ü</option>
	</select>
	<select name="status" id="status">
		<option value="T"<%if (status.equals("T")) {%> selected<%}%>>����������(��ü)</option>
		<option value="I"<%if (status.equals("I")) {%> selected<%}%>>��ȿ</option>
		<option value="R"<%if (status.equals("R")) {%> selected<%}%>>���</option>
	</select>	
	<select name="searchKeyfield" id="searchKeyfield">
		<option value="C.USERID"<%if (searchKeyfield.equals("C.USERID")) {%> selected<%}%>>���̵�</option>
		<option value="C.USERNAME"<%if (searchKeyfield.equals("C.USERNAME")) {%> selected<%}%>>�̸�</option>
	</select>
	<input type="text" name="searchKeyword" id="searchKeyword" value="<%=searchKeyword%>" />
	<button type="submit">�˻�</button>
</form>

��ü : <%=total%>��
<table>
	<tr>
		<th scope="col">NO</th>
		<th scope="col">�̸�</th>
		<th scope="col">���</th>
		<th scope="col">�μ�</th>
		<th scope="col">�߱���</th>
		<th scope="col">������</th>
		<th scope="col">����</th>
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
			<td><a href="ini_manage_cert2_pwform.jsp?userId=<%=rs.getString("USERID")%>">��й�ȣ�ʱ�ȭ</a></td>
		</tr>
<%
	no--;
}
%>
<% if (total < 1) { %>
		<tr>
			<td colspan="7">�����Ͱ� �����ϴ�.</td>
		</tr>
<% } %>
</table>


<% if (pageIndex > BLOCK) { %>
<a href="?pageIndex=1&<%=queryString%>">ó��</a>
<a href="?pageIndex=<%=(startPage-1)%>&<%=queryString%>">����</a>
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
<a href="?pageIndex=<%=(endPage+1)%>&<%=queryString%>">����</a>
<a href="?pageIndex=<%=totalPage%>&<%=queryString%>">������</a>
<% } %>


<%
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}
%>