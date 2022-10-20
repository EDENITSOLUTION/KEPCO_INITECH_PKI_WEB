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
<%!
 public byte[] getHashValue(String inputString) {
	MessageDigest md = null;
	try {
		md = MessageDigest.getInstance("MD5");
		md.update(inputString.getBytes());
	} catch (NoSuchAlgorithmException e) {
		e.printStackTrace();
	}
	
	return md.digest(); 
}

public String getBase64Data(byte[] inputByte) throws IOException {
	String returnString = "";
	returnString = new String(com.initech.util.Base64Util.encode(inputByte, false));
	return returnString;
}
%>
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

String empNo = m_IP.getParameter("empNo");
String param = m_IP.getParameter("param");
//String password = m_IP.getParameter("password");
String password = "kepco123456/";

Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

try {
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String q = "";

	q = "SELECT COUNT(*) AS cnt FROM V_INSA WHERE EMPNO='" + empNo + "' ";
	rs = stmt.executeQuery(q);
		
	int cnt = 0;
	while(rs.next()) {
		cnt =  rs.getInt("cnt");
	}

	if (cnt == 0) {
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('입력하신 사번("+ empNo +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("history.back(-1);");
		writer.println("</script>");
		writer.flush();
		return;
	}


	q = "";
	q = q + "				SELECT  A.EMPNO" ;
	q = q + "					 ,  A.NAME" ;
	q = q + "					 ,  A.DEPTNO" ;
	q = q + "					 ,  A.MAILNO" ;
	q = q + "					 ,  A.CELLNO" ;
	q = q + "					 ,  A.LEVELNM" ;
	q = q + "				  FROM  V_INSA A" ;
	q = q + "				 WHERE  A.EMPNO = '" + empNo + "'" ;

	rs = stmt.executeQuery(q);
	if (!rs.isBeforeFirst()) {
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('사번("+ empNo +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("history.back(-1);");
		writer.println("</script>");
		writer.flush();
		return;			
	} 

	rs.next();

	String name = rs.getString("NAME");


	q = "SELECT COUNT(*) AS cnt FROM USER_PWD WHERE USERID='" + empNo + "'";
	rs = stmt.executeQuery(q);

	int cnt2 = 0;
	while(rs.next()) {
		cnt2 =  rs.getInt("cnt");
	}

	if (cnt2 > 0) {
		q = "";
		q += "	UPDATE  USER_PWD";
		q += "	   SET  USERPWD = '"+getBase64Data(getHashValue(password))+"'";
		q += "		 ,  MDDATE = SYSDATE";
		q += "	 WHERE	USERID = '"+empNo+"'";
		rs = stmt.executeQuery(q);
	} else {
		q = "";
		q += "	INSERT INTO USER_PWD";
		q += "	   (USERID, USERPWD,CRDATE,USERNAME,USERIP) ";
		q += "		VALUES";
		q += "	 ('"+empNo+"', '"+getBase64Data(getHashValue(password))+"', SYSDATE, '"+name+"', '"+request.getRemoteAddr()+"')";
		rs = stmt.executeQuery(q);
	}

	/*
	String q1 = "	MERGE INTO USER_PWD_BAK S USING DUAL";
	q1 += "	ON (S.USERID = '"+empNo+"')";
	q1 += "	WHEN MATCHED THEN";
	q1 += "	   UPDATE SET USERPWD = '"+getBase64Data(getHashValue(password))+"',  MDDATE = SYSDATE";
	q1 += "	WHEN NOT MATCHED THEN";
	q1 += "		INSERT (USERID, USERPWD, CRDATE, USERNAME, USERIP) VALUES ('"+empNo+"', '"+getBase64Data(getHashValue(password))+"', SYSDATE, '"+name+"', '"+request.getRemoteAddr()+"');";

	out.print(q1);
	rs = stmt.executeQuery(q1);
		*/

	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('초기화 되었습니다.');");
	writer.println("location.href='ini_manage_insa.jsp?"+param+"'");
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