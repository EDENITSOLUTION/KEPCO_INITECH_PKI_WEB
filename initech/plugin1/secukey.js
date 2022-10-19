var E2ERandomURL = "http://" + window.location.host + "/initech/plugin64/tools/E2E_Random.jsp";

// 키보드보안 js를 코드를 깔끔하게 만들기 위해.. by wjlee

////////////////////////////////////////////////////////////////////////
// OS버전을 체크하기 위해..
OS_VER = window.navigator.appVersion;

////////////////////////////////////////////////////////////////////////
// 키보드 보안 버전
SCSK_VER1 = "4,0,31,62";
SCSK_VER2 = "4,0,6031,62";

////////////////////////////////////////////////////////////////////////
// CLSID
CLSID_SCSKV = "CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83";

////////////////////////////////////////////////////////////////////////
// cab 파일의 경로
CODEBASE_PATH	= "http://www.softcamp.co.kr/scsk/cab/";

////////////////////////////////////////////////////////////////////////
// cab 파일 이름
CAB_SCSKV_ANSI		= "SCSK4_9X.cab";

CAB_SCSKV_UNICODE	= "SCSK4.cab";

CAB_SCSKV_VISTA		= "SCSK4_VISTA.cab";

CAB_SCSKV_WOW64		= "SCSK4_WOW64.cab";

////////////////////////////////////////////////////////////////////////
// param 옵션
PARAM_USEICON_1		= "<param name='USEICON' value='1'>";
PARAM_OPTION_2		= "<param name='OPTION' value='2'>";
PARAM_UHOPTION_1	= "<param name='UHOPTION' value='1'>";
PARAM_HACKOPTION_17 = "<param name='HACKOPTION' value='17'>";
PARAM_HACKMSGSTR	= "<param name='HACKMSGSTR' value='키보드 입력을 가로채려는 시도가 있습니다.'>";
PARAM_HACKHTMSTR	= "<param name='HACKHTMSTR' value='http://www.softcamp.co.kr/scsk/attack_info/index.asp'>";

PARAM_TRAYSTR		= "<param name='TRAYSTR' value='e2e test'>";
PARAM_SITECODE		=  "<param name='SiteCode' value='9232'>";
PARAM_INI7CustomCode = "<param name='INI7CustomCode' value='106'>";
PARAM_EtEBkColor	= "<param name='EteExtBkColor' value='13434828'>"
PARAM_ExtE2EServerCert = '<param name="ExtE2EServerCert" value="'+SCert+'">';
PARAM_E2ERandomURL = '<param name="ExtE2ERandomURL" value="'+E2ERandomURL+'">';

//PARAM_ExtE2EDoubleServerCert '<param name="ExtE2EDoubleServerCert" value="'+SCert2+'">';



////////////////////////////////////////////////////////////////////////
// Object ID
ID_SCSK = "secukey";

////////////////////////////////////////////////////////////////////////
// Object Style
OBJECT_STYLE = "position:absolute;left:-1px;top:-1px;width:0px;height:0px";

////////////////////////////////////////////////////////////////////////
// OBJECT 태그 시작
OBJECT_TAG =  "<object ";
OBJECT_TAG += "classid='" + CLSID_SCSKV + "' ";	// CLSID
OBJECT_TAG += "codebase='" + CODEBASE_PATH;		// CAB PATH

//////////////////////////////////////////////////////////////////////
// OS 에 따라 cab파일, 버전을 결정

// x64
if ( OS_VER.indexOf("WOW64") > 0 )
{
	OBJECT_TAG += CAB_SCSKV_WOW64;					// CAB FILE
	OBJECT_TAG += "#version=" + SCSK_VER2 + "' ";	// VER	
}
// Vista
else if ( OS_VER.indexOf("NT 6") > 0 )
{
	OBJECT_TAG += CAB_SCSKV_VISTA;					// CAB FILE
	OBJECT_TAG += "#version=" + SCSK_VER2 + "' ";	// VER
}
// 9x, Me
else if ( OS_VER.indexOf("98") > 0 || OS_VER.indexOf("winme") > 0 )
{
	OBJECT_TAG += CAB_SCSKV_ANSI;					// CAB FILE
	OBJECT_TAG += "#version=" + SCSK_VER1 + "' ";	// VER
}
// XP, 2K
else
{
	OBJECT_TAG += CAB_SCSKV_UNICODE;				// CAB FILE
	OBJECT_TAG += "#version=" + SCSK_VER1 + "' ";	// VER
}

OBJECT_TAG += "ID='" + ID_SCSK + "' ";				// ID
OBJECT_TAG += "style='" + OBJECT_STYLE + "'>";		// STYLE


////////////////////////////////////////////////////////////////////////
// 실제로 Object 태그를 쓰고, param을 입력
document.write( OBJECT_TAG );
	
document.write( PARAM_USEICON_1 );
document.write( PARAM_OPTION_2 );
document.write( PARAM_UHOPTION_1 );
document.write( PARAM_HACKOPTION_17 );
//document.write( PARAM_HACKMSGSTR );
document.write( PARAM_HACKHTMSTR );
document.write( PARAM_TRAYSTR );
document.write( PARAM_SITECODE );
document.write( PARAM_INI7CustomCode );
document.write( PARAM_EtEBkColor );
document.write( PARAM_ExtE2EServerCert );
//document.write( PARAM_ExtE2EDoubleServerCert );
document.write( PARAM_E2ERandomURL );


document.write( "</object>" );


// 메모리변조 방지를 적용하기 위한 함수 1
function SetExtE2EFields(form)
{
	secukey.SetExtE2EFields(document);

	var obj = form.appendChild(document.createElement("<input type='hidden' name='_E2E_REAL_HSEED_' value='"+ secukey.GetHSeedINI7()+"'>"));
	var obj1 = form.appendChild(document.createElement("<input type='hidden' name='secukey_state' value='"+ secukey.state()+"'>"));
	var obj2 = form.appendChild(document.createElement("<input type='hidden' name='secukey_ini7e2estate' value='"+ secukey.ini7e2estate()+"'>"));
}
var ExtE2E_enable = true;
// 메모리변조 방지를 적용하기 위한 함수 2
//input의 elememt로 등록하기.
function SetSCSKEtEExtbyID(form,input,hidden)
{
	input.autocomplete='off'; //자동완성 기능 끄기
	input.style.imeMode = "disabled";	//한글입력 막기.
	secukey.AddETEExtInput(document, input, hidden);
	if(ExtE2E_enable){
		SetExtE2EFields(form);
		ExtE2E_enable = false;
	}
}
// 메모리변조 방지를 적용하기 위한 함수 3
//input 의 name으로 등록하기.
function SetSCSKEtEExtbyName(form,inputname,hiddenname)
{
	var inputelement=null;
	var hiddenelement=null;
	len = form.elements.length;
	for(i=0; i<len; i++)
	{
		if(form.elements[i].name==inputname)
		{
			// 메모리변조 방지 대상 필드가 text 가 아닌 경우에 대한 예외처리 - by sgun 2008-03-12
			if(form.elements[i].type == "text"){
				inputelement=form.elements[i];
			}else{
				return false;
			}
		}
		else if(form.elements[i].name==hiddenname)
		{
			hiddenelement = form.elements[i];
		}
	}

	if(inputelement && hiddenelement)
	{
		SetSCSKEtEExtbyID(form, inputelement,hiddenelement);
	}
}