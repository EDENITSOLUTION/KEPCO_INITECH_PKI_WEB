<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.util.Date.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="kepco.*" %>
<%!
 public String sendSMS(String strCertGb, String userId, String strTmid) {
	
	String resultCd = null ; //결과코드
	int cnt_user = 0 ; //사용자 존재 유무
	int cnt_log_user = 0 ; //인증서발급시 사용자 존재 유무
	String userName = null ; //사용자명
	String userPhone = null ; //사용자 전화번호
	String userMail = null ; //사용자 이메일
	
	String strMyPhoneNum = null;
	String strMyRefPhoneNum = null;
	
	String strMsgText = null; //SMS발송메세지
        String strMsgText = null;
	String strMakingText = null;
	String strMakingText1 = null;
	String REFPHONE = null ;
	
	String userTmid = "";
	String userSmsSeq = "";
	
	String SENDIP = "203.248.44.150";
	int SENDPORT = 7904;
	////////////////////////////////////////////////////
	//수신 코드 ///////////////////////////////////
	String RETURNCODE = "2000";
	String RETURNMSG = "" ;
	
	//인증서발급시 SMS로그 정보
	String strSeq = "";
	String strUserid ="";
	String strUserip = "";
	String strCrdate = "";
	String strSmsnum = "";
	String strRetcode = "";
	String strUserphone = "";
	String strRefuserid = "";
	
	
	
	try{
		//step1. userId로 사용자 정보 조회
		Context ctSms = new InitialContext();
		DataSource dsSms = (DataSource) ctSms.lookup("java:comp/env/jdbc/USERS");
		ResultSet rsSms = null;
		Connection conSms = null;
		Statement stmtSms = null;
		String smsQry = null;	
		
		//사번이 인사정보에 존재하는지 체크
		conSms = dsSms.getConnection();
		//Creat Query and get results
		stmtSms = conSms.createStatement();

		rsSms = stmtSms.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ userId +"'");
		while (rsSms.next()){
			cnt_user = rsSms.getInt("cnt");
		}
		if (cnt_user == 0){
			resultCd = "SEND-NO";
		}else{ // 사용자 정보 존재할때				
			smsQry = "" ;
			smsQry = smsQry + "SELECT "; 
			smsQry = smsQry + "		X.EMPNO ";
			smsQry = smsQry + "	,	X.USER_NAME ";
			smsQry = smsQry + "	,   X.CELLNO ";
			smsQry = smsQry + "	,	X.VAL1 ";
			smsQry = smsQry + "	,	X.VAL2 ";
			smsQry = smsQry + "	,( ";
			smsQry = smsQry + "		CASE WHEN X.VAL1 = 'ok' THEN X.CELLNO ";
			smsQry = smsQry + "		ELSE ";
			smsQry = smsQry + "			CASE WHEN X.VAL2 = 'ok' THEN  ";
			smsQry = smsQry + "				CASE WHEN LENGTH(X.CELLNO) = 10 THEN ";
			smsQry = smsQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,3) ";
			smsQry = smsQry + "					|| '-' || SUBSTR(X.CELLNO,7,4) ";
			smsQry = smsQry + "				ELSE ";
			smsQry = smsQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,4) ";
			smsQry = smsQry + "					|| '-' || SUBSTR(X.CELLNO,8,4) ";
			smsQry = smsQry + "				END ";
			smsQry = smsQry + "			ELSE 'x' ";
			smsQry = smsQry + "			END ";
			smsQry = smsQry + "		END ";
			smsQry = smsQry + "	) AS PHONENUM ";
			smsQry = smsQry + "	, X.MAILADDR ";
			smsQry = smsQry + " FROM ( ";
			smsQry = smsQry + "	SELECT ";
			smsQry = smsQry + "		EMPNO ";
			smsQry = smsQry + "		, NAME AS USER_NAME ";
			smsQry = smsQry + "		, CELLNO ";
			smsQry = smsQry + "		, DECODE ( ";
			smsQry = smsQry + "			REGEXP_REPLACE(  ";
			smsQry = smsQry + "				REGEXP_SUBSTR(  ";
			smsQry = smsQry + "					CELLNO,  ";
			smsQry = smsQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
			smsQry = smsQry + "					1 ";
			smsQry = smsQry + "				), '[^0-9]', '-' ";
			smsQry = smsQry + "			)  ";
			smsQry = smsQry + "		, '','x','ok') VAL1  ";
			smsQry = smsQry + "		, DECODE ( ";
			smsQry = smsQry + "			REGEXP_REPLACE(  ";
			smsQry = smsQry + "				REGEXP_SUBSTR(  ";
			smsQry = smsQry + "					CELLNO,  ";
			smsQry = smsQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
			smsQry = smsQry + "					1 ";
			smsQry = smsQry + "				), '[^0-9]', '-' ";
			smsQry = smsQry + "			)  ";
			smsQry = smsQry + "		, '','x','ok') VAL2 ";
			smsQry = smsQry + "    , MAILNO ";
			smsQry = smsQry + "			 ,( ";
			smsQry = smsQry + "    CASE WHEN MAILNO IS NULL THEN 'x' ";
			smsQry = smsQry + "    ELSE ";
			smsQry = smsQry + "		CASE INSTR(MAILNO,'@',1)  ";
			smsQry = smsQry + "			WHEN 0 THEN MAILNO || '@kepco.co.kr' ";
			smsQry = smsQry + "       ELSE MAILNO ";
			smsQry = smsQry + "       END ";
			smsQry = smsQry + "     END ";
			smsQry = smsQry + "    ) AS MAILADDR ";
			smsQry = smsQry + "	FROM  V_INSA ";
			smsQry = smsQry + "	WHERE EMPNO = '"+ userId +"' ";
			smsQry = smsQry + ") X ";
							
			
			rsSms = stmtSms.executeQuery(smsQry);
			
			while (rsSms.next()){
				userMail = rsSms.getString("MAILADDR");
				userPhone = rsSms.getString("PHONENUM").replace("-","");;
				userName = rsSms.getString("USER_NAME");
			}
			resultCd = "SEND-YES";
			
			strMyPhoneNum = userPhone ;//("01099117557" 15 + 1) 
			strMyRefPhoneNum = userPhone;
			
			//RECVPHONE = userPhone ;//("01099117557" 15 + 1) 
			//REFPHONE = userPhone;
			
			cnt_user = 1;
		}

		rsSms.close();
		stmtSms.close();
		conSms.close();
		
	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
	}	
	if (resultCd.equals("SEND-YES")) {
		
		//SMS발송을 위한 클라이언트 객체 생성
		SmsClient sms = new SmsClient();
		
		if (strCertGb.equals("certNew")){ //인증서 발급 후
			userTmid = strTmid;
			userSmsSeq = userTmid + "_" + userId ;// + "_" + request.getRemoteAddr() ; // 20140709172427_ex099129_255.255.255.255;
			
			try{
				Context ctNew = new InitialContext();
				DataSource dsNew = (DataSource) ctNew.lookup("java:comp/env/jdbc/USERS");
				ResultSet rsNew = null;
				Connection conNew = null;
				Statement stmtNew = null;
				String newQry = null;
				String newQry1 = null;
				newQry = "select count(*) as cnt from sms_log where seq like '"+ userSmsSeq +"%'";
				newQry1 = "select seq, userid, userip, crdate, smsnum, retcode, userphone,refuserid ";
				newQry1 = newQry1 + " from sms_log where seq like '"+ userSmsSeq +"%'";
				
				conNew = dsNew.getConnection();
				//Creat Query and get results
				stmtNew = conNew.createStatement();
	
				rsNew = stmtNew.executeQuery(newQry);
				while (rsNew.next()){
					cnt_log_user = rsNew.getInt("cnt");
				}
				if (cnt_log_user == 0){
					resultCd = "SEND-NO";
				}else{ // 사용자 정보 존재할때				
					rsNew = stmtNew.executeQuery(newQry1);				
					while (rsNew.next()){
						strSeq = rsNew.getString("seq");
						strUserid = rsNew.getString("userid");
						strUserip = rsNew.getString("userip");
						strCrdate = rsNew.getString("crdate");
						strRetcode = rsNew.getString("retcode");
						strSmsnum = rsNew.getString("smsnum");
						strUserphone = rsNew.getString("userphone");
						strRefuserid = rsNew.getString("refuserid");
					}
					resultCd = "SEND-YES";
					
					if (strUserid.trim().equals(strRefuserid.trim())){
						strMsgText = "[한전 인터넷망]" + userName + "("+ userId +")님의 인증서 발급이 완료되었습니다.";
						strMsgText1 = strMsgText;	
						strMakingText = Make_SMS_MSG(strMyPhoneNum, strMsgText, userId);
						strMakingText1 = strMakingText;
					}
	                                else{
                                                strMsgText = "[한전 인터넷망]" + userName + "("+ userId +")님의 인증서 대리발급이 완료되었습니다.";
						strMsgText1 = "[한전 인터넷망]" + userName + "("+ userId +")님의 인증서 대리발급이 완료되었습니다.";
						strMakingText = Make_SMS_MSG(strMyPhoneNum, strMsgText, userId);
						strMakingText1 = Make_SMS_MSG(strMyPhoneNum, strMsgText1, strRefuserid);


					}	
				
					cnt_log_user = 1;
				}

				rsNew.close();
				stmtNew.close();
				conNew.close();
			}
			catch(Exception ex){
				ex.printStackTrace();
			} finally {
			}			
			
		} //발급 end
		else{//인증서 폐기후 certRevoke
			userTmid = "";
			userSmsSeq = "";
			strMsgText = "[한전 인터넷망]" + userName + "("+ userId +")님의 인증서가 폐기가 완료되었습니다.";		
			strMakingText = Make_SMS_MSG(strMyPhoneNum, strMsgText, userId);		
	
		}//폐기 end
		
		RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, strMakingText);
		RETURNCODE = RETURNCODE.trim();
		RETURNMSG = rtnMessage(RETURNCODE);
		
		if (strUserid.trim().equals(strRefuserid.trim())){
		}else{
			RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, strMakingText1);
               		 RETURNCODE = RETURNCODE.trim();
               		 RETURNMSG = rtnMessage(RETURNCODE);
		}
				

		resultCd = RETURNCODE;
		
	}
        
    return resultCd ; 
    
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

