<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*, java.io.*, java.util.*, java.text.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import='java.net.*, java.io.*' %>

<%@ include file="import/iniplugin_init.jsp" %>
<% m_How = "certNew"; %>
<%@ include file="import/inica70_init.jsp" %>
<%@ include file="import/inica70_userSet.jsp" %>
<%@ include file="import/inica70_ca_send.jsp" %>
<%@ include file="import/inica70_err_check.jsp" %>
<%@ include file="import/fncSMS.jsp" %>
<%
//인증서 발급이 정상적으로 이루어졌다면 
//RA쪽 USER_PWD 테이블에 사용자의 비밀번호를 입력 또는 업데이트 해주자!

Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
ResultSet rsu = null;

Connection connu = null;
Statement stmtu = null;
PreparedStatement pstmtu = null;


String isPwd = "Y" ; //비밀번호 등록 유무
int rsPwdCnt = 0 ;
String insertSQL = null;

String seq = m_tmid + "_" + m_ID + "_" + request.getRemoteAddr();


// 인증서 발급 후 SMS발송 
// 인증서 발급 후 SMS발송 
String smsFlag = "N";
smsFlag = sendSMS(m_How, m_ID, m_tmid);


String delQry = "";
		delQry = "delete from sms_log " ;
		delQry = delQry + "	where userid='"+ m_ID +"' " ;
		delQry = delQry + "		and userip = '"+ request.getRemoteAddr() +"' " ;
		delQry = delQry + "		and seq = '"+ seq +"' " ;
		delQry = delQry + "		and smsnum = '"+ m_sms +"' " ;

try {
	connu = dsu.getConnection();
	//Creat Query and get results
	stmtu = connu.createStatement();

	rsu = stmtu.executeQuery("select count(userid) as cnt from user_pwd where userid='" + m_ID + "' ");
	//사용자아이디로 카운트하여 0보다 크면 update 0이면 insert
	while( rsu.next() ) {
		rsPwdCnt = rsu.getInt("cnt");
	}
	
	if (rsPwdCnt == 0){
		//Inset
		insertSQL = "INSERT INTO USER_PWD (USERID, USERPWD,USERNAME, USERIP) VALUES ( '" + m_ID + "', '" + getBase64Data(getHashValue(m_pw)) + "' , '" + certUserNm + "', '" + request.getRemoteAddr() + "')";
		pstmtu = connu.prepareStatement(insertSQL);
		pstmtu.executeUpdate();


	}else{
		//update
		insertSQL = "UPDATE USER_PWD set USERPWD = '" + getBase64Data(getHashValue(m_pw)) + "' , USERNAME= '" + certUserNm + "', MDDATE=SYSDATE, USERIP = '"+ request.getRemoteAddr() +"' WHERE USERID = '" + m_ID + "'";
		pstmtu = connu.prepareStatement(insertSQL);
		pstmtu.executeUpdate();
	}

	//SMS인증 정보 삭제
	//pstmtu = connu.prepareStatement(delQry);
	//pstmtu.executeUpdate();

	//[STR] VPN 연계를 위한 인증서 발급 아이디정보 저장 2017-04-11
	// 기존정보 삭제
	pstmtu = connu.prepareStatement("DELETE FROM sync_pwd_vpn WHERE userid = '" + m_ID + "'");
	pstmtu.executeUpdate();

	// 최신정보 등록
	pstmtu = connu.prepareStatement("INSERT INTO sync_pwd_vpn (userid, cdate) VALUES('" + m_ID + "', SYSDATE)");
	pstmtu.executeUpdate();
	//[END] VPN 연계를 위한 인증서 발급 아이디정보 저장 2017-04-11

} catch(Exception e) {
	e.printStackTrace();
} finally {
	rsu.close();
	connu.close();
}
%>

<%

//[STR] VPN 사용자 비밀번호 연계방식 변경 REAL → BATCH 2017-04-20 -> 주석해제 2018-09-12
	// VPN 사용자 패스워드 업데이트 내용
     URL url;//URL 주소 객체
        URLConnection connection;//URL접속을 가지는 객체
        InputStream is;//URL접속에서 내용을 읽기위한 Stream
        InputStreamReader isr;
        BufferedReader br;

        try{
            //URL객체를 생성하고 해당 URL로 접속한다..
            url = new URL("http://10.180.6.97:8080/SSL/EMPLOYEE2/epi_relay.php?id="+m_ID+"&pw="+getBase64Data(getHashValue(m_pw)));
            connection = url.openConnection();

            //내용을 읽어오기위한 InputStream객체를 생성한다..
            is = connection.getInputStream();
            isr = new InputStreamReader(is);
            br = new BufferedReader(isr);

            //내용을 읽어서 화면에 출력한다..
            String buf = null;
            while(true){
                buf = br.readLine();
                if(buf == null) break;
                System.out.println(buf);
            }
        }catch(MalformedURLException mue){
            System.err.println("잘못되 URL입니다. 사용법 : java URLConn http://hostname/path]");
            System.exit(1);
        }catch(IOException ioe){
            System.err.println("IOException " + ioe);
            ioe.printStackTrace();
            System.exit(1);
        }
