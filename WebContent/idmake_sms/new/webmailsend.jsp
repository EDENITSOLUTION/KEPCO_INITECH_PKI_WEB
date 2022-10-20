<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.*"%>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import="java.lang.String.*" %>
<%@ page import="javax.mail.*, javax.mail.internet.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file="fncSMS2.jsp" %>
<%!
//�޼��� �߼��ϱ�
public String mailCertSend(String mailTitle, String mailContent, String toMailAddress){
	
	String toAddress = toMailAddress ; //"ex099636@kepco.co.kr";
	String smtpHost = "127.0.0.1"; // SMTP ���� ����
	String mailSubject = mailTitle ;
						//new String("[�ѱ����°���] ���ͳݸ� ������ �߱޿� ���� ��ȣ".getBytes("8859_1"),"KSC5601");
	String mailText = mailContent ; 
						//new String("�̽��ƴ��� ���ͳݸ� ������ �߱� ������ȣ�� : [000000]�Դϴ�.".getBytes("8859_1"),"KSC5601");
	String fromAddress = "kepcosso@kepco.co.kr" ; //request.getParameter("from");        //��������


	Properties props = null;

	String resultMsg = "ok" ;

	try {
          props = new Properties();


		props.put("mail.smtp.host", smtpHost);
		Session s = Session.getInstance(props,null);
		MimeMessage message = new MimeMessage(s); 

		 
		InternetAddress from = new InternetAddress(fromAddress);
		message.setFrom(from); // �������� ����
		 

		InternetAddress to = new InternetAddress(toAddress); // �޴��� ���� 
		message.addRecipient(Message.RecipientType.TO, to);   
		message.setSubject(mailSubject); // ���� 
		message.setContent(mailText, "text/html"); // content Type ���� 
		message.setText(mailText, "utf-8", "html"); // ���� 
		Transport.send(message); // ���� �߼�

		resultMsg = "ok" ;
		
	}catch (Exception e) {
            resultMsg = e.toString();
    }
	return resultMsg ;
}

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
String strIsInsa = request.getParameter("strIsInsa"); //SMS�λ����� ���� ����
if (strIsInsa.equals("") || strIsInsa == null) {
	strIsInsa = "N"; //default�� �������� ����
}

String empno = request.getParameter("empno"); //���
String tmid = request.getParameter("tmid");//Ÿ�Ӿ��̵�
String refuserid = request.getParameter("refuserid");//������ �Ǵ� ��� ���� ���� ��� 
String orguserpw = request.getParameter("orguserpw");
String seq = "" ;
String strSql = "" ;


String org_mail = "" ; //request.getParameter("org_mail"); //DB�� ����� ��ȣ
String sendMail = "" ; 

String sendCnt = "00001"; //�������� SMS���� ��

//check validation
if (empno.equals("") || empno==null || tmid.equals("") || tmid==null || refuserid.equals("") || refuserid==null ){
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('���� ������ ���� ��� �� �����ּҰ� �����Ǿ� ���޵Ǿ����ϴ�.');");
	writer.println("window.close();");
	writer.println("</script>");
	writer.flush();
	return;
} // end of check all of validation 

int cnt_user = 0 ; // ����� �ش��ϴ� ����� ���� ����(0:����, �׿� ����)
String isChk = "Y"; // �λ������� ����ó�� ����� ��ϾȵǾ��� ��� �÷���
String cellQry = "" ;
String strMsg = "" ;

String orgInsaOrgPhone = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String orgInsaOrgMail = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String orgSendFmatMail = "x" ; //SMS������ ���� ���˺���� ��ȭ��ȣ
String orgUserName = "" ; //�����ϰ����ϴ� ��� ������� �̸�

String refInsaOrgPhone = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String refInsaOrgMail = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String refSendFmatMail = "x" ; //SMS������ ���� ���˺���� ��ȭ��ȣ
String refSendFmatPhone = "x" ; //SMS������ ���� ���˺���� ��ȭ��ȣ
String refUserName = "" ; //�����ϰ����ϴ� ��� ������� �̸�

