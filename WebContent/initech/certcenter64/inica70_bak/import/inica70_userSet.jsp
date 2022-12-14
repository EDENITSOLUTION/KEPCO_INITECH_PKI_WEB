<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>

<% 
//*********************************************************
//  사용자가 입력한 아이디(사번)으로 발급정보가 있는지 확인
//*********************************************************


Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

String isCert = "Y" ; //발급유무
String CertGb = "발급" ;
int rsCnt = 0 ;

String certUserNm = "테스트사용자";

String revokeCertString = null; //폐기해야할 인증서 String 값

String userPwdCheck = "Y" ; //이전 패스워드 체크 플래그

// printf("test");	
try {
	
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();

	rs = stmt.executeQuery("select count(userid) as cnt from ldap_info where userid='" + m_ID + "' and status <> 'R' and expiredate >= sysdate ");
	//사용자아이디로 카운트하여 0보다 크면 재발급하고 0이면 발급
	
	while( rs.next() ) {
		rsCnt = rs.getInt("cnt");
	}
	
	if (rsCnt == 0){
		isCert = "N";
		CertGb = "신규 발급";
	}else{
		isCert = "Y";
		CertGb = "재발급";
	}
	
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}

//사용자정보를 인사정보에서 가지고 와서
//해당 사용자만 인증서 발급 받게 할지 체크
// false : 인사정보외 입력한 임의의 아이디로도 발급가능

