<%-- CertCRLCheck.jsp --%>
<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>

<%@ page import="java.security.*,java.security.cert.*"%>
<%@ page import="com.initech.iniplugin.crl.CheckCRL" %>
<%@ page import="com.initech.iniplugin.crl.exception.*" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init.jsp"%>

<html>
<head>
	<title>INISAFE Public PKI CRL Result</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>


<% out = m_IP.startEncrypt(out); %>
<%

	  X509Certificate cert = null;
	  CheckCRL ccrl = null;
	  boolean returnFlag = false;
	  
	  String crlConfig = "/home/initech/iniplugin/properties/CRL.properties";
	
		//������ �ʿ��� ������ ���� üũ
	  if (m_IP.isClientAuth() == false) {
	        m_IniErrCode = "PPKI_000";
	        m_IniErrMsg  = "Exception : Cert is null"; 

	  } else {
		  //����� �������� ����.
			cert = m_IP.getClientCertificate();
	

			try {
				 ccrl = new CheckCRL();
				 ccrl.init(crlConfig);
			
				 //��ȿ�� ���������� �˻�.
				 returnFlag = ccrl.isValid(cert);
				 //out.println(" ������ ������� : [" + returnFlag + "]");
				 if(!returnFlag)
					 out.println(" <br><b>������ �������� ���� ������ �Դϴ�.</b>");
				 else
					 out.println(" <br><b>������ �������� ��밡���� ��ȿ�� ������ �Դϴ�.</b>"); 
					 
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
		 }
		 if(m_IniErrCode != null){
		    out.println("<br><b>INISAFE Public PKI ���� ERROR</b>");
		    out.println("<hr>");
		    out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
		    out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
		    //return;
		
	   }

%>
<% out = m_IP.endEncrypt(out); %>
</span></font>
		</td>
	</tr>
</table>


<br><br>
<center><input type=button value='�ǵ��ư���' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>


</body>
</html>