<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>

<%
	String strA = request.getParameter("A");
	String strB = request.getParameter("B");
	String strC = request.getParameter("C");
	String strCheck = request.getParameter("check");
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<title>Normal Test Result</title>	
</head>

<body>

<br><b> 일반적인 POST 전송 결과값입니다.</b><br>
<br> request.getParameter("A") = [<%=strA%>]
<br> request.getParameter("B") = [<%=strB%>]
<br> request.getParameter("C") = [<%=strC%>]
<br> request.getParameter("check") = [<%=strCheck%>]

<br><br><b> 한글 입/출력 테스트입니다.</b><br>
<%
	String testCode = strC;
	String testCode2 = "홍길동";
	String[] hangul = {"", "UTF8", "EUC_KR", "8859_1", "KSC5601"};
	String ret;
	byte[] buf;
	String ret2;
	byte[] buf2;

	out.print(" ["+testCode+"]");
	out.print(" ["+testCode2+"]");
	out.print(" ==> not convert"); 

	out.print(" ["+ new String(testCode.getBytes()) +"] <== new String(tmp.getBytes())");

	out.println("<br>");

	for(int i=0; i<hangul.length; i++){
		for(int j=0; j<hangul.length; j++){
			if(hangul[i].equals("")) {
				buf = testCode.getBytes();
				buf2 = testCode2.getBytes();
			} else { 
				buf = testCode.getBytes(hangul[i]);
				buf2 = testCode2.getBytes(hangul[i]);
			}
		
			if(hangul[j].equals("")) {
				ret = new String(buf);
				out.println(ret);
				ret2 = new String(buf2);
			} else {
				ret = new String(buf, hangul[j]);
				ret2 = new String(buf2, hangul[j]);
			}

			out.print(" ["+ret+"]");
			out.print(" ["+ret2+"]");
			out.print(" ==> new String(tmp.getBytes(\"" + hangul[i] + "\"),\"" + hangul[j] + "\")"); 
			out.println("<br>");
		}
	}
%>

<br><br>
<center><input type=button value='되돌아가기' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>

</body></html>
