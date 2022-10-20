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
String strIsInsa = request.getParameter("strIsInsa"); //SMS인사정보 연동 유무
if (strIsInsa.equals("") || strIsInsa == null) {
	strIsInsa = "N"; //default는 연동하지 않음
}

String empno = request.getParameter("empno"); //사번
String tmid = request.getParameter("tmid");//타임아이디
String refuserid = request.getParameter("refuserid");//참조자 또는 대신 받을 직원 사번
String orguserpw = request.getParameter("orguserpw");
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
	writer.println("alert('PUSH인증을 위한 사번 및 전화번호가 누락되어 전달되었습니다.');");
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
String orgInsaOrgEmail = "" ; //인사정보에 실제로 등록된 메일아이디(180717 njjang 추가)
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
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
ResultSet rs = null;
Connection conn = null;
Statement stmt = null;

try{
	//사번이 인사정보에 존재하는지 체크
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
		writer.println("alert('입력하신 사번("+ empno +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("location.href='apppushform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // 사용자 정보 존재할때				
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


		//연락처가 제대로 등록이 안된 경우

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
		writer.println("alert('입력하신 사번("+ refuserid +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("location.href='apppushform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
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


		//연락처가 제대로 등록이 안된 경우

		if (refSendFmatPhone.equals("x")  ){
			isChk = "N" ;
			strMsg = "인사정보에 등록된 올바른 사번이나 해당 사용자의 연락처가\\n정상적으로 등록되지 않았습니다.\\n사용자 정보(사번) : "+ refUserName +"("+ refuserid +")\\n등록된 연락처 : "+ refInsaOrgPhone ;
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
//refSendFmatPhone = "010-3089-0929"; // 대리발급자
//orgSendFmatPhone = "010-3089-0929"; // 본인
//orgInsaOrgEmail = "like_eh@nate.com";
if (isNoPhoneUser.equals("N")) { // 핸드폰 번호가 정상적으로 등록된 사용자가 아닐 경우
		//발급받고자 하는 사용자의 핸드폰 번호가 정상적으로 등록되지 않았을 경우는 
		//대리발급으로 간주하는것으로 변경	
		sendCnt = "00002";
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
			writer.println("alert('발급받을 사원의 비밀번호가 일치하지 않습니다.');");
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
//SMS인증번호 만들기 START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);
String strMsgText ="[한전 인터넷망]"+ orgUserName + "("+ empno +")님의 인증서 발급용 인증번호 : "+certkey;

if (empno.equals(refuserid)){
	 strMsgText = strMsgText;
 }else{
	 strMsgText = "[한전 인터넷망]"+ refUserName + "(" + refuserid + ")님이 인증서 대리발급을 요청하였습니다." ;
 }
//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

String RefSendMsg = "KEPCO-SSO 인증서발급용 인증번호요청알림 : "+ phone1 + "-" + phone2 + "-" + phone3  ;
//RefSendMsg = "KEPCO-SSO 인증번호요청알림\n요청번호:"+ sendPhone +"("+ refUserName +")";
RefSendMsg = "[한전 인터넷망]"+ orgUserName + "("+ empno +")님의 인증서 발급용 인증번호 : "+ certkey ;


String RECVPHONE = sendPhone ; 
String REFPHONE = org_phone;
String RETURNCODE = "9999";


	sendPush(RECVPHONE, strMsgText);
	if (sendCnt.equals("00002")) {
		sendPush(REFPHONE, RefSendMsg);
		sendSMS(empno, REFPHONE, strMsgText);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
	
	alert("인증번호를 PUSH 발송하였습니다.\n\n전송받으신 인증번호를 입력하십시오.");
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
