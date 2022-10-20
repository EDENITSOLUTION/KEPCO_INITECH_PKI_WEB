<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.*"%>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import="java.lang.String.*" %>
<%@ include file="import/iniplugin_init.jsp" %>

<%
//************************************************
//      변수 선언 및 입력정보 복호화
//************************************************
	
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");

String admUID = "kepcoca";
String admPWD = "kepcoca!@##";
String userIP = request.getRemoteAddr();

String isManagerIpCheck = "Y"; //관리자 IP체크유무(Y:체크함,N:체크안함)
String isAcsOK = "Y"; //관리자IP접근가능유무(Y:접근가능함,N:접근불가)

String acsIPs[] = {"10.200.107.127","10.200.107.150","10.200.107.135","10.180.5.74","10.180.5.75","10.180.5.76","10.200.107.185","10.200.107.148","10.200.107.189","168.78.245.31","10.200.107.141"};
// 10.200.107.127  최태욱
// 10.200.107.150  백순웅
// 10.200.107.135  김현이
// 10.180.5.74-76  유지보수(KDN)
// 10.200.107.185  전대산
// 10.200.107.148  김진구
// 10.200.107.189  강성간
// 168.78.245.31   운영서버

String acsErrMsg = "";

if (isManagerIpCheck.equals("N")){ //관리자IP체크하지않는다면
	isAcsOK = "Y"; //관리자접근은 무조건 가능하게
	acsErrMsg = "관리자 로그인 ID 및 비밀번호가 일치하지 않습니다.";
}else{
	acsErrMsg = "관리자 ID 또는 비밀번호가 일치하지 않거나 접근 불가한 IP에서 접속하셨습니다.";
	int j = 0;
	for (int i=0;i<acsIPs.length;i++){ 
		if (acsIPs[i].equals(userIP)){
			j++;
		}
	}
	if (j == 0){
		isAcsOK = "N";
	}else{
		isAcsOK = "Y";
	}
}

String m_userID = m_IP.getParameter("id");
String m_userPWD = m_IP.getParameter("pw");


if (m_userID == null || m_userID.equals("") || m_userPWD == null || m_userPWD.equals("")  ) {
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('사용자 ID 또는 비밀번호가 입력되지 않았습니다.');");
		writer.println("location.href='ini_manage_cert_login.jsp'");
		writer.println("</script>");
		writer.flush();
		return;
}
if (m_userID.equals(admUID) && m_userPWD.equals(admPWD) && isAcsOK.equals("Y") ) {
	session.setAttribute("adminLogin",m_userID);
	session.setMaxInactiveInterval(1000);
	response.sendRedirect("ini_manage_cert.jsp");

%>
<!--DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>관리자 로그인</title>
<script type="text/javascript" src="/initech/plugin/INIplugin.js"></script>
<script type="text/javascript" src="/initech/plugin/INIutil.js"></script>
<script language="javascript">
function CheckSendForm() {

	var readForm = document.readForm;
	var sendForm = document.sendForm;
	
	if (EncForm2(readForm, sendForm))
	{
		sendForm.submit();
		return false;
	}
	return false;
}

</script>
</head>
<body>
<form name="sendForm" method="post" action="ini_manage_cert.jsp">
<input type="hidden" name="INIpluginData" value="" />
</form>
<form name="readForm">
</form>
</body>
</html-->
<%

}else {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('"+ acsErrMsg +"');");
	writer.println("location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}

%>
