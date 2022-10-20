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

 public byte[] getHashValue(String inputString) {
	MessageDigest md = null;
	try {
		md = MessageDigest.getInstance("MD5");
		md.update(inputString.getBytes());
	} catch (NoSuchAlgorithmException e) {
		e.printStackTrace();
	}
	
	return md.digest(); 
}

public String getBase64Data(byte[] inputByte) throws IOException {
	String returnString = "";
	returnString = new String(com.initech.util.Base64Util.encode(inputByte, false));
	return returnString;
}
%>
<%
String strIsInsa = request.getParameter("strIsInsa"); //SMS인사정보 연동 유무
if (strIsInsa.equals("") || strIsInsa == null) {
	strIsInsa = "N"; //default는 연동하지 않음
}

String empno = request.getParameter("empno"); //사번
String tmid = request.getParameter("tmid");//타임아이디
String refuserid = request.getParameter("refuserid");//참조자 또는 대신 받을 직원 사번 
String orguserpw = request.getParameter("orguserpw");
String seq = "" ;
String strSql = "" ;


String org_mail = "" ; //request.getParameter("org_mail"); //DB에 저장된 번호
String sendMail = "" ; 

String sendCnt = "00001"; //보내야할 SMS전송 수

//check validation
if (empno.equals("") || empno==null || tmid.equals("") || tmid==null || refuserid.equals("") || refuserid==null ){
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('메일 인증을 위한 사번 및 메일주소가 누락되어 전달되었습니다.');");
	writer.println("window.close();");
	writer.println("</script>");
	writer.flush();
	return;
} // end of check all of validation 

int cnt_user = 0 ; // 사번에 해당하는 사용자 존재 유무(0:없음, 그외 존재)
String isChk = "Y"; // 인사정보에 연락처가 제대로 등록안되었을 경우 플래그
String cellQry = "" ;
String strMsg = "" ;

String orgInsaOrgPhone = "" ; //인사정보에 실제로 등록된 전화번호
String orgInsaOrgMail = "" ; //인사정보에 실제로 등록된 전화번호
String orgSendFmatMail = "x" ; //SMS전송을 위해 포맷변경된 전화번호
String orgUserName = "" ; //전달하고자하는 사번 사용자의 이름

String refInsaOrgPhone = "" ; //인사정보에 실제로 등록된 전화번호
String refInsaOrgMail = "" ; //인사정보에 실제로 등록된 전화번호
String refSendFmatMail = "x" ; //SMS전송을 위해 포맷변경된 전화번호
String refSendFmatPhone = "x" ; //SMS전송을 위해 포맷변경된 전화번호
String refUserName = "" ; //전달하고자하는 사번 사용자의 이름

String isNoMailUser = "Y" ; //인사정보에 이메일이 잘못된 사용자 인지 체크
String NoMailUserNum = "x" ;
String strRefUserID = empno ;
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//////////// 사번으로 사용자 메일주소 검색 Start //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
Context ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
ResultSet rs = null;
Connection conn = null;
Statement stmt = null;

