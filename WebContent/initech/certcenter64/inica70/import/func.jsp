<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%> 
<%@ page import="java.util.*"%> 
<%!




        

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


%>	
