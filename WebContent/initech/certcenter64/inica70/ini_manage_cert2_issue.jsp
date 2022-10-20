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
		<th scope="col">��¥</th>
		<th scope="col">����</th>
		<th scope="col">�߱޹��</th>
		<th scope="col">�߱�IP</th>
	</tr>
<%

	int i = 1;
	while (rs.next()) {
%>

	<tr>
		<td><%=i%></td>
		<td><%=rs.getString("ISSUE_DATE")%></td>
		<td><%=rs.getString("LASTSTATUSNM")%></td>
		<td>�����(WEB)</td>
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