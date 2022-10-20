<%@ page language="java" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.io.*, java.util.*, java.lang.*, java.text.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="java.security.cert.CertificateFactory" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="com.initech.util.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ include file="./config.jsp" %>
<%
	boolean bEncrypt = false;
	String tmp = m_IP.getParameter("encrypt");
	if ((tmp != null) && tmp.equals("on"))
	{
		bEncrypt = true;
	}


	//인증서 serial번호로 인증서 상태 검증
	Context ict = new InitialContext();
	DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
	ResultSet rs = null;

	Connection conn = null;
	Statement stmt = null;

	// 인증이 필요한 페이지 인지 체크 및 인증서 정보보기
	String strClientAuth = null;
	String certInfo = "";
	String subjectDN = "";
	String IssuerDN = "";
	String userCertString = null;
	String x509String = null;
	String pemtype = null;
	String x509String_1 = null;
	String strNotBefore = ""; //인증서 발급일
	String strNotAfter = "" ; //인증서 만료일
	String strSerial = "" ; //인증서 시리얼
	String strCertOrg = "" ; //인증서 발급기관
	String strCertValid = "폐기" ; //인증서 상태
	int defDate = 0 ;
	int rsCnt = 0 ;

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
			//System.out.println(userCertString);

			X509Certificate userCert = parseX509Cert(userCertString);	// PEM형식의 인증서를 x509 형태로

			x509String = userCert.toString();
			//System.out.println(x509String);

			pemtype = x509CertificateToPem(userCert);
			//System.out.println(pemtype);

			userCert = parseX509Cert(pemtype);
			x509String = userCert.toString();
			//System.out.println(x509String);

			subjectDN = userCert.getSubjectDN().toString();

			int certGubun = 0;	// 인증서 구분 : 사설(0), 금결원(1), 타기관OCSP(2>=)

			DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
			java.util.Date NotBefore = userCert.getNotBefore();	// 인증서 발급일
			java.util.Date NotAfter = userCert.getNotAfter();		// 인증서 만기일
			java.util.Date currentTime = new java.util.Date();				// 현재 시간
			int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));
			defDate = date ;

			strNotBefore = myDate.format(NotBefore) ;
			strNotAfter = myDate.format(NotAfter) ;
			strSerial = userCert.getSerialNumber().toString(10) ;
			//certInfo += "&nbsp;&nbsp;&nbsp;Serial[<b>" + userCert.getSerialNumber().toString() + "</b>]";
			//certInfo += "&nbsp;&nbsp;&nbsp;Serial(10진수)[<b>" + userCert.getSerialNumber().toString(10) + "</b>]";
			//certInfo += "&nbsp;&nbsp;&nbsp;Serial(16진수)[<b>" + userCert.getSerialNumber().toString(16) + "</b>]";
			
			
			//try {
				conn = ds.getConnection();
				stmt = conn.createStatement();
				rs = stmt.executeQuery("select count(serial) as cnt from ldap_info where to_char(to_number(serial)) = '"+ strSerial +"'");
				
				while( rs.next() ) {
					rsCnt = rs.getInt("cnt");
				}
				if (rsCnt == 0){
					strCertValid = "폐기된 인증서";
				}else{
					strCertValid = "유효한 인증서";
				}
			//} catch(Exception e) {
				//e.printStackTrace();
			//} finally {
				rs.close();
				conn.close();
			//}

			IssuerDN = userCert.getIssuerDN().toString().toUpperCase();
			//out.println("<Br><Br>IssuerDN ==> " + IssuerDN);
			if (IssuerDN.indexOf("O=사설") > -1)							certGubun = 0;	// 사설
			else if (IssuerDN.indexOf("O=yessign".toUpperCase()) >- 1)		certGubun = 1;	// 금결원공인
			else if (IssuerDN.indexOf("O=SignKorea".toUpperCase()) >- 1)	certGubun = 2;	// 증권전산
			else if (IssuerDN.indexOf("O=NCASign".toUpperCase()) >- 1)		certGubun = 3;	// 전산원
			else if (IssuerDN.indexOf("O=TradeSign".toUpperCase()) >- 1)	certGubun = 4;	// 무역정보통신
			else if (IssuerDN.indexOf("O=CrossCert".toUpperCase()) >- 1)	certGubun = 5;	// 전자인증
			else if (IssuerDN.indexOf("O=KICA".toUpperCase()) >- 1)			certGubun = 6;	// 정보인증
			else															certGubun = 10;	// 기타공인

			if (certGubun == 0)			strCertOrg += "사설";
			else if (certGubun == 1)	strCertOrg += "금결원";
			else if (certGubun == 2)	strCertOrg += "증권전산";
			else if (certGubun == 3)	strCertOrg += "전산원";
			else if (certGubun == 4)	strCertOrg += "무역정보통신";
			else if (certGubun == 5)	strCertOrg += "전자인증";
			else if (certGubun == 6)	strCertOrg += "정보인증";
			else						strCertOrg += "한국전력공사";

			
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


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=11"/>
<title>인증센터 이용안내</title>
<link rel="stylesheet" type="text/css" href="css/import.css" />
<link rel="stylesheet" type="text/css" href="css/main.css" />

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.flexslider-min.js"></script>
<script type="text/javascript" src="js/jquery.als-1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>
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
<style type="text/css">
.wTable {
	width:930px;
	border-top : solid 1px #c5c5c5;
	border-left : solid 1px #c5c5c5;
}
.wTableTdHeader {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	text-align : center;
	font-weight : bold;
	background-color : #eeeeee ;
	padding : 4px;
}
.wTableTdCell {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffff ;
	padding : 4px;
}
.wTableTdSearch {
	border-right : solid 1px #c5c5c5;
	border-bottom : solid 1px #c5c5c5;
	font-weight : normal;
	background-color : #ffffff ;
	padding : 5px;
}
.wTableTdSearch1 {
	border-right : solid 1px #c5c5c5;
	
	font-weight : normal;
	background-color : #ffffff ;
	padding : 5px;
}
</style>
<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body>

