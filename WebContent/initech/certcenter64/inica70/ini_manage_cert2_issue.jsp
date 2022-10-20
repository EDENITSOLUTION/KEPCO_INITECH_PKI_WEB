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
String userId = request.getParameter("userId");

Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

try {
	conn = ds.getConnection();
	stmt = conn.createStatement();


	String strQuery = "" ;
	strQuery = strQuery + "SELECT " ;
	strQuery = strQuery + "        A.SERIAL " ;
	strQuery = strQuery + "    ,   A.USERID " ;
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
	strQuery = strQuery + "    ,   A.ISSUE_DATE" ;
	strQuery = strQuery + "    ,   A.EXPIRE_DATE " ;
	strQuery = strQuery + " FROM CERTS A " ;
	strQuery = strQuery + " WHERE A.USERID = '" + userId + "'"  ;	
	strQuery = strQuery + " ORDER BY A.ISSUE_DATE DESC " ;	
	rs = stmt.executeQuery(strQuery);
%>


<table>
	<tr>
		<th scope="col">NO</th>
		<th scope="col">날짜</th>
		<th scope="col">상태</th>
		<th scope="col">발급방법</th>
		<th scope="col">발급IP</th>
	</tr>
<%

	int i = 1;
	while (rs.next()) {
%>

	<tr>
		<td><%=i%></td>
		<td><%=rs.getString("ISSUE_DATE")%></td>
		<td><%=rs.getString("LASTSTATUSNM")%></td>
		<td>사용자(WEB)</td>
		<td><%=rs.getString("USERIP")%></td>
	</tr>


<%
		i++;
	}

%>
</table>

<%
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}
%>