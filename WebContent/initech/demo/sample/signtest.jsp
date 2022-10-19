<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!--  이니텍 관련 -->
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
<h3>---------- 전자서명 테스트 -------------</h3><p><br>
</center>

<%

String orgData = "";
String regDate = "";
String dateTime = "";
String DATE_FORMAT = "yyyyMMddHHmmssSSS";

// ### INISigner 대체 : is.pkcs7Data()
String PKCS7SignedData = m_IP.getParameter("PKCS7SignedData");
out.println("PKCS7SignedData : <br>" + PKCS7SignedData);

try {
	// INISAFE Sign 초기화
	INISAFESign is =  new INISAFESign(PKCS7SignedData, "/usr/Application/proc/proc.ear/procWeb.war/initech/iniplugin/properties/INISAFESign.properties");

	// ### INISigner 대체 함수 : verify()
	boolean result = is.verifyPKCS7();
	if (result) {
		out.println("<font size=2 color=000099><br><b>서명 검증이 정상적으로 이루어 졌습니다.</b></font><br>");	
	} else {
		// 서명 데이타 검증 실패 
		out.println("<font size=2 color=000099><br><b>서명 데이타 검증 실패 </b></font><br>");
	}

	// 원본데이터
	//orgData = is.getData();
	//out.println("<br>SignedData OrgData(원본데이터) : "+ orgData);

	//(PKCS7 서명데이터에서 인증서를 추출, 인증서의 정책 OID를 가지고 옴
	X509Certificate cert = is.getCertificate();

	out.println("X509Certificate IssuerDN1 =" + cert.getIssuerDN().toString()+"<br>");
	out.println("X509Certificate SubjectDN1 =" + cert.getSubjectDN().toString()+"<br>");
	out.println("X509Certificate SerialNumber1 =" + cert.getSerialNumber()+"<br>");
	out.println("X509Certificate getNotBefore =" + cert.getNotBefore()+"<br>");
	out.println("X509Certificate getNotAfter 만료일 =" + cert.getNotAfter()+"<br>");

	//out.println("iniSign.getPKCS7Mgr() DataProperties = [ " + is.getPKCS7Manager().getDataProperties() + "]"+"<br>");

	// ### INISigner 대체 함수 : getCettificate() 
	out.println("<br> getCertManager().getCertificate() = [ " + is.getCertManager().getCertificate() + "]"+"<br>");

	// ### INISigner 대체 함수 : getPemCertificate()
	out.println("<br> m_IP.getClientCertificate2() = [ " + m_IP.getClientCertificate2() + "]"+"<br>");

	// ### INISigner 대체 함수 : getCettificate() 
	out.println("<br> X509Certificate 인증서 =" + cert.toString()+"<br>");

	// ### INISigner 대체 함수 : getParameter() 
	out.println("<br> signer.getSignParameter =" + is.getSignParameter("아이디") +"<br>");

	out.println("<br><br>");

	String pubkey = "/usr/Application/proc/proc.ear/procWeb.war/initech/keys/signCert.pem";
	String privkey = "/usr/Application/proc/proc.ear/procWeb.war/initech/keys/signPri.key";
	String privpw = "lgchem2007";
	String plainData = "성명=홍길동&부서=보안사업부&주소=서울 구로구 구로동";

	INISAFESign sign = new INISAFESign("D:/initech/sign_java/properties/INISAFESign.properties");
	byte[] signData = sign.sign(plainData.getBytes());
	//byte[] signData = sign(pubkey, privkey, privpw, plainData.getBytes());
	String base64encodedSignData = new String(Base64Util.encode(signData));

	// 서버 서명
	INISAFESign sign2 =  new INISAFESign(base64encodedSignData, "/usr/Application/proc/proc.ear/procWeb.war/initech/properties/INISAFESign.properties");

	// ### INISigner 대체 함수 : verify()
	result = sign2.verifyPKCS7();
	if (result) {
		out.println("<font size=2 color=000099><br><b>서버 서명 검증이 정상적으로 이루어 졌습니다.</b></font><br>");	
	} else {
		// 서명 데이타 검증 실패 
		out.println("<font size=2 color=000099><br><b>서버 서명 데이타 검증 실패 </b></font><br>");
	}

	

/**
	//본인확인 테스트
	X509Certificate jp_cert = m_IP.getClientCertificate();
	String JUMINNO = m_IP.getParameter("JUMINNO");
	//String vid = m_IP.getVIDRandom();
	IDVerifier idv = new IDVerifier();

	if ((idv.checkVID(jp_cert, JUMINNO, m_IP.getVIDRandom().getBytes())) == true) {			
		out.println("본인확인에 성공했습니다.!! "+"<br>");
	} else {					
		out.println("본인확인에 실패했습니다.!!"+"<br>");
	}

	//OID 테스트
	jp_cert = m_IP.getClientCertificate();
	CertOIDUtil cou = new CertOIDUtil("D:/initechRoot/initech_web_java/iniplugin/properties/jCERTOID.properties");
	if (cou.checkOID(jp_cert) == true) {
		out.println("OID 확인에 성공했습니다.!! "+"<br>");
	} else {					
		out.println("OID 확인에 실패했습니다.!!"+"<br>");
	}		
	int iou = 0;
	iou = cou.getCertOU(cou.getCertOID());			   
	out.println("**인증서 종류 구분** "+ iou +"<br>");
	if (iou == ConstDef.PERSONAL) {
		out.println("인증서 구분 : [ 개인 ]"+"<br>");
	} else if (iou == ConstDef.CORPORATION) {
		out.println("인증서 구분 : [ 법인 ]"+"<br>");
	} else if (iou == ConstDef.ORGAN) {
		out.println("인증서 구분 : [ 기관 ]"+"<br>");
	} else {
		out.println("인증서 종류를 알수 없습니다. "+"<br>");
	}
	
	String issuer = null;
	issuer = cou.getCertIssuer(cou.getCertOID());			
	out.println(" **인증서 발급자 구분** : " + issuer + "<br>");
	if (issuer != null) {
		if (issuer.equals(ConstDef.KICA)) {
			out.println("인증서 발급자  : [ 한국정보인증 ]"+"<br>");
		} else if (issuer.equals(ConstDef.SIGNKOREA)) {
			out.println("인증서 발급자  : [ 한국증권전산 ]"+"<br>");
		} else if (issuer.equals(ConstDef.YESSIGN)) {
			out.println("인증서 발급자  : [ 금융결제원 ]"+"<br>");
		} else if (issuer.equals(ConstDef.NCA)) {
			out.println("인증서 발급자  :[ 한국전산원 ]"+"<br>");
		} else if (issuer.equals(ConstDef.CROSSCERT)) {
			out.println("인증서 발급자  :[ 한국전자인증 ]"+"<br>");
		} else if (issuer.equals(ConstDef.TRADESIGN)) {
			out.println("인증서 발급자  : [ 한국무역정보통신 ]"+"<br>");
		}
	}
**/

	//CRL Test
	CheckCRL ccrl = null;
	X509Certificate x509 = null;

	boolean returnFlag = false;
		
	//아래의 389 포트가 out 으로 열려있어야 함.
	//한국증권전산 : 210.207.195.77 389
	//한국정보인증 : 211.35.96.26 389
	//한국전산원 : 210.114.93.21 389
	//한국전자인증 : 211.192.169.180 389
	//한국무역정보통신 : 203.242.205.156 389

	String crlConfig = "/usr/Application/proc/proc.ear/procWeb.war/initech/properties/CRL.properties";
	

	ccrl = new CheckCRL();
	ccrl.init(crlConfig);
	returnFlag = ccrl.isValid(m_IP.getClientCertificate());         
	out.println(" 인증서 검증결과 : [" + returnFlag + "]"+"<br>");

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
	out.println("<br><b>INISAFE Public PKI 검증 ERROR</b>");
	out.println("<hr>");
	out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
	out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
}

/**


}catch(Exception e){

	INISAFESignException se = new INISAFESignException(e);

	// ### INISigner 대체 함수 : getErrorCode() 
	out.println("<br>ErrorCode = " + se.getErrorCode() + "<br>");

	// ### INISigner 대체 함수 : getErrorMessage() 
	out.println("<br>ErrorMessage = " + se.getErrorMessage() + "<br><br>");

	// ### INISigner 대체 함수 : is.PrintStackTrace() 
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
<center><input type=button value="되돌아가기" onClick="history.back();">
</center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH Bank</font><br></p>
</body>
</html>
