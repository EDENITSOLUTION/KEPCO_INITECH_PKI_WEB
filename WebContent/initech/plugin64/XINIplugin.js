//document.write('<OBJECT ID="INIplugin6" CLASSID="CLSID:286A75C3-11FB-4FB4-AC4A-4DD1B0750050" width=100 height=100 CodeBase=http://dn.initech.com/web/plugin/60/tst/down/INIS60.cab></OBJECT>');

///////////////////////////////////////////////////////////////////////////////////
// XInternet 
///////////////////////////////////////////////////////////////////////////////////

// XInternet Function Start
///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : XInternetMakeINIpluginData
//  �Ķ��Ÿ : vf - ��ȣȭ, ���� ������ ���̴�. 0�ΰ��� ��ȣȭ, 1�ΰ��� �����̴�.
//             data - ��ȣȭ �� �������̴�. 
//  �� �� �� : ��ȣȭ�� �����͸� �����Ͽ��� �����Ѵ�. 
//             ���࿡ �Էµ� ���� �߸��� ����� �� ��Ʈ���� �����ϰ�, 
//             �������� ����� ��ȣȭ�� iniplugin ������ ��Ʈ���� �����Ѵ�. 
//  ��    �� : ��ȣȭ�� �����͸� �����Ѵ�.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetMakeINIpluginData(vf, data)
{

	var INIdata = "";
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	//Get Server Time  -- 20080422 modified blackhole 
	var ver="4,2,0,0";
	if(AddServerTime && EnableFunction(ver)) {
		if(data!=""){
				data = "__INIts__=" + obj.GetServerTime(TimeURL) + "&" + data;
		}
		else{
				data = "__INIts__=" + obj.GetServerTime(TimeURL);
		}
	}

	if ((INIdata = obj.MakeINIpluginData(vf, cipher, data, TimeURL))=="")
	{
		return false;
	}	  
  	return INIdata;
}

///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : XInternetDecrypt
//  �Ķ��Ÿ : encData - �������� ���� ��ȣȭ �Ǿ��ִ� �������̴�. ��ȣȭ �ؾ� �� �����̴�.
//  �� �� �� : �������� ���� ��ȣȭ�� �����͸� ��ȣȭ �ϴµ� ����Ѵ�. 
//             ����Ű�� ���������� MakeINIpluginData �Լ��� ����Ͽ� ������ ����Ű�� ����Ѵ�. 
//             �����ô� ��ȣȭ�� ������, ���нÿ��� �� ��Ʈ���� �����Ѵ�.
//  ��    �� : �Էµ� ��ȣȭ�� �����͸� ��ȣȭ �Ѵ�.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetDecrypt(encData) 
{
	var data = "";
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	
	if ((data = obj.Decrypt(cipher, encData))=="")
	{
		return false;
	}	 

  	return data;
}


////////////////////////////////////////////////////////////////////////////////////
// BLUETHOTH 
////////////////////////////////////////////////////////////////////////////////////

// Bluethoth Function Start
///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : XInternetEncryptRemote
//  �Ķ��Ÿ : source - JSON���� ��Ʈ��ȭ �ǰ� ��ȣȭ �� ��ü
//  �� �� �� : ��ȣȭ�� �����͸� �����Ͽ��� �����Ѵ�. 
//             ���������� XInternetMakeINIpluginData�� ����Ѵ�. [��ȣȭ�� ���]
//             ���࿡ �Էµ� ���� �߸��� ����� �� ��Ʈ���� �����ϰ�, 
//             �������� ����� ��ȣȭ�� iniplugin ������ ��Ʈ���� �����Ѵ�. 
//  ��    �� : ��ȣȭ�� �����͸� �����Ѵ�.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetEncryptRemote(source){
	//return XInternetMakeINIpluginData(0, "xbank="+JSON.stringify(source));
	return XInternetMakeINIpluginData(10, source);
}

///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : XInternetSignRemote
//  �Ķ��Ÿ : source - JSON���� ��Ʈ��ȭ �ǰ� ���� �� ��ü
//  �� �� �� : ����� �����͸� �����Ͽ��� �����Ѵ�. 
//             ���������� XInternetMakeINIpluginData�� ����Ѵ�. [���� ���]
//             ���࿡ �Էµ� ���� �߸��� ����� �� ��Ʈ���� �����ϰ�, 
//             �������� ����� ����� iniplugin ������ ��Ʈ���� �����Ѵ�. 
//  ��    �� : ����� �����͸� �����Ѵ�.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetSignRemote(source){
	//return XInternetMakeINIpluginData(1, "xbank="+JSON.stringify(source));
	return XInternetMakeINIpluginData(11, source);
	//return XInternetMakeINIpluginData(1, "xbank=");
}

