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
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class _check_0userinfo__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  private boolean _caucho_isNotModified;
  private com.caucho.jsp.PageManager _jsp_pageManager;






          

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







  public String do_check_userinfo(String info1, String info2) {

  	//STEP 1 : \ufffd\u047e\ufffd \ufffd\ufffd8\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd x\ufffd\ufffd\ufffd\ufffd\ufffd \u00fc\u0169\ufffd\ufffd\ufffd	//STEP 2 : \ufffd\ufffd\ufffd\ufffd\ufffd x\ufffd\ufffd\ufffd\u0678\ufffd//	STEP 2-1 : \ufffd\u047e\ufffd \ufffd\ufffd\ufffd \ufffd\ufffd\ufffd\u022d\ufffd\ufffd\ufffd	//	STEP 2-2 : \ufffd\ufffd\ufffd\u022d\ufffd \ufffd\ufffd\ufffd\ufffd\ufffd \ufffd\ufffd\ufffd\ufffd\ufffd\ufffd \ufffd\ufffd\u0474\ufffd	//	STEP 2-3 : \ufffd\u03b0\ufffd\ufffd\ufffd\ufffd \ufffd\ufffd\ufffd\u0678\ufffdESULT=999\ufffd\ufffd \ufffd\ufffd\ufffd\ufffd\ufffd\ufffd//	STEP 2-4 : \ufffd\u03b0\ufffd\ufffd\ufffd\ufffd \ufffd\u0678\ufffd\ufffd\u0678\ufffdESULT=000; \ufffd\ufffd\ufffd\ufffd\ufffd\ufffd
  	//STEP 3 : \ufffd\ufffd\ufffd\ufffd\ufffd x\ufffd\ufffd\ufffd \ufffd\u02b4\u00b4\u0678\ufffdESULT=000 8\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd	
  	Connection conn = null;
  	ResultSet rs    = null;
  	
  	String  orgPWD = "";
  	String encryptPWD = "" ;

  	StringBuffer buffer = new StringBuffer();

  	
  	try{
        
  		conn = getConnection();
  		conn.setAutoCommit(false);		
  		Statement stmt = conn.createStatement();   


  	
  		//-------------------------------------------
  		// STEP 1 : \ufffd\u047e\ufffd \ufffd\ufffd8\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd x\ufffd\ufffd\ufffd\ufffd\ufffd \u00fc\u0169\ufffd\ufffd\ufffd		//-------------------------------------------    
  		String queary = "SELECT USERPWD  FROM USER_PWD WHERE USERID = '"+info1+"'";
  		rs = stmt.executeQuery(queary);
      
  		//-------------------------------------------
  		// STEP 2 : \ufffd\ufffd\ufffd\ufffd\ufffd x\ufffd\ufffd\ufffd\u0678\ufffd	//-------------------------------------------    
  		if (rs.next())     	{
  				
  				//-------------------------------------------
  				// STEP 2-1 : \ufffd\u047e\ufffd \ufffd\ufffd\ufffd \ufffd\ufffd\ufffd\u022d\ufffd\ufffd\ufffd				//------------------------------------------- 
  				encryptPWD = getBase64Data(getHashValue(info2));

  				orgPWD = rs.getString("USERPWD");			// USERPWD

  				
  				//-------------------------------------------
  				// STEP 2-2 : \ufffd\ufffd\ufffd\u022d\ufffd \ufffd\ufffd\ufffd\ufffd\ufffd \ufffd\ufffd\ufffd\ufffd\ufffd\ufffd \ufffd\ufffd\u0474\ufffd				//------------------------------------------- 
  				if (encryptPWD.equals(orgPWD)) {
  					//-------------------------------------------
  					// STEP 2-3 : \ufffd\u03b0\ufffd\ufffd\ufffd\ufffd \ufffd\ufffd\ufffd\u0678\ufffdESULT=999\ufffd\ufffd \ufffd\ufffd\ufffd\ufffd\ufffd\ufffd				//------------------------------------------- 
  					buffer.append("RESULT=999");
  				}else{
  					//-------------------------------------------
  					// STEP 2-4 : \ufffd\u03b0\ufffd\ufffd\ufffd\ufffd \ufffd\u0678\ufffd\ufffd\u0678\ufffdESULT=000; \ufffd\ufffd\ufffd\ufffd\ufffd\ufffd
  					//------------------------------------------- 
  					buffer.append("RESULT=000");
  				}
  				
  		}else{
  			//-------------------------------------------
  			// STEP 3 : \ufffd\ufffd\ufffd\ufffd\ufffd x\ufffd\ufffd\ufffd \ufffd\u02b4\u00b4\u0678\ufffdESULT=000 8\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd			//-------------------------------------------    
  			buffer.append("RESULT=000");
  		}


  		
    } catch (Exception e) {
      	e.printStackTrace();
  			buffer.append("RESULT=998");
    }finally{
  	   try{
  	    conn.close();
  	  }catch(Exception e){
  	    e.printStackTrace();
  	  }
    }
  	
  	return buffer.toString();
  }






   public byte[] getHashValue(String inputString)
      {
          MessageDigest md = null;
          
          try {
              md = MessageDigest.getInstance("MD5");
              
              md.update(inputString.getBytes());
              
          } catch (NoSuchAlgorithmException e) {
              // TODO \ufffd\ufffd\ufffd \ufffd\ue5b3\udeb5\ufffdcatch \ufffd\ufffd
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
    response.setContentType("text/html; charset=utf-8");

    out.write(_jsp_string0, 0, _jsp_string0.length);
     response.setContentType("text/xml; charset=UTF-8"); 
    out.write(_jsp_string1, 0, _jsp_string1.length);
     request.setCharacterEncoding("UTF-8"); 
    out.write(_jsp_string1, 0, _jsp_string1.length);
       	
  
String resultString = "RESULT=999";

try{
	
	String info1 = request.getParameter("info1"); //sabun
	String info2 = request.getParameter("info2"); //pwd
	String info2Dec = java.net.URLDecoder.decode(info2, "UTF-8");


	if(info1 == null || info1.equalsIgnoreCase("") == true) {
		out.println("RESULT=991"); //id \ufffd\ufffd\u0330\u0173\ufffd \ufffd\ufffd\u0338\ufffd91
		return;
	}

	else if(info2 == null || info2.equalsIgnoreCase("") == true) {
		out.println("RESULT=992"); //pwd\ufffd\ufffd\u0330\u0173\ufffd \ufffd\ufffd\u0338\ufffd92
		return;
	}

	else {

		resultString = do_check_userinfo(info1, info2);


		out.println(resultString);

	}


}catch(Exception e){
	resultString = do_protocol_error();
	out.println(resultString);
	return;
}


    out.write(_jsp_string1, 0, _jsp_string1.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/check_userinfo.jsp"), -7547951894164037553L, true);
    _caucho_depends.add(depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("certcenter64/inica70/check_userinfo_func.jsp"), 204477625455088321L, true);
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

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = " \r\n\r\n \n\n\n\n \n \n	\n \n	\n\n\n \r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
