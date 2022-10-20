<%@ page contentType="text/html;charset=EUC-KR" %><%@ 
page import="java.io.*,java.util.*,java.lang.*" %><%@ 
include file="import/iniplugin_init.jsp"  %><% 
m_How = m_IP.getParameter("how"); 
System.out.println("===============================");
System.out.println("m_How = " + m_How);
System.out.println("===============================");
%><%@
include file="import/inica70_init.jsp"    %><%@ 
include file="import/inica70_ca_send.jsp" %><%
if (m_IniErrCode == null) {
	String result_msg = m_orgCertString;
	//System.out.println("id :: " + m_IP.getParameter("id") + " & p10 :: " +  result_msg);
	out.println("result_code=success&userCert="+result_msg);
}else{
	out.println("result_code=" + m_IniErrCode);
}
%>
