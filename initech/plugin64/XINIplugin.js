//document.write('<OBJECT ID="INIplugin6" CLASSID="CLSID:286A75C3-11FB-4FB4-AC4A-4DD1B0750050" width=100 height=100 CodeBase=http://dn.initech.com/web/plugin/60/tst/down/INIS60.cab></OBJECT>');

///////////////////////////////////////////////////////////////////////////////////
// XInternet 
///////////////////////////////////////////////////////////////////////////////////

// XInternet Function Start
///////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : XInternetMakeINIpluginData
//  파라메타 : vf - 암호화, 서명 여부의 값이다. 0인경우는 암호화, 1인경우는 서명이다.
//             data - 암호화 할 데이터이다. 
//  리 턴 값 : 암호화된 데이터를 생성하여서 리턴한다. 
//             만약에 입력된 값이 잘못된 경우라면 널 스트링을 리턴하고, 
//             정상적인 경우라면 암호화된 iniplugin 형식의 스트링을 리턴한다. 
//  설    명 : 암호화된 데이터를 생성한다.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetMakeINIpluginData(vf, data)
{

	var INIdata = "";
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
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
//  함 수 명 : XInternetDecrypt
//  파라메타 : encData - 서버에서 보낸 암호화 되어있는 데이터이다. 복호화 해야 할 내용이다.
//  리 턴 값 : 서버에서 보낸 암호화된 데이터를 복호화 하는데 사용한다. 
//             세션키는 일차적으로 MakeINIpluginData 함수를 사용하여 공유한 세션키를 사용한다. 
//             성공시는 복호화된 데이터, 실패시에는 널 스트링을 리턴한다.
//  설    명 : 입력된 암호화된 데이터를 복호화 한다.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetDecrypt(encData) 
{
	var data = "";
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
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
//  함 수 명 : XInternetEncryptRemote
//  파라메타 : source - JSON으로 스트링화 되고 암호화 될 객체
//  리 턴 값 : 암호화된 데이터를 생성하여서 리턴한다. 
//             내부적으로 XInternetMakeINIpluginData를 사용한다. [암호화만 사용]
//             만약에 입력된 값이 잘못된 경우라면 널 스트링을 리턴하고, 
//             정상적인 경우라면 암호화된 iniplugin 형식의 스트링을 리턴한다. 
//  설    명 : 암호화된 데이터를 생성한다.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetEncryptRemote(source){
	//return XInternetMakeINIpluginData(0, "xbank="+JSON.stringify(source));
	return XInternetMakeINIpluginData(10, source);
}

///////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : XInternetSignRemote
//  파라메타 : source - JSON으로 스트링화 되고 서명 될 객체
//  리 턴 값 : 서명된 데이터를 생성하여서 리턴한다. 
//             내부적으로 XInternetMakeINIpluginData를 사용한다. [서명만 사용]
//             만약에 입력된 값이 잘못된 경우라면 널 스트링을 리턴하고, 
//             정상적인 경우라면 서명된 iniplugin 형식의 스트링을 리턴한다. 
//  설    명 : 서명된 데이터를 생성한다.
//
///////////////////////////////////////////////////////////////////////////////////
function XInternetSignRemote(source){
	//return XInternetMakeINIpluginData(1, "xbank="+JSON.stringify(source));
	return XInternetMakeINIpluginData(11, source);
	//return XInternetMakeINIpluginData(1, "xbank=");
}

///////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : XInternetDecryptRemote
//  파라메타 : source - 서버에서 보낸 암호화 되어있는 데이터이다. 복호화 해야 할 내용이다.
//  리 턴 값 : 서버에서 보낸 암호화된 데이터를 복호화 하는데 사용한다. 
//             내부적으로 XInternetDecrypt를 사용한다.
//             성공시는 복호화된 데이터, 실패시에는 널 스트링을 리턴한다.
//  설    명 : 입력된 암호화된 데이터를 복호화 한다.
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
//  함 수 명 : xFlashGetDeviceList
//  파라메터 : 없음 
//  리 턴 값 : 성공 드라이브 리스트 스트링 리턴(ex, "CD-ROM(D:)&로컬디스크(E:)")
//             실패 길이가 0인 스트링 리턴
//  설    명 : 드라이브 리스트를 얻어온다 
//
////////////////////////////////////////////////////////////////////////////////////
//function GetFDDList()
function xFlashGetDeviceList()
{
    obj = ModuleInstallCheck();
    if (obj == null) {
            alert("암호화프레임(secureframe)을 찾을수 없습니다.");
            return false;
    }

    strFDDList = obj.xFlashGetDeviceList();
    // 리아 확인 필요!!
    //certificate.setVariable("strFDDList", strFDDList);
    return strFDDList;
}

function xFlashGetExternDeviceList()
{
    obj = ModuleInstallCheck();
    if (obj == null) {
            alert("암호화프레임(secureframe)을 찾을수 없습니다.");
            return false;
    }

	obj.SetProperty("certmanui_verifyhsmdriverurl", "http://www.rootca.or.kr/certs/hsm.der");

	var ret = obj.ExtendMethod("xFlashGetExternDeviceList", "HSM");
	return ret;
}

////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : xFlashGetCertListCount
//  파라메터 : store - 저장 매체 선택 (HDD: 0, FDD: 1, SCARD: 2, USB: 3)
//             pin - 핀번호 
//             drive - 드라이명 ("A") 
//  리 턴 값 : 인증서의 개수 리턴, 해당 매체에 인증서가 존재 한지 않으면 0 리턴 
//  설    명 : 해당 매체에 존재하는 인증서의 개수를 리턴하며,INIplugin 내에 인증서
//             리스트가 메모리에 올라오게 된다 
// 
////////////////////////////////////////////////////////////////////////////////
//function GetCertListCount(store, pin, drive)
function xFlashGetCertListCount(store, pin, drive)
{
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
		return false;
	}
	i = obj.xFlashGetCertListCount(store, pin, drive);

	return i;
}

