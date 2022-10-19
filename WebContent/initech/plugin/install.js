/* INISAFE Web V6 - install.js 
   수정일자 : 2007.07.19 
   수 정 자 : 프로젝트 팀
*/

/********************************************************************
1. update 2004/09/01 wakano@initech.com
 - INISAFEWeb.html에서 프레임없이 사용하는 구조
	: function CheckPlugin() 및 var InstallPluginURL, CheckVersion 추가

2. update 2005/11/01 wakano@initech.com
 - IDC을 이용하여 다운로드 받는 구조로 변경
	: var InitechGroupID 추가(맨마지막 라인참고)

3. update 2005/11/01 young@initech.com
 - componentName, mimeType 오류 수정 (Netscape 및 파이어폭스)
********************************************************************/

var baseURL				= "http://" + window.location.host + "/initech/plugin/";

var DownBaseURL			= "http://" + window.location.host + "/initech/plugin/";

var InstallModuleURL	= DownBaseURL + "dll/INIS60.vcs"; 
var InstallModuleURL_noExt	= baseURL + "dll/INIS60_noExt.vcs";
var iePackageURL                = DownBaseURL + "down/INIS60_"+getCodeSigningHashName()+".cab";
var nsPackageURL		= DownBaseURL + "down/INIS60.jar"; 
var ieManualPackageURL	= DownBaseURL + "down/INIS60.exe";

/* 선배포를 위해 추가 */
var InstallModuleURL_Rate	    = DownBaseURL + "dll_rate/INIS60.vcs"; 
var InstallModuleURL_noExt_Rate	= baseURL + "dll_rate/INIS60_noExt.vcs";
var iePackageURL_Rate			= DownBaseURL + "down_rate/INIS60.cab"; 
var nsPackageURL_Rate			= DownBaseURL + "down_rate/INIS60.jar"; 
var ieManualPackageURL_Rate		= DownBaseURL + "down_rate/INIS60.exe";

/********************************************************************/

var nsManualPackageURL	= ieManualPackageURL;
var manualInstallURL	= baseURL + "download.html";

 

/* 선배포를 위해 추가 */
var ieVersion_Rate		= "6,4,0,89"; 
var nsVersion_Rate		= ieVersion_Rate;

var ieVersion			= "6,4,0,89"; 
var nsVersion			= ieVersion;
/********************************************************************/

// add 2004/09/01 wakano@initech.com INISAFEWeb.html 사용시 사용)
var InstallPluginURL	= "http://" + window.location.host + "/initech/plugin/site/install.html";
var CheckVersion		= ieVersion;  // 업그레이드 확인버전 ieVersion과 동일하게 사용을 권장

var componentName		= "plugins/initech/INISAFE60/npINISAFEWeb60.dll";
var mimeType			= "application/x-INISAFEWebv60";
//var CLSID				= "286A75C3-11FB-4FB4-AC4A-4DD1B0750050";
var CLSID				= "DD8C54E8-9028-4a54-96B9-30761B1F80DF";


/****************************************************/
/*********** 아래의 내용은 수정하지 마세요 **********/
/****************************************************/

function getWindowsVersion()
{
    var tp = navigator.platform, ua = navigator.userAgent;
    var result = {};

    // version
    if (tp == "Win32" || tp == "Win64"){
            if(ua.indexOf("Windows NT 5.1") != -1) {result.version="5.1"; result.name="Windows XP";}
            else if(ua.indexOf("Windows NT 6.0") != -1) {result.version="6.0"; result.name="Windows VISTA";}
            else if(ua.indexOf("Windows NT 6.1") != -1) {result.version="6.1"; result.name="Windows 7";}
            else if(ua.indexOf("Windows NT 6.2") != -1) {result.version="6.2"; result.name="Windows 8";}
            else if(ua.indexOf("Windows NT 6.3") != -1) {result.version="6.3"; result.name="Windows 8.1";}
            else if(ua.indexOf("Windows NT 6.4") != -1) {result.version="6.4"; result.name="Windows 10";}
            else if(ua.indexOf("Windows NT 10.0") != -1) {result.version="10.0"; result.name="Windows 10";}
            else if(ua.indexOf("Windows NT") != -1){
                        result.version="UNKNOWN"; result.name="UNKNOWN";
            } else {
                        result.version="UNKNOWN"; result.name="UNKNOWN";
            }
    }
    return result;
}

 function getCodeSigningHashName(){
    if(getWindowsVersion().name == "Windows XP" || getWindowsVersion().name == "Windows VISTA" || getWindowsVersion().name == "UNKNOWN"){
        return "SHA1";}
    return "SHA2";
}

