<%@ page contentType="text/html; charset=utf-8"%> 
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ include file= "./check_userinfo_func.jsp" %> 
<% response.setContentType("text/xml; charset=UTF-8"); %>
<% request.setCharacterEncoding("UTF-8"); %>
<%   	
  
String resultString = "RESULT=999";

try{
	
	String info1 = request.getParameter("info1"); //sabun
	String info2 = request.getParameter("info2"); //pwd
	String info2Dec = java.net.URLDecoder.decode(info2, "UTF-8");


	if(info1 == null || info1.equalsIgnoreCase("") == true) {
		out.println("RESULT=991"); //id 공백이거나 널이면 991
		return;
	}

	else if(info2 == null || info2.equalsIgnoreCase("") == true) {
		out.println("RESULT=992"); //pwd공백이거나 널이면 992
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

%>
