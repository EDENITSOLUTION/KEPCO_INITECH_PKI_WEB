var E2ERandomURL = "http://" + window.location.host + "/initech/plugin64/tools/E2E_Random.jsp";

// Ű���庸�� js�� �ڵ带 ����ϰ� ����� ����.. by wjlee

////////////////////////////////////////////////////////////////////////
// OS������ üũ�ϱ� ����..
OS_VER = window.navigator.appVersion;

////////////////////////////////////////////////////////////////////////
// Ű���� ���� ����
SCSK_VER1 = "4,0,31,62";
SCSK_VER2 = "4,0,6031,62";

////////////////////////////////////////////////////////////////////////
// CLSID
CLSID_SCSKV = "CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83";

////////////////////////////////////////////////////////////////////////
// cab ������ ���
CODEBASE_PATH	= "http://www.softcamp.co.kr/scsk/cab/";

////////////////////////////////////////////////////////////////////////
// cab ���� �̸�
CAB_SCSKV_ANSI		= "SCSK4_9X.cab";

CAB_SCSKV_UNICODE	= "SCSK4.cab";

CAB_SCSKV_VISTA		= "SCSK4_VISTA.cab";

CAB_SCSKV_WOW64		= "SCSK4_WOW64.cab";

////////////////////////////////////////////////////////////////////////
// param �ɼ�
PARAM_USEICON_1		= "<param name='USEICON' value='1'>";
PARAM_OPTION_2		= "<param name='OPTION' value='2'>";
PARAM_UHOPTION_1	= "<param name='UHOPTION' value='1'>";
PARAM_HACKOPTION_17 = "<param name='HACKOPTION' value='17'>";
PARAM_HACKMSGSTR	= "<param name='HACKMSGSTR' value='Ű���� �Է��� ����ä���� �õ��� �ֽ��ϴ�.'>";
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
// OBJECT �±� ����
OBJECT_TAG =  "<object ";
OBJECT_TAG += "classid='" + CLSID_SCSKV + "' ";	// CLSID
OBJECT_TAG += "codebase='" + CODEBASE_PATH;		// CAB PATH

//////////////////////////////////////////////////////////////////////
// OS �� ���� cab����, ������ ����

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
// ������ Object �±׸� ����, param�� �Է�
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


// �޸𸮺��� ������ �����ϱ� ���� �Լ� 1
function SetExtE2EFields(form)
{
	secukey.SetExtE2EFields(document);

	var obj = form.appendChild(document.createElement("<input type='hidden' name='_E2E_REAL_HSEED_' value='"+ secukey.GetHSeedINI7()+"'>"));
	var obj1 = form.appendChild(document.createElement("<input type='hidden' name='secukey_state' value='"+ secukey.state()+"'>"));
	var obj2 = form.appendChild(document.createElement("<input type='hidden' name='secukey_ini7e2estate' value='"+ secukey.ini7e2estate()+"'>"));
}
var ExtE2E_enable = true;
// �޸𸮺��� ������ �����ϱ� ���� �Լ� 2
//input�� elememt�� ����ϱ�.
function SetSCSKEtEExtbyID(form,input,hidden)
{
	input.autocomplete='off'; //�ڵ��ϼ� ��� ����
	input.style.imeMode = "disabled";	//�ѱ��Է� ����.
	secukey.AddETEExtInput(document, input, hidden);
	if(ExtE2E_enable){
		SetExtE2EFields(form);
		ExtE2E_enable = false;
	}
}
// �޸𸮺��� ������ �����ϱ� ���� �Լ� 3
//input �� name���� ����ϱ�.
function SetSCSKEtEExtbyName(form,inputname,hiddenname)
{
	var inputelement=null;
	var hiddenelement=null;
	len = form.elements.length;
	for(i=0; i<len; i++)
	{
		if(form.elements[i].name==inputname)
		{
			// �޸𸮺��� ���� ��� �ʵ尡 text �� �ƴ� ��쿡 ���� ����ó�� - by sgun 2008-03-12
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