var os_ver = window.navigator.appVersion;
if(os_ver.indexOf("WOW64")>0){
	document.write('<object classid="CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83" codebase="http://www.softcamp.co.kr/scsk/ini6_kjb_fsa_test/SCSK4_wow64.cab#version=4,0,6031,8" width="0" height="0" id="secukey" >');
	document.write('<param name="USEICON" value="1">');
	document.write('<param name="OPTION" value="2">');
	document.write('<param name="TRAYSTR" value="ini6 test">');
	document.write('<param name="SiteCode" value="9232">');			//�̰������ؾ� Initech 6 �����
	document.write('<param name="INI7CustomCode" value="106">');		//�̰������ؾ� Initech 6 �����
	document.write('<param name="ExtE2EServerCert" value="'+SCert+'">');	//���༭�� ����Ű
	document.write('<param name="ExtE2EDoubleServerCert" value="'+SCert+'">');	//��ũŸ��� ����Ű
	document.write('<param name="EteExtBkColor" value="13434828">'); //rgb�� �������� ��ȯ�ؼ� �ѱ�� ��.
	//document.write('<param name="ETEOPTIONFLDS" value="input1;input2;input3;">'); //option
	////HACKOPTION
	//#define HACKOPTION_ALERT_NO		0x00000000		
	//#define HACKOPTION_ALERT_HTM		0x00000001		//HTM ��� ����Ʈ.
	//#define HACKOPTION_ALERT_MSG		0x00000002
	
	
	//#define HACKOPTION_USE_EXIT		0x00000010		//�����Ѵ�. (16)
	//#define HACKOPTION_ERR_OFF		0x00000100		//������ �ȳ����Ѵ�. (256)
	
	document.write('<param name="HACKOPTION" value="256">');
	//document.write('<param name="HACKHTMSTR" value="http://www.softcamp.co.kr/scsk">');
	//document.write('<param name="HACKMSGSTR" value="��ŷ�޽��� �����Դϴ�.">');
	document.write('</object>');
}
else if(os_ver.indexOf("Win64")>0)
{
	alert("32bit Internet Explorer�� ����Ͻʽÿ�.");
}
else if(os_ver.indexOf("NT 6")>0){
	document.write('<object classid="CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83" codebase="http://www.softcamp.co.kr/scsk/ini6_kjb_fsa_test/SCSK4_vista.cab#version=4,0,6031,8" width="0" height="0" id="secukey" >');
	document.write('<param name="USEICON" value="1">');
	document.write('<param name="OPTION" value="2">');
	document.write('<param name="TRAYSTR" value="ini6 test">');
	document.write('<param name="SiteCode" value="9232">');			//�̰������ؾ� Initech 6 �����
	document.write('<param name="INI7CustomCode" value="106">');		//�̰������ؾ� Initech 6 �����
	document.write('<param name="ExtE2EServerCert" value="'+SCert+'">');	//���༭�� ����Ű
	document.write('<param name="ExtE2EDoubleServerCert" value="'+SCert+'">');	//��ũŸ��� ����Ű
	document.write('<param name="EteExtBkColor" value="13434828">'); //rgb�� �������� ��ȯ�ؼ� �ѱ�� ��.
	//document.write('<param name="ETEOPTIONFLDS" value="input1;input2;input3;">'); //option
	////HACKOPTION
	//#define HACKOPTION_ALERT_NO		0x00000000		
	//#define HACKOPTION_ALERT_HTM		0x00000001		//HTM ��� ����Ʈ.
	//#define HACKOPTION_ALERT_MSG		0x00000002
	
	
	//#define HACKOPTION_USE_EXIT		0x00000010		//�����Ѵ�. (16)
	//#define HACKOPTION_ERR_OFF		0x00000100		//������ �ȳ����Ѵ�. (256)
	
	document.write('<param name="HACKOPTION" value="256">');
	//document.write('<param name="HACKHTMSTR" value="http://www.softcamp.co.kr/scsk">');
	//document.write('<param name="HACKMSGSTR" value="��ŷ�޽��� �����Դϴ�.">');
	document.write('</object>');	
}else{
	document.write('<object classid="CLSID:39FC0CF9-86F3-4502-B773-D16706EDEC83" codebase="http://www.softcamp.co.kr/scsk/ini6_kjb_fsa_test/scsk4.cab#version=4,0,31,8" width="0" height="0" id="secukey" >');
	document.write('<param name="USEICON" value="1">');
	document.write('<param name="OPTION" value="2">');
	document.write('<param name="TRAYSTR" value="ini6 test">');
	document.write('<param name="SiteCode" value="9232">');			//�̰������ؾ� Initech 6 �����
	document.write('<param name="INI7CustomCode" value="106">');		//�̰������ؾ� Initech 6 �����
	document.write('<param name="ExtE2EServerCert" value="'+SCert1+'">');	//���༭�� ����Ű
	document.write('<param name="ExtE2EThirdServerCert" value="'+SCert+'">');	//��ũŸ��� ����Ű
	document.write('<param name="EteExtBkColor" value="13434828">'); //rgb�� �������� ��ȯ�ؼ� �ѱ�� ��.
	document.write('<param name="ExtE2ERandomURL" value="'+E2ERandomURL+'">'); //rgb�� �������� ��ȯ�ؼ� �ѱ�� ��.

	//document.write('<param name="ETEOPTIONFLDS" value="input1;input2;input3;">'); //option
	////HACKOPTION
	//#define HACKOPTION_ALERT_NO		0x00000000		
	//#define HACKOPTION_ALERT_HTM		0x00000001		//HTM ��� ����Ʈ.
	//#define HACKOPTION_ALERT_MSG		0x00000002
	
	
	//#define HACKOPTION_USE_EXIT		0x00000010		//�����Ѵ�. (16)
	//#define HACKOPTION_ERR_OFF		0x00000100		//������ �ȳ����Ѵ�. (256)
	
	document.write('<param name="HACKOPTION" value="256">');
	//document.write('<param name="HACKHTMSTR" value="http://www.softcamp.co.kr/scsk">');
	//document.write('<param name="HACKMSGSTR" value="��ŷ�޽��� �����Դϴ�.">');
	document.write('</object>');
}



//document.write('<param name="ExtE2EServerCert" value="'+SCert+'">');	//�̰������ؾ� field �̸��� ������.

//************************************************************************************************
//������� 
//���������� inputelement name ���� �����ϹǷ�, ���� �������� ���� name �� ������ �ȵȴ�.

function SetExtE2EFields()
{
	secukey.SetExtE2EFields(document);
}

//input�� elememt�� ����ϱ�.
function SetSCSKEtEExtbyID(input,hidden)
{
	input.autocomplete='off'; //�ڵ��ϼ� ��� ����
	input.style.imeMode = "disabled";	//�ѱ��Է� ����.
	secukey.AddETEExtInput(document, input, hidden);
}

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

//htm ���ο� �ִ°��� ����.
//SetSCSKEtEExtbyName(document.forms[0], "account", "_ExtE2E123_account");

