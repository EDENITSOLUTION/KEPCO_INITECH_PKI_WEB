<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>

<% 
//*********************************************************
//  ����ڰ� �Է��� ���̵�(���)���� �߱������� �ִ��� Ȯ��
//*********************************************************


Context ict = new InitialContext();
DataSource ds = (DataSource) ict.lookup("java:comp/env/jdbc/INICA");
ResultSet rs = null;

Connection conn = null;
Statement stmt = null;

String isCert = "Y" ; //�߱�����
String CertGb = "�߱�" ;
int rsCnt = 0 ;

String certUserNm = "�׽�Ʈ�����";

String revokeCertString = null; //����ؾ��� ������ String ��

String userPwdCheck = "Y" ; //���� �н����� üũ �÷���

// printf("test");	
try {
	
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();

	rs = stmt.executeQuery("select count(userid) as cnt from ldap_info where userid='" + m_ID + "' and status <> 'R' and expiredate >= sysdate ");
	//����ھ��̵�� ī��Ʈ�Ͽ� 0���� ũ�� ��߱��ϰ� 0�̸� �߱�
	
	while( rs.next() ) {
		rsCnt = rs.getInt("cnt");
	}
	
	if (rsCnt == 0){
		isCert = "N";
		CertGb = "�ű� �߱�";
	}else{
		isCert = "Y";
		CertGb = "��߱�";
	}
	
} catch(Exception e) {
	e.printStackTrace();
} finally {
	rs.close();
	conn.close();
}

//����������� �λ��������� ������ �ͼ�
//�ش� ����ڸ� ������ �߱� �ް� ���� üũ
// false : �λ������� �Է��� ������ ���̵�ε� �߱ް���

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
			//�λ�DB�� ����� ������ ���� ��
			//�Է��Ͻ� ����� ���� ������ �λ��������� �������� �ʽ��ϴ�.

			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('�Է��Ͻ� ���("+ m_ID +")�� ���� ������ �λ��������� �������� �ʽ��ϴ�.');");
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

} // �λ����� üũ ���� end
else{
	certUserNm = "�׽�Ʈ�����";
}


//������ ��� �ϱ�
if (m_How.equals("certRevoke")) {
	//������ ��⸦ ���� 
	//Step1 : ����� �������� �ִ��� üũ�Ѵ�.
	//        LDAP_INFO���� �˻��Ͽ� count�� 0�̸� �߱���������
	//                               count�� 0�̻��̸� ��� ���μ���
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


		//������ ����ϱ� ���� �߱� ������ �����ϴ� Ȯ�� 
		//�߱������� ������ (count > 0) ���
		//�߱������� ������ (count = 0) �߱���������

		rvkRs = rvkStmt.executeQuery("select count(userid) as cnt from ldap_info where userid='" + m_ID + "' ");
		
		//List results
		while(rvkRs.next()) {
			rvkCertCnt =  rvkRs.getInt("cnt");
		}

		if (rvkCertCnt == 0){
			//LDAP_INFO ������ ������ ���� ��
			//����ؾ��� �������� �������� �ʽ��ϴ�.
			if (m_strBrg.equals("Y")) { //�߱����μ��� �ٷ� ó��
			}else{	

				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('�Է��Ͻ� ���("+ m_ID +")���� ����ؾ� �� �������� �������� �ʽ��ϴ�.������ �߱����������� �������� �߱޹޾� �ֽʽÿ�');");
				writer.println("location.href='ini_certNew.jsp'");
				writer.println("</script>");
				writer.flush();
				return;
			}


		}else{ //�Է¹��� ���̵�� ��й�ȣ�� ���� ������ ����
			rvkRs = rvkStmt.executeQuery("select serial from ldap_info where userid='" + m_ID + "' ");
			while(rvkRs.next()) {
				m_certserial =  rvkRs.getString("serial");
			}
			
		}
		
			
		//Step2 : ������ �߱޽� ���� �߱������� ������
		//        �ٷ� ��⸦ �ϵ� �̶��� ���� ��� üũ���Ѵ�
		//Step2 : �Է��� ������� ����� PWD�� �����ϴ��� üũ�Ѵ�.
		//Step2 : �Է��� ������� ����� PWD�� �����ϴ��� üũ�Ѵ�.
				

		rvkRs = rvkStmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + m_ID + "' and userpwd = '" + getBase64Data(getHashValue(m_pw)) + "' ");
		
		//List results
		while(rvkRs.next()) {
			rvkPwdUCnt =  rvkRs.getInt("cnt");
		}

		if (m_strBrg.equals("Y")) {
		}else{		
			if (rvkPwdUCnt == 0){
				//LDAP_INFO ������ ������ ���� ��
				//����ؾ��� �������� �������� �ʽ��ϴ�.

				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('������ ��й�ȣ�� �߸��Ǿ����ϴ�.');");
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
	
	//Ŭ���̾�Ʈ PC�� �������� �����ϱ� ����
	//CA CERT_INFO Table���� ������ String ���� ������ ����
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

//SMS����üũ�ϱ�
if (m_How.equals("certNew")) { //������ �߱޽ÿ��� üũ����
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
			//����ھ��̵�� ī��Ʈ�Ͽ� 0���� ũ�� update 0�̸� insert
			while( rss.next() ) {
				rsSmsCnt = rss.getInt("cnt");
			}
			
			if (rsSmsCnt == 0){
				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('�Է��Ͻ� ������ȣ�� �ùٸ� SMS������ȣ�� �ƴմϴ�.\\n�ٽ� �ѹ� ������ �߱��� �Ͻʽÿ�.');");
				writer.println("location.href='ini_certNew.jsp';");
				writer.println("</script>");
				writer.flush();
				return;


			}else{
				//���������� �����ϸ� ���� �����ʹ� ��������.
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


//���� �н����� üũ����
	
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
	// STEP 1 : �Ѿ�� ������� ����ڰ� �����ϴ� �� üũ�ϴ�
	//-------------------------------------------    
	rsPwd = stmtPwd.executeQuery("SELECT USERPWD  FROM USER_PWD WHERE USERID = '"+ m_ID +"'");
	
	
	//-------------------------------------------
	// STEP 2 : ����ڰ� �����Ѵٸ�
	//-------------------------------------------  
	if (rsPwd.next())     	{
		//-------------------------------------------
		// STEP 2-1 : �Ѿ�� ����� ��ȣȭ�Ѵ�
		//------------------------------------------- 
		encryptPWD = getBase64Data(getHashValue(m_pw));
		orgPWD = rsPwd.getString("USERPWD");			// USERPWD

		//-------------------------------------------
		// STEP 2-2 : ��ȣȭ�� ����� DB�� �ִ� ����� ���Ѵ�
		//------------------------------------------- 
		if (encryptPWD.equals(orgPWD)) {
			//-------------------------------------------
			// STEP 2-3 : �ΰ����� ���ٸ� N �����ϰ�
			//------------------------------------------- 
			userPwdCheck = "N" ;
		}else{
			//-------------------------------------------
			// STEP 2-4 : �ΰ����� �ٸ��ٸ� Y�� �����Ѵ�.
			//------------------------------------------- 
			userPwdCheck = "Y" ;
		}
	} else{
		//-------------------------------------------
		// STEP 3 : ����ڰ� �������� �ʴ´ٸ� Y �� �����Ѵ�
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
            // TODO �ڵ� ������ catch ����
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