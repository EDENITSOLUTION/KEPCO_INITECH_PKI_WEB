<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.util.Date.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="kepco.*" %>
<%!
 public String sendSMS(String strCertGb, String userId, String strTmid) {
	
	String resultCd = null ; //����ڵ�
	int cnt_user = 0 ; //����� ���� ����
	int cnt_log_user = 0 ; //�������߱޽� ����� ���� ����
	String userName = null ; //����ڸ�
	String userPhone = null ; //����� ��ȭ��ȣ
	String userMail = null ; //����� �̸���
	
	String strMyPhoneNum = null;
	String strMyRefPhoneNum = null;
	
	String strMsgText = null; //SMS�߼۸޼���
        String strMsgText = null;
	String strMakingText = null;
	String strMakingText1 = null;
	String REFPHONE = null ;
	
	String userTmid = "";
	String userSmsSeq = "";
	
	String SENDIP = "203.248.44.150";
	int SENDPORT = 7904;
	////////////////////////////////////////////////////
	//���� �ڵ� ///////////////////////////////////
	String RETURNCODE = "2000";
	String RETURNMSG = "" ;
	
	//�������߱޽� SMS�α� ����
	String strSeq = "";
	String strUserid ="";
	String strUserip = "";
	String strCrdate = "";
	String strSmsnum = "";
	String strRetcode = "";
	String strUserphone = "";
	String strRefuserid = "";
	
	
	
	try{
		//step1. userId�� ����� ���� ��ȸ
		Context ctSms = new InitialContext();
		DataSource dsSms = (DataSource) ctSms.lookup("java:comp/env/jdbc/USERS");
		ResultSet rsSms = null;
		Connection conSms = null;
		Statement stmtSms = null;
		String smsQry = null;	
		
		//����� �λ������� �����ϴ��� üũ
		conSms = dsSms.getConnection();
		//Creat Query and get results
		stmtSms = conSms.createStatement();

		rsSms = stmtSms.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ userId +"'");
		while (rsSms.next()){
			cnt_user = rsSms.getInt("cnt");
		}
		if (cnt_user == 0){
			resultCd = "SEND-NO";
		}else{ // ����� ���� �����Ҷ�				
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
		
		//SMS�߼��� ���� Ŭ���̾�Ʈ ��ü ����
		SmsClient sms = new SmsClient();
		
		if (strCertGb.equals("certNew")){ //������ �߱� ��
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
				}else{ // ����� ���� �����Ҷ�				
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
						strMsgText = "[���� ���ͳݸ�]" + userName + "("+ userId +")���� ������ �߱��� �Ϸ�Ǿ����ϴ�.";
						strMsgText1 = strMsgText;	
						strMakingText = Make_SMS_MSG(strMyPhoneNum, strMsgText, userId);
						strMakingText1 = strMakingText;
					}
	                                else{
                                                strMsgText = "[���� ���ͳݸ�]" + userName + "("+ userId +")���� ������ �븮�߱��� �Ϸ�Ǿ����ϴ�.";
						strMsgText1 = "[���� ���ͳݸ�]" + userName + "("+ userId +")���� ������ �븮�߱��� �Ϸ�Ǿ����ϴ�.";
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
			
		} //�߱� end
		else{//������ ����� certRevoke
			userTmid = "";
			userSmsSeq = "";
			strMsgText = "[���� ���ͳݸ�]" + userName + "("+ userId +")���� �������� ��Ⱑ �Ϸ�Ǿ����ϴ�.";		
			strMakingText = Make_SMS_MSG(strMyPhoneNum, strMsgText, userId);		
	
		}//��� end
		
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
			MsgStr = "�������� �߼� ��� ����";
	}else if (MsgCode.equals("9999")) {
			MsgStr = "����";
	}else if (MsgCode.equals("1000")) {
			MsgStr = "SMS ���μ��� ����(SMS ���� ���μ��� ����)";
	}else if (MsgCode.equals("1001")) {
			MsgStr = "���� ���������� ����";
	}else if (MsgCode.equals("1002")) {
			MsgStr = "������ ���۽ð� �ʰ� ����";
	}else if (MsgCode.equals("1100")) {
			MsgStr = "�����ͺ��̽� ���� ���� �Ǵ� ���� ���� ����";
	}else if (MsgCode.equals("1101")) {
			MsgStr = "�����ͺ��̽� Query ����";
	}else if (MsgCode.equals("1200")) {
			MsgStr = "����� ���� ���� (�߸��� ����� �ڵ� ����)";
	}else if (MsgCode.equals("2000")) {
			MsgStr = "�������� �߼� ��� ����";
	}else {
			MsgStr = "����";
	
	}
	return MsgStr ;
	
}
%>
