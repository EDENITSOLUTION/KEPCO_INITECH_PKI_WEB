<%
dim code
code = request("code")
'code = "1" timestamp가 없다.
'code = "2" timestamp expire

%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
    <title>INITECH INIsafeWeb 보안경고</title>
</head>
<style>
    body    { background : white; color : black; margin: 0 }
    body    { font-family: 굴림, Gulim, Arial, sans-serif; font-size: 9pt; line-height: 12pt }
    table   { font-family: 굴림, Gulim, Arial, sans-serif; font-size: 9pt; line-height: 12pt }
    
    div.Offscreen     { display:none }
    span.Offscreen    { display:none }
    span.BulletNumber { font-size: x-large; font-weight: bold; color: #66ccff }
    span.BulletText   { font-size: x-small; font-weight: bold; letter-spacing: -1pt; text-align:center}

</style>

<body LINK=#FF0000 VLINK=#4E4E4E">
<div style="position:relative; left:10px; top:10px; width:90%; height=+30px;" id=DivRule>
	<font style="font-size: 14pt; font-family: 굴림, Gulim, Arial, sans-serif; color: #4E4E4E;  line-height: 14pt" >
	INITECH IniSafeWeb Plugin 보안경고: 만료된 페이지입니다.
	</font>
</div>

<div id=Out0 style="position:relative; left:20px; top:+15px; width:90%;" >
사용자가 요청한 페이지는 폼으로 보낸 정보를 사용하여 만들어진 페이지입니다. 이 페이지는 더 이상 사용할 수 없습니다. 보안을 위해서 사용자가 새로고침으로 재전송된 페이지는 허용항지 않습니다.
<BR><BR>
사용자 개인 정보를 재전송하고 이 페이지를 보려면 <b><a href="javascript:history.back()">여기</a></b> 단추를 클릭하십시오.
</div>
<BR><BR><BR>
</body>
</HTML>


