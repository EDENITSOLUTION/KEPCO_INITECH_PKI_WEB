// Last Modified 2008-06-17 

// INIplugn-128 Java Script
// 1. update 2002/01/29 wakano@initech.com
//  - �������� ȣȯ �޼ҵ� ��� �߰�.
//		EncryptInput(form)     => EncForm
//		EncryptInput2(form, r) => EncFormVerify
//		�� �޼ҵ� ���� ���������� ShinHan_plugin ������ ����Ͽ� ó����
//	-. INIpluginData���� EcnForm.. ���� ����ó��
//
// 2. update 2002/03/13 wakano@initech.com
//  -. function GatherValue() ���� : ���ø��̳� �÷��� �������� elements�� ���� "" �ϰ�찡 ����
//		if(element.name=="") continue;
// 
// 3. update 2002/06/07 wakano@initech.com
//  -. function FrameCheck() ���� : windows.open�� 2���̻��ϰ�� �������� �ʴ� ���� ����
//  -. function GetVersion() ���� : Netscape���� �������� �ʴ� ���� ����
//  -. function EncLink() ���� : Netscape���� �������� �ʴ� ���� ����
//  -. function EncLocation() �߰�
//
// 4. update 2002/06/11 brson@initech.com
//  -. GatherValue, EncLink, EncLocation ����
//		:AddServerTime�� true�϶� TimeURL���� server�ð� �� ����Ÿ�� �߰���.
//	

//var TimeURL = "http://" + window.location.host + "/servlets/Time";
var TimeURL = "http://" + window.location.host + "/initech/plugin/tools/Random.jsp";

var LogoURL = 'http://' + window.location.host + '/initech/plugin/site/img/plugin.initech.com.gif';

var E2ERandomURL = "http://" + window.location.host + "/initech/plugin/tools/E2E_Random_DG.jsp";

if (navigator.systemLanguage != "ko")  //�ѱ������찡 �ƴҰ��
	LogoURL = 'http://' + window.location.host + '/initech/plugin/img/' + window.location.hostname + '.gif';


var YessignCAIP = "203.233.91.234";
var YessignCMPPort = "4512";
//var YessignCAIP = "203.233.91.71";
//var YessignCMPPort = 4512;

var cipher = "SEED-CBC";
var InitechPackage = "INITECH";
var YessignPackage = "YESSIGN";

var EnableMsg = true;
var secureframename="secureframe";
var secureframe=null;
var framecount = 0;
var maxframecount = 10;
var ShinHan_plugin = false;
var no_secureframe = true;

// �缳 CA ���� ���� 
var Initech_CAPackage = "INITECH_CA";
var Initech_CAIP = "118.219.55.139";
//var Initech_CMPPort = "58829";
//var Initech_CMPPort = "58088";
var Initech_CMPPort = "8200";
var CANAME = "INITECHCA";

//add brson
var AddServerTime=true;




// for flex for java
var baseURL	= "http://" + window.location.host + "/initech/plugin/";
//var TimeURL = baseURL + "tools/Time.jsp";

var isAgentCheckerLoaded = false;
var isAgentInstalled = false;
var agentVersion = "1.0.0.7";
var agentAirURL = baseURL + "swfs/INISAFEWeb4FlexAgent.air";
var agentAppID = "INISAFEWeb4FlexAgent";
var agentPubID = "18F1512CBFC8DC808B30CBD64B5090E4F6FA0CDD.1";
var titleImageURL = baseURL + "img/initech.gif";
var isLCEnc = false;

function getFlashVars() {
	var vars = "";
	vars += "serverCert=" + SCert;
	vars += "&timeUrl=" + TimeURL;
	vars += "&agentAppID=" + agentAppID;
	vars += "&agentPubID=" + agentPubID;
	vars += "&agentVersion=" + agentVersion;
	vars += "&agentInstallUrl=" + agentAirURL;
	vars += "&titleImgUrl=" + titleImageURL;
	vars += "&caDNs=" + getCACertCNs();
	//vars += "&domain=" + window.location.host;
	vars += "&domain=*";
	vars += "&isLCEnc=" + isLCEnc;
	return vars;
}

function getTitleImageURL() {
	return titleImageURL;
}

function getAgentAppID() {
	return agentAppID;
}

function getAgentPubID() {
	return agentPubID;
}

function getAgentVersion() {
	return agentVersion;
}

function getAgentAirURL() {
	return agentAirURL;
}

function getTimeURL() {
	return TimeURL;
}

function upgradeAgent() {
	document.agentChecker.updateApplication(agentURL, agentVersion);
}

function cbCheckerLoaded() {
	isAgentCheckerLoaded = true;
}

function checkInstall(callbackFun) {
	document.agentChecker.checkInstall(agentAppID, agentPubID, callbackFun);
}

function cbCheckInstall(installed, version) {
	isAgentInstalled = installed;
	
	if ( agentVersion > version )
		upgradeAgent();
}

function loadChecker() {
	document.writeln('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"');
	document.writeln('id="agentChecker" width="0%" height="0%"');
	document.writeln('codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">');
	document.writeln('<param name="movie" value="' + baseURL + '/swfs/AgentChecker.swf" />');
	document.writeln('<param name="quality" value="high" />');
	document.writeln('<param name="bgcolor" value="#869ca7" />');
	document.writeln('<param name="allowScriptAccess" value="always" />');
	document.writeln('<embed src="' + baseURL + '/swfs/AgentChecker.swf" quality="high" bgcolor="#869ca7"');
	document.writeln('width="0%" height="0%" name="agentChecker" align="middle"');
	document.writeln('play="true"');
	document.writeln('loop="false"');
	document.writeln('quality="high"');
	document.writeln('allowScriptAccess="always"');
	document.writeln('type="application/x-shockwave-flash"');
	document.writeln('pluginspage="http://www.adobe.com/go/getflashplayer">');
	document.writeln('</embed>');
	document.writeln('</object>');
}

