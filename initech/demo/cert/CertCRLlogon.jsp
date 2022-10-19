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
	<title>CRL�� ���� ������ �α���</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>
<%
    //======================================================
	  // 1. ��ȣȭ�� ����Ÿ �� ������ ó�� : Init.jsp���� ó��
	  //======================================================
%>
<% out = m_IP.startEncrypt(out); %>
<%
	
	String certInfo = "";
	//������ ����� �и��ؼ� ó��

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
	  // 2. ��ȣ������ ������
	  //======================================================
	  CertOIDUtil cou = new CertOIDUtil(propOID);

		if (cou.checkOID(userCert) == true) {
      certInfo += "<br><b> OID ���� : ��ȣ������ �������Դϴ�.</b>";
			certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";
					
    } else {
      certInfo += "<br><b> OID ���� : ��ȣ������ �������� �ƴմϴ�.</b>";
	  	certInfo += "<br><b>OID=[" + cou.getCertOID() + "]";
	  }

	  //======================================================
	  // 3. ������ ��ȿ�� Ȯ��
	  //======================================================
		ccrl = new CheckCRL();
    ccrl.init(propCRL);
    crlRet = ccrl.isValid(userCert);


		//======================================================
	  // 4. ����Ȯ��üũ
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
		out.println("<br><b>INISAFE Public PKI ���� ERROR</b>");
		out.println("<hr>");
		out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
		out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
		//return;
		
	 }
	   	
	if( crlRet ) {
		certInfo += "<br><b>CRL ���� : ������ �������� ��ȿ�� �������Դϴ�.</b>";
	} else {
	  certInfo += "<br><b>CRL ���� : ������ �������� ���� �������Դϴ�.</b>";
	}

  if( vidRet ) {
	  certInfo += "<br><b>VID ���� : ������ �������� ������ �������� �½��ϴ�.</b>";
	} else {
	  certInfo += "<br><b>VID ���� : ������ �������� ������ �������� �ƴմϴ�.</b>";
	}
	
   
%>
<%
	if( crlRet && vidRet ) // ���� ��� ó���� ���
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
		certInfo += "<br><br>INIplugnData : " +  request.getParameter("INIpluginData");
		certInfo += "<br><br>er( juminHash ) : " +  m_IP.getVIDRandom();
		certInfo += "<br><br>dt : " +  m_IP.getNotParsedData();
		certInfo += "<br><br>cc : " +  m_IP.getClientCertificate();
	}
%>
<% out = m_IP.endEncrypt(out); %>
<br><h3>����� ���� �����Դϴ�.</h3>
<p><b>�����Ͻ� ����� �������� ������ �Ʒ��� �����ϴ�.</b><br>
<%=certInfo%>

<p><b>�����Ͻ� �������� ��ġ�ϴ� �ֹε�Ϲ�ȣ�� �Ʒ��� �����ϴ�. ��ȿ�� ��쿡�� ������ ������ ���Դϴ�.</b><br>
<br><b>�ֹε�Ϲ�ȣ =</b> [<%= juminParam %>]


<br><br>
<center><input type=button value='�ǵ��ư���' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>


</body></html>
