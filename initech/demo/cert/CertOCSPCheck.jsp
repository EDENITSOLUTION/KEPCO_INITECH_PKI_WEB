<%-- CertOCSPCheck.jsp2 --%>
<%@ page language="java" %>
<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.*" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="com.initech.iniplugin.vid.*" %>
<%@ page import="com.initech.pkix.ocsp.OCSPManager" %>
<%@ page import="com.initech.pkix.ocsp.SingleResponse" %>
<%@ page import="com.initech.pkix.ocsp.util.CertificateUtil" %>
<%@ page import="com.initech.iniplugin.oid.CertOIDUtil "%>
<%@ page import="com.initech.iniplugin.oid.OIDException" %>
<%
	response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "0");

	String certInfo = "";
%>
<%
	//======================================================
	// 1. 암호화된 데이타 및 인증서 처리
	//======================================================
    IniPlugin m_IP = null;
    String propIniPlugin = "C:/WAS/initech/iniplugin/properties/IniPlugin.properties";
    
	try {
       	m_IP = new IniPlugin(request, response, propIniPlugin);
		m_IP.init();
	} catch(Exception e) {
		e.printStackTrace();
	out.println("<br><b>(?)INISAFE Web Plugin Server SDK - Init() ERR(?)</b>");
			out.println("<br>FileName = 예제1_result.jsp");
			out.println("<br>Exception = " + e.getMessage());
			out.println("<br><br><b>printStackTrace</b><br>");
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			out.println(sw.toString());
			return;
	}

	//======================================================
	// 2. 인증서 유효성 확인
	//======================================================
	X509Certificate userCert = null;	
	int retOCSP = 0;	
	try {
		userCert = m_IP.getClientCertificate();	
		OCSPManager om = new OCSPManager("C:/WAS/initech/iniplugin/properties/jOCSP.properties");

		Enumeration e = om.request(userCert);		
		while(e.hasMoreElements()){
			SingleResponse sr = new SingleResponse(e);
			if(sr.isStatusGood()) {
				System.out.println("유효한 인증서 입니다.");
				retOCSP = 0;// 유효한 인증서입니다.
			} else if(sr.isStatusRevoked()){
				System.out.println("폐기된 인증서 입니다.");
				retOCSP = 103; // 폐기된 인증서입니다.
			} else if(sr.isStatusUnknown()){
				System.out.println("효력 정지 또는 알수 없는 인증서 입니다. ");
				retOCSP = 104; // 효력정지 또는 알수 없는 인증서입니다.}
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
		retOCSP = -1;
	}

	if(retOCSP==0) {
		certInfo += "<br><b>OCSP 결과 : 유효한 인증서입니다.</b>";
	} else if(retOCSP==103) {
	    certInfo += "<br><b>OCSP 결과 : 폐기된 인증서입니다.</b>";
	} else if(retOCSP==104) {
   		certInfo += "<br><b>OCSP 결과 : 효력정지 또는 알수 없는 인증서입니다.</b>";
   	} else if(retOCSP==-1) {
   		certInfo += "<br><b>OCSP 결과 : 유효성 검사에 실패하였습니다.</b>";
   	} 
%>
<%
	if( retOCSP==0)
	{
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// 인증서 발급일
		Date NotAfter = userCert.getNotAfter();		// 인증서 만기일
		Date currentTime = new Date();				// 현재 시간
		int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>인증서종류 : " + userCert.getSigAlgName();
		certInfo += "<br>발급자 : " + userCert.getIssuerDN().toString();
		certInfo += "<br>발급대상 : " + userCert.getSubjectDN().toString();
		certInfo += "<br>발급일 : " + myDate.format(NotBefore);
		certInfo += "<br>만료일 : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>현재시간 : " + myDate.format(currentTime);
		certInfo += "<br>고객님의 인증서는 ";
		certInfo += date;
		certInfo += "일 후에 만료가 됩니다.";
	}
%>

<html>
<head>
	<title></title>
</head>

<body>

<br><h3>사용자 인증 정보입니다.</h3>
<p><b>제출하신 사용자 인증서의 정보는 아래와 같습니다. 유효한 경우에만 인증서 정보가 보입니다.</b><br>
<%=certInfo%>

<br>
<br><br>
<center><input type=button value='되돌아가기' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>

</body></html>