function xMakePluginData(isSign, data, functionName){
	var obj = ModuleInstallCheck();
	if (obj == null) {
            alert("��ȣȭ ����� ��ġ���� �ʾҽ��ϴ�.");
            return false;
    }
	var vf = 0;
	var alg = null;
	var timeUrl = null;
	if( isSign == true )
		vf = 1;
	
	return obj.MakeINIpluginData(data, vf, functionName);
}


function InsertCerttoMS()
{
	var obj = ModuleInstallCheck();
	if (obj == null) return "";
	return obj.InsertCertToMS();
}

function FindSecureFrame(inframe)
{
	if(secureframe!=null) return secureframe;
	if (framecount++ > maxframecount) return null;
	if ((typeof inframe == "undefined") || (inframe == null))
	{
		return null;
	}
	else if ((typeof inframe.secureframe != "undefined")  && (inframe.secureframe != null))
	{
		//alert("secureframe Find OK = " + inframe.secureframe);
		framecount = 0;
		return inframe.secureframe
	} 
	else if (inframe.parent.length > 0) 
	{
		return FindsecureFrame(inframe.parent);
	}
    return null;
}

function FindsecureFrame(inframe)
{

	if(secureframe!=null) return secureframe;
	if (framecount++ > maxframecount) return null;
	if ((typeof inframe == "undefined") || (inframe == null))
	{
		return null;
	}
	else if ((typeof inframe.secureframe != "undefined")  && (inframe.secureframe != null))
	{
		//alert("secureframe Find OK = " + inframe.secureframe);
		framecount = 0;
		return inframe.secureframe
	} 
	else if (inframe.parent.length > 0) 
	{
		return FindsecureFrame(inframe.parent);
	}
    return null;
}

function FrameCheck()
{
	if (typeof document.INIplugin != "undefined")
	{
		secureframe = self;
	}
	else
	{
		framecount = 0;
		secureframe = FindsecureFrame(parent);

		//�˾�,��� �˾�â�� ��� �߰�
		//���â�� ������ window��ü�� Arguments�� ����������� ��밡��
		if (secureframe == null) {
			var open_frame = null;
			open_frame = top.opener;

			//opener�� ������� ���â���� �Ǵ� ���â���� �Ѱܹ��� ������ ��ü�� open_frame���� ����
			if ((typeof open_frame) == "undefined" && (typeof window.dialogArguments)!="undefined")
			{
				open_frame = window.dialogArguments;
			}
			//�ֻ��� opener���� ã�ư���.
			while((typeof open_frame) != "undefined")
			{
				if((typeof open_frame.document) == "unknown")
				{
					break;
				}//opener�� �����ϴ��� ���� üũ
				
				framecount = 0;
				secureframe = FindsecureFrame(open_frame);

				if (secureframe != null){
					break;
				}else{
					var t_open_frame = open_frame;
					open_frame = open_frame.top.opener;

					if ((typeof open_frame) == "undefined" 
						&& (typeof t_open_frame.window.dialogArguments)!="undefined")//opener�� ������� ������� �Ǵ�
					{
						open_frame = t_open_frame.window.dialogArguments;
					}
				} 
			}
		} 
	}
}


function ModuleInstallCheck()
{
	try{
		FrameCheck();
	}catch(e)
	{
		//alert(e.message);
	}

	if (secureframe==null) return;

	if(navigator.appName == "Netscape")
	{
		return secureframe.document.INIplugin;
	}
	else
	{
		if(secureframe.INIplugin==null || typeof(secureframe.INIplugin) == "undefined" || secureframe.INIplugin.object==null) return null;
		else return secureframe.INIplugin;
	}
}

function GatherValue(form, start, bErase)
{
	var strResult = "";
	var name = "";
	var value = "";
	var sel=0;

	// INIplugin-128 Install Check
	obj = ModuleInstallCheck();
	if (obj == null) return "";
	
	len = form.elements.length;
	for(i=start; i<len; i++) 
	{
		element = form.elements[i];

		//add to wakano 2002/03/13
		if(element.name=="") continue;
		if(element.name=="INIpluginData") continue;
		if(element.name=="filedata") continue;

		if ((ShinHan_plugin) && (element.name=="input")) // with for Shinhan Bank 
			continue;
		if (!((form.elements[i].type != "button") && (form.elements[i].type != "reset") && (form.elements[i].type != "submit"))) 
			continue;

		if ( ((element.type == "radio") || (element.type == "checkbox")) && (element.checked!=true) ) 
			continue;
		// File Field�� SKIP�Ѵ�.
        if(form.elements[i].name.indexOf('file_', 0) >= 0) {
			continue;
        }

		if (element.type == "select-one") {
			sel = element.selectedIndex;
			if(sel<0) continue;
			if (element.options[sel].value != ''){	
				value = element.options[sel].value;
			} else {
				value = element.options[sel].text;
			}
			if(bErase) element.selectedIndex = 0;
		} else{
			value = element.value;
			if(bErase) element.value = "";
		}

		// modify wakano 2001/08/21
		if ((element.type == "checkbox") && (bErase)) element.checked = false;

		if (strResult!="") strResult += "&";

		// modify brson 2002/06/11 check element.name
		if(element.name!=""){
			strResult += element.name;
			strResult += "=";
			strResult += obj.URLEncode(value);
		}
	}

	//modify brson 2002/06/11 
	//dt�� server time �߰�
	var ver="4,2,0,0";
	if(AddServerTime && EnableFunction(ver)) {
		if(strResult!=""){
				strResult = "__INIts__=" + obj.GetServerTime(TimeURL) + "&" + strResult;
		}
		else{
				strResult = "__INIts__=" + obj.GetServerTime(TimeURL);
		}
	}
	/*else if(AddServerTime){
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ �������� �ʴ±���Դϴ�."
	    msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return "";
	}
	*/

	return strResult;
}

