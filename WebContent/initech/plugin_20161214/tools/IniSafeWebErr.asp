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
		msg = "INIpluginData�� �߸��Ǿ����ϴ�."			'sk, dt, vf �ʵ尡 ���� ���
	elseif code = 200 then
		msg = "����Ű ��ȣȭ����"
	elseif code = 202 then
		msg = "�������� �ʴ� �˰���"
	elseif code = 203 then
		msg = "dt ��ȣȭ����"
	elseif code = 300 then
		msg = "����� ������ ������ �����Ͽ����ϴ�."			'cc ����� ������ �ε� ����
	elseif code = "3xx" then
		msg = "����� ������ ������ �����Ͽ����ϴ�."			'����� ������ Ȯ�ν���
	elseif code = 400 then
		msg = "vd �ð��ʰ�"
	elseif code = 401 then
		msg = "vd ��ȣȭ ����"
	elseif code = 500 then
		msg = "sg Ȯ�� ����"
	else 
		msg = "����� �ٽ� ����Ͻñ� �ٶ��ϴ�"
	end if

%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
    <title>INITECH INIsafeWeb ����</title>
</head>
<style>
    body    { background : white; color : black; margin: 0 }
    body    { font-family: ����, Gulim, Arial, sans-serif; font-size: 9pt; line-height: 12pt }
    table   { font-family: ����, Gulim, Arial, sans-serif; font-size: 9pt; line-height: 12pt }
    
    div.Offscreen     { display:none }
    span.Offscreen    { display:none }
    span.BulletNumber { font-size: x-large; font-weight: bold; color: #66ccff }
    span.BulletText   { font-size: x-small; font-weight: bold; letter-spacing: -1pt; text-align:center}

</style>

<body LINK=#FF0000 VLINK=#4E4E4E">
<div style="position:relative; left:10px; top:10px; width:90%; height=+30px;" id=DivRule>
	<font style="font-size: 14pt; font-family: ����, Gulim, Arial, sans-serif; color: #4E4E4E;  line-height: 14pt" >
	INITECH IniSafeWeb ����: �Ʒ��� ���� ������ �߻��Ͽ����ϴ�.
	</font>
</div>

<div id=Out0 style="position:relative; left:20px; top:+15px; width:90%;" >
�����ڵ� : <%=code%>
<BR><BR>
�����޼��� : <%=msg%>
</div>
<BR><BR><BR>
</body>
</HTML>


