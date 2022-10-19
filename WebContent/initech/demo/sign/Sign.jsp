<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.net.URLDecoder" %>

<!--  이니텍 관련 -->
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="com.initech.inisafesign.*" %>
<%@ page import="com.initech.inisafesign.exception.*" %>
<%@ page import="com.initech.util.Base64Util" %>
<%@ include file ="../include/Init.jsp"%>

<head><title>Sign TEST</title>
</head>
<body>
<center>
<h3>---------- 전자서명 테스트 -------------</h3><p><br>
</center>

<%

  String orgData = "";
	String regDate = "";
	String dateTime = "";
	String DATEFORMATData = "yyyyMMddHHmmssSSS";
	
  //전자서명 데이터 추출
	String SignedDataWithBase64 = m_IP.getParameter("PKCS7SignedData");

	
	//##### Step 1. 전자서명 거래 유무 판단 ####
	if(SignedDataWithBase64 ==null || "".equals(SignedDataWithBase64)){
	
		// 전자서명 데이타가 아닙니다.. 에러 처리 
		out.println("<font size=2 color=000099><center><b>전자서명 데이타가 아닙니다.. 에러 페이지로 이동</b></center></font><br>");
	}

  try {
    // INISAFE Sign 초기화
	  INISAFESign signer =  new INISAFESign(SignedDataWithBase64, "C:/WAS/initech/iniplugin/properties/INISAFESign.properties");

	  //검증(인증서 검증, 서명 검증);
    //signer.verify(); 
      
	  //##### Step 2. 전자서명(#PKCS7) 검증  ####
	  boolean result = signer.verifyPKCS7();
	 
	  if (result) {
    	out.println("<font size=2 color=000099><br><b>PKCS7 검증이 정상적으로 이루어 졌습니다.</b></font><br>");	
    	
    } else {
    	// 서명 데이타 검증 실패 
    	out.println("<font size=2 color=000099><br><b>서명 데이타 검증 실패 </b></font><br>");
    }
    
    //##### Step 3. 인증서 검증  ####
    
    if (signer.verifyCertificatePath()) {
    //	 인증서  검증 성공
    	out.println("<font size=2 color=000099><br><b>인증서 검증이 정상적으로 이루어 졌습니다.</b></font><br>");
    } else {
    	//인증서  검증 실패 
    	out.println("<font size=2 color=000099><br><b>인증서 검증 실패 </b></font><br>");
    }
    
      // 원본데이터
	  orgData = signer.getData();

	  out.println("<br>SignedData OrgData : "+ URLDecoder.decode(orgData));

	  // 서명 날짜
	  regDate = signer.getSigningTime();
	  dateTime = com.initech.inisafesign.util.SignUtil.getLocalDateTime(DATEFORMATData);

	  out.println("<br>SignedData regDate: "+ regDate);
	  out.println("<br>SignedData dateTime: " + dateTime);
   
      //(PKCS7 서명데이터에서 인증서를 추출, 인증서의 정책 OID를 가지고 옴
      X509Certificate cert = signer.getCertificate();
      
      out.println("X509Certificate IssuerDN =" + cert.getIssuerDN().toString()+"<br>");
      out.println("X509Certificate SubjectDN =" + cert.getSubjectDN().toString()+"<br>");
      out.println("X509Certificate SerialNumber =" + cert.getSerialNumber()+"<br>");
      out.println("X509Certificate getNotBefore =" + cert.getNotBefore()+"<br>");
      out.println("X509Certificate getNotAfter =" + cert.getNotAfter()+"<br>");
      out.println("iniSign.getPKCS7Mgr() DataProperties = [ " + signer.getPKCS7Manager().getDataProperties() + "]"+"<br>");



	}catch(ClientSignException e) {
	  m_IniErrCode = "SIGN_001";
	  m_IniErrMsg  = "Exception : " + e.getMessage(); 
		
	} catch(SignPKCS7Exception e) {
		m_IniErrCode = "SIGN_002";
	  m_IniErrMsg  = "Exception : " + e.getMessage(); 
	  
	} catch(SignCertificateException e) {
		m_IniErrCode = "SIGN_003";
	  m_IniErrMsg  = "Exception : " + e.getMessage(); 
	  
	} catch(INISAFESignException e) {
		m_IniErrCode = "SIGN_004";
	  m_IniErrMsg  = "Exception : " + e.getMessage(); 
	  
	} catch(Exception e) {
		m_IniErrCode = "SIGN_999";
	  m_IniErrMsg  = "Exception : " + e.getMessage();
	}
	
	if(m_IniErrCode != null){
		out.println("<br><b>INISAFE Sign 검증 ERROR</b>");
		out.println("<hr>");
		out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
		out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
		//return;
		
	}

%>  

<p> 
<center><input type=button value="되돌아가기" onClick="history.back();">
</center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH Bank</font><br></p>
</body>
</html>