try{
	//사번이 인사정보에 존재하는지 체크
	conn = ds.getConnection();
	//Creat Query and get results
	stmt = conn.createStatement();


	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ empno +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isChk = "N" ;
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('입력하신 사번("+ empno +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // 사용자 정보 존재할때				
		cellQry = "" ;
		cellQry = cellQry + "SELECT "; 
		cellQry = cellQry + "		X.EMPNO ";
		cellQry = cellQry + "	,	X.USER_NAME ";
		cellQry = cellQry + "	,	X.MAILNO ";
		cellQry = cellQry + "   ,( ";
		cellQry = cellQry + "		CASE WHEN X.MAILNO IS NULL THEN 'x' ";
		cellQry = cellQry + "		ELSE ";
		cellQry = cellQry + "			CASE INSTR(X.MAILNO,'@',1)  ";
		cellQry = cellQry + "				WHEN 0 THEN X.MAILNO || '@kepco.co.kr' ";
		cellQry = cellQry + "		    ELSE X.MAILNO ";
		cellQry = cellQry + "			END ";
		cellQry = cellQry + "		END ";
		cellQry = cellQry + "    ) AS MAILADDR ";
		cellQry = cellQry + "	,   X.CELLNO ";
		cellQry = cellQry + "	,	X.VAL1 ";
		cellQry = cellQry + "	,	X.VAL2 ";
		cellQry = cellQry + "	,( ";
		cellQry = cellQry + "		CASE WHEN X.VAL1 = 'ok' THEN X.CELLNO ";
		cellQry = cellQry + "		ELSE ";
		cellQry = cellQry + "			CASE WHEN X.VAL2 = 'ok' THEN  ";
		cellQry = cellQry + "				CASE WHEN LENGTH(X.CELLNO) = 10 THEN ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,3) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,7,4) ";
		cellQry = cellQry + "				ELSE ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,4) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,8,4) ";
		cellQry = cellQry + "				END ";
		cellQry = cellQry + "			ELSE 'x' ";
		cellQry = cellQry + "			END ";
		cellQry = cellQry + "		END ";
		cellQry = cellQry + "	) AS PHONENUM ";
		cellQry = cellQry + " FROM ( ";
		cellQry = cellQry + "	SELECT ";
		cellQry = cellQry + "		EMPNO ";
		cellQry = cellQry + "		, MAILNO ";
		cellQry = cellQry + "		, NAME AS USER_NAME ";
		cellQry = cellQry + "		, CELLNO ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL1  ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL2 ";
		cellQry = cellQry + "	FROM  V_INSA ";
		cellQry = cellQry + "	WHERE EMPNO = '"+ empno +"' ";
		cellQry = cellQry + ") X ";
						
		
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
			orgInsaOrgPhone = rs.getString("CELLNO");
			orgSendFmatMail = rs.getString("MAILADDR");
			orgInsaOrgMail = rs.getString("MAILADDR");
			orgUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//연락처가 제대로 등록이 안된 경우

		if (orgSendFmatMail.equals("x")  ){
			isNoMailUser = "N" ;
		}else{
			isChk = "Y" ;			
		}
	}


	rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM V_INSA WHERE EMPNO ='"+ refuserid +"'");
	while (rs.next()){
		cnt_user = rs.getInt("cnt");
	}
	if (cnt_user == 0){
		isChk = "N" ;
		response.setCharacterEncoding("EUC-KR");
		PrintWriter writer = response.getWriter();
		writer.println("<script type='text/javascript'>");
		writer.println("alert('입력하신 사번("+ refuserid +")에 대한 정보가 인사정보에는 존재하지 않습니다.');");
		writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
		writer.println("</script>");
		writer.flush();
		return;
	}else{ // 사용자 정보 존재할때				
		cellQry = "" ;
		cellQry = cellQry + "SELECT "; 
		cellQry = cellQry + "		X.EMPNO ";
		cellQry = cellQry + "	,	X.USER_NAME ";
		cellQry = cellQry + "	,   X.CELLNO ";
		cellQry = cellQry + "	,	X.VAL1 ";
		cellQry = cellQry + "	,	X.VAL2 ";
		cellQry = cellQry + "	,( ";
		cellQry = cellQry + "		CASE WHEN X.VAL1 = 'ok' THEN X.CELLNO ";
		cellQry = cellQry + "		ELSE ";
		cellQry = cellQry + "			CASE WHEN X.VAL2 = 'ok' THEN  ";
		cellQry = cellQry + "				CASE WHEN LENGTH(X.CELLNO) = 10 THEN ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,3) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,7,4) ";
		cellQry = cellQry + "				ELSE ";
		cellQry = cellQry + "					SUBSTR(X.CELLNO,1,3) || '-' || SUBSTR(X.CELLNO,4,4) ";
		cellQry = cellQry + "					|| '-' || SUBSTR(X.CELLNO,8,4) ";
		cellQry = cellQry + "				END ";
		cellQry = cellQry + "			ELSE 'x' ";
		cellQry = cellQry + "			END ";
		cellQry = cellQry + "		END ";
		cellQry = cellQry + "	) AS PHONENUM ";
		cellQry = cellQry + " FROM ( ";
		cellQry = cellQry + "	SELECT ";
		cellQry = cellQry + "		EMPNO ";
		cellQry = cellQry + "		, NAME AS USER_NAME ";
		cellQry = cellQry + "		, CELLNO ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}-[0-9]{3,4}-[0-9]{4}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL1  ";
		cellQry = cellQry + "		, DECODE ( ";
		cellQry = cellQry + "			REGEXP_REPLACE(  ";
		cellQry = cellQry + "				REGEXP_SUBSTR(  ";
		cellQry = cellQry + "					CELLNO,  ";
		cellQry = cellQry + "					'01[0-9]{1}[0-9]{7,8}',  ";
		cellQry = cellQry + "					1 ";
		cellQry = cellQry + "				), '[^0-9]', '-' ";
		cellQry = cellQry + "			)  ";
		cellQry = cellQry + "		, '','x','ok') VAL2 ";
		cellQry = cellQry + "	FROM  V_INSA ";
		cellQry = cellQry + "	WHERE EMPNO = '"+ refuserid +"' ";
		cellQry = cellQry + ") X ";
						
		
		rs = stmt.executeQuery(cellQry);
		
		while (rs.next()){
			refSendFmatPhone = rs.getString("PHONENUM").replace("-","");
			refInsaOrgPhone = rs.getString("CELLNO");
			refSendFmatMail = rs.getString("MAILADDR");
			refInsaOrgMail = rs.getString("MAILADDR");
			refUserName = rs.getString("USER_NAME");
		}

		cnt_user = 1;


		//연락처가 제대로 등록이 안된 경우

		if (refSendFmatMail.equals("x")  ){
			isChk = "N" ;
			strMsg = "인사정보에 등록된 올바른 사번이나 해당 사용자의 메일주소가\\n정상적으로 등록되지 않았습니다.\\n사용자 정보(사번) : "+ refUserName +"("+ refuserid +")\\n등록된 메일주소 : 미등록" ;
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('"+ strMsg +"');");
			writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"'");
			writer.println("</script>");
			writer.flush();
			return;
		}else{
			isChk = "Y" ;			
		}
	}
}
catch(Exception ex){
	ex.printStackTrace();
} finally {
	rs.close();
	stmt.close();
	conn.close();
}

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//////////// 사번으로 사용자 메일주소 검색 End ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