String isNoMailUser = "Y" ; //�λ������� �̸����� �߸��� ����� ���� üũ
String NoMailUserNum = "x" ;
String strRefUserID = empno ;
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//////////// ������� ����� �����ּ� �˻� Start //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
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


	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ empno +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isChk = "N" ;
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('�Է��Ͻ� ���("+ empno +")�� ���� ������ �λ��������� �������� �ʽ��ϴ�.');");
		writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // ����� ���� �����Ҷ�				
		cellQry = "" ;
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
			orgInsaOrgPhone = rs.getString("CELLNO");
			orgSendFmatMail = rs.getString("MAILADDR");
			orgInsaOrgMail = rs.getString("MAILADDR");
			orgUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//����ó�� ����� ����� �ȵ� ���

		if (orgSendFmatMail.equals("x")  ){
			isNoMailUser = "N" ;
		}else{
			isChk = "Y" ;			
		}
	}


	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ refuserid +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isChk = "N" ;
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('�Է��Ͻ� ���("+ refuserid +")�� ���� ������ �λ��������� �������� �ʽ��ϴ�.');");
		writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // ����� ���� �����Ҷ�				
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
			refSendFmatPhone = rs.getString("PHONENUM").replace("-","");
			refInsaOrgPhone = rs.getString("CELLNO");
			refSendFmatMail = rs.getString("MAILADDR");
			refInsaOrgMail = rs.getString("MAILADDR");
			refUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//����ó�� ����� ����� �ȵ� ���

		if (refSendFmatMail.equals("x")  ){
			isChk = "N" ;
			strMsg = "�λ������� ��ϵ� �ùٸ� ����̳� �ش� ������� �����ּҰ�\\n���������� ��ϵ��� �ʾҽ��ϴ�.\\n����� ����(���) : "+ refUserName +"("+ refuserid +")\\n��ϵ� �����ּ� : �̵��" ;
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('"+ strMsg +"');");
			writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
			writer.println("</script>");
			writer.flush();
			return;
		}else{
			isChk = "Y" ;			
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

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//////////// ������� ����� �����ּ� �˻� End ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


//make MAIL  seq 
seq = tmid + "_" + empno + "_" + request.getRemoteAddr() ; // 20140709172427_ex099129_255.255.255.255


/////////////////////////////////////////////////////////////////////////////////////////
////1. �����ּ� ������ ���
////   case 1 )  empno != refuserid
////             - �ѹ��� �߼�
////2. �����ּ� ���� ���
////   case 2) empno = refuserid  REFUSERID
////		     - �ѹ��� �߼�
////   case 3) empno != refuserid
////             - �ι� �߼�
////	       a. �����ڵ� �߼� : smsphonenum = refuserid phone
////	       b. Ȯ���ڵ� �߼� : smsphonenum = empno phone
/////////////////////////////////////////////////////////////////////////////////////////

if (isNoMailUser.equals("N")) { // �̸��� ��ȣ�� ���������� ��ϵ� ����ڰ� �ƴ� ���
	sendCnt = "00001"; //�̸��ϵ� ���������� ��ϾȵǾ����� �ٸ� ����ڿ��� �˸� �޼��� ������������ �ѹ�
	sendMail = refSendFmatMail.replace("-","");
	org_mail = refSendFmatMail.replace("-","");
	strRefUserID = refuserid ;
}else{ // �̸��� ��ȣ�� ���������� ��ϵǾ��� ����� �����
	if (empno.equals(refuserid)){//���� ����� ����� �޴� ����� ����� ���� ��(����� ������� Default ����)
		sendCnt = "00001"; 
		sendMail = orgSendFmatMail.replace("-","");
		org_mail = orgSendFmatMail.replace("-","");
		strRefUserID = empno ;
	}else{ //��������ؼ� ������
		sendCnt = "00002";
		sendMail = refSendFmatMail.replace("-","");
		org_mail = orgSendFmatMail.replace("-","");
		strRefUserID = refuserid ;
	}
}

if ("00002".equals(sendCnt)) {

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
			writer.println("alert('�߱޹��� ����� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.');");
			writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"&refuserid2="+refuserid+"'");
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
}

//////////////////////////////////////////////////////////////////////////////////////////
//SMS������ȣ ����� START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);

