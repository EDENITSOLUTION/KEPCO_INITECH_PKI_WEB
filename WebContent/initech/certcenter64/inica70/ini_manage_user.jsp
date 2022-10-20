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
int totalPage = 1;
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
function DeleteSendForm() {

	if (!confirm('������ �����Ͻðڽ��ϱ�?'))
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
		alert('������ �ּ���');
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
		<li class="toptxtcon">�������� ������</li>
		<li class="toptxtcon01" style="width:150px;text-align:left;"><a href="ini_manage_cert.jsp">������ �߱� ���� ��ȸ</a></li>
		<li class="toptxtcon01"><a href="ini_manage_config.jsp">ȯ�漳��</a></li>
		<li class="toptxtcon01"><a href="ini_manage_insa.jsp">�λ��������</a></li>
		<li class="toptxtcon01" style="font-weight:bold; color:#000; text-decoration:underline;"><a href="ini_manage_user.jsp">������������</a></li>
		<li class="toptxtcon01"><a href="ini_manage_cert_logout.jsp">�α׾ƿ�</a></li>
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
				<option value="">��ü</option>
					<option value="C.USERID"<%if (searchKeyfield.equals("C.USERID")) {%> selected<%}%>>���̵�</option>
					<option value="C.NAME"<%if (searchKeyfield.equals("C.NAME")) {%> selected<%}%>>�̸�</option>
				</select>
				<input type="text" name="searchKeyword" id="searchKeyword" value="<%=searchKeyword%>" style="border:1px solid #dedede; width:150px;" />
				<button type="submit">�˻�</button>
			</td>
		</tr>
	</table>
</form>
<form name="deleteSubmit" method="post" action="ini_manage_user_delete.jsp">
<p style="width:950px; margin:0 auto">��ü : <%=total%>��</p>
<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
	<tr>
		<th class="wTableTdHeader"><input type="checkbox" onclick="set_checkbox(this.form, 'chk', this.checked)" /></th>
		<th class="wTableTdHeader" scope="col">NO</th>
		<th class="wTableTdHeader" scope="col">�̸�</th>
		<th class="wTableTdHeader" scope="col">���</th>
		<th class="wTableTdHeader" scope="col">����</th>
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
			<td class="wTableTdCell" style="text-align:center" colspan="4">�����Ͱ� �����ϴ�.</td>
		</tr>
<% } %>
</table>
<div style="width:950px; margin:0 auto; height:60px;">
<button type="button" onclick="check_action();" style="left; width:80px; border:1px solid #dedede; background:#3068b0;   text-align:center; color:#fff; padding: 10px 10px; ">���û���</button>
<a href="ini_manage_user_write.jsp" style="float:right; width:50px; border:1px solid #dedede; background:#3068b0;   text-align:center; color:#fff; padding: 10px 10px; ">���</a>
</div>


</form>


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

<script language="javascript">dspCopyRight();</script>
