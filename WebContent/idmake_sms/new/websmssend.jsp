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
<%@ page import="kepco.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%!
//SendMSG�����
public String en(String ko){
	String new_str = null;
	try{        
		new_str  = new String(ko.getBytes("KSC5601"), "8859_1");
	} catch(UnsupportedEncodingException ex) {ex.printStackTrace(); }
		return new_str;
}

public String ko(String en){
	String new_str = null;
	try{              
		try{
			new_str  = new String(en.getBytes("8859_1"), "KSC5601");                
		}
		catch(UnsupportedEncodingException ex) {
				ex.printStackTrace(); 
		}
	}catch(NullPointerException e) {	
		System.out.println("Null  " + en);
		new_str = en;
	}
	return new_str;
}

public String fillSpace(String text, int size){
	String tmpStr = "";
	try{ 
		tmpStr = new String(text.getBytes("KSC5601"),"8859_1"); 
	}catch(UnsupportedEncodingException e){
		e.printStackTrace(); 
	} 
	int diff = size - tmpStr.length();
	if (diff > 0 ){
		for (int i = 0 ; i < diff ; i++) {
			text += " ";
			//text +=  (char)0;
		}
		StringBuffer sb1 = new StringBuffer(text);
		sb1.setLength(size);
		text = sb1.toString();
	}
	else{
		StringBuffer sb = new StringBuffer(text);
		sb.setLength(size);
		text = sb.toString();
	}

	return text;
}

public String getMessage(String str, int addCnt) {
	String strAdd ="";	
	for(int i=0; i <addCnt ; i++){
		strAdd += " ";
	}		
	return str+strAdd;
}

public String rtnMessage(String MsgCode){
	String MsgStr = "" ;
	if (MsgCode.equals("2000")) {
			MsgStr = "�������� �߼� ��� ����";
	}else if (MsgCode.equals("9999")) {
			MsgStr = "����";
	}else if (MsgCode.equals("1000")) {
			MsgStr = "SMS ���μ��� ����(SMS ���� ���μ��� ����)";
	}else if (MsgCode.equals("1001")) {
			MsgStr = "���� ���������� ����";
	}else if (MsgCode.equals("1002")) {
			MsgStr = "������ ���۽ð� �ʰ� ����";
	}else if (MsgCode.equals("1100")) {
			MsgStr = "�����ͺ��̽� ���� ���� �Ǵ� ���� ���� ����";
	}else if (MsgCode.equals("1101")) {
			MsgStr = "�����ͺ��̽� Query ����";
	}else if (MsgCode.equals("1200")) {
			MsgStr = "����� ���� ���� (�߸��� ����� �ڵ� ����)";
	}else if (MsgCode.equals("2000")) {
			MsgStr = "�������� �߼� ��� ����";
	}else {
			MsgStr = "����";
	
	}
	return MsgStr ;
}

//1. 9999 : ����(�޼��� ���� ó��)
//2. 1000 : SMS ���μ��� ����(SMS ���� ���μ����� �������� ���)
//3. 1001 : ���� ���������� ����(���� ������������ ������ ���� ���� ���)
//4. 1002 : ������ ���۽ð� �ʰ� ����(������ ���� �� �����ð����� ������ �ۼ����� �̷������ ���� ���)
//5. 1100 : �����ͺ��̽� ���� ����(�����ͺ��̽��� �����Ǿ����� ���� ������ ���� ���)
//6. 1101 : �����ͺ��̽� Query ����(�����ͺ��̽� Query �� ������ ���Ŀ� �°� ������ �� �����ͺ��̽� �˻��� �߸��� ���);
//7. 1200 : ����� ���� ���� (����� �ڵ尡 �߸��� ���)
//8. 2000 : �������� ������� ����
////////////////////////////////////////////////////

