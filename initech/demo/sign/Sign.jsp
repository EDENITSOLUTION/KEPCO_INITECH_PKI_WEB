<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.net.URLDecoder" %>

<!--  �̴��� ���� -->
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
<h3>---------- ���ڼ��� �׽�Ʈ -------------</h3><p><br>
</center>

<%

  String orgData = "";
	String regDate = "";
	String dateTime = "";
	String DATEFORMATData = "yyyyMMddHHmmssSSS";
	
  //���ڼ��� ������ ����
	String SignedDataWithBase64 = m_IP.getParameter("PKCS7SignedData");

	
	//##### Step 1. ���ڼ��� �ŷ� ���� �Ǵ� ####
	if(SignedDataWithBase64 ==null || "".equals(SignedDataWithBase64)){
	
		// ���ڼ��� ����Ÿ�� �ƴմϴ�.. ���� ó�� 
		out.println("<font size=2 color=000099><center><b>���ڼ��� ����Ÿ�� �ƴմϴ�.. ���� �������� �̵�</b></center></font><br>");
	}

  try {
    // INISAFE Sign �ʱ�ȭ
	  INISAFESign signer =  new INISAFESign(SignedDataWithBase64, "C:/WAS/initech/iniplugin/properties/INISAFESign.properties");

	  //����(������ ����, ���� ����);
    //signer.verify(); 
      
	  //##### Step 2. ���ڼ���(#PKCS7) ����  ####
	  boolean result = signer.verifyPKCS7();
	 
	  if (result) {
    	out.println("<font size=2 color=000099><br><b>PKCS7 ������ ���������� �̷�� �����ϴ�.</b></font><br>");	
    	
    } else {
    	// ���� ����Ÿ ���� ���� 
    	out.println("<font size=2 color=000099><br><b>���� ����Ÿ ���� ���� </b></font><br>");
    }
    
    //##### Step 3. ������ ����  ####
    
    if (signer.verifyCertificatePath()) {
    //	 ������  ���� ����
    	out.println("<font size=2 color=000099><br><b>������ ������ ���������� �̷�� �����ϴ�.</b></font><br>");
    } else {
    	//������  ���� ���� 
    	out.println("<font size=2 color=000099><br><b>������ ���� ���� </b></font><br>");
    }
    
      // ����������
	  orgData = signer.getData();

	  out.println("<br>SignedData OrgData : "+ URLDecoder.decode(orgData));

	  // ���� ��¥
	  regDate = signer.getSigningTime();
	  dateTime = com.initech.inisafesign.util.SignUtil.getLocalDateTime(DATEFORMATData);

	  out.println("<br>SignedData regDate: "+ regDate);
	  out.println("<br>SignedData dateTime: " + dateTime);
   
      //(PKCS7 �������Ϳ��� �������� ����, �������� ��å OID�� ������ ��
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
		out.println("<br><b>INISAFE Sign ���� ERROR</b>");
		out.println("<hr>");
		out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
		out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
		//return;
		
	}

%>  

<p> 
<center><input type=button value="�ǵ��ư���" onClick="history.back();">
</center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH Bank</font><br></p>
</body>
</html>
