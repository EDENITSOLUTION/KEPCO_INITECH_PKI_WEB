<%@ page contentType="text/html;charset=EUC-KR" %>
<%
//************************************************
//      변수 선언 및 입력정보 복호화
//************************************************
	
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");



//2014.04.22 라이센스경로 제거
//String licensePath = "/home/initech/iniplugin/license/IniRA_v6_sdk.lic";
//IniRAutil m_RA = new IniRAutil( licensePath );




//암호화여부 : 리얼적용시 반드시true로 변경해야함..
boolean m_bEncrypt = true;

//사용자정보를 인사정보에서 가지고 와서
//해당 사용자만 인증서 발급 받게 할지 체크
// false : 인사정보외 입력한 임의의 아이디로도 발급가능
//리얼적용시 반드시true로 변경해야함..
boolean is_insaUser = true;

//String userPwdSendURL = "http://10.


//사용자 신분확인 정보
String m_ID = null;		// form name = id
String m_REGNO = null;	// form name = regno
String m_pw = null; // form name = certpass

//SMS 인증코드
//String m_smschk = null; //발급SMS인증코드
String m_sms = null; //입력SMS인증코드
String m_tmid = null;//SMS인증을 위한 타임 아이디

//발급시 기존 인증서 폐기 후 다시 발급하는 프로세스 옵션
String m_strBrg = null ;



// 조회 정보 (요청)
String m_SEARCHCODE = null;		// form name = searchcode
String m_SEARCHCONTENTS = null;	// form name = searchcontents

// 조회 정보 (응답)
String m_seCACODE			= null;
String m_seMANAGERID		= null;
String m_seCERTPOLICY		= null;
String m_seCERTSERIAL		= null;
String m_seUSERID			= null;
String m_seSUBJECTDN		= null;
String m_seIDNO				= null;
String m_seSVDATE			= null;
String m_seEVDATE			= null;
String m_seCERTSTATUS		= null;
String m_seTOTALRECORDNUM	= null;
String m_seCURRENTRECORNUM	= null;

//Challenge사용여부 : 일반적으로 사용안함
boolean m_bChallenge = false;

//LDAP 관련정보 : 변경하지 말것
String m_certserial = null;
String m_ldapchallenge = null;

//인증서신청정보, 호스트에서 발아야 할정보 : 변경하지 말것
String m_REQ = null; //cert request
String m_CN = "홍길동";
String m_MAIL = "caadmin@kepco.co.kr";
String m_OU = "정보기술처";	//정보기술처
String m_O = "한국전력공사";
String m_L = "서울특별시";
String m_C = "KR";

//인증서 신청(취소) 성공시 받아오는 값들 : 변경하지 말것
String m_caSerial = null;
String m_caSeqNo = null;
String m_caIssueDate = null;
String m_caExpireDate = null;
String m_caRevokeDate = null;
String m_caRejectReason = null;

//발급(폐기)된 인증서를 PC에 저장(삭제)하기위한 정보 : 변경하지 말것
String m_caCertString = null;
String m_orgCertString = null;
String m_caRevokedCertString = null;


if (m_IniErrCode == null) {
	
	try {
		if (m_bDebug) System.out.println("INIplugin (" + m_How + " ) : start ip.init");

		//사용자 확인 Parameter 입력폼이 추가되면 여기다가 추가하면 됨
		m_ID = m_IP.getParameter("id");

		//2014.04.22 한국전력은 주민번호 입력하지 않으므로
		//임의의 주민등록 번호를 입력하게 한다.
		//m_REGNO = lpad(m_IP.getParameter("regno"),13, "0");
		m_REGNO = "0000000000000";

		//사용자비밀번호 관리를 위해
		m_pw = m_IP.getParameter("pw");


		//m_smschk = m_IP.getParameter("smschk");
		m_sms = m_IP.getParameter("sms");
		m_tmid = m_IP.getParameter("tmid");

		m_strBrg = m_IP.getParameter("strBrg");

		m_SEARCHCODE = m_IP.getParameter("searchcode");
		m_SEARCHCONTENTS = m_IP.getParameter("searchcontents");
		
		if (m_How.equals("certNew") || m_How.equals("certRenewal") ||
			m_How.equals("certReplace")) {
			m_REQ = m_IP.getParameter("req");
			
			//CN값은 ID로 변경
			//m_CN = m_IP.getParameter("CN");
			m_CN = m_ID ;
			
			m_MAIL = m_IP.getParameter("EMAIL");
			
			//OU값 변경 : 전자통신처
			m_OU = m_IP.getParameter("OU");
			m_OU = "정보기술처"; //정보기술처
			
			//O값 변경 : 한국전력공사
			//m_O = m_IP.getParameter("O");
			m_O = "한국전력공사";
			
			
			m_L = m_IP.getParameter("L");

			//C값 변경 : KR
			//m_C = m_IP.getParameter("C");
			m_C = "KR";
		}
		
		m_certserial = m_IP.getParameter("serialno");

		if (m_bDebug) {
			System.out.println("\tID : " + m_ID);
			System.out.println("\tREGNO : " + m_REGNO);
//			System.out.println("\tPW : " + m_PW);
			System.out.println("\tCN : " + m_CN);
			System.out.println("\tEMAIL : " + m_MAIL);
			System.out.println("\tSERIAL : " + m_certserial);			
			System.out.println("\tSEARCHCODE     : " + m_SEARCHCODE);			
			System.out.println("\tSEARCHCONTENTS : " + m_SEARCHCONTENTS);			
		}
		if (m_bDebug) System.out.println(m_ID + "( " + m_How + " ) : end ip.init");
	} catch(Exception e){
		m_IniErrCode = "iniPlugin_102";
		System.out.println(m_ID + " : Exception : " + e.getMessage());
		e.printStackTrace();
	}
}
%>

<%!
    public static String lpad(String str, int len, String addStr) {
         String result = str;
         if (result == null) return result;
         int templen   = len - result.length();

        for (int i = 0; i < templen; i++){
               result = addStr + result;
         }
         
         return result;
     }
%>
