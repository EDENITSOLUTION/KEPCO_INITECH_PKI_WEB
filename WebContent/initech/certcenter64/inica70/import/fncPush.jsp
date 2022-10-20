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
<%@ page import="kepco.*" %>
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

%>
