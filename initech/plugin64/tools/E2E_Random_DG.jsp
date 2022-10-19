<%@ page language="java" %><%@ page contentType="text/html" %><%@ page import=" javax.servlet.*,javax.servlet.http.*,java.io.*,sun.misc.*,com.initech.iniplugin.Nonce,java.net.*,com.initech.util.*" %><% 
  String e2e_UniqueKey = null;
	e2e_UniqueKey = request.getParameter("UniqueKey");
	String time= Long.toString(System.currentTimeMillis()) + "_" + ((int)0x0ff & java.net.InetAddress.getLocalHost().getAddress()[3]);  
	try {	
		byte[] encode = Base64Util.encode(time.getBytes(), false);
		int base64encodetimelength=encode.length;
		String strbase64encodetimelength=Integer.toString(base64encodetimelength);
		String test=strConvert(strbase64encodetimelength,4);
		Nonce e2e_value = new Nonce();
	  e2e_value.setValue(time);	
	  session.setAttribute("TP_"+e2e_UniqueKey, e2e_value);
		out.print(test+"@"+new String(encode));
	} catch (Exception e){ };	
%>
<%!
public static String strConvert(String s, int i)
{
     StringBuffer sb = new StringBuffer();
		 int k = s.length();
		 for(int j = 0; j <i-k; j++){
			 sb.append("0");
		 }
		 sb.append(s);
     return sb.toString();
}
%>