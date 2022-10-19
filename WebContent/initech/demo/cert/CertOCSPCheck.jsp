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
	// 1. ��ȣȭ�� ����Ÿ �� ������ ó��
	//======================================================
    IniPlugin m_IP = null;
    String propIniPlugin = "C:/WAS/initech/iniplugin/properties/IniPlugin.properties";
    
	try {
       	m_IP = new IniPlugin(request, response, propIniPlugin);
		m_IP.init();
	} catch(Exception e) {
		e.printStackTrace();
	out.println("<br><b>(?)INISAFE Web Plugin Server SDK - Init() ERR(?)</b>");
			out.println("<br>FileName = ����1_result.jsp");
			out.println("<br>Exception = " + e.getMessage());
			out.println("<br><br><b>printStackTrace</b><br>");
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			out.println(sw.toString());
			return;
	}

	//======================================================
	// 2. ������ ��ȿ�� Ȯ��
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
				System.out.println("��ȿ�� ������ �Դϴ�.");
				retOCSP = 0;// ��ȿ�� �������Դϴ�.
			} else if(sr.isStatusRevoked()){
				System.out.println("���� ������ �Դϴ�.");
				retOCSP = 103; // ���� �������Դϴ�.
			} else if(sr.isStatusUnknown()){
				System.out.println("ȿ�� ���� �Ǵ� �˼� ���� ������ �Դϴ�. ");
				retOCSP = 104; // ȿ������ �Ǵ� �˼� ���� �������Դϴ�.}
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
		retOCSP = -1;
	}

	if(retOCSP==0) {
		certInfo += "<br><b>OCSP ��� : ��ȿ�� �������Դϴ�.</b>";
	} else if(retOCSP==103) {
	    certInfo += "<br><b>OCSP ��� : ���� �������Դϴ�.</b>";
	} else if(retOCSP==104) {
   		certInfo += "<br><b>OCSP ��� : ȿ������ �Ǵ� �˼� ���� �������Դϴ�.</b>";
   	} else if(retOCSP==-1) {
   		certInfo += "<br><b>OCSP ��� : ��ȿ�� �˻翡 �����Ͽ����ϴ�.</b>";
   	} 
%>
<%
	if( retOCSP==0)
	{
		DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
		Date NotBefore = userCert.getNotBefore();	// ������ �߱���
		Date NotAfter = userCert.getNotAfter();		// ������ ������
		Date currentTime = new Date();				// ���� �ð�
		int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

		certInfo += "<br>���������� : " + userCert.getSigAlgName();
		certInfo += "<br>�߱��� : " + userCert.getIssuerDN().toString();
		certInfo += "<br>�߱޴�� : " + userCert.getSubjectDN().toString();
		certInfo += "<br>�߱��� : " + myDate.format(NotBefore);
		certInfo += "<br>������ : " + myDate.format(NotAfter);
		certInfo += "<br>Serial : " + userCert.getSerialNumber().toString(10);
		certInfo += "<br>����ð� : " + myDate.format(currentTime);
		certInfo += "<br>������ �������� ";
		certInfo += date;
		certInfo += "�� �Ŀ� ���ᰡ �˴ϴ�.";
	}
%>

<html>
<head>
	<title></title>
</head>

<body>

<br><h3>����� ���� �����Դϴ�.</h3>
<p><b>�����Ͻ� ����� �������� ������ �Ʒ��� �����ϴ�. ��ȿ�� ��쿡�� ������ ������ ���Դϴ�.</b><br>
<%=certInfo%>

<br>
<br><br>
<center><input type=button value='�ǵ��ư���' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>

</body></html>
