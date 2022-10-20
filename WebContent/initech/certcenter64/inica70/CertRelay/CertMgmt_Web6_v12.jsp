<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if(request.getProtocol().equals("HTTP/1.1")) {
	   response.setHeader("Cache-Control", "no-cache");
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>인증서 내보내기</TITLE>
<h1>인증서 이동 v1.2 WEB6</h1>

<script language="javascript" src="/initech/plugin64/INIplugin.js"></script>
<script src="/initech/plugin64/cert.js"></script>
<script src="/initech/plugin64/install.js"></script>
<script src="/initech/plugin/noframe.js"></script>

<script language="javascript">
	//var ClientVersion = "6,4,0,42";
	function CertMgmt_CertRoamingPrc()
	{
		// 인증서 보내기 클라이언트 ActiveX설치 여부 확인 
		/*if (typeof(CertClient) == "undefined") {
			alert("인증서 보내기 클라이언트를 설치 하십시오.");
			return;
		}*/
		
		/**
		 * 인증서 제출창 상단의 배너 이미지
		 * 여기에 사용될 이미지는 기존 이니텍 INISAFE Web 제품을 사용하는 곳이라면,
		 * 이미 사용하고 있는 이미지 URL을 넣어주면 되나,
		 * 아니라면 해당 이미지를 작성 후, 이니텍에 전달해서 전자서명을 받아서 사용해야 한다.
		 * 이니텍에서 전자서명 받은 이미지가 아니면 상단에 이미지가 보여지지 않는다.
		 */
		
		/**
		 * 인증서 이동 프로토콜 버전 설정
		 */
		INIplugin.SetProperty("UseCertMode","1");				
		INIplugin.LoadCert(SCert);			
		//인증서 복사 적용 버전
		INIplugin.ICCSetOption("SetProtocolVersion","1.2");  	
		//구간암호화 여부
//		INIplugin.ICCSetOption("MakePluginData","TRUE");
		INIplugin.ICCSetOption("MakePluginData","FALSE");
		INIplugin.ICCSetOption("TimeURL", TimeURL);
		//인증서 제출창 이미지 경로(서명된 인증서야 함)
		INIplugin.ICCSetOption("SetLogoPath", LogoURL);

		/**
		 * 인증번호 자리 입력수. 스마트폰에서 설정한 자릿수와 일치하여야 한다.
		 */
		INIplugin.ICCSetOption("SetAuthenticationNumber","8");
		

		/**
		 * 주민등록번호 입력을 사용할것인지의 여부. (기본값:"TRUE")
		 * ("FALSE"로 지정하게 되면 인증서 가져오기 1.1 버전으로 동작한다.)
		 */
		INIplugin.ICCSetOption("SetUseIdentify","FALSE");

		/**
		 * 내보내기할 인증서의 비밀번호를 재설정할것인지의 여부.(기본값:"TRUE")
		 * (즉 스마트폰에 저장될 인증서 암호결정)
		 * "FALSE"로 지정하면 재설정하지 않고 바로 전송되며 지정하지 않을 시
		 * 사용자에게 재설정 여부를 알린다.
		 */
		INIplugin.ICCSetOption("SetUseCertPwd","FALSE");

		/**
		 * GPKI 인증서 출력 여부
		 */
		INIplugin.ICCSetOption("Setproperty","certmanui_gpki&all");

		/**
		 * 인증서 내보내기 처리 시작
		 */
		INIplugin.ICCSendCert( GetExportURL() );
	}

	function GetExportURL() 
	{
		var currURL = location.href;
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificateWeb6_v12.jsp";
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificate_v12.jsp";
		var exportURL = "/initech/certcenter64/inica70/CertRelay/GetCertificate_v12.jsp";
		//alert("exportURL [" + exportURL + "]");
		return exportURL;
	}

	function GetImportURL() 
	{
		var currURL = location.href;
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificateWeb6_v12.jsp";
//		var exportURL = currURL.substring(0, currURL.lastIndexOf("/")) + "/GetCertificate_v12.jsp";
		var exportURL = "/initech/certcenter64/inica70/CertRelay/GetCertificate_v12.jsp";
		
		return exportURL;
	}

	function CertMgmt_ImportCert() 
	{
		// 인증서 보내기 클라이언트 ActiveX설치 여부 확인 
		/*if (typeof(CertClient) == "undefined") {
			alert("인증서 보내기 클라이언트를 설치 하십시오.");
			return;
		}*/
		
		/**
		 * 인증서 제출창 상단의 배너 이미지
		 * 여기에 사용될 이미지는 기존 이니텍 INISAFE Web 제품을 사용하는 곳이라면,
		 * 이미 사용하고 있는 이미지 URL을 넣어주면 되나,
		 * 아니라면 해당 이미지를 작성 후, 이니텍에 전달해서 전자서명을 받아서 사용해야 한다.
		 * 이니텍에서 전자서명 받은 이미지가 아니면 상단에 이미지가 보여지지 않는다.
		 */
	
		INIplugin.SetProperty("UseCertMode","1");				
		INIplugin.LoadCert(SCert);		

//		INIplugin.ICCSetOption("MakePluginData","TRUE");
		INIplugin.ICCSetOption("MakePluginData","FALSE");
		INIplugin.ICCSetOption("TimeURL", TimeURL);
		INIplugin.ICCSetOption("SetLogoPath", LogoURL);
		/**
		 * 인증서 이동 프로토콜 버전 설정
		 */
		INIplugin.ICCSetOption("SetProtocolVersion", "1.2");

		/**
		 * 인증번호 자리 입력수. 스마트폰에서 설정한 자릿수와 일치하여야 한다.
		 */
		INIplugin.ICCSetOption("SetAuthenticationNumber","8");

		/**
		 * 주민등록번호 입력을 사용할것인지의 여부. (기본값:"TRUE")
		 * ("FALSE"로 지정하게 되면 인증서 가져오기 1.1 버전으로 동작한다.)
		 */
		INIplugin.ICCSetOption("SetUseIdentify","FALSE");

		/**
		 * 내보내기할 인증서의 비밀번호를 재설정할것인지의 여부.(기본값:"TRUE")
		 * (즉 스마트폰에 저장될 인증서 암호결정)
		 * "FALSE"로 지정하면 재설정하지 않고 바로 전송되며 지정하지 않을 시
		 * 사용자에게 재설정 여부를 알린다.
		 */
		INIplugin.ICCSetOption("SetUseCertPwd","FALSE");
		/**
		 * 인증서 내보내기 처리 시작
		 */
		INIplugin.ICCRecvCert( GetImportURL() );

	}
</script>
</HEAD>

<BODY>
<!-- script language="javascript">
	CertMgmt_ClientInstall();
</script -->

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<input type=button value="인증서 내보내기" onClick="CertMgmt_CertRoamingPrc()">
<input type=button value="인증서 가져오기" onClick="CertMgmt_ImportCert()">
<br>
<br>
<br>
<!--a href="INISAFECertClientv1.exe">내보내기 프로그램 수동 다운로드</a -->
</BODY>
</HTML>