/*
String strTitText = "";
String strMsgText ="=================================================================================" + (char)10 ;
strMsgText = strMsgText + "---------------------------------------------------------------------------------" + (char)10 + (char)10 ; 
strMsgText = strMsgText + "[�ѱ����°���]  ���ͳݸ� PC �缳������ �߱޿� ������ȣ�� [ "+certkey+" ]�Դϴ�." + (char)10 + (char)10 ;
strMsgText = strMsgText + orgUserName + "(" + empno + ")���� �������� " + refUserName + "(" + refuserid + ")���� �븮�߱��� ��û�Ͽ����ϴ�."  + (char)10 + (char)10 ;
strMsgText = strMsgText + "---------------------------------------------------------------------------------" + (char)10 ; 
strMsgText = strMsgText + "=================================================================================" + (char)10 ; 

//////////////////////////////////////////////////////////////////////////////////////////
//SMS������ȣ ����� END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////






String RefSendMsg = "KEPCO-SSO ������ȣ��û�˸� : ������ȣ - "+ certkey +" / ��û �̸��� - "+ sendMail +"("+ refUserName +")" + (char)10 + (char)10 ;
RefSendMsg = RefSendMsg + orgUserName + "(" + empno + ")���� �������� " + refUserName + "(" + refuserid + ")���� �븮�߱��� ��û�Ͽ����ϴ�." ;
*/

//���� �߼�
String sendMailing = "" ;

String sendRefMailing = "" ;

if (sendCnt.equals("00002")) { // �븮 �߱��� ���

	String subject = "[���� ���ͳݸ�] ������ �߱޿� ������ȣ";
	String content = certkey;
	sendMailing = mailCertSend(subject, content, sendMail) ; // �븮��
	
	subject = "[���� ���ͳݸ�] ������ �븮�߱� ��û";
	
	
	content = "";
	//content = "<table border='1'>";
	//content+= "<tr>";
	//content+= "<td colspan='2'>image1</td>";
	//content+= "</tr>";
	//content+= "<tr>";
	//content+= "<td colspan='2'>image2</td>";
	//content+= "</tr>";
	//content+= "<tr>";
	//content+= "<td>image3</td>";
	//content+= "<td>";
	//content+= "<input type='text' value='123'/>";
	//content+= "</td>";
	//content+= "</tr>";
	//content+= "<tr>";
	//content+= "<td>";
	content+= "[���� ���ͳݸ�] "+orgUserName+"("+empno+")���� �������� "+refUserName+"("+refuserid+")���� ������ �븮�߱��� ��û�Ͽ����ϴ�.";
	//content+= "</td>";
	//content+= "</tr>";
	//content+= "</table>";	
	
	
	sendRefMailing = mailCertSend(subject, content, org_mail) ; // ����
	//sendSMS(empno, orgInsaOrgPhone, content);
	sendSMS(empno, orgInsaOrgPhone, "[���� ���ͳݸ�] "+refUserName+"("+refuserid+")���� ������ �븮�߱��� ��û�Ͽ����ϴ�.");

} else { // ���� �߱��� ���
	
	String subject = "[���� ���ͳݸ�] ������ �߱޿� ������ȣ";
	String content = certkey;
	sendMailing = mailCertSend(subject, content, sendMail) ;

}

//SMS���� db insert
Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
//ResultSet rsu = null;

Connection connu = null;
//Statement stmtu = null;
PreparedStatement pstmtu = null;

strSql = "INSERT INTO SMS_LOG ( SEQ, USERID, USERIP, SMSNUM, RETCODE, USERPHONE, REFUSERID)  VALUES ( '"+ seq +"', '"+ empno +"', '"+ request.getRemoteAddr() +"', '"+ certkey +"', '9999', '"+ sendMail +"', '"+ strRefUserID +"' )" ;


try {
	connu = dsu.getConnection();
	//stmtu = connu.createStatement();
	pstmtu = connu.prepareStatement(strSql);
	pstmtu.executeUpdate();

} catch(Exception e) {
	e.printStackTrace();
} finally {
	pstmtu.close();
	connu.close();
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>���� �����ϱ�</title>
<script  type="text/javascript" language="javascript">
function  fncConfirm() {
	alert("�Է��Ͻ� ���� �ּҷ� ������ȣ�� �߼��Ͽ����ϴ�.\n\n���� Ȯ�� ��, ������ȣ�� �Է��Ͻʽÿ�.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
}
</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="fncConfirm();">
<!-- 
sendMailing : <%=sendMailing%>
sendRefMailing : <%=sendRefMailing%>
org_mail : <%=org_mail%><br />
sendMail : <%=sendMail%><br />
sendCnt : <%=sendCnt%><br /> -->
</body>
</html>