if (is_insaUser) {
	Context insaIc = new InitialContext();
	DataSource insaDs = (DataSource) insaIc.lookup("java:comp/env/jdbc/USERS");
	ResultSet insaRs = null;

	Connection insaConn = null;
	Statement insaStmt = null;

	String m_userName = null;
	int userInsaCnt = 0 ;

	try{
		insaConn = insaDs.getConnection();
		//Creat Query and get results
		insaStmt = insaConn.createStatement();
		insaRs = insaStmt.executeQuery("SELECT count(*) as cnt FROM V_INSA where empno='" + m_ID + "' ");
		
		//List results
		while(insaRs.next()) {
			userInsaCnt =  insaRs.getInt("cnt");
		}

		if (userInsaCnt == 0){
			//인사DB에 사용자 정보가 없을 때
			//입력하신 사번에 대한 정보가 인사정보에는 존재하지 않습니다.

			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('입력하신 사번("+ m_ID +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
			writer.println("location.href='ini_certNew.jsp'");
		    writer.println("</script>");
			writer.flush();
			return;


		}else{
			insaRs = insaStmt.executeQuery("SELECT NAME as certUserNm FROM V_INSA where empno='" + m_ID + "' ");
			
			while(insaRs.next()) {
				certUserNm =  insaRs.getString("certUserNm");
			}
		}

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		insaRs.close();
		insaConn.close();
	}

} // 인사정보 체크 유무 end
else{
	certUserNm = "테스트사용자";
}


//인증서 폐기 하기
if (m_How.equals("certRevoke")) {
	//인증서 폐기를 위해 
	//Step1 : 폐기할 인증서가 있는지 체크한다.
	//        LDAP_INFO에서 검색하여 count가 0이면 발급페이지로
	//                               count가 0이상이면 폐기 프로세스
	Context rvkIc = new InitialContext();
	DataSource rvkDs = (DataSource) rvkIc.lookup("java:comp/env/jdbc/INICA");
	ResultSet rvkRs = null;

	Connection rvkConn = null;
	Statement rvkStmt = null;

	int rvkCertCnt = 0 ;
	int rvkPwdUCnt = 0 ;
	String strSerial = null;

	try{
		rvkConn = rvkDs.getConnection();
		//Creat Query and get results
		rvkStmt = rvkConn.createStatement();


		//인증서 폐기하기 위해 발급 정보가 존재하는 확인 
		//발급정보가 있으면 (count > 0) 폐기
		//발급정보가 없으면 (count = 0) 발급페이지로

		rvkRs = rvkStmt.executeQuery("select count(userid) as cnt from ldap_info where userid='" + m_ID + "' ");
		
		//List results
		while(rvkRs.next()) {
			rvkCertCnt =  rvkRs.getInt("cnt");
		}

		if (rvkCertCnt == 0){
			//LDAP_INFO 인증서 정보가 없을 때
			//폐기해야할 인증서가 존재하지 않습니다.
			if (m_strBrg.equals("Y")) { //발급프로세스 바로 처리
			}else{	

				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('입력하신 사번("+ m_ID +")으로 폐기해야 할 인증서가 존재하지 않습니다.인증서 발급페이지에서 인증서를 발급받아 주십시오');");
				writer.println("location.href='ini_certNew.jsp'");
				writer.println("</script>");
				writer.flush();
				return;
			}


		}else{ //입력받은 아이디와 비밀번호에 대한 인증서 존재
			rvkRs = rvkStmt.executeQuery("select serial from ldap_info where userid='" + m_ID + "' ");
			while(rvkRs.next()) {
				m_certserial =  rvkRs.getString("serial");
			}
			
		}
		
			
		//Step2 : 인증서 발급시 기존 발급정보가 있을때
		//        바로 폐기를 하되 이때는 따로 비번 체크안한다
		//Step2 : 입력한 사용자의 사번과 PWD가 존재하는지 체크한다.
		//Step2 : 입력한 사용자의 사번과 PWD가 존재하는지 체크한다.
				

		rvkRs = rvkStmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + m_ID + "' and userpwd = '" + getBase64Data(getHashValue(m_pw)) + "' ");
		
		//List results
		while(rvkRs.next()) {
			rvkPwdUCnt =  rvkRs.getInt("cnt");
		}

		if (m_strBrg.equals("Y")) {
		}else{		
			if (rvkPwdUCnt == 0){
				//LDAP_INFO 인증서 정보가 없을 때
				//폐기해야할 인증서가 존재하지 않습니다.

				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('인증서 비밀번호가 잘못되었습니다.');");
				writer.println("location.href='ini_certRevoke.jsp'");
				writer.println("</script>");
				writer.flush();
				return;
			}
		}

		

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		rvkRs.close();
		rvkStmt.close();
		rvkConn.close();
	}
	
	//클라이언트 PC의 인증서를 삭제하기 위해
	//CA CERT_INFO Table에서 인증서 String 값을 가지고 오자
	Context certIc = new InitialContext();
	DataSource certDs = (DataSource) certIc.lookup("java:comp/env/jdbc/INIRA");
	ResultSet certRs = null;

	Connection certConn = null;
	Statement certStmt = null;
	try{
		certConn = certDs.getConnection();
		//Creat Query and get results
		certStmt = certConn.createStatement();

		certRs = certStmt.executeQuery("SELECT CERTIFICATE FROM CERT_INFO WHERE SERIAL = '"+ m_certserial +"' ");
		
		while(certRs.next()) {
			revokeCertString =  certRs.getString("CERTIFICATE");
		}

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		certRs.close();
		certStmt.close();
		certConn.close();
	}
	


}

