<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.*"%>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import="java.lang.String.*" %>
<%@ page import="javax.mail.*, javax.mail.internet.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ include file="fncSMS2.jsp" %>
<%!
//�޼��� �߼��ϱ�
public String mailCertSend(String mailTitle, String mailContent, String toMailAddress){
	
	String toAddress = toMailAddress ; //"ex099636@kepco.co.kr";
	String smtpHost = "127.0.0.1"; // SMTP ���� ����
	String mailSubject = mailTitle ;
						//new String("[�ѱ����°���] ���ͳݸ� ������ �߱޿� ���� ��ȣ".getBytes("8859_1"),"KSC5601");
	String mailText = mailContent ; 
						//new String("�̽��ƴ��� ���ͳݸ� ������ �߱� ������ȣ�� : [000000]�Դϴ�.".getBytes("8859_1"),"KSC5601");
	String fromAddress = "kepcosso@kepco.co.kr" ; //request.getParameter("from");        //��������


	Properties props = null;

	String resultMsg = "ok" ;

	try {
          props = new Properties();


		props.put("mail.smtp.host", smtpHost);
		Session s = Session.getInstance(props,null);
		MimeMessage message = new MimeMessage(s); 

		 
		InternetAddress from = new InternetAddress(fromAddress);
		message.setFrom(from); // �������� ����
		 

		InternetAddress to = new InternetAddress(toAddress); // �޴��� ���� 
		message.addRecipient(Message.RecipientType.TO, to);   
		message.setSubject(mailSubject); // ���� 
		message.setContent(mailText, "text/html"); // content Type ���� 
		message.setText(mailText, "utf-8", "html"); // ���� 
		Transport.send(message); // ���� �߼�

		resultMsg = "ok" ;
		
	}catch (Exception e) {
            resultMsg = e.toString();
    }
	return resultMsg ;
}
%>
<%

	String content = "";
	content = "<table border='1'>";
	content+= "<tr>";
	content+= "<td colspan='2'>image1</td>";
	content+= "</tr>";
	content+= "<tr>";
	content+= "<td colspan='2'>image2</td>";
	content+= "</tr>";
	content+= "<tr>";
	content+= "<td>image3</td>";
	content+= "<td>";
	content+= "<input type='text' value='123'/>";
	content+= "</td>";
	content+= "</tr>";
	content+= "<tr>";
	content+= "<td>";
	content+= "[���� ���ͳݸ�]���� ������ �븮�߱��� ��û�Ͽ����ϴ�.";
	content+= "</td>";
	content+= "</tr>";
	content+= "</table>";	
String result = mailCertSend("test", content, "ex099129@kepco.co.kr");
out.print(result);
%>