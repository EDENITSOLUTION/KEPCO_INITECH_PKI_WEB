/*
 * JSP generated by Resin Professional 4.0.38 (built Tue, 17 Dec 2013 09:49:45 PST)
 */

package _jsp._certcenter64._inica70;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.lang.*;
import java.security.cert.X509Certificate;
import com.initech.iniplugin.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

public class _ini_0certNew_0checkid__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  private boolean _caucho_isNotModified;
  private com.caucho.jsp.PageManager _jsp_pageManager;


      public static String lpad(String str, int len, String addStr) {
           String result = str;
           if (result == null) return result;
           int templen   = len - result.length();

          for (int i = 0; i < templen; i++){
                 result = addStr + result;
           }
           
           return result;
       }

  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    com.caucho.jsp.PageContextImpl pageContext = _jsp_pageManager.allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);

    TagState _jsp_state = null;

    try {
      _jspService(request, response, pageContext, _jsp_application, session, _jsp_state);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_pageManager.freePageContext(pageContext);
    }
  }
  
  private void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response,
              com.caucho.jsp.PageContextImpl pageContext,
              javax.servlet.ServletContext application,
              javax.servlet.http.HttpSession session,
              TagState _jsp_state)
    throws Throwable
  {
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    javax.servlet.jsp.tagext.JspTag _jsp_parent_tag = null;
    com.caucho.jsp.PageContextImpl _jsp_parentContext = pageContext;
    response.setContentType("text/html;charset=EUC-KR");

    out.write(_jsp_string0, 0, _jsp_string0.length);
    
//2014.04.22 com.initech.IniRA.* \uc81c\uac70
//--@ page import="com.initech.IniRA.*" 


boolean m_bDebug = true;
String m_How = null;

String m_IniErrCode = null;
String m_IniErrMsg = null;
IniPlugin m_IP = new IniPlugin(request, response, "/home/initech/iniplugin/properties/IniPlugin.inica70.properties");

//************************************************
//      Post Data \ud655\uc778
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
	try
	{
		m_IP.init();
	}
	catch (Exception e)
	{
		m_IniErrCode = "iniPlugin_099";
		m_IniErrMsg = "Exception : " + e.getMessage();
	}

	//if (m_IniErrCode != null) IniDebug.request(request);
}

    out.write(_jsp_string1, 0, _jsp_string1.length);
     m_How = "certNew"; 
    out.write(_jsp_string1, 0, _jsp_string1.length);
    
//************************************************
//      \ubcc0\uc218 \uc120\uc5b8 \ubc0f \uc785\ub825\uc815\ubcf4 \ubcf5\ud638\ud654
//************************************************
	
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");



//2014.04.22 \ub77c\uc774\uc13c\uc2a4\uacbd\ub85c \uc81c\uac70
//String licensePath = "/home/initech/iniplugin/license/IniRA_v6_sdk.lic";
//IniRAutil m_RA = new IniRAutil( licensePath );




//\uc554\ud638\ud654\uc5ec\ubd80 : \ub9ac\uc5bc\uc801\uc6a9\uc2dc \ubc18\ub4dc\uc2dctrue\ub85c \ubcc0\uacbd\ud574\uc57c\ud568..
boolean m_bEncrypt = false;

//\uc0ac\uc6a9\uc790 \uc2e0\ubd84\ud655\uc778 \uc815\ubcf4
String m_ID = null;		// form name = id
String m_REGNO = null;	// form name = regno

// \uc870\ud68c \uc815\ubcf4 (\uc694\uccad)
String m_SEARCHCODE = null;		// form name = searchcode
String m_SEARCHCONTENTS = null;	// form name = searchcontents

// \uc870\ud68c \uc815\ubcf4 (\uc751\ub2f5)
String m_seCACODE			= null;
String m_seMANAGERID		= null;
String m_seCERTPOLICY		= null;
String m_seCERTSERIAL		= null;
String m_seUSERID			= null;
String m_seSUBJECTDN		= null;
String m_seIDNO				= null;
String m_seSVDATE			= null;
String m_seEVDATE			= null;
String m_seCERTSTATUS		= null;
String m_seTOTALRECORDNUM	= null;
String m_seCURRENTRECORNUM	= null;

