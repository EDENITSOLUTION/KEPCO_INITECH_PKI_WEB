<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>
<%@ page import="com.initech.oppra.*" %>
<%@ page import="com.initech.oppra.util.*" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%
	String p10Msg = request.getParameter("req");
	String host = "172.20.26.23";
	int port = 4007;
	String RAUSER = "InitedhDemo"; // �ܸ��� ��� ID
	String USERCODE = "1"; // ������ �����ڵ�  1 ����, 2 ���, 3 ��Ÿ
	String ORGNAME = "Initech";	// �����
	String DETAILNAME = "�̴���(Initech)";	// ����/��� ���θ�
	// String REGNO = "1234567890123";	// �ֹι�ȣ
	String REGNO = "1234517890121";	// �ֹι�ȣ
	String BANKINGID = "TEST1111";	// ���ͳݹ�ŷID
	String SERVICEPROVIDER = "01";	// ����������   01 RA_v7, 02 AuthGD
	String CODE = "08"; // ������� �ĺ��ڵ� 01 �ݰ��, 02 �����������, 03 ��������, 04 �ڽ���, 05 ��������, 06 �ѱ������
	String CERTPOLICY = "71";	// ������å �ĺ��ڵ�
	String USERMAIL = "test@initech.com";	// �̸���
	String PHONE = "010-123-1234";	// ��
	String FAX = "02-6445-7200";	// FAX
	String POSTNUM = "123-123";	// �����ȣ
	String ADDRESS = "���� ���� ���ε� ���̽����̿���Ÿ��2�� 11�� 1ȣ";	// �ּ�
	String PKCS10MSG = "MIICkjCCAXwCAQAwTzELMAkGA1UEBhMCS1IxEDAOBgNVBAoTB0lOSVRFQ0gxEDAOBgNVBAsTB0lOSVRFQ0gxHDAaBgNVBAMME+q5gOyngOyImChLSU0gSklTVSkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCK68yeGaCfWrPOw2nXO4mamSBuwuGvRTJ1LuXys3xuzC+aGg95ChTKhOcX4LysUqKpJeS1SuNr2pZN3otlYNlP8nRbZml9oerqGWPOhD/tWV5fOgS7ADSHq3StcgexAULSF2OKmyeYMoGaWXf1YevhFVpjC217TTbGfKmQppaHGUjVpYSS+287hD6Ygi0kf7th/zqQ7UPhL4TsP8WWfzSXwkI6olVlwbyYiTP5QSmpMBqaySC6yuVPc7NQjFoIOAKYsGFbVcb/S2g/pTHLpEIIWXcgbUmjBe8TSzf9cBQsBX8++jCFJ2sIhWrySelc5zL1woEKtiiXgSoXOTX0pRhXAgMBAAGgADALBgkqhkiG9w0BAQUDggEBAGEi7Z3GZW315auBSCoo2RkdgoYpyO4Iz919zZ/C4xHT2AVDL6ou7m308XPbrvYdIFhL/F6hjPDGwr1QfgvcvPxHX+Ki6yuVePJ/iYdGNDrSmRC3TVstWkP0vQprY0AxVjls6uZEfrnvIIvzWAVuldQJU95YOiQyAUm2+p6EkFaDwrH4Fda9zo4CHpVj+Z9hDuMqq6c9xpRl0vWBrHy4kcr+6wzwspShaOrYbzdP0g6aKpx2EFJ23CgqupcSyoz3II5/PJOh/8Gd1NjdZqdNGEiK1JUbBfhiIfoHIbDkZE/eUegQQEm+npySODIHwwaiI441o/mb0GIbinrjIcmgBug=";
	
	HashMap hash = new HashMap();
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
	
	
	IniOPPRA iniRA = new IniOPPRA(host, port);
	iniRA.initialize();
	OppraSendDataParser oppraSendDataParser = new OppraSendDataParser( "C5" , hash, false);
	String requestMsg = oppraSendDataParser.getSendLastData();
	
	out.println("[send]: " + requestMsg);
	out.println("<br/>");
		
	String rsp = iniRA.requestRAW(requestMsg);
	
	out.println("[recv]: [Header] " + iniRA.getRetHeader() + "<br/>");
	out.println("[recv]: " + rsp + "<br/>");	
	
	OppraMessageDataParser odp = new OppraMessageDataParser( "C5", iniRA.getResDataPart() );
	String sRESCODE = odp.getCodeData("RESCODE"); //�����ڵ�
	String sRESMSG = odp.getCodeData("RESMSG"); //����޼���
	
	if( sRESCODE.equals("000") ) {
		String sCERTDATA = odp.getStrCodeData("CERTDATA"); //������
	
		out.print("[CERTDATA]: " + sCERTDATA + "<br/>");
	} else {
		out.print("����");
	}
	
	

%>
