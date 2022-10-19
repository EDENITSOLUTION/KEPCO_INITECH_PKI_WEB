/*
 * JSP generated by Resin Professional 4.0.38 (built Tue, 17 Dec 2013 09:49:45 PST)
 */

package _jsp;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.lang.*;
import java.lang.String.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

public class _websmsform__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  private boolean _caucho_isNotModified;
  private com.caucho.jsp.PageManager _jsp_pageManager;
  
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
    
boolean is_insa = false; //SMS\uc778\uc0ac\uc815\ubcf4 \uc5f0\ub3d9 \uc720\ubb34

String strIsInsa = "Y" ;
if (is_insa) {
	strIsInsa = "Y";
}else{
	strIsInsa = "N";
}

//\uc0ac\ubc88
String empno = request.getParameter("empno");
int cnt_user = 0 ; // \uc0ac\ubc88\uc5d0 \ud574\ub2f9\ud558\ub294 \uc0ac\uc6a9\uc790 \uc874\uc7ac \uc720\ubb34(0:\uc5c6\uc74c, \uadf8\uc678 \uc874\uc7ac)
String userName = null;
String phone = "010-9911-7557";
String phone1 = null;
String phone2 = null;
String phone3 = null;
String org_phone = null;

int phoneLen = 0 ;

