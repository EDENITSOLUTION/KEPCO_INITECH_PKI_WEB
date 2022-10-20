/*
 * JSP generated by Resin Professional 4.0.38 (built Tue, 17 Dec 2013 09:49:45 PST)
 */

package _jsp._certcenter64._inica70;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.util.Date.*;
import java.util.Calendar.*;
import java.text.SimpleDateFormat;
import java.lang.*;
import java.lang.String.*;
import java.text.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
import java.security.cert.X509Certificate;
import com.initech.iniplugin.*;

public class _ini_0manage_0insa__jsp extends com.caucho.jsp.JavaPage
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







          

  //*********************************************************
  // getConnection
  //*********************************************************
  public Connection getConnection()
  {
  		Connection conn = null;
  		
  		
  			
  	  
  		try
  		{
  			Properties props = new Properties();
  			props.put("connection.driver", "oracle.jdbc.driver.OracleDriver");
  			props.put("connection.url", "jdbc:oracle:thin:@10.180.2.67:1521:INICA");
  			props.put("user", "ra");
  			props.put("password", "kepcora");
  	
  			Class.forName(props.getProperty("connection.driver"));
  	    conn = DriverManager.getConnection(props.getProperty("connection.url"), props);		  
  	  }catch(Exception e){
  	  	e.printStackTrace();
  	  }

  	  
      return conn;
  }



  public String closeDB(ResultSet rs, Statement stmt, Connection conn, Statement stmtCount)
  {
      String result = "";
      try{
        if(rs!=null)
  	      rs.close();
  	      result +=" rs close ok";
  	  }catch(Exception e1){
  	    e1.printStackTrace();
  	  }
  	  
  	  try{
  	    if(stmt!=null)
  	    stmt.close();
  	    result +=" stmt close ok";
  	  }catch(Exception e1){
  	    e1.printStackTrace();
  	  }

  	  try{
  	    if(stmtCount!=null)
  	      stmtCount.close();
  	    result +=" stmtCount close ok";
  	  }catch(Exception e1){
  	    e1.printStackTrace();
  	  }
  	  
  	  
  	  
  	  
  	   try{
  	   
  	    if(conn!=null)
  	    conn.close();
  	    result +=" conn close ok";
  	  }catch(Exception e1){
  	    e1.printStackTrace();
  	  }	  
  	  
      return result;
  }


  public String do_protocol_error()
  {
    StringBuffer buffer = new StringBuffer();
    
      	buffer.append("<result_code>1</result_code>");   
      	buffer.append("<result_msg>inavlid protocol</result_msg>");
  	    buffer.append("</response>");   
  	    
  	return buffer.toString();    

  }


  public String nullConvefrt(String str)
  {
  	if (str == null) {
  		return "";
  	} else if ("".equals(str.trim())) {
  		return "";
  	}

  	return str;
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
boolean m_bEncrypt = true;

//\uc0ac\uc6a9\uc790\uc815\ubcf4\ub97c \uc778\uc0ac\uc815\ubcf4\uc5d0\uc11c \uac00\uc9c0\uace0 \uc640\uc11c
//\ud574\ub2f9 \uc0ac\uc6a9\uc790\ub9cc \uc778\uc99d\uc11c \ubc1c\uae09 \ubc1b\uac8c \ud560\uc9c0 \uccb4\ud06c
// false : \uc778\uc0ac\uc815\ubcf4\uc678 \uc785\ub825\ud55c \uc784\uc758\uc758 \uc544\uc774\ub514\ub85c\ub3c4 \ubc1c\uae09\uac00\ub2a5
//\ub9ac\uc5bc\uc801\uc6a9\uc2dc \ubc18\ub4dc\uc2dctrue\ub85c \ubcc0\uacbd\ud574\uc57c\ud568..
boolean is_insaUser = true;

//String userPwdSendURL = "http://10.


//\uc0ac\uc6a9\uc790 \uc2e0\ubd84\ud655\uc778 \uc815\ubcf4
String m_ID = null;		// form name = id
String m_REGNO = null;	// form name = regno
String m_pw = null; // form name = certpass

//SMS \uc778\uc99d\ucf54\ub4dc
//String m_smschk = null; //\ubc1c\uae09SMS\uc778\uc99d\ucf54\ub4dc
String m_sms = null; //\uc785\ub825SMS\uc778\uc99d\ucf54\ub4dc
String m_tmid = null;//SMS\uc778\uc99d\uc744 \uc704\ud55c \ud0c0\uc784 \uc544\uc774\ub514

//\ubc1c\uae09\uc2dc \uae30\uc874 \uc778\uc99d\uc11c \ud3d0\uae30 \ud6c4 \ub2e4\uc2dc \ubc1c\uae09\ud558\ub294 \ud504\ub85c\uc138\uc2a4 \uc635\uc158
String m_strBrg = null ;



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
String m_OU = "\uc815\ubcf4\uae30\uc220\ucc98";	//\uc815\ubcf4\uae30\uc220\ucc98
String m_O = "\ud55c\uad6d\uc804\ub825\uacf5\uc0ac";
String m_L = "\uc11c\uc6b8\ud2b9\ubcc4\uc2dc";
String m_C = "KR";
String m_POLICY = "71"; // 20180718 njjang \ucd94\uac00

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


		//m_smschk = m_IP.getParameter("smschk");
		m_sms = m_IP.getParameter("sms");
		m_tmid = m_IP.getParameter("tmid");

		m_strBrg = m_IP.getParameter("strBrg");

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
			m_OU = "\uc815\ubcf4\uae30\uc220\ucc98"; //\uc815\ubcf4\uae30\uc220\ucc98
			
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
//      \uad00\ub9ac\uc790 \uc138\uc158 \uccb4\ud06c
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
String admin2Login = (String)session.getAttribute("admin2Login");
if (adminLogin == null && admin2Login == null) {
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('\uad00\ub9ac\uc790 \ub85c\uadf8\uc778 \uc815\ubcf4\uac00 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.');");
	writer.println("location.href='ini_manage_cert_login.jsp'");
	writer.println("</script>");
	writer.flush();
	return;
}

Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

// \ud398\uc774\uc9d5
final int ROWSIZE = 15;
final int BLOCK = 10;
int pageIndex = 1;
if (request.getParameter("pageIndex") != null) {
	try {
		pageIndex = Integer.parseInt(request.getParameter("pageIndex"));
	} catch (Exception e) {
	}
}

int start = (pageIndex * ROWSIZE) - (ROWSIZE - 1);
int end = (pageIndex * ROWSIZE);
int totalPage = 0;
int startPage = ((pageIndex - 1) / BLOCK * BLOCK) + 1;
int endPage = ((pageIndex - 1) / BLOCK * BLOCK) + BLOCK;
int total = 0;

////////////////////////////////////////////////////////////////////////////

String searchKeyfield = request.getParameter("searchKeyfield");
String searchKeyword = request.getParameter("searchKeyword");

if (searchKeyfield == null || searchKeyfield.equals("")) {
	searchKeyfield = "";
}

if (searchKeyword == null || searchKeyword.equals("")) {
	searchKeyword = "";
}

String queryString = "searchKeyfield="+searchKeyfield+"&searchKeyword="+searchKeyword;

////////////////////////////////////////////////////////////////////////////


try {
	conn = ds.getConnection();
	stmt = conn.createStatement();

	String strQuery = "" ;
	strQuery = strQuery + "		SELECT  COUNT(*) " ;
	strQuery = strQuery + "		  FROM  ( " ;
	strQuery = strQuery + "				SELECT  *" ;
	strQuery = strQuery + "				  FROM  V_INSA A" ;
	strQuery = strQuery + "			 LEFT JOIN  LDAP_INFO B ON (A.EMPNO = B.USERID AND B.STATUS ='V')" ;
	strQuery = strQuery + "				 WHERE  1=1" ;
	strQuery = strQuery + "			)  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		if (!"".equals(searchKeyfield)) {
			strQuery = strQuery + " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
		} else {
			strQuery = strQuery + " AND (C.EMPNO LIKE '%" + searchKeyword + "%' OR C.NAME LIKE '%" + searchKeyword + "%')" ;
		}
	}

	rs = stmt.executeQuery(strQuery);
	rs.next();
    total = rs.getInt(1);
	
	totalPage = (int)Math.ceil(total / ROWSIZE);
	if (endPage > totalPage) {
		endPage = totalPage;
	}

	strQuery = "";
	strQuery = strQuery + "SELECT X.* FROM (" ;
	strQuery = strQuery + "		SELECT  C.EMPNO " ;
	strQuery = strQuery + "			 ,  C.NAME " ;
	strQuery = strQuery + "			 ,  C.DEPTNO " ;
	strQuery = strQuery + "			 ,  C.MAILNO " ;
	strQuery = strQuery + "			 ,  C.CELLNO " ;
	strQuery = strQuery + "			 ,  C.LEVELNM " ;
	strQuery = strQuery + "			 ,  TO_CHAR(C.ISSUEDATE,'YYYY-MM-DD') AS ISSUEDATE" ;
	strQuery = strQuery + "			 ,  TO_CHAR(C.EXPIREDATE,'YYYY-MM-DD') AS EXPIREDATE " ;
	strQuery = strQuery + "			 ,  ROWNUM R " ;
	strQuery = strQuery + "			 ,  RANK() OVER (ORDER BY C.NAME ASC) AS RANKING " ;
	strQuery = strQuery + "		 FROM  ( " ;
	strQuery = strQuery + "				SELECT  A.EMPNO" ;
	strQuery = strQuery + "					 ,  A.NAME" ;
	strQuery = strQuery + "					 ,  A.DEPTNO" ;
	strQuery = strQuery + "					 ,  A.MAILNO" ;
	strQuery = strQuery + "					 ,  A.CELLNO" ;
	strQuery = strQuery + "					 ,  A.LEVELNM" ;
	strQuery = strQuery + "					 ,  B.ISSUEDATE" ;
	strQuery = strQuery + "					 ,  B.EXPIREDATE" ;
	strQuery = strQuery + "				  FROM  V_INSA A" ;
	strQuery = strQuery + "			 LEFT JOIN  LDAP_INFO B ON (A.EMPNO = B.USERID AND B.STATUS ='V')" ;
	strQuery = strQuery + "				 WHERE  1=1" ;
	strQuery = strQuery + "			   )  C WHERE 1=1" ;
	if (!"".equals(searchKeyword)) {
		if (!"".equals(searchKeyfield)) {
			strQuery = strQuery + " AND " + searchKeyfield + " LIKE '%" + searchKeyword + "%' " ;
		} else {
			strQuery = strQuery + " AND (C.EMPNO LIKE '%" + searchKeyword + "%' OR C.NAME LIKE '%" + searchKeyword + "%')" ;
		}
	}
	strQuery = strQuery + "  ORDER BY  C.NAME ASC " ; 
	strQuery = strQuery + ") X " ; 
	strQuery = strQuery + "WHERE X.RANKING BETWEEN "+ (start-1) +" and "+ end ; 
	//out.print(strQuery);
	rs = stmt.executeQuery(strQuery);

    out.write(_jsp_string3, 0, _jsp_string3.length);
     if (admin2Login != null) { 
    out.write(_jsp_string4, 0, _jsp_string4.length);
     } else { 
    out.write(_jsp_string5, 0, _jsp_string5.length);
     } 
    out.write(_jsp_string6, 0, _jsp_string6.length);
    if (searchKeyfield.equals("C.EMPNO")) {
    out.write(_jsp_string7, 0, _jsp_string7.length);
    }
    out.write(_jsp_string8, 0, _jsp_string8.length);
    if (searchKeyfield.equals("C.NAME")) {
    out.write(_jsp_string7, 0, _jsp_string7.length);
    }
    out.write(_jsp_string9, 0, _jsp_string9.length);
    out.print((searchKeyword));
    out.write(_jsp_string10, 0, _jsp_string10.length);
    out.print((pageIndex));
    out.write('&');
    out.print((queryString));
    out.write(_jsp_string11, 0, _jsp_string11.length);
    out.print((total));
    out.write(_jsp_string12, 0, _jsp_string12.length);
    
