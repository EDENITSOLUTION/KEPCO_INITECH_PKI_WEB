<!-- <%-- ETETest.jsp --%> -->
<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="com.initech.iniplugin.*" %>
<%
	IniPlugin m_IP = null;
	String account = null; String money = null;
	String input1 = null; String input2 = null;
	try {
		// IniPlugin ��ü ����
		m_IP = new IniPlugin(request, response,"/home/initech/iniplugin/properties/IniPlugin.inica70.properties");    

		// IniPlugin �ʱ�ȭ ? ��ȣȭ �̷����
		m_IP.init(); 

		if(!m_IP.isE2EMatch()){
			out.println("<font color=red><B>���ռ� ������ ������ ����Ÿ�� �ֽ��ϴ�.</b></font><Br><br>");		    
			out.println(m_IP.failVerifyData()); 
		}

	}catch(Exception e){
		out.println("<Br>Exception = " + e.getMessage());
		retuen;
	}

	//�� �̾ƿ���
	account = m_IP.getParameter("account");
	money = m_IP.getParameter("money");
	input1 = m_IP.getParameter("input1");
	input2 = m_IP.getParameter("input2");
%>
<html>
<head>	
</head>

<body>
<b>Ȯ�� E2E Ű���� ���� �׽�Ʈ ���</b><br>
	<table>
		<tr>
			<td>���¹�ȣ(account):<%=account%></td>
			<td>��(money):<%=money%></td>
			<td>�Ϲ�Text(input1):<%=input1%></td>
			<td>�н�����(input2):<%=input2%></td>
		</tr>
	</table>
</body>
</html>