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

//1. 9999 : ����(�޼��� ���� ó��)
//2. 1000 : SMS ���μ��� ����(SMS ���� ���μ����� �������� ���)
//3. 1001 : ���� ���������� ����(���� ������������ ������ ���� ���� ���)
//4. 1002 : ������ ���۽ð� �ʰ� ����(������ ���� �� �����ð����� ������ �ۼ����� �̷������ ���� ���)
//5. 1100 : �����ͺ��̽� ���� ����(�����ͺ��̽��� �����Ǿ����� ���� ������ ���� ���)
//6. 1101 : �����ͺ��̽� Query ����(�����ͺ��̽� Query �� ������ ���Ŀ� �°� ������ �� �����ͺ��̽� �˻��� �߸��� ���);
//7. 1200 : ����� ���� ���� (����� �ڵ尡 �߸��� ���)
//8. 2000 : �������� ������� ����
////////////////////////////////////////////////////
%>
<%
String strIsInsa = request.getParameter("strIsInsa"); //SMS�λ����� ���� ����
if (strIsInsa.equals("") || strIsInsa == null) {
	strIsInsa = "N"; //default�� �������� ����
}

String empno = request.getParameter("empno"); //���
String tmid = request.getParameter("tmid");//Ÿ�Ӿ��̵�
String seq = "" ;
String strSql = "" ;
String org_phone = request.getParameter("org_phone"); //DB�� ����� ��ȣ
String userName = request.getParameter("userName"); // ����ڸ�

String phone1 = request.getParameter("phone1"); //���� �Է��� ��ȣ1
String phone2 = request.getParameter("phone2"); //���� �Է��� ��ȣ2
String phone3 = request.getParameter("phone3"); //���� �Է��� ��ȣ3
String phone = phone1 + "-" + phone2 + "-" + phone3 ; //����ó ����

String orgPhone = org_phone.replace("-","");
String sendPhone = phone1 + phone2 + phone3 ; //����ó ����

String sendCnt = "00001"; //�������� SMS���� ��

//validation check
if (empno.equals("") || empno==null || phone1.equals("") || phone1==null || phone2.equals("") || phone2==null || phone3.equals("") || phone3==null || tmid.equals("") || tmid==null ){
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('SMS������ ���� ��� �� ��ȭ��ȣ�� �����Ǿ� ���޵Ǿ����ϴ�.');");
	writer.println("location.href='websmsform.jsp';");
	writer.println("</script>");
	writer.flush();
	return;
} // end of check all of validation 


//SMS seq make
seq = tmid + "_" + empno + "_" + request.getRemoteAddr() ; // 20140709172427_ex099129_255.255.255.255


int cnt_user = 0 ; // ����� �ش��ϴ� ����� ���� ����(0:����, �׿� ����)

int phoneLen = 0 ;

if (orgPhone.equals(sendPhone)){//�λ����̺� ����� ��ȭ��ȣ�� �Է��� ��ȭ��ȣ�� �������� �ѹ��� ����
	sendCnt = "00001";
}else{
	if (org_phone.equals("010-0000-0000")) { //�λ������� ����ó ����� �ȵ�..�̰� ����ó������
		sendCnt = "00001";
	}else{
		sendCnt = "00002";//�λ����̺� ����� ��ȭ��ȣ�� �Է��� ��ȭ��ȣ�� �ٸ��� �ι� �߼�
	}
}

//////////////////////////////////////////////////////////////////////////////////////////
//SMS������ȣ ����� START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);
String strMsgText ="[�ѱ����°���] ���ͳݸ� ������ �߱޿�\n������ȣ�� ["+certkey+"]�Դϴ�.";
//////////////////////////////////////////////////////////////////////////////////////////
//SMS������ȣ ����� END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////




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
//  ���� �ڵ� ///////////////////////////////////
String RETURNCODE = "2000";
String RETURNMSG = "" ;



String strRef = "2000";
String RefMsg = "KEPCO-SSO �������߱޿� ������ȣ��û�˸� : "+ phone1 + "-" + phone2 + "-" + phone3  ;
String RefKey = KEY + "1" ;

String RefSMSMsg = "";
if (sendCnt.equals("00002")) {
	//��ȭ��ȣ�� �ٸ����� �� ����� ��ȭ��ȣ�� �޼��� ��������
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


//SMS�߼��� ���� Ŭ���̾�Ʈ ��ü ����
SmsClient sms = new SmsClient();
RETURNCODE = sms.SendSMS(SENDIP, SENDPORT, SEND_MSG);

RETURNCODE = RETURNCODE.trim();
RETURNMSG = rtnMessage(RETURNCODE);


if (sendCnt.equals("00002")) {
	strRef = sms.SendSMS(SENDIP, SENDPORT, RefSMSMsg).trim();
}

//SMS���� db insert
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
<title>SMS �����ϱ�</title>
<script  type="text/javascript" language="javascript">
function  fncConfirm() {
<% 
if (RETURNCODE.equals("99991001")) { //����
%>
	alert("[<%=RETURNMSG%>]SMS������ȣ�� �����Ͽ����ϴ�.\n\n���۹����� ������ȣ�� �Է��Ͻʽÿ�.");
	//opener.readForm.smschk.value="<%=certkey%>";
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("9999")) { //���۵���������
%>
	alert("[<%=RETURNMSG%>]SMS������ȣ�� �����Ͽ����ϴ�.\n\n���۹����� ������ȣ�� �Է��Ͻʽÿ�.");
	//opener.readForm.smschk.value="<%=certkey%>";
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
<%
}else if (RETURNCODE.equals("1001")) { //���۵��������� �������� ��� ��ŵ
%>
	alert("[<%=RETURNMSG%>]SMS�Է¶��� <%=certkey%>��(��) �Է��Ͻʽÿ�.");
	//opener.readForm.smschk.value="<%=certkey%>";
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();	
<%
}else{
%>
	
	alert("[<%=RETURNMSG%>]SMS������ȣ�� �����Ͽ����ϴ�.\n\n���۹����� ������ȣ�� �Է��Ͻʽÿ�.");
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