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

//////////////////////////////////////////////////////////////////////////////////////////////

String searchKeyfield = request.getParameter("searchKeyfield");
String searchKeyword = request.getParameter("searchKeyword");

if (searchKeyfield == null || searchKeyfield.equals("")) {
	searchKeyfield = "C.EMPNO";
}

if (searchKeyword == null || searchKeyword.equals("")) {
	searchKeyword = "";
}

String queryString = "searchKeyfield="+searchKeyfield+"&searchKeyword="+searchKeyword;

//////////////////////////////////////////////////////////////////////////////////////////////

Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

try
{
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String q = "";

	q =  "";
	q += "		SELECT  COUNT(*) " ;
	q += "		 FROM  ( " ;
	q += "				SELECT  A.EMPNO";
	q += "					 ,  A.NAME";
	q += "				  FROM  V_INSA A";
	//q += "			 LEFT JOIN  MNG_USER B ON (A.EMPNO = B.USERID AND B.GUBUN = 'E')";
	//q += "				 WHERE  B.USERID IS NULL";
	q += "			   )  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		q += " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
	}
	//out.print(q);
	rs = stmt.executeQuery(q);
	rs.next();
    total = rs.getInt(1);
	
	totalPage = (int)Math.ceil(total / ROWSIZE);
	if (endPage > totalPage) {
		endPage = totalPage;
	}

	q =  "";
	q += "SELECT X.* FROM (" ;
	q += "		SELECT  C.EMPNO " ;
	q += "			 ,  C.NAME " ;
	q += "			 ,  C.LEVELNM " ;
	q += "			 ,  C.CELLNO " ;
	q += "			 ,  ROWNUM R " ;
	q += "			 ,  RANK() OVER (ORDER BY C.NAME ASC) AS RANKING " ;
	q += "		 FROM  ( " ;
	q += "				SELECT  A.EMPNO";
	q += "					 ,  A.NAME";
	q += "					 ,  A.LEVELNM";
	q += "					 ,  A.CELLNO";
	q += "				  FROM  V_INSA A";
	//q += "			 LEFT JOIN  MNG_USER B ON (A.EMPNO = B.USERID AND B.GUBUN = 'E')";
	//q += "				 WHERE  B.USERID IS NULL";
	q += "			   )  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		q += " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
	}
	q += "  ORDER BY  C.NAME ASC " ; 
	q += ") X " ; 
	q += "WHERE X.RANKING BETWEEN "+ (start-1) +" and "+ end ; 
	//out.print(q);
	rs = stmt.executeQuery(q);
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
<script type="text/javascript">
function SelectItem(empNo, name, levelNm, cellNo) {

	var a = {
		'empNo':empNo,
		'name':name,
		'levelNm':levelNm,
		'cellNo':cellNo
	}
	window.opener.SearchComplete(a);
	self.close();
}
</script>
<style type="text/css">
.wTable {
	width:100%;
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
</style>

<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head>
<body>

<form name="sendForm" method="post" action="ini_manage_user_search.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form action="ini_manage_user_search.jsp" name="readForm" method="post">
<input type="hidden" name="pageIndex" value="1" />
	<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable" style="border-bottom:1px solid #c5c5c5; margin-bottom:10px;">
	<tr>	
		<td class="wTableTdSearch1">
			<select name="searchKeyfield" id="searchKeyfield">
				<option value="C.EMPNO"<%if (searchKeyfield.equals("C.EMPNO")) {%> selected<%}%>>���̵�</option>
				<option value="C.NAME"<%if (searchKeyfield.equals("C.NAME")) {%> selected<%}%>>�̸�</option>
			</select>
			<input type="text" style="border:1px solid #dedede; width:150px;" name="searchKeyword" id="searchKeyword" value="<%=searchKeyword%>" />
			<button type="submit">�˻�</button>
		</td>
	</tr>
	
	</table>
</form>

��ü : <%=total%>��
<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable" style="border-bottom:1px solid #c5c5c5; " >
	<tr>
		<td class="wTableTdHeader" scope="col">NO</td>
		<td class="wTableTdHeader" scope="col">�̸�</td>
		<td class="wTableTdHeader" scope="col">���</td>
		<td class="wTableTdHeader" scope="col">����</td>
		<td class="wTableTdHeader" scope="col">����</td>
	</tr>
<%
int no = (total - (ROWSIZE * (pageIndex-1)));
while (rs.next()) {		
%>

		<tr>
			<td class="wTableTdCell" style="text-align:center"><%=no%></td>
			<td class="wTableTdCell" style="text-align:center"><%=rs.getString("NAME")%></td>
			<td class="wTableTdCell" style="text-align:center"><%=rs.getString("EMPNO")%></td>
			<td class="wTableTdCell" style="text-align:center"><%=(rs.getString("LEVELNM") != null ? rs.getString("LEVELNM") : "")%></td>
			<td class="wTableTdCell" style="text-align:center"><button type="button" onclick="SelectItem('<%=rs.getString("EMPNO")%>', '<%=rs.getString("NAME")%>', '<%=(rs.getString("LEVELNM") != null ? rs.getString("LEVELNM") : "")%>', '<%=(rs.getString("CELLNO") != null ? rs.getString("CELLNO") : "")%>')">����</button></td>
		</tr>
<%
	no--;
}
%>
<% if (total < 1) { %>
		<tr>
			<td colspan="3">�����Ͱ� �����ϴ�.</td>
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
} 
catch(Exception e) 
{
	e.printStackTrace();
} 
finally 
{
	//rs.close();
	conn.close();
}
%>