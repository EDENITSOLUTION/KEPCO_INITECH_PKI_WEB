<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.String.*" %>
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
String MESSAGE = "[�ѱ����°���] �������� ������ �߱޿� ������ȣ�� [000000]�Դϴ�."; //80 + 1
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
//  ���� �ڵ� ///////////////////////////////////
String RETURNCODE = "2000";
////////////////////////////////////////////////////
//1. 9999 : ����(�޼��� ���� ó��)
//2. 1000 : SMS ���μ��� ����(SMS ���� ���μ����� �������� ���)
//3. 1001 : ���� ���������� ����(���� ������������ ������ ���� ���� ���)
//4. 1002 : ������ ���۽ð� �ʰ� ����(������ ���� �� �����ð����� ������ �ۼ����� �̷������ ���� ���)
//5. 1100 : �����ͺ��̽� ���� ����(�����ͺ��̽��� �����Ǿ����� ���� ������ ���� ���)
//6. 1101 : �����ͺ��̽� Query ����(�����ͺ��̽� Query �� ������ ���Ŀ� �°� ������ �� �����ͺ��̽� �˻��� �߸��� ���);
//7. 1200 : ����� ���� ���� (����� �ڵ尡 �߸��� ���)
//8. 2000 : �������� ������� ����


//SMS�߼��� ���� Ŭ���̾�Ʈ ��ü ����
SmsClient sms = new SmsClient();
RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);

String tempPhone = "01099117557";

String RefMsg = "KEPCO-SSO �������߱޿� ������ȣ��û�˸� : "+ tempPhone ;


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
<title>Insert title here</title>
</head>
<body>

-�����ڵ� : <%=RETURNCODE%><br />
- RefMsg : <%=RefMsg%><br />
- RefMsg length : <%=RefMsg.length()%><br />
- RefMsg byte length : <%=RefMsg.getBytes().length%><br />

</body>
</html>
