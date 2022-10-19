<%-- CertOCSPlogon.jsp CRL�� �̿��� ���������� �α��� ���� --%>

<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.*" %>

<%@ page import="com.initech.iniplugin.vid.*" %>
<%@ page import="com.initech.pkix.ocsp.*" %>
<%@ page import="com.initech.pkix.ocsp.util.CertificateUtil" %>
<%@ page import="com.initech.iniplugin.oid.* "%>
<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init.jsp"%>

<%
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");

String certInfo = "";

//======================================================
// 1. ��ȣȭ�� ����Ÿ �� ������ ó�� : Init.jsp���� ó��
//======================================================

X509Certificate userCert = null;
CertOIDUtil cou = null;
userCert = m_IP.getClientCertificate();

//���� Ȯ�� üũ �÷���
boolean vidRet = false;
String juminHash = m_IP.getVIDRandom();
String juminParam = m_IP.getParameter("juminNO");

// OCSP Ȯ�� üũ �÷��� 
int retOCSP = -1;

try{
  
	//======================================================
	// 2. ������ ����(����� �ſ�ī���)
	//======================================================
	cou = new CertOIDUtil("C:/WAS/initech/iniplugin/properties/jCERTOID.properties");
						
    if (cou.checkOID(userCert) == true) {
		certInfo += "<br><b>�������� ��ȣ������ �������Դϴ�.</b>";
		certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";		
	} else {					
		certInfo += "<br><b>�������� ��ȣ������ �������� �ƴմϴ�.</b>";
		certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";
		//////////////////////////// ����ó�� ���־�� �� ////////////////////////////
	}			
						
	//======================================================
	// 3. ������ ��ȿ�� Ȯ��(OCSPCD)
	//======================================================
	
	try {
		userCert = m_IP.getClientCertificate();	
		OCSPManager om = new OCSPManager("C:/WAS/initech/iniplugin/properties/jOCSP.properties");

		Enumeration e = om.request(userCert);		
		while(e.hasMoreElements()){
			SingleResponse sr = new SingleResponse(e);
			if(sr.isStatusGood()) {
				System.out.println("��ȿ�� ������ �Դϴ�.");
				retOCSP = 0;// ��ȿ�� �������Դϴ�.
			} 
			else if(sr.isStatusRevoked()){
				System.out.println("���� ������ �Դϴ�.");
				retOCSP = 103; // ���� �������Դϴ�.
			} 
			else if(sr.isStatusUnknown()){
				System.out.println("ȿ�� ���� �Ǵ� �˼� ���� ������ �Դϴ�. ");
				retOCSP = 104; // ȿ������ �Ǵ� �˼� ���� �������Դϴ�.}
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
		retOCSP = -1;
	}

	//======================================================
	// 4. ����Ȯ��üũ
	//======================================================

	IDVerifier idv = new IDVerifier();

	vidRet = idv.checkVID(userCert, juminParam, juminHash.getBytes());
	
} catch(Exception e) {
	m_IniErrCode = "PPKI_999";
	m_IniErrMsg  = "Exception : " + e.getMessage();
	retOCSP = -1;
	vidRet = false;
}
	
if(m_IniErrCode != null){
   out.println("<br><b>INISAFE Public PKI ���� ERROR</b>");
   out.println("<hr>");
   out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
   out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
   //return;
	
}
	   	
if(retOCSP==0) {
	certInfo += "<br><b>OCSP ��� : ������ �������� ��ȿ�� �������Դϴ�.</b>";
} else if(retOCSP==103) {
	certInfo += "<br><b>OCSP ��� : ������ �������� ���� �������Դϴ�.</b>";
} else if(retOCSP==104) {
	certInfo += "<br><b>OCSP ��� : ������ �������� ȿ������ �Ǵ� �˼� ���� �������Դϴ�.</b>";
} else if(retOCSP==-1) {
	certInfo += "<br><b>OCSP ��� : ������ �������� ��ȿ�� �˻翡 �����Ͽ����ϴ�.</b>";
} 


if( vidRet ) {
	certInfo += "<br><b>������ �������� ������ �������� �½��ϴ�.</b>";
} else {
	certInfo += "<br><b>������ �������� ������ �������� �ƴմϴ�.</b>";
}


	
%>
<%
	if( retOCSP==0 && vidRet )
	{
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// ������ �߱���
		Date NotAfter = userCert.getNotAfter();		// ������ ������
		Date currentTime = new Date();				// ���� �ð�
		int dateformat = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>�߱��� : " + userCert.getIssuerDN().toString();
		certInfo += "<br>�߱޴�� : " + userCert.getSubjectDN().toString();
		certInfo += "<br>�߱��� : " + myDate.format(NotBefore);
		certInfo += "<br>������ : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>����ð� : " + myDate.format(currentTime);
		certInfo += "<br>������ �������� ";
		certInfo += dateformat;
		certInfo += "�� �Ŀ� ���ᰡ �˴ϴ�.";
	}
%>

<html>
<head>
	<title>Login</title>
</head>

<body>

<br><h3>����� ���� �����Դϴ�.</h3>
<p><b>�����Ͻ� ����� �������� ������ �Ʒ��� �����ϴ�.</b><br>
<%=certInfo%>

<p><b>�����Ͻ� �������� ��ġ�ϴ� �ֹε�Ϲ�ȣ�� �Ʒ��� �����ϴ�.</b><br>
<br><b>�ֹε�Ϲ�ȣ =</b> [<%= juminParam %>]



<br><br>
<center><input type=button value='�ǵ��ư���' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>

</body></html>
