<%-- 
	//************************************************
	//	취소된 인증서 삭제를 위한 다운로드
	//************************************************
--%>
<% if (m_IniErrCode == null) 
{
	m_RA.setInfo(m_ID, m_IP);
	if (m_RA.certDown(m_certserial))
		m_caRevokedCertString = m_RA.getCertString("CertDown");
}
%>