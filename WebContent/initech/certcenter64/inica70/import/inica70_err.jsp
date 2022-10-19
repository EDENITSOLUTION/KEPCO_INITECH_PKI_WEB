<%@ page contentType="text/html;charset=EUC-KR" %>
<%-- 
	//************************************************
        //      에러코드를 에러 메시지로 변환
	//	input : m_How => output : m_Title
	//	input : m_Code => output : m_ErrMsg
        //************************************************
--%>

<%
if (m_How.equals("certNew"))
	m_Title = "ID(" + m_ID + ")로 인증서 신청도중 다음과 같은 오류가 발생하였습니다.";
else if (m_How.equals("certRevoke"))
	m_Title = "ID(" + m_ID + ")로 인증서 취소도중 다음과 같은 오류가 발생하였습니다.";
else if (m_How.equals("certReplace"))
	m_Title = "ID(" + m_ID + ")로 인증서 변경도중 다음과 같은 오류가 발생하였습니다.";
else if (m_How.equals("certRenewal"))
	m_Title = "ID(" + m_ID + ")로 인증서 갱신도중 다음과 같은 오류가 발생하였습니다.";
else if (m_How.equals("logon"))
	m_Title = "로그온 도중 다음과 같은 오류가 발생하였습니다.";
else 		
	m_Title = "다음과 같은 오류가 발생하였습니다.";

if (m_Code.equals("iniPlugin_101"))
	m_ErrMsg = "암호화 모듈 설치를 확인요.(INIpluginDATA is null)";
else if (m_Code.equals("iniPlugin_102"))
		m_ErrMsg = "암호화 모듈 설치를 확인요.(복호화 오류)";
else if (m_Code.equals("iniPlugin_103"))
		m_ErrMsg = "암호화 모듈 설치를 확인요.(암호화 오류)";

else if (m_Code.equals("iniLDAP_001"))
	m_ErrMsg = "찾고자하는 Attribute가 존재하지 않습니다.";
else if (m_Code.equals("iniLDAP_002"))
	m_ErrMsg = "발급 받은 인증서가 없습니다.";
else if (m_Code.equals("iniLDAP_003"))
	m_ErrMsg = "이미 발급받은 인증서 입니다.";

else if (m_Code.equals("iniLDAP_101"))
	m_ErrMsg = "LDAP 알수 없는 오류입니다.";
else if (m_Code.equals("iniLDAP_102"))
	m_ErrMsg = "LDAP 서버 연결에 실패하였습니다.";
else if (m_Code.equals("iniLDAP_103"))
	m_ErrMsg = "LDAP 서버 연결에 실패하였습니다.";

else if (m_Code.equals("iniLDAP_201"))
	m_ErrMsg = "취소된 인증서 입니다.";
else if (m_Code.equals("iniLDAP_301"))
	m_ErrMsg = "LDAP서버에 ID 추가에 실패하였습니다.";
else if (m_Code.equals("iniLDAP_401"))
	m_ErrMsg = "인증서 취소 비밀번호가 틀립니다..";

else if (m_Code.equals("iniCA_000"))
	m_ErrMsg = "인증서 파싱 에러(잘못된 함수 호출)";
else if (m_Code.equals("iniCA_101") || m_Code.equals("iniCA_201")
	|| m_Code.equals("iniCA_301") || m_Code.equals("iniCA_401")
	|| m_Code.equals("iniCA_501") )
	m_ErrMsg = "inimessage is null";
else if (m_Code.equals("iniCA_102") || m_Code.equals("iniCA_202")
	|| m_Code.equals("iniCA_302") || m_Code.equals("iniCA_402")
	|| m_Code.equals("iniCA_502") )
	m_ErrMsg = "인증서버 연결에 실패하였습니다.";
else 
	if (m_ErrMsg == null) m_ErrMsg = "잠시후 다시신청하여 주십시요";
%>