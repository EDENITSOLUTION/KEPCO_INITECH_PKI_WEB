<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if(request.getProtocol().equals("HTTP/1.1")) {
	   response.setHeader("Cache-Control", "no-cache");
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>������ ��������</TITLE>
<h1>������ �̵� v1.2 WEB6</h1>

<script language="javascript" src="/initech/plugin64/INIplugin.js"></script>
<script src="/initech/plugin64/cert.js"></script>
<script src="/initech/plugin64/install.js"></script>
<script src="/initech/plugin/noframe.js"></script>

<script language="javascript">
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
		//������ ����â �̹��� ���(����� �������� ��)
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
		var exportURL = "/initech/certcenter64/inica70/CertRelay/GetCertificate_v12.jsp";
		//alert("exportURL [" + exportURL + "]");
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
</HEAD>

<BODY>
<!-- script language="javascript">
	CertMgmt_ClientInstall();
</script -->

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<input type=button value="������ ��������" onClick="CertMgmt_CertRoamingPrc()">
<input type=button value="������ ��������" onClick="CertMgmt_ImportCert()">
<br>
<br>
<br>
<!--a href="INISAFECertClientv1.exe">�������� ���α׷� ���� �ٿ�ε�</a -->
</BODY>
</HTML>