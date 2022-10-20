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
//������ �߱� �� SMS�߼� 
//������ �߱� �� SMS�߼� 
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
<title>�������� �̿�ȳ�</title>
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
		<li class="toptxtcon">�������� �̿��ϱ�</li>
		<li class="toptxtcon01">������ �߱�</li>
		<li class="toptxtcon01" style="text-decoration:underline;">������ ���</li>
		<li class="toptxtcon01">������ ����</li>
	</ul>
</div>

<div id="sub2issue">
	<ul>
		<li><img src="img/subtitle0102.gif" alt="���������_������ �н�(������ ��й�ȣ�� �ؾ���� ���, �̿��ϴ� ��ǻ�Ͱ� ����� ���, �������� ���� �� ���)�� �ٽ� �������� �߱޹�
���ø� ��� �����մϴ�."></li>
		<li class="stitle"><img src="img/subtitle0206.gif" alt="���������_�Ϸ�"></li>
		<li class="box">
			<ul>
				<li class="sbtextbg2"><img src="img/bullet_list.gif" align="center"> <b class="txblue"><%=certUserNm%>(<%=m_ID%>)</b>���� �������� ���������� ��Ⱑ �Ǿ����ϴ�.</li>
				<li class="sbtextbg2"><img src="img/bullet_list.gif" align="center"> �������� ��ȿ�Ⱓ�� 
					<%
					if ("69".equals(m_POLICY)) {
						out.print("1����");
					} else if ("70".equals(m_POLICY)) {
						out.print("2����");
					} else if ("71".equals(m_POLICY)) {
						out.print("3����");
					} else if ("72".equals(m_POLICY)) {
						out.print("4����");
					} else if ("73".equals(m_POLICY)) {
						out.print("5����");
					} else if ("74".equals(m_POLICY)) {
						out.print("6����");
					} else if ("75".equals(m_POLICY)) {
						out.print("7����");
					} else if ("76".equals(m_POLICY)) {
						out.print("8����");
					} else if ("77".equals(m_POLICY)) {
						out.print("9����");
					} else if ("78".equals(m_POLICY)) {
						out.print("10����");
					} else if ("79".equals(m_POLICY)) {
						out.print("11����");
					} else if ("80".equals(m_POLICY)) {
						out.print("12����");
					}
					%>				
				�����̸�, ��ȿ�Ⱓ�� ���� �������� ����Ͻ� �� �����ϴ�.</li>
				<li class="sbtextbg2"><img src="img/bullet_list.gif" align="center"> PowerNet �α����� ���ؼ� PowerNet ToolBand�� ���������� Ŭ���Ͻʽÿ�. �̿����ּż� �����մϴ�</li>
				<li class="dotted1"></li>
				<li class="sbtextbg2" style="padding:15px; 0 15px 0 ">&nbsp;</li>

				<li class="sbtextbg"> - ������ �н�(������ ��й�ȣ�� �ؾ���� ���, �̿��ϴ� ��ǻ�Ͱ� ���� �� ���, �������� ������ 
... ���)�� �������� ����� ��, �߱޹����ø� ��� �����մϴ�. </li>
				
				<li style="text-align:center;"><a href="index.jsp"><img src="img/btn_cen_fir.gif" alt="�������� �ʱ�ȭ��"></a></li>
				
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

