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
//      ���� ���� �� �Է����� ��ȣȭ
//************************************************
	
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");

String admUID = "kepcoca";
String admPWD = "kepcoca!@##";
String userIP = request.getRemoteAddr();

String isManagerIpCheck = "Y"; //������ IPüũ����(Y:üũ��,N:üũ����)
String isAcsOK = "Y"; //������IP���ٰ�������(Y:���ٰ�����,N:���ٺҰ�)

String acsIPs[] = {"10.200.107.127","10.200.107.150","10.200.107.135","10.180.5.74","10.180.5.75","10.180.5.76","10.200.107.185","10.200.107.148","10.200.107.189","168.78.245.31","10.200.107.141"};
// 10.200.107.127  ���¿�
// 10.200.107.150  �����
// 10.200.107.135  ������
// 10.180.5.74-76  ��������(KDN)
// 10.200.107.185  �����
// 10.200.107.148  ������
// 10.200.107.189  ������
// 168.78.245.31   �����

String acsErrMsg = "";

if (isManagerIpCheck.equals("N")){ //������IPüũ�����ʴ´ٸ�
	isAcsOK = "Y"; //������������ ������ �����ϰ�
	acsErrMsg = "������ �α��� ID �� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.";
}else{
	acsErrMsg = "������ ID �Ǵ� ��й�ȣ�� ��ġ���� �ʰų� ���� �Ұ��� IP���� �����ϼ̽��ϴ�.";
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
		writer.println("alert('����� ID �Ǵ� ��й�ȣ�� �Էµ��� �ʾҽ��ϴ�.');");
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
<title>������ �α���</title>
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
