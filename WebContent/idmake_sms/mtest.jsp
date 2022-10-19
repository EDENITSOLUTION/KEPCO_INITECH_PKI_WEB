<%@ page contentType = "text/html; charset=euc-kr" %>
<%@ page import="java.util.*, javax.mail.*, javax.mail.internet.*" %>
<%

String smtpHost = "10.180.6.91"; // SMTP 서버 설정
String mailSubject = new String("[한국전력공사] 인터넷망 인증서 발급용 인증 번호".getBytes("8859_1"),"KSC5601");
String mailText = new String("이승훈님의 인터넷망 인증서 발급 인증번호는 : [000000]입니다.".getBytes("8859_1"),"KSC5601");
String fromAddress = "idmake@kepco.co.kr" ; //request.getParameter("from");        //보내는이


Properties props = new Properties();

props.put("mail.smtp.host", smtpHost);
Session s = Session.getInstance(props,null);
MimeMessage message = new MimeMessage(s); 

 
InternetAddress from = new InternetAddress(fromAddress);
message.setFrom(from); // 보내는이 설정
 
String toAddress = "ex099636@kepco.co.kr";//ex099129@request.getParameter("to"); 

InternetAddress to = new InternetAddress(toAddress); // 받는이 설정 
message.addRecipient(Message.RecipientType.TO, to);   
message.setSubject(mailSubject); // 제목 
message.setContent(mailText, "text/plain; charset=EUC-KR"); // content Type 설정 
message.setText(mailText); // 본문 
Transport.send(message); // 메일 발송
 
%>


