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
import java.util.Date.*;
import java.util.Calendar.*;
import java.text.SimpleDateFormat;
import java.lang.String.*;
import java.security.cert.X509Certificate;
import com.initech.iniplugin.*;

public class _ini_0certNew__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  private boolean _caucho_isNotModified;
  private com.caucho.jsp.PageManager _jsp_pageManager;


  public String getDateTime() {
  	Locale locale = java.util.Locale.KOREA;
  	SimpleDateFormat sdfr = new SimpleDateFormat("yyyyMMddHHmmss", locale);
  	String convertedTime = sdfr.format(new Date());
  	return convertedTime;

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
    
String timeId = getDateTime() ;

    out.write(_jsp_string2, 0, _jsp_string2.length);
    
if (is_smsChk) {

    out.write(_jsp_string3, 0, _jsp_string3.length);
    
}

    out.write(_jsp_string4, 0, _jsp_string4.length);
    
if (is_smsChk) {

    out.write(_jsp_string5, 0, _jsp_string5.length);
    
}

    out.write(_jsp_string6, 0, _jsp_string6.length);
    out.print((timeId));
    out.write(_jsp_string7, 0, _jsp_string7.length);
    
						if (is_smsChk) {
						
    out.write(_jsp_string8, 0, _jsp_string8.length);
    
						}else{
						
    out.write(_jsp_string9, 0, _jsp_string9.length);
    
						}
						
    out.write(_jsp_string10, 0, _jsp_string10.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/ini_certNew.jsp"), -7048358152204696932L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/import/iniplugin_init.jsp"), -1077120484095086999L, true);
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

  private final static char []_jsp_string2;
  private final static char []_jsp_string9;
  private final static char []_jsp_string5;
  private final static char []_jsp_string6;
  private final static char []_jsp_string8;
  private final static char []_jsp_string1;
  private final static char []_jsp_string4;
  private final static char []_jsp_string3;
  private final static char []_jsp_string7;
  private final static char []_jsp_string10;
  private final static char []_jsp_string0;
  static {
    _jsp_string2 = "\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\" />\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=11\"/>\n<title>\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\uc548\ub0b4</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/import.css\" />\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\" />\n\n<script type=\"text/javascript\" src=\"js/jquery-1.7.2.min.js\"></script>\n<script type=\"text/javascript\" src=\"js/jquery.flexslider-min.js\"></script>\n<script type=\"text/javascript\" src=\"js/jquery.als-1.1.min.js\"></script>\n<script type=\"text/javascript\" src=\"js/common.js\"></script>\n\n<script type=\"text/javascript\" src=\"/initech/plugin/INIplugin.js\"></script>\n<script type=\"text/javascript\" src=\"/initech/plugin/INIutil.js\"></script>\n\n<script language=\"javascript\">\nfunction getStrDate(){\n	Date.prototype.format = function(f) {    \n    if (!this.valueOf()) return \" \";     \n        var weekName = [\"\uc77c\uc694\uc77c\", \"\uc6d4\uc694\uc77c\", \"\ud654\uc694\uc77c\", \"\uc218\uc694\uc77c\", \"\ubaa9\uc694\uc77c\", \"\uae08\uc694\uc77c\", \"\ud1a0\uc694\uc77c\"];    \n        var d = this;         \n        \n        return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\\/p)/gi, function($1) {        \n            switch ($1) {            \n               case \"yyyy\": return d.getFullYear();            \n               case \"yy\": return (d.getFullYear() % 1000).zf(2);            \n               case \"MM\": return (d.getMonth() + 1).zf(2);            \n               case \"dd\": return d.getDate().zf(2);            \n               case \"E\": return weekName[d.getDay()];            \n               case \"HH\": return d.getHours().zf(2);            \n               case \"hh\": return ((h = d.getHours() % 12) ? h : 12).zf(2);            \n               case \"mm\": return d.getMinutes().zf(2);            \n               case \"ss\": return d.getSeconds().zf(2);            \n               case \"a/p\": return d.getHours() < 12 ? \"\uc624\uc804\" : \"\uc624\ud6c4\";            \n               default: return $1;        \n             }    \n        });}; \n\n    //\ud55c\uc790\ub9ac\uc77c\uacbd\uc6b0 \uc55e\uc5d0 0\uc744 \ubd99\uc5ec\uc900\ub2e4.\n    String.prototype.string = function(len){\n        var s = '', i = 0; \n        while (i++ < len) { s += this; } \n        return s;\n    }; \n    String.prototype.zf = function(len){return \"0\".string(len - this.length) + this;};\n    Number.prototype.zf = function(len){return this.toString().zf(len);};\n\n    \n	return (new Date().format(\"yyyyMMddHHmmss\"))\n	// \uc608\uc81c \n    //2014\ub144 01\uc6d4 30\uc77c \uc624\ud6c4 01\uc2dc 45\ubd84 02\ucd08\n    //console.log(new Date().format(\"yyyy\ub144 MM\uc6d4 dd\uc77c a/p hh\uc2dc mm\ubd84 ss\ucd08\")); \n    //2014-01-30\n    //console.log(new Date().format(\"yyyy-MM-dd\")); \n    //'14 01.30\n    //console.log(new Date().format(\"'yy MM.dd\")); \n    //2014-01-30 \ubaa9\uc694\uc77c\n    //console.log(new Date().format(\"yyyy-MM-dd E\")); \n    //\ud604\uc7ac\ub144\ub3c4 : 2014\n    //console.log(\"\ud604\uc7ac\ub144\ub3c4 : \" + new Date().format(\"yyyy\"));\n    \n\n    //\uc815\uaddc\ud45c\ud604\uc2dd \ud50c\ub798\uadf8\n    //i : \ub300\uc18c\ubb38\uc790  \uad6c\ubcc4\ud558\uc9c0 \uc54a\uc74c\n    //g : \uc804\uc5ed\ub9e4\uce6d \uc218\ud589, \uccab\ubc88\uc9f8 \ub9e4\uce58\uc5d0\uc11c \ub05d\ub0b4\uc9c0 \uc54a\uace0 \ub9e4\uce58\ub418\ub294 \ubaa8\ub4e0 \uac83\uc744 \ucc3e\ub294\ub2e4.\n    \n\n    //alert(new Date()+\"\\r\\n\"\n          //+new Date().format(\"yyyy\ub144 MM\uc6d4 dd\uc77c a/p hh\uc2dc mm\ubd84 ss\ucd08\")+\"\\r\\n\"\n          //+new Date().format(\"yyyy-MM-dd\"));\n\n}\n\n\n\n\n\n\n\n\nfunction MM_callJS(jsStr) \n{ //v2.0\n	return eval(jsStr)\n}\n\n// \uae38\uc774 \uacc4\uc0b0\nString.prototype.bytes = function(){\n	str = this != window ? this : str;\n	var len = 0; //bug. \uc774 \ud55c\uc904\ub54c\ubb38\uc5d0 \uace0\uc0dd\uc744.. \ub123\uc5b4\uc8fc\uc138\uc694. -_-;; \n	for(j=0; j<str.length; j++) \n	{\n		var chr = str.charAt(j);\n		len += (chr.charCodeAt() > 128) ? 2 : 1\n	}\n	return len;\n}\n\nfunction isEmpty(input) {\n	if (input.value == null || input.value.replace(/ /gi,\"\") == \"\") {\n		return true;\n	}\n	return false;\n}\n\nfunction CheckSendForm() {\n\n	var readForm = document.readForm;\n	var sendForm = document.sendForm;\n	\n	if (readForm.id.value.length < 8) {\n		alert(\"8\uc790\ub9ac \uc774\uc0c1\uc758 \uc0ac\ubc88\uc744 \uc785\ub825\ud558\uc2ed\uc2dc\uc694.\");\n		readForm.id.focus();\n		return false;\n	}\n	//if (readForm.regno.value.length != 13) {\n		//var text2 = \"13\uc790\ub9ac\uc758 \uc8fc\ubbfc\ub4f1\ub85d\ubc88\ud638\ub97c \uc785\ub825\ud558\uc2ed\uc2dc\uc694.\\n\\n\ud655\uc778\ud558\uc2e0\ud6c4 \ub2e4\uc2dc \uc785\ub825\ud574 \uc8fc\uc138\uc694.\";\n		//alert(text2);\n		//readForm.regno.focus();\n		//return false;\n	//}\n\n	if (readForm.CN.value.length < 2) {\n		var text4 = \"2\uc790\ub9ac \uc774\uc0c1\uc758 \uc774\ub984\uc744 \uc785\ub825\ud558\uc2ed\uc2dc\uc694.\\n\\n\ud655\uc778\ud558\uc2e0\ud6c4 \ub2e4\uc2dc \uc785\ub825\ud574 \uc8fc\uc138\uc694.\";\n		alert(text4);\n		readForm.CN.focus();\n		return false;\n	}\n	if (readForm.EMAIL.value.length < 7) {\n		var text5 = \"7\uc790\ub9ac \uc774\uc0c1\uc758 E-Mail\uc774\ub098 \uc804\ud654\ubc88\ud638\ub97c \uc785\ub825\ud558\uc2ed\uc2dc\uc694.\\n\\n\ud655\uc778\ud558\uc2e0\ud6c4 \ub2e4\uc2dc \uc785\ub825\ud574 \uc8fc\uc138\uc694.\";\n		alert(text5);\n		readForm.EMAIL.focus();\n		return false;\n	}\n	\n	\n\n	if(readForm.certpass.value.length < 1)\n	{\n		alert(\"\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\ub97c \uc785\ub825\ud574 \uc8fc\uc2ed\uc2dc\uc624\");\n		readForm.certpass.focus();\n		return false;\n	}\n	\n	if(isEmpty(readForm.certpass)) 	{\n		alert(\"\uacf5\ubc31\ubb38\uc790\ub294 \ube44\ubc00\ubc88\ud638\ub85c \uc0ac\uc6a9\ud560\uc218 \uc5c6\uc2b5\ub2c8\ub2e4. \ub2e4\uc2dc \uc785\ub825\ud574 \uc8fc\uc2ed\uc2dc\uc624\");\n		readForm.certpass.focus();\n		return false;\n	}\n	//////////////////////////////////////////////////////////////////////////////////////////////////////////\n	// \ud2b9\uc218\ubb38\uc790 \uccb4\ud06c \uc2dc\uc791\n	//////////////////////////////////////////////////////////////////////////////////////////////////////////\n	var strTest = \"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~`!@#$^&*()-_+={[}]|:;<>,.?/\";\n	var isOk = false;\n	var EngSum = false;\n	var NumSum = false;\n	var SstrSum = false;\n	\n	for(intCnt =0; intCnt < readForm.certpass.value.length; intCnt++){\n		\n		strChar = readForm.certpass.value.charAt(intCnt);\n		if(strTest.indexOf(strChar) < 0 ){\n			isOk = false;\n			//alert(\"\uc785\ub825\ud560 \uc218 \uc5c6\ub294 \ud2b9\uc218\ubb38\uc790(' , '', %, \\)\ub97c \uc785\ub825\ud558\uc168\uc2b5\ub2c8\ub2e4.\"); \n			break;\n		}	\n\n		if (strChar.match(/[a-zA-Z]/)) {\n			var EngSum = 1;\n		}\n		if (strChar.match(/[0-9]/)) {\n			var NumSum = 1;\n		}\n		if (strChar.match(/[\\~\\`\\!\\@#$\\^\\&\\*\\(\\)\\-\\_\\+\\=\\[\\]\\{\\}\\|\\:\\;\\,\\.\\<\\>\\?\\/]/)) {\n			var SstrSum = 1;\n		}\n		if(EngSum == true && NumSum == true && SstrSum == true ){\n			isOk = true;\n		}\n		\n	}\n\n	if( ! isOk ){\n		alert(\"\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638 \uc785\ub825\ub780\uc5d0 \\n\\n\uc785\ub825\ud560 \uc218 \uc5c6\ub294 \ud2b9\uc218\ubb38\uc790(' , '', %, \\)\ub97c \uc785\ub825\ud558\uc168\uac70\ub098, \\n\\n\uc22b\uc790, \uc601\ubb38, \ud2b9\uc218\ubb38\uc790\ub97c \ud544\uc218\ub85c \uc870\ud569\ud558\uc5ec 9\uc790\ub9ac \uc774\uc0c1 \uc785\ub825\ud558\uc154\uc57c\ud569\ub2c8\ub2e4.\");\n		readForm.certpass.focus();\n		return false;\n	}\n\n	if( readForm.certpass.value.bytes() < 9 || readForm.certpass.value.bytes() > 30 ) {\n		alert(\"\ube44\ubc00\ubc88\ud638\ub294 \ucd5c\uc18c 9\uc790\ub9ac\uc774\uc0c1 \ucd5c\ub300 30\uc790\ub9ac\uc774\ud558\ub85c \uc785\ub825\ud574 \uc8fc\uc2ed\uc2dc\uc624.\\n\ud604\uc7ac \uae38\uc774 \" +  readForm.certpass.value.bytes() + \"\uc790\uc785\ub2c8\ub2e4.\");\n		readForm.certpass.focus();\n		return;\n	}\n	if (readForm.certpass1.value.length ==0 ) {\n		alert(\"\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\ub97c \ub2e4\uc2dc \ud55c\ubc88 \uc785\ub825\ud558\uc2ed\uc2dc\uc624.\");\n		readForm.certpass1.focus();\n		return false;\n	}\n	if (readForm.certpass.value != readForm.certpass1.value ) {\n		\n		alert(\"\uc785\ub825\ud558\uc2e0 \ub450\uac1c\uc758 \uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\uac00 \uc11c\ub85c \uc77c\uce58\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.\");\n		readForm.certpass1.value = \"\";\n		readForm.certpass1.focus();\n		return false;\n	}\n".toCharArray();
    _jsp_string9 = "\n							<input type=\"hidden\" name=\"sms\" maxlength=\"6\" value=\"000000\" size=\"20\" style=\"border: 1px solid #dedede;\" />\n						".toCharArray();
    _jsp_string5 = "	\nfunction goOpenSms()\n{\n	var	url=null;\n	var tid = getStrDate();\n	var form = document.readForm;\n	form.tmid.value = tid ;\n	//alert(\"tmid : \"+ form.tmid.value + \" / tid=\" + tid);\n	//if (readForm.id.value.length !=8 )\n	//{\n		//alert(\"8\uc790\ub9ac\uc758 \uc0ac\ubc88\uc744 \uc785\ub825\ud574 \uc8fc\uc2ed\uc2dc\uc624.\");\n		//readForm.id.focus();\n		//return ;\n	//}\n	//if (readForm.certpass.value.length < 8) {\n		//alert(\"8\uc790\ub9ac \uc774\uc0c1\uc758 \uc778\uc99d\uc11c \ud328\uc2a4\uc6cc\ub4dc\ub97c \uc785\ub825\ud558\uc2ed\uc2dc\uc694 \\n\\n\ud655\uc778\ud558\uc2e0\ud6c4 \ub2e4\uc2dc \uc785\ub825\ud574 \uc8fc\uc138\uc694.\");\n		//readForm.certpass.focus();\n		//return false;\n	//}\n	//if( readForm.certpass.value.bytes() < 9 || readForm.certpass.value.bytes() > 30 ) {\n		//alert(\"\ube44\ubc00\ubc88\ud638\ub294 \ucd5c\uc18c 9\uc790\ub9ac\uc774\uc0c1 \ucd5c\ub300 30\uc790\ub9ac\uc774\ud558\ub85c \uc785\ub825\ud574 \uc8fc\uc2ed\uc2dc\uc624.\\n\ud604\uc7ac \uae38\uc774 \" +  readForm.certpass.value.bytes() + \"\uc790\uc785\ub2c8\ub2e4.\");\n		//readForm.certpass.focus();\n		//return;\n	//}\n	//if (readForm.certpass1.value.length ==0 ) {\n		//var text8 = \"\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\ub97c \ub2e4\uc2dc \ud55c\ubc88 \uc785\ub825\ud558\uc2ed\uc2dc\uc624.\";\n		//alert(text8);\n		//readForm.certpass1.focus();\n		//return false;\n	//}\n	//if (readForm.certpass.value != readForm.certpass1.value ) {\n		\n		//alert(\"\uc785\ub825\ud558\uc2e0 \ub450\uac1c\uc758 \uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\uac00 \uc11c\ub85c \uc77c\uce58\ud558\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4.\");\n		//readForm.certpass1.value = \"\";\n		//readForm.certpass1.focus();\n		//return false;\n	//}\n	clearInterval(timerID);\n	var x1 = document.getElementById(\"time\");\n	x1.innerHTML = '';\n\n	url=\"http://idmake.kepco.co.kr:8080/idmake_sms/websmsform.jsp?empno=\"+form.id.value+\"&tmid=\"+tid  ;\n	window.open(url, \"sms\", \"WIDTH=330,HEIGHT=370,TOP=0,LEFT=0,scrollbars=yes\");\n}\n".toCharArray();
    _jsp_string6 = "\n\nfunction fnc_reset() {\n	document.getElementById(\"timeLayer\").style.display = 'none';\n	document.readForm.reset();\n	clearInterval(timerID);\n	var x1 = document.getElementById(\"time\");\n	x1.innerHTML = '';\n}\n</script>\n\n<!--[if IE 6]>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie6.css\">\n<![endif]-->\n<!--[if IE 7]>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"css/ie7.css\">\n<![endif]-->\n</head> \n<body onload=\"aa();document.readForm.id.focus();defaultStatus='';\">\n\n<div id=\"header\">\n	<!-- MAIN MENU START -->\n	<script language=\"javascript\">dspMainMenu();</script>\n	<!-- MAIN MENU END -->\n</div>\n\n<div style=\"height:10px;\"></div>\n<div id=\"subtop\">\n	<ul class=\"subtoptxt\">\n		<li class=\"toptxtcon\">\uc778\uc99d\uc13c\ud130 \uc774\uc6a9\ud558\uae30</li>\n		<li class=\"toptxtcon01\" style=\"font-weight:bold; color:#000; text-decoration:underline;\"><a href=\"ini_certNew.jsps\">\uc778\uc99d\uc11c \ubc1c\uae09</a></li>\n		<li class=\"toptxtcon01\"><a href=\"ini_certRevoke.jsp\">\uc778\uc99d\uc11c \ud3d0\uae30</a></li>\n		<li class=\"toptxtcon01\"><a href=\"ini_myCert_info.jsp\">\uc778\uc99d\uc11c \uad00\ub9ac</a></li>\n	</ul>\n</div>\n\n\n<div id=\"subissue\">\n	<ul>\n		<li><img src=\"img/subtitle0101.gif\" alt=\"\uc778\uc99d\uc11c\ubc1c\uae09_\uc778\uc99d\uc11c\ub97c \ubc1c\uae09\ud574\ub4dc\ub9bd\ub2c8\ub2e4.\"></li>\n		<li class=\"stitle\"><img src=\"img/subtitle0201.gif\" alt=\"\uc778\uc99d\uc11c\ubc1c\uae09_\uc785\ub825\"></li>\n		\n		<li class=\"box\" style=\"overflow:hidden;\">\n			<form action=\"./ini_certNew_checkid.jsp\" method=\"post\" name=\"sendForm\">\n			<input type=\"hidden\" name=\"INIpluginData\" value=\"\" />\n			</form>\n			<form name=\"readForm\">\n			<input type=\"hidden\" name=\"regno\" value=\"0000000000000\" />\n			<input type=\"hidden\" name=\"CN\" value=\"\ud55c\uc804\uc0ac\uc6a9\uc790\" />\n			<input type=\"hidden\" name=\"EMAIL\" value=\"mailto@initech.com\" />\n			<input type=\"hidden\" name=\"pw\" value=\"\" />\n			<input type=\"hidden\" name=\"tmid\" value=\"".toCharArray();
    _jsp_string8 = "\n						<tr>\n							<td style=\"text-align:right;padding:3px;\"><b>\uc778\uc99d\ubc88\ud638</b></td>\n							<td style=\"padding:3px;\">\n								<input type=\"text\" name=\"sms\" maxlength=\"6\" size=\"20\" style=\"border: 1px solid #dedede; width:120px;\" />\n							</td>\n							<td style=\"text-align:left;\"><img src=\"img/btn_phnb.gif\" alt=\"\uc778\uc99d\ubc88\ud638\ubc1b\uae30\" align=\"center\" style=\"cursor:pointer;\" onclick=\"CheckSendForm();\"><!-- goOpenSms() -->\n							</td>\n						</tr>\n						<tr id=\"timeLayer\" style=\"display:none;\">\n							<td style=\"text-align:right;padding:3px;\"><b>\uc778\uc99d\ubc88\ud638 \uc785\ub825\uc2dc\uac04</b></td>\n							<td style=\"padding:3px;\"><span id=\"time\" style=\"font-weight:bold; color:blue; font-size:22px;\"></span></td>\n							<td></td>\n						</tr>\n						<!--\n						<tr>\n							<td>&nbsp;</td>\n							<td style=\"padding:3px;\" colspan=\"2\">\n								<img src=\"img/bullet_list.gif\" align=\"center\"> \uc778\uc99d\ubc88\ud638\ub294 \uc694\uccad \ud6c4 5\ubd84 \uc774\ub0b4\uc5d0 \uc785\ub825\ud574\uc57c \uc720\ud6a8\ud569\ub2c8\ub2e4.\n								<br />\n								<img src=\"img/bullet_list.gif\" align=\"center\"> SMS \uc778\uc99d \ubb38\uc790\ub294\n								<br />\n								&nbsp;&nbsp;&nbsp;- <span style=\"color:#6600ff;\">&quot;[\ud55c\uc804 \uc778\ud130\ub137\ub9dd] \uc778\uc99d\uc11c \ubc1c\uae09\uc6a9 \uc778\uc99d\ubc88\ud638\ub294 [000000]\uc785\ub2c8\ub2e4.&quot;</span> \ub77c\ub294 \ud615\ud0dc\ub85c \uc804\uc1a1\ub418\uba70,\n								<br />\n								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ubc1c\uc2e0\ubc88\ud638\ub294 <span style=\"color:#6600ff;\">&quot;061-345-8000&quot;</span>\uc785\ub2c8\ub2e4.\n								<br />\n								<img src=\"img/bullet_list.gif\" align=\"center\"> SMS \uc778\uc99d \ubb38\uc790\ub97c \uc218\uc2e0\ubc1b\uc9c0 \ubabb\ud558\uc2e4 \ub54c\ub294, <span style=\"color:#ff0033;font-weight:bold;\">\ubc1c\uc2e0\ubc88\ud638 \ub610\ub294 \uc704 \ubb38\uc790</span>\uac00 \uae08\uc9c0 \ub2e8\uc5b4\ub85c \ud3ec\ud568\ub418\uc5b4 \uc788\ub294\uc9c0 \ud655\uc778\ud558\uc2dc\uae30 \ubc14\ub78d\ub2c8\ub2e4. \n							</td>\n						</tr>\n						-->\n						".toCharArray();
    _jsp_string1 = "\n\n".toCharArray();
    _jsp_string4 = "\n	readForm.CN.value = readForm.id.value;\n	readForm.pw.value = readForm.certpass.value;\n\n\n	if (EncForm2(readForm, sendForm))\n	{\n		ViewMsg();\n                checkBtn();\n		sendForm.submit();\n		return false;\n	}\n	return false;\n}\n\nfunction checkBtn() {\n  document.getElementById(\"reqBtn\").style.display=\"none\";\n}\n\nfunction ViewMsg()\n{\n	var msg = \"\uc0ac\uc6a9\uc790 \ud655\uc778\uc911 \uc785\ub2c8\ub2e4. \uc7a0\uc2dc\ub9cc \uae30\ub2e4\ub9ac\uc2ed\uc2dc\uc694.\";\n	setMsg(msg, 0, 200);\n	showMsg();\n}\n\nvar timerID;\nvar time = 300;\n\nfunction setTimerOn()\n{\n	time = 300;\n	//setTimeout('setInputNo()',300000);\n	timerID = setInterval(\"decrementTime()\", 1000);\n	document.getElementById(\"timeLayer\").style.display = '';\n}\nfunction decrementTime() {\n	\n	var x1 = document.getElementById(\"time\");\n	x1.innerHTML = toMinSec(time);\n\n	if (time > 0) time--;\n	else {\n		clearInterval(timerID);\n		setInputNo();\n	}\n}\nfunction toMinSec(t) {\n	var hour;\n	var min;\n	var sec;\n\n	hour = Math.floor(t / 3600);\n	min = Math.floor((t-(hour*3600))/60);\n	sec = t - (hour*3600) - (min*60);\n\n	if (hour < 10) hour = \"0\" + hour;\n	if (min < 10) min = \"0\" + min;\n	if (sec < 10) sec = \"0\" + sec;\n	\n	return (min + \":\" + sec);\n}\nfunction setInputNo()\n{\n	aa();\n	var text1 = \"\uc778\uc99d\ubc88\ud638 \uc785\ub825\uc2dc\uac04\uc774 \ucd08\uacfc\ub418\uc5c8\uc2b5\ub2c8\ub2e4. \\n\uc778\uc99d\ubc88\ud638\ub97c \ub2e4\uc2dc \ubc1b\uc73c\uc2e0\ud6c4 \uc778\uc99d\uc11c\ub97c \ubc1c\uae09 \ubc1b\uc73c\uc138\uc694.\"\n	alert(text1);\n	//readForm.smschk.value=\"\";\n	location.href=\"ini_certNew.jsp\";\n	//return;\n}\nfunction aa()\n{\n	readForm.sms.style.background=\"#eeeeee\";\n	readForm.sms.disabled=false;\n}\n".toCharArray();
    _jsp_string3 = "	\n	if (readForm.sms.value.length !=6) {\n		alert(\"\ubcf8\uc778 \ud655\uc778\uc744 \uc704\ud558\uc5ec, SMS \ub610\ub294 \uc774\uba54\uc77c \uc778\uc99d\uc744 \uc218\ud589\ud569\ub2c8\ub2e4\");\n		goOpenSms();\n		return false;\n	}\n	//if (readForm.smschk.value.length !=6) {\n		//alert(\"SMS\uc778\uc99d\uc808\ucc28\ub97c \ubc1f\uc9c0\uc54a\uc558\uc2b5\ub2c8\ub2e4.\\n\\nSMS \uc778\uc99d\uc744 \uc218\ud589\ud569\ub2c8\ub2e4..\");\n		//goOpenSms();\n		//return false;\n	//}\n\n	\n	//if (readForm.sms.value != readForm.smschk.value)\n	//{\n		//alert(\"\uc778\uc99d\ubc88\ud638\uac00 \uc62c\ubc14\ub974\uc9c0 \uc54a\uc2b5\ub2c8\ub2e4. \ub2e4\uc2dc \ud655\uc778\ud6c4 \uc785\ub825\ud574 \uc8fc\uc2ed\uc2dc\uc624.\");\n		//readForm.sms.value=\"\";\n		//readForm.sms.disabled=true;\n		//return false ;\n	//}\n\n".toCharArray();
    _jsp_string7 = "\" />\n			<ul style=\"padding-top:50px;\">\n				<!--<li class=\"sbtextbg\"><a href=\"#\" onclick=\"getStrDate();\"> -</a> \uc2e0\ubd84\ud655\uc778\uc5d0 \ud544\uc694\ud55c \uc544\ub798\uc758 \uc815\ubcf4\ub97c \uc785\ub825\ud558\uc2ed\uc2dc\uc624. </li>-->\n				<li class=\"sbtextbg2\" style=\"height:auto;\">\n\n					<table cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\" border=\"0\" style=\"table-layout:fixed;\">\n						<colgroup>\n							<col style=\"width:140px;\">\n							<col style=\"width:126px;\">\n							<col>\n						</colgroup>\n						<tr>\n							<td style=\"width:140px; text-align:right;padding:3px;\"><b>\uc0ac\uc6d0\ubc88\ud638</b></td>\n							<td style=\"padding:3px;\" colspan=\"2\"><input type=\"text\" name=\"id\" size=\"20\" style=\"border: 1px solid #dedede; width:120px;\" value=\"\" /></td>\n						</tr>\n						<tr>\n							<td style=\"text-align:right;padding:3px;\"><b>\ube44\ubc00\ubc88\ud638</b></td>\n							<td style=\"padding:3px;width:126px;\">\n								<input type=\"password\" name=\"certpass\" maxlength=\"30\" size=\"20\" style=\"border: 1px solid #dedede; width:120px;\" value=\"\" />\n							</td>\n							<td style=\"text-align:left;padding-left:3px;\" rowspan=\"2\">\n							<span>\n								&nbsp;\u203b\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\ub294 \ubc18\ub4dc\uc2dc \uc22b\uc790,\uc601\ubb38,\ud2b9\uc218\ubb38\uc790\ub85c \uc870\ud569\ud558\uc154\uc57c \ud569\ub2c8\ub2e4.<br />\n								&nbsp;\u203b\uc778\uc99d\uc11c \ube44\ubc00\ubc88\ud638\uc5d0 \ud2b9\uc218\ubb38\uc790 <b>\ub530\uc634\ud45c(')</b> , <b>\uc30d\ub530\uc634\ud45c(\")</b>, <b>\ud37c\uc13c\ud2b8(%)</b>, <b>\uc5ed\uc2ac\ub7ec\uc2dc(\\)</b>\ub294 <br />&nbsp;&nbsp;\uc0ac\uc6a9\ud560\uc218\uc5c6\uc2b5\ub2c8\ub2e4.</span>\n							</td>\n						</tr>\n						<tr>\n							<td style=\"text-align:right;padding:3px;\"><b>\ube44\ubc00\ubc88\ud638 \ud655\uc778</b></td>\n							<td style=\"padding:3px;\">\n								<input type=\"password\" name=\"certpass1\" maxlength=\"30\" size=\"20\" style=\"border: 1px solid #dedede; width:120px;\" value=\"\" />\n							</td>\n						</tr>\n						".toCharArray();
    _jsp_string10 = "\n					</table>\n\n\n\n\n				<!--<li class=\"dotted1\"></li>-->\n				<li style=\"padding-left:160px; height:60px;\">\n					<img src=\"img/btn_issue_new.gif\" id=\"reqBtn\" name=\"reqBtn\" border=\"0\" alt=\"\ubc1c\uae09\" style=\"cursor:pointer;\"  onclick=\"CheckSendForm();\">\n					<a href=\"#\" onclick=\"fnc_reset();\"><img src=\"img/btn_re-input_new.gif\" alt=\"\uc7ac\uc785\ub825\"></a>\n				</li>\n			</ul>\n			</form>\n		</li>\n	</ul>\n\n	<div style=\"height:20px;\"></div>\n</div>\n\n<!-- COPYRIGHT START -->\n<script language=\"javascript\">dspCopyRight();</script>\n<!-- COPYRIGHT END -->\n\n</body>\n</html>\n".toCharArray();
    _jsp_string0 = "\n\n\n\n\n\n\n\n\n\n\n".toCharArray();
  }
}