/* 선배포 기능 추가 ,  쿠키 설정 */
function get_Cookie(name){ 
    var cname = name + "=";               
    var dc = document.cookie;             
 
    if (dc.length > 0) {              
     begin = dc.indexOf(cname);       
        
        if (begin != -1) {           
         begin += cname.length;       
         end = dc.indexOf(";", begin);
 
         if (end == -1) end = dc.length;
             return unescape(dc.substring(begin, end));
        } 
    }
    return "";
} 

/* 선배포 기능 추가 , 쿠키 가져오기 */
 function set_Cookie(cKey, cValue)  // name,pwd
{
    // 만료시점 : 오늘날짜+1 설정
    var validTime = 12;		//시간
	var expire_date = new Date()
	
	expire_date = new Date(expire_date.getTime() + 60*60*validTime*1000)
    // 쿠키 저장
    document.cookie = cKey + '=' + escape(cValue) + ';expires=' + expire_date.toGMTString();
}

function setDeliveryCheck()
{	
	/* 1. 기존 쿠키가 살아 있는지 확인함, 있다면 그대로 리턴 */
	var flagStr = getDeliveryCheck();

	if(0 < flagStr.length)
	{
		/* 1-2. 쿠키가 있다면 리턴 한다 */
		return;
	}
	/* 2. 선배포에 적합환 환경 설정을 수행함 */
	probability = 10;   //10 = 1/10 확률 , 5 = 1/5 확률 , 1 = 1/1 확률
	
	var r = Math.floor(Math.random() * probability) + 1;
	
	
	/* 3. r == 1 일 경우에만 클라이언트를 배포 */
	if(r == 1){
		set_Cookie("_ini6_pre_delivery_", "true");
	}
	else
	{
		set_Cookie("_ini6_pre_delivery_", "false");
	}
}

function getDeliveryCheck()
{
	/* 1. 쿠키에 저장된 배포 처리를 가져옴 */
	var flagStr = get_Cookie("_ini6_pre_delivery_");
	return flagStr;
}


function getIntVersion(versionStr)
{
	var version = new Array(4);
	versionArray = versionStr.split(",");	
	for(i=0;i<4;i++)
		version[i] = parseInt(versionArray[i], 10);

	return version;
}

function myVersionCompare()
{
	var myMimetype = navigator.mimeTypes[mimeType];
	var desc = myMimetype.enabledPlugin.description;
    var index = desc.indexOf('v.', 0);
    if (index < 0)
        return -5;
    desc += ' ';

    versionString = desc.substring(index+2, desc.length);
    arrayOfStrings = versionString.split('.');

	var existing = new Array(4);
	for(i=0; i<4; i++)
    	existing[i] = parseInt(arrayOfStrings[i], 10);

	var version = getIntVersion(nsVersion);

	for(i=0; i<4; i++)
	{
		if(existing[i]>version[i])
			return (4-i);
		else if(existing[i]<version[i])
			return -(4-i);
	}

    return 0;
}

//add  brson 2002/4/16
function getUserAgentVersion()
{	
	var s = navigator.userAgent.indexOf("/");
	var	e = navigator.userAgent.indexOf(" ");
	var	ver = navigator.userAgent.substring(s+1, s+4);
	return ver;
}

