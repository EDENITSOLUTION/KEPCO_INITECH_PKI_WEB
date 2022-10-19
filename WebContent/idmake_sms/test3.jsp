<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.String.*" %>
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
%>
<%

String SENDIP = "203.248.44.150";
int SENDPORT = 7904;

String CLASSCODE = "IDMKL" ; // 5 + 1
int iCLASSCODE = 5 ;
String PASSWORD = "DIST"; // 4 + 1
int iPASSWORD = 4 ;
String KEY = "000000000000001";//15 + 1
int iKEY = 15 ;
String KEY1 = "000000000000001";//15 + 1
int iKEY1 = 15 ;
String KEY2 = "000000000000001";//15 + 1
int iKEY2 = 15 ;
String RECVPHONE = "01099117557"; //15 + 1 
int iRECVPHONE = 15 ;
String CALLBACK = "0234561166"; //15 + 1
int iCALLBACK = 15 ;
String MESSAGE = "[한국전력공사] 인증센터 인증서 발급용 인증번호는 [000000]입니다."; //80 + 1
int iMESSAGE = 80 ;
String EMPNO = "jekyung8"; // 8 + 1
int iEMPNO = 8 ;
String REFCNT = "00001"; // 5 + 1
int iREFCNT = 5 ;


Locale locale = java.util.Locale.KOREA;
SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale);
String convertedTime = sdfr.format(new Date());

KEY = convertedTime;
KEY1 = convertedTime;
KEY2 = convertedTime;

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




//MESSAGE = new String(MESSAGE.getBytes("KSC5601"), "UTF-8");

////////////////////////////////////////////////////
//  수신 코드 ///////////////////////////////////
String RETURNCODE = "2000";
////////////////////////////////////////////////////
//1. 9999 : 성공(메세지 정상 처리)
//2. 1000 : SMS 프로세스 오류(SMS 데몬 프로세스가 정지됐을 경우)
//3. 1001 : 전송 데이터형식 오류(전송 데이터형식이 규정에 맞지 않을 경우)
//4. 1002 : 서버간 전송시간 초과 오류(서버간 연결 후 일정시간동안 데이터 송수신이 이루어지지 않을 경우)
//5. 1100 : 데이터베이스 접속 오류(데이터베이스가 정지되었가나 동시 접속이 많을 경우)
//6. 1101 : 데이터베이스 Query 오류(데이터베이스 Query 및 데이터 형식에 맞게 수신한 후 데이터베이스 검색시 잘못된 경우);
//7. 1200 : 사업소 서비스 오류 (사업소 코드가 잘못된 경우)
//8. 2000 : 보내는쪽 소켓통신 오류


//SMS발송을 위한 클라이언트 객체 생성
SmsClient sms = new SmsClient();
RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);

String tempPhone = "01099117557";

String RefMsg = "KEPCO-SSO 인증서발급용 인증번호요청알림 : "+ tempPhone ;


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
<title>Insert title here</title>
</head>
<body>

-리턴코드 : <%=RETURNCODE%><br />
- RefMsg : <%=RefMsg%><br />
- RefMsg length : <%=RefMsg.length()%><br />
- RefMsg byte length : <%=RefMsg.getBytes().length%><br />

</body>
</html>