public String Make_SMS_MSG(String strRecvPhone, String strSmsMsg, String strEmpNo){
	String SmsMsgStr = null;
	
	int iCLASSCODE = 5 ;//--
	String CLASSCODE = "IDMKL" ; // 5 + 1 //--	
	int iPASSWORD = 4 ;//--
	String PASSWORD = "DIST"; // 4 + 1 //--	
	int iKEY = 15 ;//--
	String KEY = "000000000000001";//15 + 1 //--
	Locale locale = java.util.Locale.KOREA; //--
	SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale); //--
	String convertedTime = sdfr.format(new java.util.Date()); //--
	KEY = convertedTime ;	 //--	
	int iRECVPHONE = 15 ;//--
	String RECVPHONE = strRecvPhone ; //--	
	int iCALLBACK = 15 ;//--
	String CALLBACK = "0613451166"; //15 + 1 //--	
	int iMESSAGE = 80 ; //--
	String MESSAGE = strSmsMsg; //strMsgText ; //80 + 1 //--	
	int iEMPNO = 8 ; //--
	String EMPNO = strEmpNo ; // 8 + 1 //-- 	
	int iREFCNT = 5 ; //	
	String REFCNT = "00001"; // 5 + 1 //--		
	int fCnt = 0 ; //--
	
	String SEND_MSG = null ; // --
	
	SEND_MSG = fillSpace(CLASSCODE, iCLASSCODE) + (char)0 ;	
	SEND_MSG = SEND_MSG + fillSpace(PASSWORD, iPASSWORD) + (char)0 ;	
	SEND_MSG = SEND_MSG + fillSpace(KEY, iKEY) + (char)0 ;	
	SEND_MSG = SEND_MSG + fillSpace(RECVPHONE, iRECVPHONE) + (char)0 ;	
	SEND_MSG = SEND_MSG + fillSpace(CALLBACK, iCALLBACK) + (char)0  ;	
	
	if (fillSpace(MESSAGE,iMESSAGE).getBytes().length > iMESSAGE ){
		if(MESSAGE.getBytes().length < iMESSAGE ){
			fCnt = iMESSAGE-MESSAGE.getBytes().length;
			MESSAGE = getMessage(MESSAGE,fCnt);
		}
		SEND_MSG = SEND_MSG + MESSAGE  + (char)0 ;	
	}else{
		SEND_MSG = SEND_MSG + fillSpace(MESSAGE,iMESSAGE) + (char)0 ;	
	}
	
	SEND_MSG = SEND_MSG + fillSpace(EMPNO,iEMPNO)  + (char)0;	
	SEND_MSG = SEND_MSG + fillSpace(REFCNT,iREFCNT )  + (char)0;
	
	return SEND_MSG;
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
%>