function GatherFileValue(form, start, bErase)
{
	var strResult = "";
	var name = "";
	var value = "";
	var sel=0;

	// INIplugin-128 Install Check
	obj = ModuleInstallCheck();
	if (obj == null) return "";
	
	len = form.elements.length;
	for(i=start; i<len; i++) 
	{
		element = form.elements[i];

		//add to wakano 2002/03/13
		if(element.name=="") continue;
		if(element.name=="INIpluginData") continue;
		if(element.name=="filedata") continue;

		if ((ShinHan_plugin) && (element.name=="input")) // with for Shinhan Bank 
			continue;
		if (!((form.elements[i].type != "button") && (form.elements[i].type != "reset") && (form.elements[i].type != "submit"))) 
			continue;

		if ( ((element.type == "radio") || (element.type == "checkbox")) && (element.checked!=true) ) 
			continue;
		// File Field
        if(form.elements[i].name.indexOf('file_', 0)>=0)
        //if(form.elements[i].name.indexOf('inputfileform_1', 0)>=0)
		{
	        if(strResult!="")
			{
 	        	strResult += "&";
            }
            strResult+= form.elements[i].name;
            strResult += "=";
            strResult += obj.URLEncode(form.elements[i].value);
			if(bErase) form.elements[i].value = "";
 		}
	}

	return strResult;
}

// make for Shinhan Bank
function EncryptInput(form)
{	
	ShinHan_plugin = true;
	return EncForm(form);
}

function EncryptInput2(form, r)
{
	ShinHan_plugin = true;
	return EncFormVerify(form);
}

function EncForm(form) 
{
	var INIdata = "";
	var eletemp = "";
	var filetemp = "";

	obj = ModuleInstallCheck();

	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	filetemp = GatherFileValue(form, 0, true);
	if (filetemp !=  "")
	{
		if ((form.filedata.value = obj.MakeFileData(0, cipher, filetemp)) == "") return false; 
	}

	eletemp = GatherValue(form, 0, true);
	if ((INIdata = obj.MakeINIpluginData(0, cipher, eletemp, ""))=="") return false;

	//add bye wakano 2001/01/29
	if (typeof form.INIpluginData == "undefined") 
	{
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
	}

   	return true;
}

function EncForm2(form1, form2) 
{
	var INIdata = "";
	var eletemp = "";
	var filetemp = "";

	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	filetemp = GatherFileValue(form1, 0, false);
	if (filetemp !=  "") 
	{
		if ((form2.filedata.value = obj.MakeFileData(0, cipher, filetemp)) == "") return false; 
	}

	eletemp = GatherValue(form1, 0, false);
	if ((INIdata = obj.MakeINIpluginData(0, cipher, eletemp, ""))=="") return false;

	//add bye wakano 2001/01/29
	if (typeof form2.INIpluginData == "undefined") 
	{
		if (ShinHan_plugin) // with for Shinhan Bank 
		{
			form2.input.value = INIdata;
			form2.input.name = "INIpluginData"; // for Shinhan Bank
		} else {
			alert("INIpluginData(form.name)�� �ʿ��մϴ�.");
			return false;
		}
	} else {
		form2.INIpluginData.value = INIdata;
	}

   	return true;
}

function EncLink(url, encData, target, style)
{
	var queryString = "INIpluginData=";
	var INIdata;

	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	//modify brson 2002/06/11 
	//dt�� server time �߰�
	var ver="4,2,0,0";
	if(AddServerTime && EnableFunction(ver)) {
		if(encData!=""){
				encData = "__INIts__=" + obj.GetServerTime(TimeURL) + "&" + encData;
		}
		else{
				encData = "__INIts__=" + obj.GetServerTime(TimeURL);
		}
	}


	//modify wakano 2002/06/07
	if ((INIdata = obj.MakeINIpluginData(0, cipher, encData, ""))=="") return false;
	queryString += obj.URLEncode(INIdata);
	if(url.indexOf('?', 0) < 0) url += "?";
	if((url.charAt(url.length-1)!='?') && (url.charAt(url.length-1)!='&')) url += "&";
	url += queryString;
	
	window.open(url, target, style);
}

//add by wakano 2002/06/07
function EncLocation(indata)
{
	var INIdata;
	var s = indata.indexOf('?');

	//add by wakano 2002/07/15
	if (s <= -1 ) s = indata.length;

	var url = indata.substring(0, s) + "?INIpluginData=";
	var encData = indata.substring(s+1);

	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	//modify brson 2002/06/11 
	//dt�� server time �߰�
	var ver="4,2,0,0";
	if(AddServerTime && EnableFunction(ver)) {
		if(encData!=""){
				encData = "__INIts__=" + obj.GetServerTime(TimeURL) + "&" + encData;
		}
		else{
				encData = "__INIts__=" + obj.GetServerTime(TimeURL);
		}
	}

	if ((INIdata = obj.MakeINIpluginData(0, cipher, encData, ""))=="") return false;
	url += obj.URLEncode(INIdata);
	//alert(url);
	return url;
}

function Idecrypt(data)
{
	obj = ModuleInstallCheck();
	if (obj == null) return "";
	
	if (navigator.appName == 'Netscape') 
	{
		if(EnableFunction("4,1,15,0")) 
			return obj.Decrypt(cipher, data);
		else
			return unescape(obj.Decrypt(cipher, data));
	}
	else
		return obj.Decrypt(cipher, data);
}

function EncFormVerify(form) 
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
		if ((form.filedata.value = obj.MakeFileData(1, cipher, filetemp)) == "") return false; 
	}

	//LoadRunner�� �ڵ�����������
	//alert("email=suggyoung@goodbank.com,cn=������,ou=CertExt,o=Koram,l=����,c=KR", "a1111111");
	//alert(obj.SelectClientCert("email=suggyoung@goodbank.com,cn=������,ou=CertExt,o=Koram,l=����,c=KR", "a1111111"));
	//alert(obj.SelectClientCert("cn=���1��(����)()00912002042500000006,ou=KimSangGyun,ou=�̴���,ou=corporation4EC,o=yessign,c=kr", "qqqqqqqq"));

	eletemp = GatherValue(form, 0, true);
	if ((INIdata = obj.MakeINIpluginData(1, cipher, eletemp, Random))=="") return false;
	if (INIdata == "keylib error")
	{
		form2.INIpluginData.value = INIdata;
		return false;
	}

	//add bye wakano 2001/01/29
	if (typeof form.INIpluginData == "undefined") 
	{
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
	}
    
   	return true;
}