if (empno.equals("") || empno==null ){
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
else {
	if (is_insa) { //\uc778\uc0ac\uc815\ubcf4 \uc5f0\ub3d9\uc2dc
		//\uc0ac\ubc88\uc774 \ub118\uc5b4\uc624\uba74 \uc778\uc0ac\ucabd\uc5d0\uc11c \ud574\ub2f9 \uc0ac\ubc88\uc758 \uc804\ud654\ubc88\ud638\ub97c \uac00\uc9c0\uace0 \uc624\uc790
		Context ic = new InitialContext();
		DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/INSA");
		ResultSet rs = null;

		Connection conn = null;
		Statement stmt = null;

		try{
			//\uc0ac\ubc88\uc774 \uc778\uc0ac\uc815\ubcf4\uc5d0 \uc874\uc7ac\ud558\ub294\uc9c0 \uccb4\ud06c
			conn = ds.getConnection();
			//Creat Query and get results
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM IRIS.V_INSA WHERE EMPNO ='"+ empno +"'");
			while (rs.next()){
				cnt_user = rs.getInt("cnt");
			}
			if (cnt_user == 0){
				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('\uc785\ub825\ud558\uc2e0 \uc0ac\ubc88("+ empno +")\uc5d0 \ub300\ud55c \uc815\ubcf4\uac00 \uc778\uc0ac\uc815\ubcf4\uc5d0\ub294 \uc874\uc7ac\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.');");
				writer.println("window.close();");
				writer.println("</script>");
				writer.flush();
				return;
			}else{ // \uc0ac\uc6a9\uc790 \uc815\ubcf4 \uc874\uc7ac\ud560\ub54c
				rs = stmt.executeQuery("SELECT EMPNO, NAME AS USER_NAME, CELLNO FROM IRIS.V_INSA WHERE empno ='"+ empno +"'");
				
				while (rs.next()){
					userName = rs.getString("USER_NAME");
					org_phone = rs.getString("CELLNO");
					phoneLen = phone.length();
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
		org_phone = phone ;
		cnt_user = 1 ;
		phoneLen = 13;
		userName = "\uac1c\ubc1c\uc790";
	}
		
} //\uc0ac\ubc88\uc815\ubcf4\uac00 \ub118\uc5b4\uc654\uc744 \ub54c end

if (cnt_user > 0 ) { //\uc0ac\uc6a9\uc790 \uc815\ubcf4\uac00 \uc874\uc7ac\ud55c\ub2e4\uba74 \uc778\uc99d\ud3fc\ubcf4\uc5ec\uc8fc\uc790

    out.write(_jsp_string1, 0, _jsp_string1.length);
    out.print((empno));
    out.write(_jsp_string2, 0, _jsp_string2.length);
    out.print((org_phone));
    out.write(_jsp_string3, 0, _jsp_string3.length);
    out.print((userName));
    out.write(_jsp_string4, 0, _jsp_string4.length);
    out.print((strIsInsa));
    out.write(_jsp_string5, 0, _jsp_string5.length);
    
String cell[] = org_phone.split("-"); 
phone1 =  cell[0] ;
phone2 =  cell[1] ;
phone3 =  cell[2] ;
if (phoneLen==13 || phoneLen == 12) {
	

    out.write(_jsp_string6, 0, _jsp_string6.length);
    out.print((phone1));
    out.write(_jsp_string7, 0, _jsp_string7.length);
    out.print((phone2));
    out.write(_jsp_string8, 0, _jsp_string8.length);
    out.print((phone3));
    out.write(_jsp_string9, 0, _jsp_string9.length);
    
}else{

    out.write(_jsp_string10, 0, _jsp_string10.length);
    
}

    out.write(_jsp_string11, 0, _jsp_string11.length);
    
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("websmsform.jsp"), -7392772374341796771L, true);
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

  private final static char []_jsp_string9;
  private final static char []_jsp_string7;
  private final static char []_jsp_string4;
  private final static char []_jsp_string11;
  private final static char []_jsp_string0;
  private final static char []_jsp_string5;
  private final static char []_jsp_string1;
  private final static char []_jsp_string3;
  private final static char []_jsp_string6;
  private final static char []_jsp_string8;
  private final static char []_jsp_string10;
  private final static char []_jsp_string2;
  static {
    _jsp_string9 = "\" onkeyup='javascript:NumberCheck(document.data.phone3)'>\n				</td>\n			</tr>\n			<tr>\n				<td height=25><font color=blue>\u261e</font> \uac1c\uc778\uc815\ubcf4\uc758 \ud578\ub4dc\ud3f0 \ubc88\ud638\uc784</td>\n			</tr>\n".toCharArray();
    _jsp_string7 = "\" onkeyup='javascript:NumberCheck(document.data.phone1)'>&nbsp;&nbsp;-&nbsp; \n				<input type=\"text\" name=\"phone2\" size=\"4\" class=\"input\" maxlength=4 value=\"".toCharArray();
    _jsp_string4 = "\">\n<input type=\"hidden\" name=\"strIsInsa\" value=\"".toCharArray();
    _jsp_string11 = "\n\n\n			</table>\n			</td>\n		</tr>\n		<tr> \n			<td>\n			<table border=\"0\" align=\"right\" cellpadding=\"0\" cellspacing=\"0\">\n			<tr>\n				<td width=\"50\"><a href='javascript:send()'><img src=\"/idmake_sms/IMAGE/burton_go.gif\" width=\"50\" height=\"19\"></a></td>\n				<td width=\"2\"></td>\n\n				<td width=\"50\"><a href='javascript:window.close();'><img src=\"/idmake_sms/IMAGE/burton_close.gif\" width=\"50\" height=\"19\"></a></td>\n\n				<td width=\"13\"></td>\n			</tr>\n			</table>\n			</td>\n		</tr>\n		</table>\n		</td>\n	</tr>\n	</table>\n	</td>\n</tr>\n<tr>\n	<td height=\"1\" bgcolor=\"#CECECE\"></td>\n</tr>\n</form>\n</table>\n</body>\n</html>\n\n".toCharArray();
    _jsp_string0 = "\n\n\n\n".toCharArray();
    _jsp_string5 = "\">\n<tr>\n	<td width=\"220\" height=\"1\" bgcolor=\"#CECECE\"></td>\n</tr>\n<tr> \n	<td height=\"45\"><img src=\"/idmake_sms/IMAGE/title.gif\" width=\"98\" height=\"21\"></td>\n</tr>\n<tr> \n	<td height=\"144\" valign=\"top\">\n	<table width=\"220\" height=\"131\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"1\" bgcolor=\"D7D5D5\">\n	<tr>\n		<td width=\"208\" height=\"129\" bgcolor=\"#FFFFFF\">\n		<table width=\"220\" height=\"113\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\n		<tr> \n			<td height=\"26\"><div align=\"center\"><img src=\"/idmake_sms/IMAGE/title2.gif\" width=\"200\" height=\"13\"></div></td>\n		</tr>\n		<tr> \n			<td>\n			<table border=0 align=center cellpadding=\"0\" cellspacing=\"1\">\n".toCharArray();
    _jsp_string1 = "\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html>\n<head>\n<title>SMS \uc778\uc99d\ud558\uae30</title>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">\n</head>\n<style type=\"text/css\">\n<!--\na:hover\n{\n	font-family: \"\ub3cb\uc6c0\";\n	font-size: 9pt;\n	line-height: normal;\n	color: #064687;\n	text-decoration: underline;\n}\ntd\n{\n	font-family: \"\ub3cb\uc6c0\";\n	font-size: 9pt;\n	color: #064687;\n}\na \n{ \n	font-family: \"\ub3cb\uc6c0\";\n	font-size: 9pt;\n	color: #064687;\n	text-decoration: none;\n}\nselect \n{\n	font-family: \"\ub3cb\uc6c0\";\n	font-size: 9pt;\n	color: #064687;\n}\n.input\n{\n	BORDER-RIGHT: B6B6B6 1px solid;\n	BORDER-TOP: B6B6B6 1px solid; \n	FONT-SIZE: 9pt; \n	BORDER-LEFT: B6B6B6 1px solid;\n	BORDER-BOTTOM: B6B6B6 1px solid;\n	border-color:B6B6B6;\n	text-align:center;\n	color:064687;\n	background-color:FAFAFA\n}\nIMG \n{\n	border:0;\n}\n-->\n</style>\n<script language=javascript>\nfunction  NumberCheck(no)\n{\n	numstr = '0123456789-';\n	for(var i=0;i<no.value.length;i++) {  \n		if(numstr.indexOf(no.value.charAt(i)) == -1) { \n			alert('SMS \uc778\uc99d\ud0a4 \uc218\uc2e0\uc790 \uc804\ud654\ubc88\ud638\ub294 \uc22b\uc790\ub9cc \uc785\ub825\uc774 \uac00\ub2a5\ud569\ub2c8\ub2e4.'); \n			no.value='';\n			no.focus();\n			return false;\n		}\n	}\n	return true;\n}\nfunction	send()\n{\n	document.data.action='websmssend.jsp';\n	document.data.submit();\n}\n\n</script>\n<body leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">\n<table width=\"235\" height=\"190\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" bgcolor=\"EEEEEE\">\n<form name=\"data\" method=\"post\">\n<input type=\"hidden\" name=\"empno\" value=\"".toCharArray();
    _jsp_string3 = "\">\n<input type=\"hidden\" name=\"userName\" value=\"".toCharArray();
    _jsp_string6 = "\n\n			<tr>\n				<td>\n				<input type=\"text\" name=\"phone1\" size=\"3\" class=\"input\" maxlength=3 value=\"".toCharArray();
    _jsp_string8 = "\" onkeyup='javascript:NumberCheck(document.data.phone2)'>&nbsp;&nbsp;-&nbsp; \n				<input type=\"text\" name=\"phone3\" size=\"4\" class=\"input\" maxlength=4 value=\"".toCharArray();
    _jsp_string10 = "\n			<tr>\n				<td>\n				<select name=\"phone1\">\n				<option value='010'>010\n				<option value='011'>011\n				<option value='016'>016\n				<option value='017'>017\n				<option value='018'>018\n				<option value='019'>019\n				</select>\n				-&nbsp; \n				<input type=\"text\" name=\"phone2\" size=4 class=input maxlength=4 onkeyup='javascript:NumberCheck(document.data.phone2)'>&nbsp;&nbsp;-&nbsp; \n				<input type=\"text\" name=\"phone3\" size=4 class=input maxlength=4  onkeyup='javascript:NumberCheck(document.data.phone3)'>\n				</td>\n			</tr>\n".toCharArray();
    _jsp_string2 = "\">\n<input type=\"hidden\" name=\"chk\">\n<input type=\"hidden\" name=\"org_phone\" value=\"".toCharArray();
  }
}
