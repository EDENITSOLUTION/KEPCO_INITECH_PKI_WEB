<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>

<% 
//************************************************
//  �Է� : ����� �ź�Ȯ������(m_ID, m_PW .. )
//  ��� : DN����(m_CN, m_MAIL, m_OU, m_O, m_L, m_C)
//************************************************

if (m_IniErrCode == null) 
{
	if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : host(DB) connect start ...");
	//m_ID, m_PW�� DB������ Ȯ���� �Ʒ��� �ʿ��� ������ ä���.

	//m_CN = "�׽�Ʈ";
	//m_MAIL = "mailto@initech.com
	m_OU = "�������ó";
	m_O = "�ѱ����°���";
	m_L = "SEOUL";
	m_C = "KR";

	//	m_IniErrCode = "DB_001";
	//	m_IniErrMsg = "�����Ȯ�ο���";
	
	
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
