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
String refuserid = request.getParameter("refuserid");//참조자 또는 대신 받을 직원 사번 
String seq = "" ;
String strSql = "" ;

String phone1 = request.getParameter("phone1"); //직접 입력한 번호1
String phone2 = request.getParameter("phone2"); //직접 입력한 번호2
String phone3 = request.getParameter("phone3"); //직접 입력한 번호3


String org_phone = "" ; //request.getParameter("org_phone"); //DB에 저장된 번호
String sendPhone = "" ; //phone1 + phone2 + phone3 ; //연락처 조합

String sendCnt = "00001"; //보내야할 SMS전송 수

//check validation
if (empno.equals("") || empno==null || tmid.equals("") || tmid==null || refuserid.equals("") || refuserid==null ){
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('SMS인증을 위한 사번 및 전화번호가 누락되어 전달되었습니다.');");
	writer.println("location.href='websmsform.jsp';");
	writer.println("</script>");
	writer.flush();
	return;
} // end of check all of validation 

int cnt_user = 0 ; // 사번에 해당하는 사용자 존재 유무(0:없음, 그외 존재)
String isChk = "Y"; // 인사정보에 연락처가 제대로 등록안되었을 경우 플래그
String cellQry = "" ;
String strMsg = "" ;


String orgInsaOrgPhone = "" ; //인사정보에 실제로 등록된 전화번호
String orgSendFmatPhone = "x" ; //SMS전송을 위해 포맷변경된 전화번호
String orgUserName = "" ; //전달하고자하는 사번 사용자의 이름

String refInsaOrgPhone = "" ; //인사정보에 실제로 등록된 전화번호
String refSendFmatPhone = "x" ; //SMS전송을 위해 포맷변경된 전화번호
String refUserName = "" ; //전달하고자하는 사번 사용자의 이름

String isNoPhoneUser = "Y" ; //인사정보에 핸드폰이 잘못된 사용자 인지 체크
String NoPhoneUserNum = "x" ;
String strRefUserID = empno ;
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//////////// 사번으로 사용자 연락처 검색 Start //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/INSA");
ResultSet rs = null;
Connection conn = null;
Statement stmt = null;

