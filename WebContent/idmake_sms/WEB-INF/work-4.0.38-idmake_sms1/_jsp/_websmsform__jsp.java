/*
 * JSP generated by Resin Professional 4.0.38 (built Tue, 17 Dec 2013 09:49:45 PST)
 */

package _jsp;
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
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class _websmsform__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  private boolean _caucho_isNotModified;
  private com.caucho.jsp.PageManager _jsp_pageManager;


   public byte[] getHashValue(String inputString) {
  	MessageDigest md = null;
  	try {
  		md = MessageDigest.getInstance("MD5");
  		md.update(inputString.getBytes());
  	} catch (NoSuchAlgorithmException e) {
  		e.printStackTrace();
  	}
  	
  	return md.digest(); 
  }

  public String getBase64Data(byte[] inputByte) throws IOException {
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
    
boolean is_insa = true; //SMS\uc778\uc0ac\uc815\ubcf4 \uc5f0\ub3d9 \uc720\ubb34

String strIsInsa = "Y" ;
if (is_insa) {
	strIsInsa = "Y";
}else{
	strIsInsa = "N";
}



String exRead = "readonly='readonly'"; //ex099129\uc0ac\ubc88\uc740 \uc608\uc678
String refuserid = "" ;
//\uc0ac\ubc88
String empno = request.getParameter("empno");
if (empno.equals("ex099129")) { //ex099129\ub294 \uc804\ud654\ubc88\ud638 \ubcc0\uacbd \uac00\ub2a5\ud558\ub3c4\ub85d\ud558\uc790.
	exRead = "readonly='readonly'"; //"";
	refuserid = "ex09912";
}else{
	exRead = "readonly='readonly'";
}

String refuserid2 = request.getParameter("refuserid2") ;
if (refuserid2 == null) {
	refuserid2 = "";
}

//\ud0c0\uc784\uc544\uc774\ub514
String tmid = request.getParameter("tmid");

int cnt_user = 0 ; // \uc0ac\ubc88\uc5d0 \ud574\ub2f9\ud558\ub294 \uc0ac\uc6a9\uc790 \uc874\uc7ac \uc720\ubb34(0:\uc5c6\uc74c, \uadf8\uc678 \uc874\uc7ac)
int pwdCnt = 0;
int certCnt = 0 ;
String userName = null;
String phone = "010-9911-7557";
String phone1 = null;
String phone2 = null;
String phone3 = null;
String org_phone = null;
String cellQry = null ;
String PHONENUM = null;
String isChk = "Y"; // \uc778\uc0ac\uc815\ubcf4\uc5d0 \uc5f0\ub77d\ucc98\uac00 \uc81c\ub300\ub85c \ub4f1\ub85d\uc548\ub418\uc5c8\uc744 \uacbd\uc6b0 \ud50c\ub798\uadf8
String cellNotice = null; //\uc778\uc0ac\uc815\ubcf4\uc5d0 \uc5f0\ub77d\ucc98\uac00 \uc81c\ub300\ub85c \ub4f1\ub85d \uc548\ub418\uc5c8\uc744 \uacbd\uc6b0 \uba54\uc138\uc9c0
int winH = 485;
int winW = 330;

int phoneLen = 0 ;

if (empno.equals("") || empno==null || tmid.equals("") || tmid==null ){
	isChk = "N" ;
	//\uc0ac\ubc88\uc774 \ub118\uc5b4\uc624\uc9c0 \uc54a\uc73c\uba74 \ucc3d\uc744 \ub2eb\uc544\ubc84\ub9ac\uc790
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('SMS\uc778\uc99d\uc744 \uc704\ud55c \uc0ac\ubc88\uc815\ubcf4\uac00 \uc804\ub2ec\ub418\uc9c0 \uc54a\uc558\uc2b5\ub2c8\ub2e4.');");
	writer.println("window.close();");
	writer.println("</script>");
	writer.flush();
	return;
}

if (is_insa) { //\uc778\uc0ac\uc815\ubcf4 \uc5f0\ub3d9\uc2dc

	//\uc0ac\ubc88\uc774 \ub118\uc5b4\uc624\uba74 \uc778\uc0ac\ucabd\uc5d0\uc11c \ud574\ub2f9 \uc0ac\ubc88\uc758 \uc804\ud654\ubc88\ud638\ub97c \uac00\uc9c0\uace0 \uc624\uc790
	Context ic = new InitialContext();
	DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
	ResultSet rs = null;
	ResultSet rRs = null;

	Connection conn = null;
	Statement stmt = null;

	try{
		//\uc0ac\ubc88\uc774 \uc778\uc0ac\uc815\ubcf4\uc5d0 \uc874\uc7ac\ud558\ub294\uc9c0 \uccb4\ud06c
		conn = ds.getConnection();
		//Creat Query and get results
		stmt = conn.createStatement();
		rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ empno +"'");
		while (rs.next()){
			cnt_user = rs.getInt("cnt");
		}
		if (cnt_user == 0){
			isChk = "N" ;
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('\uc785\ub825\ud558\uc2e0 \uc0ac\ubc88("+ empno +")\uc5d0 \ub300\ud55c \uc815\ubcf4\uac00 \uc778\uc0ac\uc815\ubcf4\uc5d0\ub294 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.');");
			writer.println("window.close();");
			writer.println("</script>");
			writer.flush();
			return;
		}else{ // \uc0ac\uc6a9\uc790 \uc815\ubcf4 \uc874\uc7ac\ud560\ub54c				
			cellQry = "" ;
			cellQry = cellQry + "SELECT "; 
			cellQry = cellQry + "		X.EMPNO ";
			cellQry = cellQry + "	,	X.USER_NAME ";
			cellQry = cellQry + "	,   X.CELLNO ";
			cellQry = cellQry + "	,	X.VAL1 ";
			cellQry = cellQry + "	,	X.VAL2 ";
			cellQry = cellQry + "	,( ";
			cellQry = cellQry + "		CASE WHEN X.VAL1 = 'ok' THEN X.CELLNO ";
			cellQry = cellQry + "		ELSE ";
			cellQry = cellQry + "			CASE WHEN X.VAL2 = 'ok' THEN  ";
			cellQry = cellQry + "				CASE WHEN LENGTH(X.CELLNO) = 10 THEN ";
			cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,3) ";
			cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,7,4) ";
			cellQry = cellQry + "				ELSE ";
			cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,4) ";
			cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,8,4) ";
			cellQry = cellQry + "				END ";
			cellQry = cellQry + "			ELSE 'x' ";
			cellQry = cellQry + "			END ";
			cellQry = cellQry + "		END ";
			cellQry = cellQry + "	) AS PHONENUM ";
			cellQry = cellQry + " FROM ( ";
			cellQry = cellQry + "	SELECT ";
			cellQry = cellQry + "		EMPNO ";
			cellQry = cellQry + "		, NAME AS USER_NAME ";
			cellQry = cellQry + "		, CELLNO ";
			cellQry = cellQry + "		, DECODE ( ";
			cellQry = cellQry + "			REGEXP_REPLACE(  ";
			cellQry = cellQry + "				REGEXP_SUBSTR(  ";
			cellQry = cellQry + "					CELLNO,  ";
			cellQry = cellQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
			cellQry = cellQry + "					1 ";
			cellQry = cellQry + "				), '[^0-9]', '-' ";
			cellQry = cellQry + "			)  ";
			cellQry = cellQry + "		, '','x','ok') VAL1  ";
			cellQry = cellQry + "		, DECODE ( ";
			cellQry = cellQry + "			REGEXP_REPLACE(  ";
			cellQry = cellQry + "				REGEXP_SUBSTR(  ";
			cellQry = cellQry + "					CELLNO,  ";
			cellQry = cellQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
			cellQry = cellQry + "					1 ";
			cellQry = cellQry + "				), '[^0-9]', '-' ";
			cellQry = cellQry + "			)  ";
			cellQry = cellQry + "		, '','x','ok') VAL2 ";
			cellQry = cellQry + "	FROM  V_INSA ";
			cellQry = cellQry + "	WHERE EMPNO = '"+ empno +"' ";
			cellQry = cellQry + ") X ";
							
			
			rs = stmt.executeQuery(cellQry);
			
			while (rs.next()){
				userName = rs.getString("USER_NAME");
				org_phone = rs.getString("CELLNO");
				PHONENUM = rs.getString("PHONENUM");
				phoneLen = phone.length();
			}
			cnt_user = 1;
			
			rs = stmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + empno + "' " );
			while (rs.next()){
				pwdCnt = rs.getInt("cnt");
			}

			rs = stmt.executeQuery("select count(name) as cnt from certs where name='" + empno + "' " );
			while (rs.next()){
				certCnt = rs.getInt("cnt");
			}

			if (pwdCnt < 1) {
				String q = "";
				q += "	INSERT INTO USER_PWD";
				q += "	   (USERID, USERPWD,CRDATE,USERNAME,USERIP) ";
				q += "		VALUES";
				q += "	 ('"+empno+"', '"+getBase64Data(getHashValue(empno + "!@"))+"', SYSDATE, '"+userName+"', '"+request.getRemoteAddr()+"')";
				rs = stmt.executeQuery(q);
			}
			//\uc5f0\ub77d\ucc98\uac00 \uc81c\ub300\ub85c \ub4f1\ub85d\uc774 \uc548\ub41c \uacbd\uc6b0

			if (PHONENUM.equals("x")  ){
				isChk = "N" ;
				cellNotice = "<br /> -" + userName +"("+ empno +")\ub2d8\uc758 \ud578\ub4dc\ud3f0 \ubc88\ud638\uac00 \uc778\uc0ac\uc815\ubcf4\uc5d0<br />&nbsp;&nbsp;\uc62c\ubc14\ub974\uac8c \ub4f1\ub85d\ub418\uc9c0 \uc54a\uc558\uc2b5\ub2c8\ub2e4.<br />- \ub4f1\ub85d\ub41c \ud578\ub4dc\ud3f0 \ubc88\ud638 : <span style='font-weight:bold;color:#ff0000;'>"+ org_phone +"</span> <br />- \uc544\ub798 SMS\uc778\uc99d \ubc1b\uc73c\uc2e4 \ubd84\uc758 \uc0ac\ubc88\uc744<br />&nbsp;&nbsp;\uc785\ub825\ud558\uc2ed\uc2dc\uc624."; 
				org_phone = "000-0000-0000" ;
				phoneLen = org_phone.length();
				refuserid = "";

			}else{
				isChk = "Y" ;
				org_phone = PHONENUM ;
				phoneLen = org_phone.length();
				refuserid = empno ;
			}
					


		}
	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		rs.close();
		stmt.close();
		conn.close();
	}
}else{ //\uc778\uc0ac\uc815\ubcf4 \uc5f0\ub3d9 \uc548\ud560\ub54c
	isChk = "Y" ;
	org_phone = phone ;
	cnt_user = 1 ;
	phoneLen = 13;
	userName = empno;
	refuserid = empno;
}
		
