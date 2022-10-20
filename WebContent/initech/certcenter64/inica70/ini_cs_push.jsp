<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.String.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ include file="import/iniplugin_init.jsp" %>
<%@ include file="import/fncPush.jsp" %>
<%@ include file="import/fncSMS2.jsp" %>
<%!
public String getDateTime() {
	Locale locale = java.util.Locale.KOREA;
	SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale);
	String convertedTime = sdfr.format(new java.util.Date());
	return convertedTime;

}
%>
<%
String timeId = getDateTime() ;


String empno = request.getParameter("id");
String refuserid = request.getParameter("id2");
if (refuserid == null || "".equals(refuserid)) {
	refuserid = empno;
}

Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
ResultSet rs = null;
Connection conn = null;
Statement stmt = null;

String isNoPhoneUser = "Y" ; //인사정보에 핸드폰이 잘못된 사용자 인지 체크

String isChk = "";
String cellNo = "";
String phoneNum = "";
String name = "";

String cellNo2 = "";
String phoneNum2 = "";
String name2 = "";
try{
	//사번이 인사정보에 존재하는지 체크
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();

	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ empno +"'");

	int cnt_user = 0;
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	
	if (cnt_user == 0){
		isChk = "N";
	} else { // 사용자 정보 존재할때				
		String cellQry = "" ;
		cellQry = cellQry + "SELECT "; 
		cellQry = cellQry + "		X.EMPNO ";
		cellQry = cellQry + "	,	X.USER_NAME ";
		cellQry = cellQry + "	,	X.MAILNO ";
		cellQry = cellQry + "   ,( ";
		cellQry = cellQry + "		CASE WHEN X.MAILNO IS NULL THEN 'x' ";
		cellQry = cellQry + "		ELSE ";
		cellQry = cellQry + "			CASE INSTR(X.MAILNO,'@',1)  ";
		cellQry = cellQry + "				WHEN 0 THEN X.MAILNO || '@kepco.co.kr' ";
		cellQry = cellQry + "		    ELSE X.MAILNO ";
		cellQry = cellQry + "			END ";
		cellQry = cellQry + "		END ";
		cellQry = cellQry + "    ) AS MAILADDR ";
		cellQry = cellQry + "	,   X.CELLNO ";
		cellQry = cellQry + "	,	X.VAL1 ";
		cellQry = cellQry + "	,	X.VAL2 ";
		cellQry = cellQry + "	,( ";
		cellQry = cellQry + "		CASE WHEN X.VAL1 = 'ok' THEN X.CELLNO ";
		cellQry = cellQry + "		ELSE ";
		cellQry = cellQry + "			CASE WHEN X.VAL2 = 'ok' THEN  ";
		cellQry = cellQry + "				CASE WHEN LENGTH(X.CELLNO) = 10 THEN ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,3) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,7,4) ";
		cellQry = cellQry + "				ELSE ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,4) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,8,4) ";
		cellQry = cellQry + "				END ";
		cellQry = cellQry + "			ELSE 'x' ";
		cellQry = cellQry + "			END ";
		cellQry = cellQry + "		END ";
		cellQry = cellQry + "	) AS PHONENUM ";
		cellQry = cellQry + " FROM ( ";
		cellQry = cellQry + "	SELECT ";
		cellQry = cellQry + "		EMPNO ";
		cellQry = cellQry + "		, MAILNO ";
		cellQry = cellQry + "		, NAME AS USER_NAME ";
		cellQry = cellQry + "		, CELLNO ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL1  ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL2 ";
		cellQry = cellQry + "	FROM  V_INSA ";
		cellQry = cellQry + "	WHERE EMPNO = '"+ empno +"' ";
		cellQry = cellQry + ") X ";
						
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
			name = rs.getString("USER_NAME");
			phoneNum = rs.getString("PHONENUM");
			cellNo = rs.getString("CELLNO");
		}

		cellNo = cellNo.replace("-","");	



	}

	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ refuserid +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isChk = "N" ;
	} else {
		String cellQry = "" ;
		cellQry = cellQry + "SELECT "; 
		cellQry = cellQry + "		X.EMPNO ";
		cellQry = cellQry + "	,	X.USER_NAME ";
		cellQry = cellQry + "	,   X.CELLNO ";
		cellQry = cellQry + "	,	X.VAL1 ";
		cellQry = cellQry + "	,	X.VAL2 ";
		cellQry = cellQry + "	,( ";
		cellQry = cellQry + "		CASE WHEN X.VAL1 = 'ok' THEN X.CELLNO ";
		cellQry = cellQry + "		ELSE ";
		cellQry = cellQry + "			CASE WHEN X.VAL2 = 'ok' THEN  ";
		cellQry = cellQry + "				CASE WHEN LENGTH(X.CELLNO) = 10 THEN ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,3) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,7,4) ";
		cellQry = cellQry + "				ELSE ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,4) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,8,4) ";
		cellQry = cellQry + "				END ";
		cellQry = cellQry + "			ELSE 'x' ";
		cellQry = cellQry + "			END ";
		cellQry = cellQry + "		END ";
		cellQry = cellQry + "	) AS PHONENUM ";
		cellQry = cellQry + " FROM ( ";
		cellQry = cellQry + "	SELECT ";
		cellQry = cellQry + "		EMPNO ";
		cellQry = cellQry + "		, NAME AS USER_NAME ";
		cellQry = cellQry + "		, CELLNO ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL1  ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL2 ";
		cellQry = cellQry + "	FROM  V_INSA ";
		cellQry = cellQry + "	WHERE EMPNO = '"+ refuserid +"' ";
		cellQry = cellQry + ") X ";
						
		
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
			cellNo2 = rs.getString("CELLNO");
			phoneNum2 = rs.getString("PHONENUM");
			name2 = rs.getString("USER_NAME");
		}

		cellNo2 = cellNo2.replace("-","");	
	}
}
catch(Exception ex){
	ex.printStackTrace();
} finally {
	rs.close();
	stmt.close();
	conn.close();
}

