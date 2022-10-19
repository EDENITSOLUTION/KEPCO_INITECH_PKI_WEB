<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certRevoke"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_userSet.jsp" %>
<%@ include file="import/inica70_ca_send.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
  <title>인증서 발급</title>
	<script type="text/javascript" src="/initech/plugin/INIplugin.js"></script>
	<script type="text/javascript" src="/initech/plugin/INIutil.js"></script>
	<script type="text/javascript">
	<!--
	function CheckSendForm() {
		var readForm = document.readForm;
		var sendForm = document.sendForm;
		if (EncForm2(readForm, sendForm)) {
			ViewMsg();
			sendForm.submit();
			return false;
		}
		return false;
	}
	function ViewMsg()	{
		var msg = "사용자 확인중 입니다. 잠시만 기다리십시요.";
		setMsg(msg, 0, 200);
		showMsg();
	}
	//-->
	</script>
 </head>
 <body onload="CheckSendForm();">
  <body>
 <form name="sendForm" method="post" action="./ini_certNew_checkid.jsp">
	<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm">
<input type="hidden" name="id" value="<%=m_ID%>" />
<input type="hidden" name="regno" value="<%=m_REGNO%>" />
<input type="hidden" name="C" value="<%=m_C%>" />
<input type="hidden" name="L" value="<%=m_L%>" />
<input type="hidden" name="O" value="<%=m_O%>" />
<input type="hidden" name="OU" value="<%=m_OU%>" />
<input type="hidden" name="CN" value="<%=m_CN%>" />
<input type="hidden" name="EMAIL" value="<%=m_MAIL%>" />
<input type="hidden" name="req" value="" />
<input type="hidden" name="keybits" value="2048" />
<input type="hidden" name="pw" value="<%=m_pw%>" />
<input type="hidden" name="sms" value="<%=m_sms%>" />
<input type="hidden" name="certpass" value="<%=m_IP.getParameter("certpass")%>" />
<input type="hidden" name="serialno" value="<%=m_certserial%>" />
<input type="hidden" name="tmid" value="<%=m_tmid%>" />
</form>  
 </body>
</html>