///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : XInternetDecryptRemote
//  �Ķ��Ÿ : source - �������� ���� ��ȣȭ �Ǿ��ִ� �������̴�. ��ȣȭ �ؾ� �� �����̴�.
//  �� �� �� : �������� ���� ��ȣȭ�� �����͸� ��ȣȭ �ϴµ� ����Ѵ�. 
//             ���������� XInternetDecrypt�� ����Ѵ�.
//             �����ô� ��ȣȭ�� ������, ���нÿ��� �� ��Ʈ���� �����Ѵ�.
//  ��    �� : �Էµ� ��ȣȭ�� �����͸� ��ȣȭ �Ѵ�.
//
///////////////////////////////////////////////////////////////////////////////////

function XInternetDecryptRemote(source){
	//return JSON.parse(XInternetDecrypt(unescape(source)));
	return XInternetDecrypt(unescape(source));
}

// XInternet Function End


////////////////////////////////////////////////////////////////////////////////////
// XSAFE 
////////////////////////////////////////////////////////////////////////////////////

// XSAFE Function Start
////////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashGetDeviceList
//  �Ķ���� : ���� 
//  �� �� �� : ���� ����̺� ����Ʈ ��Ʈ�� ����(ex, "CD-ROM(D:)&���õ�ũ(E:)")
//             ���� ���̰� 0�� ��Ʈ�� ����
//  ��    �� : ����̺� ����Ʈ�� ���´� 
//
////////////////////////////////////////////////////////////////////////////////////
//function GetFDDList()
function xFlashGetDeviceList()
{
    obj = ModuleInstallCheck();
    if (obj == null) {
            alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
            return false;
    }

    strFDDList = obj.xFlashGetDeviceList();
    // ���� Ȯ�� �ʿ�!!
    //certificate.setVariable("strFDDList", strFDDList);
    return strFDDList;
}

function xFlashGetExternDeviceList()
{
    obj = ModuleInstallCheck();
    if (obj == null) {
            alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
            return false;
    }

	obj.SetProperty("certmanui_verifyhsmdriverurl", "http://www.rootca.or.kr/certs/hsm.der");

	var ret = obj.ExtendMethod("xFlashGetExternDeviceList", "HSM");
	return ret;
}

////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashGetCertListCount
//  �Ķ���� : store - ���� ��ü ���� (HDD: 0, FDD: 1, SCARD: 2, USB: 3)
//             pin - �ɹ�ȣ 
//             drive - ����̸� ("A") 
//  �� �� �� : �������� ���� ����, �ش� ��ü�� �������� ���� ���� ������ 0 ���� 
//  ��    �� : �ش� ��ü�� �����ϴ� �������� ������ �����ϸ�,INIplugin ���� ������
//             ����Ʈ�� �޸𸮿� �ö���� �ȴ� 
// 
////////////////////////////////////////////////////////////////////////////////
//function GetCertListCount(store, pin, drive)
function xFlashGetCertListCount(store, pin, drive)
{
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	i = obj.xFlashGetCertListCount(store, pin, drive);

	return i;
}

////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashGetAllCertHeader
//  �Ķ���� : store - ���� ��ü ���� (HDD: 0, FDD: 1, SCARD: 2, USB: 3)
//             pin - �ɹ�ȣ 
//             drive - ����̸� ("A") 
//  �� �� �� : �����ϸ� ��� ������ ��� ��Ʈ�� ����,
//             1) �� �ʵ� delimiter '&' ���, �� ��� row delimiter '|' ���
//             2) expired : 0(�Ⱓ ��ȿ��), 1(�Ⱓ �����)
//            ex)"index=0&expired=0&user=ȫ�浿&issuer=INITECH&type=�缳&expire=2006-04-12|��|index=n&user=ȫ�浿n&issuer=INITECH&type=�缳&expire=2006-05-12"
//               ���� ���̰� 0�� ��Ʈ�� ����
//  ��    �� : ���õ� ��ü�� �ִ� ��� �������� ��� ��Ʈ���� ���´�
// 
////////////////////////////////////////////////////////////////////////////////
//newAdd
function xFlashGetAllCertHeader(store, pin, drive)
{
    //alert("1.xFlashGetAllCertHeader:" + store + "/" + pin + "/" + drive);
	obj = ModuleInstallCheck();
	//alert("2.moduleInstallCheck():" + obj);
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	strAllCertHeader = obj.xFlashGetAllCertHeader(store, pin, drive);
	return strAllCertHeader;
}

