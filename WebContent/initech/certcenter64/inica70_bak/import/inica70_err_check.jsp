<%-- 
	//************************************************
	//	에러처리
	//************************************************
--%>

<%
	if (m_IniErrCode == null) {
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) *** Success ***\n");
	} else {
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) *** Fail : " + m_IniErrCode + " ***\n");
		response.sendRedirect("err.jsp?id=" + m_ID + "&how=" + m_How + "&code=" + m_IniErrCode + "&msg=" + m_IniErrMsg);
		return;
	}
%>