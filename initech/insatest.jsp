<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%
Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

try{
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();
	rs = stmt.executeQuery("SELECT EMPNO, DEPTNO, MAILNO, NAME, LEVELNM FROM V_INSA");
		
%>
<html>
<head>
<title>certificate</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript">
	function new_window(url)
	{
		//new_win= window.open(url,'new_win','status=yes,scrollbars=no,resizble=no,width=500,height=550');
		window.location = url;
	}
	</script>
<style type="text/css">
<!--
.text {  font-family: "����"; font-size: 11px; text-decoration: none; line-height: 15px}
-->
</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<center>
<h3 align="center">�λ������׽�Ʈ</h3>
<table border = "1" align="center">

<tr bgcolor = "C2C0C1"> 
	<td>���</td>
	<td>�μ��ڵ�</td>
	<td>�����ּ�</td>
	<td>�̸�</td>
	<td>����</td>
</tr>
<%
	while (rs.next()){
%>
<tr>
	<td><%=rs.getString("EMPNO")%></td>
	<td><%=rs.getString("DEPTNO")%></td>
	<td><%=rs.getString("MAILNO")%></td>
	<td><%=rs.getString("NAME")%></td>
	<td><%=rs.getString("LEVELNM")%></td>
</tr>
<%
	}
	rs.close();
%>

</table>
<%
			

	}
	catch(Exception ex){
		ex.printStackTrace();
} finally {
	stmt.close();
	conn.close();
}
%>
</body>
</html>


