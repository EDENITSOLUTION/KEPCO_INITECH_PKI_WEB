<%@ page contentType="text/html;charset=EUC-KR" %>
<%
//************************************************
//      ���� ���� �� �Է����� ��ȣȭ
//************************************************
	
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");



//2014.04.22 ���̼������ ����
//String licensePath = "/home/initech/iniplugin/license/IniRA_v6_sdk.lic";
//IniRAutil m_RA = new IniRAutil( licensePath );




//��ȣȭ���� : ��������� �ݵ��true�� �����ؾ���..
boolean m_bEncrypt = true;

//����������� �λ��������� ������ �ͼ�
//�ش� ����ڸ� ������ �߱� �ް� ���� üũ
// false : �λ������� �Է��� ������ ���̵�ε� �߱ް���
//��������� �ݵ��true�� �����ؾ���..
boolean is_insaUser = true;

//String userPwdSendURL = "http://10.


//����� �ź�Ȯ�� ����
String m_ID = null;		// form name = id
String m_REGNO = null;	// form name = regno
String m_pw = null; // form name = certpass

//SMS �����ڵ�
//String m_smschk = null; //�߱�SMS�����ڵ�
String m_sms = null; //�Է�SMS�����ڵ�
String m_tmid = null;//SMS������ ���� Ÿ�� ���̵�

//�߱޽� ���� ������ ��� �� �ٽ� �߱��ϴ� ���μ��� �ɼ�
String m_strBrg = null ;



// ��ȸ ���� (��û)
String m_SEARCHCODE = null;		// form name = searchcode
String m_SEARCHCONTENTS = null;	// form name = searchcontents

// ��ȸ ���� (����)
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

//Challenge��뿩�� : �Ϲ������� ������
boolean m_bChallenge = false;

//LDAP �������� : �������� ����
String m_certserial = null;
String m_ldapchallenge = null;

//��������û����, ȣ��Ʈ���� �߾ƾ� ������ : �������� ����
String m_REQ = null; //cert request
String m_CN = "ȫ�浿";
String m_MAIL = "caadmin@kepco.co.kr";
String m_OU = "�������ó";	//�������ó
String m_O = "�ѱ����°���";
String m_L = "����Ư����";
String m_C = "KR";

//������ ��û(���) ������ �޾ƿ��� ���� : �������� ����
String m_caSerial = null;
String m_caSeqNo = null;
String m_caIssueDate = null;
String m_caExpireDate = null;
String m_caRevokeDate = null;
String m_caRejectReason = null;

//�߱�(���)�� �������� PC�� ����(����)�ϱ����� ���� : �������� ����
String m_caCertString = null;
String m_orgCertString = null;
String m_caRevokedCertString = null;


if (m_IniErrCode == null) {
	
	try {
		if (m_bDebug) System.out.println("INIplugin (" + m_How + " ) : start ip.init");

		//����� Ȯ�� Parameter �Է����� �߰��Ǹ� ����ٰ� �߰��ϸ� ��
		m_ID = m_IP.getParameter("id");

		//2014.04.22 �ѱ������� �ֹι�ȣ �Է����� �����Ƿ�
		//������ �ֹε�� ��ȣ�� �Է��ϰ� �Ѵ�.
		//m_REGNO = lpad(m_IP.getParameter("regno"),13, "0");
		m_REGNO = "0000000000000";

		//����ں�й�ȣ ������ ����
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
			
			//CN���� ID�� ����
			//m_CN = m_IP.getParameter("CN");
			m_CN = m_ID ;
			
			m_MAIL = m_IP.getParameter("EMAIL");
			
			//OU�� ���� : �������ó
			m_OU = m_IP.getParameter("OU");
			m_OU = "�������ó"; //�������ó
			
			//O�� ���� : �ѱ����°���
			//m_O = m_IP.getParameter("O");
			m_O = "�ѱ����°���";
			
			
			m_L = m_IP.getParameter("L");

			//C�� ���� : KR
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
