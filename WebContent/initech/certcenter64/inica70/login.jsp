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

	// 인증이 필요한 페이지 인지 체크 및 인증서 정보보기
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
		strClientAuth = "사용자(Client) 인증서가 사용되지 않았습니다.";
	}
	else
	{
		try
		{
			strClientAuth = "사용자(Client) 인증서의 정보는 아래와 같습니다.";

			X509Certificate userCert_a = m_IP.getClientCertificate();

			userCertString = m_IP.getClientCertificate2();  // 인증서 PEM형태로 뽑기
			System.out.println(userCertString);

			X509Certificate userCert = parseX509Cert(userCertString);	// PEM형식의 인증서를 x509 형태로

			x509String = userCert.toString();
			System.out.println(x509String);

			pemtype = x509CertificateToPem(userCert);
			System.out.println(pemtype);

			userCert = parseX509Cert(pemtype);
			x509String = userCert.toString();
			System.out.println(x509String);

			subjectDN = userCert.getSubjectDN().toString();

			int certGubun = 0;	// 인증서 구분 : 사설(0), 금결원(1), 타기관OCSP(2>=)

			DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
			Date NotBefore = userCert.getNotBefore();	// 인증서 발급일
			Date NotAfter = userCert.getNotAfter();		// 인증서 만기일
			Date currentTime = new Date();				// 현재 시간
			int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));

			certInfo += "<br>발급자[<b>" + userCert.getIssuerDN().toString() + "</b>]";
			certInfo += "<br>발급대상[<b>" + userCert.getSubjectDN().toString() + "</b>]";
			certInfo += "<br>발급일[<b>" + myDate.format(NotBefore) + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;만료일[<b>" + myDate.format(NotAfter) + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;Serial[<b>" + userCert.getSerialNumber().toString() + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;Serial(10진수)[<b>" + userCert.getSerialNumber().toString(10) + "</b>]";
			certInfo += "&nbsp;&nbsp;&nbsp;Serial(16진수)[<b>" + userCert.getSerialNumber().toString(16) + "</b>]";
			certInfo += "<br>발급공인인증기관은 <b>";

			IssuerDN = userCert.getIssuerDN().toString().toUpperCase();
			out.println("<Br><Br>IssuerDN ==> " + IssuerDN);
			if (IssuerDN.indexOf("O=사설") > -1)							certGubun = 0;	// 사설
			else if (IssuerDN.indexOf("O=yessign".toUpperCase()) >- 1)		certGubun = 1;	// 금결원공인
			else if (IssuerDN.indexOf("O=SignKorea".toUpperCase()) >- 1)	certGubun = 2;	// 증권전산
			else if (IssuerDN.indexOf("O=NCASign".toUpperCase()) >- 1)		certGubun = 3;	// 전산원
			else if (IssuerDN.indexOf("O=TradeSign".toUpperCase()) >- 1)	certGubun = 4;	// 무역정보통신
			else if (IssuerDN.indexOf("O=CrossCert".toUpperCase()) >- 1)	certGubun = 5;	// 전자인증
			else if (IssuerDN.indexOf("O=KICA".toUpperCase()) >- 1)			certGubun = 6;	// 정보인증
			else															certGubun = 10;	// 기타공인

			if (certGubun == 0)			certInfo += "사설";
			else if (certGubun == 1)	certInfo += "금결원";
			else if (certGubun == 2)	certInfo += "증권전산";
			else if (certGubun == 3)	certInfo += "전산원";
			else if (certGubun == 4)	certInfo += "무역정보통신";
			else if (certGubun == 5)	certInfo += "전자인증";
			else if (certGubun == 6)	certInfo += "정보인증";
			else						certInfo += "기타공인";

			certInfo += "</b>이며 고객님의 인증서는 ";
			certInfo += date;
			certInfo += "일 후에 만료가 됩니다.";
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
	/** PEM 타입의 인증서 헤더 */
	public static final String PEM_BEGIN_STR = "-----BEGIN CERTIFICATE-----\n";
	/** PEM 타입의 인증서 테일 */
	public static final String PEM_END_STR = "-----END CERTIFICATE-----";

	// PEM형식에서 x509로~~~

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

	// x509 에서 pem 형식으로~~
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
				// 암호화 수행 (변경사항 : EncFormVerify -> EncForm)
				if (EncForm(form) == true)
				{
					return true;
				}
				else
				{
					alert("암호화에 실패했습니다.");
					return false;
				}
			}
			else
			{
				alert("전자서명에 실패했습니다.");
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
<br><b>접속 Client 브라우져 정보는 아래와 같습니다.</b>
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