int no = (total - (ROWSIZE * (pageIndex-1)));
while (rs.next()) {		

    out.write(_jsp_string13, 0, _jsp_string13.length);
    out.print((no));
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print((rs.getString("EMPNO")));
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print((rs.getString("NAME")));
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print(((rs.getString("LEVELNM") != null ? rs.getString("LEVELNM") : "")));
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print(((rs.getString("ISSUEDATE") != null ? rs.getString("ISSUEDATE") : "")));
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print(((rs.getString("EXPIREDATE") != null ? rs.getString("EXPIREDATE") : "")));
    out.write(_jsp_string15, 0, _jsp_string15.length);
    out.print((rs.getString("EMPNO")));
    out.write(_jsp_string16, 0, _jsp_string16.length);
    
	no--;
}

    out.write(_jsp_string17, 0, _jsp_string17.length);
     if (total < 1) { 
    out.write(_jsp_string18, 0, _jsp_string18.length);
     } 
    out.write(_jsp_string19, 0, _jsp_string19.length);
     if (pageIndex > BLOCK) { 
    out.write(_jsp_string20, 0, _jsp_string20.length);
    out.print((queryString));
    out.write(_jsp_string21, 0, _jsp_string21.length);
    out.print(((startPage-1)));
    out.write('&');
    out.print((queryString));
    out.write(_jsp_string22, 0, _jsp_string22.length);
     } 
    out.write(_jsp_string17, 0, _jsp_string17.length);
     