//[END] VPN 사용자 비밀번호 연계방식 변경 REAL → BATCH 2017-04-20

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>인증센터 이용안내</title>
<link rel="stylesheet" type="text/css" href="css/import.css" />
<link rel="stylesheet" type="text/css" href="css/main.css" />

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery.flexslider-min.js"></script>
<script type="text/javascript" src="js/jquery.als-1.1.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>

<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
<script language="javascript">
	var UserCert;
	<%=m_caCertString%>
</script>
<script language="javascript">
function setTimerMain() {
	setTimeout("location.href='/initech/certcenter64/inica70/index.jsp'",5000);
}
</script>

<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="css/ie6.css">
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="css/ie7.css">
<![endif]-->
</head> 

<body onload="InsertUserCert(UserCert);document.hdnForm.target='hdnFrame';document.hdnForm.submit(); setTimerMain();">
<% try { if (m_bEncrypt) out = m_IP.startEncrypt(out); } catch(Exception e) {} %>
<iframe name="hdnFrame" id="hdnFrame" src="_balnk" width="110" height="110" style="display:none" scrolling="no" frameborder="0"></iframe>
<form name="hdnForm" id="hdnForm" method="get" action="<%=pwdSynURL%>">
<input type="hidden" name="key" id="key" value="<%=pwdSyncKey%>" />
<input type="hidden" name="didx" id="didx" value="<%=pwdSyncDidx%>" />
<input type="hidden" name="usb" id="usb" value="<%=m_ID%>" />
<input type="hidden" name="pwd" id="pwd" value="<%=getBase64Data(getHashValue(m_pw))%>" />
</form>
<div id="header"> 
	<!-- MAIN MENU START <%=m_tmid%>-->
	<script language="javascript">dspMainMenu();</script>
	<!-- MAIN MENU END -->
</div>

<div style="height:10px;"></div>
<div id="subtop">
	<ul class="subtoptxt">
		<li class="toptxtcon">인증센터 이용하기</li>
		<li class="toptxtcon01" style="text-decoration:underline;">인증서 발급</li>
		<li class="toptxtcon01">인증서 폐기</li>
		<li class="toptxtcon01">인증서 관리</li>
	</ul>
</div>

<div id="subissue">
	<ul>
		<li><img src="img/subtitle0101.gif" alt="인증서발급_인증서를 발급해드립니다."></li>
		<li class="stitle"><img src="img/subtitle0203.gif" alt="인증서발급_완료"></li>
		<li class="box">
			<ul>
				<li class="sbtextbg2">
					<img src="img/bullet_list.gif" align="center"> <b class="txblue"><%=certUserNm%>(<%=m_ID%>)</b> 님의 인증서가 성공적으로 발급되었습니다.</li>
				<li class="sbtextbg2">
					<img src="img/bullet_list.gif" align="center"> 인증서의 유효기간은 3개월이며, 유효기간이 지난 인증서는 사용하실 수 없습니다.</li>
				<li class="sbtextbg2">
					<img src="img/bullet_list.gif" align="center"> PowerNet 로그인을 위해서 PowerNet ToolBand의 통합인증을 클릭하십시오. 이용해주셔서 감사합니다</li>
				<li class="dotted1"></li>

				<li class="sbtextbg"> 
					- 인증서 분실(인증서 비밀번호를 잊어버린 경우, 이용하는 컴퓨터가 변경 된 경우, 인증서가 삭제된 경우 등)시 인증서를 폐기한 후, 발급받으시면 사용 가능합니다. </li>
				
				<li style="text-align:center;"><a href="/initech/certcenter64/inica70/index.jsp"><img src="img/btn_cen_fir.gif" alt="인증서초기화면"></a></li>
				
			</ul>
		</li>
		
	</ul>
	<div style="height:90px;"></div>
</div>

<!-- COPYRIGHT START -->
<script language="javascript">dspCopyRight();</script>
<!-- COPYRIGHT END -->


<% try { if (m_bEncrypt) out = m_IP.endEncrypt(out); } catch(Exception e) {} %>

</body>
</html>

