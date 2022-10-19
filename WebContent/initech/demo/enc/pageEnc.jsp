<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ include file ="../include/Init.jsp"%>
<html>
<head> 
	<title>암호화 스크립트 사용예제</title>
	<meta http-equiv="Content-Type" Pragma="no-cache" Cache-control="no-cache" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script>
	function CheckSendForm(readForm, sendForm)
	{
		if (EncForm2(readForm, sendForm)) {
			sendForm.submit();
			return false;
		} else {
			alert("보안상 문제가 생겨 전송이 취소 되었습니다.");
		}
		return false; //반드시 false를 return;
	}

	
	</script>
</head>

<body>

<br><h3>페이지 암호화</h3>
<% out = m_IP.startEncrypt(out); %>
<form name=form1 action="./pageEncCheck.jsp" method=POST onsubmit="return EncForm(this);">
	<b>POST 방식의 1개의 form 문을 이용한 암호화(EncForm) 예제</b><br>
    <input type=hidden name=INIpluginData>
    A:<input type=text name=A value="AAAAAAA">
    B:<input type=text name=B value="BBBBBBB"><br>
    C:<input type=text name=C value="입력한글">&nbsp;&nbsp;&nbsp

	<input type="checkbox" name="check" checked>CheckBox 

<select name="selectType">
    <option value="blue">blue</option>
    <option value="red">red</option>
    <option value="">black</option>
  </select>

	<input type=submit value="암호화 전송">
</form>
<% out = m_IP.endEncrypt(out); %>

<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

</html>
