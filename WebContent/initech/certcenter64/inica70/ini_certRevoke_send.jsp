<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certRevoke"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_userSet.jsp" %>
<%@ include file="import/inica70_ca_send.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>
<%@ include file="import/fncSMS.jsp" %>
<%
//인증서 발급 후 SMS발송 
//인증서 발급 후 SMS발송 
String smsFlag = "N";
smsFlag = sendSMS(m_How, m_ID, "");
%>
<%!
public static String makeCertString(String varName, String certificate)
{
	String certificate1 = null;
	String retString = null;
	String certContent = null;
	
	certContent = certificate.substring("-----BEGIN CERTIFICATE-----".length(), certificate.length() - ("-----END CERTIFICATE-----".length() + 1 ));
	
	StringTokenizer token = new StringTokenizer(certContent, "\n\r");

	while(token.hasMoreTokens()) {
		String temp = token.nextToken();
		if(certificate1 == null) {
			certificate1 = temp;
		} else if(certificate1.equals(null)) {
			System.out.println("Second Null");
		} else {
			certificate1 = certificate1 + temp;
		}
	}

	retString = varName + "=\"-----BEGIN CERTIFICATE-----\";\n" + varName + "+=\"\\n\";\n";
	
	StringReader reader = new StringReader(certificate1);
	
	char[] readbuf = new char[64];
	try {
		for(int i = 0; i < (int)Math.floor((certificate1.length() / 64)); i++) {
			reader.read(readbuf);
			String temp = varName + "+=\"" + new String(readbuf) + "\";\n";
			temp = temp + varName + "+=\"\\n\";\n";
			retString = retString + temp;
		}

		int rem = certificate1.length() % 64;
		if( rem != 0) {
			System.out.println("rem length : " + String.valueOf(rem));
			char[] buf = new char[rem];
			reader.read(buf);
			String temp = varName + "+=\"" + new String(buf) + "\";\n";
			
			temp = temp + varName + "+=\"\\n\";\n";
			retString = retString + temp;
		}

	} catch (Exception e) {
		System.out.println("Exception e");
		e.printStackTrace();
	}

	String temp = varName + "+=\"-----END CERTIFICATE-----\";\n";
	retString = retString + temp;

	return retString;
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
	<script language="javascript" src="/initech/plugin/INIutil.js"></script>
	<script language="javascript">
	function DeleteCert() {
	<% if(revokeCertString != null) { %>
		var CertResult0;
		<%= makeCertString("CertResult0", revokeCertString) %>
		DeleteUserCert(CertResult0);
	<% } %>
	}
	function setTimerMain() {
		setTimeout("location.href='/initech/certcenter64/inica70/index.jsp'",5000);
	}
	</script>

<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body  onload="javascript:DeleteCert();setTimerMain();">
<%// try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>
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
		<li class="toptxtcon01" style="text-decoration:underline;">인증서 폐기</li>
		<li class="toptxtcon01">인증서 관리</li>
	</ul>
</div>

<div id="sub2issue">
	<ul>
		<li><img src="img/subtitle0102.gif" alt="인증서폐기_인증서 분실(인증서 비밀번호를 잊어버린 경우, 이용하는 컴퓨터가 변경된 경우, 인증서가 삭제 된 경우)시 다시 인증서를 발급받
으시면 사용 가능합니다."></li>
		<li class="stitle"><img src="img/subtitle0206.gif" alt="인증서폐기_완료"></li>
		<li class="box">
			<ul>
				<li class="sbtextbg2"><img src="img/bullet_list.gif" align="center"> <b class="txblue"><%=certUserNm%>(<%=m_ID%>)</b>님의 인증서가 성공적으로 폐기가 되었습니다.</li>
				<li class="sbtextbg2"><img src="img/bullet_list.gif" align="center"> 인증서의 유효기간은 
					<%
					if ("69".equals(m_POLICY)) {
						out.print("1개월");
					} else if ("70".equals(m_POLICY)) {
						out.print("2개월");
					} else if ("71".equals(m_POLICY)) {
						out.print("3개월");
					} else if ("72".equals(m_POLICY)) {
						out.print("4개월");
					} else if ("73".equals(m_POLICY)) {
						out.print("5개월");
					} else if ("74".equals(m_POLICY)) {
						out.print("6개월");
					} else if ("75".equals(m_POLICY)) {
						out.print("7개월");
					} else if ("76".equals(m_POLICY)) {
						out.print("8개월");
					} else if ("77".equals(m_POLICY)) {
						out.print("9개월");
					} else if ("78".equals(m_POLICY)) {
						out.print("10개월");
					} else if ("79".equals(m_POLICY)) {
						out.print("11개월");
					} else if ("80".equals(m_POLICY)) {
						out.print("12개월");
					}
					%>				
				개월이며, 유효기간이 지난 인증서는 사용하실 수 없습니다.</li>
				<li class="sbtextbg2"><img src="img/bullet_list.gif" align="center"> PowerNet 로그인을 위해서 PowerNet ToolBand의 통합인증을 클릭하십시오. 이용해주셔서 감사합니다</li>
				<li class="dotted1"></li>
				<li class="sbtextbg2" style="padding:15px; 0 15px 0 ">&nbsp;</li>

				<li class="sbtextbg"> - 인증서 분실(인증서 비밀번호를 잊어버린 경우, 이용하는 컴퓨터가 변경 된 경우, 인증서가 삭제된 
... 경우)시 인증서를 폐기한 후, 발급받으시면 사용 가능합니다. </li>
				
				<li style="text-align:center;"><a href="index.jsp"><img src="img/btn_cen_fir.gif" alt="인증센터 초기화면"></a></li>
				
			</ul>
		</li>
		
	</ul>
	<div style="height:90px;"></div>
</div>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

<%// try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>
</body>
</html>

