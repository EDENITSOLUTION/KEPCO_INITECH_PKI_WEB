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
	
		CheckPlugin();
	// ���̳� ������Ʈ ����

	//document.writeln('<span id="secure" style="display:block;">');
	//document.writeln('noframe.js start');
	//alert(InstallModuleURL);
	InstallModule(InstallModuleURL);
	//LoadCACert(CACert);

	SetProperty("certmanui_GPKI", "all");	//GPKI ������ ��δ� ����
	//SetProperty("certmanui_GPKI", "only");
	DisableInvalidCert(false);			//�α���â���� ���/����������� ǥ�ÿ��� default (false)

/*
	SetProperty("certmanui_phone", "SHINHAN|http://test.ubikey.co.kr/infovine/1023/DownloadList&INITECH|SOFTCAMP");
	SetProperty("certmanui_phoneURL", "http://test.ubikey.co.kr/infovine/1023/download.html");
	SetProperty("certmanui_phoneVer", "1,0,2,3");
*/
	SetProperty("certmanui_SendCertOnlyImgVerify","no");
//	SetProperty("SetBitPKCS10CertRequest","2048");

	
//	SetProperty("certmanui_phoneIssue", "4");


 					SetProperty("certmanui_phone", "KDB|https://banking.kdb.co.kr/pb/infovine/virtkey.html|1|html|615|305|22|&INITECH|AHNLAB25AOS");
 					SetProperty("certmanui_phoneURL", "https://banking.kdb.co.kr/pb/infovine/download.html");
 					SetProperty("certmanui_phoneVer", "1,2,3,7" );
// 					SetProperty("certmanui_phoneIssue", "4"); 					
 					
// 					SetProperty("certmanui_securekey", "ahnlab25_aos");
 					
 					 

	SetProperty("certmanui_phoneServiceList", "mobisign|infovine");
	SetProperty("certmanui_mobiVer", "5.0.2.14");
	SetProperty("certmanui_mobiURL", "http://www.mobisign.kr/mobisigndll.htm");
	SetProperty("certmanui_mobiClientCode", "0100001");
	SetProperty("certmanui_mobiOIDFilter", "2;yessignCA;1.2.410.200005.1.1.4;yessignCA;1.2.410.200005.1.1.2;");

	SetProperty("certmanui_hsm","yes");
//	SetProperty("GetDevSNInfo", "true");
//	SetProperty("GetCertRequestStoreInfo", "true");


	SetProperty("OldCertNotSafeMsg", "1");
	
	//SetProperty("certmanui_screenkeyboardprovider","initech");
	SetProperty("certmanui_screenkeyboardcheckmode","1");
//	SetProperty("certmanui_oid", "d1");

	//��ȭ ���� �����ϵ��� �߰�
	SetProperty("UseCertMode","1");

	//1024 bit ������ ���Ȱ��â ��¿���
	SetProperty("OldCertNotSafeMsg","1");

	SetProperty("certmanui_PasswordDlgImgDesc","false");

	SetProperty("certmanui_changepassworddlgdescriptionkor", "������ ������ ��ȣ�� �Է��Ͻð� ���ο� ��ȣ�� �Է��Ͻʽÿ�.\n������ ��ȣ�� ������ �ݵ�� �����Ͽ� 8�ڸ� �̻� �Է��ϼž�\n�մϴ�.\n������ ��ȣ�� ������ҹ��ڸ� �����մϴ�.");
	SetProperty("certmanui_changepassworddlgdescriptioneng", "Enter existing certificate password and a new password. Certificate password should be at least 8 characters long, including at least one alphabetical character. Certificate password is case sensitive.");
	
//	SetProperty("certmanui_securekey", "softforum");
// 13�� 10�� ��ķ Ű���庸�� ��ȭ
//	SetProperty("certmanui_securekey","softcamp_enc");

//	SetProperty("SignatureAlert","4");
	SetProperty("certmanui_topmost","yes");
//	SetProperty("PopupSaveCertMsgToMovableMedia","yes");

	SetLogoPath();


//	SetProperty("certmanui_nopwdfocus","yes");
//  ������� ��� ����
//	SetProperty("certmanui_setkdbusedproperty", "1");
	
//	SetProperty("updatecertresetpsw", "TRUE");

//	SetProperty("certmanui_SearchStorageFilterOnDevice", "TRUE");

//	SetProperty("certmanui_securekey", "ahnlab25_aos");
//	SetProperty("E2ECrypt", "ahnlab25_aos");

//	SetProperty("certmanui_setkdbusedproperty","1")

//	SetProperty("certmanui_screenkeyboardprovider","lumen");
//	SetProperty("certmanui_screenkeyboardprovideroption","url=http%3a%2f%2fm.touchen.co.kr%3a8080%2fOpenNH%2fTransKey%2fTransKey_crt.jsp");


//	SetProperty("certmanui_screenkeyboardprovider","nshc");
//	SetProperty("certmanui_screenkeyboardprovideroption","url=http%3a%2f%2fnshc.net%3a8080%2fOpenWebNFilter%2fdefault_browser%2fjsp%2fcs_nfilter.jsp");


