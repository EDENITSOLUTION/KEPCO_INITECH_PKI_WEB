<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>SMS �����ϱ�</title>
<%
String empno = request.getParameter("empno");
String refuserid = request.getParameter("refuserid");

int cnt_user = 0 ; //����� ���� ����� ���� ���� (0:����, �׿� ����)
String cellQry = null ;
String MAILADDR = null;
String orgMail = null;
String USER_NAME = null ;
String isOkEmp = "N" ;
String strMsg = "" ;

if (refuserid.equals("") || refuserid==null || empno.equals("") || empno==null ){
	isOkEmp = "N" ;
	//����� �Ѿ���� ������ â�� �ݾƹ�����
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("parent.document.data.isOkEmp.value='N';");	
	writer.println("parent.document.data.refuserid.value='';");
	writer.println("parent.document.data.hdnRefEmp.value='';");
	writer.println("alert('����� ����� ���޵��� �ʾҽ��ϴ�.');");
	writer.println("location.href='blank.html';");
	writer.println("</script>");
	writer.flush();
	return;
}

if (refuserid.equals(empno)){
	isOkEmp = "N" ;
	//����� �Ѿ���� ������ â�� �ݾƹ�����
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("parent.document.data.isOkEmp.value='N';");	
	writer.println("parent.document.data.refuserid.value='';");
	writer.println("parent.document.data.hdnRefEmp.value='';");
	writer.println("alert('�������� ����� �ڽ��� ����� ��ġ�մϴ�.\n\n�ٽ� �ѹ� Ȯ���Ͻʽÿ�.');");
	writer.println("location.href='blank.html';");
	writer.println("</script>");
	writer.flush();
	return;
}


//����� �Ѿ���� �λ��ʿ��� �ش� ����� ��ȭ��ȣ�� ������ ����
Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

try{
	//����� �λ������� �����ϴ��� üũ
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
		writer.println("alert('�Է��Ͻ� ���("+ refuserid +")�� ���� ������ �λ��������� �������� �ʽ��ϴ�.');");
		writer.println("location.href='blank.html';");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // ����� ���� �����Ҷ�				
		
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


		//����ó�� ����� ����� �ȵ� ���

		if (MAILADDR.equals("x")  ){
			isOkEmp = "N" ;
			strMsg = "�λ������� ��ϵ� �ùٸ� ����̳� �ش� ������� �����ּҰ�\\n���������� ��ϵ��� �ʾҽ��ϴ�.\\n����� ����(���) : "+ USER_NAME +"("+ refuserid +")\\n��ϵ� �����ּ� : "+ orgMail ;
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
			strMsg = "���� ������ ���� �� �ִ� �ùٸ� ����Դϴ�.\\n����� ����(���) : "+ USER_NAME +"("+ refuserid +")\\n��ϵ� �����ּ� : "+ orgMail ;

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