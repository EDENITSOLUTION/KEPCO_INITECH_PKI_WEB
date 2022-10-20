<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.util.Date.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="kepco.*" %>
<%!
//SendMSG만들기
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
			MsgStr = "인증센터 발송 모듈 오류";
	}else if (MsgCode.equals("9999")) {
			MsgStr = "성공";
	}else if (MsgCode.equals("1000")) {
			MsgStr = "SMS 프로세스 오류(SMS 데몬 프로세스 정지)";
	}else if (MsgCode.equals("1001")) {
			MsgStr = "전송 데이터형식 오류";
	}else if (MsgCode.equals("1002")) {
			MsgStr = "서버간 전송시간 초과 오류";
	}else if (MsgCode.equals("1100")) {
			MsgStr = "데이터베이스 접속 오류 또는 동시 접속 과다";
	}else if (MsgCode.equals("1101")) {
			MsgStr = "데이터베이스 Query 오류";
	}else if (MsgCode.equals("1200")) {
			MsgStr = "사업소 서비스 오류 (잘못된 사업소 코드 전송)";
	}else if (MsgCode.equals("2000")) {
			MsgStr = "인증센터 발송 모듈 오류";
	}else {
			MsgStr = "성공";
	
	}
	return MsgStr ;
}

public String sendSMS(String userId, String cellNo, String message) {

	////////////////////////////////////////////////////
	//1. 9999 : 성공(메세지 정상 처리)
	//2. 1000 : SMS 프로세스 오류(SMS 데몬 프로세스가 정지됐을 경우)
	//3. 1001 : 전송 데이터형식 오류(전송 데이터형식이 규정에 맞지 않을 경우)
	//4. 1002 : 서버간 전송시간 초과 오류(서버간 연결 후 일정시간동안 데이터 송수신이 이루어지지 않을 경우)
	//5. 1100 : 데이터베이스 접속 오류(데이터베이스가 정지되었가나 동시 접속이 많을 경우)
	//6. 1101 : 데이터베이스 Query 오류(데이터베이스 Query 및 데이터 형식에 맞게 수신한 후 데이터베이스 검색시 잘못된 경우);
	//7. 1200 : 사업소 서비스 오류 (사업소 코드가 잘못된 경우)
	//8. 2000 : 보내는쪽 소켓통신 오류

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

	String EMPNO = userId;

	// 사용자의 핸드폰 번호가 정상적으로 등록안되었으므로 
	//String RECVPHONE = orgSendFmatPhone.replace("-","");
	String RECVPHONE = cellNo ; 
	RECVPHONE = RECVPHONE.replace("-","");

	String CALLBACK = "0613458000"; //15 + 1
	String MESSAGE = message ; //80 + 1

	//if (sendCnt.equals("00002")){
	  // MESSAGE = "[한전 인터넷망]"+ refUserName + "("+refuserid+")님이 인증서 대리 발급을 요청하였습니다.";
	//}
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
	//  수신 코드 ///////////////////////////////////
	String RETURNCODE = "2000";
	String RETURNMSG = "" ;


	//SMS발송을 위한 클라이언트 객체 생성
	SmsClient sms = new SmsClient();
	RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);

	RETURNCODE = RETURNCODE.trim();
	RETURNMSG = rtnMessage(RETURNCODE);

	return RETURNCODE;
}
%>