if (!"".equals(refuserid2)) {
	refuserid = refuserid2;
}

if (cnt_user > 0 ) { //\uc0ac\uc6a9\uc790 \uc815\ubcf4\uac00 \uc874\uc7ac\ud55c\ub2e4\uba74 \uc778\uc99d\ud3fc\ubcf4\uc5ec\uc8fc\uc790

    out.write(_jsp_string1, 0, _jsp_string1.length);
    
if (isChk.equals("N")) {

    out.write(_jsp_string2, 0, _jsp_string2.length);
    out.print((winW));
    out.write(',');
    out.print((winH));
    out.write(_jsp_string3, 0, _jsp_string3.length);
    
}else{

    out.write(_jsp_string2, 0, _jsp_string2.length);
    out.print((winW));
    out.write(_jsp_string4, 0, _jsp_string4.length);
    
}

    out.write(_jsp_string5, 0, _jsp_string5.length);
    
if (isChk.equals("N")) { //\uc5f0\ub77d\ucc98 \ud3ec\ub9f7\uc774 \ud578\ub4dc\ud3f0\uc774 \uc544\ub2c8\uac70\ub098 \uc5f0\ub77d\ucc98 \ub4f1\ub85d\uc774 \uc548\ub41c \uacbd\uc6b0

    out.write(_jsp_string6, 0, _jsp_string6.length);
    
}

    out.write(_jsp_string7, 0, _jsp_string7.length);
    
if (isChk.equals("Y")) { 

    out.write(_jsp_string8, 0, _jsp_string8.length);
    
}

    out.write(_jsp_string9, 0, _jsp_string9.length);
    
if (isChk.equals("Y")) { //\uc62c\ubc14\ub978 \ud3ec\ub9f7\uc774\uace0 \ub808\uc774\uc5b4\uac00 \ub2eb\ud790\ub54c

    out.write(_jsp_string10, 0, _jsp_string10.length);
    
} else { //\uc62c\ubc14\ub978 \ud3ec\ub9f7\uc774 \uc544\ub2c8\uace0 \ub808\uc774\uc5b4\uac00 \ub2eb\ud790 \uacbd\uc6b0\ub294 \uc5c6\uc9c0\ub9c8..

    out.write(_jsp_string11, 0, _jsp_string11.length);
    
} 

    out.write(_jsp_string12, 0, _jsp_string12.length);
    out.print((empno));
    out.write(_jsp_string13, 0, _jsp_string13.length);
    out.print((tmid));
    out.write(_jsp_string14, 0, _jsp_string14.length);
    out.print((empno));
    out.write(_jsp_string13, 0, _jsp_string13.length);
    out.print((tmid));
    out.write(_jsp_string15, 0, _jsp_string15.length);
     if (!"".equals(refuserid2)) { 
    out.write(_jsp_string16, 0, _jsp_string16.length);
    out.print((refuserid2));
    out.write(_jsp_string17, 0, _jsp_string17.length);
     } 
    out.write(_jsp_string18, 0, _jsp_string18.length);
    out.print((empno));
    out.write(_jsp_string19, 0, _jsp_string19.length);
    
	if (empno.equals("ex099129")) {
	
    out.write(_jsp_string20, 0, _jsp_string20.length);
    out.print((org_phone));
    out.write(_jsp_string21, 0, _jsp_string21.length);
    
	}
	
    out.write(_jsp_string22, 0, _jsp_string22.length);
    out.print((userName));
    out.write(_jsp_string23, 0, _jsp_string23.length);
    out.print((strIsInsa));
    out.write(_jsp_string24, 0, _jsp_string24.length);
    out.print((tmid));
    out.write(_jsp_string25, 0, _jsp_string25.length);
    
	String cell[] = org_phone.split("-"); 
	phone1 =  cell[0] ;
	phone2 =  cell[1] ;
	phone3 =  cell[2] ;
		
	//if (empno.equals("ex099129")) {
	//}else{
		phone2 = "****";
	//}
	
    out.write(_jsp_string26, 0, _jsp_string26.length);
    out.print((phone1));
    out.write(_jsp_string27, 0, _jsp_string27.length);
    out.print((exRead));
    out.write(_jsp_string28, 0, _jsp_string28.length);
    out.print((phone2));
    out.write(_jsp_string29, 0, _jsp_string29.length);
    out.print((exRead));
    out.write(_jsp_string30, 0, _jsp_string30.length);
    out.print((phone3));
    out.write(_jsp_string31, 0, _jsp_string31.length);
    out.print((exRead));
    out.write(_jsp_string32, 0, _jsp_string32.length);
    if (isChk.equals("Y")){
    out.write(_jsp_string33, 0, _jsp_string33.length);
    }else{
    out.write(_jsp_string34, 0, _jsp_string34.length);
    }
    out.write(_jsp_string35, 0, _jsp_string35.length);
    out.print((userName));
    out.write(_jsp_string36, 0, _jsp_string36.length);
    
							if (isChk.equals("N")) {
							
    out.write(_jsp_string37, 0, _jsp_string37.length);
    out.print((cellNotice));
    out.write(_jsp_string38, 0, _jsp_string38.length);
    
							}
							
    out.write(_jsp_string39, 0, _jsp_string39.length);
    if (isChk.equals("Y") && "".equals(refuserid2)) {
    out.write(_jsp_string40, 0, _jsp_string40.length);
    }else{
    }
    out.write(_jsp_string41, 0, _jsp_string41.length);
    
										if ( pwdCnt < 1 || certCnt < 1   ) {
									
    out.write(_jsp_string42, 0, _jsp_string42.length);
    
										}	
									
    out.write(_jsp_string43, 0, _jsp_string43.length);
    out.print((userName));
    out.write(_jsp_string44, 0, _jsp_string44.length);
    out.print((refuserid));
    out.write(_jsp_string45, 0, _jsp_string45.length);
    if (empno.equals("ex099129")) {
    }else{
    out.write(_jsp_string46, 0, _jsp_string46.length);
    }
    out.write(_jsp_string47, 0, _jsp_string47.length);
    
}//\uc0ac\uc6a9\uc790 \uc815\ubcf4 \uc874\uc7ac ..end

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("websmsform.jsp"), 2215377340183963681L, true);
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
  private final static char []_jsp_string15;
  private final static char []_jsp_string42;
  private final static char []_jsp_string25;
  private final static char []_jsp_string29;
  private final static char []_jsp_string41;
  private final static char []_jsp_string2;
  private final static char []_jsp_string33;
  private final static char []_jsp_string32;
  private final static char []_jsp_string9;
  private final static char []_jsp_string47;
  private final static char []_jsp_string24;
  private final static char []_jsp_string21;
  private final static char []_jsp_string6;
  private final static char []_jsp_string5;
  private final static char []_jsp_string34;
  private final static char []_jsp_string39;
  private final static char []_jsp_string3;
  private final static char []_jsp_string13;
  private final static char []_jsp_string26;
  private final static char []_jsp_string45;
  private final static char []_jsp_string7;
  private final static char []_jsp_string4;
  private final static char []_jsp_string20;
  private final static char []_jsp_string40;
  private final static char []_jsp_string31;
  private final static char []_jsp_string43;
  private final static char []_jsp_string17;
  private final static char []_jsp_string10;
  private final static char []_jsp_string0;
  private final static char []_jsp_string36;
  private final static char []_jsp_string28;
  private final static char []_jsp_string19;
  private final static char []_jsp_string46;
  private final static char []_jsp_string27;
  private final static char []_jsp_string23;
  private final static char []_jsp_string18;
  private final static char []_jsp_string30;
  private final static char []_jsp_string37;
  private final static char []_jsp_string8;
  private final static char []_jsp_string14;
  private final static char []_jsp_string22;
  private final static char []_jsp_string16;
  private final static char []_jsp_string35;
  private final static char []_jsp_string1;
  private final static char []_jsp_string11;
  private final static char []_jsp_string38;
  private final static char []_jsp_string44;
  static {
    _jsp_string12 = "\n	}else{\n		lyrId.style.display = \"\";\n		form.isOkEmp.value= \"N\";\n		form.refuserid.value = \"\";\n		form.hdnRefEmp.value = \"\";\n	}\n}\n\nfunction isRightUser(){\n	var form = document.data;\n	if (form.refuserid.value.length < 8) {\n		form.isOkEmp.value=\"N\";\n		alert(\"8\uc790\ub9ac \uc774\uc0c1\uc758 \uc0ac\ubc88\uc744 \uc785\ub825\ud558\uc2ed\uc2dc\uc694.\");\n		form.refuserid.focus();\n		return false;\n	}\n	if (form.refuserid.value==form.empno.value) {\n		form.isOkEmp.value=\"N\";\n		alert(\"\uc778\uc99d\ubc1b\uc744 \uc0ac\ubc88\uc774 \uc790\uc2e0\uc758 \uc0ac\ubc88\uacfc \uc77c\uce58\ud569\ub2c8\ub2e4.\\n\\n\ub2e4\uc2dc \ud55c\ubc88 \ud655\uc778\ud558\uc2ed\uc2dc\uc624.\");\n		form.refuserid.value=\"\";\n		form.refuserid.focus();\n		return false;\n	}\n\n	form.target = \"hdnFrame\";\n	form.action = \"checkUserId.jsp\";\n	form.submit();\n\n}\nfunction fncChangeMod(){\n	location.href=\"webmailform.jsp?empno=".toCharArray();
    _jsp_string15 = "\";\n}\n\n".toCharArray();
    _jsp_string42 = "\n									<span>\u203b \ucd5c\ucd08 \uc778\uc99d\uc11c\ub97c \ubc1b\uc744\uacbd\uc6b0 \uc774\uc804 \ube44\ubc00\ubc88\ud638\ub294 <br/><strong style=\"color:red;\">'\uc0ac\ubc88!@'</strong> \uc785\ub2c8\ub2e4. </span><br/>\n									".toCharArray();
    _jsp_string25 = "\" />\n	<tr> \n		<td height=\"30\" style=\"border-top:solid 1px #cecece;\"><img src=\"/idmake_sms/IMAGE/title.gif\" width=\"98\" height=\"21\" border=\"0\" /></td>\n	</tr>\n	<tr>\n		<td>\n			<table width=\"100%\" border=\"0\" cellpadding=\"0\">\n				<tr>\n					<td style=\"text-align:center;\">\n						<img src=\"/idmake_sms/IMAGE/popup_sms_n.gif\" alt=\"\" /><br/>\n						<input type=\"radio\" name=\"chk\" checked=\"checked\" /><br/>\ud734\ub300\uc804\ud654\ub85c \ubc1c\uc1a1\n					</td>\n					<td style=\"text-align:center;\">\n						<img src=\"/idmake_sms/IMAGE/popup_email_n.gif\" alt=\"\" /><br/>\n						<input type=\"radio\" name=\"chk\" onclick=\"fncChangeMod();\" /><br/>\uc774\uba54\uc77c\ub85c \ubc1c\uc1a1\n					</td>\n					<td style=\"text-align:center;\">\n						<img src=\"/idmake_sms/IMAGE/popup_push_n.gif\" alt=\"\" /><br/>\n						<input type=\"radio\" name=\"chk\" onclick=\"fncChangeMod2();\" /><br/>\ud574\uc678\uc0ac\uc6a9\uc790 \uc804\uc6a9\n					</td>\n				</tr>\n			</table>\n		</td>\n	</tr>\n	<tr> \n		<td valign=\"top\">\n			<table width=\"100%\" border=\"0\" cellpadding=\"0\" style=\"border:solid 1px #d7d5d5;\">\n				<tr>\n					<td style=\"background-color:#ffffff;padding-top:10px;padding-left:10px;\">\n						<table width=\"98%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n							<!--\n							<tr> \n								<td colspan=\"2\" style=\"padding-top:5px;padding-bottom:5px;\"><img src=\"/idmake_sms/IMAGE/title2.gif\" width=\"200\" height=\"13\" border=\"0\" /></td>\n							</tr>\n							<tr> \n								<td colspan=\"2\" style=\"padding-right:10px;padding-top:5px;padding-bottom:10px;\">\n									<span style=\"cursor:pointer;font-weight:bold;color:#ffffff;background-color:#6633ff;border:solid 1px #666666;padding:6px 5.5px 2px 5.5px;\" onclick=\"fncChangeMod();\">\uc774\uba54\uc77c \uc778\uc99d\uc73c\ub85c \ubcc0\uacbd</span>\n									<span style=\"cursor:pointer;font-weight:bold;color:#ffffff;background-color:#6633ff;border:solid 1px #666666;padding:6px 5.5px 2px 5.5px;\" onclick=\"fncChangeMod2();\">PUSH \uc778\uc99d\uc73c\ub85c \ubcc0\uacbd</span>\n								 </td>\n							</tr>	\n							-->\n	".toCharArray();
    _jsp_string29 = "\" onkeyup='javascript:NumberCheck(document.data.phone2)' disabled=\"disabled\" ".toCharArray();
    _jsp_string41 = ";\">\n								<td height=25 colspan=\"2\">\n									<br />\n									<span style=\"color:#6600cc;font-weight:bold;\"><strong>\u203b \uc785\ub825\ud558\uc2e0 \uc0ac\ubc88\uc5d0 \ud574\ub2f9\ud558\ub294 \uc0ac\uc6d0\uc758 \ud578\ub4dc\ud3f0 \ubc88\ud638\ub85c SMS \uc778\uc99d\ubc88\ud638\uac00 \uc804\uc1a1\ub429\ub2c8\ub2e4.</strong></span> \n									<br />\n									".toCharArray();
    _jsp_string2 = "\n	window.resizeTo(".toCharArray();
    _jsp_string33 = "\n									<img src=\"/idmake_sms/IMAGE/burton_edit.gif\" width=\"50\" height=\"19\" border=\"0\" style=\"cursor:pointer;\" onclick=\"changeUserPhone();\" align=\"absmiddle\" />\n								".toCharArray();
    _jsp_string32 = " />\n								</td>\n								<td style=\"width:60px; text-align:right; padding-right:10px;\">\n								".toCharArray();
    _jsp_string9 = "	\n\n	\n	if ((form.refuserid.value != \"\") && (form.isOkEmp.value == \"Y\")) {\n		if (form.refuserid.value != form.hdnRefEmp.value){\n			alert(\"SMS\uc778\uc99d\uc744 \ubc1b\uc744 \uc218 \uc788\ub294 \uc0ac\uc6d0 \ud655\uc778 \ud6c4, \uc0ac\ubc88\uc744 \ubcc0\uacbd\ud558\uc2dc\uba74 \uc548\ub429\ub2c8\ub2e4.\\n\ub2e4\uc2dc \ud55c\ubc88 SMS\uc778\uc99d\uc744 \ubc1b\uc73c\uc2e4 \uc0ac\uc6d0\uc758 \uc0ac\ubc88\uc744 \uc785\ub825\ud558\uc2dc\uace0\\n[\uc0ac\uc6d0\ud655\uc778]\ubc84\ud2bc\uc744 \ud074\ub9ad\ud558\uc154\uc11c SMS\uc778\uc99d\uc744 \ubc1b\uc744 \uc218\uc788\ub294 \uc0ac\uc6d0\uc778\uc9c0 \ud655\uc778\ud558\uc2ed\uc2dc\uc624.\");\n			form.refuserid.value = \"\" ;\n			form.refuserid.focus();\n			return ;\n		}\n	}\n	\n	//alert(form.isOkEmp.value + \" / emp: \" + form.empno.value  + \" / refuserid : \" + form.refuserid.value + \" / hdnRefEmp : \" + form.hdnRefEmp.value);\n	form.target = \"_self\";\n	form.action='websmssend.jsp';\n	\n	if(form.refuserid.value == form.empno.value) {\n		form.submit();\n	} else {\n		if(CheckEmpno(document.data.refuserid)) {\n			form.submit();\n		}\n	}\n}\n\nfunction changeUserPhone(){\n	var form = document.data;\n	var lyrId = document.getElementById(\"tr_refuserid\");\n	if (lyrId.style.display==\"\") {\n		lyrId.style.display = \"none\";\n".toCharArray();
    _jsp_string47 = " /> \n									<img src=\"/idmake_sms/IMAGE/btn_userConfirm1.gif\" border=\"0\" align=\"absmiddle\" style=\"cursor:pointer; margin-left:4px; vertical-align:bottom; margin-bottom:1px;\" onclick=\"isRightUser();\" />\n									\n									\n								</td>\n							</tr>\n							<tr> \n								<td colspan=\"2\" style=\"text-align:center;height:20px; border-bottom:dotted 1px #666666;\">&nbsp;</td>\n							</tr>\n							<tr> \n								<td colspan=\"2\" style=\"text-align:center; padding:4px;\">\n									<a href='javascript:send()'><img src=\"/idmake_sms/IMAGE/burton_go.gif\" width=\"50\" height=\"19\" border=\"0\" /></a>\n									&nbsp;\n									<a href='javascript:window.close();'><img src=\"/idmake_sms/IMAGE/burton_close.gif\" width=\"50\" height=\"19\" border=\"0\" /></a>\n								</td>\n							</tr>\n							<tr> \n								<td colspan=\"2\" style=\"text-align:center;height:20px; border-top:dotted 1px #666666;\">&nbsp;</td>\n							</tr>\n						</table>\n					</td>\n				</tr>\n			</table>\n		</td>\n	</tr>\n	<!-- <tr>\n		<td height=\"1\" bgcolor=\"#CECECE\"></td>\n	</tr> -->\n	</form>\n</table>\n<iframe name=\"hdnFrame\" id=\"hdnFrame\" src=\"blank.html\" width=\"110\" height=\"110\" style=\"display:none\" scrolling=\"no\" frameborder=\"0\"></iframe>\n</body>\n</html>\n\n".toCharArray();
    _jsp_string24 = "\" />\n	<input type=\"hidden\" name=\"tmid\" value=\"".toCharArray();
    _jsp_string21 = "\" />\n	".toCharArray();
    _jsp_string6 = "\n	if (form.refuserid.value.length !=8) {\n		alert(\"SMS\uc778\uc99d\uc744 \ubc1b\uc73c\uc2e4 \uc0ac\uc6d0\uc758 \uc0ac\ubc88\uc744 \uc785\ub825\ud558\uc2dc\uace0\\n[\uc0ac\uc6d0\ud655\uc778]\ubc84\ud2bc\uc744 \ud074\ub9ad\ud558\uc154\uc11c SMS\uc778\uc99d\uc744 \ubc1b\uc744 \uc218\uc788\ub294 \uc0ac\uc6d0\uc778\uc9c0 \ud655\uc778\ud558\uc2ed\uc2dc\uc624.\");\n		form.isOkEmp.value = \"N\";\n		form.hdnRefEmp.value=\"\";\n		form.refuserid.focus();\n		return ;\n	}\n	if (form.isOkEmp.value==\"N\") {\n		alert(\"[\uc0ac\uc6d0\ud655\uc778]\ubc84\ud2bc\uc744 \ud074\ub9ad\ud558\uc154\uc11c SMS\uc778\uc99d\uc744 \ubc1b\uc744 \uc218\uc788\ub294 \uc0ac\uc6d0\uc778\uc9c0 \ud655\uc778\ud558\uc2ed\uc2dc\uc624.\");\n		form.refuserid.focus();\n		form.refuserid.value=\"\";\n		form.hdnRefEmp.value=\"\";\n		return ;\n	}\n	\n".toCharArray();
    _jsp_string5 = "\nfunction  NumberCheck(no)\n{\n	numstr = '0123456789';\n	for(var i=0;i<no.value.length;i++) {  \n		if(numstr.indexOf(no.value.charAt(i)) == -1) { \n			alert('SMS \uc778\uc99d\ud0a4 \uc218\uc2e0\uc790 \uc804\ud654\ubc88\ud638\ub294 \uc22b\uc790\ub9cc \uc785\ub825\uc774 \uac00\ub2a5\ud569\ub2c8\ub2e4.'); \n			no.value='';\n			no.focus();\n			return false;\n		}\n	}\n	return true;\n}\n\nfunction  CheckEmpno(no)\n{\n	numstr = '0123456789';\n	/*\n	for(var i=0;i<no.value.length;i++) {  \n		if(numstr.indexOf(no.value.charAt(i)) == -1) { \n			alert('\uc0ac\ubc88 \uc785\ub825\uc740 \uc22b\uc790\ub9cc \uc785\ub825\uc774 \uac00\ub2a5\ud569\ub2c8\ub2e4.'); \n			no.value='';\n			no.focus();\n			return false;\n		}\n	}\n	*/\n	return true;\n}\n\nfunction	send()\n{\n	\n	var form = document.data ;\n	var lyrId = document.getElementById(\"tr_refuserid\");\n".toCharArray();
    _jsp_string34 = "&nbsp;".toCharArray();
    _jsp_string39 = "\n							<tr id=\"tr_refuserid\" style=\"display:".toCharArray();
    _jsp_string3 = ")\n".toCharArray();
    _jsp_string13 = "&tmid=".toCharArray();
    _jsp_string26 = "\n							\n							\n							\n							<tr> \n								<td>\n									<input type=\"text\" name=\"phone1\" size=\"3\" class=\"input\" maxlength=\"3\" value=\"".toCharArray();
    _jsp_string45 = "\" size=\"8\" class=\"input\" style=\"width:93px; margin-top:10px;\"  ".toCharArray();
    _jsp_string7 = "	\n".toCharArray();
    _jsp_string4 = ",530)\n".toCharArray();
    _jsp_string20 = "\n	<input type=\"hidden\" name=\"org_phone\" value=\"".toCharArray();
    _jsp_string40 = "none".toCharArray();
    _jsp_string31 = "\" onkeyup='javascript:NumberCheck(document.data.phone3)' disabled=\"disabled\" ".toCharArray();
    _jsp_string43 = "\n									<span style=\"display:inline-block; width:110px; font-size:8pt; padding-bottom:2px;\">".toCharArray();
    _jsp_string17 = "';\n}\n".toCharArray();
    _jsp_string10 = "\n		form.isOkEmp.value= \"Y\";\n		form.refuserid.value = form.empno.value;		\n		form.hdnRefEmp.value = form.empno.value;\n".toCharArray();
    _jsp_string0 = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n".toCharArray();
    _jsp_string36 = "\ub2d8 \uc778\uc0ac\uc815\ubcf4\uc758 \ud578\ub4dc\ud3f0 \ubc88\ud638\uc785\ub2c8\ub2e4.</td>\n							</tr>\n							".toCharArray();
    _jsp_string28 = " />&nbsp;-&nbsp; \n									<input type=\"text\" name=\"phone2\" size=\"4\" class=\"input\" maxlength=\"4\" value=\"".toCharArray();
    _jsp_string19 = "\" />\n	<input type=\"hidden\" name=\"chk\" />\n	<input type=\"hidden\" name=\"isOkEmp\" value=\"Y\" />\n	<input type=\"hidden\" name=\"hdnRefEmp\" value=\"\" />\n	".toCharArray();
    _jsp_string46 = " onkeyup=\"CheckEmpno(document.data.refuserid);\"".toCharArray();
    _jsp_string27 = "\" onkeyup='javascript:NumberCheck(document.data.phone1)' disabled=\"disabled\" ".toCharArray();
    _jsp_string23 = "\" />\n	<input type=\"hidden\" name=\"strIsInsa\" value=\"".toCharArray();
    _jsp_string18 = "\n</script>\n</head>\n<body>\n<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#eeeeee;\">\n	<form name=\"data\" method=\"post\">\n	<input type=\"hidden\" name=\"empno\" value=\"".toCharArray();
    _jsp_string30 = " />&nbsp;-&nbsp; \n									<input type=\"text\" name=\"phone3\" size=\"4\" class=\"input\" maxlength=\"4\" value=\"".toCharArray();
    _jsp_string37 = "\n							<tr>\n								<td colspan=\"2\">\n								".toCharArray();
    _jsp_string8 = "\n	if (lyrId.style.display==\"\") { //refuserid\ub808\uc774\uc5b4\uac00 \ud65c\uc131\ub418\uc5c8\ub2e4\uba74 \ubc18\ub4dc\uc2dc refuserid\uc785\ub825\ud574\uc57c\ud568\n		if (form.refuserid.value.length !=8) {\n			alert(\"SMS\uc778\uc99d\uc744 \ubc1b\uc73c\uc2e4 \uc0ac\uc6d0\uc758 \uc0ac\ubc88\uc744 \uc785\ub825\ud558\uc2dc\uace0\\n[\uc0ac\uc6d0\ud655\uc778]\ubc84\ud2bc\uc744 \ud074\ub9ad\ud558\uc154\uc11c SMS\uc778\uc99d\uc744 \ubc1b\uc744 \uc218\uc788\ub294 \uc0ac\uc6d0\uc778\uc9c0 \ud655\uc778\ud558\uc2ed\uc2dc\uc624.\");		\n			form.hdnRefEmp.value=\"\";\n			form.isOkEmp.value = \"N\";	\n			form.refuserid.focus();\n			return ;\n		}		\n		if (form.isOkEmp.value==\"N\") {\n			alert(\"[\uc0ac\uc6d0\ud655\uc778]\ubc84\ud2bc\uc744 \ud074\ub9ad\ud558\uc154\uc11c SMS\uc778\uc99d\uc744 \ubc1b\uc744 \uc218\uc788\ub294 \uc0ac\uc6d0\uc778\uc9c0 \ud655\uc778\ud558\uc2ed\uc2dc\uc624.\");\n			form.refuserid.value=\"\";	\n			form.hdnRefEmp.value=\"\";	\n			form.refuserid.focus();	\n			return ;\n		}\n	}else{\n		form.refuserid.value=form.empno.value;\n		form.hdnRefEmp.value=form.empno.value;\n		form.isOkEmp.value = \"Y\";\n		//alert(form.hdnRefEmp.value + \" / \" + form.refuserid.value + \" / \" + form.isOkEmp.value );\n	}\n\n".toCharArray();
    _jsp_string14 = "\";\n}\nfunction fncChangeMod2(){\n	location.href=\"apppushform.jsp?empno=".toCharArray();
    _jsp_string22 = "\n	<input type=\"hidden\" name=\"userName\" value=\"".toCharArray();
    _jsp_string16 = "\nwindow.onload = function() {\n	document.data.isOkEmp.value='Y';\n	document.data.hdnRefEmp.value='".toCharArray();
    _jsp_string35 = "\n								</td>\n							</tr>\n							<tr>\n								<td height=25 colspan=\"2\"><span style=\"color:#6600cc;\">\u261e</span>".toCharArray();
    _jsp_string1 = "\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\" />\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=11\"/>\n<title>[1]SMS \uc778\uc99d\ud558\uae30</title>\n<style type=\"text/css\">\n<!--\nbody {\n	font-family: \"\ub3cb\uc6c0\";\n	font-size: 9pt;\n	color: #064687;\n	margin:0px;\n}\n.input\n{\n	border: solid 1px #b6b6b6;\n	text-align:center;\n	color:#064687;\n	background-color:#fafafa\n}\n-->\n</style>\n<script language=javascript>\n".toCharArray();
    _jsp_string11 = "\n		form.isOkEmp.value= \"N\";\n		form.refuserid.value = \"\";		\n		form.hdnRefEmp.value = \"\";\n".toCharArray();
    _jsp_string38 = "\n								</td>\n							</tr>\n							".toCharArray();
    _jsp_string44 = "\ub2d8\uc758 \ube44\ubc00\ubc88\ud638 :</span> <input type=\"password\" name=\"orguserpw\" value=\"\" class=\"input\" style=\"width:93px; margin-top:5px;\" />\n																		\n									<span style=\"display:inline-block; width:110px; font-size:8pt; padding-bottom:2px; margin-top:10px;\">\ub300\ub9ac\uc790 \uc0ac\ubc88 :</span> <input type=\"text\" name=\"refuserid\" value=\"".toCharArray();
  }
}