function EncFormVerify2(form1, form2)
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
	
	filetemp = GatherFileValue(form1, 0, false);
	if (filetemp !=  "") 
	{
		if ((form2.filedata.value = obj.MakeFileData(1, cipher, filetemp)) == "") return false; 
	}

	eletemp = GatherValue(form1, 0, false);
	if ((INIdata = obj.MakeINIpluginData(1, cipher, eletemp, Random))=="") return false;
	if (INIdata == "keylib error")
	{
		form2.INIpluginData.value = INIdata;
		return false;
	}

	//add bye wakano 2001/01/29
	if (typeof form2.INIpluginData == "undefined") 
	{
		if (ShinHan_plugin) // with for Shinhan Bank 
		{
			form2.input.value = INIdata;
			form2.input.name = "INIpluginData"; // for Shinhan Bank
		} else {
			alert("INIpluginData(form.name)�� �ʿ��մϴ�.");
			return false;
		}
	} else {
		form2.INIpluginData.value = INIdata;
	}

   	return true;
}

/* ASP Time Check �� �Լ� �ӽÿ��Դϴ�. */
function imsi_FormVerify(form1, form2)
{
	var INIdata = "";
	var eletemp = "";
	var filetemp = "";
	var TimeURL = "http://" + window.location.host + "/initech/plugin/tools/Time.asp";
	var Random = TimeURL;

	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	
	filetemp = GatherFileValue(form1, 0, false);
	if (filetemp !=  "") 
	{
		if ((form2.filedata.value = obj.MakeFileData(1, cipher, filetemp)) == "") return false; 
	}

	eletemp = GatherValue(form1, 0, false);
	if((form2.INIpluginData.value = obj.MakeINIpluginData(1, cipher, eletemp, Random))=="") return false;
	if ((INIdata = obj.MakeINIpluginData(1, cipher, eletemp, Random))=="") return false;

	//add bye wakano 2001/01/29
	if (typeof form2.INIpluginData == "undefined") 
	{
		if (ShinHan_plugin) // with for Shinhan Bank 
		{
			form2.input.value = INIdata;
			form2.input.name = "INIpluginData"; // for Shinhan Bank
		} else {
			alert("INIpluginData(form.name)�� �ʿ��մϴ�.");
			return false;
		}
	} else {
		form2.INIpluginData.value = INIdata;
	}
	
   	return true;
}

function EncLinkVerify(url, encData, target)
{
	var queryString = "INIpluginData=";
	var INIdata;
	var Random = TimeURL;

	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	
	if((INIdata = obj.MakeINIpluginData(1, cipher, encData, Random))=="") return;
	queryString += obj.URLEncode(INIdata);

	if(url.indexOf('?', 0) < 0) url += "?";
	if((url.charAt(url.length-1)!='?') && (url.charAt(url.length-1)!='&')) url += "&";
	
	url += queryString;
	window.open(url, target);
}

function InsertUserCert(cert)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;

	return obj.InsertUserCert(InitechPackage, "", cert);
}

function InsertUserCert2(cert, storage)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;

	return obj.InsertUserCert(InitechPackage, storage, cert);
}

function CertRequest(form)
{
	var dn="";
	var temp=""
	len = form.elements.length;

	form.req.value="";

	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	for (i = 0; i < len; i++) 
	{
		var name = form.elements[i].name.toUpperCase();
		var temp = form.elements[i].value;
		if(name == "C")	dn = dn + "C=" + obj.URLEncode(temp) + "&";
		if(name == "L")	dn = dn + "L=" + obj.URLEncode(temp) + "&";
		if(name == "O")	dn = dn + "O=" + obj.URLEncode(temp) + "&";
		if(name == "OU") dn = dn + "OU=" + obj.URLEncode(temp) + "&";
		if(name == "CN") dn = dn + "CN=" + obj.URLEncode(temp) + "&";
		if(name == "EMAIL")
		{
			if(temp=="") temp = " ";

			dn = dn + "EMAIL=" + obj.URLEncode(temp) + "&";
		}
	}
	
	//req = obj.CertRequest2(InitechPackage, "", dn, form.challenge.value); 
	req = obj.CertRequest2(InitechPackage, "", dn, "qqqqqqqq"); 
	//req = obj.CertRequest(InitechPackage, "HDD", dn, "qqqqqqqq"); 
	//alert("test");
	if(req=="") return false;
	form.req.value = req;
	
	return true;		
}

function CertRequest2(form)
{
    var dn="";
    var temp=""
    len = form.elements.length;

    form.req.value="";

    obj = ModuleInstallCheck();
    if (obj == null) return false;

    for (i = 0; i < len; i++)
    {
        var name = form.elements[i].name.toUpperCase();
        var temp = form.elements[i].value;
        if(name == "C") dn = dn + "C=" + obj.URLEncode(temp) + "&";
        if(name == "L") dn = dn + "L=" + obj.URLEncode(temp) + "&";
        if(name == "O") dn = dn + "O=" + obj.URLEncode(temp) + "&";
        if(name == "OU") dn = dn + "OU=" + obj.URLEncode(temp) + "&";
        if(name == "CN") dn = dn + "CN=" + obj.URLEncode(temp) + "&";
        if(name == "EMAIL")
        {
            if(temp=="") temp = " ";

            dn = dn + "EMAIL=" + obj.URLEncode(temp) + "&";
        }
    }

    SetProperty("IssueSkipUI", "yes");

    //req = obj.CertRequest2(InitechPackage, "", dn, form.challenge.value); 
    //req = obj.CertRequest2(InitechPackage, "HDD", dn, "qqqqqqqq"); 
    req = obj.CertRequest(InitechPackage, "HDD", dn, "qqqqqqqq");
    //alert("test");
    if(req=="") return false;
    form.req.value = req;

    return true;
}

