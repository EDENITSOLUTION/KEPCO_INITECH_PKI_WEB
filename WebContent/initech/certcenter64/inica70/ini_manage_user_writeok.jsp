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
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/func.jsp" %>
<%
//************************************************
//      관리자 세션 체크
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
if (adminLogin == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('관리자 로그인 정보가 존재하지 않습니다.');");
	writer.println("location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}

String command = m_IP.getParameter("command");
String queryString = m_IP.getParameter("queryString");
String userId = m_IP.getParameter("userId");
String gubun = m_IP.getParameter("gubun");
String REPLACE_CELLNO = m_IP.getParameter("REPLACE_CELLNO");
if (REPLACE_CELLNO == null || "".equals(REPLACE_CELLNO)) {
	REPLACE_CELLNO = "";
}


Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

try {
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String q = "";

	if ("update".equals(command)) {

		q = "";
		q += "	UPDATE  MNG_USER";
		q += "	   SET  REPLACE_CELLNO = '"+REPLACE_CELLNO+"'";
		q += "	 WHERE	USERID = '"+userId+"'";
		rs = stmt.executeQuery(q);

		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('변경 되었습니다.');");
		writer.println("location.href='ini_manage_user_write.jsp?userId="+userId+"'");
		writer.println("</script>");
		writer.flush();

	} else {

		q = "";
		q += "				SELECT  A.USERID" ;
		q += "				  FROM  MNG_USER A" ;
		q += "				 WHERE  1=1" ;
		q += "				   AND  A.GUBUN = '"+gubun+"'" ;
		q += "				   AND  A.USERID = '"+userId+"'" ;

		rs = stmt.executeQuery(q);
		if (rs.isBeforeFirst()) {
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('해당 사번("+ userId +")은 이미 예외사용자로 등록되어 있습니다.');");
			writer.println("history.back(-1);");
		    writer.println("</script>");
			writer.flush();
			return;			
		} 
		rs.next();
		
		q = "";
		q += "	INSERT INTO MNG_USER";
		q += "		 (  USERID";
		q += "		 ,  GUBUN";
		q += "		 ,  REPLACE_CELLNO";
		q += "		 ) ";
		q += "VALUES (  '"+userId+"'";
		q += "		 ,  '"+gubun+"'";
		q += "		 ,  '"+REPLACE_CELLNO+"'";
		q += "		 )";
		rs = stmt.executeQuery(q);

		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('등록 되었습니다.');");
		writer.println("location.href='ini_manage_user.jsp'");
		writer.println("</script>");
		writer.flush();
	}
	
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}
%>