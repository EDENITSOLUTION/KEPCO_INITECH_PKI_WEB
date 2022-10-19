<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*,java.net.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%
//String syncID = m_IP.getParameter("id");
//String syncPWD = m_IP.getParameter("pw");
//String syncKey = m_IP.getParameter("syncKey");
String syncID = request.getParameter("id");
String syncIncPwd = request.getParameter("pw");
String syncPWD =  java.net.URLDecoder.decode(syncIncPwd, "EUC_KR");
String syncKey = request.getParameter("syncKey");
String syncEncPWD = getBase64Data(getHashValue(syncPWD));

String result_code = "1" ; //성공 1, 실패 0

if (syncID == null || syncID.equals("")) {
	result_code = "0";
}
if (syncPWD == null || syncPWD.equals("")) {
	result_code = "0";
}
if (syncKey == null || syncKey.equals("")) {
	result_code = "0";
}
if (syncKey.equals(pwdSyncKey)) {
	result_code = "1";
}else{
	result_code = "0";
}

if (result_code.equals("0")) { 
	out.println("result_code=0");
} else {
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>인증센터 이용안내</title>
</head>
<body>
<!-- String syncID = <%=syncID%><br>
String syncIncPwd = <%=syncIncPwd%><br>
String syncPWD = <%=syncPWD%><br>
String syncKey = <%=syncKey%><br>
String syncEncPWD = <%=syncEncPWD%><br>
 -->


<iframe name="hdnFrame" id="hdnFrame" src="<%=pwdSynURL%>?key=<%=pwdSyncKey%>&didx=<%=pwdSyncDidx%>&usb=<%=syncID%>&pwd=<%=syncEncPWD%>" width="200" height="200" style="display:none" scrolling="no" frameborder="0"></iframe>
</body>
</html>
<%
}
%>
<%!
public byte[] getHashValue(String inputString)     {
	MessageDigest md = null;
	
	try {
		md = MessageDigest.getInstance("MD5");
		
		md.update(inputString.getBytes());
		
	} catch (NoSuchAlgorithmException e) {
		// TODO 자동 생성된 catch 블록
		e.printStackTrace();
	}
	
	return md.digest(); 
}

public String getBase64Data(byte[] inputByte) throws IOException
{
	String returnString = "";
	returnString = new String(com.initech.util.Base64Util.encode(inputByte, false));

	return returnString;
}

%>