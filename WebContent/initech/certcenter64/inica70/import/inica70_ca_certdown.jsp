<%-- 
	//************************************************
	//	��ҵ� ������ ������ ���� �ٿ�ε�
	//************************************************
--%>
<% if (m_IniErrCode == null) 
{
	m_RA.setInfo(m_ID, m_IP);
	if (m_RA.certDown(m_certserial))
		m_caRevokedCertString = m_RA.getCertString("CertDown");
}
%>