function IssueCertificate(szRef, szCode)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	var Arg = "";
	var challenge = "1111";
	
	Arg += "REF=";
	Arg += obj.URLEncode(szRef);
	Arg += "&CODE=";
	Arg += obj.URLEncode(szCode);
	Arg += "&CAIP=";
	Arg += obj.URLEncode(YessignCAIP);
	Arg += "&CAPORT=";
	Arg += obj.URLEncode(YessignCMPPort);
	
	if(obj.CertRequest(YessignPackage, "", Arg, challenge)=="") {
		var msg = "���������� �߱޽� ������ �߻��Ͽ� ������ �߱޿� �����Ͽ����ϴ�.\n"
		    msg += "�Ʒ��� ������ȣ�� �ΰ��ڵ带 �����Ͻÿ� yessign���� �߱� �����ñ� �ٶ��ϴ�.\n\n"
		    msg += "������ȣ : " + szRef;
		    msg += "\t�ΰ��ڵ� : " + szCode;
	    alert(msg);
        return false;
    }
    return true;
}

function UpdateCertificate()
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;

	var Arg = "";
	var challenge = "1111";
	
	Arg += "CAIP=";
	Arg += obj.URLEncode(YessignCAIP);
	Arg += "&CAPORT=";
	Arg += obj.URLEncode(YessignCMPPort);
	
	//if(obj.CertUpdate(YessignPackage, "", Arg)=="")	return false;
	if(obj.CertUpdate2(YessignPackage, "", Arg)=="")	return false; //ĳ��������������

	return true;
}

function InsertCACert(cert)
{
	// INIplugin-128 Install Check

	obj = ModuleInstallCheck();
	if (obj == null) return false;
	obj.InsertCACert(InitechPackage, cert);
	
	return true;
}

//add bye wakano 2001/01/29 with for Shinhan Bank 
function EncryptedCertRequest(form1)
{
        ShinHan_plugin = true;
    	if(CertRequest(form1)){
        	return EncForm(form1);
    	}
    	return false;
}

function EncCertReq(form1)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	if(CertRequest(form1)) return EncForm(form1);

	return false;
	
}

function EncCertReq2(form1, form2)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	if(!CertRequest(form1))
		return false;

	return EncForm2(form1, form2);
}

function LoadCACert(CACert)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	obj.LoadCACert(CACert);
	
	return true;
}

function DeleteUserCert(DelCert)
{
	obj = ModuleInstallCheck();
	if (obj == null) return;
	
	if (obj.DeleteUserCert(InitechPackage, "", DelCert)) 
	{
		alert("�ش� ������ �����Ͽ����ϴ�.");
	}
	else
	{
		alert("���� ����Ͻô� ��ǻ�Ϳ� �ش� �������� ��� �������� ���Ͽ����ϴ�.");
	}
	
	return;		
}

function RevokeCertificate(serial)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;
    //alert(serial);
	if(obj.DeleteUserCert(YessignPackage, "", serial))
	{
		//alert("�ش� ������ �����Ͽ����ϴ�.");
		return true;
	}
	else
	{
		//alert("���� ����Ͻô� ��ǻ�Ϳ� �ش� �������� ��� �������� ���Ͽ����ϴ�.");
		return false;
	}

    return  true;
}

function SelFile(field)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;

    field.value = obj.SelectFile();
}

function InstallModule(InstallModuleURL)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	if(InstallModuleURL=="") return true;
	obj.InstallModule(InstallModuleURL);
	return true;
}

function FilterUserCert(storage, issuerAndSerial)
{
    obj = ModuleInstallCheck();
    if (obj == null) return -1;
	return obj.FilterUserCert(storage, issuerAndSerial);
}

function FilterUserCert2(storage, issuerAndSerial)
{
    obj = ModuleInstallCheck();
    if (obj == null) return -1;
	return obj.FilterUserCert2(storage, issuerAndSerial);
}

function URLEncode(data)
{
    obj = ModuleInstallCheck();
    if (obj == null) return "";
	return obj.URLEncode(data);
}

function GetStorageSerial(storage, pin)
{
    obj = ModuleInstallCheck();
    if (obj == null) return "";
	return obj.GetStorageSerial(storage, pin);
}

function IsCheckCard(storage)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;
	return obj.IsCheckCard(storage);
}

function VerifyPin(storage, pin)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;
	return obj.VerifyPIN(storage, pin);
}

function ChangePIN(storage, oldpin, newpin)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;
	return obj.ChangePIN(storage, oldpin, newpin);
}

//add to brson :  ���Ͼ�ȣȭ V4.0.2.4
///////////////////////////////////////////////////
///////////// ���Ͼ�ȣȭ API  /////////////////////
///////////////////////////////////////////////////

function EncFile(url, form) 
{
	var eletemp = "";
	var filetemp = "";

	obj = ModuleInstallCheck();
	if (obj == null) return false;

	filetemp = GatherFileValue(form, 0, true);
	//	filetemp = "test=d:\\cert.zip";
	alert("function encfile filetem = " + filetemp);
	alert("function encfile url = " + url);
	alert("function encfile cipher = " + cipher);
	if (filetemp !=  "")
	{
		alert('11');

		if ((form.INIfileData.value = obj.UploadEncryptFile(url, 0, cipher, filetemp, "")) == ""){
			alert("File Upload Fail");
			return false; 
		}
		alert("INIfileData = " + form.INIfileData.value);
	}

	eletemp = GatherValue(form, 0, true);
	if ((form.INIpluginData.value = obj.MakeINIpluginData(0, cipher, eletemp, ""))=="") return false;

	alert("from.INIpluginData.value: " + form.INIpluginData.value);

   	return true;
}

