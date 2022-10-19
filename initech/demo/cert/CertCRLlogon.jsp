<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.*" %>

<%@ page import="com.initech.iniplugin.vid.*" %>
<%@ page import="com.initech.iniplugin.crl.*" %>
<%@ page import="com.initech.iniplugin.crl.exception.*" %>
<%@ page import="com.initech.iniplugin.oid.* "%>

<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init.jsp"%>

<html>
<head>
	<title>CRL을 통한 인증서 로그인</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>
<%
    //======================================================
	  // 1. 암호화된 데이타 및 인증서 처리 : Init.jsp에서 처리
	  //======================================================
%>
<% out = m_IP.startEncrypt(out); %>
<%
	
	String certInfo = "";
	//각각의 모듈을 분리해서 처리

	X509Certificate userCert = null;
	String caFlag = "";	
	userCert = m_IP.getClientCertificate();
	String propOID = "C:/WAS/initech/iniplugin/properties/jCERTOID.properties";

	CheckCRL ccrl = null;
  boolean crlRet = false;
  String propCRL = "C:/WAS/initech/iniplugin/properties/CRL.properties";

	String juminHash = m_IP.getVIDRandom();
	String juminParam = m_IP.getParameter("juminNO");
	IDVerifier idv = new IDVerifier();
	boolean vidRet = false;

	try
	{
	  //======================================================
	  // 2. 상호연동용 인증서
	  //======================================================
	  CertOIDUtil cou = new CertOIDUtil(propOID);

		if (cou.checkOID(userCert) == true) {
      certInfo += "<br><b> OID 검증 : 상호연동용 인증서입니다.</b>";
			certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";
					
    } else {
      certInfo += "<br><b> OID 검증 : 상호연동용 인증서가 아닙니다.</b>";
	  	certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";
	  }

	  //======================================================
	  // 3. 인증서 유효성 확인
	  //======================================================
		ccrl = new CheckCRL();
    ccrl.init(propCRL);
    crlRet = ccrl.isValid(userCert);


		//======================================================
	  // 4. 본인확인체크
	  //======================================================
    vidRet = idv.checkVID(userCert, juminParam, juminHash.getBytes());

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
	  crlRet = false;
    vidRet = false;
				 
	}
	if(m_IniErrCode != null){
		out.println("<br><b>INISAFE Public PKI 검증 ERROR</b>");
		out.println("<hr>");
		out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
		out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
		//return;
		
	 }
	   	
	if( crlRet ) {
		certInfo += "<br><b>CRL 검증 : 제출한 인증서는 유효한 인증서입니다.</b>";
	} else {
	  certInfo += "<br><b>CRL 검증 : 제출한 인증서는 폐기된 인증서입니다.</b>";
	}

  if( vidRet ) {
	  certInfo += "<br><b>VID 검증 : 제출한 인증서는 본인의 인증서가 맞습니다.</b>";
	} else {
	  certInfo += "<br><b>VID 검증 : 제출한 인증서는 본인의 인증서가 아닙니다.</b>";
	}
	
   
%>
<%
	if( crlRet && vidRet ) // 각각 모듈 처리시 사용
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
		certInfo += "<br><br>INIplugnData : " +  request.getParameter("INIpluginData");
		certInfo += "<br><br>er( juminHash ) : " +  m_IP.getVIDRandom();
		certInfo += "<br><br>dt : " +  m_IP.getNotParsedData();
		certInfo += "<br><br>cc : " +  m_IP.getClientCertificate();
	}
%>
<% out = m_IP.endEncrypt(out); %>
<br><h3>사용자 인증 정보입니다.</h3>
<p><b>제출하신 사용자 인증서의 정보는 아래와 같습니다.</b><br>
<%=certInfo%>

<p><b>제출하신 인증서와 일치하는 주민등록번호는 아래와 같습니다. 유효한 경우에만 인증서 정보가 보입니다.</b><br>
<br><b>주민등록번호 =</b> [<%= juminParam %>]


<br><br>
<center><input type=button value='되돌아가기' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>


</body></html>