try{
	//사번이 인사정보에 존재하는지 체크
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();


	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM IRIS.V_INSA WHERE EMPNO ='"+ empno +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isChk = "N" ;
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('입력하신 사번("+ empno +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("location.href='websmsform3.jsp?empno="+ empno +"&tmid="+ tmid +"'");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // 사용자 정보 존재할때				
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
		cellQry = cellQry + "	FROM  IRIS.V_INSA ";
		cellQry = cellQry + "	WHERE EMPNO = '"+ empno +"' ";
		cellQry = cellQry + ") X ";
						
		
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
			orgSendFmatPhone = rs.getString("PHONENUM");
			orgInsaOrgPhone = rs.getString("CELLNO");
			orgUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//연락처가 제대로 등록이 안된 경우

		if (orgSendFmatPhone.equals("x")  ){
			isNoPhoneUser = "N" ;
		}else{
			isChk = "Y" ;			
		}
	}


	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM IRIS.V_INSA WHERE EMPNO ='"+ refuserid +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isChk = "N" ;
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('입력하신 사번("+ refuserid +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("location.href='websmsform3.jsp?empno="+ empno +"&tmid="+ tmid +"'");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // 사용자 정보 존재할때				
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
		cellQry = cellQry + "	FROM  IRIS.V_INSA ";
		cellQry = cellQry + "	WHERE EMPNO = '"+ refuserid +"' ";
		cellQry = cellQry + ") X ";
						
		
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
			refSendFmatPhone = rs.getString("PHONENUM");
			refInsaOrgPhone = rs.getString("CELLNO");
			refUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//연락처가 제대로 등록이 안된 경우

		if (refSendFmatPhone.equals("x")  ){
			isChk = "N" ;
			strMsg = "인사정보에 등록된 올바른 사번이나 해당 사용자의 연락처가\\n정상적으로 등록되지 않았습니다.\\n사용자 정보(사번) : "+ refUserName +"("+ refuserid +")\\n등록된 연락처 : "+ refInsaOrgPhone ;
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('"+ strMsg +"');");
			writer.println("location.href='websmsform3.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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
//////////// 사번으로 사용자 연락처 검색 End ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


//make SMS seq 
seq = tmid + "_" + empno + "_" + request.getRemoteAddr() ; // 20140709172427_ex099129_255.255.255.255


/////////////////////////////////////////////////////////////////////////////////////////
////1. 연락처 비정상 등록
////   case 1 )  empno != refuserid
////             - 한번만 발송
////2. 연락처 정상 등록
////   case 2) empno = refuserid  REFUSERID
////		     - 한번만 발송
////   case 3) empno != refuserid
////             - 두번 발송
////	       a. 인증코드 발송 : smsphonenum = refuserid phone
////	       b. 확인코드 발송 : smsphonenum = empno phone
/////////////////////////////////////////////////////////////////////////////////////////

if (isNoPhoneUser.equals("N")) { // 핸드폰 번호가 정상적으로 등록된 사용자가 아닐 경우
	sendCnt = "00001"; //핸드폰도 정상적으로 등록안되었으니 다른 사용자에게 알림 메세지 보낼수없으니 한번
	sendPhone = refSendFmatPhone.replace("-","");
	org_phone = refSendFmatPhone.replace("-","");
	strRefUserID = refuserid ;
}else{ // 핸드폰 번호가 정상적으로 등록되었을 경우의 사용자
	if (empno.equals(refuserid)){//실제 사용자 사번과 받는 사용자 사번이 같을 때(사용자 변경안한 Default 상태)
		sendCnt = "00001"; 
		sendPhone = orgSendFmatPhone.replace("-","");
		org_phone = orgSendFmatPhone.replace("-","");
		strRefUserID = empno ;
	}else{ //사번변경해서 보낼때
		sendCnt = "00002";
		sendPhone = refSendFmatPhone.replace("-","");
		org_phone = orgSendFmatPhone.replace("-","");
		strRefUserID = refuserid ;
	}
}


//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);
String strMsgText ="[한국전력공사] 인터넷망 인증서 발급용 인증번호는 ["+certkey+"]입니다.";
//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

String RefSendMsg = "KEPCO-SSO 인증서발급용 인증번호요청알림 : "+ phone1 + "-" + phone2 + "-" + phone3  ;
RefSendMsg = "KEPCO-SSO 인증번호요청알림\n인증번호:"+ certkey +"\n요청번호:"+ sendPhone +"("+ orgUserName +")";




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

String CALLBACK = "0234568000"; //15 + 1
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
String RefMsg = RefSendMsg ;
String RefKey = KEY + "1" ;

String RefSMSMsg = "";
if (sendCnt.equals("00002")) {
	//전화번호가 다를때는 원 사용자 전화번호로 메세지 리턴하자
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
<title>SMS 인증하기</title>
<script  type="text/javascript" language="javascript">
function  fncConfirm() {
<% 
if (RETURNCODE.equals("99991001")) { //정상
%>
	alert("[<%=RETURNMSG%>]SMS인증번호를 전송하였습니다.\n\n전송받으신 인증번호를 입력하십시오.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("9999")) { //전송데이터형식
%>
	alert("[<%=RETURNMSG%>]SMS인증번호를 전송하였습니다.\n\n전송받으신 인증번호를 입력하십시오.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("1001")) { //전송데이터형식 오류지만 잠시 스킵
%>
	alert("[<%=RETURNMSG%>]SMS입력란에 <%=certkey%>을(를) 입력하십시오.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();	
<%
}else{
%>
	
	alert("[<%=RETURNMSG%>]SMS인증번호를 전송하였습니다.\n\n전송받으신 인증번호를 입력하십시오.");
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