<div id="header">
	<!-- MAIN MENU START -->
	<script language="javascript">dspMainMenu();</script>
	<!-- MAIN MENU END -->
</div>

<div style="height:10px;"></div>
<div id="subtop">
	<ul class="subtoptxt">
		<li class="toptxtcon">인증센터 이용하기</li>
		<li class="toptxtcon01">인증서 발급</li>
		<li class="toptxtcon01">인증서 폐기</li>
		<li class="toptxtcon01" style="text-decoration:underline;">인증서 관리</li>
	</ul>
</div>
<div id="subissue">
	<ul>
		<li><img src="img/subtitle_mycertInfo.gif" alt="나의 인증서 조회"></li>
		<li class="stitle">&nbsp;</li>
		
		<li class="box" style="height:340px;">
			<ul>
				<li class="sbtextbg" style="color:#336699;font-weight:bold;"> - <%=strClientAuth%></li>
				
				<li style="float:left;padding-left:5px;">
<table cellSpacing="0" cellPadding="0" width="95%" border="0" class="wTable">
	<tr>
		<td class="wTableTdHeader" style="width:150px" >인증서 발급자</td>
		<td class="wTableTdCell"><%=IssuerDN%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">인증서 발급 기관</td>
		<td class="wTableTdCell"><%=strCertOrg%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">사용자 인증서 정보</td>
		<td class="wTableTdCell"><%=subjectDN%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">사용자 인증서 상태</td>
		<td class="wTableTdCell" style="font-weight:bold;color:#ff3366;"><%=strCertValid%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">인증서 발급일</td>
		<td class="wTableTdCell"><%=strNotBefore.substring(0,10)%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">인증서 만료일</td>
		<td class="wTableTdCell"><%if (rsCnt == 0){%>폐기<%}else{%><%=strNotAfter.substring(0,10)%><%}%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">인증서 시리얼번호</td>
		<td class="wTableTdCell"><%=strSerial%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">만료까지 남은 일 수</td>
		<td class="wTableTdCell">
		<%if (rsCnt == 0){%>폐기<%}else{%><%=defDate%> 일<%}%>
		</td>
	</tr>
	<tr>
		<td class="wTableTdHeader">사용자 IP</td>
		<td class="wTableTdCell"><%=request.getRemoteAddr()%></td>
	</tr>
	<tr>
		<td class="wTableTdHeader">사용자 브라우저 정보</td>
		<td class="wTableTdCell"><%=request.getHeader("User-Agent")%></td>
	</tr>
</table>
<br />
<table cellSpacing="0" cellPadding="0" width="100%" border="0">
	<tr>
		<td style="text-align:center;">
			<img src="img/btn_myCert_info.gif" border="0" alt="인증서 다시 조회" style="cursor:pointer;"  onclick="location.href='ini_myCert_info.jsp';">
			<a href="#" onclick="location.href='index.jsp';"><img src="img/btn_myCert_info_cancel.gif" alt="메인 페이지 바로가기"></a>
		</td>
	</tr>
</table>
				</li>
			</ul>
		</li>
	</ul>

	<div style="height:10px;"></div>
</div>



<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

</body>
</html>
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