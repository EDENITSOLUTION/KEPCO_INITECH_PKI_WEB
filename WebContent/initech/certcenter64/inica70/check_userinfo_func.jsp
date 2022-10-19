<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file= "./import/func.jsp" %> 
<%!


public String do_check_userinfo(String info1, String info2) {

	//STEP 1 : �Ѿ�� ������� ����ڰ� �����ϴ� �� üũ�ϴ�
	//STEP 2 : ����ڰ� �����Ѵٸ�
	//	STEP 2-1 : �Ѿ�� ����� ��ȣȭ�Ѵ�
	//	STEP 2-2 : ��ȣȭ�� ����� DB�� �ִ� ����� ���Ѵ�
	//	STEP 2-3 : �ΰ����� ���ٸ� RESULT=999�� �����ϰ�
	//	STEP 2-4 : �ΰ����� �ٸ��ٸ� RESULT=000�� �����Ѵ�.
	//STEP 3 : ����ڰ� �������� �ʴ´ٸ� RESULT=000 ���� �����Ѵ�
	
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
		// STEP 1 : �Ѿ�� ������� ����ڰ� �����ϴ� �� üũ�ϴ�
		//-------------------------------------------    
		String queary = "SELECT USERPWD  FROM USER_PWD WHERE USERID = '"+info1+"'";
		rs = stmt.executeQuery(queary);
    
		//-------------------------------------------
		// STEP 2 : ����ڰ� �����Ѵٸ�
		//-------------------------------------------    
		if (rs.next())     	{
				
				//-------------------------------------------
				// STEP 2-1 : �Ѿ�� ����� ��ȣȭ�Ѵ�
				//------------------------------------------- 
				encryptPWD = getBase64Data(getHashValue(info2));

				orgPWD = rs.getString("USERPWD");			// USERPWD

				
				//-------------------------------------------
				// STEP 2-2 : ��ȣȭ�� ����� DB�� �ִ� ����� ���Ѵ�
				//------------------------------------------- 
				if (encryptPWD.equals(orgPWD)) {
					//-------------------------------------------
					// STEP 2-3 : �ΰ����� ���ٸ� RESULT=999�� �����ϰ�
					//------------------------------------------- 
					buffer.append("RESULT=999");
				}else{
					//-------------------------------------------
					// STEP 2-4 : �ΰ����� �ٸ��ٸ� RESULT=000�� �����Ѵ�.
					//------------------------------------------- 
					buffer.append("RESULT=000");
				}
				
		}else{
			//-------------------------------------------
			// STEP 3 : ����ڰ� �������� �ʴ´ٸ� RESULT=000 ���� �����Ѵ�
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
            // TODO �ڵ� ������ catch ���
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