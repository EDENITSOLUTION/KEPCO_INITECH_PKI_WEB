<%@ page contentType="text/html; charset=utf-8"%> 
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%> 
<%@ page import="java.util.*"%> 
<%@ include file= "./ini_cert_valid_func.jsp" %> 
<% response.setContentType("text/xml; charset=UTF-8"); %>
<% request.setCharacterEncoding("UTF-8"); %>
<%   	
  
  String resultString="";
 
  try{

       String uid = request.getParameter("UID");
       String sn = request.getParameter("SN");


	if(uid==null|| uid.equalsIgnoreCase("")==true){
		out.println("RESULT=990");
		return;
        }


        if(sn==null|| sn.equalsIgnoreCase("")==true){
                out.println("RESULT=991");
                return;
        }

       resultString = do_op_cert_info_list(uid, sn);

        
       out.println(resultString);
   
   
   }catch(Exception e){
    resultString = do_protocol_error();
    out.println(resultString);
    return;
   }

%>
