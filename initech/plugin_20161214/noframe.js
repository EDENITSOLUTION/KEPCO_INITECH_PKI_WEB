/* INISAFE Web V6 - noframe.js */

/********************************************************************
1. ���� �ݵ�� <body></body> ���̿� ������ ���� ����ؾ���
  <script language="javascript" src="/initech/plugin/noframe.js"></script>
********************************************************************/

var checkFrame = false;
function StartIniPlugin()
{
	// INIplugin.js, install.js, cert.js �ε����� Ȯ��
	if ( (typeof(LoadPlugin) == 'undefined') || (typeof(SCert) == 'undefined') || (typeof(LoadCert) == 'undefined'))
	{
		if (checkFrame == false)
		{
			checkFrame = true;
			alert("reCheck");
			setTimeout("StartIniPlugin()", 2000);
			return;
		} else 
			alert("install.js/cert.js/INIplugin.js ������ include���� �ʾҽ��ϴ�.")
			return;
	}

	//���߷ε� ���� (Ư���� ��� ��� �ν��� üũ���� object ���� ���� �߻��� ������ ���� ���� �̶��� ���Ÿ� �ϵ��� ��)
	if (typeof (ModuleInstallCheck) == "function") {
 		if (ModuleInstallCheck() != null) {
		//	alert("find secureframe skip noframe...");
			return;
		}
	}

	//document.writeln('<span id="secure" style="display:block;">');
	//document.writeln('noframe.js start');
	CheckPlugin();
	// ���̳� ������Ʈ ����
	InstallModule(InstallModuleURL);
	//LoadCACert(CACert);
	SetProperty("certmanui_GPKI", "all");	//GPKI ������ ��δ� ����
	SetProperty("URLCheckForGetServerTime","yes");
	//SetProperty("certmanui_GPKI", "only");
	//DisableInvalidCert(true);			//�α���â���� ���/����������� ǥ�ÿ��� default (false)

	SetProperty("certmanui_phone", "SHINHAN|http://test.ubikey.co.kr/infovine/1023/DownloadList&INITECH|SOFTCAMP");
	SetProperty("certmanui_phoneURL", "http://test.ubikey.co.kr/infovine/1023/download.html");


	SetProperty("certmanui_phoneVer", "1,0,2,3");

	SetProperty("certmanui_hsm","yes");

	//��ȭ ���� �����ϵ��� �߰�
  //SetProperty("UseCertMode","1");

  //1024 bit ������ ���Ȱ��â ��¿���
  SetProperty("OldCertNotSafeMsg","1");

	if (!LoadCert(SCert)) {
		//alert("���� �缳�����Դϴ�.");
		//location.reload();
		setTimeout("StartIniPlugin()", 1000);
	}

}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
if (typeof(StartIniPlugin) != 'undefined')
	StartIniPlugin();
else
	setTimeout("StartIniPlugin()", 1000);
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

