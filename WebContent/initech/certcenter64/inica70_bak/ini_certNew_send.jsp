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
//������ �߱��� ���������� �̷�����ٸ� 
//RA�� USER_PWD ���̺� ������� ��й�ȣ�� �Է� �Ǵ� ������Ʈ ������!

Context icu = new InitialContext();
DataSource dsu = (DataSource) icu.lookup("java:comp/env/jdbc/INICA");
ResultSet rsu = null;

Connection connu = null;
Statement stmtu = null;
PreparedStatement pstmtu = null;


String isPwd = "Y" ; //��й�ȣ ��� ����
int rsPwdCnt = 0 ;
String insertSQL = null;

String seq = m_tmid + "_" + m_ID + "_" + request.getRemoteAddr();


// ������ �߱� �� SMS�߼� 
// ������ �߱� �� SMS�߼� 
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
	//����ھ��̵�� ī��Ʈ�Ͽ� 0���� ũ�� update 0�̸� insert
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

	//SMS���� ���� ����
	//pstmtu = connu.prepareStatement(delQry);
	//pstmtu.executeUpdate();

	//[STR] VPN ���踦 ���� ������ �߱� ���̵����� ���� 2017-04-11
	// �������� ����
	pstmtu = connu.prepareStatement("DELETE FROM sync_pwd_vpn WHERE userid = '" + m_ID + "'");
	pstmtu.executeUpdate();

	// �ֽ����� ���
	pstmtu = connu.prepareStatement("INSERT INTO sync_pwd_vpn (userid, cdate) VALUES('" + m_ID + "', SYSDATE)");
	pstmtu.executeUpdate();
	//[END] VPN ���踦 ���� ������ �߱� ���̵����� ���� 2017-04-11

} catch(Exception e) {
	e.printStackTrace();
} finally {
	rsu.close();
	connu.close();
}
%>

<%

//[STR] VPN ����� ��й�ȣ ������ ���� REAL �� BATCH 2017-04-20 -> �ּ����� 2018-09-12
	// VPN ����� �н����� ������Ʈ ����
     URL url;//URL �ּ� ��ü
        URLConnection connection;//URL������ ������ ��ü
        InputStream is;//URL���ӿ��� ������ �б����� Stream
        InputStreamReader isr;
        BufferedReader br;

        try{
            //URL��ü�� �����ϰ� �ش� URL�� �����Ѵ�..
            url = new URL("http://10.180.6.97:8080/SSL/EMPLOYEE2/epi_relay.php?id="+m_ID+"&pw="+getBase64Data(getHashValue(m_pw)));
            connection = url.openConnection();

            //������ �о�������� InputStream��ü�� �����Ѵ�..
            is = connection.getInputStream();
            isr = new InputStreamReader(is);
            br = new BufferedReader(isr);

            //������ �о ȭ�鿡 ����Ѵ�..
            String buf = null;
            while(true){
                buf = br.readLine();
                if(buf == null) break;
                System.out.println(buf);
            }
        }catch(MalformedURLException mue){
            System.err.println("�߸��� URL�Դϴ�. ���� : java URLConn http://hostname/path]");
            System.exit(1);
        }catch(IOException ioe){
            System.err.println("IOException " + ioe);
            ioe.printStackTrace();
            System.exit(1);
        }
//[END] VPN ����� ��й�ȣ ������ ���� REAL �� BATCH 2017-04-20

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>�������� �̿�ȳ�</title>
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
		<li class="toptxtcon">�������� �̿��ϱ�</li>
		<li class="toptxtcon01" style="text-decoration:underline;">������ �߱�</li>
		<li class="toptxtcon01">������ ���</li>
		<li class="toptxtcon01">������ ����</li>
	</ul>
</div>

<div id="subissue">
	<ul>
		<li><img src="img/subtitle0101.gif" alt="�������߱�_�������� �߱��ص帳�ϴ�."></li>
		<li class="stitle"><img src="img/subtitle0203.gif" alt="�������߱�_�Ϸ�"></li>
		<li class="box">
			<ul>
				<li class="sbtextbg2">
					<img src="img/bullet_list.gif" align="center"> <b class="txblue"><%=certUserNm%>(<%=m_ID%>)</b> ���� �������� ���������� �߱޵Ǿ����ϴ�.</li>
				<li class="sbtextbg2">
					<img src="img/bullet_list.gif" align="center"> �������� ��ȿ�Ⱓ�� 3�����̸�, ��ȿ�Ⱓ�� ���� �������� ����Ͻ� �� �����ϴ�.</li>
				<li class="sbtextbg2">
					<img src="img/bullet_list.gif" align="center"> PowerNet �α����� ���ؼ� PowerNet ToolBand�� ���������� Ŭ���Ͻʽÿ�. �̿����ּż� �����մϴ�</li>
				<li class="dotted1"></li>

				<li class="sbtextbg"> 
					- ������ �н�(������ ��й�ȣ�� �ؾ���� ���, �̿��ϴ� ��ǻ�Ͱ� ���� �� ���, �������� ������ ��� ��)�� �������� ����� ��, �߱޹����ø� ��� �����մϴ�. </li>
				
				<li style="text-align:center;"><a href="/initech/certcenter64/inica70/index.jsp"><img src="img/btn_cen_fir.gif" alt="�������ʱ�ȭ��"></a></li>
				
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