for (int i = startPage; i <= endPage; i++ ) {
	if (i == pageIndex) {

    out.write(_jsp_string23, 0, _jsp_string23.length);
    out.print((i));
    out.write(_jsp_string24, 0, _jsp_string24.length);
    
	} else {

    out.write(_jsp_string25, 0, _jsp_string25.length);
    out.print((i));
    out.write('&');
    out.print((queryString));
    out.write(_jsp_string26, 0, _jsp_string26.length);
    out.print((i));
    out.write(_jsp_string27, 0, _jsp_string27.length);
    
	}
}

    out.write(_jsp_string17, 0, _jsp_string17.length);
     if (endPage < totalPage) { 
    out.write(_jsp_string28, 0, _jsp_string28.length);
    out.print(((endPage+1)));
    out.write('&');
    out.print((queryString));
    out.write(_jsp_string29, 0, _jsp_string29.length);
    out.print((totalPage));
    out.write('&');
    out.print((queryString));
    out.write(_jsp_string30, 0, _jsp_string30.length);
     } 
    out.write(_jsp_string31, 0, _jsp_string31.length);
    
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}

    out.write(_jsp_string32, 0, _jsp_string32.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/ini_manage_insa.jsp"), -5303138122229148179L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/iniplugin_init.jsp"), -1077120484095086999L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/inica70_init.jsp"), 4796767119961629043L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/func.jsp"), -134361262012752146L, true);
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

  private final static char []_jsp_string1;
  private final static char []_jsp_string3;
  private final static char []_jsp_string14;
  private final static char []_jsp_string12;
  private final static char []_jsp_string26;
  private final static char []_jsp_string30;
  private final static char []_jsp_string21;
  private final static char []_jsp_string5;
  private final static char []_jsp_string31;
  private final static char []_jsp_string16;
  private final static char []_jsp_string9;
  private final static char []_jsp_string7;
  private final static char []_jsp_string29;
  private final static char []_jsp_string8;
  private final static char []_jsp_string25;
  private final static char []_jsp_string23;
  private final static char []_jsp_string15;
  private final static char []_jsp_string6;
  private final static char []_jsp_string0;
  private final static char []_jsp_string32;
  private final static char []_jsp_string19;
  private final static char []_jsp_string13;
  private final static char []_jsp_string27;
  private final static char []_jsp_string22;
  private final static char []_jsp_string17;
  private final static char []_jsp_string11;
  private final static char []_jsp_string10;
  private final static char []_jsp_string18;
  private final static char []_jsp_string28;
  private final static char []_jsp_string20;
  private final static char []_jsp_string4;
  private final static char []_jsp_string2;
  private final static char []_jsp_string24;
  static {
    _jsp_string1 = "\r\n\n".toCharArray();
    _jsp_string3 = "\r\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n<head>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\" />\r\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=11\"/>\r\n<title>\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\uc548\ub0b4</title>\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/import.css\" />\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\" />\r\n\r\n<script type=\"text/javascript\" src=\"js/jquery-1.7.2.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"js/jquery.flexslider-min.js\"></script>\r\n<script type=\"text/javascript\" src=\"js/jquery.als-1.1.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"js/common.js\"></script>\r\n\r\n<script type=\"text/javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\r\n<script type=\"text/javascript\" src=\"/initech/plugin/INIutil.js\"></script>\r\n<script language=\"javascript\">\r\nfunction initPass(empNo) {\r\n	var sendForm = document.sendForm;\r\n	var readForm = document.readForm;\r\n\r\n	if (!confirm('\uc815\ub9d0\ub85c \ucd08\uae30\ud654\ud558\uc2dc\uaca0\uc2b5\ub2c8\uae4c?'))\r\n	{\r\n		return;\r\n	}\r\n\r\n	readForm.empNo.value = empNo;\r\n\r\n	if (EncForm2(readForm, sendForm))\r\n	{\r\n\r\n		sendForm.submit();\r\n		return false;\r\n	}\r\n\r\n	return false;\r\n}\r\n\r\nfunction CheckSendForm() {\r\n\r\n	var readForm = document.readForm;\r\n	readForm.target=\"_self\";\r\n	//var sendForm = document.sendForm;\r\n\r\n	//if (EncForm2(readForm, sendForm)) {\r\n		//ViewMsg();\r\n		readForm.submit();\r\n		//return false;\r\n	//}\r\n	return false;\r\n}\r\nfunction ViewMsg()\r\n{\r\n	var msg = \"\uc870\ud68c \ud655\uc778 \uc911 \uc785\ub2c8\ub2e4. \uc7a0\uc2dc\ub9cc \uae30\ub2e4\ub9ac\uc2ed\uc2dc\uc694.\";\r\n	setMsg(msg, 0, 200);\r\n	showMsg();\r\n}\r\n\r\n</script>\r\n<style type=\"text/css\">\r\n.wTable {\r\n	width:950px;\r\n	border-top : solid 1px #c5c5c5;\r\n	border-left : solid 1px #c5c5c5;\r\n	margin:0 auto;\r\n}\r\n.wTableTdHeader {\r\n	border-right : solid 1px #c5c5c5;\r\n	border-bottom : solid 1px #c5c5c5;\r\n	text-align : center;\r\n	font-weight : bold;\r\n	background-color : #eeeeee ;\r\n	padding :10px 4px;\r\n}\r\n.wTableTdCell {\r\n	border-right : solid 1px #c5c5c5;\r\n	border-bottom : solid 1px #c5c5c5;\r\n	font-weight : normal;\r\n	background-color : #ffffff ;\r\n	padding :10px 4px;\r\n}\r\n.wTableTdSearch {\r\n	border-right : solid 1px #c5c5c5;\r\n	border-bottom : solid 1px #c5c5c5;\r\n	font-weight : normal;\r\n	background-color : #ffffff ;\r\n	padding : 5px;\r\n}\r\n.wTableTdSearch1 {\r\n	border-right : solid 1px #c5c5c5;\r\n	\r\n	font-weight : normal;\r\n	background-color : #ffffff ;\r\n	padding : 5px;\r\n}\r\n.paging_box {\r\n	display:table; \r\n	background:#F6F6F6; \r\n	margin:0 auto; \r\n	border:1px solid #999;\r\n	border-radius:5px;\r\n\r\n}\r\n.paging_box > li {\r\n	float:left;\r\n	font-size:16px;\r\n	color:#000;\r\n	font-weight:bold;\r\n	padding:10px 15px 9px 15px;\r\n	border-right:1px solid #999;\r\n}\r\n.paging_box > li:last-child {\r\n	border-right:none;\r\n}\r\n.tac {text-align:center;}\r\n\r\n\r\n</style>\r\n\r\n<!--[if IE 6]>\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie6.css\">\r\n<![endif]-->\r\n<!--[if IE 7]>\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie7.css\">\r\n<![endif]-->\r\n\r\n\r\n</head>\r\n<body>\r\n<div id=\"header\"> \r\n	<!-- MAIN MENU START -->\r\n	<script language=\"javascript\">dspMainMenu();</script>\r\n	<!-- MAIN MENU END -->\r\n</div>\r\n<div style=\"height:10px;\"></div>\r\n<div id=\"subtop\">\r\n	<ul class=\"subtoptxt\">\r\n		<li class=\"toptxtcon\">\uc778\uc99d\uc13c\ud130 \uad00\ub9ac\uc790</li>\r\n		".toCharArray();
    _jsp_string14 = "</td>\r\n			<td class=\"wTableTdCell tac\">".toCharArray();
    _jsp_string12 = "\uac74</p>\r\n<table cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\" border=\"0\" class=\"wTable\">\r\n	<tr>\r\n		<td class=\"wTableTdHeader\" scope=\"col\">NO</td>\r\n		<td class=\"wTableTdHeader\" scope=\"col\">\uc0ac\ubc88</td>\r\n		<td class=\"wTableTdHeader\" scope=\"col\">\uc131\uba85</td>\r\n		<td class=\"wTableTdHeader\" scope=\"col\">\uc9c1\uae09</td>\r\n		<td class=\"wTableTdHeader\" scope=\"col\">\uc778\uc99d\uc11c<br/>\ubc1c\uae09\uc77c</td>\r\n		<td class=\"wTableTdHeader\" scope=\"col\">\uc778\uc99d\uc11c<br/>\ub9cc\ub8cc\uc77c</td>\r\n		<td class=\"wTableTdHeader\" scope=\"col\">\ube44\ubc00\ubc88\ud638<br/>\ucd08\uae30\ud654</td>\r\n	</tr>\r\n".toCharArray();
    _jsp_string26 = "\">".toCharArray();
    _jsp_string30 = "\">\ub9c8\uc9c0\ub9c9</a></li>\r\n".toCharArray();
    _jsp_string21 = "\">\ucc98\uc74c</a></li>\r\n<li><a href=\"?pageIndex=".toCharArray();
    _jsp_string5 = "\r\n		<li class=\"toptxtcon01\" style=\"width:150px;text-align:left;\"><a href=\"ini_manage_cert.jsp\">\uc778\uc99d\uc11c \ubc1c\uae09 \ub0b4\uc5ed \uc870\ud68c</a></li>\r\n		<li class=\"toptxtcon01\"><a href=\"ini_manage_config.jsp\">\ud658\uacbd\uc124\uc815</a></li>\r\n		<li class=\"toptxtcon01\" style=\"font-weight:bold; color:#000; text-decoration:underline;\"><a href=\"ini_manage_insa.jsp\">\uc778\uc0ac\uc815\ubcf4\ubaa9\ub85d</a></li>\r\n		<li class=\"toptxtcon01\"><a href=\"ini_manage_user.jsp\">\uc608\uc678\uc9c1\uc6d0\uad00\ub9ac</a></li>\r\n		<li class=\"toptxtcon01\"><a href=\"ini_manage_cert_logout.jsp\">\ub85c\uadf8\uc544\uc6c3</a></li>\r\n		<li class=\"toptxtcon01\">&nbsp;</li>\r\n		".toCharArray();
    _jsp_string31 = "\r\n</ul>\r\n".toCharArray();
    _jsp_string16 = "');\" style=\"padding:6px 5px 3px 5px; color:#000; background:#ccc; border:1px solid #999; border-radius:5px;\">\ucd08\uae30\ud654</a></td>\r\n		</tr>\r\n".toCharArray();
    _jsp_string9 = ">\uc774\ub984</option>\r\n			</select>\r\n			<input type=\"text\" name=\"searchKeyword\" id=\"searchKeyword\"  style=\"border:1px solid #dedede; width:150px;\"value=\"".toCharArray();
    _jsp_string7 = " selected".toCharArray();
    _jsp_string29 = "\">\ub2e4\uc74c</a></li>\r\n<li><a href=\"?pageIndex=".toCharArray();
    _jsp_string8 = ">\uc544\uc774\ub514</option>\r\n				<option value=\"C.NAME\"".toCharArray();
    _jsp_string25 = "\r\n	<li><a href=\"?pageIndex=".toCharArray();
    _jsp_string23 = "\r\n	<li><strong style=\"color:red; font-weight:bold;\">".toCharArray();
    _jsp_string15 = "</td>\r\n			<td class=\"wTableTdCell tac\"><a href=\"javascript:initPass('".toCharArray();
    _jsp_string6 = "\r\n	</ul>\r\n</div>\r\n<form action=\"ini_manage_insa.jsp\" method=\"post\">\r\n<input type=\"hidden\" name=\"pageIndex\" value=\"1\" />\r\n	<table cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\" border=\"0\" class=\"wTable\" style=\"border-bottom:1px solid #c5c5c5; margin:10px auto 10px auto;\">\r\n	<tr>\r\n		<td class=\"wTableTdSearch1\">\r\n			<select name=\"searchKeyfield\" id=\"searchKeyfield\">\r\n				<option value=\"\">\uc804\uccb4</option>\r\n				<option value=\"C.EMPNO\"".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\n\n\n\n".toCharArray();
    _jsp_string32 = "\r\n<script language=\"javascript\">dspCopyRight();</script>\r\n</body>\r\n</html>".toCharArray();
    _jsp_string19 = "\r\n</table>\r\n\r\n<ul class=\"paging_box\" style=\"margin-top:15px;\">\r\n".toCharArray();
    _jsp_string13 = "\r\n\r\n		<tr>\r\n			<td class=\"wTableTdCell tac\">".toCharArray();
    _jsp_string27 = "</a></li>\r\n".toCharArray();
    _jsp_string22 = "\">\uc774\uc804</a></li>\r\n".toCharArray();
    _jsp_string17 = "\r\n".toCharArray();
    _jsp_string11 = "\" />\r\n</form>\r\n\r\n<p style=\"width:950px; margin:0 auto;\">\uc804\uccb4 : ".toCharArray();
    _jsp_string10 = "\" />\r\n			<button type=\"submit\">\uac80\uc0c9</button>\r\n		</td>\r\n	</tr>\r\n	</table>\r\n</form>\r\n\r\n<form name=\"sendForm\" method=\"post\" action=\"./ini_manage_insa_pwok.jsp\">\r\n	<input type=\"hidden\" name=\"INIpluginData\" value=\"\" />\r\n</form>\r\n<form name=\"readForm\" method=\"post\">\r\n	<input type=\"hidden\" name=\"empNo\" value=\"\" />\r\n	<input type=\"hidden\" name=\"param\" value=\"pageIndex=".toCharArray();
    _jsp_string18 = "\r\n		<tr>\r\n			<td class=\"wTableTdCell tac\" colspan=\"7\" style=\"text-align:center;\">\ub370\uc774\ud130\uac00 \uc5c6\uc2b5\ub2c8\ub2e4.</td>\r\n		</tr>\r\n".toCharArray();
    _jsp_string28 = "\r\n<li><a href=\"?pageIndex=".toCharArray();
    _jsp_string20 = "\r\n<li><a href=\"?pageIndex=1&".toCharArray();
    _jsp_string4 = "\r\n		<li class=\"toptxtcon01\" style=\"font-weight:bold; color:#000; text-decoration:underline;\"><a href=\"ini_manage_insa.jsp\">\uc778\uc0ac\uc815\ubcf4\ubaa9\ub85d</a></li>\r\n		<li class=\"toptxtcon01\"><a href=\"ini_manage_cert_logout.jsp\">\ub85c\uadf8\uc544\uc6c3</a></li>\r\n		<li class=\"toptxtcon01\">&nbsp;</li>\r\n		".toCharArray();
    _jsp_string2 = "\n\n\n\r\n\n \n \n	\n\r\n".toCharArray();
    _jsp_string24 = "</strong></li>\r\n".toCharArray();
  }
}