////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : xFlashGetAllCertHeader
//  파라메터 : store - 저장 매체 선택 (HDD: 0, FDD: 1, SCARD: 2, USB: 3)
//             pin - 핀번호 
//             drive - 드라이명 ("A") 
//  리 턴 값 : 성공하면 모든 인증서 헤더 스트링 리턴,
//             1) 각 필드 delimiter '&' 사용, 각 헤더 row delimiter '|' 사용
//             2) expired : 0(기간 유효시), 1(기간 만료시)
//            ex)"index=0&expired=0&user=홍길동&issuer=INITECH&type=사설&expire=2006-04-12|…|index=n&user=홍길동n&issuer=INITECH&type=사설&expire=2006-05-12"
//               실패 길이가 0인 스트링 리턴
//  설    명 : 선택된 매체에 있는 모든 인증서의 헤더 스트링을 얻어온다
// 
////////////////////////////////////////////////////////////////////////////////
//newAdd
function xFlashGetAllCertHeader(store, pin, drive)
{
    //alert("1.xFlashGetAllCertHeader:" + store + "/" + pin + "/" + drive);
	obj = ModuleInstallCheck();
	//alert("2.moduleInstallCheck():" + obj);
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
		return false;
	}
	strAllCertHeader = obj.xFlashGetAllCertHeader(store, pin, drive);
	return strAllCertHeader;
}

////////////////////////////////////////////////////////////////////////////////
// 
//  함 수 명 : xFlashGetCertHeader
//  파라메터 : idx - INIplugin 내에 구성된 리스트중 불어올 인증서 index
//  리 턴 값 : 성공 선택한 인증서 헤더 스트링 리턴
//             expired : 0(기간 유효시), 1(기간 만료시)
//             ex) "index=0&expired=0&user=홍길동&issuer=INITECH&type=사설&expire=2006-04-12"
//             실패 길이가 0인 스트링 리턴 
//  설    명 : I선택한 인증서의 header 스트링을 얻어온다
//
////////////////////////////////////////////////////////////////////////////////
//function GetCertInfoStr(idx)
function xFlashGetCertHeader(idx)
{
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
		return false;
	}

	strCertInfo = obj.xFlashGetCertHeader(idx);
	return strCertInfo;		
}

////////////////////////////////////////////////////////////////////////////////
// 
//  함 수 명 : xFlashGetCertDetail
//  파라메터 : idx - INIplugin 내에 구성된 리스트중 불어올 인증서 index
//  리 턴 값 : 성공 선택한 인증서의 자세한 정보 스트링 리턴, 
//             ex) "name=value&name=value&…&name=value&name=value"
//            실패 FALSE
//  설    명 : 선택한 인증서의 자세한 정보 스트링을 얻어온다
//
////////////////////////////////////////////////////////////////////////////////
//newAdd
function xFlashGetCertDetail(idx)
{
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
		return false;
	}

	strCertInfo = obj.xFlashGetCertDetail(idx);

	return strCertInfo;	
		
}

