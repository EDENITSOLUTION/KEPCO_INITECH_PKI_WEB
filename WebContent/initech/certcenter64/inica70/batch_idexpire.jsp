<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="com.initech.oppra.*" %>
<%@ page import="com.initech.oppra.util.*" %>
<%
Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;
ResultSet rs2 = null;

Connection conn = null;
Statement stmt = null;
Statement stmt2 = null;


HashMap hash = null;

/* 요청 (C0:발급요청, C5:재발급요청, C8:갱신요청) */
String CACode = "40";

String RAUSER = "TEST";	// 단말기 운영자 ID
String SERVICEPROVIDER = "01";	// 서비스제공자   01 RA_v7, 02 AuthGD
String CODE = "08";	// 인증기관 식별코드 01 금결원, 02 무역정보통신, 03 전자인증, 04 코스콤, 05 정보인증, 06 한국전산원, 08 사설CA
String CERTPOLICY = "";	// 인증정책 식별코드
String CERTSERIAL = ""; // 인증서 일련번호
String SERVICECODE = "30";	// 서비스 코드 30:폐기


/* RA 요청 */


	try {

		conn = ds.getConnection();
		stmt = conn.createStatement();
		stmt2 = conn.createStatement();

		String cellQry = "SELECT A.POLICY, A.SERIAL, A.ISSUEDATE, A.EXPIREDATE, B.EMPNO, A.USERID FROM LDAP_INFO A LEFT JOIN V_INSA B ON (A.USERID = B.EMPNO) WHERE B.EMPNO IS NULL" ;
						
		rs = stmt.executeQuery(cellQry);

		String requestMsg = "";
		String rsp = "";
		String sRESLEN = "";			// 레코드길이
		String sRESCODE = "";		// 응답코드
		String sRESMSG = "";			// 응답메세지

		String USERID = "";
		String EMPNO = "";
		String MAILNO = "";
		String POLICY = "";
		String SERIAL = "";
		String ISSUEDATE = "";
		String EXPIREDATE = "";

		int i = 1;
		while( rs.next() ) {
			USERID = rs.getString("USERID");
			EMPNO = rs.getString("EMPNO");
			POLICY = rs.getString("POLICY");
			SERIAL = rs.getString("SERIAL");
			ISSUEDATE = rs.getString("ISSUEDATE");
			EXPIREDATE = rs.getString("EXPIREDATE");
			out.print(i + " : " + SERIAL + " - " + ISSUEDATE + " - " + EXPIREDATE + " - " + USERID + "<br>");

			CERTPOLICY = POLICY; // 인증정책 식별코드
			CERTSERIAL = SERIAL; // 인증서 일련번호

			hash = new HashMap();
			hash.put("MANAGERID", RAUSER);
			hash.put("SERVICEPROVIDER", SERVICEPROVIDER);
			hash.put("CACODE", CODE);
			hash.put("CERTCODE", CERTPOLICY);
			hash.put("CERTSERIAL", CERTSERIAL);
			hash.put("SERVICECODE", SERVICECODE);

			
			OppraSendDataParser oppraSendDataParser = new OppraSendDataParser(CACode, hash, false);
			requestMsg = oppraSendDataParser.getSendLastData();
			
			/* 응답수신 [PKCS#10 인증서 발급통보 (C1) 포맷] */
			/* [정상응답: rescode=000]
			 * 01: RESLEN
			 * 02: RESCODE
			 * 03: RESMSG
			 * 04: CERTDATA (상태변경 메시지 요청의 응답일 경우 제외) */
			/* [오류응답: rescode=999]
			 * 01: RESLEN
			 * 02: RESCODE
			 * 03: RESMSG
			 * 04: ADDRESCODE
			 * 05: ADDRESMSG
			 * 06: RESERVE1
			 * 07: RESERVE2 */
			/* [오류응답: rescode=기타]
			 * 01: RESLEN
			 * 02: RESCODE
			 * 03: RESMSG
			 * 04: ADDRESCODE
			 * 05: ADDRESMSG
			 * 06: RESERVE1
			 * 07: RESERVE2
			 * 08: RESERVE3
			 * 09: RESERVE4 */

			/* RA SDK 초기화 */
			//IniOPPRA iniRA = new IniOPPRA("172.20.25.121", 4007);
			IniOPPRA iniRA = new IniOPPRA("10.180.2.67", 4000);
			iniRA.setCharEncoding("euc-kr");
			/* IniOPPRA iniRA = new IniOPPRA("172.20.25.140", 4007); */
			iniRA.initialize();
			
			rsp = iniRA.requestRAW(requestMsg);
			OppraMessageDataParser odp = new OppraMessageDataParser(CACode, iniRA.getResDataPart());
			sRESLEN = odp.getCodeData("RESLEN");			// 레코드길이
			sRESCODE = odp.getCodeData("RESCODE");		// 응답코드
			sRESMSG = odp.getCodeData("RESMSG");			// 응답메세지



				String q = "";
				q += "	INSERT INTO MNG_LOG_IDEXPIRE ";
				q += "		 (  SEQ";
				q += "		 ,  USERID";
				q += "		 ,  CRDATE";
				q += "		 ,  SERIAL";
				q += "		 ,  POLICY";
				q += "		 ,  ISSUEDATE";
				q += "		 ,  EXPIREDATE";
				q += "		 ,  RETCODE";
				q += "		 ) ";
				q += "VALUES (  MNGLOGIDEXPIRE_SEQ.NEXTVAL";
				q += "		 ,  '"+USERID+"'";
				q += "		 ,  SYSDATE";
				q += "		 ,  '"+SERIAL+"'";
				q += "		 ,  '"+POLICY+"'";
				q += "		 ,  TO_DATE('"+ISSUEDATE+"', 'YYYY-MM-DD HH24:MI:SS')";
				q += "		 ,  TO_DATE('"+EXPIREDATE+"', 'YYYY-MM-DD HH24:MI:SS')";
				q += "		 ,  '"+sRESCODE+"'";
				q += "		 )";
				rs2 = stmt2.executeQuery(q);
			
			Thread.sleep(1 * 1000);

			i++;
		}
		
		
	} catch(Exception e) {
		out.print(e.getMessage());
		e.printStackTrace();
	} finally {
		rs.close();
		if (rs2 != null) {
			rs2.close();
		}
		conn.close();
	}


%>
<%!
public static String makeCertString(String varName, String certificate, boolean doFromJSP)
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
%>