//make MAIL  seq 
seq = tmid + "_" + empno + "_" + request.getRemoteAddr() ; // 20140709172427_ex099129_255.255.255.255


/////////////////////////////////////////////////////////////////////////////////////////
////1. 메일주소 비정상 등록
////   case 1 )  empno != refuserid
////             - 한번만 발송
////2. 메일주소 정상 등록
////   case 2) empno = refuserid  REFUSERID
////		     - 한번만 발송
////   case 3) empno != refuserid
////             - 두번 발송
////	       a. 인증코드 발송 : smsphonenum = refuserid phone
////	       b. 확인코드 발송 : smsphonenum = empno phone
/////////////////////////////////////////////////////////////////////////////////////////

if (isNoMailUser.equals("N")) { // 이메일 번호가 정상적으로 등록된 사용자가 아닐 경우
	sendCnt = "00001"; //이메일도 정상적으로 등록안되었으니 다른 사용자에게 알림 메세지 보낼수없으니 한번
	sendMail = refSendFmatMail.replace("-","");
	org_mail = refSendFmatMail.replace("-","");
	strRefUserID = refuserid ;
}else{ // 이메일 번호가 정상적으로 등록되었을 경우의 사용자
	if (empno.equals(refuserid)){//실제 사용자 사번과 받는 사용자 사번이 같을 때(사용자 변경안한 Default 상태)
		sendCnt = "00001"; 
		sendMail = orgSendFmatMail.replace("-","");
		org_mail = orgSendFmatMail.replace("-","");
		strRefUserID = empno ;
	}else{ //사번변경해서 보낼때
		sendCnt = "00002";
		sendMail = refSendFmatMail.replace("-","");
		org_mail = orgSendFmatMail.replace("-","");
		strRefUserID = refuserid ;
	}
}

