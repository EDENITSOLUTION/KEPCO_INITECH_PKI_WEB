<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="com.initech.oppra.*" %>
<%@ page import="com.initech.oppra.util.*" %>

<%-- 
//************************************************
//	���������� ������ �߱�/����/����/���
//************************************************
--%>

<% if (m_IniErrCode == null) 
{
	String userid = m_ID;	
	String regno = m_REGNO;
	String ou = m_OU;
	//CN�� ����� ���̵�� ����
	//String cn = m_CN;
	String cn = m_ID;

	String mail = m_MAIL;
	String policy = "71";
	String serialno = m_certserial;

	HashMap hash = null;

	//m_RA.setInfo(m_ID, m_IP);
	boolean ret = false;

	/* ��û (C0:�߱޿�û, C5:��߱޿�û, C8:���ſ�û) */
	String CACode = null;
	if (m_How.equals("certNew")) 
	{
		CACode = "C0";
	}
	else if (m_How.equals("certReplace"))
	{
		CACode = "C5";
	}
	else if (m_How.equals("certRenewal"))
	{
		CACode = "C8";
	}
	else if (m_How.equals("certRevoke") || m_How.equals("certStop") || m_How.equals("certStart"))
	{
		CACode = "40";	/* 40:������ ���º��� ��û */
	}
	else if (m_How.equals("certSearch"))
	{
		CACode = "50";	/* 50:������ ��ȸ ��û */
	}

	if (m_How.equals("certRevoke") || m_How.equals("certStop") || m_How.equals("certStart"))
	{
		String RAUSER = "TEST";					// �ܸ��� ��� ID
		String SERVICEPROVIDER = "01";			// ����������   01 RA_v7, 02 AuthGD
		String CODE = "08";						// ������� �ĺ��ڵ� 01 �ݰ��, 02 �����������, 03 ��������, 04 �ڽ���, 05 ��������, 06 �ѱ������, 08 �缳CA
		String CERTPOLICY = policy;				// ������å �ĺ��ڵ�
		String CERTSERIAL = serialno;			// ������ �Ϸù�ȣ
		String SERVICECODE = null;
		if (m_How.equals("certRevoke"))
			SERVICECODE = "30";				// ���� �ڵ� 30:���
		else if (m_How.equals("certStop"))
			SERVICECODE = "40";				// ���� �ڵ� 40:ȿ������
		else if (m_How.equals("certStart"))
			SERVICECODE = "41";				// ���� �ڵ� 41:ȿ��ȸ��

		hash = new HashMap();
		hash.put("MANAGERID", RAUSER);
		hash.put("SERVICEPROVIDER", SERVICEPROVIDER);
		hash.put("CACODE", CODE);
		hash.put("CERTCODE", CERTPOLICY);
		hash.put("CERTSERIAL", CERTSERIAL);
		hash.put("SERVICECODE", SERVICECODE);
	}
	else if (m_How.equals("certSearch"))
	{
		String RAUSER = "TEST";					// �ܸ��� ��� ID
		String SERVICEPROVIDER = "01";			// ����������   01 RA_v7, 02 AuthGD
		String CODE = "08";						// ������� �ĺ��ڵ� 01 �ݰ��, 02 �����������, 03 ��������, 04 �ڽ���, 05 ��������, 06 �ѱ������, 08 �缳CA
		String CERTPOLICY = policy;				// ������å �ĺ��ڵ�
		String SEARCHCODE = m_SEARCHCODE;
		String SEARCHCONTENTS = m_SEARCHCONTENTS;
		String REQRECORDSTARTNO = null;
		String REQRECORDNO = null;

		hash = new HashMap();
		hash.put("MANAGERID", RAUSER);
		hash.put("SERVICEPROVIDER", SERVICEPROVIDER);
		hash.put("CACODE", CODE);
		hash.put("CERTCODE", CERTPOLICY);
		hash.put("SEARCHCODE", SEARCHCODE);
		hash.put("SEARCHCONTENTS", SEARCHCONTENTS);
		hash.put("REQRECORDSTARTNO", REQRECORDSTARTNO);
		hash.put("REQRECORDNO", REQRECORDNO);
	}
	else
	{
		String RAUSER = "TEST";					// �ܸ��� ��� ID
		String USERCODE = "1";					// ������ �����ڵ�  1 ����, 2 ���, 3 ��Ÿ
		String ORGNAME = ou;					// �����
		String DETAILNAME = cn;					// ����/��� ���θ�
		String REGNO = regno;					// �ֹι�ȣ
		String BANKINGID = userid;				// ���ͳݹ�ŷID
		String SERVICEPROVIDER = "01";			// ����������   01 RA_v7, 02 AuthGD
		String CODE = "08";						// ������� �ĺ��ڵ� 01 �ݰ��, 02 �����������, 03 ��������, 04 �ڽ���, 05 ��������, 06 �ѱ������, 08 �缳CA
		String CERTPOLICY = policy;				// ������å �ĺ��ڵ�
		String USERMAIL = mail;	// �̸���
		String PHONE = "010-123-1234";			// ��
		String FAX = "02-6445-7200";			// FAX
		String POSTNUM = "123-123";				// ������ȣ
		String ADDRESS ="���� ���� ���ε� ���̽����̿���Ÿ��2�� 11�� 1ȣ"; // �ּ�
		String PKCS10MSG = m_REQ;

		hash = new HashMap();
		hash.put("MANAGERID", RAUSER);
		hash.put("USERCODE", USERCODE);
		hash.put("OU_NAME", ORGNAME);
		hash.put("CN_NAME", DETAILNAME);
		hash.put("IDNO", REGNO);
		hash.put("USERID", BANKINGID);
		hash.put("SERVICEPROVIDER", SERVICEPROVIDER);
		hash.put("CACODE", CODE);
		hash.put("CERTCODE", CERTPOLICY);
		hash.put("EMAIL", USERMAIL);
		hash.put("HANDPHONE", PHONE);
		hash.put("FAX", FAX);
		hash.put("POSTCODE", POSTNUM);
		hash.put("POSTADDR", ADDRESS);
		hash.put("PHONE", PHONE);
		hash.put("POSTCODE1", POSTNUM);
		hash.put("POSTADDR1", ADDRESS);
		hash.put("PHONE1", PHONE);
		hash.put("PKCS10MSG", PKCS10MSG);
	}

	/* RA SDK �ʱ�ȭ */
	//IniOPPRA iniRA = new IniOPPRA("172.20.25.121", 4007);
	IniOPPRA iniRA = new IniOPPRA("10.180.2.66", 4000);
	iniRA.setCharEncoding("euc-kr");
	/* IniOPPRA iniRA = new IniOPPRA("172.20.25.140", 4007); */
	iniRA.initialize();

	/* RA ��û */
	OppraSendDataParser oppraSendDataParser = new OppraSendDataParser(CACode, hash, false);
	String requestMsg = oppraSendDataParser.getSendLastData();

	/* ������� [PKCS#10 ������ �߱��뺸 (C1) ����] */
	/* [��������: rescode=000]
	 * 01: RESLEN
	 * 02: RESCODE
	 * 03: RESMSG
	 * 04: CERTDATA (���º��� �޽��� ��û�� ������ ��� ����) */
	/* [��������: rescode=999]
	 * 01: RESLEN
	 * 02: RESCODE
	 * 03: RESMSG
	 * 04: ADDRESCODE
	 * 05: ADDRESMSG
	 * 06: RESERVE1
	 * 07: RESERVE2 */
	/* [��������: rescode=��Ÿ]
	 * 01: RESLEN
	 * 02: RESCODE
	 * 03: RESMSG
	 * 04: ADDRESCODE
	 * 05: ADDRESMSG
	 * 06: RESERVE1
	 * 07: RESERVE2
	 * 08: RESERVE3
	 * 09: RESERVE4 */
	String rsp = iniRA.requestRAW(requestMsg);
	OppraMessageDataParser odp = new OppraMessageDataParser(CACode, iniRA.getResDataPart());
	String sRESLEN = odp.getCodeData("RESLEN");			// ���ڵ����
	String sRESCODE = odp.getCodeData("RESCODE");		// �����ڵ�
	String sRESMSG = odp.getCodeData("RESMSG");			// ����޼���
	String sCERTDATA = null;
	String sADDRESCODE = null;
	String sADDRESMSG = null;
	String sRESERVE1 = null;
	String sRESERVE2 = null;
	String sRESERVE3 = null;
	String sRESERVE4 = null;
	String sCLICERTDATA = null;

	String sCACODE = null;
	String sMANAGERID = null;
	String sCERTPOLICY = null;
	String sCERTSERIAL = null;
	String sUSERID = null;
	String sSUBJECTDN = null;
	String sIDNO = null;
	String sSVDATE = null;
	String sEVDATE = null;
	String sCERTSTATUS = null;
	String sTOTALRECORDNUM = null;
	String sCURRENTRECORNUM = null;

	if (sRESCODE.equals("000"))
	{
		if (m_How.equals("certRevoke") || m_How.equals("certStop") || m_How.equals("certStart"))
		{
			if (m_bDebug)
			{
				System.out.println(m_ID + "( " + m_How + " ) - �����0(��ü)       : " + iniRA.getResDataPart());
				System.out.println(m_ID + "( " + m_How + " ) - �����1(���ڵ����) : " + sRESLEN);
				System.out.println(m_ID + "( " + m_How + " ) - �����2(�����ڵ�)   : " + sRESCODE);
				System.out.println(m_ID + "( " + m_How + " ) - �����3(����޼���) : " + sRESMSG);
			}
		}
		else if (m_How.equals("certSearch"))
		{
			sCACODE = odp.getStrCodeData("CACODE");						// ��ϴ��� ����ڵ�
			sMANAGERID = odp.getStrCodeData("MANAGERID");				// �ܸ��� ��� ID
			sCERTPOLICY = odp.getStrCodeData("CERTPOLICY");				// ������å�ĺ��ڵ�
			sCERTSERIAL = odp.getStrCodeData("CERTSERIAL");				// �������Ϸù�ȣ
			sUSERID = odp.getStrCodeData("USERID");						// ������ID
			sSUBJECTDN = odp.getStrCodeData("SUBJECTDN");				// ������ DN��
			sIDNO = odp.getStrCodeData("IDNO");							// �ֹ�(�����)��Ϲ�ȣ
			sSVDATE = odp.getStrCodeData("SVDATE");						// ��ȿ�Ⱓ����
			sEVDATE = odp.getStrCodeData("EVDATE");						// ��ȿ�Ⱓ����
			sCERTSTATUS = odp.getStrCodeData("CERTSTATUS");				// ����������
			sTOTALRECORDNUM= odp.getStrCodeData("TOTALRECORDNUM");		// �� ���ڵ� ��
			sCURRENTRECORNUM= odp.getStrCodeData("CURRENTRECORNUM");	// �� ���ڵ� ��ȣ

			if (m_bDebug)
			{
				System.out.println(m_ID + "( " + m_How + " ) - �����00(��ü)       : " + iniRA.getResDataPart());
				System.out.println(m_ID + "( " + m_How + " ) - �����01(���ڵ����) : " + sRESLEN);
				System.out.println(m_ID + "( " + m_How + " ) - �����02(�����ڵ�)   : " + sRESCODE);
				System.out.println(m_ID + "( " + m_How + " ) - �����03(����޼���) : " + sRESMSG);
				System.out.println(m_ID + "( " + m_How + " ) - �����04(��ϴ��� ����ڵ�)    : " + sCACODE);
				System.out.println(m_ID + "( " + m_How + " ) - �����05(�ܸ��� ��� ID)     : " + sMANAGERID);
				System.out.println(m_ID + "( " + m_How + " ) - �����06(������å�ĺ��ڵ�)     : " + sCERTPOLICY);
				System.out.println(m_ID + "( " + m_How + " ) - �����07(�������Ϸù�ȣ)       : " + sCERTSERIAL);
				System.out.println(m_ID + "( " + m_How + " ) - �����08(������ID)             : " + sUSERID);
				System.out.println(m_ID + "( " + m_How + " ) - �����09(������ DN��)          : " + sSUBJECTDN);
				System.out.println(m_ID + "( " + m_How + " ) - �����10(�ֹ�(�����)��Ϲ�ȣ) : " + sIDNO);
				System.out.println(m_ID + "( " + m_How + " ) - �����11(��ȿ�Ⱓ����)         : " + sSVDATE);
				System.out.println(m_ID + "( " + m_How + " ) - �����12(��ȿ�Ⱓ����)         : " + sEVDATE);
				System.out.println(m_ID + "( " + m_How + " ) - �����13(����������)           : " + sCERTSTATUS);
				System.out.println(m_ID + "( " + m_How + " ) - �����14(�� ���ڵ� ��)         : " + sTOTALRECORDNUM);
				System.out.println(m_ID + "( " + m_How + " ) - �����15(�� ���ڵ� ��ȣ)       : " + sCURRENTRECORNUM);
			}
		}
		else
		{
			sCERTDATA = odp.getStrCodeData("CERTDATA");	// ������
			m_orgCertString = makeCertCSString(sCERTDATA);
			/* ������ (Ŭ���̾�Ʈ ���� ����) */
			sCLICERTDATA = makeCertString("UserCert", sCERTDATA, false);

			if (m_bDebug)
			{
				System.out.println(m_ID + "( " + m_How + " ) - �����0(��ü)       : " + iniRA.getResDataPart());
				System.out.println(m_ID + "( " + m_How + " ) - �����1(���ڵ����) : " + sRESLEN);
				System.out.println(m_ID + "( " + m_How + " ) - �����2(�����ڵ�)   : " + sRESCODE);
				System.out.println(m_ID + "( " + m_How + " ) - �����3(����޼���) : " + sRESMSG);
				System.out.println(m_ID + "( " + m_How + " ) - �����4(������)     : " + sCERTDATA);
				System.out.println(m_ID + "( " + m_How + " ) - �����5(������-Ŭ���̾�Ʈ��������) : " + sCLICERTDATA);
			}
		}
	}
	else if (sRESCODE.equals("999"))
	{
		sADDRESCODE = odp.getStrCodeData("ADDRESCODE");
		sADDRESMSG = odp.getStrCodeData("ADDRESMSG");
		sRESERVE1 = odp.getStrCodeData("RESERVE1");
		sRESERVE2 = odp.getStrCodeData("RESERVE2");

		if (m_bDebug)
		{
			System.out.println(m_ID + "( " + m_How + " ) - �����0(��ü)       : " + iniRA.getResDataPart());
			System.out.println(m_ID + "( " + m_How + " ) - �����1(���ڵ����) : " + sRESLEN);
			System.out.println(m_ID + "( " + m_How + " ) - �����2(�����ڵ�)   : " + sRESCODE);
			System.out.println(m_ID + "( " + m_How + " ) - �����3(����޼���) : " + sRESMSG);
			System.out.println(m_ID + "( " + m_How + " ) - �����4(ADDRESCODE) : " + sADDRESCODE);
			System.out.println(m_ID + "( " + m_How + " ) - �����5(ADDRESMSG)  : " + sADDRESMSG);
			System.out.println(m_ID + "( " + m_How + " ) - �����6(RESERVE1)   : " + sRESERVE1);
			System.out.println(m_ID + "( " + m_How + " ) - �����7(RESERVE2)   : " + sRESERVE2);
		}
	}
	else
	{
		sADDRESCODE = odp.getStrCodeData("ADDRESCODE");
		sADDRESMSG = odp.getStrCodeData("ADDRESMSG");
		sRESERVE1 = odp.getStrCodeData("RESERVE1");
		sRESERVE2 = odp.getStrCodeData("RESERVE2");
		sRESERVE3 = odp.getStrCodeData("RESERVE3");
		sRESERVE4 = odp.getStrCodeData("RESERVE4");

		if (m_bDebug)
		{
			System.out.println(m_ID + "( " + m_How + " ) - �����0(��ü)       : " + iniRA.getResDataPart());
			System.out.println(m_ID + "( " + m_How + " ) - �����1(���ڵ����) : " + sRESLEN);
			System.out.println(m_ID + "( " + m_How + " ) - �����2(�����ڵ�)   : " + sRESCODE);
			System.out.println(m_ID + "( " + m_How + " ) - �����3(����޼���) : " + sRESMSG);
			System.out.println(m_ID + "( " + m_How + " ) - �����4(ADDRESCODE) : " + sADDRESCODE);
			System.out.println(m_ID + "( " + m_How + " ) - �����5(ADDRESMSG)  : " + sADDRESMSG);
			System.out.println(m_ID + "( " + m_How + " ) - �����6(RESERVE1)   : " + sRESERVE1);
			System.out.println(m_ID + "( " + m_How + " ) - �����7(RESERVE2)   : " + sRESERVE2);
			System.out.println(m_ID + "( " + m_How + " ) - �����8(RESERVE3)   : " + sRESERVE3);
			System.out.println(m_ID + "( " + m_How + " ) - �����9(RESERVE4)   : " + sRESERVE4);
		}
	}

	if (sRESCODE.equals("000"))
	{
		if (m_How.equals("certNew") || m_How.equals("certRenewal") || m_How.equals("certReplace"))
		{
			/***********************************/
			/* ���ŵ� ������ Ŭ���̾�Ʈ�� ���� */
			/***********************************/
			m_caCertString = sCLICERTDATA;
		}
		else if (m_How.equals("certSearch"))
		{
			/***********************************/
			/* ��ȸ�� ����� Ŭ���̾�Ʈ�� ���� */
			/***********************************/
			m_seCACODE			= sCACODE;			// ��ϴ��� ����ڵ�
			m_seMANAGERID		= sMANAGERID;		// �ܸ��� ��� ID
			m_seCERTPOLICY		= sCERTPOLICY;		// ������å�ĺ��ڵ�
			m_seCERTSERIAL		= sCERTSERIAL;		// �������Ϸù�ȣ
			m_seUSERID			= sUSERID;			// ������ID
			m_seSUBJECTDN		= sSUBJECTDN;		// ������ DN��
			m_seIDNO			= sIDNO;			// �ֹ�(�����)��Ϲ�ȣ
			m_seSVDATE			= sSVDATE;			// ��ȿ�Ⱓ����
			m_seEVDATE			= sEVDATE;			// ��ȿ�Ⱓ����
			m_seCERTSTATUS		= sCERTSTATUS;		// ����������
			m_seTOTALRECORDNUM	= sTOTALRECORDNUM;	// �� ���ڵ� ��
			m_seCURRENTRECORNUM	= sCURRENTRECORNUM;	// �� ���ڵ� ��ȣ
		}
	}
	else
	{
		/*************/
		/* ���� ���� */
		/*************/
		m_IniErrCode = sRESCODE;
	}

	/* THE END */
}
%><%!
public static String makeCertString(String varName, String certificate, boolean doFromJSP)
{
	String certificate1 = null;
	String retString = null;
	String certContent = null;

	/*
	   if( doFromJSP ){
	   certContent = certificate.substring("-----BEGIN CERTIFICATE-----".length()+2, certificate.length() - ("-----END CERTIFICATE-----".length()+2));
	   }else{
	   certContent = certificate.substring("-----BEGIN CERTIFICATE-----".length(), certificate.length() - ("-----END CERTIFICATE-----".length() + 1 ));
	   }
	 */

	certificate = certificate.replace("-----BEGIN CERTIFICATE-----", "");
	certContent = certificate.replace("-----END CERTIFICATE-----", "");


	StringTokenizer token = new StringTokenizer(certContent, "\n\r");

	while(token.hasMoreTokens()) {
		String temp = token.nextToken();
		if(certificate1 == null) {
			certificate1 = temp;
		} else if(certificate1.equals(null)) {
			System.out.println("Second Null");
		} else {
			certificate1 = certificate1 + temp;
		}
	}

	retString = varName + "=\"-----BEGIN CERTIFICATE-----\";\n" + varName + "+=\"\\n\";\n";

	StringReader reader = new StringReader(certificate1);

	char[] readbuf = new char[64];
	try {
		for(int i = 0; i < (int)Math.floor((certificate1.length() / 64)); i++) {
			reader.read(readbuf);
			String temp = varName + "+=\"" + new String(readbuf) + "\";\n";
			temp = temp + varName + "+=\"\\n\";\n";
			retString = retString + temp;
		}

		int rem = certificate1.length() % 64;
		if( rem != 0) {
			System.out.println("rem length : " + String.valueOf(rem));
			char[] buf = new char[rem];
			reader.read(buf);
			String temp = varName + "+=\"" + new String(buf) + "\";\n";

			temp = temp + varName + "+=\"\\n\";\n";
			retString = retString + temp;
		}

	} catch (Exception e) {
		System.out.println("Exception e");
		e.printStackTrace();
	}

	String temp = varName + "+=\"-----END CERTIFICATE-----\";\n";
	retString = retString + temp;

	return retString;
}