function EncFile2(url, form, form2) 
{
	var eletemp = "";
	var filetemp = "";

	obj = ModuleInstallCheck();
	if (obj == null) return false;

	filetemp = GatherFileValue(form, 0, false);
	if (filetemp !=  "")
	{
		//alert("fileValue = " + filetemp);
		if ((form.INIfileData.value = obj.UploadEncryptFile(url, 0, cipher, filetemp, "")) == ""){
			alert("File Upload Fail");
			return false; 
		}
		//alert("INIfileData = " + form.INIfileData.value);
	}

	eletemp = GatherValue(form, 0, false);
	if ((form2.INIpluginData.value = obj.MakeINIpluginData(0, cipher, eletemp, ""))=="") return false;

   	return true;
}

function EncDown(url, args) 
{
	alert("EncDown::::args =  " + args);
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	return obj.DownloadEncryptFile(url, 0, cipher, args, "");
}

function EncDownVerify(url, args) 
{

	obj = ModuleInstallCheck();
	if (obj == null) return false;
	return obj.DownloadEncryptFile(url, 1, cipher, args, TimeURL);
}

function URLEncode(value) 
{
	obj = ModuleInstallCheck();
	if (obj == null) return "";
	return obj.URLEncode(value);
}

///////////////////////////////////////////////////
///////////// �ʱⰪ ���� API  /////////////////////
///////////////////////////////////////////////////

function LoadCert(Cert)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	return obj.LoadCert(Cert);
}

function InitCache()
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	obj.InitCache();
	
	return true;
}

function SetCacheTime(gap)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	
	obj.SetCacheTime(gap);
	
	return true;
}

function ReSession()
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	obj.ReSession();
	return true;
}

function SetLogoPath()
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;
    return obj.SetLogoPath(LogoURL);
}

function EnableCheckCRL(check)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;
    obj.EnableCheckCRL(check);
}

function SetVerifyNegoTime(time1, time2)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;
    obj.SetVerifyNegoTime(time1, time2);
}

function DisableInvalidCert(check)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	obj.DisableInvalidCert(check);
}

function SetTVBanking(bTV)
{
	var ver = "4, 1, 3, 0";
	if(EnableFunction(ver)) {
		obj = ModuleInstallCheck();
		if (obj == null) return false;
		obj.SetTVBanking(bTV);
	} else {
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ �������� �ʴ±���Դϴ�."
	    msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return false;
	}
	return true;
}

///////////////////////////////////////////////////
///////////// ��Ÿ             /////////////////////
///////////////////////////////////////////////////

function GetVersion()
{
	var ver = "4,0,0,0"
	var thisVer = ver;
    obj = ModuleInstallCheck();
    if (obj == null) return ver;

	//modify wakano 2002/06/07
	thisVer = obj.GetVersion();
	if ( (thisVer == null) || (thisVer == "") ) return ver;
	return String(thisVer);
}

function EnableFunction(inputVersion)
{
	var thisArray = GetVersion().split(',');
    var inputArray = inputVersion.split(',');

	for (i=0; i<4; i++)
	{
		if (parseInt(thisArray[i], 10) > parseInt(inputArray[i], 10))
			return true;
		else if (parseInt(thisArray[i], 10) < parseInt(inputArray[i], 10))
			return false;
	}
	return true;
}

function ManageCert()
{
	obj = ModuleInstallCheck();
	if (obj == null) return; 
	obj.ManageCert();
}

function INIAbout()
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;
	obj.About();
	return true;
}

function GetClientUID()
{
	var ver = "4, 5, 0, 0";
	if(EnableFunction(ver)) {
		obj = ModuleInstallCheck();
		if (obj == null) return;
	    return obj.GetClientUID();
	} else {
		var msg;
		//msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ �������� �ʴ±���Դϴ�."
	    //msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
	    msg = "\n .. �������Դϴ�... "
		if (EnableMsg) alert(msg);
	}
	return;
}


///////////////////////////////////////////////////
/////////////���ݰ�꼭 API ����/////////////////////
///////////////////////////////////////////////////

function MakeTaxData(inform, outform)
{
	var gValue = "";
    var ret  = "";
    
	len = inform.elements.length;
    outform.INIpluginTax.value="";

    obj = ModuleInstallCheck();
    if (obj == null) return false;

    for (i = 0; i < len; i++) {
    	var name = inform.elements[i].name;
        var value = obj.URLEncode(inform.elements[i].value);
        gValue = gValue + name + "=" + value + "&";
    }

    ret = obj.MakeTaxData(gValue);
    if(ret == "" || ret == "CERT_NOT_FOUND") return false;
    outform.INIpluginTax.value = ret;

    return true;
}

//��꼭
function MakeTadData(inform, outform)
{
	var gValue = "";
    var ret  = "";
    
	len = inform.elements.length;
    outform.INIpluginTax.value="";

    // INIplugin-128 Install Check
    obj = ModuleInstallCheck();
    if (obj == null) return false;

    for (i = 0; i < len; i++) {
    	var name = inform.elements[i].name;
        var value = obj.URLEncode(inform.elements[i].value);
        gValue = gValue + name + "=" + value + "&";
    }

    ret = obj.MakeTadData(gValue);
    if(ret == "" || ret == "CERT_NOT_FOUND") return false;
    outform.INIpluginTax.value = ret;

    return true;
}


function EncMakeTaxData(inform, outform)
{
	if(MakeTaxData(inform, outform)) {
		alert(outform.INIpluginTax.value);
		return EncForm(outform);
	}
	return false;
}

//��꼭
function EncMakeTadData(inform, outform)
{
	if(MakeTadData(inform, outform)) {
		alert(outform.INIpluginTax.value);
		return EncForm(outform);
	}
	return false;
}

function SaveTaxData(taxData)
{
        // INIplugin-128 Install Check
        obj = ModuleInstallCheck();
        if (obj == null) return false;
        if(obj.SaveTaxData(taxData)){
                return true;
        } else {
                return false;
        }
}
//��꼭
function SaveTadData(taxData)
{
        // INIplugin-128 Install Check
        obj = ModuleInstallCheck();
        if (obj == null) return false;
        if(obj.SaveTadData(taxData)) {
                return true;
        } else {
                return false;
        }
}

