<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>SMS 인증하기</title>
<%
String empno = request.getParameter("empno");
String refuserid = request.getParameter("refuserid");

int cnt_user = 0 ; //사번에 대한 사용자 정보 유무 (0:없음, 그외 존재)
String cellQry = null ;
String MAILADDR = null;
String orgMail = null;
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
		cellQry = cellQry + "SELECT X.EMPNO ";
		cellQry = cellQry + "    , X.NAME AS USER_NAME ";
		cellQry = cellQry + "    , X.MAILNO ";
		cellQry = cellQry + "			 ,( ";
		cellQry = cellQry + "    CASE WHEN X.MAILNO IS NULL THEN 'x' ";
		cellQry = cellQry + "    ELSE ";
		cellQry = cellQry + "		CASE INSTR(X.MAILNO,'@',1)  ";
		cellQry = cellQry + "			WHEN 0 THEN X.MAILNO || '@kepco.co.kr' ";
		cellQry = cellQry + "       ELSE X.MAILNO ";
		cellQry = cellQry + "       END ";
		cellQry = cellQry + "     END ";
		cellQry = cellQry + "    ) AS MAILADDR ";
		cellQry = cellQry + " FROM V_INSA X ";
		cellQry = cellQry + " WHERE EMPNO = '"+ refuserid +"' ";
		
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
			MAILADDR = rs.getString("MAILADDR");
			orgMail = rs.getString("MAILADDR");
			USER_NAME = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//연락처가 제대로 등록이 안된 경우

		if (MAILADDR.equals("x")  ){
			isOkEmp = "N" ;
			strMsg = "인사정보에 등록된 올바른 사번이나 해당 사용자의 메일주소가\\n정상적으로 등록되지 않았습니다.\\n사용자 정보(사번) : "+ USER_NAME +"("+ refuserid +")\\n등록된 메일주소 : "+ orgMail ;
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
			strMsg = "메일 인증을 받을 수 있는 올바른 사번입니다.\\n사용자 정보(사번) : "+ USER_NAME +"("+ refuserid +")\\n등록된 메일주소 : "+ orgMail ;

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