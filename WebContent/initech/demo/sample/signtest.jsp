<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!--  �̴��� ���� -->
<%@ page import="java.security.cert.CertificateException" %>
<%@ page import="java.security.cert.CertificateExpiredException" %>
<%@ page import="java.security.cert.CertificateFactory" %>
<%@ page import="java.security.cert.CertificateNotYetValidException" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="com.initech.iniplugin.crl.CheckCRL" %>
<%@ page import="com.initech.iniplugin.crl.exception.*" %>
<%@ page import="com.initech.inisafesign.*" %>
<%@ page import="com.initech.inisafesign.exception.*" %>
<%@ page import="com.initech.util.*" %>

<%@ include file ="../include/Init.jsp"%>


<head><title>INISAFE Sign TEST</title>
</head>
<body>
<center>
<h3>---------- ���ڼ��� �׽�Ʈ -------------</h3><p><br>
</center>

<%

String orgData = "";
String regDate = "";
String dateTime = "";
String DATE_FORMAT = "yyyyMMddHHmmssSSS";

// ### INISigner ��ü : is.pkcs7Data()
String PKCS7SignedData = m_IP.getParameter("PKCS7SignedData");
out.println("PKCS7SignedData : <br>" + PKCS7SignedData);

try {
	// INISAFE Sign �ʱ�ȭ
	INISAFESign is =  new INISAFESign(PKCS7SignedData, "/usr/Application/proc/proc.ear/procWeb.war/initech/iniplugin/properties/INISAFESign.properties");

	// ### INISigner ��ü �Լ� : verify()
	boolean result = is.verifyPKCS7();
	if (result) {
		out.println("<font size=2 color=000099><br><b>���� ������ ���������� �̷�� �����ϴ�.</b></font><br>");	
	} else {
		// ���� ����Ÿ ���� ���� 
		out.println("<font size=2 color=000099><br><b>���� ����Ÿ ���� ���� </b></font><br>");
	}

	// ����������
	//orgData = is.getData();
	//out.println("<br>SignedData OrgData(����������) : "+ orgData);

	//(PKCS7 �������Ϳ��� �������� ����, �������� ��å OID�� ������ ��
	X509Certificate cert = is.getCertificate();

	out.println("X509Certificate IssuerDN1 =" + cert.getIssuerDN().toString()+"<br>");
	out.println("X509Certificate SubjectDN1 =" + cert.getSubjectDN().toString()+"<br>");
	out.println("X509Certificate SerialNumber1 =" + cert.getSerialNumber()+"<br>");
	out.println("X509Certificate getNotBefore =" + cert.getNotBefore()+"<br>");
	out.println("X509Certificate getNotAfter ������ =" + cert.getNotAfter()+"<br>");

	//out.println("iniSign.getPKCS7Mgr() DataProperties = [ " + is.getPKCS7Manager().getDataProperties() + "]"+"<br>");

	// ### INISigner ��ü �Լ� : getCettificate() 
	out.println("<br> getCertManager().getCertificate() = [ " + is.getCertManager().getCertificate() + "]"+"<br>");

	// ### INISigner ��ü �Լ� : getPemCertificate()
	out.println("<br> m_IP.getClientCertificate2() = [ " + m_IP.getClientCertificate2() + "]"+"<br>");

	// ### INISigner ��ü �Լ� : getCettificate() 
	out.println("<br> X509Certificate ������ =" + cert.toString()+"<br>");

	// ### INISigner ��ü �Լ� : getParameter() 
	out.println("<br> signer.getSignParameter =" + is.getSignParameter("���̵�") +"<br>");

	out.println("<br><br>");

	String pubkey = "/usr/Application/proc/proc.ear/procWeb.war/initech/keys/signCert.pem";
	String privkey = "/usr/Application/proc/proc.ear/procWeb.war/initech/keys/signPri.key";
	String privpw = "lgchem2007";
	String plainData = "����=ȫ�浿&�μ�=���Ȼ����&�ּ�=���� ���α� ���ε�";

	INISAFESign sign = new INISAFESign("D:/initech/sign_java/properties/INISAFESign.properties");
	byte[] signData = sign.sign(plainData.getBytes());
	//byte[] signData = sign(pubkey, privkey, privpw, plainData.getBytes());
	String base64encodedSignData = new String(Base64Util.encode(signData));

	// ���� ����
	INISAFESign sign2 =  new INISAFESign(base64encodedSignData, "/usr/Application/proc/proc.ear/procWeb.war/initech/properties/INISAFESign.properties");

	// ### INISigner ��ü �Լ� : verify()
	result = sign2.verifyPKCS7();
	if (result) {
		out.println("<font size=2 color=000099><br><b>���� ���� ������ ���������� �̷�� �����ϴ�.</b></font><br>");	
	} else {
		// ���� ����Ÿ ���� ���� 
		out.println("<font size=2 color=000099><br><b>���� ���� ����Ÿ ���� ���� </b></font><br>");
	}

	

/**
	//����Ȯ�� �׽�Ʈ
	X509Certificate jp_cert = m_IP.getClientCertificate();
	String JUMINNO = m_IP.getParameter("JUMINNO");
	//String vid = m_IP.getVIDRandom();
	IDVerifier idv = new IDVerifier();

	if ((idv.checkVID(jp_cert, JUMINNO, m_IP.getVIDRandom().getBytes())) == true) {			
		out.println("����Ȯ�ο� �����߽��ϴ�.!! "+"<br>");
	} else {					
		out.println("����Ȯ�ο� �����߽��ϴ�.!!"+"<br>");
	}

	//OID �׽�Ʈ
	jp_cert = m_IP.getClientCertificate();
	CertOIDUtil cou = new CertOIDUtil("D:/initechRoot/initech_web_java/iniplugin/properties/jCERTOID.properties");
	if (cou.checkOID(jp_cert) == true) {
		out.println("OID Ȯ�ο� �����߽��ϴ�.!! "+"<br>");
	} else {					
		out.println("OID Ȯ�ο� �����߽��ϴ�.!!"+"<br>");
	}		
	int iou = 0;
	iou = cou.getCertOU(cou.getCertOID());			   
	out.println("**������ ���� ����** "+ iou +"<br>");
	if (iou == ConstDef.PERSONAL) {
		out.println("������ ���� : [ ���� ]"+"<br>");
	} else if (iou == ConstDef.CORPORATION) {
		out.println("������ ���� : [ ���� ]"+"<br>");
	} else if (iou == ConstDef.ORGAN) {
		out.println("������ ���� : [ ��� ]"+"<br>");
	} else {
		out.println("������ ������ �˼� �����ϴ�. "+"<br>");
	}
	
	String issuer = null;
	issuer = cou.getCertIssuer(cou.getCertOID());			
	out.println(" **������ �߱��� ����** : " + issuer + "<br>");
	if (issuer != null) {
		if (issuer.equals(ConstDef.KICA)) {
			out.println("������ �߱���  : [ �ѱ��������� ]"+"<br>");
		} else if (issuer.equals(ConstDef.SIGNKOREA)) {
			out.println("������ �߱���  : [ �ѱ��������� ]"+"<br>");
		} else if (issuer.equals(ConstDef.YESSIGN)) {
			out.println("������ �߱���  : [ ���������� ]"+"<br>");
		} else if (issuer.equals(ConstDef.NCA)) {
			out.println("������ �߱���  :[ �ѱ������ ]"+"<br>");
		} else if (issuer.equals(ConstDef.CROSSCERT)) {
			out.println("������ �߱���  :[ �ѱ��������� ]"+"<br>");
		} else if (issuer.equals(ConstDef.TRADESIGN)) {
			out.println("������ �߱���  : [ �ѱ������������ ]"+"<br>");
		}
	}
**/

	//CRL Test
	CheckCRL ccrl = null;
	X509Certificate x509 = null;

	boolean returnFlag = false;
		
	//�Ʒ��� 389 ��Ʈ�� out ���� �����־�� ��.
	//�ѱ��������� : 210.207.195.77 389
	//�ѱ��������� : 211.35.96.26 389
	//�ѱ������ : 210.114.93.21 389
	//�ѱ��������� : 211.192.169.180 389
	//�ѱ������������ : 203.242.205.156 389

	String crlConfig = "/usr/Application/proc/proc.ear/procWeb.war/initech/properties/CRL.properties";
	

	ccrl = new CheckCRL();
	ccrl.init(crlConfig);
	returnFlag = ccrl.isValid(m_IP.getClientCertificate());         
	out.println(" ������ ������� : [" + returnFlag + "]"+"<br>");

} catch (IllegalArgumentException e) {
	m_IniErrCode = "PPKI_001";
	m_IniErrMsg  = "Exception : " + e.getMessage(); 

}catch (LdapConnectException e) {
	m_IniErrCode = "PPKI_002";
	m_IniErrMsg  = "Exception : " + e.getMessage(); 

}catch (CertificateExpiredException e) {
	m_IniErrCode = "PPKI_003";
	m_IniErrMsg  = "Exception : " + e.getMessage(); 

}catch (CertificateNotYetValidException e) {
	m_IniErrCode = "PPKI_004";
	m_IniErrMsg  = "Exception : " + e.getMessage(); 

}catch (ValidCANotFoundException e) {
	m_IniErrCode = "PPKI_005";
	m_IniErrMsg  = "Exception : " + e.getMessage(); 

}catch (CertificatePolicyException e) {
	m_IniErrCode = "PPKI_006";
	m_IniErrMsg  = "Exception : " + e.getMessage();

}catch (Exception e) {
	m_IniErrCode = "PPKI_999";
	m_IniErrMsg  = "Exception : " + e.getMessage();

}

if(m_IniErrCode != null){
	out.println("<br><b>INISAFE Public PKI ���� ERROR</b>");
	out.println("<hr>");
	out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
	out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
}

/**


}catch(Exception e){

	INISAFESignException se = new INISAFESignException(e);

	// ### INISigner ��ü �Լ� : getErrorCode() 
	out.println("<br>ErrorCode = " + se.getErrorCode() + "<br>");

	// ### INISigner ��ü �Լ� : getErrorMessage() 
	out.println("<br>ErrorMessage = " + se.getErrorMessage() + "<br><br>");

	// ### INISigner ��ü �Լ� : is.PrintStackTrace() 
	StringWriter sw = new StringWriter();
	PrintWriter pw = new PrintWriter(sw);
	e.printStackTrace(pw);
	out.println(sw.toString());

	out.println("<br><br>e.toString() = "+e.toString() + "<br>");
	return;
}

**/



%>  

<p> 
<center><input type=button value="�ǵ��ư���" onClick="history.back();">
</center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH Bank</font><br></p>
</body>
</html>
