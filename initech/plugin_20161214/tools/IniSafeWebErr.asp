<%
	Dim code
	Dim msg
	code = Request("code")

	if code = 3 then
		msg = "ERR_NOT_FOUND_INITS"
	elseif code = 4 then
		msg = "ERR_EXPIRE_INITS"
	elseif code = 5 then
		msg = "ERR_FOUND_RESERVED_FIELD"
	elseif code = 101 then
		msg = "INIpluginData가 잘못되었습니다."			'sk, dt, vf 필드가 없을 경우
	elseif code = 200 then
		msg = "세션키 복호화에러"
	elseif code = 202 then
		msg = "지원하지 않는 알고리즘"
	elseif code = 203 then
		msg = "dt 복호화실패"
	elseif code = 300 then
		msg = "사용자 인증서 검증에 실패하였습니다."			'cc 사용자 인증서 로드 실패
	elseif code = "3xx" then
		msg = "사용자 인증서 검증에 실패하였습니다."			'사용자 인증서 확인실패
	elseif code = 400 then
		msg = "vd 시간초과"
	elseif code = 401 then
		msg = "vd 복호화 실패"
	elseif code = 500 then
		msg = "sg 확인 실패"
	else 
		msg = "잠시후 다시 사용하시기 바랍니다"
	end if

%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
    <title>INITECH INIsafeWeb 에러</title>
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
	INITECH IniSafeWeb 에러: 아래와 같은 오류가 발생하였습니다.
	</font>
</div>

<div id=Out0 style="position:relative; left:20px; top:+15px; width:90%;" >
에러코드 : <%=code%>
<BR><BR>
에러메세지 : <%=msg%>
</div>
<BR><BR><BR>
</body>
</HTML>


