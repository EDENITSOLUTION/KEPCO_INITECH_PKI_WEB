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

//1. 9999 : 성공(메세지 정상 처리)
//2. 1000 : SMS 프로세스 오류(SMS 데몬 프로세스가 정지됐을 경우)
//3. 1001 : 전송 데이터형식 오류(전송 데이터형식이 규정에 맞지 않을 경우)
//4. 1002 : 서버간 전송시간 초과 오류(서버간 연결 후 일정시간동안 데이터 송수신이 이루어지지 않을 경우)
//5. 1100 : 데이터베이스 접속 오류(데이터베이스가 정지되었가나 동시 접속이 많을 경우)
//6. 1101 : 데이터베이스 Query 오류(데이터베이스 Query 및 데이터 형식에 맞게 수신한 후 데이터베이스 검색시 잘못된 경우);
//7. 1200 : 사업소 서비스 오류 (사업소 코드가 잘못된 경우)
//8. 2000 : 보내는쪽 소켓통신 오류
////////////////////////////////////////////////////
%>
<%
String strIsInsa = request.getParameter("strIsInsa"); //SMS인사정보 연동 유무
if (strIsInsa.equals("") || strIsInsa == null) {
	strIsInsa = "N"; //default는 연동하지 않음
}

String empno = request.getParameter("empno"); //사번
String tmid = request.getParameter("tmid");//타임아이디
String seq = "" ;
String strSql = "" ;
String org_phone = request.getParameter("org_phone"); //DB에 저장된 번호
String userName = request.getParameter("userName"); // 사용자명

String phone1 = request.getParameter("phone1"); //직접 입력한 번호1
String phone2 = request.getParameter("phone2"); //직접 입력한 번호2
String phone3 = request.getParameter("phone3"); //직접 입력한 번호3
String phone = phone1 + "-" + phone2 + "-" + phone3 ; //연락처 조합

String orgPhone = org_phone.replace("-","");
String sendPhone = phone1 + phone2 + phone3 ; //연락처 조합

String sendCnt = "00001"; //보내야할 SMS전송 수

//validation check
if (empno.equals("") || empno==null || phone1.equals("") || phone1==null || phone2.equals("") || phone2==null || phone3.equals("") || phone3==null || tmid.equals("") || tmid==null ){
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('SMS인증을 위한 사번 및 전화번호가 누락되어 전달되었습니다.');");
	writer.println("location.href='websmsform.jsp';");
	writer.println("</script>");
	writer.flush();
	return;
} // end of check all of validation 


//SMS seq make
seq = tmid + "_" + empno + "_" + request.getRemoteAddr() ; // 20140709172427_ex099129_255.255.255.255


int cnt_user = 0 ; // 사번에 해당하는 사용자 존재 유무(0:없음, 그외 존재)

int phoneLen = 0 ;

if (orgPhone.equals(sendPhone)){//인사테이블에 저장된 전화번호와 입력한 전화번호가 같을때는 한번만 보냄
	sendCnt = "00001";
}else{
	if (org_phone.equals("010-0000-0000")) { //인사정보에 연락처 등록이 안됨..이거 어케처리할지
		sendCnt = "00001";
	}else{
		sendCnt = "00002";//인사테이블에 저장된 전화번호와 입력한 전화번호가 다르면 두번 발송
	}
}

//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);
String strMsgText ="[한국전력공사] 인터넷망 인증서 발급용\n인증번호는 ["+certkey+"]입니다.";
//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////




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

String RECVPHONE = sendPhone ;//("01099117557" 15 + 1) 
String REFPHONE = org_phone;

String CALLBACK = "0234561166"; //15 + 1
String MESSAGE = strMsgText ; //80 + 1
String EMPNO = empno ; // 8 + 1
String REFCNT = "00001"; // 5 + 1



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



String strRef = "2000";
String RefMsg = "KEPCO-SSO 인증서발급용 인증번호요청알림 : "+ phone1 + "-" + phone2 + "-" + phone3  ;
String RefKey = KEY + "1" ;

String RefSMSMsg = "";
if (sendCnt.equals("00002")) {
	//전화번호가 다를때는 원 사용자 전화번호로 메세지 리턴하자
	RefSMSMsg = fillSpace(CLASSCODE, iCLASSCODE) + (char)0 ;	
	RefSMSMsg = RefSMSMsg + fillSpace(PASSWORD, iPASSWORD) + (char)0 ;	
	RefSMSMsg = RefSMSMsg + fillSpace(RefKey, iKEY) + (char)0 ;	
	RefSMSMsg = RefSMSMsg + fillSpace(orgPhone, iRECVPHONE) + (char)0 ;	
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


//SMS발송을 위한 클라이언트 객체 생성
SmsClient sms = new SmsClient();
RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);

RETURNCODE = RETURNCODE.trim();
RETURNMSG = rtnMessage(RETURNCODE);


if (sendCnt.equals("00002")) {
	strRef = sms.SendSMS(SENDIP, SENDPORT, RefSMSMsg).trim();
}

//SMS정보 db insert
Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
//ResultSet rsu = null;

Connection connu = null;
//Statement stmtu = null;
PreparedStatement pstmtu = null;

strSql = "INSERT INTO SMS_LOG ( SEQ, USERID, USERIP, SMSNUM, RETCODE)  VALUES ( '"+ seq +"', '"+ empno +"', '"+ request.getRemoteAddr() +"', '"+ certkey +"', '"+ RETURNCODE +"' )" ;


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
<title>SMS 인증하기</title>
<script  type="text/javascript" language="javascript">
function  fncConfirm() {
<% 
if (RETURNCODE.equals("99991001")) { //정상
%>
	alert("[<%=RETURNMSG%>]SMS인증번호를 전송하였습니다.\n\n전송받으신 인증번호를 입력하십시오.");
	//opener.readForm.smschk.value="<%=certkey%>";
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("9999")) { //전송데이터형식
%>
	alert("[<%=RETURNMSG%>]SMS인증번호를 전송하였습니다.\n\n전송받으신 인증번호를 입력하십시오.");
	//opener.readForm.smschk.value="<%=certkey%>";
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("1001")) { //전송데이터형식 오류지만 잠시 스킵
%>
	alert("[<%=RETURNMSG%>]SMS입력란에 <%=certkey%>을(를) 입력하십시오.");
	//opener.readForm.smschk.value="<%=certkey%>";
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();	
<%
}else{
%>
	
	alert("[<%=RETURNMSG%>]SMS인증번호를 전송하였습니다.\n\n전송받으신 인증번호를 입력하십시오.");
	//opener.readForm.smschk.value="<%=certkey%>";
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
orgPhone : <%=orgPhone%><br />
sendPhone : <%=sendPhone%><br />
REFCNT : <%=REFCNT%><br /> -->
</body>
</html>