//SMS인증체크하기
if (m_How.equals("certNew")) { //인증서 발급시에만 체크하자
	if (is_smsChk) {
		String seq = m_tmid + "_" + m_ID + "_" + request.getRemoteAddr();
		String smsQry = "" ;
		smsQry = smsQry + "select count(x.smsnum) as cnt " ;
		smsQry = smsQry + "from ( " ;
		smsQry = smsQry + "	select a.smsnum " ;
		smsQry = smsQry + "	, rank() over (order by a.crdate desc) AS ranking " ;
		smsQry = smsQry + "	from sms_log a " ;
		smsQry = smsQry + "	where a.userid='"+ m_ID +"' " ;
		smsQry = smsQry + "		and a.userip = '"+ request.getRemoteAddr() +"' " ;
		smsQry = smsQry + "		and a.seq = '"+ seq +"' " ;
		smsQry = smsQry + "	order by a.crdate desc " ;
		smsQry = smsQry + ") x " ;
		smsQry = smsQry + " where x.ranking=1  and x.smsnum='"+ m_sms +"'" ;

		String delQry = "";
		delQry = "delete from sms_log " ;
		delQry = delQry + "	where userid='"+ m_ID +"' " ;
		delQry = delQry + "		and userip = '"+ request.getRemoteAddr() +"' " ;
		delQry = delQry + "		and seq = '"+ seq +"' " ;
		delQry = delQry + "		and smsnum = '"+ m_sms +"' " ;

		Context icsm = new InitialContext();
		DataSource dssm = (DataSource) icsm.lookup("java:comp/env/jdbc/INICA");
		ResultSet rss = null;
		Connection conns = null;
		Statement stmts = null;
		PreparedStatement pstmtsm = null;

		int rsSmsCnt = 0 ;

		try {
			conns = dssm.getConnection();
			stmts = conns.createStatement();

			rss = stmts.executeQuery(smsQry);
			//사용자아이디로 카운트하여 0보다 크면 update 0이면 insert
			while( rss.next() ) {
				rsSmsCnt = rss.getInt("cnt");
			}
			
			if (rsSmsCnt == 0){
				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('입력하신 인증번호는 올바른 SMS인증번호가 아닙니다.\\n다시 한번 인증서 발급을 하십시오.');");
				writer.println("location.href='ini_certNew.jsp';");
				writer.println("</script>");
				writer.flush();
				return;


			}else{
				//정상적으로 수행하면 기존 데이터는 삭제하자.
				//pstmtsm = conns.prepareStatement(delQry);
				//pstmtsm.executeUpdate();

			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			rss.close();
			conns.close();
		}
	}
}


//이전 패스워드 체크유무
	
Context ictPwd = new InitialContext();
DataSource dsPwd = (DataSource) ictPwd.lookup("java:comp/env/jdbc/INICA");
ResultSet rsPwd = null;
Connection connPwd = null;
Statement stmtPwd = null;

String orgPWD = "";
String encryptPWD = "" ;

try {
	
	connPwd = dsPwd.getConnection();
	//Creat Query and get results
	stmtPwd = connPwd.createStatement();

	//-------------------------------------------
	// STEP 1 : 넘어온 사번으로 사용자가 존재하는 지 체크하다
	//-------------------------------------------    
	rsPwd = stmtPwd.executeQuery("SELECT USERPWD  FROM USER_PWD WHERE USERID = '"+ m_ID +"'");
	
	
	//-------------------------------------------
	// STEP 2 : 사용자가 존재한다면
	//-------------------------------------------  
	if (rsPwd.next())     	{
		//-------------------------------------------
		// STEP 2-1 : 넘어온 비번을 암호화한다
		//------------------------------------------- 
		encryptPWD = getBase64Data(getHashValue(m_pw));
		orgPWD = rsPwd.getString("USERPWD");			// USERPWD

		//-------------------------------------------
		// STEP 2-2 : 암호화한 비번과 DB에 있는 비번을 비교한다
		//------------------------------------------- 
		if (encryptPWD.equals(orgPWD)) {
			//-------------------------------------------
			// STEP 2-3 : 두개값이 같다면 N 리턴하고
			//------------------------------------------- 
			userPwdCheck = "N" ;
		}else{
			//-------------------------------------------
			// STEP 2-4 : 두개값이 다르다면 Y를 리턴한다.
			//------------------------------------------- 
			userPwdCheck = "Y" ;
		}
	} else{
		//-------------------------------------------
		// STEP 3 : 사용자가 존재하지 않는다면 Y 로 리턴한다
		//-------------------------------------------    
		userPwdCheck = "Y" ;
	}
	
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rsPwd.close();
	stmtPwd.close();
	connPwd.close();
}

%>	

<%!
 public byte[] getHashValue(String inputString)
    {
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
