/*
 * JSP generated by Resin Professional 4.0.38 (built Tue, 17 Dec 2013 09:49:45 PST)
 */

package _jsp._certcenter64._inica70new;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.lang.*;
import java.text.*;
import java.security.cert.X509Certificate;
import com.initech.iniplugin.*;

public class _ini_0manage_0cert_0login__jsp extends com.caucho.jsp.JavaPage
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
//      \uad00\ub9ac\uc790 \uc138\uc158 \uccb4\ud06c
//************************************************
String adminLogin = (String)session.getAttribute("adminLogin");
if (adminLogin == null) {


    out.write(_jsp_string2, 0, _jsp_string2.length);
    
}else{
	response.sendRedirect("ini_manage_cert.jsp");
}

    out.write('\n');
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70new/ini_manage_cert_login.jsp"), -8269861560235092967L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70new/import/iniplugin_init.jsp"), -8960418715910081368L, true);
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
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\n\n\n\n\n\n\n".toCharArray();
    _jsp_string2 = "\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\" />\n<title>\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\uc548\ub0b4</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/import.css\" />\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\" />\n\n<script type=\"text/javascript\" src=\"js/jquery-1.7.2.min.js\"></script>\n<script type=\"text/javascript\" src=\"js/jquery.flexslider-min.js\"></script>\n<script type=\"text/javascript\" src=\"js/jquery.als-1.1.min.js\"></script>\n<script type=\"text/javascript\" src=\"js/common.js\"></script>\n\n<script type=\"text/javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\n<script type=\"text/javascript\" src=\"/initech/plugin/INIutil.js\"></script>\n\n<script language=\"javascript\">\nfunction CheckSendForm() {\n\n	var readForm = document.readForm;\n	var sendForm = document.sendForm;\n	\n	if (readForm.id.value.length ==0) 	{\n		alert(\"\ub85c\uadf8\uc778 ID\ub97c \uc785\ub825\ud558\uc2ed\uc2dc\uc624\");\n		readForm.id.focus();\n		return false;\n	}\n	if (readForm.pw.length ==0) 	{\n		alert(\"\ub85c\uadf8\uc778 \ube44\ubc00\ubc88\ud638\ub97c \uc785\ub825\ud558\uc2ed\uc2dc\uc624\");\n		readForm.pw.focus();\n		return false;\n	}\n	\n\n	if (EncForm2(readForm, sendForm))\n	{\n		sendForm.submit();\n		return false;\n	}\n	return false;\n}\nfunction enterCheck(){\n\n		if(event.keyCode == 13){\n			CheckSendForm();\n		} \n\n}\n</script>\n\n<!--[if IE 6]>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie6.css\">\n<![endif]-->\n<!--[if IE 7]>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie7.css\">\n<![endif]-->\n</head> \n<body>\n\n<div id=\"header\">\n	<!-- MAIN MENU START -->\n	<script language=\"javascript\">dspMainMenu();</script>\n	<!-- MAIN MENU END -->\n</div>\n\n<div style=\"height:10px;\"></div>\n<div id=\"subtop\">\n	<ul class=\"subtoptxt\">\n		<li class=\"toptxtcon\">\uc778\uc99d\uc13c\ud130 \uad00\ub9ac\uc790</li>\n		<li class=\"toptxtcon01\" style=\"text-decoration:underline;width:150px;text-align:left;\">\uc778\uc99d\uc11c \ubc1c\uae09 \ub0b4\uc5ed \uc870\ud68c</li>\n		<li class=\"toptxtcon01\">&nbsp;</li>\n		<li class=\"toptxtcon01\">&nbsp;</li>\n	</ul>\n</div>\n\n\n<div id=\"subissue\">\n	<ul>\n		<li><img src=\"img/subtitle_manage.gif\" alt=\"\uad00\ub9ac\uc790 \ub85c\uadf8\uc778\"></li>\n		<li class=\"stitle\">&nbsp;<!-- <img src=\"img/subtitle0201.gif\" alt=\"\uc778\uc99d\uc11c\ubc1c\uae09_\uc785\ub825\"> --></li>\n		\n		<li class=\"box\" style=\"height:160px;\">\n			<form action=\"./ini_manage_cert_login_check.jsp\" method=\"post\" name=\"sendForm\">\n			<input type=\"hidden\" name=\"INIpluginData\" value=\"\" />\n			</form>\n			<form name=\"readForm\">\n			<ul>\n				<li class=\"sbtextbg\"> - \uc778\uc99d\uc11c \ubc1c\uae09\ub0b4\uc5ed \uc870\ud68c\ub97c \uc704\ud55c \uad00\ub9ac\uc790 ID \ubc0f \ube44\ubc00\ubc88\ud638\ub97c \uc785\ub825\ud558\uc2ed\uc2dc\uc624.</li>\n				<li class=\"sbtextbg2\">\n					<b>\uc0ac\uc6a9\uc790 ID</b> \n					<input type=\"text\" name=\"id\" maxlength=\"8\" size=\"20\" style=\"border: 1px solid #dedede;\" />\n				</li>\n\n				<li class=\"sbtextbg2\">\n					<b>\ube44\ubc00\ubc88\ud638</b> \n					&nbsp;<input type=\"password\" name=\"pw\" maxlength=\"30\" size=\"20\" onkeydown=\"enterCheck();\" style=\"border: 1px solid #dedede;\" />\n				</li>\n\n				<li class=\"dotted1\"></li>\n				<li style=\"float:left; padding-left:80px; height:30px;\">\n					<img src=\"img/login_new.gif\" border=\"0\" alt=\"\ub85c\uadf8\uc778\" style=\"cursor:pointer;\"  onclick=\"CheckSendForm();\">\n					<a href=\"#\" onclick=\"document.readForm.reset();\"><img src=\"img/btn_re-input_new.gif\" alt=\"\uc7ac\uc785\ub825\"></a>\n				</li>\n			</ul>\n			</form>\n		</li>\n	</ul>\n\n	<div style=\"height:90px;\"></div>\n</div>\n\n<!-- COPYRIGHT START -->\n<script language=\"javascript\">dspCopyRight();</script>\n<!-- COPYRIGHT END -->\n\n</body>\n</html>\n".toCharArray();
    _jsp_string1 = "\n\n".toCharArray();
  }
}
