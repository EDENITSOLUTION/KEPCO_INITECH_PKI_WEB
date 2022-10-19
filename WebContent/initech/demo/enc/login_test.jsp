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
    //��ȣȭ
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
��
// ID/PWȮ���� �ʿ����.
��
%>
<html><head></head>
<body>
���������(�α׿�)�� �����Ͽ����ϴ�.<br>
�����Ͻ� �������� ��ġ�ϴ� ID�� �Ʒ��� �����ϴ�.<br>
ID = [<%=m_ID%>]

�����Ͻ� ����� �������� ������ �Ʒ��� �����ϴ�.<br>
IssuerDN =  [<%=m_IssuerDN%>]
SubjectDN =  [<%=m_SubjectDN%>]
Serial =  [<%=m_certSerial%>]

</body></html>
