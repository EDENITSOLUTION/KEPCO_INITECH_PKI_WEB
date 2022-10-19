<%-- CertOCSPlogon.jsp CRL을 이용한 공인인증서 로그인 예제 --%>

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
// 1. 암호화된 데이타 및 인증서 처리 : Init.jsp에서 처리
//======================================================

X509Certificate userCert = null;
CertOIDUtil cou = null;
userCert = m_IP.getClientCertificate();

//본인 확인 체크 플래그
boolean vidRet = false;
String juminHash = m_IP.getVIDRandom();
String juminParam = m_IP.getParameter("juminNO");

// OCSP 확인 체크 플래그 
int retOCSP = -1;

try{
  
	//======================================================
	// 2. 인증서 구분(범용과 신용카드용)
	//======================================================
	cou = new CertOIDUtil("C:/WAS/initech/iniplugin/properties/jCERTOID.properties");
						
    if (cou.checkOID(userCert) == true) {
		certInfo += "<br><b>인증서가 상호연동용 인증서입니다.</b>";
		certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";		
	} else {					
		certInfo += "<br><b>인증서가 상호연동용 인증서가 아닙니다.</b>";
		certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";
		//////////////////////////// 에러처리 해주어야 함 ////////////////////////////
	}			
						
	//======================================================
	// 3. 인증서 유효성 확인(OCSPCD)
	//======================================================
	
	try {
		userCert = m_IP.getClientCertificate();	
		OCSPManager om = new OCSPManager("C:/WAS/initech/iniplugin/properties/jOCSP.properties");

		Enumeration e = om.request(userCert);		
		while(e.hasMoreElements()){
			SingleResponse sr = new SingleResponse(e);
			if(sr.isStatusGood()) {
				System.out.println("유효한 인증서 입니다.");
				retOCSP = 0;// 유효한 인증서입니다.
			} 
			else if(sr.isStatusRevoked()){
				System.out.println("폐기된 인증서 입니다.");
				retOCSP = 103; // 폐기된 인증서입니다.
			} 
			else if(sr.isStatusUnknown()){
				System.out.println("효력 정지 또는 알수 없는 인증서 입니다. ");
				retOCSP = 104; // 효력정지 또는 알수 없는 인증서입니다.}
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
		retOCSP = -1;
	}

	//======================================================
	// 4. 본인확인체크
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
   out.println("<br><b>INISAFE Public PKI 검증 ERROR</b>");
   out.println("<hr>");
   out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
   out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
   //return;
	
}
	   	
if(retOCSP==0) {
	certInfo += "<br><b>OCSP 결과 : 제출한 인증서는 유효한 인증서입니다.</b>";
} else if(retOCSP==103) {
	certInfo += "<br><b>OCSP 결과 : 제출한 인증서는 폐기된 인증서입니다.</b>";
} else if(retOCSP==104) {
	certInfo += "<br><b>OCSP 결과 : 제출한 인증서는 효력정지 또는 알수 없는 인증서입니다.</b>";
} else if(retOCSP==-1) {
	certInfo += "<br><b>OCSP 결과 : 제출한 인증서는 유효성 검사에 실패하였습니다.</b>";
} 


if( vidRet ) {
	certInfo += "<br><b>제출한 인증서는 본인의 인증서가 맞습니다.</b>";
} else {
	certInfo += "<br><b>제출한 인증서는 본인의 인증서가 아닙니다.</b>";
}


	
%>
<%
	if( retOCSP==0 && vidRet )
	{
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// 인증서 발급일
		Date NotAfter = userCert.getNotAfter();		// 인증서 만기일
		Date currentTime = new Date();				// 현재 시간
		int dateformat = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>발급자 : " + userCert.getIssuerDN().toString();
		certInfo += "<br>발급대상 : " + userCert.getSubjectDN().toString();
		certInfo += "<br>발급일 : " + myDate.format(NotBefore);
		certInfo += "<br>만료일 : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>현재시간 : " + myDate.format(currentTime);
		certInfo += "<br>고객님의 인증서는 ";
		certInfo += dateformat;
		certInfo += "일 후에 만료가 됩니다.";
	}
%>

<html>
<head>
	<title>Login</title>
</head>

<body>

<br><h3>사용자 인증 정보입니다.</h3>
<p><b>제출하신 사용자 인증서의 정보는 아래와 같습니다.</b><br>
<%=certInfo%>

<p><b>제출하신 인증서와 일치하는 주민등록번호는 아래와 같습니다.</b><br>
<br><b>주민등록번호 =</b> [<%= juminParam %>]



<br><br>
<center><input type=button value='되돌아가기' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>

</body></html>