//Challenge\uc0ac\uc6a9\uc5ec\ubd80 : \uc77c\ubc18\uc801\uc73c\ub85c \uc0ac\uc6a9\uc548\ud568
boolean m_bChallenge = false;

//LDAP \uad00\ub828\uc815\ubcf4 : \ubcc0\uacbd\ud558\uc9c0 \ub9d0\uac83
String m_certserial = null;
String m_ldapchallenge = null;

//\uc778\uc99d\uc11c\uc2e0\uccad\uc815\ubcf4, \ud638\uc2a4\ud2b8\uc5d0\uc11c \ubc1c\uc544\uc57c \ud560\uc815\ubcf4 : \ubcc0\uacbd\ud558\uc9c0 \ub9d0\uac83
String m_REQ = null; //cert request
String m_CN = "\ud64d\uae38\ub3d9";
String m_MAIL = "caadmin@kepco.co.kr";
String m_OU = "\uc804\uc790\ud1b5\uc2e0\ucc98";	
String m_O = "\ud55c\uad6d\uc804\ub825\uacf5\uc0ac";
String m_L = "\uc11c\uc6b8\ud2b9\ubcc4\uc2dc";
String m_C = "KR";

//\uc778\uc99d\uc11c \uc2e0\uccad(\ucde8\uc18c) \uc131\uacf5\uc2dc \ubc1b\uc544\uc624\ub294 \uac12\ub4e4 : \ubcc0\uacbd\ud558\uc9c0 \ub9d0\uac83
String m_caSerial = null;
String m_caSeqNo = null;
String m_caIssueDate = null;
String m_caExpireDate = null;
String m_caRevokeDate = null;
String m_caRejectReason = null;

//\ubc1c\uae09(\ud3d0\uae30)\ub41c \uc778\uc99d\uc11c\ub97c PC\uc5d0 \uc800\uc7a5(\uc0ad\uc81c)\ud558\uae30\uc704\ud55c \uc815\ubcf4 : \ubcc0\uacbd\ud558\uc9c0 \ub9d0\uac83
String m_caCertString = null;
String m_orgCertString = null;
String m_caRevokedCertString = null;


if (m_IniErrCode == null) {
	
	try {
		if (m_bDebug) System.out.println("INIplugin (" + m_How + " ) : start ip.init");

		//\uc0ac\uc6a9\uc790 \ud655\uc778 Parameter \uc785\ub825\ud3fc\uc774 \ucd94\uac00\ub418\uba74 \uc5ec\uae30\ub2e4\uac00 \ucd94\uac00\ud558\uba74 \ub428
		m_ID = m_IP.getParameter("id");

		//2014.04.22 \ud55c\uad6d\uc804\ub825\uc740 \uc8fc\ubbfc\ubc88\ud638 \uc785\ub825\ud558\uc9c0 \uc54a\uc73c\ubbc0\ub85c
		//\uc784\uc758\uc758 \uc8fc\ubbfc\ub4f1\ub85d \ubc88\ud638\ub97c \uc785\ub825\ud558\uac8c \ud55c\ub2e4.
		//m_REGNO = lpad(m_IP.getParameter("regno"),13, "0");
		m_REGNO = "0000000000000";


		//m_PW = m_IP.getParameter("pw");

		m_SEARCHCODE = m_IP.getParameter("searchcode");
		m_SEARCHCONTENTS = m_IP.getParameter("searchcontents");
		
		if (m_How.equals("certNew") || m_How.equals("certRenewal") ||
			m_How.equals("certReplace")) {
			m_REQ = m_IP.getParameter("req");
			
			//CN\uac12\uc740 ID\ub85c \ubcc0\uacbd
			//m_CN = m_IP.getParameter("CN");
			m_CN = m_ID ;
			
			m_MAIL = m_IP.getParameter("EMAIL");
			
			//OU\uac12 \ubcc0\uacbd : \uc804\uc790\ud1b5\uc2e0\ucc98
			m_OU = m_IP.getParameter("OU");
			m_OU = "\uc804\uc790\ud1b5\uc2e0\ucc98";
			
			//O\uac12 \ubcc0\uacbd : \ud55c\uad6d\uc804\ub825\uacf5\uc0ac
			//m_O = m_IP.getParameter("O");
			m_O = "\ud55c\uad6d\uc804\ub825\uacf5\uc0ac";
			
			
			m_L = m_IP.getParameter("L");

			//C\uac12 \ubcc0\uacbd : KR
			//m_C = m_IP.getParameter("C");
			m_C = "KR";
		}
		
		m_certserial = m_IP.getParameter("serialno");

		if (m_bDebug) {
			System.out.println("\tID : " + m_ID);
			System.out.println("\tREGNO : " + m_REGNO);
//			System.out.println("\tPW : " + m_PW);
			System.out.println("\tCN : " + m_CN);
			System.out.println("\tEMAIL : " + m_MAIL);
			System.out.println("\tSERIAL : " + m_certserial);			
			System.out.println("\tSEARCHCODE     : " + m_SEARCHCODE);			
			System.out.println("\tSEARCHCONTENTS : " + m_SEARCHCONTENTS);			
		}
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : end ip.init");
	} catch(Exception e){
		m_IniErrCode = "iniPlugin_102";
		System.out.println(m_ID + " : Exception : " + e.getMessage());
		e.printStackTrace();
	}
}

    out.write(_jsp_string2, 0, _jsp_string2.length);
     
