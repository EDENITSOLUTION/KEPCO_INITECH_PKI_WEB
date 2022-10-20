<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
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
Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;
ResultSet rs2 = null;

Connection conn = null;
Statement stmt = null;
Statement stmt2 = null;

SmsClient sms = null;
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
String CALLBACK = "0613458000"; //15 + 1

String MESSAGE = "";
String RECVPHONE = "" ; 
String EMPNO = "" ; // 8 + 1
String REFCNT = "00000"; // 5 + 1

String SEND_MSG = null ;
String RETURNCODE = "";



	try {
		conn = ds.getConnection();
		stmt = conn.createStatement();
		stmt2 = conn.createStatement();

		String cellQry = "" ;
		
		// 알림 설정
		String noticeGubun = ""; // 알림구분(S : 문자, P : 푸시)
		String noticeDay = "14,7,1"; // 몇일전부터 알림을 보낼껀지...
		cellQry = "SELECT NOTICE_GUBUN, NOTICE_DAY FROM MNG_CONFIG WHERE ROWNUM = 1" ;
		rs = stmt.executeQuery(cellQry);
		while (rs.next()) {
			noticeGubun = rs.getString("NOTICE_GUBUN");
			try {
				noticeDay = rs.getString("NOTICE_DAY");
			} catch (Exception e) {
			}
		}


		sms = new SmsClient();

		cellQry = "" ;
		cellQry = cellQry + "SELECT "; 
		cellQry = cellQry + "		 TO_DATE(TO_CHAR(A.EXPIREDATE, 'YYYYMMDD')) - TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) AS DAY";
		cellQry = cellQry + "		 , A.EXPIREDATE";
		cellQry = cellQry + "		 , B.EMPNO";
		cellQry = cellQry + "		 , B.NAME";
		cellQry = cellQry + "		 , B.CELLNO";

		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					B.CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL1  ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					B.CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL2 ";

		cellQry = cellQry + "		 , C.REPLACE_CELLNO";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					C.REPLACE_CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL3  ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					C.REPLACE_CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL4 ";

		cellQry = cellQry + " FROM ";
		cellQry = cellQry + " LDAP_INFO A ";
		cellQry = cellQry + " LEFT JOIN V_INSA B ON (A.USERID = B.EMPNO) ";
		cellQry = cellQry + " LEFT JOIN MNG_USER C ON (A.USERID = C.USERID AND C.GUBUN = 'E') ";
		cellQry = cellQry + " WHERE 1=1 ";
		cellQry = cellQry + " AND A.STATUS = 'V' ";
		cellQry = cellQry + " AND (TO_DATE(TO_CHAR(A.EXPIREDATE, 'YYYYMMDD')) - TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) in ("+noticeDay+")) ";
		//cellQry = cellQry + " OR A.USERID ='ec180023' ";
		//out.print(cellQry + "<Br>");			
		rs = stmt.executeQuery(cellQry);

		String day = "";
		String expiredate = "";
		String val1 = "";
		String val2 = "";
		String val3 = "";
		String val4 = "";
		String empno = "";
		String name = "";
		String cellno = "";
		String cellno2 = "";
		while( rs.next() ) {
			val1 = rs.getString("VAL1");
			val2 = rs.getString("VAL2");
			val3 = rs.getString("VAL3");
			val4 = rs.getString("VAL4");
			empno = rs.getString("EMPNO");
			name = rs.getString("NAME");
			cellno = rs.getString("CELLNO");
			cellno2 = rs.getString("REPLACE_CELLNO");
			day = rs.getString("DAY");
			expiredate = rs.getString("EXPIREDATE");

			//rs2 = null;
			
			// 사원 핸드폰번호가 올바른지
			if ("ok".equals(val1) || "ok".equals(val2)) {
				cellno = cellno.replace("-", "");
			} else {
				cellno = "";
			}

			// 대신 문자받을 핸드폰번호가 올바른지
			if ("ok".equals(val3) || "ok".equals(val4)) {
				cellno2 = cellno2.replace("-", "");
			} else {
				cellno2 = "";
			}

			if (!"".equals(cellno2)) {
				cellno = cellno2;
			}
			
			if (!"".equals(cellno)) {

				MESSAGE = "[한전 인터넷망]"+name+"("+empno+")님의 인증서 만료일이 "+day+"일 남았습니다.";
				out.print(MESSAGE + "<br>");



				RECVPHONE = cellno;
				EMPNO = empno;

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

				RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);
				

				String q = "";
				q += "	INSERT INTO MNG_LOG_NOTICE ";
				q += "		 (  SEQ";
				q += "		 ,  USERID";
				q += "		 ,  CRDATE";
				q += "		 ,  RETCODE";
				q += "		 ,  SENDPHONE";
				q += "		 ,  USERPHONE";
				q += "		 ,  MESSAGE";
				q += "		 ) ";
				q += "VALUES (  MNGLOGNOTICE_SEQ.NEXTVAL";
				q += "		 ,  '"+empno+"'";
				q += "		 ,  SYSDATE";
				q += "		 ,  '"+RETURNCODE+"'";
				q += "		 ,  '"+CALLBACK+"'";
				q += "		 ,  '"+cellno+"'";
				q += "		 ,  '"+MESSAGE+"'";
				q += "		 )";
				rs2 = stmt2.executeQuery(q);
			}

		}
		
		
	} catch(Exception e) {
		out.print(e.getMessage());
		e.printStackTrace();
	} finally {
		rs.close();
		if (rs2 != null) {
			rs2.close();
		}
		conn.close();
	}


%>
