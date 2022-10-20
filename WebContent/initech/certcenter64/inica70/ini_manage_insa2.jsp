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
//      관리자 세션 체크
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
String admin2Login = (String)session.getAttribute("admin2Login");
if (adminLogin == null && admin2Login == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('관리자 로그인 정보가 존재하지 않습니다.');");
	writer.println("location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}

String db_url = "jdbc:oracle:thin:10.180.2.52:1521:ORA11G";

Connection a =  null;
try{
Class.forName("oracle.jdbc.driver.OracleDriver");
a = DriverManager.getConnection(db_url, "iris", "iris");
} catch (Exception e) {
out.print(e.getMessage());
}
	Context ict = new InitialContext();
	DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INSA");
	ResultSet rs = null;

	Connection conn = null;
	Statement stmt = null;

	try {
		conn = ds.getConnection();
		stmt = conn.createStatement();

		String strQuery = "" ;
		/*
		strQuery = "";
		strQuery = strQuery + "				SELECT  A.EMPNO" ;
		strQuery = strQuery + "					 ,  A.NAME" ;
		strQuery = strQuery + "					 ,  A.PASSWD" ;
		strQuery = strQuery + "				  FROM  insa_tbl" ;
		strQuery = strQuery + "				 WHERE  1=1" ;
		strQuery = strQuery + "				   AND  A.EMPNO = 'ec180024'" ;

		rs = stmt.executeQuery(strQuery);
		if (!rs.isBeforeFirst()) {
			out.print("a");
			return;			
		}		

		
		rs.next();

		out.print(rs.getString("NAME"));
		*/

		strQuery = "select * from all_tables where owner='IRIS'";
		rs = stmt.executeQuery(strQuery);
		out.print(rs);
		while (rs.next()) {	
			out.print("a");
			out.print(rs.getString("TABLE_NAME") + "<br>");
		}

	} catch(Exception e) {
		out.print(e.getMessage());
		e.printStackTrace();
	} finally {
		//rs.close();
		conn.close();
	}

%>11