//************************************************
//  \uc785\ub825 : \uc0ac\uc6a9\uc790 \uc2e0\ubd84\ud655\uc778\uc815\ubcf4(m_ID, m_PW .. )
//  \ucd9c\ub825 : DN\uc815\ubcf4(m_CN, m_MAIL, m_OU, m_O, m_L, m_C)
//************************************************

if (m_IniErrCode == null) 
{
	if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : host(DB) connect start ...");
	//m_ID, m_PW\ub85c DB\uc11c\ubc84\uc5d0 \ud655\uc778\ud6c4 \uc544\ub798\uc758 \ud544\uc694\ud55c \uc815\ubcf4\ub97c \ucc44\uc6b4\ub2e4.

	//m_CN = "\ud14c\uc2a4\ud2b8";
	//m_MAIL = "mailto@initech.com
	m_OU = "\uc804\uc790\ud1b5\uc2e0\ucc98";
	m_O = "\ud55c\uad6d\uc804\ub825\uacf5\uc0ac";
	m_L = "SEOUL";
	m_C = "KR";

	//	m_IniErrCode = "DB_001";
	//	m_IniErrMsg = "\uc0ac\uc6a9\uc790\ud655\uc778\uc5d0\ub7ec";
	
	
	//String url = "jdbc:oracle:thin:@10.180.2.62:1521:INICA";
	//String user_id = "ra";
	//String user_pw = "kepcora";


	Context ic = new InitialContext();
	DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/INICA");
	ResultSet rs = null;
	
	Connection conn = null;
	Statement stmt = null;

	
	// printf("test");	
	try {
		
		conn = ds.getConnection();
		//Creat Query and get results
		stmt = conn.createStatement();

		rs = stmt.executeQuery("select serial from LDAP_INFO where userid='" + m_ID + "' and status='V'");
		
		while( rs.next() ) {
			m_certserial = rs.getString("serial");
		}
		
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : m_certserial: " + m_certserial);
		
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		rs.close();
		conn.close();
	}

	if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : host(DB) connect end ...");
}

    out.write(_jsp_string3, 0, _jsp_string3.length);
    
	if (m_IniErrCode == null) {
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) *** Success ***\n");
	} else {
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) *** Fail : " + m_IniErrCode + " ***\n");
		response.sendRedirect("err.jsp?id=" + m_ID + "&how=" + m_How + "&code=" + m_IniErrCode + "&msg=" + m_IniErrMsg);
		return;
	}

    out.write(_jsp_string4, 0, _jsp_string4.length);
    out.print((m_IP.getParameter("certpass")));
    out.write(_jsp_string5, 0, _jsp_string5.length);
     try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} 
    out.write(_jsp_string6, 0, _jsp_string6.length);
    out.print((m_ID));
    out.write(_jsp_string7, 0, _jsp_string7.length);
    out.print((m_REGNO));
    out.write(_jsp_string8, 0, _jsp_string8.length);
    out.print((m_C));
    out.write(_jsp_string9, 0, _jsp_string9.length);
    out.print((m_L));
    out.write(_jsp_string10, 0, _jsp_string10.length);
    out.print((m_O));
    out.write(_jsp_string11, 0, _jsp_string11.length);
    out.print((m_OU));
    out.write(_jsp_string12, 0, _jsp_string12.length);
    out.print((m_CN));
    out.write(_jsp_string13, 0, _jsp_string13.length);
    out.print((m_MAIL));
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print((m_CN));
    out.write(_jsp_string15, 0, _jsp_string15.length);
     try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} 
    out.write(_jsp_string16, 0, _jsp_string16.length);
  }

  private com.caucho.make.DependencyContainer _caucho_depends
    = new com.caucho.make.DependencyContainer();

  public java.util.ArrayList<com.caucho.vfs.Dependency> _caucho_getDependList()
  {
    return _caucho_depends.getDependencies();
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    _caucho_depends.add(depend);
  }

  protected void _caucho_setNeverModified(boolean isNotModified)
  {
    _caucho_isNotModified = true;
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;

    if (_caucho_isNotModified)
      return false;

    if (com.caucho.server.util.CauchoSystem.getVersionId() != -1257324557874484737L)
      return true;

    return _caucho_depends.isModified();
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
    TagState tagState;
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/ini_certNew_checkid.jsp"), -4071466326380591156L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/iniplugin_init.jsp"), 6054584604837940715L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_init.jsp"), -887868055251006594L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_db_check.jsp"), -4092200393441911220L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_err_check.jsp"), 7889382124300349123L, true);
    _caucho_depends.add(depend);
  }

  final static class TagState {

    void release()
    {
    }
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void caucho_init(ServletConfig config)
  {
    try {
      com.caucho.server.webapp.WebApp webApp
        = (com.caucho.server.webapp.WebApp) config.getServletContext();
      init(config);
      if (com.caucho.jsp.JspManager.getCheckInterval() >= 0)
        _caucho_depends.setCheckInterval(com.caucho.jsp.JspManager.getCheckInterval());
      _jsp_pageManager = webApp.getJspApplicationContext().getPageManager();
      com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
      com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.InitPageContextImpl(webApp, this);
    } catch (Exception e) {
      throw com.caucho.config.ConfigException.create(e);
    }
  }

  private final static char []_jsp_string7;
  private final static char []_jsp_string6;
  private final static char []_jsp_string4;
  private final static char []_jsp_string2;
  private final static char []_jsp_string11;
  private final static char []_jsp_string16;
  private final static char []_jsp_string14;
  private final static char []_jsp_string15;
  private final static char []_jsp_string8;
  private final static char []_jsp_string10;
  private final static char []_jsp_string0;
  private final static char []_jsp_string13;
  private final static char []_jsp_string3;
  private final static char []_jsp_string1;
  private final static char []_jsp_string5;
  private final static char []_jsp_string12;
  private final static char []_jsp_string9;
  static {
    _jsp_string7 = "\">\n	<input type=hidden name=regno value=\"".toCharArray();
    _jsp_string6 = "\n\n<table width=\"570\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n  <tr> \n    <td height=\"107\" align=\"center\" valign=\"bottom\"><font face=\"\ub3cb\uc6c0\" size=\"4\"><b>- \uc778\uc99d\uc11c \uc2e0\uaddc\ubc1c\uae09 -</b></font><br>\n      <br>\n    </td>\n  </tr>\n  <tr> \n    <td align=\"center\">\n    \n<form name=sendForm method=POST action='./ini_certNew_send.jsp'>\n	<input type=hidden name=INIpluginData value=\"\">\n</form>\n\n<form name=readForm onsubmit='return CheckSendForm(this, sendForm);'>\n	<input type=hidden name=id value=\"".toCharArray();
    _jsp_string4 = "\n\n\n<html>\n<head>\n	<title>\uc778\uc99d\uc11c \uc2e0\uaddc\ubc1c\uae09 \uc2e0\uccad</title>	\n	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">\n	<meta http-equiv=\"Progma\" content=\"no-cache\">\n	<script language=\"javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\n	<script language=\"javascript\" src=\"/initech/plugin/INIutil.js\"></script>\n	<script language=\"javascript\">\n	var bAutoSubmit = true;\n	\n	//\ud328\uc2a4\uc6cc\ub4dc\ub97c \uc6f9\ud398\uc774\uc9c0\uc5d0\uc11c \ubc1b\uae30 \uc704\ud574 \ucd94\uac00 \uc2dc\uc791\n	function CertRequest_NoUI(form)\n	{\n		var dn=\"\";\n		var temp=\"\"\n		len = form.elements.length;\n	\n		form.req.value=\"\";\n	\n		obj = ModuleInstallCheck();\n		if (obj == null) return false;\n		\n		for (i = 0; i < len; i++) \n		{\n			var name = form.elements[i].name.toUpperCase();\n			var temp = form.elements[i].value;\n			if(name == \"C\")	dn = dn + \"C=\" + obj.URLEncode(temp) + \"&\";\n		//	if(name == \"L\")	dn = dn + \"L=\" + obj.URLEncode(temp) + \"&\";\n			if(name == \"O\")	dn = dn + \"O=\" + obj.URLEncode(temp) + \"&\";\n			if(name == \"OU\") dn = dn + \"OU=\" + obj.URLEncode(temp) + \"&\";\n			if(name == \"CN\") dn = dn + \"CN=\" + obj.URLEncode(temp) + \"&\";\n			if(name == \"EMAIL\")\n			{\n				if(temp==\"\") temp = \" \";\n	\n				dn = dn + \"EMAIL=\" + obj.URLEncode(temp) + \"&\";\n			}\n		}\n		\n		//\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638 \uc785\ub825 ui \ud45c\uc2dc\ub418\uc9c0 \uc54a\ub3c4\ub85d \uc124\uc815\n		//\uc778\uc99d\uc11c \uc800\uc7a5 UI\uac00 \ud45c\uc2dc\ub418\uc9c0 \uc54a\uc73c\ubbc0\ub85c \ud558\ub4dc\ub514\uc2a4\ud06c\uc5d0 \uc800\uc7a5\ud568.\n		SetProperty(\"InputPwdSkipForCertReq\",\"true\");\n		\n		req = obj.CertRequest(InitechPackage, \"HDD\", dn, \"".toCharArray();
    _jsp_string2 = "\n\n\n\n\n\n\n".toCharArray();
    _jsp_string11 = "\">\n	<input type=hidden name=OU value=\"".toCharArray();
    _jsp_string16 = "\n</body>\n</html>\n".toCharArray();
    _jsp_string14 = "\">\n	<input type=hidden name=req value=\"\">\n\n	<div align=\"center\">\n	<table border=\"0\" cellspacing=\"1\" width=\"370\">\n        <tr> \n          <td width=\"100%\" align=\"left\"> \n            <p> <font face=\"\ub3cb\uc6c0\" size=\"2\"><span class=\"text\">".toCharArray();
    _jsp_string15 = "\ub2d8\uc758 \uc778\uc99d\uc11c\ub97c \uc2e0\uaddc\ubc1c\uae09 \uc2e0\uccad\uc911\uc785\ub2c8\ub2e4.<br>\n              \uc544\ub798\uc758 \uc0dd\uc131 \ubc84\ud2bc\uc744 \ub204\ub974\uba74 \ub2e4\uc74c\uacfc \uac19\uc740 \ubc1c\uae09 \uc808\ucc28\ub85c \uc9c4\ud589\uc774 \ub429\ub2c8\ub2e4.</span></font><span class=\"text\"><font face=\"\ub3cb\uc6c0\" size=\"2\" color=\"#3366FF\"><br>\n                KeyBits: <input type=radio name=keybits value=\"1024\"> 1024 <input type=radio name=keybits value=\"2048\" checked> 2048<br>\n              <br>\n              <b>*\ubc1c\uae09\uc808\ucc28</b><br>\n              </font><font face=\"\ub3cb\uc6c0\" size=\"2\"> (1) PC\uc5d0 \ubcf4\uad00\ub420 \uc778\uc99d\uc11c \uc554\ud638 \uc785\ub825<br>\n              (2) \uc0ac\uc6a9\uc790\uc758 \uacf5\uac1c\ud0a4 \uc0dd\uc131<br>\n              (3) \uc778\uc99d\uc11c\ubc84\uc5d0 \uc778\uc99d\uc11c \ubc1c\uae09 \uc694\uccad<br>\n              (4) \uc778\uc99d\uc11c \ubc1c\uae09</font></span> \n          </td>\n        </tr>\n        <tr> \n          <td height=\"27\">&nbsp;</td>\n        </tr>\n        <tr align=\"center\"> \n          <td><input type=\"image\" src=\"img/icon_8.gif\" border=\"0\" alt=\"\ud655\uc778\"></td>\n        </tr>\n      </table>\n</form>\n\n</td>\n  </tr>\n</table>\n".toCharArray();
    _jsp_string8 = "\">\n	<input type=hidden name=C value=\"".toCharArray();
    _jsp_string10 = "\">\n	<input type=hidden name=O value=\"".toCharArray();
    _jsp_string0 = "\n\n\n\n\n\n\n\n".toCharArray();
    _jsp_string13 = "\">\n	<input type=hidden name=EMAIL value=\"".toCharArray();
    _jsp_string3 = "\n\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\n\n".toCharArray();
    _jsp_string5 = "\"); \n		\n		if(req==\"\") return false;\n		form.req.value = req;\n		\n		return true;		\n	}\n	//\ud328\uc2a4\uc6cc\ub4dc\ub97c \uc6f9\ud398\uc774\uc9c0\uc5d0\uc11c \ubc1b\uae30 \uc704\ud574 \ucd94\uac00 \uc885\ub8cc\n	\n	function CheckSendForm(readForm, sendForm)\n	{\n		bAutoSubmit = false;\n		\n		// 1024, 2048 \uc124\uc815\n		var bits = (document.forms[\"readForm\"].keybits[0].checked)?\"1024\":\"2048\";			\n		SetProperty(\"SetBitPKCS10CertRequest\", bits);\n		\n		// p10 \ud14c\uc2a4\ud2b8\ub97c \uc704\ud55c DN\uac12 \ucd94\ucd9c\n//		var dn = CertRequest_DN(readForm);\n\n		\n//		alert(dn);\n		\n		//if(CertRequest(readForm))\n		if(CertRequest_NoUI(readForm))\n			if (EncForm2(readForm, sendForm)) {\n				ViewMsg();\n				sendForm.submit();\n				return false;\n			}\n		alert(\"\uc778\uc99d\uc11c \uc2e0\uccad\uc774 \ucde8\uc18c \ub418\uc5c8\uc2b5\ub2c8\ub2e4.\");\n		return false;\n	}\n\n	function ViewMsg()\n	{\n		var msg = \"\uc778\uc99d\uc11c\ubc84\uc5d0\uc11c \uc778\uc99d\uc11c\ub97c \ubc1b\uc544\uc624\ub294 \uc911\uc785\ub2c8\ub2e4. \uc7a0\uc2dc\ub9cc \uae30\ub2e4\ub9ac\uc2ed\uc2dc\uc694.\";\n		setMsg(msg, 0, 200);\n		showMsg();\n	}\n\n	function AutoSubmit()\n	{\n		if (bAutoSubmit)\n			return CheckSendForm(readForm, sendForm);\n	}\n\n	function AutoRequest()\n	{\n		setTimeout(\"AutoSubmit()\", 5000);\n	}\n	</script>\n<style type=\"text/css\">\n<!--\n.text {  font-family: \"\ub3cb\uc6c0\"; font-size: 12px; text-decoration: none; line-height: 17px}\n-->\n</style>\n</head>\n\n<body onLoad=\"defaultStatus='';\">\n".toCharArray();
    _jsp_string12 = "\">\n	<input type=hidden name=CN value=\"".toCharArray();
    _jsp_string9 = "\">\n	<input type=hidden name=L value=\"".toCharArray();
  }
}
