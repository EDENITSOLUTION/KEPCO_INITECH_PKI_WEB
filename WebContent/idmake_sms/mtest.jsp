<%@ page contentType = "text/html; charset=euc-kr" %>
<%@ page import="java.util.*, javax.mail.*, javax.mail.internet.*" %>
<%

String smtpHost = "10.180.6.91"; // SMTP ���� ����
String mailSubject = new String("[�ѱ����°���] ���ͳݸ� ������ �߱޿� ���� ��ȣ".getBytes("8859_1"),"KSC5601");
String mailText = new String("�̽��ƴ��� ���ͳݸ� ������ �߱� ������ȣ�� : [000000]�Դϴ�.".getBytes("8859_1"),"KSC5601");
String fromAddress = "idmake@kepco.co.kr" ; //request.getParameter("from");        //��������


Properties props = new Properties();

props.put("mail.smtp.host", smtpHost);
Session s = Session.getInstance(props,null);
MimeMessage message = new MimeMessage(s); 

 
InternetAddress from = new InternetAddress(fromAddress);
message.setFrom(from); // �������� ����
 
String toAddress = "ex099636@kepco.co.kr";//ex099129@request.getParameter("to"); 

InternetAddress to = new InternetAddress(toAddress); // �޴��� ���� 
message.addRecipient(Message.RecipientType.TO, to);   
message.setSubject(mailSubject); // ���� 
message.setContent(mailText, "text/plain; charset=EUC-KR"); // content Type ���� 
message.setText(mailText); // ���� 
Transport.send(message); // ���� �߼�
 
%>


