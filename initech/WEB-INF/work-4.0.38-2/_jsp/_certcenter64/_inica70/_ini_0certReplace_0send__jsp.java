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
import com.initech.IniRA.*;
import java.text.*;
import com.initech.oppra.*;
import com.initech.oppra.util.*;

public class _ini_0certReplace_0send__jsp extends com.caucho.jsp.JavaPage
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



  public static String makeCertString(String varName, String certificate, boolean doFromJSP)
  {
  	String certificate1 = null;
  	String retString = null;
  	String certContent = null;

  	/*
  	   if( doFromJSP ){
  	   certContent = certificate.substring("-----BEGIN CERTIFICATE-----".length()+2, certificate.length() - ("-----END CERTIFICATE-----".length()+2));
  	   }else{
  	   certContent = certificate.substring("-----BEGIN CERTIFICATE-----".length(), certificate.length() - ("-----END CERTIFICATE-----".length() + 1 ));
  	   }
  	 */

  	certificate = certificate.replace("-----BEGIN CERTIFICATE-----", "");
  	certContent = certificate.replace("-----END CERTIFICATE-----", "");


  	StringTokenizer token = new StringTokenizer(certContent, "\n\r");

  	while(token.hasMoreTokens()) {
  		String temp = token.nextToken();
  		if(certificate1 == null) {
  			certificate1 = temp;
  		} else if(certificate1.equals(null)) {
  			System.out.println("Second Null");
  		} else {
  			certificate1 = certificate1 + temp;
  		}
  	}

  	retString = varName + "=\"-----BEGIN CERTIFICATE-----\";\n" + varName + "+=\"\\n\";\n";

  	StringReader reader = new StringReader(certificate1);

  	char[] readbuf = new char[64];
  	try {
  		for(int i = 0; i < (int)Math.floor((certificate1.length() / 64)); i++) {
  			reader.read(readbuf);
  			String temp = varName + "+=\"" + new String(readbuf) + "\";\n";
  			temp = temp + varName + "+=\"\\n\";\n";
  			retString = retString + temp;
  		}

  		int rem = certificate1.length() % 64;
  		if( rem != 0) {
  			System.out.println("rem length : " + String.valueOf(rem));
  			char[] buf = new char[rem];
  			reader.read(buf);
  			String temp = varName + "+=\"" + new String(buf) + "\";\n";

  			temp = temp + varName + "+=\"\\n\";\n";
  			retString = retString + temp;
  		}

  	} catch (Exception e) {
  		System.out.println("Exception e");
  		e.printStackTrace();
  	}

  	String temp = varName + "+=\"-----END CERTIFICATE-----\";\n";
  	retString = retString + temp;

  	return retString;
  }

  public static String makeCertCSString(String certificate)
  {
  	String certificate1 = null;
  	String retString = null;
  	String certContent = null;

  	certificate = certificate.replace("-----BEGIN CERTIFICATE-----", "");
  	certContent = certificate.replace("-----END CERTIFICATE-----", "");

  	return certContent;
  }
  /*
  public static String makeCertCSString(String certificate)
  {
  	String certificate1 = null;
  	String retString = null;
  	String certContent = null;

  	certificate = certificate.replace("-----BEGIN CERTIFICATE-----", "");
  	certContent = certificate.replace("-----END CERTIFICATE-----", "");

  	StringTokenizer token = new StringTokenizer(certContent, "\n\r");

  	while(token.hasMoreTokens()) {
  		String temp = token.nextToken();
  		if(certificate1 == null) {
  			certificate1 = temp;
  		} else if(certificate1.equals(null)) {
  			System.out.println("Second Null");
  		} else {
  			certificate1 = certificate1 + temp;
  		}
  	}

  	retString = "-----BEGIN CERTIFICATE-----\n\r";

  	StringReader reader = new StringReader(certificate1);

  	char[] readbuf = new char[64];
  	try {
  		for(int i = 0; i < (int)Math.floor((certificate1.length() / 64)); i++) {
  			reader.read(readbuf);
  			String temp = new String(readbuf) + "\n\r";
  			retString = retString + temp;
  		}

  		int rem = certificate1.length() % 64;
  		if( rem != 0) {
  			System.out.println("rem length : " + String.valueOf(rem));
  			char[] buf = new char[rem];
  			reader.read(buf);
  			String temp = new String(buf) + "\n\r";
  			retString = retString + temp;
  		}

  	} catch (Exception e) {
  		System.out.println("Exception e");
  		e.printStackTrace();
  	}

  	String temp = "-----END CERTIFICATE-----\n\r";
  	retString = retString + temp;

  	return retString;
  }*/

  
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
	IniDebug.println(true, m_IniErrMsg);
	IniDebug.request(request);
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

	if (m_IniErrCode != null) IniDebug.request(request);
}

    out.write(_jsp_string1, 0, _jsp_string1.length);
     m_How = "certReplace"; 
    out.write(_jsp_string1, 0, _jsp_string1.length);
    
	response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "0");
	

	String licensePath = "/home/initech/iniplugin/license/IniRA_v6_sdk.lic";

	IniRAutil m_RA = new IniRAutil( licensePath );

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
	String m_MAIL = "mailto@initech.com";
	String m_OU = "\uc778\uc99d\uc11c\ube44\uc2a4\ud300";	
	String m_O = "\uc774\ub2c8\ud14d";
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
		if (m_bDebug) IniDebug.println("INIplugin", m_How + " : start ip.init");

		//\uc0ac\uc6a9\uc790 \ud655\uc778 Parameter \uc785\ub825\ud3fc\uc774 \ucd94\uac00\ub418\uba74 \uc5ec\uae30\ub2e4\uac00 \ucd94\uac00\ud558\uba74 \ub428
		m_ID = m_IP.getParameter("id");
		m_REGNO = lpad(m_IP.getParameter("regno"),13, "0");
