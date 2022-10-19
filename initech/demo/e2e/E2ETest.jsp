<!-- <%-- ETETest.jsp --%> -->
<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="com.initech.iniplugin.*" %>
<%
	IniPlugin m_IP = null;
	String account = null; String money = null;
	String input1 = null; String input2 = null;
	try {
		// IniPlugin 객체 생성
		m_IP = new IniPlugin(request, response,"/home/initech/iniplugin/properties/IniPlugin.inica70.properties");    

		// IniPlugin 초기화 ? 복호화 이루어짐
		m_IP.init(); 

		if(!m_IP.isE2EMatch()){
			out.println("<font color=red><B>정합성 검증에 실패한 데이타가 있습니다.</b></font><Br><br>");		    
			out.println(m_IP.failVerifyData()); 
		}

	}catch(Exception e){
		out.println("<Br>Exception = " + e.getMessage());
		retuen;
	}

	//값 뽑아오기
	account = m_IP.getParameter("account");
	money = m_IP.getParameter("money");
	input1 = m_IP.getParameter("input1");
	input2 = m_IP.getParameter("input2");
%>
<html>
<head>	
</head>

<body>
<b>확장 E2E 키보드 보안 테스트 결과</b><br>
	<table>
		<tr>
			<td>계좌번호(account):<%=account%></td>
			<td>돈(money):<%=money%></td>
			<td>일반Text(input1):<%=input1%></td>
			<td>패스워드(input2):<%=input2%></td>
		</tr>
	</table>
</body>
</html>