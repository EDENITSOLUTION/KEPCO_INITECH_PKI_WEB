<%@ page language="java" %>
<%@ page import="java.io.*, java.util.*, java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="java.security.cert.CertificateFactory" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="com.initech.util.*" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ include file="./config.jsp" %>

<%
	boolean bEncrypt = false;
	String tmp = m_IP.getParameter("encrypt");
	if ((tmp != null) && tmp.equals("on"))
	{
		bEncrypt = true;
	}

	// ������ �ʿ��� ������ ���� üũ �� ������ ��������
	String strClientAuth = null;
	String certInfo = "";
	String subjectDN = "";
	String IssuerDN = "";
	String userCertString = null;
	String x509String = null;
	String pemtype = null;
	String x509String_1 = null;

	if (m_IP.isClientAuth() == false)
	{
		strClientAuth = "�����(Client) �������� ������ �ʾҽ��ϴ�.";
	}
	else
	{
		try
		{
			strClientAuth = "�����(Client) �������� ������ �Ʒ��� �����ϴ�.";

			X509Certificate userCert_a = m_IP.getClientCertificate();

			userCertString = m_IP.getClientCertificate2();  // ������ PEM���·� �̱�
			System.out.println(userCertString);

			X509Certificate userCert = parseX509Cert(userCertString);	// PEM������ �������� x509 ���·�

			x509String = userCert.toString();
			System.out.println(x509String);

			pemtype = x509CertificateToPem(userCert);
			System.out.println(pemtype);

			userCert = parseX509Cert(pemtype);
			x509String = userCert.toString();
			System.out.println(x509String);

			subjectDN = userCert.getSubjectDN().toString();

			int certGubun = 0;	// ������ ���� : �缳(0), �ݰ��(1), Ÿ���OCSP(2>=)

			DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
			Date NotBefore = userCert.getNotBefore();	// ������ �߱���
			Date NotAfter = userCert.getNotAfter();		// ������ ������
			Date currentTime = new Date();				// ���� �ð�
			int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

			certInfo += "<br>�߱���[<b>" + userCert.getIssuerDN().toString() + "</b>]";
			certInfo += "<br>�߱޴��[<b>" + userCert.getSubjectDN().toString() + "</b>]";
			certInfo += "<br>�߱���[<b>" + myDate.format(NotBefore) + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;������[<b>" + myDate.format(NotAfter) + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;Serial[<b>" + userCert.getSerialNumber().toString() + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;Serial(10����)[<b>" + userCert.getSerialNumber().toString(10) + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;Serial(16����)[<b>" + userCert.getSerialNumber().toString(16) + "</b>]";
			certInfo += "<br>�߱ް������������ <b>";

			IssuerDN = userCert.getIssuerDN().toString().toUpperCase();
			out.println("<Br><Br>IssuerDN ==> " + IssuerDN);
			if (IssuerDN.indexOf("O=�缳") > -1)							certGubun = 0;	// �缳
			else if (IssuerDN.indexOf("O=yessign".toUpperCase()) >- 1)		certGubun = 1;	// �ݰ������
			else if (IssuerDN.indexOf("O=SignKorea".toUpperCase()) >- 1)	certGubun = 2;	// ��������
			else if (IssuerDN.indexOf("O=NCASign".toUpperCase()) >- 1)		certGubun = 3;	// �����
			else if (IssuerDN.indexOf("O=TradeSign".toUpperCase()) >- 1)	certGubun = 4;	// �����������
			else if (IssuerDN.indexOf("O=CrossCert".toUpperCase()) >- 1)	certGubun = 5;	// ��������
			else if (IssuerDN.indexOf("O=KICA".toUpperCase()) >- 1)			certGubun = 6;	// ��������
			else															certGubun = 10;	// ��Ÿ����

			if (certGubun == 0)			certInfo += "�缳";
			else if (certGubun == 1)	certInfo += "�ݰ��";
			else if (certGubun == 2)	certInfo += "��������";
			else if (certGubun == 3)	certInfo += "�����";
			else if (certGubun == 4)	certInfo += "�����������";
			else if (certGubun == 5)	certInfo += "��������";
			else if (certGubun == 6)	certInfo += "��������";
			else						certInfo += "��Ÿ����";

			certInfo += "</b>�̸� ������ �������� ";
			certInfo += date;
			certInfo += "�� �Ŀ� ���ᰡ �˴ϴ�.";
		}
		catch (Exception eee)
		{
			out.println("<br><b>(?)Certificate Info() ERR</b>");
			out.println("<br>FileName = CryptoTest.jsp");
			out.println("<br>Exception = " + eee.getMessage());
			out.println("<br><br><b>printStackTrace</b><br>");
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			eee.printStackTrace(pw);
			out.println(sw.toString());
			return;
		}
	}
%>

<%!
	/** PEM Ÿ���� ������ ��� */
	public static final String PEM_BEGIN_STR = "-----BEGIN CERTIFICATE-----\n";
	/** PEM Ÿ���� ������ ���� */
	public static final String PEM_END_STR = "-----END CERTIFICATE-----";

	// PEM���Ŀ��� x509��~~~

	public X509Certificate parseX509Cert(String certStr) throws Exception
	{
		String str = null;
		X509Certificate x509Cert = null;
		ByteArrayInputStream baIn = null;
		CertificateFactory certFactory = null;

		try
		{
			baIn = new ByteArrayInputStream(certStr.getBytes());
			certFactory = getCertificateFactory();
			x509Cert = (X509Certificate) certFactory.generateCertificate(baIn);
		}
		catch (Exception e)
		{
			throw new Exception(e.getMessage());
		}
		finally
		{
			try
			{
				baIn.close();
			}
			catch (Exception e) {}
		}

		return x509Cert;
	}

	public CertificateFactory getCertificateFactory() throws Exception
	{
		CertificateFactory certFactory = null;
		certFactory = CertificateFactory.getInstance("X.509", AutoProvider.providerName);
		return certFactory;
	}

	// x509 ���� pem ��������~~
	public static String x509CertificateToPem(X509Certificate cert) throws Exception
	{
		byte[] asn1encoded = null;
		byte[] base64encoded = null;
		String certStr = null;
		try
		{
			asn1encoded = cert.getEncoded();
			base64encoded = Base64Util.encode(asn1encoded);
			certStr = PEM_BEGIN_STR + new String(base64encoded) + PEM_END_STR;
		}
		catch (Exception e)
		{
			throw new Exception(e.getMessage());
		}

		return certStr;
	}
	
%>


<html>
<head>
	<title>INISAFE Web Plugin - SDKex02 Result</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript">
		function SecureSubmit(form)
		{
			alert("1");
			InitCache();
			var filter = "SubjectDN=" + '<%=subjectDN%>';
			var data = "aaaa";
			FilterUserCert("", filter);
			if (PKCS7SignedData(form, data, false) == true)
			{
				// ��ȣȭ ���� (������� : EncFormVerify -> EncForm)
				if (EncForm(form) == true)
				{
					return true;
				}
				else
				{
					alert("��ȣȭ�� �����߽��ϴ�.");
					return false;
				}
			}
			else
			{
				alert("���ڼ��� �����߽��ϴ�.");
				return false;
			}

			return false;
		}
	</script>
</head>

<body bgcolor="#ffffff" text="#000000" style="font-size:9pt;">

<table width="800" border="0" cellspacing="0" cellpadding="2" >
	<tr>
		<td bgcolor="#828DA6">
			<font color="#ffffff" face="arial,helvetica,sanserif">
		</td>
	</tr>
</table>

<table width="800">
<br><b><%=strClientAuth%></b>
<%=certInfo%>
<br>
<br><b>���� Client ������ ������ �Ʒ��� �����ϴ�.</b>
<br>getRemoteAddr[<b><%=request.getRemoteAddr()%></b>]
&nbsp;&nbsp;getMethod[<b><%=request.getMethod()%></b>]
<br>User-Agent[<b><%=request.getHeader("User-Agent")%></b>]
<br>
<%
	if (bEncrypt)
	{
		out = m_IP.endEncrypt(out);
	}
%>

</body>
</html>