function SaveTaxData2Clt(pfile, taxData)
{
        // INIplugin-128 Install Check
        obj = ModuleInstallCheck();
        if (obj == null) return false;
        if(obj.SaveTaxData2Clt(pfile, taxData)) {
                return true;
        } else {
                return false;
        }
}
//��꼭
function SaveTadData2Clt(pfile, taxData)
{
        // INIplugin-128 Install Check
        obj = ModuleInstallCheck();
        if (obj == null) return false;
        if(obj.SaveTadData2Clt(pfile, taxData)) {
                return true;
        } else {
                return false;
        }
}

function ManageTax()
{
	obj = ModuleInstallCheck();
        if (obj == null) return false;
        if(obj.manageTax()) {
                return true;
        } else {
                return false;
        }
}


///////////////////////////////////////////////////
///////////// ���ڼ��� API ����/////////////////////
///////////////////////////////////////////////////

function AddSignValue(data, name, value)
{
	if(data!="") data += "&";
	data += URLEncode(name);
	data += "=";
	data += URLEncode(value);
	return data;
}

function PKCS7SignedData(form, data, view)
{
	var ver = "4, 1, 14, 0";
	if(EnableFunction(ver)) {
		obj = ModuleInstallCheck();
		if (obj == null) return false;

		form.PKCS7SignedData.value = obj.PKCS7SignData("sha1", data, TimeURL, view);
		if(form.PKCS7SignedData.value=="") return false;
		return true;

	} else {
		alert("this");
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ ���ڼ��� ����� �������� �ʽ��ϴ�."
		msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg)	alert(msg);
		return false;
	}
}

function IniSign(form, data, inputtitle, inputdata)
//function IniSign(form, data, inputdata)
//inputdata�� null�ϰ�� ó��....��� ó��...�ұ�?????
{
	var iniputtitle = "";
	var ver = "4, 1, 9, 0";
	if(EnableFunction(ver)) {
		obj = ModuleInstallCheck();
		if (obj == null) return false;
		
		form.PKCS7SignedData.value = obj.IniSign("sha1", data, TimeURL, inputtitle, inputdata);
		if(form.PKCS7SignedData.value=="") return false;
		//alert(form.PKCS7SignedData.value);
		return true;
	} else {
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ ���ڼ��� ����� �������� �ʽ��ϴ�."
		msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return false;
	}
}

/*
function IniSign2(form, data)
{
	var ver = "4, 1, 9, 0";
	if(EnableFunction(ver)) {
		obj = ModuleInstallCheck();
		if (obj == null) return false;

		form.PKCS7SignedData.value = obj.IniSign2("sha1", data, TimeURL);
		if(form.PKCS7SignedData.value=="") return false;
		return true;

	} else {
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ ���ڼ��� ����� �������� �ʽ��ϴ�."
		msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return false;
	}
}
*/

function IniSign3(form, data, htmlURL)
{
	// ���� ������... ������ �����ұ�??....
	var ver = "4, 5, 0, 0";
	if(EnableFunction(ver)) {
		obj = ModuleInstallCheck();
		if (obj == null) return false;
		
		form.PKCS7SignedData.value = obj.IniSign3("sha1", data, htmlURL, TimeURL);
		if(form.PKCS7SignedData.value=="") return false;
		//alert(PKCS7SignedData);
		return true;
	} else {
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ ���ڼ��� ����� �������� �ʽ��ϴ�."
		msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return false;
	}
}


function SetProperty(name, value)
{
	var obj = ModuleInstallCheck();
	if (obj == null) return "";
	
	return obj.SetProperty(name, value);
}


//INISafeWeb 4.5.4.21 �������� ���Ǵ� �Լ��� 2003-06-10

function IsCachedCert()				//������ ĳ���Ǿ� �ִ��� true/false
{
	var obj = ModuleInstallCheck();
	if (obj == null) return false;
	return obj.IsCachedCert();
}

function GetCachedCert(name)		//ĳ������������ dn�������� ������
{
	var obj = ModuleInstallCheck();
	if (obj == null) return "";
	return obj.GetCachedCert(name);
}

function CheckCRL(cert)				// ������(ĳ����) �������� crlȮ��
{
	var obj = ModuleInstallCheck();
	if (obj == null) return false;
	return obj.CheckCRL(cert);
}

function ViewCert(cert)				// ����� ������ �����ֱ�
{
	var obj = ModuleInstallCheck();
	if (obj == null) return false;
	return obj.ViewCert(cert);
}

function InitPass()
{
	obj = ModuleInstallCheck();
	if (obj == null) return null;
	
	return obj.ExtendMethod("InitCache", "on");
}
function FilterCert(storage, issuerAndSerial)
{
    obj = ModuleInstallCheck();
    if (obj == null) return -1;
				
	return obj.FilterCert(storage, issuerAndSerial);
}

//���� �߰�... ���� ���� ���� �� ����
function setSharedAttribute(name, value){
	obj = ModuleInstallCheck();
	if (obj == null) return false;

	var ver = "5, 1, 5, 23";
	if(!EnableFunction(ver)) {
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ �� ����� �������� �ʽ��ϴ�."
		msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return false;
	}
	
	obj.setSharedAttribute(name, value);
	return true;
}

function getSharedAttribute(name){
	obj = ModuleInstallCheck();
	if (obj == null) return null;

	var ver = "5, 1, 5, 23";
	if(!EnableFunction(ver)) {
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ �� ����� �������� �ʽ��ϴ�."
		msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return false;
	}
	
	return obj.getSharedAttribute(name);
}

