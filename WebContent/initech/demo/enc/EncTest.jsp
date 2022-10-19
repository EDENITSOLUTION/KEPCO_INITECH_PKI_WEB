<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="com.initech.iniplugin.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ include file ="../include/Init.jsp"%>

<%
	Properties InData = m_IP.getDecryptParameter();
	String notParseData = m_IP.getNotParsedData();
	String encALL = InData.toString();
	String encA = m_IP.getParameter("A");
	String encB = m_IP.getParameter("B");
	String encC = m_IP.getParameter("C");
	String encCheck = m_IP.getParameter("check");
	String encbox = m_IP.getParameter("selectType");

/*	String value = null;
	StringBuffer sb = new StringBuffer();
	Enumeration enumlist = m_IP.getParameterNames();
	while(enumlist.hasMoreElements()){
		String name = (String)enumlist.nextElement();
		sb.append("<br>[" + name + "] = [" + value + "]");
	}
	String outData = sb.toString();
	out.println(outData);
*/

	String encOutT = m_IP.isprint(encALL, true);
	String encOutF = m_IP.isprint(encALL, false);

%>

<html>
<head>
	<title>Script Test Result</title>
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>

<br/>
<br><b> 아래의 값은 브라우져가 암호화하여 전송한 INIpluginData 값입니다.</b>
<br> request.getParameter("INIpluginData") = [<%=request.getParameter("INIpluginData")%>]
<br/><br/>

<br/>
<br><br><b> 아래의 값은 null로 나와야 합니다.</b>
<br> request.getParameter("A") = [<%=request.getParameter("A")%>]
<br> request.getParameter("B") = [<%=request.getParameter("B")%>]
<br> request.getParameter("C") = [<%=request.getParameter("C")%>]
<br> request.getParameter("check") = [<%=request.getParameter("check")%>]
<br> request.getParameter("selectType") = [<%=request.getParameter("selectType")%>]

<br><br><b> 아래의 값은 실제로 입력한 값이 나와야 합니다.</b>
<br> IP.getNotParseData = [<%=notParseData%>]
<br> IP.getDecryptParameter().toString() = [<%=encALL%>]
<br> IP.getParameter("A") = [<%=encA%>]
<br> IP.getParameter("B") = [<%=encB%>]
<br> IP.getParameter("C") = [<%=encC%>]
<br> IP.getParameter("check") = [<%=encCheck%>]
<br> IP.getParameter("selectType") = [<%=encbox%>]

<br><br><b>아래의 내용은 서버가 암호화하여 출력하는 예제입니다.</b>

<br><br><b>1. IP.isprint(OutData, true) 사용</b><br>
<%=encOutT%>

<br><br><b>2. IP.isprint(OutData, false) 사용</b><br>
<%=encOutF%>

<br><br><b>아래의 내용은 서버가 암호화하여 출력하는 예제입니다.</b>
<br/><B>out = m_IP.startEncrypt(out); 시작</B><br/>
<% out = m_IP.startEncrypt(out); %>
<br><br><b>1. 암호화 사용</b><br/><br/>
<% out = m_IP.endEncrypt(out); %>
<br/><B>out = m_IP.endEncrypt(out); 끝</B><br/>
<br>
<br><br><b>2. 암호화 사용</b><br/><br/>

<center>
<input type=button value="되돌아가기" onClick="history.back();"></center>
<hr size="1" width="550" color="#CCCCCC"></p>
<p align="center"><font size="2">Copyright(c) 1997-2007 by INITECH</font><br></p>


</body></html>