//change brson 2002/4/16
function startDownload() 
{
	var trigger;
	var version;
	var newVI;
	var existingVI;
	var myMimetype = navigator.mimeTypes[mimeType];
	// If some version is already installed on this machine...
	if ( myMimetype ) {
		if(getUserAgentVersion()>=5.0){
			if(myVersionCompare()<0){
				top.location = manualInstallURL;
				return true;
			} else{
				return true;
			}
		}
		trigger = netscape.softupdate.Trigger;
		version = getIntVersion(nsVersion);
		newVI = new netscape.softupdate.VersionInfo(version[0], version[1], version[2], version[3]);
		existingVI = netscape.softupdate.Trigger.GetVersionInfo(componentName);
		if ( existingVI==null)
		{
			if(myVersionCompare()<0)
			{
				alert("INIplugin을 설치합니다.");
				//return trigger.StartSoftwareUpdate(nsPackageURL, trigger.DEFAULT_MODE|trigger.SILENT_MODE);
				return trigger.StartSoftwareUpdate(nsPackageURL, trigger.DEFAULT_MODE);
			}
			else
			{
				return true;
			}
		}
		else if ( existingVI.compareTo(newVI)<0)
		{
			alert("INIplugin을 설치합니다.");
			//return trigger.ConditionalSoftwareUpdate(nsPackageURL, componentName, newVI, trigger.DEFAULT_MODE|trigger.SILENT_MODE);
			return trigger.ConditionalSoftwareUpdate(nsPackageURL, componentName, newVI, trigger.DEFAULT_MODE);
		}
		else
		{
			return true;
		}
	}
	else
	{
		if(getUserAgentVersion()>=5.0){
			top.location = manualInstallURL;
			return true;
		}
		else{
			trigger = netscape.softupdate.Trigger;
			alert("INIplugin을 설치합니다.");
			//return trigger.StartSoftwareUpdate(nsPackageURL, trigger.DEFAULT_MODE|trigger.SILENT_MODE);
			return trigger.StartSoftwareUpdate(nsPackageURL, trigger.DEFAULT_MODE);
		}
	}

	return false;
}



//change brson 2002/4/16
function isInstalled()
{
	var myMimetype = navigator.mimeTypes[mimeType];
	if ( myMimetype ){
		if(getUserAgentVersion()>=5.0){
			if(myVersionCompare()>=0){
				return true;
			}else{
				return false;
			}
		} else{
			var version = getIntVersion(nsVersion);
			var newVI = new netscape.softupdate.VersionInfo(version[0], version[1], version[2], version[3]);
			var existingVI = netscape.softupdate.Trigger.GetVersionInfo(componentName);
			if(existingVI==null) {
				if(myVersionCompare()>=0){
					return true;
				}else{
					return false;
				}
			}
			else if ( existingVI.compareTo(newVI)>=0){
				return true;
			}
		}
	}
	return false;
}

var loadOK;
function LoadPlugin()
{
	loadOK=true;	
	if (navigator.appName == 'Netscape' && navigator.userAgent.indexOf('Trident') ==  -1) 
	{
		if(isInstalled())
		{
			document.writeln('<EMBED type=' + mimeType + ' name="INIplugin" width=2 height=2>INIplugin Load OK</EMBED>');
		}
		else
		{
			loadOK = startDownload();
			NS_Init();
		}
	}
	else
	{
		/* 선배포 대상인지 확인하여 처리하는 함수를 추가 한다. */
		setDeliveryCheck();

		/* 1. 선배포 대상인지를 체크 한다 */
		if("true" == getDeliveryCheck())
		{
			/* 1-1. 선배포 대상 */
			document.writeln('<OBJECT ID="INIplugin" CLASSID="CLSID:' + CLSID + '" width=1 height=1 ');
			document.writeln('CODEBASE='+ iePackageURL_Rate + '#Version=' + ieVersion_Rate +'>');
			document.writeln('</OBJECT>');	
		}
		else
		{
			/* 1-2. 선배포 대상 아님 */
			document.writeln('<OBJECT ID="INIplugin" CLASSID="CLSID:' + CLSID + '" width=1 height=1 ');
			document.writeln('CODEBASE='+ iePackageURL + '#Version=' + ieVersion +'>');
			document.writeln('</OBJECT>');	
		}
	}
}

