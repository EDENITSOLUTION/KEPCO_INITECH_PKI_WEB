<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ include file ="../include/Init.jsp"%>
<html>
<head> 
	<title>��ȣȭ ��ũ��Ʈ ��뿹��</title>
	<meta http-equiv="Content-Type" Pragma="no-cache" Cache-control="no-cache" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
	<script>
	function CheckSendForm(readForm, sendForm)
	{
		if (EncForm2(readForm, sendForm)) {
			sendForm.submit();
			return false;
		} else {
			alert("���Ȼ� ������ ���� ������ ��� �Ǿ����ϴ�.");
		}
		return false; //�ݵ�� false�� return;
	}

	
	</script>
</head>

<body>

<br><h3>������ ��ȣȭ</h3>
<% out = m_IP.startEncrypt(out); %>
<form name=form1 action="./pageEncCheck.jsp" method=POST onsubmit="return EncForm(this);">
	<b>POST ����� 1���� form ���� �̿��� ��ȣȭ(EncForm) ����</b><br>
    <input type=hidden name=INIpluginData>
    A:<input type=text name=A value="AAAAAAA">
    B:<input type=text name=B value="BBBBBBB"><br>
    C:<input type=text name=C value="�Է��ѱ�">&nbsp;&nbsp;&nbsp

	<input type="checkbox" name="check" checked>CheckBox 

<select name="selectType">
    <option value="blue">blue</option>
    <option value="red">red</option>
    <option value="">black</option>
  </select>

	<input type=submit value="��ȣȭ ����">
</form>
<% out = m_IP.endEncrypt(out); %>

<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>

</html>
