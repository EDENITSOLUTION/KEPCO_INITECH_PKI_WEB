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
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class _ini_0certRevoke_0checkid__jsp extends com.caucho.jsp.JavaPage
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


  
   public byte[] getHashValue(String inputString)
      {
          MessageDigest md = null;
          
          try {
              md = MessageDigest.getInstance("MD5");
              
              md.update(inputString.getBytes());
              
          } catch (NoSuchAlgorithmException e) {
              // TODO \uc790\ub3d9 \uc0dd\uc131\ub41c catch \ube14\ub85d
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
     m_How = "certRevoke"; 
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

//\uc0ac\uc6a9\uc790\uc815\ubcf4\ub97c \uc778\uc0ac\uc815\ubcf4\uc5d0\uc11c \uac00\uc9c0\uace0 \uc640\uc11c
//\ud574\ub2f9 \uc0ac\uc6a9\uc790\ub9cc \uc778\uc99d\uc11c \ubc1c\uae09 \ubc1b\uac8c \ud560\uc9c0 \uccb4\ud06c
// false : \uc778\uc0ac\uc815\ubcf4\uc678 \uc785\ub825\ud55c \uc784\uc758\uc758 \uc544\uc774\ub514\ub85c\ub3c4 \ubc1c\uae09\uac00\ub2a5
//\ub9ac\uc5bc\uc801\uc6a9\uc2dc \ubc18\ub4dc\uc2dctrue\ub85c \ubcc0\uacbd\ud574\uc57c\ud568..
boolean is_insaUser = false;

//\uc0ac\uc6a9\uc790 \uc2e0\ubd84\ud655\uc778 \uc815\ubcf4
String m_ID = null;		// form name = id
String m_REGNO = null;	// form name = regno
String m_pw = null; // form name = certpass


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

		//\uc0ac\uc6a9\uc790\ube44\ubc00\ubc88\ud638 \uad00\ub9ac\ub97c \uc704\ud574
		m_pw = m_IP.getParameter("pw");


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
     
//*********************************************************
//  \uc0ac\uc6a9\uc790\uac00 \uc785\ub825\ud55c \uc544\uc774\ub514(\uc0ac\ubc88)\uc73c\ub85c \ubc1c\uae09\uc815\ubcf4\uac00 \uc788\ub294\uc9c0 \ud655\uc778
//*********************************************************


Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

String isCert = "Y" ; //\ubc1c\uae09\uc720\ubb34
String CertGb = "\ubc1c\uae09" ;
int rsCnt = 0 ;

// printf("test");	
try {
	
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();

	rs = stmt.executeQuery("select count(userid) as cnt from ldap_info where userid='" + m_ID + "' ");
	//\uc0ac\uc6a9\uc790\uc544\uc774\ub514\ub85c \uce74\uc6b4\ud2b8\ud558\uc5ec 0\ubcf4\ub2e4 \ud06c\uba74 \uc7ac\ubc1c\uae09\ud558\uace0 0\uc774\uba74 \ubc1c\uae09
	
	while( rs.next() ) {
		rsCnt = rs.getInt("cnt");
	}
	
	if (rsCnt == 0){
		isCert = "N";
		CertGb = "\uc2e0\uaddc \ubc1c\uae09";
	}else{
		isCert = "Y";
		CertGb = "\uc7ac\ubc1c\uae09";
	}
	
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}

//\uc0ac\uc6a9\uc790\uc815\ubcf4\ub97c \uc778\uc0ac\uc815\ubcf4\uc5d0\uc11c \uac00\uc9c0\uace0 \uc640\uc11c
//\ud574\ub2f9 \uc0ac\uc6a9\uc790\ub9cc \uc778\uc99d\uc11c \ubc1c\uae09 \ubc1b\uac8c \ud560\uc9c0 \uccb4\ud06c
// false : \uc778\uc0ac\uc815\ubcf4\uc678 \uc785\ub825\ud55c \uc784\uc758\uc758 \uc544\uc774\ub514\ub85c\ub3c4 \ubc1c\uae09\uac00\ub2a5

if (is_insaUser) {
	Context insaIc = new InitialContext();
	DataSource insaDs = (DataSource) insaIc.lookup("java:comp/env/jdbc/INSA");
	ResultSet insaRs = null;

	Connection insaConn = null;
	Statement insaStmt = null;

	String m_userName = null;
	int userInsaCnt = 0 ;

	try{
		insaConn = insaDs.getConnection();
		//Creat Query and get results
		insaStmt = insaConn.createStatement();
		insaRs = insaStmt.executeQuery("SELECT count(*) as cnt FROM IRIS.V_INSA where empno='" + m_ID + "' ");
		
		//List results
		while(insaRs.next()) {
			userInsaCnt =  insaRs.getInt("cnt");
		}

		if (userInsaCnt == 0){
			//\uc778\uc0acDB\uc5d0 \uc0ac\uc6a9\uc790 \uc815\ubcf4\uac00 \uc5c6\uc744 \ub54c
			//\uc785\ub825\ud558\uc2e0 \uc0ac\ubc88\uc5d0 \ub300\ud55c \uc815\ubcf4\uac00 \uc778\uc0ac\uc815\ubcf4\uc5d0\ub294 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.

			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('\uc785\ub825\ud558\uc2e0 \uc0ac\ubc88("+ m_ID +")\uc5d0 \ub300\ud55c \uc815\ubcf4\uac00 \uc778\uc0ac\uc815\ubcf4\uc5d0\ub294 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.');");
			writer.println("location.href='ini_certNew.jsp'");
		    writer.println("</script>");
			writer.flush();
			return;


		}else{
		
		}

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		insaRs.close();
		insaConn.close();
	}

} // \uc778\uc0ac\uc815\ubcf4 \uccb4\ud06c \uc720\ubb34 end


//\uc778\uc99d\uc11c \ud3d0\uae30 \ud558\uae30
if (m_How.equals("certRevoke")) {
	//\uc778\uc99d\uc11c \ud3d0\uae30\ub97c \uc704\ud574 
	//Step1 : \ud3d0\uae30\ud560 \uc778\uc99d\uc11c\uac00 \uc788\ub294\uc9c0 \uccb4\ud06c\ud55c\ub2e4.
	//        LDAP_INFO\uc5d0\uc11c \uac80\uc0c9\ud558\uc5ec count\uac00 0\uc774\uba74 \ubc1c\uae09\ud398\uc774\uc9c0\ub85c
	//                               count\uac00 0\uc774\uc0c1\uc774\uba74 \ud3d0\uae30 \ud504\ub85c\uc138\uc2a4
	Context rvkIc = new InitialContext();
	DataSource rvkDs = (DataSource) rvkIc.lookup("java:comp/env/jdbc/INICA");
	ResultSet rvkRs = null;

	Connection rvkConn = null;
	Statement rvkStmt = null;

	int rvkCertCnt = 0 ;
	int rvkPwdUCnt = 0 ;

	try{
		rvkConn = rvkDs.getConnection();
		//Creat Query and get results
		rvkStmt = rvkConn.createStatement();
		rvkRs = rvkStmt.executeQuery("select count(userid) as cnt from ldap_info where userid='" + m_ID + "' ");
		
		//List results
		while(rvkRs.next()) {
			rvkCertCnt =  rvkRs.getInt("cnt");
		}

		if (rvkCertCnt == 0){
			//LDAP_INFO \uc778\uc99d\uc11c \uc815\ubcf4\uac00 \uc5c6\uc744 \ub54c
			//\ud3d0\uae30\ud574\uc57c\ud560 \uc778\uc99d\uc11c\uac00 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.

			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('\uc785\ub825\ud558\uc2e0 \uc0ac\ubc88("+ m_ID +")\uc73c\ub85c \ud3d0\uae30\ud574\uc57c \ud560 \uc778\uc99d\uc11c\uac00 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.\uc778\uc99d\uc11c \ubc1c\uae09\ud398\uc774\uc9c0\uc5d0\uc11c \uc778\uc99d\uc11c\ub97c \ubc1c\uae09\ubc1b\uc544 \uc8fc\uc2ed\uc2dc\uc624');");
			writer.println("location.href='ini_certNew.jsp'");
		    writer.println("</script>");
			writer.flush();
			return;


		}
			
		//Step2 : \uc785\ub825\ud55c \uc0ac\uc6a9\uc790\uc758 \uc0ac\ubc88\uacfc PWD\uac00 \uc874\uc7ac\ud558\ub294\uc9c0 \uccb4\ud06c\ud55c\ub2e4.
		//Step2 : \uc785\ub825\ud55c \uc0ac\uc6a9\uc790\uc758 \uc0ac\ubc88\uacfc PWD\uac00 \uc874\uc7ac\ud558\ub294\uc9c0 \uccb4\ud06c\ud55c\ub2e4.
		rvkRs = rvkStmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + m_ID + "' and userpwd = '" + getBase64Data(getHashValue(m_pw)) + "' ");
		
		//List results
		while(rvkRs.next()) {
			rvkPwdUCnt =  rvkRs.getInt("cnt");
		}

		if (rvkPwdUCnt == 0){
			//LDAP_INFO \uc778\uc99d\uc11c \uc815\ubcf4\uac00 \uc5c6\uc744 \ub54c
			//\ud3d0\uae30\ud574\uc57c\ud560 \uc778\uc99d\uc11c\uac00 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.

			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\uac00 \uc798\ubabb\ub418\uc5c8\uc2b5\ub2c8\ub2e4.');");
			writer.println("location.href='ini_certRevoke.jsp'");
		    writer.println("</script>");
			writer.flush();
			return;


		}

		

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		rvkRs.close();
		rvkStmt.close();
		rvkConn.close();
	}


	

}


    out.write(_jsp_string4, 0, _jsp_string4.length);
    
	if (m_IniErrCode == null) {
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) *** Success ***\n");
	} else {
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) *** Fail : " + m_IniErrCode + " ***\n");
		response.sendRedirect("err.jsp?id=" + m_ID + "&how=" + m_How + "&code=" + m_IniErrCode + "&msg=" + m_IniErrMsg);
		return;
	}

    out.write(_jsp_string5, 0, _jsp_string5.length);
     try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} 
    out.write(_jsp_string6, 0, _jsp_string6.length);
    out.print((m_ID));
    out.write(_jsp_string7, 0, _jsp_string7.length);
    out.print((m_pw));
    out.write(_jsp_string8, 0, _jsp_string8.length);
    out.print((m_REGNO));
    out.write(_jsp_string9, 0, _jsp_string9.length);
    out.print((m_certserial));
    out.write(_jsp_string10, 0, _jsp_string10.length);
    out.print((m_ID));
    out.write(_jsp_string11, 0, _jsp_string11.length);
    out.print((m_ID));
    out.write(_jsp_string12, 0, _jsp_string12.length);
     try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} 
    out.write(_jsp_string13, 0, _jsp_string13.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/ini_certRevoke_checkid.jsp"), -8655691142680844974L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/iniplugin_init.jsp"), 6054584604837940715L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_init.jsp"), 1658657925408701595L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_db_check.jsp"), 7639038416292097162L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_userSet.jsp"), 3326411726199365788L, true);
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

  private final static char []_jsp_string4;
  private final static char []_jsp_string13;
  private final static char []_jsp_string3;
  private final static char []_jsp_string2;
  private final static char []_jsp_string6;
  private final static char []_jsp_string11;
  private final static char []_jsp_string7;
  private final static char []_jsp_string9;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string10;
  private final static char []_jsp_string5;
  private final static char []_jsp_string8;
  private final static char []_jsp_string12;
  static {
    _jsp_string4 = "\r\n\r\n\r\n\r\n\r\n\n\r\n\r\n".toCharArray();
    _jsp_string13 = "\n</body>\n</html>".toCharArray();
    _jsp_string3 = "\n\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\n\n\n\n\n\n\n".toCharArray();
    _jsp_string6 = "\n\n<div id=\"header\"> \n	<!-- MAIN MENU START -->\n	<script language=\"javascript\">dspMainMenu();</script>\n	<!-- MAIN MENU END -->\n</div>\n\n<div style=\"height:10px;\"></div>\n<div id=\"subtop\">\n	<ul class=\"subtoptxt\">\n		<li class=\"toptxtcon\">\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\uc548\ub0b4</li>\n		<li class=\"toptxtcon01\">\uc778\uc99d\uc11c \ubc1c\uae09</li>\n		<li class=\"toptxtcon01\" style=\"text-decoration:underline;\">\uc778\uc99d\uc11c \ud3d0\uae30</li>\n		<li class=\"toptxtcon01\">\uc778\uc99d\uc11c \uad00\ub9ac</li>\n	</ul>\n</div>\n<form name=\"sendForm\" method=\"post\" action=\"./ini_certRevoke_send.jsp\">\n	<input type=\"hidden\" name=\"INIpluginData\" value=\"\" />\n</form>\n<form name=\"readForm\" onsubmit=\"return CheckSendForm(this, sendForm);\">\n	<input type=\"hidden\" name=\"id\" value=\"".toCharArray();
    _jsp_string11 = "</b>\ub2d8\uc758 \uc778\uc99d\uc11c\ub97c \ud3d0\uae30\ud558\uace0\uc790 \ud569\ub2c8\ub2e4.</li>\n				<li class=\"sbtextbg2\" style=\"padding-top:10px; padding-left:21px;\"><img src=\"img/bullet_list.gif\" align=\"center\"> \uc0ac\ubc88(<b class=\"txblue\"> ".toCharArray();
    _jsp_string7 = "\">\n	<input type=\"hidden\" name=\"pw\" value=\"".toCharArray();
    _jsp_string9 = "\" />\n	<input type=\"hidden\" name=\"serialno\" value=\"".toCharArray();
    _jsp_string0 = "\n\n\n\n\n\n\n\n".toCharArray();
    _jsp_string1 = "\n\n".toCharArray();
    _jsp_string10 = "\" />\n<div id=\"sub2issue\">\n	<ul>\n		<li><img src=\"img/subtitle0102.gif\" alt=\"\uc778\uc99d\uc11c\ud3d0\uae30_\uc778\uc99d\uc11c \ubd84\uc2e4(\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\ub97c \uc78a\uc5b4\ubc84\ub9b0 \uacbd\uc6b0, \uc774\uc6a9\ud558\ub294 \ucef4\ud4e8\ud130\uac00 \ubcc0\uacbd\ub41c \uacbd\uc6b0, \uc778\uc99d\uc11c\uac00 \uc0ad\uc81c \ub41c \uacbd\uc6b0)\uc2dc \ub2e4\uc2dc \uc778\uc99d\uc11c\ub97c \ubc1c\uae09\ubc1b\n\uc73c\uc2dc\uba74 \uc0ac\uc6a9 \uac00\ub2a5\ud569\ub2c8\ub2e4.\"></li>\n		<li class=\"stitle\"><img src=\"img/subtitle0205.gif\" alt=\"\uc778\uc99d\uc11c\ud3d0\uae30_\uc9c4\ud589\"></li>\n		<li class=\"box\">\n			<ul>\n				<li class=\"sbtextbg\"> - <b class=\"txblue\">".toCharArray();
    _jsp_string5 = "\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\" />\n<title>\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\uc548\ub0b4</title>\n	<link rel=\"stylesheet\" type=\"text/css\" href=\"css/import.css\" />\n	<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\" />\n\n	<script type=\"text/javascript\" src=\"js/jquery-1.7.2.min.js\"></script>\n	<script type=\"text/javascript\" src=\"js/jquery.flexslider-min.js\"></script>\n    <script type=\"text/javascript\" src=\"js/jquery.als-1.1.min.js\"></script>\n	<script type=\"text/javascript\" src=\"js/common.js\"></script>\n\n	<script type=\"text/javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\n	<script type=\"text/javascript\" src=\"/initech/plugin/INIutil.js\"></script>\n\n	<script language=\"javascript\">\n	var bAutoSubmit = true;\n	function CheckSendForm(readForm, sendForm)\n	{\n		bAutoSubmit = false;\n\n		if (EncForm2(readForm, sendForm)) {\n			ViewMsg();\n			sendForm.submit();\n			return false;\n		}\n		alert(\"\uc778\uc99d\uc11c \ud3d0\uae30\uc2e0\uccad\uc774 \ucde8\uc18c \ub418\uc5c8\uc2b5\ub2c8\ub2e4.\");\n		return false;\n	}\n\n	function ViewMsg()\n	{\n		var msg = \"\uc778\uc99d\uc11c\ubc84\uc5d0\uc11c \uc778\uc99d\uc11c\ub97c \ud3d0\uae30\uc911 \uc785\ub2c8\ub2e4. \uc7a0\uc2dc\ub9cc \uae30\ub2e4\ub9ac\uc2ed\uc2dc\uc694.\";\n		setMsg(msg, 0, 200);\n		showMsg();\n	}\n\n	function AutoSubmit()\n	{\n		if (bAutoSubmit)\n			return CheckSendForm(readForm, sendForm);\n	}\n\n	function AutoRequest()\n	{\n		setTimeout(\"AutoSubmit()\", 5000);\n	}\n	</script>\n\n<!--[if IE 6]>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie6.css\">\n<![endif]-->\n<!--[if IE 7]>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie7.css\">\n<![endif]-->\n</head> \n<body onload=\"defaultStatus='';\">\n".toCharArray();
    _jsp_string8 = "\">\n	<input type=\"hidden\" name=\"regno\" value=\"".toCharArray();
    _jsp_string12 = " </b>)(\uc73c)\ub85c \ubc1c\uae09\ubc1b\uc740 \uc778\uc99d\uc11c\ub97c \ud3d0\uae30\ud558\uc2dc\uaca0\uc2b5\ub2c8\uae4c?</li>\n				<!-- <li class=\"sbtextbg2\" style=\"padding-top:10px; padding-left:21px;\"><img src=\"img/bullet_list.gif\" align=\"center\"> \uc774 \ud398\uc774\uc9c0\ub294 1\ucd08 \ud6c4 <a href=\"sub01_02_02.html\">\ub2e4\uc74c\ud398\uc774\uc9c0\ub85c \uc790\ub3d9\uc73c\ub85c \uc774\ub3d9</a>\ub429\ub2c8\ub2e4.</li> -->\n				<li class=\"dotted1\"></li>\n				<li style=\"float:right; padding:8px 22px 0px 0px;\"></li>\n				<li class=\"sbtextbg2\" style=\"padding-top:10px; text-align:center;\">\n					<input type=\"image\" src=\"img/btn_issue03.gif\" align=\"center\">\n				</li>\n				<li class=\"sbtextbg2\">&nbsp;</li>\n			</ul>\n		</li>\n		\n	</ul>\n	<div style=\"height:90px;\"></div>\n</div>\n</form>\n\n<!-- COPYRIGHT START -->\n<script language=\"javascript\">dspCopyRight();</script>\n<!-- COPYRIGHT END -->\n\n".toCharArray();
  }
}
