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
<%!
//�޼��� �߼��ϱ�
public String mailCertSend(String mailContent, String toMailAddress){
	
	String toAddress = toMailAddress ; //"ex099636@kepco.co.kr";
	String smtpHost = "10.180.6.91"; // SMTP ���� ����
	String mailSubject = "[�ѱ����°���] ���ͳݸ� PC �缳������ �߱޿� ������ȣ�Դϴ�." ;
						//new String("[�ѱ����°���] ���ͳݸ� ������ �߱޿� ���� ��ȣ".getBytes("8859_1"),"KSC5601");
	String mailText = mailContent ; 
						//new String("�̽��ƴ��� ���ͳݸ� ������ �߱� ������ȣ�� : [000000]�Դϴ�.".getBytes("8859_1"),"KSC5601");
	String fromAddress = "idmake@kepco.co.kr" ; //request.getParameter("from");        //��������


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
		message.setContent(mailText, "text/plain; charset=EUC-KR"); // content Type ���� 
		message.setText(mailText); // ���� 
		Transport.send(message); // ���� �߼�

		resultMsg = "ok" ;
		
	}catch (Exception e) {
            resultMsg = e.toString();
    }
	return resultMsg ;
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


String orgInsaOrgMail = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String orgSendFmatMail = "x" ; //SMS������ ���� ���˺���� ��ȭ��ȣ
String orgUserName = "" ; //�����ϰ����ϴ� ��� ������� �̸�

String refInsaOrgMail = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String refSendFmatMail = "x" ; //SMS������ ���� ���˺���� ��ȭ��ȣ
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
		cellQry = cellQry + " WHERE EMPNO = '"+ empno +"' ";
						
		
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
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


//////////////////////////////////////////////////////////////////////////////////////////
//SMS������ȣ ����� START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);

String strMsgText ="=================================================================================" + (char)10 ;
strMsgText = strMsgText + "---------------------------------------------------------------------------------" + (char)10 + (char)10 ; 
strMsgText = strMsgText + "[�ѱ����°���]  ���ͳݸ� PC �缳������ �߱޿� ������ȣ�� [ "+certkey+" ]�Դϴ�." + (char)10 + (char)10 ;
strMsgText = + orgUserName + "(" + empno + ")���� ��������" + refUserName + "(" + refuserid + ")���� �븮�߱��� ��û�Ͽ����ϴ�."  + (char)10 + (char)10 ;
strMsgText = strMsgText + "---------------------------------------------------------------------------------" + (char)10 ; 
strMsgText = strMsgText + "=================================================================================" + (char)10 ; 

//////////////////////////////////////////////////////////////////////////////////////////
//SMS������ȣ ����� END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////






String RefSendMsg = "KEPCO-SSO ������ȣ��û�˸� : ������ȣ - "+ certkey +" / ��û �̸��� - "+ sendMail +"("+ refUserName +")" + (char)10 + (char)10 ;
strMsgText = + orgUserName + "(" + empno + ")���� ��������" + refUserName + "(" + refuserid + ")���� �븮�߱��� ��û�Ͽ����ϴ�." ;



//���� �߼�
String sendMailing = mailCertSend(strMsgText, sendMail) ;

String sendRefMailing = "" ;

if (sendCnt.equals("00002")) {
	sendRefMailing = mailCertSend(RefSendMsg, org_mail) ;
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
org_mail : <%=org_mail%><br />
sendMail : <%=sendMail%><br />
sendCnt : <%=sendCnt%><br /> -->
</body>
</html>