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
String policyDefault = m_IP.getParameter("policyDefault");
String policyExceptn1 = m_IP.getParameter("policyExceptn1");
//String policyExceptn2 = m_IP.getParameter("policyExceptn2");
String noticeGubun = m_IP.getParameter("noticeGubun");
String noticeDay = m_IP.getParameter("noticeDay");

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
		q += "	UPDATE  MNG_CONFIG";
		q += "	   SET  POLICY_DEFAULT = '"+policyDefault+"'";
		q += "		 ,  POLICY_EXCEPTN1 = '"+policyExceptn1+"'";
		//q += "		 ,  POLICY_EXCEPTN2 = '"+policyExceptn2+"'";
		q += "		 ,  NOTICE_GUBUN = '"+noticeGubun+"'";
		q += "		 ,  NOTICE_DAY = '"+noticeDay+"'";
	} else {
		q += "	INSERT";
		q += "	  INTO  MNG_CONFIG";
		q += "		 (  POLICY_DEFAULT";
		q += "		 ,  POLICY_EXCEPTN1";
		//q += "		 ,  POLICY_EXCEPTN2";
		q += "		 ,  NOTICE_GUBUN";
		q += "		 ,  NOTICE_DAY";
		q += "		 ) ";
		q += "		 VALUES";
		q += "		 (  '"+policyDefault+"'";
		q += "		 ,  '"+policyExceptn1+"'";
		//q += "		 ,  '"+policyExceptn2+"'";
		q += "		 ,  '"+noticeGubun+"'";
		q += "		 ,  '"+noticeDay+"'";
		q += "		 )";
	}
	
	rs = stmt.executeQuery(q);


	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('변경되었습니다.');");
	writer.println("location.href='ini_manage_config.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
		
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}
%>