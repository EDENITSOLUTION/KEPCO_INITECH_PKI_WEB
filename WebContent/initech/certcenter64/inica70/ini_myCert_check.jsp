<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %> 
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file="import/iniplugin_init.jsp" %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/func.jsp" %>
<%!
 public byte[] getHashValue(String inputString)
    {
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
<%

String id = m_IP.getParameter("id");
String pw = m_IP.getParameter("pw");

	Context rvkIc = new InitialContext();
	DataSource rvkDs = (DataSource) rvkIc.lookup("java:comp/env/jdbc/INICA");
	ResultSet rvkRs = null;

	Connection rvkConn = null;
	Statement rvkStmt = null;

	int rvkCertCnt = 0 ;
	int rvkPwdUCnt = 0 ;


	try{
		rvkConn = rvkDs.getConnection();
		//Creat Query and get results
		rvkStmt = rvkConn.createStatement();
				

		rvkRs = rvkStmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + id + "' and userpwd = '" + getBase64Data(getHashValue(pw)) + "' ");
		
		//List results
		while(rvkRs.next()) {
			rvkPwdUCnt =  rvkRs.getInt("cnt");
		}

	
			if (rvkPwdUCnt == 0){
				//LDAP_INFO ������ ������ ���� ��
				//����ؾ��� �������� �������� �ʽ��ϴ�.

				response.setCharacterEncoding("EUC-KR");
				PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('���̵� Ȥ�� ��й�ȣ�� �߸��Ǿ����ϴ�.');");
				writer.println("history.back(-1);");
				writer.println("</script>");
				writer.flush();
				return;
			}

		session.setAttribute("myLogin",id);
		session.setMaxInactiveInterval(1000);
		response.sendRedirect("ini_myCert_list_view.jsp");

		

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		rvkRs.close();
		rvkStmt.close();
		rvkConn.close();
	}
%>