<%-- ScriptTest	.jsp --%>

<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="java.net.*" %>

<% try { %>

<html>
	<head></head>
<body>
	<p><center><b>암호화/Base64인코딩시 달라지는 Size</b></center><br>
	<table align="center" width=450 border="1" cellpadding="1" cellspacing="0" bgcolor="#E1E2D8" bordercolor="white">
		<tr>
			<td width="80"><b>원본Size</b></td>
			<td width="80"><b>SEED-CBC</b></td>
			<td width="80"><b>BASE64(+-2)</b></td>
			<td><b>Seed+Base64(+-2)</b></td>
		</tr>
	</table>
	<table align="center" width=450 border="1" cellpadding="1" cellspacing="0" 	bgcolor="#C9CCB0" bordercolor="white">
<%
	for (int i=0; i<100; i++) {
		int in_len = i;
		int seed_cbc_len = 16 - (in_len % 16) + in_len;
		
		int tmp_len =  3 - ( (in_len-1) %3 ) + in_len-1;
		int b64_len = tmp_len * 4 / 3;
		b64_len = b64_len + (b64_len / 64) + 1;


		in_len = seed_cbc_len;
		int tmp_len2 =  3 - ( (in_len-1) %3 ) + in_len-1;
		int seed_cbc_b64_len = tmp_len2 * 4 / 3;
		seed_cbc_b64_len = seed_cbc_b64_len + (seed_cbc_b64_len / 64) + 1;

		out.println("	<tr>");
		out.println("		<td width=80><b>"+ i + "</b></td>");
		out.println("		<td width=80><b>"+ seed_cbc_len + "</b></td>");
		out.println("		<td width=80><b>"+ b64_len + "</b></td>");
		out.println("		<td><b>"+ seed_cbc_b64_len + "</b></td>");
		out.println("	</tr>");
	}
%>
<%
	for (int i=100; i<200; i=i+4) {
		int in_len = i;
		int seed_cbc_len = 16 - (in_len % 16) + in_len;
		
		int tmp_len =  3 - ( (in_len-1) %3 ) + in_len-1;
		int b64_len = tmp_len * 4 / 3;
		b64_len = b64_len + (b64_len / 64) + 1;

		in_len = seed_cbc_len;
		int tmp_len2 =  3 - ( (in_len-1) %3 ) + in_len-1;
		int seed_cbc_b64_len = tmp_len2 * 4 / 3;
		seed_cbc_b64_len = seed_cbc_b64_len + (seed_cbc_b64_len / 64) + 1;

		out.println("	<tr>");
		out.println("		<td width=80><b>"+ i + "</b></td>");
		out.println("		<td width=80><b>"+ seed_cbc_len + "</b></td>");
		out.println("		<td width=80><b>"+ b64_len + "</b></td>");
		out.println("		<td><b>"+ seed_cbc_b64_len + "</b></td>");
		out.println("	</tr>");
	}
%>
<%
	for (int i=200; i<2000; i+=100) {
		int in_len = i;
		int seed_cbc_len = 16 - (in_len % 16) + in_len;
		
		int tmp_len =  3 - ( (in_len-1) %3 ) + in_len-1;
		int b64_len = tmp_len * 4 / 3;
		b64_len = b64_len + (b64_len / 64) + 1;


		in_len = seed_cbc_len;
		int tmp_len2 =  3 - ( (in_len-1) %3 ) + in_len-1;
		int seed_cbc_b64_len = tmp_len2 * 4 / 3;
		seed_cbc_b64_len = seed_cbc_b64_len + (seed_cbc_b64_len / 64) + 1;

		out.println("	<tr>");
		out.println("		<td width=80><b>"+ i + "</b></td>");
		out.println("		<td width=80><b>"+ seed_cbc_len + "</b></td>");
		out.println("		<td width=80><b>"+ b64_len + "</b></td>");
		out.println("		<td><b>"+ seed_cbc_b64_len + "</b></td>");
		out.println("	</tr>");
	}
%>
<%--
	for (int i=100; i<10000; i+=100) {
		int in_len = i;
		int seed_cbc_len = 16 - (in_len % 16) + in_len;
		

		in_len = i;
		int tmp_len =  3 - ( (in_len-1) %3 ) + in_len-1;
		int b64_len = tmp_len * 4 / 3;

		in_len = seed_cbc_len;
		int tmp_len2 =  3 - ( (in_len-1) %3 ) + in_len-1;
		int b64_len2 = tmp_len * 4 / 3;


		out.println("	<tr>");
		out.println("		<td width=60><b>"+ i + "</b></td>");
		out.println("		<td width=60><b>"+ seed_cbc_len + "</b></td>");
		out.println("		<td width=60><b>"+ tmp_len + "</b></td>");
		out.println("		<td width=60><b>"+ b64_len + "</b></td>");
		out.println("		<td width=60><b>"+ tmp_len2 + "</b></td>");
		out.println("		<td><b>"+ b64_len2 + "</b></td>");
		out.println("	</tr>");
	}
--%>


	</table>
</body>

<% }catch (Exception e) {
	out.println("<br>FileName = ocspcd.jsp");
	out.println("<br>Exception = " + e.getMessage());
	out.println("<br><br><b>printStackTrace</b><br>");
	StringWriter sw = new StringWriter();
	PrintWriter pw = new PrintWriter(sw);
	e.printStackTrace(pw);
	out.println(sw.toString());
} %>