if ("00002".equals(sendCnt)) {

	Context rIc = new InitialContext();
	DataSource rDs = (DataSource) rIc.lookup("java:comp/env/jdbc/INICA");
	ResultSet rRs = null;

	Connection rConn = null;
	Statement rStmt = null;

	try{
		rConn = rDs.getConnection();
		rStmt = rConn.createStatement();
		rRs = rStmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + empno + "' and userpwd = '" + getBase64Data(getHashValue(orguserpw)) + "' ");
		
		int rPwdUCnt = 0;
		while(rRs.next()) {
			rPwdUCnt =  rRs.getInt("cnt");
		}

		if (rPwdUCnt == 0) {
			response.setCharacterEncoding("EUC-KR");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('발급받을 사원의 비밀번호가 일치하지 않습니다.');");
			writer.println("location.href='webmailform.jsp?empno="+ empno +"&tmid="+ tmid +"&refuserid2="+refuserid+"'");
			writer.println("</script>");
			writer.flush();
			return;
		}

	}
	catch(Exception ex){
		ex.printStackTrace();
	} finally {
		rRs.close();
		rStmt.close();
		rConn.close();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 START   /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
String certkey = "000000";

int RandNum = (int)(Math.random()*1000000 + 1);
DecimalFormat dt = new DecimalFormat("000000");
certkey = dt.format(RandNum);

/*
String strTitText = "";
String strMsgText ="=================================================================================" + (char)10 ;
strMsgText = strMsgText + "---------------------------------------------------------------------------------" + (char)10 + (char)10 ; 
strMsgText = strMsgText + "[한국전력공사]  인터넷망 PC 사설인증서 발급용 인증번호는 [ "+certkey+" ]입니다." + (char)10 + (char)10 ;
strMsgText = strMsgText + orgUserName + "(" + empno + ")님의 인증서를 " + refUserName + "(" + refuserid + ")님이 대리발급을 요청하였습니다."  + (char)10 + (char)10 ;
strMsgText = strMsgText + "---------------------------------------------------------------------------------" + (char)10 ; 
strMsgText = strMsgText + "=================================================================================" + (char)10 ; 

//////////////////////////////////////////////////////////////////////////////////////////
//SMS인증번호 만들기 END   ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////






String RefSendMsg = "KEPCO-SSO 인증번호요청알림 : 인증번호 - "+ certkey +" / 요청 이메일 - "+ sendMail +"("+ refUserName +")" + (char)10 + (char)10 ;
RefSendMsg = RefSendMsg + orgUserName + "(" + empno + ")님의 인증서를 " + refUserName + "(" + refuserid + ")님이 대리발급을 요청하였습니다." ;
*/

//메일 발송
String sendMailing = "" ;

String sendRefMailing = "" ;

if (sendCnt.equals("00002")) { // 대리 발급인 경우

	String subject = "[한전 인터넷망] 인증서 발급용 인증번호";
	String content = certkey;
	sendMailing = mailCertSend(subject, content, sendMail) ; // 대리자
	
	subject = "[한전 인터넷망] 인증서 대리발급 요청";
	
	
	content = "";
	//content = "<table border='1'>";
	//content+= "<tr>";
	//content+= "<td colspan='2'>image1</td>";
	//content+= "</tr>";
	//content+= "<tr>";
	//content+= "<td colspan='2'>image2</td>";
	//content+= "</tr>";
	//content+= "<tr>";
	//content+= "<td>image3</td>";
	//content+= "<td>";
	//content+= "<input type='text' value='123'/>";
	//content+= "</td>";
	//content+= "</tr>";
	//content+= "<tr>";
	//content+= "<td>";
	content+= "[한전 인터넷망] "+orgUserName+"("+empno+")님의 인증서를 "+refUserName+"("+refuserid+")님이 인증서 대리발급을 요청하였습니다.";
	//content+= "</td>";
	//content+= "</tr>";
	//content+= "</table>";	
	
	
	sendRefMailing = mailCertSend(subject, content, org_mail) ; // 본인
	//sendSMS(empno, orgInsaOrgPhone, content);
	sendSMS(empno, orgInsaOrgPhone, "[한전 인터넷망] "+refUserName+"("+refuserid+")님이 인증서 대리발급을 요청하였습니다.");

} else { // 본인 발급인 경우
	
	String subject = "[한전 인터넷망] 인증서 발급용 인증번호";
	String content = certkey;
	sendMailing = mailCertSend(subject, content, sendMail) ;

}

//SMS정보 db insert
Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
//ResultSet rsu = null;

Connection connu = null;
//Statement stmtu = null;
PreparedStatement pstmtu = null;

strSql = "INSERT INTO SMS_LOG ( SEQ, USERID, USERIP, SMSNUM, RETCODE, USERPHONE, REFUSERID)  VALUES ( '"+ seq +"', '"+ empno +"', '"+ request.getRemoteAddr() +"', '"+ certkey +"', '9999', '"+ sendMail +"', '"+ strRefUserID +"' )" ;


try {
	connu = dsu.getConnection();
	//stmtu = connu.createStatement();
	pstmtu = connu.prepareStatement(strSql);
	pstmtu.executeUpdate();

} catch(Exception e) {
	e.printStackTrace();
} finally {
	pstmtu.close();
	connu.close();
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>메일 인증하기</title>
<script  type="text/javascript" language="javascript">
function  fncConfirm() {
	alert("입력하신 메일 주소로 인증번호를 발송하였습니다.\n\n메일 확인 후, 인증번호를 입력하십시오.");
	opener.readForm.sms.style.background="#ffffff";
	opener.readForm.sms.disabled=false;
	opener.setTimerOn();
	window.close();
}
</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="fncConfirm();">
<!-- 
sendMailing : <%=sendMailing%>
sendRefMailing : <%=sendRefMailing%>
org_mail : <%=org_mail%><br />
sendMail : <%=sendMail%><br />
sendCnt : <%=sendCnt%><br /> -->
</body>
</html>
