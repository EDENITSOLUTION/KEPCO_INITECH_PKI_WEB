<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.String.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%!
public String getDateTime() {
	Locale locale = java.util.Locale.KOREA;
	SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale);
	String convertedTime = sdfr.format(new Date());
	return convertedTime;

}
%>
<%
String timeId = getDateTime() ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=11"/>
<title>인증서 복사하기</title>
<link rel="stylesheet" type="text/css" href="css/import.css" />
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" type="text/css" href="css/pcToMobile.css" />

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.flexslider-min.js"></script>
<script type="text/javascript" src="js/jquery.als-1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>

<script type="text/javascript" src="/initech/plugin/INIplugin.js"></script>
<script type="text/javascript" src="/initech/plugin/cert.js"></script>
<script type="text/javascript" src="/initech/plugin/install.js"></script>
<script type="text/javascript" src="/initech/plugin/INIutil.js"></script>
<script type="text/javascript" src="/initech/plugin/noframe.js"></script>
<script language="javascript">
    //프레임에서 스크립트 오류로 추가작업-20210209
   var INIplugin = window.parent.frames["secureframe"].INIplugin;
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
		var exportURL = "http://"+ window.location.host +"/initech/certcenter64/inica70/CertRelay/GetCertificate_v12.jsp";
		//alert("[" + exportURL + "]");
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
<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 
<body>

<div id="header">
	<!-- MAIN MENU START -->
	<script language="javascript">dspMainMenu();</script>
	<!-- MAIN MENU END -->
</div>

<div style="height:10px;"></div>
<div id="subtop">
	<ul class="subtoptxt">
		<li class="toptxtcon">인증서 복사하기</li>
	</ul>
</div>

<div id="subissue">
	<ul>
		<li><img src="img/copy_title.gif" alt="PC → 스마트기기 인증서 복사" /></li>
		<li class="stitle">&nbsp;</li>
		
		<li class="box" style="overflow:hidden; border:0;">

			<img src="img/copy_step.jpg" alt="PC → 스마트기기 인증서 복사 순서" />

			
		</li>
	</ul>
	<div class="copyWrap">
		<span class="copyBtn"><a href="javascript:;"  onclick="CertMgmt_CertRoamingPrc()">인증서 복사 (PC→스마트기기)</a></span>
	</div>
</div>



<div style="height:20px;"></div>
<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->

</body>
</html>