/*
 * ĳ���� �������� serial ���� �����Ѵ�.
 * add by juno at 2004/11/11 - �������� Ŭ���̾�Ʈ���� ������ Ȯ���ϱ�
 * GetCachedData("serial") - ���� ĳ���� �������� SerialNumber�� �����Ѵ�.
 * GetCachedData("subjectcn") - ���� ĳ���� �������� SubjectCN�� �����Ѵ�.
 * GetCachedData("subjectdn") - ���� ĳ���� �������� SubjectDN�� �����Ѵ�.
 * GetCachedData("issuerdn") - ���� ĳ���� �������� IssuerDN�� �����Ѵ�.
 */
function GetCachedData(key)
{
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}

	if(key == "serial") {
	    return obj.GetCachedData(key);
	}
        else if(key == "subjectcn") {
	    return obj.GetCachedData(key);
	}
	else if(key == "subjectdn") {
	    return obj.GetCachedData(key);
	}
	else if(key == "issuerdn") {
	    return obj.GetCachedData(key);
	}
	else {
	    alert("������ key�� �ƴմϴ�. [serial, subjectdn, subjectcn, issuerdn]");
	    return false;
	}
}

function ExtendMethod(name,value)
{
	obj = ModuleInstallCheck();
	if (obj == null) return null;
	
	return obj.ExtendMethod(name, value);
}

function GetCachedData(key)
{
	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
     	return false;
	}

	return obj.GetCachedData(key);
}
//name : ��ȣȭ �� ������, length : field ����, ch : padding character, form : form name
//��ȣȭ �� �������� ���̰� ������ field ���̺��� ���� ��� padding character�� �̿��ؼ� ����� ��ŭ ä���ش�.

// 2007-08-03 by park young jin. �߰�
function EncryptLengthToSK(name,length,ch,form){
	
    var ver = "5, 0, 0, 0";
	if(!EnableFunction(ver)) {
		var msg;
		msg = "���� ��ġ�� ���� V " + GetVersion() + " ������ ���߾�ȣȭ ����� �������� �ʽ��ϴ�."
		msg += "\n\nV " + ver + " �̻����� ���׷��̵� �Ͻñ� �ٶ��ϴ�."
		if (EnableMsg) alert(msg);
		return false;
	}

	obj = ModuleInstallCheck();
	if (obj == null) {
		alert("��ȣȭ������(secureframe)�� ã���� �����ϴ�.");
		return false;
	}
	
	for(var i=0; i<form.elements.length ; i++) 
	{
		var element = form.elements[i];
		if (element.name == name) {
			if(element.value.length < length){
				var cnt = element.value.length;
				var padding = length - cnt;				
				for (i=0; i<padding; ++i)
				{
					element.value += ch;
				}
			}			
			element.value = obj.EncryptWithSKInfo2(form.INIencSK.value, element.value);
			return true;
		}
	}
	alert("���߾�ȣȭ�� form.name(" + name + ")�� ã������ �����ϴ�.");
	return false;
}

// �缳 ������ ���� �Լ���
// ������ �߱�
function INITECHCA_IssueCertificate(szRef, szCode)
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;

    var Arg = "";
    var challenge = "1111";

    Arg += "REF=";
    Arg += obj.URLEncode(szRef);
    Arg += "&CODE=";
    Arg += obj.URLEncode(szCode);
    Arg += "&CAIP=";
    Arg += obj.URLEncode(Initech_CAIP);
    Arg += "&CAPORT=";
    Arg += obj.URLEncode(Initech_CMPPort);
    Arg += "&CANAME=";
    Arg += obj.URLEncode(CANAME);

    if(obj.CertRequest(Initech_CAPackage, "", Arg, challenge)=="") {
        var msg = "������ �߱޽� ������ �߻��Ͽ� ������ �߱޿� �����Ͽ����ϴ�.\n"
            msg += "�Ʒ��� ������ȣ�� �ΰ��ڵ带 �����Ͻÿ� �߱� �����ñ� �ٶ��ϴ�.\n\n"
            msg += "������ȣ : " + szRef;
            msg += "\t�ΰ��ڵ� : " + szCode;
        alert(msg);
        return false;
        }
    return true;
}


// ������ �ڵ��߱� �� 
function INITECHCA_IssueCertificateA(szRef, szCode)
{
	obj = ModuleInstallCheck();
	if (obj == null) return false;

	var Arg = "";
	var password = "qqqqqqqq";

	Arg += "REF=";
	Arg += obj.URLEncode(szRef);
	Arg += "&CODE=";
    Arg += obj.URLEncode(szCode);
    Arg += "&CAIP=";
    Arg += obj.URLEncode(Initech_CAIP);
    Arg += "&CAPORT=";
    Arg += obj.URLEncode(Initech_CMPPort);
    Arg += "&CANAME=";
    Arg += obj.URLEncode(CANAME);


	SetProperty("IssueSkipUI", "yes");



    if(obj.CertRequest(Initech_CAPackage, "HDD", Arg, password)=="") {
        var msg = "������ �߱޽� ������ �߻��Ͽ� ������ �߱޿� �����Ͽ����ϴ�.\n"
		msg += "�Ʒ��� ������ȣ�� �ΰ��ڵ带 �����Ͻÿ� �߱� �����ñ� �ٶ��ϴ�.\n\n"
	    msg  += "������ȣ : " + szRef;
		msg += "\t�ΰ��ڵ� : " + szCode;
        alert(msg);
        return false;
    }
    return true;

}



// ������ ����
function INITECHCA_UpdateCertificate()
{
    obj = ModuleInstallCheck();
    if (obj == null) return false;

    var Arg = "";
    var challenge = "1111";

    Arg += "CAIP=";
    Arg += obj.URLEncode(Initech_CAIP);
    Arg += "&CAPORT=";
    Arg += obj.URLEncode(Initech_CMPPort);
    Arg += "&CANAME=";
    Arg += obj.URLEncode(CANAME);
	alert("1");
    if(obj.CertUpdate2(Initech_CAPackage, "", Arg)=="") return false; //.........

    return true;
}

function ExtendMethod(name,value)
{
	obj = ModuleInstallCheck();
	if (obj == null) return null;

	return obj.ExtendMethod(name, value);
}
