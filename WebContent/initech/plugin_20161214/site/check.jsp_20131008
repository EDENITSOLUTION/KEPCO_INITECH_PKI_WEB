<%-- 2002/05/16 INIplugn 설치페이지 출력여부 확인
 	파일명 :	check.jsp 
	사용법(호출방법)
		url		: 설치확인후 다음페이지 경로(절대경로로 입력?)
				default : /initech/plugin/start_pub.html
		check : 설치화면출력여부(내부적으로 사용함) 
				default : no(화면출력안함)
				
	사용예..
        check.jsp?url=/initech/demo/start.html
        check.jsp?url=/initech/demo/start.html&check=yes
--%>

<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%
	response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "0");

	String check = request.getParameter("check");
	String url = request.getParameter("url");
	if ( (url == null) || (url.equals(""))) url = "/initech/plugin/start.html";
%>

<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title> INIplugin-128 Install Check Page</title>
<style type="text/css">
<!--
.text {  font-family: "돋움"; font-size: 12px; text-decoration: none; color: #FFFFFF}
-->
</style>
<script language=javascript src="/initech/plugin/INIplugin.js"></script>
<script language=javascript src="/initech/plugin/install.js"></script>
<script language="JavaScript">
var startURL = "<%=url%>";
var installURL = "./check.jsp?check=yes&url=" + startURL;
var UpradeCheck = true;

function Check() 
{
	var findframe = FindSecureFrame(parent);
	if (findframe == null) {
		alert("암호화 프레임(secureframe)을 찾을수 없습니다.");
	}
	else if( ModuleInstallCheck() != null && findframe.bINIinstall)	{
        	window.location = startURL;
	} 
	else {
    	setTimeout("Check()", 500);
	}
}

function setupPlugin()
{
	top.location = manualInstallURL;
}
</script>
</head>


<%  // 설치여부를 확인 : 설치가된상태이면 다음화면으로 출력함... 변경하지 말것...
	if ( (check == null) || (!check.equals("yes"))) { 
%>
<body>
<script language="JavaScript">
	var url = startURL;

	//소프트로럼.... OBject//
	//document.writeln('<OBJECT ID="XecureWeb" CLASSID="CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404"><COMMENT><EMBED type="application/x-SoftForum-XecSSL40" hidden=true name="XecureWeb"><NOEMBED></COMMENT>No XecureWeb 4.0 PlugIn</NOEMBED></EMBED></OBJECT>');

	document.writeln('<OBJECT ID="INIplugin_check" CLASSID="CLSID:6AD92401-CE2D-452B-AA63-1291D60EC2D2" width=1 height=1><COMMENT><EMBED type="application/x-INIplugin128v40" hidden="true" name="INIplugin_check"><NOEMBED></COMMENT>No IniPlugin V4</NOEMBED></EMBED></OBJECT>');

if (navigator.appName == 'Netscape') 
{
	if( (typeof(this.document.INIplugin_check) == "undefined") || (this.document.INIplugin_check==null) ) {
		//alert("not Install");
		url = installURL;
	} else if (UpradeCheck == true) {
		var thisArray = this.INIplugin_check.document.GetVersion().split(',');
	    var inputArray = ieVersion.split(',');
	    //var inputArray = "5,1,15,0".split(',');
		for (i=0; i<4; i++)
		{
			if (parseInt(thisArray[i], 10) > parseInt(inputArray[i], 10)) {
				break;
			} else if (parseInt(thisArray[i], 10) < parseInt(inputArray[i], 10)) {
				url = installURL;
				break;
			}
		}
	}
} 
else 
{
	if( (typeof(this.document.INIplugin_check) == "undefined") || (this.document.INIplugin_check==null) || (this.document.INIplugin_check.object==null) ) {
	//if( (typeof(this.document.INIplugin_check) == "undefined") || (this.document.INIplugin_check==null) ) {
		//alert("not Install");
		url = installURL;
	} else if (UpradeCheck == true) {
		var thisArray = this.INIplugin_check.GetVersion().split(',');
	    var inputArray = ieVersion.split(',');
	    //var inputArray = "5,1,15,0".split(',');
		for (i=0; i<4; i++)
		{
			if (parseInt(thisArray[i], 10) > parseInt(inputArray[i], 10)) {
				break;
			} else if (parseInt(thisArray[i], 10) < parseInt(inputArray[i], 10)) {
				url = installURL;
				break;
			}
		}
	}
}
//	alert(url);
//   	window.location = startURL;
	location.replace(url);
</script> 
</body>
</html>

<%  //설치가되어 있지 않거나 Upgrade시 화면 출력.. 디자인변경은 아래내용만 할것...
	} else {
%>

<body onload="Check();" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" link="#00FF99" vlink="#00FF99" alink="#00FF99">
<div align="center">
  <p>&nbsp;</p><p>&nbsp;</p>
  <table width="423" border="0" cellspacing="0" cellpadding="0" height="348">
    <tr> 
      <td background="/initech/plugin/img/plugin_bg.gif" valign="top" align="right">
        <table width="418" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td height="38"><img src="/initech/plugin/img/plugin.gif" width="408" height="15"></td>
          </tr>
          <tr> 
            <td height="239" valign="top" class="text"> 
              <center>
                <b><font color="#00FF99"><br>
                **고객 컴퓨터의 암호화 프로그램 확인중입니다.**</font></b><br>
                <font color="#00FF99">(잠시만 기다려주시기 바랍니다) <br>
                <br>
                </font> 
              </center>
              <div align="left">
                <table width="410" border="0" cellspacing="0" cellpadding="10">
                  <tr> 
                    <td  class="text"> 처음 접속하신 경우에는 설치를 위햐여 약 10초에서 수분이 소요 되며 
                      기존 사용자는 암호화 프로그램 로딩을 위하여 5초정도 소요 됩니다.<br>
                      <br>
                      암호화 프로그램의 설치여부를 묻는<font color="#FFFF00"> <b><font color="#00FF99">''보안경고''</font></b></font>창이 
                      나타나면 반드시<font color="#FFFF00"><b><font color="#00FF99">''예''</font></b></font>를 
                      선택하여 주십시요. 취소를 선택 하신 경우는 <a href="javascript:top.secureframe.document.location.reload()">새로고침</a> 
                      을 하여 다시 설치 하시기 바랍니다.<br>
                      이는 안전한 통신 방법을 제공하기 위해 필요한 소프트웨어를 설치하는 절차이며 '아니오'를 선택하시는 
                      경우는 다음 절차로 넘어갈수 없습니다.<br>
                      <br>
                      오류발생시 또는 화면이 장시간 정지시 <font color="#FFFF00"><a href="javascript:setupPlugin();"><b><font color="#00FF99">암호화 
                      프로그램 설치안내</font></b></a></font><font color="#00FF99"><b>''</b></font>를 참고하여 조치후 이용하시기 바랍니다. </td>
                  </tr>
                </table>
              </div>
            </td>
          </tr>
          <tr> 
            <td height="65" align="center" class="text"><font color="#000000">장애시 
              문의 : 고객센터<a href=mailto:support@initech.com  class="text"><font color="#3366FF"> 
              support@initech.com</font></a></font></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  
</div>
</body>
</html>
<%  //디자인 변경은 요기까지임..
	}
%>

