<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.util.Date.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="kepco.*" %>
<%!
//SendMSG�����
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

public String sendSMS(String userId, String cellNo, String message) {

	////////////////////////////////////////////////////
	//1. 9999 : ����(�޼��� ���� ó��)
	//2. 1000 : SMS ���μ��� ����(SMS ���� ���μ����� �������� ���)
	//3. 1001 : ���� ���������� ����(���� ������������ ������ ���� ���� ���)
	//4. 1002 : ������ ���۽ð� �ʰ� ����(������ ���� �� �����ð����� ������ �ۼ����� �̷������ ���� ���)
	//5. 1100 : �����ͺ��̽� ���� ����(�����ͺ��̽��� �����Ǿ����� ���� ������ ���� ���)
	//6. 1101 : �����ͺ��̽� Query ����(�����ͺ��̽� Query �� ������ ���Ŀ� �°� ������ �� �����ͺ��̽� �˻��� �߸��� ���);
	//7. 1200 : ����� ���� ���� (����� �ڵ尡 �߸��� ���)
	//8. 2000 : �������� ������� ����

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

	// ������� �ڵ��� ��ȣ�� ���������� ��ϾȵǾ����Ƿ� 
	//String RECVPHONE = orgSendFmatPhone.replace("-","");
	String RECVPHONE = cellNo ; 
	RECVPHONE = RECVPHONE.replace("-","");

	String CALLBACK = "0613458000"; //15 + 1
	String MESSAGE = message ; //80 + 1

	//if (sendCnt.equals("00002")){
	  // MESSAGE = "[���� ���ͳݸ�]"+ refUserName + "("+refuserid+")���� ������ �븮 �߱��� ��û�Ͽ����ϴ�.";
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
	//  ���� �ڵ� ///////////////////////////////////
	String RETURNCODE = "2000";
	String RETURNMSG = "" ;


	//SMS�߼��� ���� Ŭ���̾�Ʈ ��ü ����
	SmsClient sms = new SmsClient();
	RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);

	RETURNCODE = RETURNCODE.trim();
	RETURNMSG = rtnMessage(RETURNCODE);

	return RETURNCODE;
}
%>
