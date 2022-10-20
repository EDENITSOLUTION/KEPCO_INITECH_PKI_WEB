<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>SMS 인증하기</title>
<%
String empno = request.getParameter("empno");
String refuserid = request.getParameter("refuserid");
String orguserpw = request.getParameter("orguserpw");

int cnt_user = 0 ; //사번에 대한 사용자 정보 유무 (0:없음, 그외 존재)
String cellQry = null ;
String PHONENUM = null;
String orgPhone = null;
String USER_NAME = null ;
String isOkEmp = "N" ;
String strMsg = "" ;

if (refuserid.equals("") || refuserid==null || empno.equals("") || empno==null ){
	isOkEmp = "N" ;
	//사번이 넘어오지 않으면 창을 닫아버리자
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("parent.document.data.isOkEmp.value='N';");	
	writer.println("parent.document.data.refuserid.value='';");
	writer.println("parent.document.data.hdnRefEmp.value='';");
	writer.println("alert('사용자 사번이 전달되지 않았습니다.');");
	writer.println("location.href='blank.html';");
	writer.println("</script>");
	writer.flush();
	return;
}

if (refuserid.equals(empno)){
	isOkEmp = "N" ;
	//사번이 넘어오지 않으면 창을 닫아버리자
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("parent.document.data.isOkEmp.value='N';");	
	writer.println("parent.document.data.refuserid.value='';");
	writer.println("parent.document.data.hdnRefEmp.value='';");
	writer.println("alert('인증받을 사번이 자신의 사번과 일치합니다.\n\n다시 한번 확인하십시오.');");
	writer.println("location.href='blank.html';");
	writer.println("</script>");
	writer.flush();
	return;
}

// 인증서 발급받을 사원의 비밀번호 확인 
/*
Context rIc = new InitialContext();
DataSource rDs = (DataSource) rIc.lookup("java:comp/env/jdbc/INICA");
ResultSet rRs = null;

Connection rConn = null;
Statement rStmt = null;

	try{
		rConn = rDs.getConnection();
		rStmt = rConn.createStatement();
		rRs = rStmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + empno + "' and userpwd = '" + getBase64Data(getHashValue(orguserpw)) + "' ");
		
		int rPwdUCnt = 0;
		while(rRs.next()) {
			rPwdUCnt =  rRs.getInt("cnt");
		}

		if (rPwdUCnt == 0) {
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("parent.document.data.isOkEmp.value='N';");	
			writer.println("parent.document.data.refuserid.value='';");		
			writer.println("parent.document.data.orguserpw.value='';");
			writer.println("alert('발급받을 사원의 비밀번호가 일치하지 않습니다.');");
			writer.println("location.href='blank.html';");
			writer.println("</script>");
			writer.flush();
			return;
		}

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		rRs.close();
		rStmt.close();
		rConn.close();
	}
*/


//사번이 넘어오면 인사쪽에서 해당 사번의 전화번호를 가지고 오자
Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

try{
	//사번이 인사정보에 존재하는지 체크
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();
	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ refuserid +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isOkEmp = "N" ;
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("parent.document.data.isOkEmp.value='N';");	
		writer.println("parent.document.data.refuserid.value='';");		
		writer.println("parent.document.data.hdnRefEmp.value='';");
		writer.println("alert('입력하신 사번("+ refuserid +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("location.href='blank.html';");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // 사용자 정보 존재할때				
		cellQry = "" ;
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
			PHONENUM = rs.getString("PHONENUM");
			orgPhone = rs.getString("CELLNO");
			USER_NAME = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//연락처가 제대로 등록이 안된 경우

		if (PHONENUM.equals("x")  ){
			isOkEmp = "N" ;
			strMsg = "인사정보에 등록된 올바른 사번이나 해당 사용자의 연락처가\\n정상적으로 등록되지 않았습니다.\\n사용자 정보(사번) : "+ USER_NAME +"("+ refuserid +")\\n등록된 연락처 : "+ orgPhone ;
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("parent.document.data.isOkEmp.value='N';");	
			writer.println("parent.document.data.refuserid.value='';");
			writer.println("parent.document.data.hdnRefEmp.value='';");
			writer.println("alert('"+ strMsg +"');");
			writer.println("location.href='blank.html';");
			writer.println("</script>");
			writer.flush();
			return;
		}else{
			isOkEmp = "Y" ;
			strMsg = "SMS인증을 받을 수 있는 올바른 사번입니다.\\n사용자 정보(사번) : "+ USER_NAME +"("+ refuserid +")\\n등록된 연락처 : "+ orgPhone.substring(0,3)+"-****-"+orgPhone.substring(9,13);

			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("parent.document.data.isOkEmp.value='Y';");	
			//writer.println("parent.document.data.refuserid.value='';");
			writer.println("parent.document.data.hdnRefEmp.value='"+ refuserid +"';");
			writer.println("alert('"+ strMsg +"');");
			//writer.println("location.href='blank.html';");
			writer.println("</script>");
			writer.flush();
			//return;


		}
	}
}
catch(Exception ex){
	ex.printStackTrace();
} finally {
	rs.close();
	stmt.close();
	conn.close();
}

%>
</head>
<body>
<%=isOkEmp%>
</body>
</html>