//		m_PW = m_IP.getParameter("pw");

		m_SEARCHCODE = m_IP.getParameter("searchcode");
		m_SEARCHCONTENTS = m_IP.getParameter("searchcontents");
		
		if (m_How.equals("certNew") || m_How.equals("certRenewal") ||
			m_How.equals("certReplace")) {
			m_REQ = m_IP.getParameter("req");
			m_CN = m_IP.getParameter("CN");
			m_MAIL = m_IP.getParameter("EMAIL");
			m_OU = m_IP.getParameter("OU");
			m_O = m_IP.getParameter("O");
			m_L = m_IP.getParameter("L");
			m_C = m_IP.getParameter("C");
		}
		
		m_certserial = m_IP.getParameter("serialno");

		if (m_bDebug) {
			IniDebug.println("\tID : " + m_ID);
			IniDebug.println("\tREGNO : " + m_REGNO);
//			IniDebug.println("\tPW : " + m_PW);
			IniDebug.println("\tCN : " + m_CN);
			IniDebug.println("\tEMAIL : " + m_MAIL);
			IniDebug.println("\tSERIAL : " + m_certserial);			
			IniDebug.println("\tSEARCHCODE     : " + m_SEARCHCODE);			
			IniDebug.println("\tSEARCHCONTENTS : " + m_SEARCHCONTENTS);			
		}
		if (m_bDebug) IniDebug.println(m_ID, m_How + " : end ip.init");
	} catch(Exception e){
		m_IniErrCode = "iniPlugin_102";
		IniDebug.println(m_ID, "Exception : " + e.getMessage());
		e.printStackTrace();
	}
}

    out.write(_jsp_string0, 0, _jsp_string0.length);
     if (m_IniErrCode == null) 
{
	String userid = m_ID;	
	String regno = m_REGNO;
	String ou = m_OU;
	String cn = m_CN;
	String mail = m_MAIL;
	String policy = "71";
	String serialno = m_certserial;

	HashMap hash = null;

	m_RA.setInfo(m_ID, m_IP);
	boolean ret = false;

	/* \uc694\uccad (C0:\ubc1c\uae09\uc694\uccad, C5:\uc7ac\ubc1c\uae09\uc694\uccad, C8:\uac31\uc2e0\uc694\uccad) */
	String CACode = null;
	if (m_How.equals("certNew")) 
	{
		CACode = "C0";
	}
	else if (m_How.equals("certReplace"))
	{
		CACode = "C5";
	}
	else if (m_How.equals("certRenewal"))
	{
		CACode = "C8";
	}
	else if (m_How.equals("certRevoke") || m_How.equals("certStop") || m_How.equals("certStart"))
	{
		CACode = "40";	/* 40:\uc778\uc99d\uc11c \uc0c1\ud0dc\ubcc0\uacbd \uc694\uccad */
	}
	else if (m_How.equals("certSearch"))
	{
		CACode = "50";	/* 50:\uc778\uc99d\uc11c \uc870\ud68c \uc694\uccad */
	}

	if (m_How.equals("certRevoke") || m_How.equals("certStop") || m_How.equals("certStart"))
	{
		String RAUSER = "TEST";					// \ub2e8\ub9d0\uae30 \uc6b4\uc601\uc790 ID
		String SERVICEPROVIDER = "01";			// \uc11c\ube44\uc2a4\uc81c\uacf5\uc790   01 RA_v7, 02 AuthGD
		String CODE = "08";						// \uc778\uc99d\uae30\uad00 \uc2dd\ubcc4\ucf54\ub4dc 01 \uae08\uacb0\uc6d0, 02 \ubb34\uc5ed\uc815\ubcf4\ud1b5\uc2e0, 03 \uc804\uc790\uc778\uc99d, 04 \ucf54\uc2a4\ucf64, 05 \uc815\ubcf4\uc778\uc99d, 06 \ud55c\uad6d\uc804\uc0b0\uc6d0, 08 \uc0ac\uc124CA
		String CERTPOLICY = policy;				// \uc778\uc99d\uc815\ucc45 \uc2dd\ubcc4\ucf54\ub4dc
		String CERTSERIAL = serialno;			// \uc778\uc99d\uc11c \uc77c\ub828\ubc88\ud638
		String SERVICECODE = null;
		if (m_How.equals("certRevoke"))
			SERVICECODE = "30";				// \uc11c\ube44\uc2a4 \ucf54\ub4dc 30:\ud3d0\uae30
		else if (m_How.equals("certStop"))
			SERVICECODE = "40";				// \uc11c\ube44\uc2a4 \ucf54\ub4dc 40:\ud6a8\ub825\uc815\uc9c0
		else if (m_How.equals("certStart"))
			SERVICECODE = "41";				// \uc11c\ube44\uc2a4 \ucf54\ub4dc 41:\ud6a8\ub825\ud68c\ubcf5

		hash = new HashMap();
		hash.put("MANAGERID", RAUSER);
		hash.put("SERVICEPROVIDER", SERVICEPROVIDER);
		hash.put("CACODE", CODE);
		hash.put("CERTCODE", CERTPOLICY);
		hash.put("CERTSERIAL", CERTSERIAL);
		hash.put("SERVICECODE", SERVICECODE);
	}
	else if (m_How.equals("certSearch"))
	{
		String RAUSER = "TEST";					// \ub2e8\ub9d0\uae30 \uc6b4\uc601\uc790 ID
		String SERVICEPROVIDER = "01";			// \uc11c\ube44\uc2a4\uc81c\uacf5\uc790   01 RA_v7, 02 AuthGD
		String CODE = "08";						// \uc778\uc99d\uae30\uad00 \uc2dd\ubcc4\ucf54\ub4dc 01 \uae08\uacb0\uc6d0, 02 \ubb34\uc5ed\uc815\ubcf4\ud1b5\uc2e0, 03 \uc804\uc790\uc778\uc99d, 04 \ucf54\uc2a4\ucf64, 05 \uc815\ubcf4\uc778\uc99d, 06 \ud55c\uad6d\uc804\uc0b0\uc6d0, 08 \uc0ac\uc124CA
		String CERTPOLICY = policy;				// \uc778\uc99d\uc815\ucc45 \uc2dd\ubcc4\ucf54\ub4dc
		String SEARCHCODE = m_SEARCHCODE;
		String SEARCHCONTENTS = m_SEARCHCONTENTS;
		String REQRECORDSTARTNO = null;
		String REQRECORDNO = null;

		hash = new HashMap();
		hash.put("MANAGERID", RAUSER);
		hash.put("SERVICEPROVIDER", SERVICEPROVIDER);
		hash.put("CACODE", CODE);
		hash.put("CERTCODE", CERTPOLICY);
		hash.put("SEARCHCODE", SEARCHCODE);
		hash.put("SEARCHCONTENTS", SEARCHCONTENTS);
		hash.put("REQRECORDSTARTNO", REQRECORDSTARTNO);
		hash.put("REQRECORDNO", REQRECORDNO);
	}
	else
	{
		String RAUSER = "TEST";					// \ub2e8\ub9d0\uae30 \uc6b4\uc601\uc790 ID
		String USERCODE = "1";					// \uac00\uc785\uc790 \uad6c\ubd84\ucf54\ub4dc  1 \uac1c\uc778, 2 \uae30\uc5c5, 3 \uae30\ud0c0
		String ORGNAME = ou;					// \uae30\uc5c5\uba85
		String DETAILNAME = cn;					// \uac1c\uc778/\uae30\uc5c5 \uc138\ubd80\uba85
		String REGNO = regno;					// \uc8fc\ubbfc\ubc88\ud638
		String BANKINGID = userid;				// \uc778\ud130\ub137\ubc45\ud0b9ID
		String SERVICEPROVIDER = "01";			// \uc11c\ube44\uc2a4\uc81c\uacf5\uc790   01 RA_v7, 02 AuthGD
		String CODE = "08";						// \uc778\uc99d\uae30\uad00 \uc2dd\ubcc4\ucf54\ub4dc 01 \uae08\uacb0\uc6d0, 02 \ubb34\uc5ed\uc815\ubcf4\ud1b5\uc2e0, 03 \uc804\uc790\uc778\uc99d, 04 \ucf54\uc2a4\ucf64, 05 \uc815\ubcf4\uc778\uc99d, 06 \ud55c\uad6d\uc804\uc0b0\uc6d0, 08 \uc0ac\uc124CA
		String CERTPOLICY = policy;				// \uc778\uc99d\uc815\ucc45 \uc2dd\ubcc4\ucf54\ub4dc
		String USERMAIL = mail;	// \uc774\uba54\uc77c
		String PHONE = "010-123-1234";			// \ud3f0
		String FAX = "02-6445-7200";			// FAX
		String POSTNUM = "123-123";				// \uc6b0\ud3b8\ubc88\ud638
		String ADDRESS ="\uc11c\uc6b8 \uad6c\ub85c \uad6c\ub85c\ub3d9 \uc5d0\uc774\uc2a4\ud558\uc774\uc5d4\ub4dc\ud0c0\uc6cc2\ucc28 11\uce35 1\ud638"; // \uc8fc\uc18c
		String PKCS10MSG = m_REQ;

		hash = new HashMap();
		hash.put("MANAGERID", RAUSER);
		hash.put("USERCODE", USERCODE);
		hash.put("OU_NAME", ORGNAME);
		hash.put("CN_NAME", DETAILNAME);
		hash.put("IDNO", REGNO);
		hash.put("USERID", BANKINGID);
		hash.put("SERVICEPROVIDER", SERVICEPROVIDER);
		hash.put("CACODE", CODE);
		hash.put("CERTCODE", CERTPOLICY);
		hash.put("EMAIL", USERMAIL);
		hash.put("HANDPHONE", PHONE);
		hash.put("FAX", FAX);
		hash.put("POSTCODE", POSTNUM);
		hash.put("POSTADDR", ADDRESS);
		hash.put("PHONE", PHONE);
		hash.put("POSTCODE1", POSTNUM);
		hash.put("POSTADDR1", ADDRESS);
		hash.put("PHONE1", PHONE);
		hash.put("PKCS10MSG", PKCS10MSG);
	}

	/* RA SDK \ucd08\uae30\ud654 */
	//IniOPPRA iniRA = new IniOPPRA("172.20.25.121", 4007);
	IniOPPRA iniRA = new IniOPPRA("10.180.2.67", 4000);
	iniRA.setCharEncoding("euc-kr");
	/* IniOPPRA iniRA = new IniOPPRA("172.20.25.140", 4007); */
	iniRA.initialize();

	/* RA \uc694\uccad */
	OppraSendDataParser oppraSendDataParser = new OppraSendDataParser(CACode, hash, false);
	String requestMsg = oppraSendDataParser.getSendLastData();

	/* \uc751\ub2f5\uc218\uc2e0 [PKCS#10 \uc778\uc99d\uc11c \ubc1c\uae09\ud1b5\ubcf4 (C1) \ud3ec\ub9f7] */
	/* [\uc815\uc0c1\uc751\ub2f5: rescode=000]
	 * 01: RESLEN
	 * 02: RESCODE
	 * 03: RESMSG
	 * 04: CERTDATA (\uc0c1\ud0dc\ubcc0\uacbd \uba54\uc2dc\uc9c0 \uc694\uccad\uc758 \uc751\ub2f5\uc77c \uacbd\uc6b0 \uc81c\uc678) */
	/* [\uc624\ub958\uc751\ub2f5: rescode=999]
	 * 01: RESLEN
	 * 02: RESCODE
	 * 03: RESMSG
	 * 04: ADDRESCODE
	 * 05: ADDRESMSG
	 * 06: RESERVE1
	 * 07: RESERVE2 */
	/* [\uc624\ub958\uc751\ub2f5: rescode=\uae30\ud0c0]
	 * 01: RESLEN
	 * 02: RESCODE
	 * 03: RESMSG
	 * 04: ADDRESCODE
	 * 05: ADDRESMSG
	 * 06: RESERVE1
	 * 07: RESERVE2
	 * 08: RESERVE3
	 * 09: RESERVE4 */
	String rsp = iniRA.requestRAW(requestMsg);
	OppraMessageDataParser odp = new OppraMessageDataParser(CACode, iniRA.getResDataPart());
	String sRESLEN = odp.getCodeData("RESLEN");			// \ub808\ucf54\ub4dc\uae38\uc774
	String sRESCODE = odp.getCodeData("RESCODE");		// \uc751\ub2f5\ucf54\ub4dc
	String sRESMSG = odp.getCodeData("RESMSG");			// \uc751\ub2f5\uba54\uc138\uc9c0
	String sCERTDATA = null;
	String sADDRESCODE = null;
	String sADDRESMSG = null;
	String sRESERVE1 = null;
	String sRESERVE2 = null;
	String sRESERVE3 = null;
	String sRESERVE4 = null;
	String sCLICERTDATA = null;

	String sCACODE = null;
	String sMANAGERID = null;
	String sCERTPOLICY = null;
	String sCERTSERIAL = null;
	String sUSERID = null;
	String sSUBJECTDN = null;
	String sIDNO = null;
	String sSVDATE = null;
	String sEVDATE = null;
	String sCERTSTATUS = null;
	String sTOTALRECORDNUM = null;
	String sCURRENTRECORNUM = null;

	if (sRESCODE.equals("000"))
	{
		if (m_How.equals("certRevoke") || m_How.equals("certStop") || m_How.equals("certStart"))
		{
			if (m_bDebug)
			{
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf80(\uc804\uccb4)       : " + iniRA.getResDataPart());
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf81(\ub808\ucf54\ub4dc\uae38\uc774) : " + sRESLEN);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf82(\uc751\ub2f5\ucf54\ub4dc)   : " + sRESCODE);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf83(\uc751\ub2f5\uba54\uc138\uc9c0) : " + sRESMSG);
			}
		}
		else if (m_How.equals("certSearch"))
		{
			sCACODE = odp.getStrCodeData("CACODE");						// \ub4f1\ub85d\ub300\ud589 \uae30\uad00\ucf54\ub4dc
			sMANAGERID = odp.getStrCodeData("MANAGERID");				// \ub2e8\ub9d0\uae30 \uc6b4\uc601\uc790 ID
			sCERTPOLICY = odp.getStrCodeData("CERTPOLICY");				// \uc778\uc99d\uc815\ucc45\uc2dd\ubcc4\ucf54\ub4dc
			sCERTSERIAL = odp.getStrCodeData("CERTSERIAL");				// \uc778\uc99d\uc11c\uc77c\ub828\ubc88\ud638
			sUSERID = odp.getStrCodeData("USERID");						// \uac00\uc785\uc790ID
			sSUBJECTDN = odp.getStrCodeData("SUBJECTDN");				// \uac00\uc785\uc790 DN\uba85
			sIDNO = odp.getStrCodeData("IDNO");							// \uc8fc\ubbfc(\uc0ac\uc5c5\uc790)\ub4f1\ub85d\ubc88\ud638
			sSVDATE = odp.getStrCodeData("SVDATE");						// \uc720\ud6a8\uae30\uac04\uc2dc\uc791
			sEVDATE = odp.getStrCodeData("EVDATE");						// \uc720\ud6a8\uae30\uac04\uc885\ub8cc
			sCERTSTATUS = odp.getStrCodeData("CERTSTATUS");				// \uc778\uc99d\uc11c\uc0c1\ud0dc
			sTOTALRECORDNUM= odp.getStrCodeData("TOTALRECORDNUM");		// \ucd1d \ub808\ucf54\ub4dc \uc218
			sCURRENTRECORNUM= odp.getStrCodeData("CURRENTRECORNUM");	// \ud604 \ub808\ucf54\ub4dc \ubc88\ud638

			if (m_bDebug)
			{
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf800(\uc804\uccb4)       : " + iniRA.getResDataPart());
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf801(\ub808\ucf54\ub4dc\uae38\uc774) : " + sRESLEN);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf802(\uc751\ub2f5\ucf54\ub4dc)   : " + sRESCODE);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf803(\uc751\ub2f5\uba54\uc138\uc9c0) : " + sRESMSG);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf804(\ub4f1\ub85d\ub300\ud589 \uae30\uad00\ucf54\ub4dc)    : " + sCACODE);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf805(\ub2e8\ub9d0\uae30 \uc6b4\uc601\uc790 ID)     : " + sMANAGERID);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf806(\uc778\uc99d\uc815\ucc45\uc2dd\ubcc4\ucf54\ub4dc)     : " + sCERTPOLICY);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf807(\uc778\uc99d\uc11c\uc77c\ub828\ubc88\ud638)       : " + sCERTSERIAL);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf808(\uac00\uc785\uc790ID)             : " + sUSERID);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf809(\uac00\uc785\uc790 DN\uba85)          : " + sSUBJECTDN);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf810(\uc8fc\ubbfc(\uc0ac\uc5c5\uc790)\ub4f1\ub85d\ubc88\ud638) : " + sIDNO);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf811(\uc720\ud6a8\uae30\uac04\uc2dc\uc791)         : " + sSVDATE);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf812(\uc720\ud6a8\uae30\uac04\uc885\ub8cc)         : " + sEVDATE);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf813(\uc778\uc99d\uc11c\uc0c1\ud0dc)           : " + sCERTSTATUS);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf814(\ucd1d \ub808\ucf54\ub4dc \uc218)         : " + sTOTALRECORDNUM);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf815(\ud604 \ub808\ucf54\ub4dc \ubc88\ud638)       : " + sCURRENTRECORNUM);
			}
		}
		else
		{
			sCERTDATA = odp.getStrCodeData("CERTDATA");	// \uc778\uc99d\uc11c
			m_orgCertString = makeCertCSString(sCERTDATA);
			/* \uc778\uc99d\uc11c (\ud074\ub77c\uc774\uc5b8\ud2b8 \uc804\ub2ec \ud3ec\ub9f7) */
			sCLICERTDATA = makeCertString("UserCert", sCERTDATA, false);

			if (m_bDebug)
			{
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf80(\uc804\uccb4)       : " + iniRA.getResDataPart());
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf81(\ub808\ucf54\ub4dc\uae38\uc774) : " + sRESLEN);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf82(\uc751\ub2f5\ucf54\ub4dc)   : " + sRESCODE);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf83(\uc751\ub2f5\uba54\uc138\uc9c0) : " + sRESMSG);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf84(\uc778\uc99d\uc11c)     : " + sCERTDATA);
				IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf85(\uc778\uc99d\uc11c-\ud074\ub77c\uc774\uc5b8\ud2b8\uc804\ub2ec\ud3ec\ub9f7) : " + sCLICERTDATA);
			}
		}
	}
	else if (sRESCODE.equals("999"))
	{
		sADDRESCODE = odp.getStrCodeData("ADDRESCODE");
		sADDRESMSG = odp.getStrCodeData("ADDRESMSG");
		sRESERVE1 = odp.getStrCodeData("RESERVE1");
		sRESERVE2 = odp.getStrCodeData("RESERVE2");

		if (m_bDebug)
		{
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf80(\uc804\uccb4)       : " + iniRA.getResDataPart());
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf81(\ub808\ucf54\ub4dc\uae38\uc774) : " + sRESLEN);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf82(\uc751\ub2f5\ucf54\ub4dc)   : " + sRESCODE);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf83(\uc751\ub2f5\uba54\uc138\uc9c0) : " + sRESMSG);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf84(ADDRESCODE) : " + sADDRESCODE);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf85(ADDRESMSG)  : " + sADDRESMSG);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf86(RESERVE1)   : " + sRESERVE1);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf87(RESERVE2)   : " + sRESERVE2);
		}
	}
	else
	{
		sADDRESCODE = odp.getStrCodeData("ADDRESCODE");
		sADDRESMSG = odp.getStrCodeData("ADDRESMSG");
		sRESERVE1 = odp.getStrCodeData("RESERVE1");
		sRESERVE2 = odp.getStrCodeData("RESERVE2");
		sRESERVE3 = odp.getStrCodeData("RESERVE3");
		sRESERVE4 = odp.getStrCodeData("RESERVE4");

		if (m_bDebug)
		{
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf80(\uc804\uccb4)       : " + iniRA.getResDataPart());
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf81(\ub808\ucf54\ub4dc\uae38\uc774) : " + sRESLEN);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf82(\uc751\ub2f5\ucf54\ub4dc)   : " + sRESCODE);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf83(\uc751\ub2f5\uba54\uc138\uc9c0) : " + sRESMSG);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf84(ADDRESCODE) : " + sADDRESCODE);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf85(ADDRESMSG)  : " + sADDRESMSG);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf86(RESERVE1)   : " + sRESERVE1);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf87(RESERVE2)   : " + sRESERVE2);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf88(RESERVE3)   : " + sRESERVE3);
			IniDebug.println(m_ID, m_How + " \ub514\ubc84\uadf89(RESERVE4)   : " + sRESERVE4);
		}
	}

	if (sRESCODE.equals("000"))
	{
		if (m_How.equals("certNew") || m_How.equals("certRenewal") || m_How.equals("certReplace"))
		{
			/***********************************/
			/* \uc218\uc2e0\ub41c \uc778\uc99d\uc11c \ud074\ub77c\uc774\uc5b8\ud2b8\ub85c \uc804\ub2ec */
			/***********************************/
			m_caCertString = sCLICERTDATA;
		}
		else if (m_How.equals("certSearch"))
		{
			/***********************************/
			/* \uc870\ud68c\ub41c \uacb0\uacfc\ub97c \ud074\ub77c\uc774\uc5b8\ud2b8\ub85c \uc804\ub2ec */
			/***********************************/
			m_seCACODE			= sCACODE;			// \ub4f1\ub85d\ub300\ud589 \uae30\uad00\ucf54\ub4dc
			m_seMANAGERID		= sMANAGERID;		// \ub2e8\ub9d0\uae30 \uc6b4\uc601\uc790 ID
			m_seCERTPOLICY		= sCERTPOLICY;		// \uc778\uc99d\uc815\ucc45\uc2dd\ubcc4\ucf54\ub4dc
			m_seCERTSERIAL		= sCERTSERIAL;		// \uc778\uc99d\uc11c\uc77c\ub828\ubc88\ud638
			m_seUSERID			= sUSERID;			// \uac00\uc785\uc790ID
			m_seSUBJECTDN		= sSUBJECTDN;		// \uac00\uc785\uc790 DN\uba85
			m_seIDNO			= sIDNO;			// \uc8fc\ubbfc(\uc0ac\uc5c5\uc790)\ub4f1\ub85d\ubc88\ud638
			m_seSVDATE			= sSVDATE;			// \uc720\ud6a8\uae30\uac04\uc2dc\uc791
			m_seEVDATE			= sEVDATE;			// \uc720\ud6a8\uae30\uac04\uc885\ub8cc
			m_seCERTSTATUS		= sCERTSTATUS;		// \uc778\uc99d\uc11c\uc0c1\ud0dc
			m_seTOTALRECORDNUM	= sTOTALRECORDNUM;	// \ucd1d \ub808\ucf54\ub4dc \uc218
			m_seCURRENTRECORNUM	= sCURRENTRECORNUM;	// \ud604 \ub808\ucf54\ub4dc \ubc88\ud638
		}
	}
	else
	{
		/*************/
		/* \uc624\ub958 \uc751\ub2f5 */
		/*************/
		m_IniErrCode = sRESCODE;
	}

	/* THE END */
}

    out.write(_jsp_string2, 0, _jsp_string2.length);
    
	if (m_IniErrCode == null) {
		if (m_bDebug) IniDebug.println(m_ID, m_How + " *** Success ***\n");
	} else {
		if (m_bDebug) IniDebug.println(m_ID, m_How + " *** Fail : " + m_IniErrCode + " ***\n");
		response.sendRedirect("err.jsp?id=" + m_ID + "&how=" + m_How + "&code=" + m_IniErrCode + "&msg=" + m_IniErrMsg);
		return;
	}

    out.write(_jsp_string3, 0, _jsp_string3.length);
    out.print((m_caCertString));
    out.write(_jsp_string4, 0, _jsp_string4.length);
     try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} 
    out.write(_jsp_string5, 0, _jsp_string5.length);
    out.print((m_CN));
    out.write(_jsp_string6, 0, _jsp_string6.length);
     try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} 
    out.write(_jsp_string7, 0, _jsp_string7.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/ini_certReplace_send.jsp"), -7042498461645336188L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/iniplugin_init.jsp"), -1015352452247031544L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_init.jsp"), -7604223984047988997L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_ca_send.jsp"), -656865287004752097L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_err_check.jsp"), -5174669870714048634L, true);
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

  private final static char []_jsp_string0;
  private final static char []_jsp_string6;
  private final static char []_jsp_string7;
  private final static char []_jsp_string3;
  private final static char []_jsp_string5;
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  private final static char []_jsp_string4;
  static {
    _jsp_string0 = "\n\n\n\n\n\n\n\n\n\n".toCharArray();
    _jsp_string6 = "\ub2d8\uc758 \uc778\uc99d\uc11c\uac00 \uc131\uacf5\uc801\uc73c\ub85c \uc7ac\ubc1c\uae09 \ub418\uc5c8\uc2b5\ub2c8\ub2e4.<br>\n            <br>\n            \uc778\uc99d\uc11c\uc758 \uc720\ud6a8\uae30\uac04\uc740 \ubc1c\uae09\uc77c\ub85c\ubd80\ud130 1\ub144\uc774\uba70<br>\n            \uc720\ud6a8\uae30\uac04\uc774 \uc9c0\ub09c \uc778\uc99d\uc11c\ub294 \uc0ac\uc6a9\ud558\uc2e4\uc218 \uc5c6\uc2b5\ub2c8\ub2e4.<br>\n            <br>\n            <br>\n            \uc774\uc6a9\ud574 \uc8fc\uc154\uc11c \uac10\uc0ac\ud569\ub2c8\ub2e4. </td>\n        </tr>\n      </table>\n</div>\n    </td>\n  </tr>\n</table>\n\n".toCharArray();
    _jsp_string7 = "\n</body>\n</html>\n".toCharArray();
    _jsp_string3 = "\n\n<html>\n<head>\n	<title>\uc778\uc99d\uc11c \uc7ac\ubc1c\uae09 \uacb0\uacfc</title>	\n	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">\n	<meta http-equiv=\"Progma\" content=\"no-cache\">\n	<script language=\"javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\n	<script language=\"javascript\">\n		var UserCert;\n		".toCharArray();
    _jsp_string5 = "\n\n<table width=\"570\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n  <tr> \n    <td height=\"107\" align=\"center\" valign=\"bottom\"><font face=\"\ub3cb\uc6c0\" size=\"4\"><b>- \uc778\uc99d\uc11c \uc7ac\ubc1c\uae09 -</b></font><br>\n      <br>\n    </td>\n  </tr>\n  <tr> \n    <td align=\"center\">\n<div align=\"center\">\n<table border=\"0\" cellspacing=\"1\" width=\"370\">\n        <tr> \n          <td width=\"100%\" align=\"left\" class=\"text\"> ".toCharArray();
    _jsp_string2 = "\n\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\n\n".toCharArray();
    _jsp_string4 = "\n	</script>\n<style type=\"text/css\">\n<!--\n.text {  font-family: \"\ub3cb\uc6c0\"; font-size: 12px; text-decoration: none; line-height: 17px}\n-->\n</style>\n</head>\n\n<body OnLoad=\"InsertUserCert(UserCert);\">\n".toCharArray();
  }
}
