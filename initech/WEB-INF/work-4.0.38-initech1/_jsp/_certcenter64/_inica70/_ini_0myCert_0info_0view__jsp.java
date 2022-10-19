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
import java.text.*;
import java.security.cert.X509Certificate;
import java.security.cert.CertificateFactory;
import com.initech.iniplugin.*;
import com.initech.util.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

public class _ini_0myCert_0info_0view__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  private boolean _caucho_isNotModified;
  private com.caucho.jsp.PageManager _jsp_pageManager;

  
  	/** PEM \ud0c0\uc785\uc758 \uc778\uc99d\uc11c \ud5e4\ub354 */
  	public static final String PEM_BEGIN_STR = "-----BEGIN CERTIFICATE-----\n";
  	/** PEM \ud0c0\uc785\uc758 \uc778\uc99d\uc11c \ud14c\uc77c */
  	public static final String PEM_END_STR = "-----END CERTIFICATE-----";
  
  	// PEM\ud615\uc2dd\uc5d0\uc11c x509\ub85c~~~
  
  	public X509Certificate parseX509Cert(String certStr) throws Exception
  	{
  		String str = null;
  		X509Certificate x509Cert = null;
  		ByteArrayInputStream baIn = null;
  		CertificateFactory certFactory = null;
  
  		try
  		{
  			baIn = new ByteArrayInputStream(certStr.getBytes());
  			certFactory = getCertificateFactory();
  			x509Cert = (X509Certificate) certFactory.generateCertificate(baIn);
  		}
  		catch (Exception e)
  		{
  			throw new Exception(e.getMessage());
  		}
  		finally
  		{
  			try
  			{
  				baIn.close();
  			}
  			catch (Exception e) {}
  		}
  
  		return x509Cert;
  	}
  
  	public CertificateFactory getCertificateFactory() throws Exception
  	{
  		CertificateFactory certFactory = null;
  		certFactory = CertificateFactory.getInstance("X.509", AutoProvider.providerName);
  		return certFactory;
  	}
  
  	// x509 \uc5d0\uc11c pem \ud615\uc2dd\uc73c\ub85c~~
  	public static String x509CertificateToPem(X509Certificate cert) throws Exception
  	{
  		byte[] asn1encoded = null;
  		byte[] base64encoded = null;
  		String certStr = null;
  		try
  		{
  			asn1encoded = cert.getEncoded();
  			base64encoded = Base64Util.encode(asn1encoded);
  			certStr = PEM_BEGIN_STR + new String(base64encoded) + PEM_END_STR;
  		}
  		catch (Exception e)
  		{
  			throw new Exception(e.getMessage());
  		}
  
  		return certStr;
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
    response.setContentType("text/html; charset=EUC-KR");

    out.write(_jsp_string0, 0, _jsp_string0.length);
     
		IniPlugin m_IP = null;
		String pluginConfig  = null;
		String signConfig  = null;
		String oidConfig  = null;
		String crlConfig  = null;
		String certConfig  = null;
		String certverifierConfig = null;
		String netConfig = null;
		String inimasConfig = null;
		
		pluginConfig  = "/home/initech/iniplugin/properties/IniPlugin.inica70.properties";
				
		signConfig  = "/home/unixdev/initech/iniplugin/properties/INISAFESign.properties";
		oidConfig = "/home/unixdev/initech/iniplugin/properties/jCERTOID.properties";
		crlConfig = "/home/unixdev/initech/iniplugin/properties/CRL.properties";
		certConfig = "/home/unixdev/initech/iniplugin/properties/certcenter.properties";
		certverifierConfig = "/home/unixdev/initech/iniplugin/properties/certverifier.properties";
		netConfig = "/home/unixdev/initech/iniplugin/properties/INISAFENet.properties";
		inimasConfig = "/home/unixdev/initech/iniplugin/properties/IniMas.properties";
	
		String iniData = request.getParameter("INIpluginData");
		
		if(iniData != null && !iniData.equals("")){
			
		m_IP = new IniPlugin(request,response,pluginConfig);
		
		try {
			m_IP.init(false);
		} catch(Exception e) {
			e.printStackTrace();
		} 
	}	
		

    out.write(_jsp_string1, 0, _jsp_string1.length);
    
	boolean bEncrypt = false;
	String tmp = m_IP.getParameter("encrypt");
	if ((tmp != null) && tmp.equals("on"))
	{
		bEncrypt = true;
	}


	//\uc778\uc99d\uc11c serial\ubc88\ud638\ub85c \uc778\uc99d\uc11c \uc0c1\ud0dc \uac80\uc99d
	Context ict = new InitialContext();
	DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
	ResultSet rs = null;

	Connection conn = null;
	Statement stmt = null;

	// \uc778\uc99d\uc774 \ud544\uc694\ud55c \ud398\uc774\uc9c0 \uc778\uc9c0 \uccb4\ud06c \ubc0f \uc778\uc99d\uc11c \uc815\ubcf4\ubcf4\uae30
	String strClientAuth = null;
	String certInfo = "";
	String subjectDN = "";
	String IssuerDN = "";
	String userCertString = null;
	String x509String = null;
	String pemtype = null;
	String x509String_1 = null;
	String strNotBefore = ""; //\uc778\uc99d\uc11c \ubc1c\uae09\uc77c
	String strNotAfter = "" ; //\uc778\uc99d\uc11c \ub9cc\ub8cc\uc77c
	String strSerial = "" ; //\uc778\uc99d\uc11c \uc2dc\ub9ac\uc5bc
	String strCertOrg = "" ; //\uc778\uc99d\uc11c \ubc1c\uae09\uae30\uad00
	String strCertValid = "\ud3d0\uae30" ; //\uc778\uc99d\uc11c \uc0c1\ud0dc
	int defDate = 0 ;
	int rsCnt = 0 ;

	if (m_IP.isClientAuth() == false)
	{
		strClientAuth = "\uc0ac\uc6a9\uc790(Client) \uc778\uc99d\uc11c\uac00 \uc0ac\uc6a9\ub418\uc9c0 \uc54a\uc558\uc2b5\ub2c8\ub2e4.";
	}
	else
	{
		try
		{
			strClientAuth = "\uc0ac\uc6a9\uc790(Client) \uc778\uc99d\uc11c\uc758 \uc815\ubcf4\ub294 \uc544\ub798\uc640 \uac19\uc2b5\ub2c8\ub2e4.";

			X509Certificate userCert_a = m_IP.getClientCertificate();

			userCertString = m_IP.getClientCertificate2();  // \uc778\uc99d\uc11c PEM\ud615\ud0dc\ub85c \ubf51\uae30
			//System.out.println(userCertString);

			X509Certificate userCert = parseX509Cert(userCertString);	// PEM\ud615\uc2dd\uc758 \uc778\uc99d\uc11c\ub97c x509 \ud615\ud0dc\ub85c

			x509String = userCert.toString();
			//System.out.println(x509String);

			pemtype = x509CertificateToPem(userCert);
			//System.out.println(pemtype);

			userCert = parseX509Cert(pemtype);
			x509String = userCert.toString();
			//System.out.println(x509String);

			subjectDN = userCert.getSubjectDN().toString();

			int certGubun = 0;	// \uc778\uc99d\uc11c \uad6c\ubd84 : \uc0ac\uc124(0), \uae08\uacb0\uc6d0(1), \ud0c0\uae30\uad00OCSP(2>=)

			DateFormat myDate = new SimpleDateFormat("yyyy-MM-dd hh:mm ss");
			java.util.Date NotBefore = userCert.getNotBefore();	// \uc778\uc99d\uc11c \ubc1c\uae09\uc77c
			java.util.Date NotAfter = userCert.getNotAfter();		// \uc778\uc99d\uc11c \ub9cc\uae30\uc77c
			java.util.Date currentTime = new java.util.Date();				// \ud604\uc7ac \uc2dc\uac04
			int date = (int) ((NotAfter.getTime() - currentTime.getTime()) / (24 * 60 * 60 * 1000));
			defDate = date ;

			strNotBefore = myDate.format(NotBefore) ;
			strNotAfter = myDate.format(NotAfter) ;
			strSerial = userCert.getSerialNumber().toString(10) ;
			//certInfo += "&nbsp;&nbsp;&nbsp;Serial[<b>" + userCert.getSerialNumber().toString() + "</b>]";
			//certInfo += "&nbsp;&nbsp;&nbsp;Serial(10\uc9c4\uc218)[<b>" + userCert.getSerialNumber().toString(10) + "</b>]";
			//certInfo += "&nbsp;&nbsp;&nbsp;Serial(16\uc9c4\uc218)[<b>" + userCert.getSerialNumber().toString(16) + "</b>]";
			
			
			//try {
				conn = ds.getConnection();
				stmt = conn.createStatement();
				rs = stmt.executeQuery("select count(serial) as cnt from ldap_info where to_char(to_number(serial)) = '"+ strSerial +"'");
				
				while( rs.next() ) {
					rsCnt = rs.getInt("cnt");
				}
				if (rsCnt == 0){
					strCertValid = "\ud3d0\uae30\ub41c \uc778\uc99d\uc11c";
				}else{
					strCertValid = "\uc720\ud6a8\ud55c \uc778\uc99d\uc11c";
				}
			//} catch(Exception e) {
				//e.printStackTrace();
			//} finally {
				rs.close();
				conn.close();
			//}

			IssuerDN = userCert.getIssuerDN().toString().toUpperCase();
			//out.println("<Br><Br>IssuerDN ==> " + IssuerDN);
			if (IssuerDN.indexOf("O=\uc0ac\uc124") > -1)							certGubun = 0;	// \uc0ac\uc124
			else if (IssuerDN.indexOf("O=yessign".toUpperCase()) >- 1)		certGubun = 1;	// \uae08\uacb0\uc6d0\uacf5\uc778
			else if (IssuerDN.indexOf("O=SignKorea".toUpperCase()) >- 1)	certGubun = 2;	// \uc99d\uad8c\uc804\uc0b0
			else if (IssuerDN.indexOf("O=NCASign".toUpperCase()) >- 1)		certGubun = 3;	// \uc804\uc0b0\uc6d0
			else if (IssuerDN.indexOf("O=TradeSign".toUpperCase()) >- 1)	certGubun = 4;	// \ubb34\uc5ed\uc815\ubcf4\ud1b5\uc2e0
			else if (IssuerDN.indexOf("O=CrossCert".toUpperCase()) >- 1)	certGubun = 5;	// \uc804\uc790\uc778\uc99d
			else if (IssuerDN.indexOf("O=KICA".toUpperCase()) >- 1)			certGubun = 6;	// \uc815\ubcf4\uc778\uc99d
			else															certGubun = 10;	// \uae30\ud0c0\uacf5\uc778

			if (certGubun == 0)			strCertOrg += "\uc0ac\uc124";
			else if (certGubun == 1)	strCertOrg += "\uae08\uacb0\uc6d0";
			else if (certGubun == 2)	strCertOrg += "\uc99d\uad8c\uc804\uc0b0";
			else if (certGubun == 3)	strCertOrg += "\uc804\uc0b0\uc6d0";
			else if (certGubun == 4)	strCertOrg += "\ubb34\uc5ed\uc815\ubcf4\ud1b5\uc2e0";
			else if (certGubun == 5)	strCertOrg += "\uc804\uc790\uc778\uc99d";
			else if (certGubun == 6)	strCertOrg += "\uc815\ubcf4\uc778\uc99d";
			else						strCertOrg += "\ud55c\uad6d\uc804\ub825\uacf5\uc0ac";

			
}
	catch (Exception eee)
	{
		out.println("<br><b>(?)Certificate Info() ERR</b>");
		out.println("<br>FileName = CryptoTest.jsp");
		out.println("<br>Exception = " + eee.getMessage());
		out.println("<br><br><b>printStackTrace</b><br>");
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		eee.printStackTrace(pw);
		out.println(sw.toString());
		return;
	}
}		

    out.write(_jsp_string2, 0, _jsp_string2.length);
    out.print((subjectDN));
    out.write(_jsp_string3, 0, _jsp_string3.length);
    out.print((strClientAuth));
    out.write(_jsp_string4, 0, _jsp_string4.length);
    out.print((IssuerDN));
    out.write(_jsp_string5, 0, _jsp_string5.length);
    out.print((strCertOrg));
    out.write(_jsp_string6, 0, _jsp_string6.length);
    out.print((subjectDN));
    out.write(_jsp_string7, 0, _jsp_string7.length);
    out.print((strCertValid));
    out.write(_jsp_string8, 0, _jsp_string8.length);
    out.print((strNotBefore.substring(0,10)));
    out.write(_jsp_string9, 0, _jsp_string9.length);
    if (rsCnt == 0){
    out.write(_jsp_string10, 0, _jsp_string10.length);
    }else{
    out.print((strNotAfter.substring(0,10)));
    }
    out.write(_jsp_string11, 0, _jsp_string11.length);
    out.print((strSerial));
    out.write(_jsp_string12, 0, _jsp_string12.length);
    if (rsCnt == 0){
    out.write(_jsp_string10, 0, _jsp_string10.length);
    }else{
    out.print((defDate));
    out.write(_jsp_string13, 0, _jsp_string13.length);
    }
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print((request.getRemoteAddr()));
    out.write(_jsp_string15, 0, _jsp_string15.length);
    out.print((request.getHeader("User-Agent")));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/ini_myCert_info_view.jsp"), -4842348997442304516L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/config.jsp"), -7285903633904238357L, true);
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

  private final static char []_jsp_string12;
  private final static char []_jsp_string7;
  private final static char []_jsp_string10;
  private final static char []_jsp_string5;
  private final static char []_jsp_string8;
  private final static char []_jsp_string9;
  private final static char []_jsp_string4;
  private final static char []_jsp_string6;
  private final static char []_jsp_string15;
  private final static char []_jsp_string11;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string3;
  private final static char []_jsp_string14;
  private final static char []_jsp_string13;
  private final static char []_jsp_string16;
  private final static char []_jsp_string2;
  static {
    _jsp_string12 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\ub9cc\ub8cc\uae4c\uc9c0 \ub0a8\uc740 \uc77c \uc218</td>\r\n		<td class=\"wTableTdCell\">\r\n		".toCharArray();
    _jsp_string7 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc0ac\uc6a9\uc790 \uc778\uc99d\uc11c \uc0c1\ud0dc</td>\r\n		<td class=\"wTableTdCell\" style=\"font-weight:bold;color:#ff3366;\">".toCharArray();
    _jsp_string10 = "\ud3d0\uae30".toCharArray();
    _jsp_string5 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc778\uc99d\uc11c \ubc1c\uae09 \uae30\uad00</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string8 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc778\uc99d\uc11c \ubc1c\uae09\uc77c</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string9 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc778\uc99d\uc11c \ub9cc\ub8cc\uc77c</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string4 = "</li>\r\n				\r\n				<li style=\"float:left;padding-left:5px;\">\r\n<table cellSpacing=\"0\" cellPadding=\"0\" width=\"95%\" border=\"0\" class=\"wTable\">\r\n	<tr>\r\n		<td class=\"wTableTdHeader\" style=\"width:150px\" >\uc778\uc99d\uc11c \ubc1c\uae09\uc790</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string6 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc0ac\uc6a9\uc790 \uc778\uc99d\uc11c \uc815\ubcf4</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string15 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc0ac\uc6a9\uc790 \ube0c\ub77c\uc6b0\uc800 \uc815\ubcf4</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string11 = "</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc778\uc99d\uc11c \uc2dc\ub9ac\uc5bc\ubc88\ud638</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\n".toCharArray();
    _jsp_string1 = "\n\r\n".toCharArray();
    _jsp_string3 = "';\r\n		var data = \"aaaa\";\r\n		FilterUserCert(\"\", filter);\r\n		if (PKCS7SignedData(form, data, false) == true)\r\n		{\r\n			// \uc554\ud638\ud654 \uc218\ud589 (\ubcc0\uacbd\uc0ac\ud56d : EncFormVerify -> EncForm)\r\n			if (EncForm(form) == true)\r\n			{\r\n				return true;\r\n			}\r\n			else\r\n			{\r\n				alert(\"\uc554\ud638\ud654\uc5d0 \uc2e4\ud328\ud588\uc2b5\ub2c8\ub2e4.\");\r\n				return false;\r\n			}\r\n		}\r\n		else\r\n		{\r\n			alert(\"\uc804\uc790\uc11c\uba85\uc5d0 \uc2e4\ud328\ud588\uc2b5\ub2c8\ub2e4.\");\r\n			return false;\r\n		}\r\n\r\n		return false;\r\n	}\r\n</script>\r\n<style type=\"text/css\">\r\n.wTable {\r\n	width:930px;\r\n	border-top : solid 1px #c5c5c5;\r\n	border-left : solid 1px #c5c5c5;\r\n}\r\n.wTableTdHeader {\r\n	border-right : solid 1px #c5c5c5;\r\n	border-bottom : solid 1px #c5c5c5;\r\n	text-align : center;\r\n	font-weight : bold;\r\n	background-color : #eeeeee ;\r\n	padding : 4px;\r\n}\r\n.wTableTdCell {\r\n	border-right : solid 1px #c5c5c5;\r\n	border-bottom : solid 1px #c5c5c5;\r\n	font-weight : normal;\r\n	background-color : #ffffff ;\r\n	padding : 4px;\r\n}\r\n.wTableTdSearch {\r\n	border-right : solid 1px #c5c5c5;\r\n	border-bottom : solid 1px #c5c5c5;\r\n	font-weight : normal;\r\n	background-color : #ffffff ;\r\n	padding : 5px;\r\n}\r\n.wTableTdSearch1 {\r\n	border-right : solid 1px #c5c5c5;\r\n	\r\n	font-weight : normal;\r\n	background-color : #ffffff ;\r\n	padding : 5px;\r\n}\r\n</style>\r\n<!--[if IE 6]>\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie6.css\">\r\n<![endif]-->\r\n<!--[if IE 7]>\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie7.css\">\r\n<![endif]-->\r\n</head> \r\n<body>\r\n\r\n<div id=\"header\">\r\n	<!-- MAIN MENU START -->\r\n	<script language=\"javascript\">dspMainMenu();</script>\r\n	<!-- MAIN MENU END -->\r\n</div>\r\n\r\n<div style=\"height:10px;\"></div>\r\n<div id=\"subtop\">\r\n	<ul class=\"subtoptxt\">\r\n		<li class=\"toptxtcon\">\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\ud558\uae30</li>\r\n		<li class=\"toptxtcon01\">\uc778\uc99d\uc11c \ubc1c\uae09</li>\r\n		<li class=\"toptxtcon01\">\uc778\uc99d\uc11c \ud3d0\uae30</li>\r\n		<li class=\"toptxtcon01\" style=\"text-decoration:underline;\">\uc778\uc99d\uc11c \uad00\ub9ac</li>\r\n	</ul>\r\n</div>\r\n<div id=\"subissue\">\r\n	<ul>\r\n		<li><img src=\"img/subtitle_mycertInfo.gif\" alt=\"\ub098\uc758 \uc778\uc99d\uc11c \uc870\ud68c\"></li>\r\n		<li class=\"stitle\">&nbsp;</li>\r\n		\r\n		<li class=\"box\" style=\"height:340px;\">\r\n			<ul>\r\n				<li class=\"sbtextbg\" style=\"color:#336699;font-weight:bold;\"> - ".toCharArray();
    _jsp_string14 = "\r\n		</td>\r\n	</tr>\r\n	<tr>\r\n		<td class=\"wTableTdHeader\">\uc0ac\uc6a9\uc790 IP</td>\r\n		<td class=\"wTableTdCell\">".toCharArray();
    _jsp_string13 = " \uc77c".toCharArray();
    _jsp_string16 = "</td>\r\n	</tr>\r\n</table>\r\n<br />\r\n<table cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\" border=\"0\">\r\n	<tr>\r\n		<td style=\"text-align:center;\">\r\n			<img src=\"img/btn_myCert_info.gif\" border=\"0\" alt=\"\uc778\uc99d\uc11c \ub2e4\uc2dc \uc870\ud68c\" style=\"cursor:pointer;\"  onclick=\"location.href='ini_myCert_info.jsp';\">\r\n			<a href=\"#\" onclick=\"location.href='index.jsp';\"><img src=\"img/btn_myCert_info_cancel.gif\" alt=\"\uba54\uc778 \ud398\uc774\uc9c0 \ubc14\ub85c\uac00\uae30\"></a>\r\n		</td>\r\n	</tr>\r\n</table>\r\n				</li>\r\n			</ul>\r\n		</li>\r\n	</ul>\r\n\r\n	<div style=\"height:10px;\"></div>\r\n</div>\r\n\r\n\r\n\r\n<!-- COPYRIGHT START -->\r\n<script language=\"javascript\">dspCopyRight();</script>\r\n<!-- COPYRIGHT END -->\r\n\r\n</body>\r\n</html>\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n\r\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n<head>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\" />\r\n<title>\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\uc548\ub0b4</title>\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/import.css\" />\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\" />\r\n\r\n<script type=\"text/javascript\" src=\"js/jquery-1.7.2.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"js/jquery.flexslider-min.js\"></script>\r\n<script type=\"text/javascript\" src=\"js/jquery.als-1.1.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"js/common.js\"></script>\r\n<script language=\"javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\r\n<script language=\"javascript\">\r\n	function SecureSubmit(form)\r\n	{\r\n		alert(\"1\");\r\n		InitCache();\r\n		var filter = \"SubjectDN=\" + '".toCharArray();
  }
}
