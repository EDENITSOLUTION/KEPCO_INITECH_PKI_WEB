<%@ page contentType="text/html;charset=EUC-KR" %>
<%
//////////////////////////////////////////////////////////////////////////////
// STEP 1 : �Ѿ�� ����� ������� ����� ���� ��ȸ                         //
// STEP 2 : ����� ������ ���� ��, �����ڵ� ����                            //
// STEP 3 : ����� ������ ������                                            //
//         1) �ش� ������� ������� ������ �߱� ���� ��ȸ                  //
//            - �߱� ������ ���� �� : ������ ��� ��, ���� �޼��� ����      //
//                                    ��й�ȣ ����ȭ                       //
//            - �߱� ������ ���� �� : ���� �޼��� ����                      //
//                                    ��й�ȣ ����ȭ                       //
//////////////////////////////////////////////////////////////////////////////
%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file="import/iniplugin_init.jsp" %>

<%
String syncID = m_IP.getParameter("id");
String syncPWD = m_IP.getParameter("pw");
String syncEncPWD = getBase64Data(getHashValue(syncPWD));

String strHow = "certNew";

Context CSic = new InitialContext();
DataSource CSds = (DataSource) CSic.lookup("java:comp/env/jdbc/USERS");
ResultSet CSrs = null;

Connection CSconn = null;
Statement CSstmt = null;
int isUserCnt = 0 ; //����� ���� ���� ���� ī��Ʈ
int isUserCertCnt = 0 ; //����ڰ� �߱޹��� ������ ���� 
String certUserNm = "�����" ; //����ڸ�

try{
	// STEP 1 : �Ѿ�� ����� ������� ����� ���� ��ȸ 
	CSconn = CSds.getConnection();
	//Creat Query and get results
	CSstmt = CSconn.createStatement();
	CSrs = CSstmt.executeQuery("SELECT COUNT(EMPNO) AS CNT FROM V_INSA WHERE EMPNO = '"+ syncID +"'");
	while (CSrs.next()){
		isUserCnt = CSrs.getInt("CNT");
	}

	CSrs = CSstmt.executeQuery("SELECT NAME as certUserNm FROM V_INSA where empno='" + syncID + "' ");
	while(CSrs.next()) {
		certUserNm =  CSrs.getString("certUserNm");
	}
	CSrs.close();
}
catch(Exception ex){
	ex.printStackTrace();
} finally {
	CSstmt.close();	
	CSconn.close();
}

//����� ���̵�� �߱� ���� ��ȸ�Ѵ�.
DataSource CSds1 = (DataSource) CSic.lookup("java:comp/env/jdbc/INICA");	
try{
	CSconn = CSds1.getConnection();
	CSstmt = CSconn.createStatement();
	CSrs = CSstmt.executeQuery("select count(userid) as CNT from ldap_info where userid='" +  syncID + "'");
	while (CSrs.next()){
		isUserCertCnt = CSrs.getInt("CNT");
	}
	CSrs.close();
}
catch(Exception ex){
	ex.printStackTrace();
} finally {
	CSstmt.close();
	CSconn.close();
}
//��й�ȣ ������Ʈ ...
Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
ResultSet rsu = null;

Connection connu = null;
Statement stmtu = null;
PreparedStatement pstmtu = null;

int rsPwdCnt = 0 ;
String insertSQL = null;

try {
	connu = dsu.getConnection();
	//Creat Query and get results
	stmtu = connu.createStatement();

	rsu = stmtu.executeQuery("select count(userid) as cnt from user_pwd where userid='" + syncID + "' ");
	//����ھ��̵�� ī��Ʈ�Ͽ� 0���� ũ�� update 0�̸� insert
	while( rsu.next() ) {
		rsPwdCnt = rsu.getInt("cnt");
	}
	
	if (rsPwdCnt == 0){
		//Inset
		insertSQL = "INSERT INTO USER_PWD (USERID, USERPWD,USERNAME, USERIP) VALUES ( '" + syncID + "', '" + syncEncPWD + "' , '" + certUserNm + "', '" + request.getRemoteAddr() + "')";
		pstmtu = connu.prepareStatement(insertSQL);
		pstmtu.executeUpdate();


	}else{
		//update
		insertSQL = "UPDATE USER_PWD set USERPWD = '" + syncEncPWD + "' , USERNAME= '" + certUserNm + "', MDDATE=SYSDATE, USERIP = '"+ request.getRemoteAddr() +"' WHERE USERID = '" + syncID + "'";
		pstmtu = connu.prepareStatement(insertSQL);
		pstmtu.executeUpdate();
	}
	
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rsu.close();
	connu.close();
}
 

if (isUserCnt == 0){ //����� ������ ������
	//return error message
}else{ //����� ������ ������
	if (isUserCertCnt > 0 ) { // ������ �߱޳����� ���� �Ҷ� ���

		strHow = "certRevoke";

	}else{ //�߱޳����� ������ 
		strHow = "certNew";
	}
}


if (isUserCnt > 0 ) { 
	m_How = strHow ;
%>

	<%@ include file="import/inica70_init.jsp" %>
	<%@ include file="import/inica70_db_check.jsp" %>
<%
	if (m_How.equals("certRevoke")) {
%>
		<%@ include file="import/inica70_ca_send.jsp" %>
<%
	}

	if (m_IniErrCode == null) {
		String result_msg = "";
		String org_msg = "";
		//System.out.println("id :: " + syncID + " & pwd :: " +  syncPWD);
		org_msg = "user_id=" + syncID; 
		org_msg += "&user_profile=71";
		org_msg += "&C=KR";
		org_msg += "&L=SEOUL";
		org_msg += "&O=KEPCO";
		org_msg += "&OU=ICT Dept."; //�������ó
		org_msg += "&CN=" + syncID;
		result_msg = m_IP.isprint(org_msg, false);
		out.println("result_code=success&result_msg="+result_msg);
		System.out.println("result_code=success&result_msg="+result_msg);
		

		//��й�ȣ ����ȭ �������� �̵�
		//response.sendRedirect("ini_cs_update_pwd.jsp?id="+ syncID + "&pw="+ syncEncPWD );



	}else{
		out.println("result_code=" + m_IniErrCode);
	}


%>
	<%@ include file="import/inica70_err_check.jsp" %>
<%
}
%>
<%!
public byte[] getHashValue(String inputString)     {
	MessageDigest md = null;
	
	try {
		md = MessageDigest.getInstance("MD5");
		
		md.update(inputString.getBytes());
		
	} catch (NoSuchAlgorithmException e) {
		// TODO �ڵ� ������ catch ���
		e.printStackTrace();
	}
	
	return md.digest(); 
}

public String getBase64Data(byte[] inputByte) throws IOException
{
	String returnString = "";
	returnString = new String(com.initech.util.Base64Util.encode(inputByte, false));

	return returnString;
}

%>
