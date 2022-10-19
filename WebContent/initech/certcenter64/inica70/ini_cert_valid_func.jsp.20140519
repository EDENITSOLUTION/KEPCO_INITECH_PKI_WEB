<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%> 
<%@ page import="java.util.*"%> 
<%@ include file= "./import/func.jsp" %> 
<%!


public String do_op_cert_info_list(String uid, String certSN) {

	Connection conn = null;
	ResultSet rs    = null;
	String  rs1 = "";
	String rs2 = "";
	String rs4 = "";
	String rs5 = "";
	String rs6 = "";
	String rs7 = "";
	String rs8 = "";
	String rs9 = "";
	String rs15 = "";

	StringBuffer buffer = new StringBuffer();

	
	try{
      
		conn = getConnection();
		conn.setAutoCommit(false);		
		Statement stmt = conn.createStatement();   


	
		//-------------------------------------------
		// Query section
		//-------------------------------------------    
		String queary = "SELECT to_char(to_number(serial)) as serial, status  FROM ldap_info WHERE userid = '"+uid+"'";
		rs = stmt.executeQuery(queary);
    	
    	int i = 0;
    	while(rs.next())     	{
	    	
		  	  rs1 = rs.getString(1);			// CERTSERIAL
		  	  rs2 = rs.getString(2);			// CERTSTAT
		  	  
		  	  //for debug 
		  	  //buffer.append("<record>");
		  	  //buffer.append("<index>" + i + "</index>");
		  	  //buffer.append("<cert_serial>" + rs1 + "</cert_serial>");
			  //buffer.append("<cert_stat>" + rs2 + "</cert_stat>");
		  	  //buffer.append("</record>");
		  	
				i++;
    	}
    	
	
		if( rs1.equalsIgnoreCase(certSN)==true){

			if(rs2.equalsIgnoreCase("V")==true)
				buffer.append("RESULT=000");
			else
				buffer.append("RESULT=999");
			
		}else{
	 	//debug	
		//buffer.append(queary+uid+certSN+" RESULT=997 "+rs1);
			buffer.append("RESULT=999");
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



%>	
