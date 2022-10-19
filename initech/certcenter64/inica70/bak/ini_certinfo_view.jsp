<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<HEAD>
<TITLE>���� �߱� ����</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
</HEAD>
<BODY>
<%
Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/INIRA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

int i = 0;

try {

	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();

	String sql = "SELECT ltrim(serial,'0') as serial, policy, timeid, subject_dn, cid, racode, status, to_char(issue_date,'yyyymmdd'), to_char(expire_date,'yyyymmdd') FROM CERT_INFO order by issue_date, to_number(serial) desc";

	rs = stmt.executeQuery(sql);
%>
<h3 align="center">���� ������ �߱� ����</h3>
<table border = "1" align="center">

<tr bgcolor = "C2C0C1"> 
	<td>�ø����ȣ</td>
	<td>������å�ڵ�</td>
	<td>������ID</td>
	<td>������DN</td>
	<td>��ϴ������ڵ�</td>
	<td>����������</td>
	<td>�߱�����</td>
	<td>��������</td>
</tr>
<%
	while (rs.next()){
%>
<tr>
	<td><%=rs.getString(1)%></td>
	<td><%=rs.getString(2)%></td>
	<td><%=rs.getString(3)%></td>
	<td><%=rs.getString(4)%></td>
	<td><%=rs.getString(6)%></td>
	<td>��ȿ</td>
	<td><%=rs.getString(8)%></td>
	<td><%=rs.getString(9)%></td>
</tr>
<%
	}
%>

</table>
<%
}
catch (Exception e){
	e.printStackTrace();
%>
<h4>������ �߻��Ͽ����ϴ�.</h4>
<%
}finally {
		rs.close();
		
		conn.close();
	}
%>
</BODY>
</HTML>
