/*
 * JSP generated by Resin Professional 4.0.38 (built Tue, 17 Dec 2013 09:49:45 PST)
 */

package _jsp._demo._enc;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import java.lang.*;
import java.text.*;
import com.initech.iniplugin.*;
import java.util.Enumeration;

public class _pageEnc__jsp extends com.caucho.jsp.JavaPage
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
    
	/*
	************************
	Request object \uc0ac\uc6a9 INIT()
	************************
	*/
	String m_IniErrCode = null;
	String m_IniErrMsg = null;
	System.out.println("11111111111111111111111111111111");
	IniPlugin m_IP = new IniPlugin(request,response,"/home/initech/iniplugin/properties/IniPlugin.inica70.properties");

  /*
	************************
	Post Data \ud655\uc778
	************************
	*/
	
	String INIdata = request.getParameter("INIpluginData");
	System.out.println("INIpluginData: "+INIdata);
	if (INIdata == null) 
	{
	              m_IniErrCode = ">>PLUGIN_000";
	              m_IniErrMsg = "Exception : INIpluginData is null";              
	}
	  else 
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
	                           
	              }
	}
	if(m_IniErrCode != null)
	{
		out.println("<br><b>INISAFE Web 6.1 Server SDK - Init() ERROR</b>");
		out.println("<hr>");
		out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
		out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
		return;
		
	}


    out.write(_jsp_string1, 0, _jsp_string1.length);
     out = m_IP.startEncrypt(out); 
    out.write(_jsp_string2, 0, _jsp_string2.length);
     out = m_IP.endEncrypt(out); 
    out.write(_jsp_string3, 0, _jsp_string3.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("demo/enc/pageEnc.jsp"), 7651172284304120437L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("demo/include/Init.jsp"), 4167850621049698805L, true);
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
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  static {
    _jsp_string1 = "\n\r\n<html>\r\n<head> \r\n	<title>\uc554\ud638\ud654 \uc2a4\ud06c\ub9bd\ud2b8 \uc0ac\uc6a9\uc608\uc81c</title>\r\n	<meta http-equiv=\"Content-Type\" Pragma=\"no-cache\" Cache-control=\"no-cache\" content=\"text/html; charset=euc-kr\">\r\n	<script language=\"javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\r\n	<script>\r\n	function CheckSendForm(readForm, sendForm)\r\n	{\r\n		if (EncForm2(readForm, sendForm)) {\r\n			sendForm.submit();\r\n			return false;\r\n		} else {\r\n			alert(\"\ubcf4\uc548\uc0c1 \ubb38\uc81c\uac00 \uc0dd\uaca8 \uc804\uc1a1\uc774 \ucde8\uc18c \ub418\uc5c8\uc2b5\ub2c8\ub2e4.\");\r\n		}\r\n		return false; //\ubc18\ub4dc\uc2dc false\ub97c return;\r\n	}\r\n\r\n	\r\n	</script>\r\n</head>\r\n\r\n<body>\r\n\r\n<br><h3>\ud398\uc774\uc9c0 \uc554\ud638\ud654</h3>\r\n".toCharArray();
    _jsp_string3 = "\r\n\r\n<hr size=\"1\" width=\"550\" color=\"#CCCCCC\"></p>\r\n<p align=\"center\"><font size=\"2\">Copyright(c) 1997-2007 by INITECH</font><br></p>\r\n\r\n</html>\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n<form name=form1 action=\"./pageEncCheck.jsp\" method=POST onsubmit=\"return EncForm(this);\">\r\n	<b>POST \ubc29\uc2dd\uc758 1\uac1c\uc758 form \ubb38\uc744 \uc774\uc6a9\ud55c \uc554\ud638\ud654(EncForm) \uc608\uc81c</b><br>\r\n    <input type=hidden name=INIpluginData>\r\n    A:<input type=text name=A value=\"AAAAAAA\">\r\n    B:<input type=text name=B value=\"BBBBBBB\"><br>\r\n    C:<input type=text name=C value=\"\uc785\ub825\ud55c\uae00\">&nbsp;&nbsp;&nbsp\r\n\r\n	<input type=\"checkbox\" name=\"check\" checked>CheckBox \r\n\r\n<select name=\"selectType\">\r\n    <option value=\"blue\">blue</option>\r\n    <option value=\"red\">red</option>\r\n    <option value=\"\">black</option>\r\n  </select>\r\n\r\n	<input type=submit value=\"\uc554\ud638\ud654 \uc804\uc1a1\">\r\n</form>\r\n".toCharArray();
  }
}