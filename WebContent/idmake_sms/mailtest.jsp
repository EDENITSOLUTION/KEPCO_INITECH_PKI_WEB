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
//메세지 발송하기
public String mailCertSend(String mailTitle, String mailContent, String toMailAddress){
	
	String toAddress = toMailAddress ; //"ex099636@kepco.co.kr";
	String smtpHost = "127.0.0.1"; // SMTP 서버 설정
	String mailSubject = mailTitle ;
						//new String("[한국전력공사] 인터넷망 인증서 발급용 인증 번호".getBytes("8859_1"),"KSC5601");
	String mailText = mailContent ; 
						//new String("이승훈님의 인터넷망 인증서 발급 인증번호는 : [000000]입니다.".getBytes("8859_1"),"KSC5601");
	String fromAddress = "kepcosso@kepco.co.kr" ; //request.getParameter("from");        //보내는이


	Properties props = null;

	String resultMsg = "ok" ;

	try {
          props = new Properties();


		props.put("mail.smtp.host", smtpHost);
		Session s = Session.getInstance(props,null);
		MimeMessage message = new MimeMessage(s); 

		 
		InternetAddress from = new InternetAddress(fromAddress);
		message.setFrom(from); // 보내는이 설정
		 

		InternetAddress to = new InternetAddress(toAddress); // 받는이 설정 
		message.addRecipient(Message.RecipientType.TO, to);   
		message.setSubject(mailSubject); // 제목 
		message.setContent(mailText, "text/html"); // content Type 설정 
		message.setText(mailText, "utf-8", "html"); // 본문 
		Transport.send(message); // 메일 발송

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
	content+= "[한전 인터넷망]님이 인증서 대리발급을 요청하였습니다.";
	content+= "</td>";
	content+= "</tr>";
	content+= "</table>";	
String result = mailCertSend("test", content, "ex099129@kepco.co.kr");
out.print(result);
%>