////////////////////////////////////////////////////////////////////////////////
// 
//  �� �� �� : xFlashGetCertHeader
//  �Ķ���� : idx - INIplugin ���� ������ ����Ʈ�� �Ҿ�� ������ index
//  �� �� �� : ���� ������ ������ ��� ��Ʈ�� ����
//             expired : 0(�Ⱓ ��ȿ��), 1(�Ⱓ �����)
//             ex) "index=0&expired=0&user=ȫ�浿&issuer=INITECH&type=�缳&expire=2006-04-12"
//             ���� ���̰� 0�� ��Ʈ�� ���� 
//  ��    �� : I������ �������� header ��Ʈ���� ���´�
//
////////////////////////////////////////////////////////////////////////////////
//function GetCertInfoStr(idx)
function xFlashGetCertHeader(idx)
{
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	strCertInfo = obj.xFlashGetCertHeader(idx);
	return strCertInfo;		
}

////////////////////////////////////////////////////////////////////////////////
// 
//  �� �� �� : xFlashGetCertDetail
//  �Ķ���� : idx - INIplugin ���� ������ ����Ʈ�� �Ҿ�� ������ index
//  �� �� �� : ���� ������ �������� �ڼ��� ���� ��Ʈ�� ����, 
//             ex) "name=value&name=value&��&name=value&name=value"
//            ���� FALSE
//  ��    �� : ������ �������� �ڼ��� ���� ��Ʈ���� ���´�
//
////////////////////////////////////////////////////////////////////////////////
//newAdd
function xFlashGetCertDetail(idx)
{
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	strCertInfo = obj.xFlashGetCertDetail(idx);

	return strCertInfo;	
		
}

////////////////////////////////////////////////////////////////////////////////
// 
//  �� �� �� : xFlashRemoveDeviceCert
//  �Ķ���� : idx - INIplugin ���� ������ ����Ʈ�� ������ ������ index
//  �� �� �� : ���� TRUE, ���� FALSE
//  ��    �� : ������ �������� �����Ѵ�
//
////////////////////////////////////////////////////////////////////////////////
//newAdd
function xFlashRemoveDeviceCert(idx)
{
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	i = obj.xFlashRemoveDeviceCert(idx);

	return i ;	
		
}

/////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashSetCertKeys
//  �Ķ���� : idx - INIplugin�� ������ �������� index
//             pass - ������ �������� �����Ǵ� ����Ű �н����� 
//  �� �� �� : �н����尡 ��ġ�ϰ� INIplugin�� ������ ������ �����ϸ� true
//	       �н����尡 ��ġ���� �ʰų� ������ ������ �����ϸ� false
//  ��    �� : INIplugin���� ����� �������� ���� �Ѵ�
//
/////////////////////////////////////////////////////////////////////////////////
//function SetCertificate(idx, pass, form)
function xFlashSetCertKeys(idx, pass, form)
{
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	nRet = obj.xFlashSetCertKeys(idx, pass);

	if(nRet == 1) {
	    return true;
    //alert("������ �����߽��ϴ�");
	//	if (xFlashEncFormVerify(form))
	//			document.readForm.submit();
	//	else 
	//			alert('��ȣȭ�� ���� �߻�');
	}
	else
	    return false;
	    //alert("������ �����߽��ϴ�");
}

///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashEncFormVerify
//  �Ķ��Ÿ : form
//  �� �� �� : �����ϸ� INIplugin data ����, �����ϸ� ���̰� 0�� ��Ʈ�� ���� 
//  ��    �� : INIplugin�� ������ ������ ���������� �̷������ �� �������� ���� INIplugin data�� 
//	       ���� 
//
///////////////////////////////////////////////////////////////////////////////////
//function xEncFormVerify(form) 
function xFlashEncFormVerify(form) 
{
	var INIdata = "";
	var eletemp = "";
	var filetemp = "";
	var Random = TimeURL; 
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	
	filetemp = GatherFileValue(form, 0, true);
	if (filetemp !=  "") 
	{
		if ((form.filedata.value = obj.MakeFileData(11, cipher, filetemp)) == "") return false; 
	}
	
	eletemp = GatherValue(form, 0, true);
	if ((INIdata = obj.xFlashMakeINIpluginData(11, cipher, eletemp, Random))=="")
	{
		return false;
	}	 

	//add bye wakano 2001/01/29
	if (typeof form.INIpluginData == "undefined") 
	{
		alert("form.INIpluginData undefined" ) ; 
		if (ShinHan_plugin) // with for Shinhan Bank 
		{
			form.input.value = INIdata;
			form.input.name = "INIpluginData"; // for Shinhan Bank
		} else {
			alert("INIpluginData(form.name)�� �ʿ��մϴ�.");
			return false;
		}
	} else {
		form.INIpluginData.value = INIdata;
		//alert("form.INIpluginData.value " + form.INIpluginData.value) ; 
	}

  	return true;
}

