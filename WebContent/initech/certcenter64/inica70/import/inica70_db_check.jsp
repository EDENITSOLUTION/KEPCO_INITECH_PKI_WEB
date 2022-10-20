<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>

<% 
//************************************************
//  입력 : 사용자 신분확인정보(m_ID, m_PW .. )
//  출력 : DN정보(m_CN, m_MAIL, m_OU, m_O, m_L, m_C)
//************************************************

if (m_IniErrCode == null) 
{
	if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : host(DB) connect start ...");
	//m_ID, m_PW로 DB서버에 확인후 아래의 필요한 정보를 채운다.

	//m_CN = "테스트";
	//m_MAIL = "mailto@initech.com
	m_OU = "전자통신처";
	m_O = "한국전력공사";
	m_L = "SEOUL";
	m_C = "KR";

	//	m_IniErrCode = "DB_001";
	//	m_IniErrMsg = "사용자확인에러";
	
	
	Context ic = new InitialContext();
	DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/INICA");
	ResultSet rs = null;
	
	Connection conn = null;
	Statement stmt = null;

	
	// printf("test");	
	try {
		
		conn = ds.getConnection();
		stmt = conn.createStatement();
		rs = stmt.executeQuery("select serial from LDAP_INFO where userid='" + m_ID + "' and status='V'");
		while( rs.next() ) {
			m_certserial = rs.getString("serial");
		}

		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : m_certserial: " + m_certserial);
		
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		rs.close();
		conn.close();
	}

	if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : host(DB) connect end ...");
}
%>
