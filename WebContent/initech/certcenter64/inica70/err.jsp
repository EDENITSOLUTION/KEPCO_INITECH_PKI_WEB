<%-- err.jsp --%>

<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %> 
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%
	String m_How =null;
	String m_Code = null;
	String m_ID = null;

	String m_Title = null;
	String m_ErrMsg = null;
				
 	m_ID = request.getParameter("id");
 	m_How = request.getParameter("how");
	m_Code = request.getParameter("code");
 	m_ErrMsg = request.getParameter("msg");
 
	if (m_How == null) m_How = "all";
	if (m_Code == null) m_Code = "unknown_000";
	if (m_ErrMsg != null) m_ErrMsg = new String(m_ErrMsg.getBytes("8859_1"),"KSC5601");
%>

<%@ include file="import/inica70_err.jsp" %>

<html>
<head>
	<title>인증센터 - 오류</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<style type="text/css">
	<!--
	.text {  font-family: "돋움"; font-size: 11px; text-decoration: none; line-height: 15px}
	-->
	</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="107" align="center" valign="bottom"><img src="img/error_title.gif" width="469" height="48"><br>
      <br>
    </td>
  </tr>
  <tr> 
    <td align="center"> <font size="2" color="#FF0000"> <%=m_Title%> </font><br>
      <table width="273" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="30" valign="bottom"><font size="2">오류코드 : <%=m_Code%></font></td>
        </tr>
        <tr> 
          <td height="30"><font size="2">오류내용 : <%=m_ErrMsg%></font></td>
        </tr>
        <tr> 
          <td height="30" align="center"> 
            <p><img src="img/error.gif" width="131" height="131"></p>
            <p><a href="./index.jsp"><img src="img/icon_4.gif" width="74" height="20" border="0"></a></p>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
