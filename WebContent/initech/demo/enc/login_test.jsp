<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="com.initech.INIplugin.*,com.initech.IniRA.*" %>
<%
	INIplugin  m_IP  =  new INIplugin(request,response,"C:/WAS/initech/iniplugin/properties/IniPlugin.properties");
	String m_IssuerDN = null;
	String m_SubjectDN = null;
	String m_certSerial = null;
	String m_ID = null;
    //String m_PW = null;
    //m_ID = request.getParameter(id);
    //m_PW = request.getParameter(pw);
    //복호화
	try {
	    m_IP.init();
		X509Certificate userCert =
m_IP.getClientCertificate();
		IniLDAPutil LDAP = new IniLDAPutil();
		LDAP.setInfo("certLogon", m_IP);
		m_ID = LDAP.getID(userCert, "id");
		if (m_certID == null) {
			out.println("<br>ErrorCode 
= " + LDAP.getErrCode());
			out.println("<br>ErrorMessage 
= " + LDAP.getErrMsg());
			return;
		} else {
			m_IssuerDN = IniCERTutil.getIssuerDN(userCert);
			m_SubjectDN 
= IniCERTutil.getSubjectDN(userCert);
			m_certSerial = IniCERTutil.getSerial(userCert);
		}
	} catch (Exception e) {
		out.println("<br>ErrorCode = PLUGIN_999");
		out.println("<br>ErrorMessage = " + e.getMessage());
		return;
	}  
…
// ID/PW확인이 필요없다.
…
%>
<html><head></head>
<body>
사용자인증(로그온)에 성공하였습니다.<br>
제출하신 인증서와 일치하는 ID는 아래와 같습니다.<br>
ID = [<%=m_ID%>]

제출하신 사용자 인증서의 정보는 아래와 같습니다.<br>
IssuerDN =  [<%=m_IssuerDN%>]
SubjectDN =  [<%=m_SubjectDN%>]
Serial =  [<%=m_certSerial%>]

</body></html>
