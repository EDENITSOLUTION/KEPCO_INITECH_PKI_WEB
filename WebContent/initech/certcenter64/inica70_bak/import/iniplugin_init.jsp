<%--
//************************************************
//  IniPlugin128 JAVA SDK 사용예
//  사용법 : <%@ include file="/initech/import/iniplugin_init.jsp"
//************************************************
--%>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="com.initech.iniplugin.*" %>
<%
//2014.04.22 com.initech.IniRA.* 제거
//--@ page import="com.initech.IniRA.*" 

boolean is_smsChk = true;

String pwdSynURL = "http://mail.kepco.co.kr/Synk/Password.ashx";
String pwdSyncKey = "5ac1bb6d4172409089a7df3aa6ec91c2";
String pwdSyncDidx = "1";


boolean m_bDebug = true;
String m_How = null;

String m_IniErrCode = null;
String m_IniErrMsg = null;
IniPlugin m_IP = new IniPlugin(request, response, "/home/initech/iniplugin/properties/IniPlugin.inica70.properties");

//************************************************
//      Post Data 확인
//************************************************
String INIdata = request.getParameter("INIpluginData");
if (INIdata == null)
{
	m_IniErrCode = "iniPlugin_101";
	m_IniErrMsg = "Exception : INIpluginData is null";
	System.out.println(m_IniErrMsg);
	//IniDebug.request(request);
}

if (m_IniErrCode == null) 
{
	try {
		m_IP.init();
	} catch(PrivateKeyDecryptException e) {
		m_IniErrCode = "PLUGIN_001";
		m_IniErrMsg = "Exception : " + e.getMessage();

	} catch(CRLFileNotFoundException e) {
		m_IniErrCode = "PLUGIN_002";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(PropertyFileNotFoundException e) {
		m_IniErrCode = "PLUGIN_003";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(PrivateKeyFileNotFoundException e) {
		m_IniErrCode = "PLUGIN_004";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(CACertFileNotFoundException e) {
		m_IniErrCode = "PLUGIN_005";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(INIpluginDataAbnormalFormatException e) {
		m_IniErrCode = "PLUGIN_006";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(LongParseException e) {
		m_IniErrCode = "PLUGIN_007";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(PrivateKeyParseException e) {
		m_IniErrCode = "PLUGIN_008";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(CRLFileParseException e) {
		m_IniErrCode = "PLUGIN_009";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(CACertFileParseException e) {
		m_IniErrCode = "PLUGIN_010";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(ClientCertParseException e) {
		m_IniErrCode = "PLUGIN_011";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(AbnormalPropertyFileException e) {
		m_IniErrCode = "PLUGIN_012";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(PropertyNotFoundException e) {
		m_IniErrCode = "PLUGIN_013";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(VerifyDataDecryptException e) {
		m_IniErrCode = "PLUGIN_014";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(AbnormalVerifyDataException e) {
		m_IniErrCode = "PLUGIN_015";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(ExpiredVerifyDataException e) {
		m_IniErrCode = "PLUGIN_016";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(ClientCertValidityException e) {
		m_IniErrCode = "PLUGIN_017";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(SignatureVerifyException e) {
		m_IniErrCode = "PLUGIN_018";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(ClientCertRevokedException e) {
		m_IniErrCode = "PLUGIN_019";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(SessionKeyException e) {
		m_IniErrCode = "PLUGIN_020";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(EncryptDataException e) {
		m_IniErrCode = "PLUGIN_021";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(DecryptDataException e) {
		m_IniErrCode = "PLUGIN_022";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(CRLFileIOException e) {
		m_IniErrCode = "PLUGIN_023";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(PropertyFileIOException e) {
		m_IniErrCode = "PLUGIN_024";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(PrivateKeyFileIOException e) {
		m_IniErrCode = "PLUGIN_025";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(CACertFileIOException e) {
		m_IniErrCode = "PLUGIN_026";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(PropertyFileParseException e) {
		m_IniErrCode = "PLUGIN_027";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(VerifyFlagException e) {
		m_IniErrCode = "PLUGIN_028";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(IOException e) {
		m_IniErrCode = "PLUGIN_029";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(SignDataException e) {
		m_IniErrCode = "PLUGIN_030";
		m_IniErrMsg = "Exception : " + e.getMessage();
	} catch(Exception e) {
		m_IniErrCode = "PLUGIN_099";
		m_IniErrMsg = "Exception : " + e.getMessage();
		e.printStackTrace();
	}

	//if (m_IniErrCode != null) IniDebug.request(request);
}
%>
