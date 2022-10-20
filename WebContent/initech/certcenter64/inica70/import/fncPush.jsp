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

	String HOST = "http://203.248.44.215:35001/server";	// 배포 : 푸시 서버 Host 명 - 개발서버 http://211.223.60.10:35000/server	
	String APP_KEY 	= "dR/hxv3BZg22gCVzl6YDFwkPhWY=";	// 배포 : 발송 앱 Key
	String USER_ID 	= "kepco123";						// 배포 : 계정 ID
	String USER_PW 	= "powernet!@";						// 배포 : 계정 PWD
	String LOG_PATH 	= "/home/kdnadmin/initech";						// 입력 : log파일 경로
	String CALL_PHONE 	= "0613458000";					// 입력 : 발신자 전화번호 
	String LEGACY_CODE = "IDNTN";							// 입력 : 업무코드
	String SEND_MESSAGE = message;				// 입력 : 발송 메시지
	
	String PUSH_KEY1 	= convertedTime;					// 테스트 코드 : 고유키 #1


	String PUSH_PHONE1	= phone.replace("-","");					// 테스트 코드 : 수신자 전화번호 #1

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
		
		// 5-3. 발송 요청 및 결과 받기
		//.sendNamed() : 생성한 Sender 객체 내부 메서드. Named 발송 요청을 담당하는 메서드
		Result namedResult = sender.sendNamedPackage(namedPackageRequestMsg);
		
		//결과 객체 및 제공 메서드
		//Result : 발송 결과를 보유하고 있는 객체
		//.getResultCode()   : 요청 결과 Code 반환 메서드
		//.getResultMsg()    : 요청 결과 Message 반환 메서드 
		//.getAuthKey()      : AuthKey 요청 성공시 발급 된 Auth Key 반환 메서드
		//.getMsgTag()       : 발송 요청 성공시 발급된 Message Tag 반환 메서드
		//.getInvalidId      : Named 발송 요청시 요청한 ID중 없는 ID 목록 반환 메서드
		/*
		out.println("ResultCode : " + namedResult.getResultCode()
				+ "\n msgTag : " + namedResult.getMsgTag()
				+ "\n Result Message : " + namedResult.getResultMsg()
				+ "\n Invalid ID : " + namedResult.getInvalidId());
		*/
	return namedResult.getResultCode();
}

%>
