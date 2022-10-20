<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="com.daou.smartpush.service.message2.Message" %>
<%@ page import="com.daou.smartpush.service.result.Result" %>
<%@ page import="com.daou.smartpush.service.send.Sender" %>
<%@ page import="com.daou.smartpush.util.contents.ConfirmUse" %>
<%@ page import="com.daou.smartpush.util.contents.Contents" %>

<%
	//String HOST = "https://203.248.44.215:35000/server";	// 배포 : 푸시 서버 Host 명 - 개발서버 http://211.223.60.10:35000/server	
	String HOST = "http://203.248.44.215:35001/server";
	String APP_KEY 	= "dR/hxv3BZg22gCVzl6YDFwkPhWY=";	// 배포 : 발송 앱 Key
	String USER_ID 	= "kepco123";						// 배포 : 계정 ID
	String USER_PW 	= "powernet!@";						// 배포 : 계정 PWD
	String LOG_PATH 	= "/home/kdnadmin/initech";						// 입력 : log파일 경로
	String CALL_PHONE 	= "0613458000";					// 입력 : 발신자 전화번호 
	String LEGACY_CODE = "IDNTN";							// 입력 : 업무코드
	String SEND_MESSAGE = "인터넷망 푸시 발송  메세지2";				// 입력 : 발송 메시지
	
	String PUSH_KEY1 	= "PUSH1100000012";					// 테스트 코드 : 고유키 #1
	String PUSH_PHONE1	= "01088686268";					// 테스트 코드 : 수신자 전화번호 #1


		//-----------------------------------------
		//Smartpush 서버에게 요청을 하기위한 Sender 객체 생성
		//기능 : 총 4가지
		//      1. Auth Key 요청
		//      2. Braodcast 발송요청
		//      3. Named 발송 요청
		//      4. 예약 발송 요청
		//      5. Solution용 Named 발송 요청
		
		//발송 객체 생성
		//Sender 객체 생성시 필요 매개변수
		//첫번째 : Smartpush 서버 Host 명
		//두번째 : Log File 적재 될 Path(해당 Path는 존재 하여야 한다.)
		Sender sender = new Sender(HOST, LOG_PATH);

		//------------------------------------------
		// 1. AuthKey 요청
		
		// 1-1. 요청 메세지 구성
		// Message             : 모든 요청 메세지를 구성 하기위한 객체
		// newAuthKeyMessage() : Auth Key 요청 메세지 생성 메서드
		// .userId()           : Auth Key 요청을 받기 위한 등록 계정 ID
		// .pwd()              : Auth Key 요청을 받기 위한 등록 계정 Password
		String authRequestMsg = Message.newAuthKeyMessage()
				.userId(USER_ID)
				.pwd(USER_PW).build();
		
		// 1-2. 실제 요청 및 결과 받기
		// 요청시 Sender 의 sendAuthKey메서드를 이용하여 호출
		// Result 객체에 결과값이 세팅되어 반환된다.
		// .sendAuthKey() : 생성한 Sender 객체 내부 메서드. Auth Key 요청을 담당하는 메서드
		Result authResult = sender.sendAuthKey(authRequestMsg);
		
		//결과 객체 및 제공 메서드
		//Result : 발송 결과를 보유하고 있는 객체
		//.getResultCode()   : 요청 결과 Code 반환 메서드
		//.getResultMsg()    : 요청 결과 Message 반환 메서드 
		//.getAuthKey()      : AuthKey 요청 성공시 발급 된 Auth Key 반환 메서드
		//.getMsgTag()       : 발송 요청 성공시 발급된 Message Tag 반환 메서드
		//.getInvalidId      : Named 발송 요청시 요청한 ID중 없는 ID 목록 반환 메서드
		out.println("ResultCode : " + authResult.getResultCode()
				+ "\n Result Message : " + authResult.getResultMsg()
				+ "\n AuthKey : " + authResult.getAuthKey());
		
		// 5. Named Package Push
		
		// 5-1. named 준비 과정
		
		// 5-2. 요청 메세지 구성
		// Message               : 모든 요청 메세지를 구성 하기위한 객체
		//.newNamdMessage() : Named 발송 요청 메세지 생성 메서드
		//.authKey()             : 전달 받은 Auth Key 세팅 메서드. Auth Key 요청시 받은 Result의 .getAuthKey()를 이용하면 된다.
		//.appkey()              : 발송을 위해 등록한 서비스의 Appkey 세팅 메서드
		//.message()             : 발송하려는 내용 세팅 메서드
		//.pushType()            : 발송하려는 발송사 타입 세팅 메서드. Contents 객체를 통해 key 제공(all / apns / gcm / hydro)
		//                       : all   - Contents.PAYLOAD_PUSHTYPE_ALL
		//      				 : apns  - Contents.PAYLOAD_PUSHTYPE_APNS
		//      				 : gcm   - Contents.PAYLOAD_PUSHTYPE_GCM
		//      				 : hydro - Contents.PAYLOAD_PUSHTYPE_HYDRO
		//.sendType()            : 발송 형태 세팅 메서드. Contents 객체를 통해 key 제공 (normal : 일반 푸시 / rich : Rich 푸시)
		//      				 : normal - Contents.PAYLOAD_SENDTYPE_NORMAL
		//      				 : rich   - Contents.PAYLOAD_SENDTYPE_RICH
		//.receiveType()         : named 목록 타입 세팅 메서드. Contents 객체를 통해 key 제공 (id : 특정 ID / maddress : 디바이스 Mac-Address)
		//                       : id        - Contents.PAYLOAD_RECEIVETYPE_ID
		//                       : maddress  - Contents.PAYLOAD_RECEIVETYPE_MADDRESS
		//.targetList()			 : 발송하려는 ID 세팅 메서드. ArrayList (id 또는 Mac-Address , PhoneNum)으로 보내준다.
		//.cutOption()           : 메세지가 제한 길이 이상인경우 Smartpush에서 절삭 할지 여부 세팅 메서드. Contents 객체를 통해 Key 제공(y : 절삭 허용 / n : 절삭 미허용)
		//      				 : y      - Contents.PAYLOAD_CUTOPTION_YES
		//      				 : n      - Contents.PAYLOAD_CUTOPTION_NO
		//.confirmUse(필수값 아님)	 : Android 단말기 발송 후 수신확인 체크 Rseponse가 오지 않은 단말기에 대하여 SMS 우회 발송 여부
		//					     : y      - 기능 사용
		//						 : n      - 기능 사용 않함
		//.confirmTimeout(필수값 아님): confirm기능 사용시 발송 메세지에 대하여 SMS 우회 발송 여부 Timeout 시간 , 입력한 시간 이내에 수신확인 체크가 오지 않으면 SMS 우회 발송( 단위 : 분)
		//.option()              : 추가 적인 옵션값 세팅 메서드. 해당값으로 Client Device에서 특정 동작을 조작할수 있는 값.(key,value)로 설정

		/* ----------------------------------------------------- */
		// 테스트 코드 : 수신자 입력 -- 수신자 수만크 loop 적용하여 입력필요
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
			out.println("Named Package Message Setting Error");
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
		out.println("ResultCode : " + namedResult.getResultCode()
				+ "\n msgTag : " + namedResult.getMsgTag()
				+ "\n Result Message : " + namedResult.getResultMsg()
				+ "\n Invalid ID : " + namedResult.getInvalidId());

%>