///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : MakeINIpluginData
//  �Ķ��Ÿ : 
//  �� �� �� :  
//  ��    �� :  
//
///////////////////////////////////////////////////////////////////////////////////
function MakeINIpluginData(vf, data) 
{
	var INIdata = "";
	var Random = TimeURL; 

alert("vf == "+vf);
alert("data == "+data);

	obj = ModuleInstallCheck();

	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	
	if ((INIdata = obj.MakeINIpluginData(vf, cipher, data, Random))=="")
	{
		return false;
	}	 

  	return INIdata;
}


///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashCertRequest
//  �Ķ��Ÿ : 
//  �� �� �� :  
//  ��    �� :  
//
///////////////////////////////////////////////////////////////////////////////////
function xFlashCertRequest()
{
	obj = ModuleInstallCheck();
	if (obj == null) 
		alert("obj load fail");
	else
	{
		var Arg = "";
//������ȣ�� �ΰ��ڵ�� ���� �־�� ��.
		Arg += "REF=";
		Arg += obj.URLEncode("1");	//������ȣ
		Arg += "&CODE=";
		Arg += obj.URLEncode("2");	//�ΰ��ڵ�
		Arg += "&CAIP=";
		Arg += obj.URLEncode("203.233.91.234");
		Arg += "&CAPORT=";
		Arg += obj.URLEncode("4512");

		obj.SetProperty("IssueSkipUI", "yes");

		obj.ExtendMethod("SetPin", "99999999");
		obj.ExtendMethod("SetDrive", "D:");	//FDD �϶� ����ϴ°�

		ret = obj.CertRequest("YESSIGN", "HDD", Arg, "qqqqqqqq");
		//ù��° ���ڴ� ������������ ��� ����, �ι���� HDD, FDD, USB, SCARD �� ����
		alert(ret);
		//ret �� true �� ���� save_fail �̸� ���� ����
		//������ �ٸ� ���̸� �߱ް��������� ���� ���� �ڵ�� "����,�����޽���" �������� ����
	}
}


///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashCertUpdate
//  �Ķ��Ÿ : 
//  �� �� �� :  
//  ��    �� : 
//
///////////////////////////////////////////////////////////////////////////////////
function xFlashCertUpdate()
{
	obj = ModuleInstallCheck();
	if (obj == null) 
		alert("obj load fail");
	else
	{
		var Arg = "";
		Arg += "&CAIP=";
		Arg += obj.URLEncode("203.233.91.234");
		Arg += "&CAPORT=";
		Arg += obj.URLEncode("4512");

		obj.SetProperty("IssueSkipUI", "yes");

		obj.ExtendMethod("SetPin", "99999999");	//����Ʈī�峪 USB��ū�� ���
		obj.ExtendMethod("SetDrive", "D:");	//FDD �϶� ����ϴ°�

		ret = obj.CertUpdate("YESSIGN", "HDD", Arg);
		//ù��° ���ڴ� ������������ ��� ����, �ι���� HDD, FDD, USB, SCARD �� ����
		alert(ret);
		//ret �� true �� ���� save_fail �̸� ���� ����
		//������ �ٸ� ���̸� �߱ް��������� ���� ���� �ڵ�� "����,�����޽���" �������� ����
	}
}

///////////////////////////////////////////////////////////////////////////////////
//
//  �� �� �� : xFlashUrlEncode
//  �Ķ��Ÿ : 
//  �� �� �� :  
//  ��    �� : �Ķ��Ÿ�� ���޹��� ���� UrlEncoding �Ͽ� �����Ѵ�.
//
///////////////////////////////////////////////////////////////////////////////////
function xFlashUrlEncode(value) 
{ 
		obj = ModuleInstallCheck(); 
		if (obj == null)  
			alert("obj load fail"); 
		else 
		{ 
			var strResult = obj.URLEncode(value); 

			return strResult; 
		} 
} 

// XSAFE Function End