public static String makeCertCSString(String certificate)
{
	String certificate1 = null;
	String retString = null;
	String certContent = null;

	certificate = certificate.replace("-----BEGIN CERTIFICATE-----", "");
	certContent = certificate.replace("-----END CERTIFICATE-----", "");

	return certContent;
}
/*
public static String makeCertCSString(String certificate)
{
	String certificate1 = null;
	String retString = null;
	String certContent = null;

	certificate = certificate.replace("-----BEGIN CERTIFICATE-----", "");
	certContent = certificate.replace("-----END CERTIFICATE-----", "");

	StringTokenizer token = new StringTokenizer(certContent, "\n\r");

	while(token.hasMoreTokens()) {
		String temp = token.nextToken();
		if(certificate1 == null) {
			certificate1 = temp;
		} else if(certificate1.equals(null)) {
			System.out.println("Second Null");
		} else {
			certificate1 = certificate1 + temp;
		}
	}

	retString = "-----BEGIN CERTIFICATE-----\n\r";

	StringReader reader = new StringReader(certificate1);

	char[] readbuf = new char[64];
	try {
		for(int i = 0; i < (int)Math.floor((certificate1.length() / 64)); i++) {
			reader.read(readbuf);
			String temp = new String(readbuf) + "\n\r";
			retString = retString + temp;
		}

		int rem = certificate1.length() % 64;
		if( rem != 0) {
			System.out.println("rem length : " + String.valueOf(rem));
			char[] buf = new char[rem];
			reader.read(buf);
			String temp = new String(buf) + "\n\r";
			retString = retString + temp;
		}

	} catch (Exception e) {
		System.out.println("Exception e");
		e.printStackTrace();
	}

	String temp = "-----END CERTIFICATE-----\n\r";
	retString = retString + temp;

	return retString;
}*/
%>