var loopCount=0;
function NS_Init()
{
	
	if(!loadOK)
	{
		alert("설치 실패");
	}
	else if(isLoaded())
	{
		return;
	}
	else if(isInstalled())
	{
		location.reload();
		//location.replace("./INIplugin.html");	
	}
	else
	{
		loopCount++;
		if(loopCount>60*10)
		{
			alert("설치 실패");
		}
		else
		{
			setTimeout("NS_Init()", 1000);
		}
	}
}

function isLoaded()
{
	if(navigator.appName == "Netscape" && navigator.userAgent.indexOf("Trident") ==  -1)
	{
		if(document.INIplugin==null)
			return false;
		else
			return true;
	}
	else
	{
		if(frame.INIplugin==null || typeof(frame.INIplugin) == "undefined" || frame.INIplugin.object==null) return false;
		else 
			return true;
	}
}

// add 2004/09/01 wakano@initech.com
function CheckPlugin()
{
	var installOK = false;
	loadOK=true;

//alert(installOK + "=[start]");

	if (navigator.appName == 'Netscape' && navigator.userAgent.indexOf('Trident') ==  -1) 
	{
		if(isInstalled()) {
			document.writeln('<EMBED type=' + mimeType + ' name="INIplugin" width=2 height=2>INIplugin Load OK</EMBED>');
			installOK = true;
		}
	} 
	else
	{
		document.writeln('<OBJECT ID="INIplugin" CLASSID="CLSID:' + CLSID + '" width=1 height=1 ');
		document.writeln('CODEBASE='+ iePackageURL + '#Version=' + ieVersion +'>');
		document.writeln('</OBJECT>');	
		//document.writeln('<OBJECT ID="INIplugin" CLASSID="CLSID:' + CLSID + '" width=1 height=1 ></OBJECT>');

		//alert("check 1 = " + typeof(this.document.INIplugin));
		//alert("check 2 = " + this.document.INIplugin);
		//alert("check 3 = " + this.document.INIplugin);
		//alert("check 4 = " + this.document.INIplugin.object);

		if( !((typeof(this.document.INIplugin) == "undefined") || (this.document.INIplugin == "undefined") ||
				(this.document.INIplugin == null) || (this.document.INIplugin.object == null) ))
		{
			var thisArray = String(this.document.INIplugin.GetVersion()).split(',');
			var inputArray = CheckVersion.split(',');
			for (i=0; i<4; i++)
			{
//alert(thisArray[i] + "|" + inputArray[i]);
				if (parseInt(thisArray[i], 10) > parseInt(inputArray[i], 10)) {
					installOK = true;
					break;
				} else if (parseInt(thisArray[i], 10) < parseInt(inputArray[i], 10)) {
					break;
				} else {
					if (i==3) installOK = true;
				}
			}
//alert(installOK + "=[version check end]");

			if (installOK == true)
			{
				var inputArray2 = ieVersion.split(',');
				for (i=0; i<4; i++)
				{
//alert(thisArray[i] + "|" + inputArray2[i]);
					if (parseInt(thisArray[i], 10) > parseInt(inputArray2[i], 10)) {
						break;
					} else if (parseInt(thisArray[i], 10) < parseInt(inputArray2[i], 10)) {
						if (confirm("암호화모듈(INISAFE Web)이 업그레이드 되었습니다. 업그레이드 하시겠습니까")) {
							installOK = false;
							break;
						}
						break;
					}
				}
//alert(installOK + "=[upgrade check end]");
			}
		}
	}
//alert(installOK + "=[end]");
	if (installOK == false) top.location = InstallPluginURL;
}

