  

	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
	<title>SMS 인증하기</title>
	</head>
	<!-- <body> -->
	<body onload="document.hdnForm.target='hdnFrame';document.hdnForm.submit();">
	<iframe name="hdnFrame" id="hdnFrame" src="_balnk" width="0" height="0" style="display:none" scrolling="no" frameborder="0"></iframe>
	<form name="hdnForm" id="hdnForm" method="post" action="<%=pwdSynURL%>">
	<input type="hidden" name="key" id="key" value="<%=pwdSyncKey%>" />
	<input type="hidden" name="didx" id="didx" value="<%=pwdSyncDidx%>" />
	<input type="hidden" name="usb" id="usb" value="<%=m_ID%>" />
	<input type="hidden" name="pwd" id="pwd" value="<%=getBase64Data(getHashValue(m_pw))%>" />
	</form>
	<%=m_OU%><br>
	<%=m_How%><br>
	<%=m_ID%><br>
	<%=isUserCnt%><br>
	<%=isUserCertCnt%><br>
	<%=certUserNm%><br>
	id : <%=m_IP.getParameter("id")%><br>
	pw : <%=m_IP.getParameter("pw")%> // <%=getBase64Data(getHashValue(m_IP.getParameter("pw")))%><br>
	</body>
	</html>