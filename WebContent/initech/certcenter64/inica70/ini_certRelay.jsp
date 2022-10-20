<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.String.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%!
public String getDateTime() {
	Locale locale = java.util.Locale.KOREA;
	SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale);
	String convertedTime = sdfr.format(new Date());
	return convertedTime;

}
%>
<%
String timeId = getDateTime() ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=11"/>
<title>������ �����ϱ�</title>
<link rel="stylesheet" type="text/css" href="css/import.css" />
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" type="text/css" href="css/pcToMobile.css" />

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.flexslider-min.js"></script>
<script type="text/javascript" src="js/jquery.als-1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>

<script type="text/javascript" src="/initech/plugin/INIplugin.js"></script>
<script type="text/javascript" src="/initech/plugin/cert.js"></script>
<script type="text/javascript" src="/initech/plugin/install.js"></script>
<script type="text/javascript" src="/initech/plugin/INIutil.js"></script>
<script type="text/javascript" src="/initech/plugin/noframe.js"></script>
<script language="javascript">
    //�����ӿ��� ��ũ��Ʈ ������ �߰��۾�-20210209
   var INIplugin = window.parent.frames["secureframe"].INIplugin;
	//var ClientVersion = "6,4,0,42";
	function CertMgmt_CertRoamingPrc()
	{
		// ������ ������ Ŭ���̾�Ʈ ActiveX��ġ ���� Ȯ�� 
		/*if (typeof(CertClient) == "undefined") {
			alert("������ ������ Ŭ���̾�Ʈ�� ��ġ �Ͻʽÿ�.");
			return;
		}*/
		
		/**
		 * ������ ����â ����� ��� �̹���
		 * ���⿡ ���� �̹����� ���� �̴��� INISAFE Web ��ǰ�� ����ϴ� ���̶��,
		 * �̹� ����ϰ� �ִ� �̹��� URL�� �־��ָ� �ǳ�,
		 * �ƴ϶�� �ش� �̹����� �ۼ� ��, �̴��ؿ� �����ؼ� ���ڼ����� �޾Ƽ� ����ؾ� �Ѵ�.
		 * �̴��ؿ��� ���ڼ��� ���� �̹����� �ƴϸ� ��ܿ� �̹����� �������� �ʴ´�.
		 */
		
		/**
		 * ������ �̵� �������� ���� ����
		 */
		INIplugin.SetProperty("UseCertMode","1");				
		INIplugin.LoadCert(SCert);			
		//������ ���� ���� ����
		INIplugin.ICCSetOption("SetProtocolVersion","1.2");  	
		//������ȣȭ ����
//		INIplugin.ICCSetOption("MakePluginData","TRUE");
		INIplugin.ICCSetOption("MakePluginData","FALSE");
		INIplugin.ICCSetOption("TimeURL", TimeURL);
		//������ ����â �̹��� ���(������ �������� ��)
		INIplugin.ICCSetOption("SetLogoPath", LogoURL);

		/**
		 * ������ȣ �ڸ� �Է¼�. ����Ʈ������ ������ �ڸ����� ��ġ�Ͽ��� �Ѵ�.
		 */
		INIplugin.ICCSetOption("SetAuthenticationNumber","8");
		

		/**
		 * �ֹε�Ϲ�ȣ �Է��� ����Ұ������� ����. (�⺻��:"TRUE")
		 * ("FALSE"�� �����ϰ� �Ǹ� ������ �������� 1.1 �������� �����Ѵ�.)
		 */
		INIplugin.ICCSetOption("SetUseIdentify","FALSE");

		/**
		 * ���������� �������� ��й�ȣ�� �缳���Ұ������� ����.(�⺻��:"TRUE")
		 * (�� ����Ʈ���� ����� ������ ��ȣ����)
		 * "FALSE"�� �����ϸ� �缳������ �ʰ� �ٷ� ���۵Ǹ� �������� ���� ��
		 * ����ڿ��� �缳�� ���θ� �˸���.
		 */
		INIplugin.ICCSetOption("SetUseCertPwd","FALSE");

		/**
		 * GPKI ������ ��� ����
		 */
		INIplugin.ICCSetOption("Setproperty","certmanui_gpki&all");

		/**
		 * ������ �������� ó�� ����
		 */
		INIplugin.ICCSendCert( GetExportURL() );

	}

	function GetExportURL() 
	{
		var currURL = location.href;
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificateWeb6_v12.jsp";
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificate_v12.jsp";
		var exportURL = "http://"+ window.location.host +"/initech/certcenter64/inica70/CertRelay/GetCertificate_v12.jsp";
		//alert("[" + exportURL + "]");
		return exportURL;
	}

	function GetImportURL() 
	{
		var currURL = location.href;
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificateWeb6_v12.jsp";
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificate_v12.jsp";
		var exportURL = "/initech/certcenter64/inica70/CertRelay/GetCertificate_v12.jsp";
		
		return exportURL;
	}

	function CertMgmt_ImportCert() 
	{
		// ������ ������ Ŭ���̾�Ʈ ActiveX��ġ ���� Ȯ�� 
		/*if (typeof(CertClient) == "undefined") {
			alert("������ ������ Ŭ���̾�Ʈ�� ��ġ �Ͻʽÿ�.");
			return;
		}*/
		
		/**
		 * ������ ����â ����� ��� �̹���
		 * ���⿡ ���� �̹����� ���� �̴��� INISAFE Web ��ǰ�� ����ϴ� ���̶��,
		 * �̹� ����ϰ� �ִ� �̹��� URL�� �־��ָ� �ǳ�,
		 * �ƴ϶�� �ش� �̹����� �ۼ� ��, �̴��ؿ� �����ؼ� ���ڼ����� �޾Ƽ� ����ؾ� �Ѵ�.
		 * �̴��ؿ��� ���ڼ��� ���� �̹����� �ƴϸ� ��ܿ� �̹����� �������� �ʴ´�.
		 */
	
		INIplugin.SetProperty("UseCertMode","1");				
		INIplugin.LoadCert(SCert);		

//		INIplugin.ICCSetOption("MakePluginData","TRUE");
		INIplugin.ICCSetOption("MakePluginData","FALSE");
		INIplugin.ICCSetOption("TimeURL", TimeURL);
		INIplugin.ICCSetOption("SetLogoPath", LogoURL);
		/**
		 * ������ �̵� �������� ���� ����
		 */
		INIplugin.ICCSetOption("SetProtocolVersion", "1.2");

		/**
		 * ������ȣ �ڸ� �Է¼�. ����Ʈ������ ������ �ڸ����� ��ġ�Ͽ��� �Ѵ�.
		 */
		INIplugin.ICCSetOption("SetAuthenticationNumber","8");

		/**
		 * �ֹε�Ϲ�ȣ �Է��� ����Ұ������� ����. (�⺻��:"TRUE")
		 * ("FALSE"�� �����ϰ� �Ǹ� ������ �������� 1.1 �������� �����Ѵ�.)
		 */
		INIplugin.ICCSetOption("SetUseIdentify","FALSE");

		/**
		 * ���������� �������� ��й�ȣ�� �缳���Ұ������� ����.(�⺻��:"TRUE")
		 * (�� ����Ʈ���� ����� ������ ��ȣ����)
		 * "FALSE"�� �����ϸ� �缳������ �ʰ� �ٷ� ���۵Ǹ� �������� ���� ��
		 * ����ڿ��� �缳�� ���θ� �˸���.
		 */
		INIplugin.ICCSetOption("SetUseCertPwd","FALSE");
		/**
		 * ������ �������� ó�� ����
		 */
		INIplugin.ICCRecvCert( GetImportURL() );

	}
</script>
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
		<li class="toptxtcon">������ �����ϱ�</li>
	</ul>
</div>

<div id="subissue">
	<ul>
		<li><img src="img/copy_title.gif" alt="PC �� ����Ʈ��� ������ ����" /></li>
		<li class="stitle">&nbsp;</li>
		
		<li class="box" style="overflow:hidden; border:0;">

			<img src="img/copy_step.jpg" alt="PC �� ����Ʈ��� ������ ���� ����" />

			
		</li>
	</ul>
	<div class="copyWrap">
		<span class="copyBtn"><a href="javascript:;"  onclick="CertMgmt_CertRoamingPrc()">������ ���� (PC�潺��Ʈ���)</a></span>
	</div>
</div>



<div style="height:20px;"></div>
<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

</body>
</html>