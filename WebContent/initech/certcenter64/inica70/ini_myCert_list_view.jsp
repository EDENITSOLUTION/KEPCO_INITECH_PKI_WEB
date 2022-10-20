<%@ page language="java" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.io.*, java.util.*, java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="java.security.cert.CertificateFactory" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="com.initech.util.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>

<%

String myLogin = (String)session.getAttribute("myLogin");
if (myLogin == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('로그인 정보가 존재하지 않습니다.');");
	writer.println("history.back(-1);");
	writer.println("</script>");
	writer.flush();
	return;
}

String userId = myLogin;

	//인증서 serial번호로 인증서 상태 검증
	Context ict = new InitialContext();
	DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
	ResultSet rs = null;

	Connection conn = null;
	Statement stmt = null;

	//String userId = "";

		try
		{



			conn = ds.getConnection();
			stmt = conn.createStatement();


			String strQuery = "" ;

			strQuery = "" ;
			strQuery = strQuery + "SELECT " ;
			strQuery = strQuery + "        A.SERIAL " ;
			strQuery = strQuery + "    ,   A.USERID " ;
			strQuery = strQuery + "    ,   B.NAME " ;
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
			strQuery = strQuery + "            WHEN '30' THEN '발급' " ;
			strQuery = strQuery + "            WHEN '40' THEN '효력정지' " ;
			strQuery = strQuery + "            WHEN '41' THEN '효력회복' " ;
			strQuery = strQuery + "            WHEN '45' THEN '환불폐기' " ;
			strQuery = strQuery + "            ELSE '발급' " ;
			strQuery = strQuery + "        END " ;
			strQuery = strQuery + "        ) AS LASTSTATUSNM " ;
			strQuery = strQuery + "    ,   A.LASTSTATUS " ;
			strQuery = strQuery + "    ,   A.ISSUE_DATE" ;
			strQuery = strQuery + "    ,   A.EXPIRE_DATE " ;
			strQuery = strQuery + "    ,   A.EVENT_DATE " ;
			strQuery = strQuery + " FROM CERTS A, V_INSA B " ;
			strQuery = strQuery + " WHERE A.USERID = B.EMPNO AND A.USERID = '" + userId + "'"  ;	
			strQuery = strQuery + " ORDER BY A.ISSUE_DATE DESC " ;	
			rs = stmt.executeQuery(strQuery);
%>
<style>
.wTable {
	width:950px;
	border-top : solid 1px #c5c5c5;
	border-left : solid 1px #c5c5c5;
	margin:5px auto 0 auto;
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
	font-size:13px;
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
.tac {text-align:center;}
</style>
<!--<a href="ini_myCert_logout.jsp" style="display:table; padding:7px 10px; background:#ccc; color:#fff; margin:0 auto; text-decoration:none; border:1px solid #999; ">로그아웃</a>-->
<h2 class="tac">인증서 이력조회</h2>
<p style="font-size:14px;">-인증서 발급이력</p>

<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="wTable">
	<tr>
		<th class="wTableTdHeader" scope="col">순번</th>
		<th class="wTableTdHeader" scope="col">성명</th>
		<th class="wTableTdHeader" scope="col"">사번</th>
		<th class="wTableTdHeader" scope="col"">접속IP</th>
		<th class="wTableTdHeader" scope="col"">날짜</th>
		<!--<th class="wTableTdHeader" scope="col">유효기간</th>-->
		<!--<th class="wTableTdHeader" scope="col">폐기/효력정지일</th>-->
		<th class="wTableTdHeader" scope="col">상태</th>
	</tr>
<%

	int i = 1;
	while (rs.next()) {
%>

	<tr>
		<td class="wTableTdCell tac"><%=i%></td>
		<td class="wTableTdCell tac"><%=rs.getString("NAME")%></td>
		<td class="wTableTdCell tac"><%=rs.getString("USERID")%></td>
		<td class="wTableTdCell tac"><%=rs.getString("USERIP")%></td>
		<td class="wTableTdCell tac"><%=rs.getString("ISSUE_DATE")%></td>
		<!--<td class="wTableTdCell tac"><%=rs.getString("ISSUE_DATE").substring(0,10)%> ~ <%=rs.getString("EXPIRE_DATE").substring(0,10)%></td>-->
		<!--<td class="wTableTdCell tac">
			<%if (!"I".equals(rs.getString("STATUS"))) { %>
			<%=rs.getString("EVENT_DATE")%>
			<% } else {%>
				정보없음
			<%}%>
		</td>-->
		
		<td class="wTableTdCell tac"><%=rs.getString("LASTSTATUSNM")%></td>
	</tr>


<%
		i++;
	}

%>
</table>

<%
		}
		catch (Exception eee)
		{
			return;
		}
		finally 
		{
			rs.close();
			conn.close();
		}
	
%>