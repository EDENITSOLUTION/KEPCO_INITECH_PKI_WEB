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
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.daou.smartpush.service.message2.Message" %>
<%@ page import="com.daou.smartpush.service.result.Result" %>
<%@ page import="com.daou.smartpush.service.send.Sender" %>
<%@ page import="com.daou.smartpush.util.contents.ConfirmUse" %>
<%@ page import="com.daou.smartpush.util.contents.Contents" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ page import="kepco.*" %>
<%@ include file="fncSMS2.jsp" %>
<%!
public int sendPush(String phone, String message) {

	Locale locale = java.util.Locale.KOREA;
	SimpleDateFormat sdfr = new SimpleDateFormat("yyMMddHHmmss", locale);
	String convertedTime = sdfr.format(new java.util.Date());

	String HOST = "http://203.248.44.215:35001/server";	// ���� : Ǫ�� ���� Host �� - ���߼��� http://211.223.60.10:35000/server	
	String APP_KEY 	= "dR/hxv3BZg22gCVzl6YDFwkPhWY=";	// ���� : �߼� �� Key
	String USER_ID 	= "kepco123";						// ���� : ���� ID
	String USER_PW 	= "powernet!@";						// ���� : ���� PWD
	String LOG_PATH 	= "/home/kdnadmin/initech";						// �Է� : log���� ���
	String CALL_PHONE 	= "0613458000";					// �Է� : �߽��� ��ȭ��ȣ 
	String LEGACY_CODE = "IDNTN";							// �Է� : �����ڵ�
	String SEND_MESSAGE = message;				// �Է� : �߼� �޽���
	
	String PUSH_KEY1 	= convertedTime;					// �׽�Ʈ �ڵ� : ����Ű #1


	String PUSH_PHONE1	= phone.replace("-","");					// �׽�Ʈ �ڵ� : ������ ��ȭ��ȣ #1

	Sender sender = new Sender(HOST, LOG_PATH);
	String authRequestMsg = Message.newAuthKeyMessage()
			.userId(USER_ID)
			.pwd(USER_PW).build();
	Result authResult = sender.sendAuthKey(authRequestMsg);
	/*
	out.println("ResultCode : " + authResult.getResultCode()
			+ "\n Result Message : " + authResult.getResultMsg()
			+ "\n AuthKey : " + authResult.getAuthKey());
	*/
		ArrayList targetList = new ArrayList();
		HashMap named = new HashMap();
        named.put(PUSH_KEY1, PUSH_PHONE1);
        targetList.add(named);
        /* ----------------------------------------------------- */

		String namedPackageRequestMsg = null;

		try {
			namedPackageRequestMsg = Message.newNamedPackageMessage()
					.authKey(authResult.getAuthKey())
					.appkey(APP_KEY)
					.message(SEND_MESSAGE)
					.pushType(Contents.PAYLOAD_PUSHTYPE_ALL)
					.sendType(Contents.PAYLOAD_SENDTYPE_NORMAL)
					.receiveType(Contents.PAYLOAD_RECEIVETYPE_ID)
					.sendPhone(CALL_PHONE)
//					.targetList(PUSH_KEY1, PUSH_PHONE1) //.targetList("Target ID","Send Phone Number")
					.targetList(targetList)
					.cutOption(Contents.PAYLOAD_CUTOPTION_YES)
					.confirmUse(ConfirmUse.Y)
					.confirmTimeout(30)
					.option("code", LEGACY_CODE).build();
			
		} catch (Exception e) {
			//out.println("Named Package Message Setting Error");
		}
		
		// 5-3. �߼� ��û �� ��� �ޱ�
		//.sendNamed() : ������ Sender ��ü ���� �޼���. Named �߼� ��û�� ����ϴ� �޼���
		Result namedResult = sender.sendNamedPackage(namedPackageRequestMsg);
		
		//��� ��ü �� ���� �޼���
		//Result : �߼� ����� �����ϰ� �ִ� ��ü
		//.getResultCode()   : ��û ��� Code ��ȯ �޼���
		//.getResultMsg()    : ��û ��� Message ��ȯ �޼��� 
		//.getAuthKey()      : AuthKey ��û ������ �߱� �� Auth Key ��ȯ �޼���
		//.getMsgTag()       : �߼� ��û ������ �߱޵� Message Tag ��ȯ �޼���
		//.getInvalidId      : Named �߼� ��û�� ��û�� ID�� ���� ID ��� ��ȯ �޼���
		/*
		out.println("ResultCode : " + namedResult.getResultCode()
				+ "\n msgTag : " + namedResult.getMsgTag()
				+ "\n Result Message : " + namedResult.getResultMsg()
				+ "\n Invalid ID : " + namedResult.getInvalidId());
		*/
	return namedResult.getResultCode();
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
	writer.println("alert('PUSH������ ���� ��� �� ��ȭ��ȣ�� �����Ǿ� ���޵Ǿ����ϴ�.');");
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
		writer.println("location.href='apppushform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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
		writer.println("location.href='apppushform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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
			writer.println("location.href='apppushform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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
//refSendFmatPhone = "010-3089-0929"; // �븮�߱���
//orgSendFmatPhone = "010-3089-0929"; // ����
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
			writer.println("location.href='apppushform.jsp?empno="+ empno +"&tmid="+ tmid +"&refuserid2="+refuserid+"'");
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


String RECVPHONE = sendPhone ; 
String REFPHONE = org_phone;
String RETURNCODE = "9999";


	sendPush(RECVPHONE, strMsgText);
	if (sendCnt.equals("00002")) {
		sendPush(REFPHONE, RefSendMsg);
		sendSMS(empno, REFPHONE, strMsgText);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
	
	alert("������ȣ�� PUSH �߼��Ͽ����ϴ�.\n\n���۹����� ������ȣ�� �Է��Ͻʽÿ�.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
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