//�̸��� �߼��ϱ�
public String mailCertSend(String mailContent, String toMailAddress){
	String toAddress = toMailAddress ; //"ex099636@kepco.co.kr";
	String smtpHost = "10.180.6.91"; // SMTP ���� ����
	String mailSubject = "[�ѱ����°���] ���ͳݸ� PC �缳������ �븮 �߱��� ��û�Ͽ����ϴ�." ;
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

String phone1 = request.getParameter("phone1"); //���� �Է��� ��ȣ1
String phone2 = request.getParameter("phone2"); //���� �Է��� ��ȣ2
String phone3 = request.getParameter("phone3"); //���� �Է��� ��ȣ3


String org_phone = "" ; //request.getParameter("org_phone"); //DB�� ����� ��ȣ
String sendPhone = "" ; //phone1 + phone2 + phone3 ; //����ó ����

String sendCnt = "00001"; //�������� SMS���� ��

//check validation
if (empno.equals("") || empno==null || tmid.equals("") || tmid==null || refuserid.equals("") || refuserid==null ){
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('SMS������ ���� ��� �� ��ȭ��ȣ�� �����Ǿ� ���޵Ǿ����ϴ�.');");
	writer.println("location.href='websmsform.jsp';");
	writer.println("</script>");
	writer.flush();
	return;
} // end of check all of validation 

int cnt_user = 0 ; // ����� �ش��ϴ� ����� ���� ����(0:����, �׿� ����)
String isChk = "Y"; // �λ������� ����ó�� ����� ��ϾȵǾ��� ��� �÷���
String cellQry = "" ;
String strMsg = "" ;


String orgInsaOrgPhone = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String orgInsaOrgEmail = "" ; //�λ������� ������ ��ϵ� ���Ͼ��̵�(180717 njjang �߰�)
String orgSendFmatPhone = "x" ; //SMS������ ���� ���˺���� ��ȭ��ȣ
String orgUserName = "" ; //�����ϰ����ϴ� ��� ������� �̸�

String refInsaOrgPhone = "" ; //�λ������� ������ ��ϵ� ��ȭ��ȣ
String refSendFmatPhone = "x" ; //SMS������ ���� ���˺���� ��ȭ��ȣ
String refUserName = "" ; //�����ϰ����ϴ� ��� ������� �̸�

String isNoPhoneUser = "Y" ; //�λ������� �ڵ����� �߸��� ����� ���� üũ
String NoPhoneUserNum = "x" ;
String strRefUserID = empno ;
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//////////// ������� ����� ����ó �˻� Start //////////////////////////////////////////
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
		writer.println("location.href='websmsform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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
			orgSendFmatPhone = rs.getString("PHONENUM");
			orgInsaOrgPhone = rs.getString("CELLNO");
			orgInsaOrgEmail = rs.getString("MAILADDR");
			orgUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//����ó�� ����� ����� �ȵ� ���

		if (orgSendFmatPhone.equals("x")  ){
			isNoPhoneUser = "N" ;
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
		writer.println("location.href='websmsform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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
			refUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//����ó�� ����� ����� �ȵ� ���

		if (refSendFmatPhone.equals("x")  ){
			isChk = "N" ;
			strMsg = "�λ������� ��ϵ� �ùٸ� ����̳� �ش� ������� ����ó��\\n���������� ��ϵ��� �ʾҽ��ϴ�.\\n����� ����(���) : "+ refUserName +"("+ refuserid +")\\n��ϵ� ����ó : "+ refInsaOrgPhone ;
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('"+ strMsg +"');");
			writer.println("location.href='websmsform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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
//////////// ������� ����� ����ó �˻� End ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


//make SMS seq 
seq = tmid + "_" + empno + "_" + request.getRemoteAddr() ; // 20140709172427_ex099129_255.255.255.255


/////////////////////////////////////////////////////////////////////////////////////////
////1. ����ó ������ ���
////   case 1 )  empno != refuserid
////             - �ѹ��� �߼�
////2. ����ó ���� ���
////   case 2) empno = refuserid  REFUSERID
////		     - �ѹ��� �߼�
////   case 3) empno != refuserid
////             - �ι� �߼�
////	       a. �����ڵ� �߼� : smsphonenum = refuserid phone
////	       b. Ȯ���ڵ� �߼� : smsphonenum = empno phone
/////////////////////////////////////////////////////////////////////////////////////////
//refSendFmatPhone = "010-4214-5454"; // �븮�߱���
//orgSendFmatPhone = "010-4214-5454"; // ����
//orgInsaOrgEmail = "like_eh@nate.com";
if (isNoPhoneUser.equals("N")) { // �ڵ��� ��ȣ�� ���������� ��ϵ� ����ڰ� �ƴ� ���
		//�߱޹ް��� �ϴ� ������� �ڵ��� ��ȣ�� ���������� ��ϵ��� �ʾ��� ���� 
		//�븮�߱����� �����ϴ°����� ����	
		sendCnt = "00002";
		sendPhone = refSendFmatPhone.replace("-","");
		org_phone = refSendFmatPhone.replace("-","");
		strRefUserID = refuserid ;
}else{ // �ڵ��� ��ȣ�� ���������� ��ϵǾ��� ����� �����
	if (empno.equals(refuserid)){//���� ����� ����� �޴� ����� ����� ���� ��(����� ������� Default ����)
		sendCnt = "00001"; 
		sendPhone = orgSendFmatPhone.replace("-","");
		org_phone = orgSendFmatPhone.replace("-","");
		strRefUserID = empno ;
	}else{ //��������ؼ� ������
		sendCnt = "00002";
		sendPhone = orgSendFmatPhone.replace("-","");
		org_phone = refSendFmatPhone.replace("-","");
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
			writer.println("location.href='websmsform.jsp?empno="+ empno +"&tmid="+ tmid +"&refuserid2="+refuserid+"'");
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
String strMsgText ="[���� ���ͳݸ�]"+ orgUserName + "("+ empno +")���� ������ �߱޿� ������ȣ : "+certkey;

if (empno.equals(refuserid)){
	 strMsgText = strMsgText;
 }else{
	 strMsgText = "[���� ���ͳݸ�]"+ refUserName + "(" + refuserid + ")���� ������ �븮�߱��� ��û�Ͽ����ϴ�." ;
 }
//////////////////////////////////////////////////////////////////////////////////////////
//SMS������ȣ ����� END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

String RefSendMsg = "KEPCO-SSO �������߱޿� ������ȣ��û�˸� : "+ phone1 + "-" + phone2 + "-" + phone3  ;
//RefSendMsg = "KEPCO-SSO ������ȣ��û�˸�\n��û��ȣ:"+ sendPhone +"("+ refUserName +")";
RefSendMsg = "[���� ���ͳݸ�]"+ orgUserName + "("+ empno +")���� ������ �߱޿� ������ȣ : "+ certkey ;



////////////////////////////////////////////////////
//1. 9999 : ����(�޼��� ���� ó��)
//2. 1000 : SMS ���μ��� ����(SMS ���� ���μ����� �������� ���)
//3. 1001 : ���� ���������� ����(���� ������������ ������ ���� ���� ���)
//4. 1002 : ������ ���۽ð� �ʰ� ����(������ ���� �� �����ð����� ������ �ۼ����� �̷������ ���� ���)
//5. 1100 : �����ͺ��̽� ���� ����(�����ͺ��̽��� �����Ǿ����� ���� ������ ���� ���)
//6. 1101 : �����ͺ��̽� Query ����(�����ͺ��̽� Query �� ������ ���Ŀ� �°� ������ �� �����ͺ��̽� �˻��� �߸��� ���);
//7. 1200 : ����� ���� ���� (����� �ڵ尡 �߸��� ���)
//8. 2000 : �������� ������� ����

String SENDIP = "203.248.44.150";
int SENDPORT = 7904;


int iCLASSCODE = 5 ;
int iPASSWORD = 4 ;
int iKEY = 15 ;
int iRECVPHONE = 15 ;
int iCALLBACK = 15 ;
int iMESSAGE = 80 ;
int iEMPNO = 8 ;
int iREFCNT = 5 ;

String CLASSCODE = "IDMKL" ; // 5 + 1
String PASSWORD = "DIST"; // 4 + 1


String KEY = "000000000000001";//15 + 1
Locale locale = java.util.Locale.KOREA;
SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale);
String convertedTime = sdfr.format(new java.util.Date());
KEY = convertedTime ;


// ������� �ڵ��� ��ȣ�� ���������� ��ϾȵǾ����Ƿ� 
//String RECVPHONE = orgSendFmatPhone.replace("-","");
String RECVPHONE = sendPhone ; 

String REFPHONE = org_phone;

String CALLBACK = "0613458000"; //15 + 1
String MESSAGE = strMsgText ; //80 + 1

//if (sendCnt.equals("00002")){
  // MESSAGE = "[���� ���ͳݸ�]"+ refUserName + "("+refuserid+")���� ������ �븮 �߱��� ��û�Ͽ����ϴ�.";
//}
String EMPNO = empno ; // 8 + 1
String REFCNT = "00000"; // 5 + 1



String SEND_MSG = null ;



SEND_MSG = fillSpace(CLASSCODE, iCLASSCODE) + (char)0 ;	
SEND_MSG = SEND_MSG + fillSpace(PASSWORD, iPASSWORD) + (char)0 ;	
SEND_MSG = SEND_MSG + fillSpace(KEY, iKEY) + (char)0 ;	
SEND_MSG = SEND_MSG + fillSpace(RECVPHONE, iRECVPHONE) + (char)0 ;	
SEND_MSG = SEND_MSG + fillSpace(CALLBACK, iCALLBACK) + (char)0  ;	

int fCnt = 0 ;
if (fillSpace(MESSAGE,iMESSAGE).getBytes().length > iMESSAGE ){
	if(MESSAGE.getBytes().length < iMESSAGE ){
		fCnt = iMESSAGE-MESSAGE.getBytes().length;
		MESSAGE = getMessage(MESSAGE,fCnt);
	}
	SEND_MSG = SEND_MSG + MESSAGE  + (char)0 ;	
}else{
	SEND_MSG = SEND_MSG + fillSpace(MESSAGE,iMESSAGE) + (char)0 ;	
}
//SEND_MSG = SEND_MSG + getMessage(MESSAGE,81) ;

SEND_MSG = SEND_MSG + fillSpace(EMPNO,iEMPNO)  + (char)0;	
SEND_MSG = SEND_MSG + fillSpace(REFCNT,iREFCNT )  + (char)0;	



////////////////////////////////////////////////////
//  ���� �ڵ� ///////////////////////////////////
String RETURNCODE = "2000";
String RETURNMSG = "" ;



String strRef = "2000";
String RefMsg = RefSendMsg ;
String RefKey = KEY + "1" ;

String RefSMSMsg = "";
if (sendCnt.equals("00002")) {
	//��ȭ��ȣ�� �ٸ����� �� ����� ��ȭ��ȣ�� �޼��� ��������
	RefSMSMsg = fillSpace(CLASSCODE, iCLASSCODE) + (char)0 ;	
	RefSMSMsg = RefSMSMsg + fillSpace(PASSWORD, iPASSWORD) + (char)0 ;	
	RefSMSMsg = RefSMSMsg + fillSpace(RefKey, iKEY) + (char)0 ;	
	RefSMSMsg = RefSMSMsg + fillSpace(REFPHONE, iRECVPHONE) + (char)0 ;	
	RefSMSMsg = RefSMSMsg + fillSpace(CALLBACK, iCALLBACK) + (char)0  ;	

	int fCnt1 = 0 ;
	if (fillSpace(RefMsg,iMESSAGE).getBytes().length > iMESSAGE ){
		if(RefMsg.getBytes().length < iMESSAGE ){
			fCnt1 = iMESSAGE-RefMsg.getBytes().length;
			RefMsg = getMessage(RefMsg,fCnt1);
		}
		RefSMSMsg = RefSMSMsg + RefMsg  + (char)0 ;	
	}else{
		RefSMSMsg = RefSMSMsg + fillSpace(RefMsg,iMESSAGE) + (char)0 ;	
	}
	//SEND_MSG = SEND_MSG + getMessage(MESSAGE,81) ;

	RefSMSMsg = RefSMSMsg + fillSpace(EMPNO,iEMPNO)  + (char)0;	
	RefSMSMsg = RefSMSMsg + fillSpace(REFCNT,iREFCNT )  + (char)0;	
}


//SMS�߼��� ���� Ŭ���̾�Ʈ ��ü ����
SmsClient sms = new SmsClient();
RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);

RETURNCODE = RETURNCODE.trim();
RETURNMSG = rtnMessage(RETURNCODE);


if (sendCnt.equals("00002")) {
	strRef = sms.SendSMS(SENDIP, SENDPORT, RefSMSMsg).trim();

	// 180717 njjang �߰�
	// �븮�߱��ڰ� �������� �߱��� ��쿡 ������ ���ο��� �����˸� ������ �߼�
	// orgInsaOrgEmail
	/*
	if (!"x".equals(orgInsaOrgEmail)) {

		String emailMsg = "KEPCO-SSO ������ȣ��û�˸� : ������ȣ - "+ certkey +" / ��û ����ó - "+ refInsaOrgPhone +"("+ refUserName +")" + (char)10 + (char)10 ;
		emailMsg = emailMsg + orgUserName + "(" + empno + ")���� �������� " + refUserName + "(" + refuserid + ")���� �븮�߱��� ��û�Ͽ����ϴ�." ;

		String mresult = mailCertSend(emailMsg, orgInsaOrgEmail) ;
	}
	*/
}

//SMS���� db insert
Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
//ResultSet rsu = null;

Connection connu = null;
//Statement stmtu = null;
PreparedStatement pstmtu = null;

strSql = "INSERT INTO SMS_LOG ( SEQ, USERID, USERIP, SMSNUM, RETCODE, USERPHONE, REFUSERID)  VALUES ( '"+ seq +"', '"+ empno +"', '"+ request.getRemoteAddr() +"', '"+ certkey +"', '"+ RETURNCODE +"', '"+ RECVPHONE +"', '"+ strRefUserID +"' )" ;


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
<title>SMS �����ϱ�</title>
<script  type="text/javascript" language="javascript">
function  fncConfirm() {
<% 
if (RETURNCODE.equals("99991001")) { //����
%>
	alert("������ȣ�� SMS �߼��Ͽ����ϴ�.\n\n���۹����� ������ȣ�� �Է��Ͻʽÿ�.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("9999")) { //���۵���������
%>
	alert("[<%=RETURNMSG%>]������ȣ�� SMS �߼��Ͽ����ϴ�.\n\n���۹����� ������ȣ�� �Է��Ͻʽÿ�.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("1001")) { //���۵��������� �������� ��� ��ŵ
%>
	alert("[<%=RETURNMSG%>]SMS�Է¶��� <%=certkey%>��(��) �Է��Ͻʽÿ�.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();	
<%
}else{
%>
	
	alert("������ȣ�� SMS �߼��Ͽ����ϴ�.\n\n���۹����� ������ȣ�� �Է��Ͻʽÿ�.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}	
%>
}
</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="fncConfirm();">
<!-- RETURNCODE : <%=RETURNCODE%><br />
org_phone : <%=org_phone%><br />
sendPhone : <%=sendPhone%><br />
sendCnt : <%=sendCnt%><br /> -->
</body>
</html>