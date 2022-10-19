<%@ page contentType="text/html;charset=EUC-KR" %>
<%
//////////////////////////////////////////////////////////////////////////////
// STEP 1 : 넘어온 사용자 사번으로 사용자 정보 조회                         //
// STEP 2 : 사용자 정보가 없을 때, 에러코드 리턴                            //
// STEP 3 : 사용자 정보가 있을때                                            //
//         1) 해당 사용자의 사번으로 인증서 발급 내역 조회                  //
//            - 발급 내역이 있을 때 : 인증서 폐기 후, 성공 메세지 전달      //
//                                    비밀번호 동기화                       //
//            - 발급 내역이 없을 때 : 성공 메세지 전달                      //
//                                    비밀번호 동기화                       //
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
int isUserCnt = 0 ; //사용자 정보 존재 유무 카운트
int isUserCertCnt = 0 ; //사용자가 발급받은 인증서 존재 
String certUserNm = "사용자" ; //사용자명

try{
	// STEP 1 : 넘어온 사용자 사번으로 사용자 정보 조회 
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

//사용자 아이디로 발급 내역 조회한다.
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
//비밀번호 업데이트 ...
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
	//사용자아이디로 카운트하여 0보다 크면 update 0이면 insert
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
 

if (isUserCnt == 0){ //사용자 정보가 없을때
	//return error message
}else{ //사용자 정보가 있을때
	if (isUserCertCnt > 0 ) { // 인증서 발급내역이 존재 할때 폐기

		strHow = "certRevoke";

	}else{ //발급내역이 없으면 
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
		org_msg += "&OU=ICT Dept."; //정보기술처
		org_msg += "&CN=" + syncID;
		result_msg = m_IP.isprint(org_msg, false);
		out.println("result_code=success&result_msg="+result_msg);
		System.out.println("result_code=success&result_msg="+result_msg);
		

		//비밀번호 동기화 페이지로 이동
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
		// TODO 자동 생성된 catch 블록
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
