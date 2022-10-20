<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<HEAD>
<TITLE>사용자등록내역</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
</HEAD>
<BODY>
<%
Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;
	try {

		conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();

	String sql = "select userid, ltrim(serial,'0'), dn, to_char(issuedate,'yyyymmdd'), status from ldap_info order by issuedate, to_number(serial) desc";

	rs = stmt.executeQuery(sql);


		
%>
<h3 align="center">금일 사용자등록 내역</h3>
<table border = "1" align="center">

<tr bgcolor = "C2C0C1"> 
	<td>사용자id</td>
	<td>시리얼번호</td>
	<td>가입자DN</td>
	<td>등록일자</td>
	<td>상태</td>
</tr>
<%
	while (rs.next()){
%>
<tr>
	<td><%=rs.getString(1)%></td>
	<td><%=rs.getString(2)%></td>
	<td><%=rs.getString(3)%></td>
	<td><%=rs.getString(4)%></td>
	<td>유효</td>
</tr>
<%
	}
%>

</table>
<h4 align="center">사용자등록 내역이 정상적으로 출력되었습니다.</h4>
<%
	}catch (SQLException e){
%>
<h4>에러가 발생하였습니다.</h4>
<%
	}finally {
		rs.close();
		stmt.close();
		conn.close();
	}
%>
</BODY>
</HTML>