//	SetProperty("PopupSaveCertMsgToMovableMedia","yes");

	// �ѱ� ö������ �缳������ (13�� 2�� 13��)
//	SetProperty ("PrivateCertInfoSet","Provider=ksign&IssuerO=korail");


//	SetProperty("certmanui_screenkeyboardprovider","nshc");
//	SetProperty("certmanui_screenkeyboardprovideroption","url=http%3a%2f%2fnshc.net%3a8080%2fOpenWebNFilter%2fdefault_browser%2fjsp%2fcs_nfilter.jsp");

	// ��ȣ������å (2012.10.16)
//	SetProperty("certmanui_passwordpolicy","Type=2&Private=1&Public=0&InDecreaseCount=3&RepeatCount=3&mustType=Aa%2cN%2cS");

//	SetProperty("certmanui_passworddlgdescriptionkor", "������ ��ȣ�� ���Ӱ� �Է��Ͻø� �������� �߱޹޽��ϴ�. ������ ��ȣ�� ������ ���� ���Ͻ� ������ ������ �ݵ�� �����Ͽ�, 9�ڸ��̻� �Է��ϼž� �մϴ�. ������ ��ȣ�� ���� ��ҹ��ڸ� �����մϴ�.");
//	SetProperty("certmanui_passworddlgdescriptioneng", "Entering new password leads Certificate issuance. Certificate password must include English character and be 9 digits or longer. The password is case sensitive.");
//	SetProperty("certmanui_passworddlgdescriptionkor", "9�ڸ�.");
//	SetProperty("certmanui_passworddlgdescriptioneng", "word.");
	
	

//	SetProperty("certmanui_changepassworddlgdescriptionkor", "�Ϸ��Ϸ� ��ȣ�� �Է��Ͻð� ���ο� ��ȣ�� �Է��Ͻʽÿ�.\n������ ��ȣ�� ������ �ݵ�� �����Ͽ� 8�ڸ� �̻� �Է��ϼž�\n�մϴ�.\n������ ��ȣ�� ������ҹ��ڸ� �����մϴ�.");
//	SetProperty("certmanui_changepassworddlgdescriptioneng", "Korea certificate password and a new password. Certificate password should be at least 8 characters long, including at least one alphabetical character. Certificate password is case sensitive.");

//	SetProperty("certmanui_changepassworddlgdescriptionchn", "������ ��ȣ�� ���Ӱ� �Է��Ͻø� �������� �߱޹޽��ϴ�. ������ ��ȣ�� ������ ���� ���Ͻ� ������ ������ �ݵ�� �����Ͽ�, 9�ڸ��̻� �Է��ϼž� �մϴ�. ������ ��ȣ�� ���� ��ҹ��ڸ� �����մϴ�.");

	// �ȷ� AOS Ű���� ���� ����
//	SetProperty("certmanui_securekey", "inca");

//  2012.04.30 (����Ű����)
//	SetProperty("certmanui_screenkeyboardprovider","besoft");
//	SetProperty("certmanui_screenkeyboardprovideroption","libfile=LotteCap_LaunchSafeOn.dll&ipwidth=450&ipheight=400&ipurl=http%3a%2f%2fsafeon.besoft.co.kr%2fbesoft%2fsafeon%2flottecap_real%2fdownload.html&ipmsg=UsafeOn(%c8%ad%b8%e9+%ba%b8%be%c8+%b0%a1%bb%f3%c5%b0%ba%b8%b5%e5)%b8%a6+%b8%d5%c0%fa+%bc%b3%c4%a1%c7%cf%bc%c5%be%df+%c7%d5%b4%cf%b4%d9.%5cn%5cnUsafeOn+%bc%b3%c4%a1+%c6%e4%c0%cc%c1%f6%b7%ce+%c0%cc%b5%bf%c7%cf%bd%c3%b0%da%bd%c0%b4%cf%b1%ee%3f");


	//SetProperty("FilterStore", "HDD|FDD|USB|SCARD");
	
//	SetProperty("SignatureAlert","4");

	
	//SetProperty("certmanui_screenkeyboardprovider","nshc");
	//SetProperty("certmanui_screenkeyboardprovideroption","url=http%3a%2f%2fnshc.net%3a8080%2fOpenWebNFilter%2fcs_nfilter.jsp");
	//SetProperty("certmanui_screenkeyboardprovideroption","url=http%3a%2f%2fnshc.net%3a8080%2fOpenWebNFilter%2fdefault_browser%2fjsp%2fcs_nfilter.jsp");
	
	//SetProperty("certmanui_screenkeyboardprovider","besoft");
	//SetProperty("certmanui_screenkeyboardprovideroption", "libfile=LotteCap_LaunchSafeOn.dll&ipwidth=450&ipheight=400&ipurl=http%3a%2f%2fsafeon.besoft.co.kr%2fbesoft%2fsafeon%2flottecap_real%2fdownload.html&ipmsg=Test Msg");

	SetProperty("certmanui_screenkeyboardprovider","inca");
	SetProperty("certmanui_screenkeyboardprovideroption","url=http%3a%2f%2f172.20.25.20%3a8080%2finca%2fkeypad%2fkpdencoder.jsp");
	
		
//	SetProperty("certmanui_language","eng");
	
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