////////////////////////////////////////////////////////////////////////////////
// 
//  함 수 명 : xFlashRemoveDeviceCert
//  파라메터 : idx - INIplugin 내에 구성된 리스트중 삭제할 인증서 index
//  리 턴 값 : 성공 TRUE, 실패 FALSE
//  설    명 : 선택한 인증서를 삭제한다
//
////////////////////////////////////////////////////////////////////////////////
//newAdd
function xFlashRemoveDeviceCert(idx)
{
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
		return false;
	}

	i = obj.xFlashRemoveDeviceCert(idx);

	return i ;	
		
}

/////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : xFlashSetCertKeys
//  파라메터 : idx - INIplugin에 설정할 인증서의 index
//             pass - 선택한 인증서에 대응되는 개인키 패스워드 
//  리 턴 값 : 패스워드가 일치하고 INIplugin에 인증서 설정에 성공하면 true
//	       패스워드가 일치하지 않거나 인증서 설정에 실패하면 false
//  설    명 : INIplugin내에 사용할 인증서를 세팅 한다
//
/////////////////////////////////////////////////////////////////////////////////
//function SetCertificate(idx, pass, form)
function xFlashSetCertKeys(idx, pass, form)
{
	
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
		return false;
	}

	nRet = obj.xFlashSetCertKeys(idx, pass);

	if(nRet == 1) {
	    return true;
    //alert("인증에 성공했습니다");
	//	if (xFlashEncFormVerify(form))
	//			document.readForm.submit();
	//	else 
	//			alert('암호화에 문제 발생');
	}
	else
	    return false;
	    //alert("인증에 실패했습니다");
}

///////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : xFlashEncFormVerify
//  파라메타 : form
//  리 턴 값 : 성공하면 INIplugin data 리턴, 실패하면 길이가 0인 스트링 리턴 
//  설    명 : INIplugin에 인증서 설정이 성공적으로 이루어진후 그 인증서로 서명 INIplugin data를 
//	       생성 
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
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
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
			alert("INIpluginData(form.name)가 필요합니다.");
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
//  함 수 명 : MakeINIpluginData
//  파라메타 : 
//  리 턴 값 :  
//  설    명 :  
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
		alert("암호화프레임(secureframe)을 찾을수 없습니다.");
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
//  함 수 명 : xFlashCertRequest
//  파라메타 : 
//  리 턴 값 :  
//  설    명 :  
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
//참조번호와 인가코드는 새로 넣어야 함.
		Arg += "REF=";
		Arg += obj.URLEncode("1");	//참조번호
		Arg += "&CODE=";
		Arg += obj.URLEncode("2");	//인가코드
		Arg += "&CAIP=";
		Arg += obj.URLEncode("203.233.91.234");
		Arg += "&CAPORT=";
		Arg += obj.URLEncode("4512");

		obj.SetProperty("IssueSkipUI", "yes");

		obj.ExtendMethod("SetPin", "99999999");
		obj.ExtendMethod("SetDrive", "D:");	//FDD 일때 사용하는것

		ret = obj.CertRequest("YESSIGN", "HDD", Arg, "qqqqqqqq");
		//첫번째 인자는 공인인증서인 경우 고정, 두번재는 HDD, FDD, USB, SCARD 중 선택
		alert(ret);
		//ret 가 true 면 성공 save_fail 이면 저장 실패
		//나머지 다른 값이면 발급과정에서의 실패 에러 코드는 "숫자,에러메시지" 형식으로 리턴
	}
}


///////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : xFlashCertUpdate
//  파라메타 : 
//  리 턴 값 :  
//  설    명 : 
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

		obj.ExtendMethod("SetPin", "99999999");	//스마트카드나 USB토큰인 경우
		obj.ExtendMethod("SetDrive", "D:");	//FDD 일때 사용하는것

		ret = obj.CertUpdate("YESSIGN", "HDD", Arg);
		//첫번째 인자는 공인인증서인 경우 고정, 두번재는 HDD, FDD, USB, SCARD 중 선택
		alert(ret);
		//ret 가 true 면 성공 save_fail 이면 저장 실패
		//나머지 다른 값이면 발급과정에서의 실패 에러 코드는 "숫자,에러메시지" 형식으로 리턴
	}
}

///////////////////////////////////////////////////////////////////////////////////
//
//  함 수 명 : xFlashUrlEncode
//  파라메타 : 
//  리 턴 값 :  
//  설    명 : 파라메타로 전달받은 값을 UrlEncoding 하여 전달한다.
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