if ("N".equals(isChk)) {
	out.print("ret=-1");
	return;
}
//out.print(isChk);

//out.print(cellNo + "<br>");
//out.print(cellNo2 + "<br>");

String sendPhone = "";
String org_phone = "";
String strRefUserID = "";

String sendCnt = "";
if (empno.equals(refuserid)){
	sendCnt = "00001"; 
	sendPhone = cellNo.replace("-","");
	org_phone = cellNo.replace("-","");
	strRefUserID = empno ;
}else{ //사번변경해서 보낼때
	sendCnt = "00002";
	sendPhone = cellNo.replace("-","");
	org_phone = cellNo2.replace("-","");
	strRefUserID = refuserid ;
}



String seq = timeId + "_" + empno + "_" + request.getRemoteAddr();
//out.print(seq);
//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);
//out.print(certkey);

String message = "[한전 인터넷망]"+ name + "("+ empno +")님의 인증서 발급용 인증번호 : "+ certkey ;
//out.print(message);


//SMS정보 db insert
Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
//ResultSet rsu = null;

Connection connu = null;
//Statement stmtu = null;
PreparedStatement pstmtu = null;

String strSql = "INSERT INTO SMS_LOG ( SEQ, USERID, USERIP, SMSNUM, RETCODE, USERPHONE, REFUSERID)  VALUES ( '"+ seq +"', '"+ empno +"', '"+ request.getRemoteAddr() +"', '"+ certkey +"', '9999', '"+ org_phone +"', '"+ refuserid +"' )" ;
//out.print(strSql);

try {
	connu = dsu.getConnection();
	//stmtu = connu.createStatement();
	pstmtu = connu.prepareStatement(strSql);
	pstmtu.executeUpdate();

} catch(Exception e) {
	e.printStackTrace();
	
	out.print("ret=-1");
	return;
} finally {
	pstmtu.close();
	connu.close();
}

int resultCode = sendPush(org_phone, message);
if (resultCode != 200) {
	out.print("ret=-1");
	return;
}

//out.print(message + " - " + org_phone + "<br>");

if ("00002".equals(sendCnt)) {
	String smsMessage = "[한전 인터넷망]"+ name2 + "(" + refuserid + ")님이 인증서 대리발급을 요청하였습니다." ;
	//out.print(smsMessage + " - " + sendPhone + "<br>");
	sendSMS(empno, sendPhone, smsMessage);
}

out.print("ret=" + certkey);
%>