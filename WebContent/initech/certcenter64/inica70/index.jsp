<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta name="author" content="" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta name="robots" content="all" />
<title>한국전력공사 통합인증센터</title>
	<link rel="stylesheet" type="text/css" href="css/import.css" />
	<link rel="stylesheet" type="text/css" href="css/main.css" />

	<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="js/jquery.flexslider-min.js"></script>
    <script type="text/javascript" src="js/jquery.als-1.1.min.js"></script>
	<script type="text/javascript" src="js/common.js"></script>

	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script language="javascript" src="/initech/plugin/INIutil.js"></script>

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
<div id="maincenter">
	<div class="mainvisual">
		<ul class="in01">
			<li class="in01" style="font-weight:bold;color:#666666;">인증서 발급</li>
			<li class="in0102"><a href="ini_certNew.jsp">처음 인증서 발급시</a></li>
			<li class="in0102"><a href="ini_certNew.jsp">유효기간이 만료되어 갱신시</a></li>
			<li class="in0102"><a href="ini_certNew.jsp">인증서 재발급시</a></li>
			<!-- <li class="in01">인증서 발급</li>
			<li class="in0102"><a href="sub01_01.html">처음 인증서 발급시</a></li>
			<li class="in0102"><a href="sub01_01.html">유효기간이 만료되어 갱신시</a></li>
			<li class="in0102"><a href="sub01_01.html">인증서 재발급시</a></li> -->
		</ul>
		<ul class="in02">
			<li class="in01" style="font-weight:bold;color:#666666;">인증서 폐기</li>
			<li class="in0102"><a href="ini_certRevoke.jsp">장기간 이용하지 않을 경우</a></li>
			<li class="in0102"><a href="ini_certRevoke.jsp">인증서를 폐기하고자 할때</a></li>
			<!-- <li class="in01">인증서 폐기</li>
			<li class="in0102"><a href="sub01_02.html">장기간 이용하지 않을 경우</a></li>
			<li class="in0102"><a href="sub01_02.html">인증서를 폐기하고자 할때</a></li> -->
		</ul>
		<ul class="in03">
			<li class="in01" style="font-weight:bold;color:#666666;">인증서 관리</li>
			<li class="in0102"><a href="ini_myCert_info.jsp">발급받은 인증서를 조회합니다</a></li>
			<li class="in0102"><a href="#" onclick="ManageCert();">출장이나 다른 PC에서 사용하고자 할때</a></li>
			<li class="in0102"><a href="#" onclick="ManageCert();">인증서를 복사 또는 백업하고자 할때</a></li>
			<!-- <li class="in01">인증서 관리</li>
			<li class="in0102"><a href="sub01_03.html">출장이나 다른 PC에서 사용하고자 할때</a></li>
			<li class="in0102"><a href="sub01_03.html">인증서를 조회하고자 할때</a></li>
			<li class="in0102"><a href="sub01_03.html">인증서를 복사 또는 백업하고자 할때</a></li> -->
		</ul>
	</div>
</div>

<!-- MAIN COPYRIGHT START -->
<script language="javascript">dspMainCopyRight();</script>
<!-- MAIN COPYRIGHT END -->

</body>
</html>
