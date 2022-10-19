var os_ver = window.navigator.appVersion;
if(os_ver.indexOf("WOW64")>0){
	document.write('<object classid="CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83" codebase="http://www.softcamp.co.kr/scsk/ini6_kjb_fsa_test/SCSK4_wow64.cab#version=4,0,6031,8" width="0" height="0" id="secukey" >');
	document.write('<param name="USEICON" value="1">');
	document.write('<param name="OPTION" value="2">');
	document.write('<param name="TRAYSTR" value="ini6 test">');
	document.write('<param name="SiteCode" value="9232">');			//이걸지정해야 Initech 6 적용됨
	document.write('<param name="INI7CustomCode" value="106">');		//이걸지정해야 Initech 6 적용됨
	document.write('<param name="ExtE2EServerCert" value="'+SCert+'">');	//은행서버 공개키
	document.write('<param name="ExtE2EDoubleServerCert" value="'+SCert+'">');	//뱅크타운서버 공개키
	document.write('<param name="EteExtBkColor" value="13434828">'); //rgb를 십진수로 변환해서 넘기면 됨.
	//document.write('<param name="ETEOPTIONFLDS" value="input1;input2;input3;">'); //option
	////HACKOPTION
	//#define HACKOPTION_ALERT_NO		0x00000000		
	//#define HACKOPTION_ALERT_HTM		0x00000001		//HTM 경고가 디폴트.
	//#define HACKOPTION_ALERT_MSG		0x00000002
	
	
	//#define HACKOPTION_USE_EXIT		0x00000010		//종료한다. (16)
	//#define HACKOPTION_ERR_OFF		0x00000100		//에러가 안나게한다. (256)
	
	document.write('<param name="HACKOPTION" value="256">');
	//document.write('<param name="HACKHTMSTR" value="http://www.softcamp.co.kr/scsk">');
	//document.write('<param name="HACKMSGSTR" value="해킹메시지 예제입니다.">');
	document.write('</object>');
}
else if(os_ver.indexOf("Win64")>0)
{
	alert("32bit Internet Explorer를 사용하십시오.");
}
else if(os_ver.indexOf("NT 6")>0){
	document.write('<object classid="CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83" codebase="http://www.softcamp.co.kr/scsk/ini6_kjb_fsa_test/SCSK4_vista.cab#version=4,0,6031,8" width="0" height="0" id="secukey" >');
	document.write('<param name="USEICON" value="1">');
	document.write('<param name="OPTION" value="2">');
	document.write('<param name="TRAYSTR" value="ini6 test">');
	document.write('<param name="SiteCode" value="9232">');			//이걸지정해야 Initech 6 적용됨
	document.write('<param name="INI7CustomCode" value="106">');		//이걸지정해야 Initech 6 적용됨
	document.write('<param name="ExtE2EServerCert" value="'+SCert+'">');	//은행서버 공개키
	document.write('<param name="ExtE2EDoubleServerCert" value="'+SCert+'">');	//뱅크타운서버 공개키
	document.write('<param name="EteExtBkColor" value="13434828">'); //rgb를 십진수로 변환해서 넘기면 됨.
	//document.write('<param name="ETEOPTIONFLDS" value="input1;input2;input3;">'); //option
	////HACKOPTION
	//#define HACKOPTION_ALERT_NO		0x00000000		
	//#define HACKOPTION_ALERT_HTM		0x00000001		//HTM 경고가 디폴트.
	//#define HACKOPTION_ALERT_MSG		0x00000002
	
	
	//#define HACKOPTION_USE_EXIT		0x00000010		//종료한다. (16)
	//#define HACKOPTION_ERR_OFF		0x00000100		//에러가 안나게한다. (256)
	
	document.write('<param name="HACKOPTION" value="256">');
	//document.write('<param name="HACKHTMSTR" value="http://www.softcamp.co.kr/scsk">');
	//document.write('<param name="HACKMSGSTR" value="해킹메시지 예제입니다.">');
	document.write('</object>');	
}else{
	document.write('<object classid="CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83" codebase="http://www.softcamp.co.kr/scsk/ini6_kjb_fsa_test/scsk4.cab#version=4,0,31,8" width="0" height="0" id="secukey" >');
	document.write('<param name="USEICON" value="1">');
	document.write('<param name="OPTION" value="2">');
	document.write('<param name="TRAYSTR" value="ini6 test">');
	document.write('<param name="SiteCode" value="9232">');			//이걸지정해야 Initech 6 적용됨
	document.write('<param name="INI7CustomCode" value="106">');		//이걸지정해야 Initech 6 적용됨
	document.write('<param name="ExtE2EServerCert" value="'+SCert1+'">');	//은행서버 공개키
	document.write('<param name="ExtE2EThirdServerCert" value="'+SCert+'">');	//뱅크타운서버 공개키
	document.write('<param name="EteExtBkColor" value="13434828">'); //rgb를 십진수로 변환해서 넘기면 됨.
	document.write('<param name="ExtE2ERandomURL" value="'+E2ERandomURL+'">'); //rgb를 십진수로 변환해서 넘기면 됨.

	//document.write('<param name="ETEOPTIONFLDS" value="input1;input2;input3;">'); //option
	////HACKOPTION
	//#define HACKOPTION_ALERT_NO		0x00000000		
	//#define HACKOPTION_ALERT_HTM		0x00000001		//HTM 경고가 디폴트.
	//#define HACKOPTION_ALERT_MSG		0x00000002
	
	
	//#define HACKOPTION_USE_EXIT		0x00000010		//종료한다. (16)
	//#define HACKOPTION_ERR_OFF		0x00000100		//에러가 안나게한다. (256)
	
	document.write('<param name="HACKOPTION" value="256">');
	//document.write('<param name="HACKHTMSTR" value="http://www.softcamp.co.kr/scsk">');
	//document.write('<param name="HACKMSGSTR" value="해킹메시지 예제입니다.">');
	document.write('</object>');
}



//document.write('<param name="ExtE2EServerCert" value="'+SCert+'">');	//이걸지정해야 field 이름을 가져옴.

//************************************************************************************************
//제약사항 
//내부적으로 inputelement name 으로 구분하므로, 같은 페이지에 같은 name 이 있으면 안된다.

function SetExtE2EFields()
{
	secukey.SetExtE2EFields(document);
}

//input의 elememt로 등록하기.
function SetSCSKEtEExtbyID(input,hidden)
{
	input.autocomplete='off'; //자동완성 기능 끄기
	input.style.imeMode = "disabled";	//한글입력 막기.
	secukey.AddETEExtInput(document, input, hidden);
}

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
			inputelement=form.elements[i];
		}
		else if(form.elements[i].name==hiddenname)
		{
			hiddenelement = form.elements[i];
		}
	}

	if(inputelement && hiddenelement)
	{
		SetSCSKEtEExtbyID(inputelement,hiddenelement);
	}
}

//htm 내부에 있는것이 좋다.
//SetSCSKEtEExtbyName(document.forms[0], "account", "_ExtE2E123_account");

