<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file= "./import/func.jsp" %> 
<%!


public String do_check_userinfo(String info1, String info2) {

	//STEP 1 : 넘어온 사번으로 사용자가 존재하는 지 체크하다
	//STEP 2 : 사용자가 존재한다면
	//	STEP 2-1 : 넘어온 비번을 암호화한다
	//	STEP 2-2 : 암호화한 비번과 DB에 있는 비번을 비교한다
	//	STEP 2-3 : 두개값이 같다면 RESULT=999를 리턴하고
	//	STEP 2-4 : 두개값이 다르다면 RESULT=000을 리턴한다.
	//STEP 3 : 사용자가 존재하지 않는다면 RESULT=000 으로 리턴한다
	
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
		// STEP 1 : 넘어온 사번으로 사용자가 존재하는 지 체크하다
		//-------------------------------------------    
		String queary = "SELECT USERPWD  FROM USER_PWD WHERE USERID = '"+info1+"'";
		rs = stmt.executeQuery(queary);
    
		//-------------------------------------------
		// STEP 2 : 사용자가 존재한다면
		//-------------------------------------------    
		if (rs.next())     	{
				
				//-------------------------------------------
				// STEP 2-1 : 넘어온 비번을 암호화한다
				//------------------------------------------- 
				encryptPWD = getBase64Data(getHashValue(info2));

				orgPWD = rs.getString("USERPWD");			// USERPWD

				
				//-------------------------------------------
				// STEP 2-2 : 암호화한 비번과 DB에 있는 비번을 비교한다
				//------------------------------------------- 
				if (encryptPWD.equals(orgPWD)) {
					//-------------------------------------------
					// STEP 2-3 : 두개값이 같다면 RESULT=999를 리턴하고
					//------------------------------------------- 
					buffer.append("RESULT=999");
				}else{
					//-------------------------------------------
					// STEP 2-4 : 두개값이 다르다면 RESULT=000을 리턴한다.
					//------------------------------------------- 
					buffer.append("RESULT=000");
				}
				
		}else{
			//-------------------------------------------
			// STEP 3 : 사용자가 존재하지 않는다면 RESULT=000 으로 리턴한다
			//-------------------------------------------    
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



%>	


<%!
 public byte[] getHashValue(String inputString)
    {
        MessageDigest md = null;
        
        try {
            md = MessageDigest.getInstance("MD5");
            
            md.update(inputString.getBytes());
            
        } catch (NoSuchAlgorithmException e) {
            // TODO 자동 생성된 catch 블록
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

%>