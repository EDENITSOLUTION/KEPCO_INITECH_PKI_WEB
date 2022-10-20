<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.util.Calendar.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.*"%>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%!
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
boolean is_insa = true; //SMS인사정보 연동 유무

String strIsInsa = "Y" ;
if (is_insa) {
	strIsInsa = "Y";
}else{
	strIsInsa = "N";
}



String exRead = "readonly='readonly'"; //ex099129사번은 예외
String refuserid = "" ;
//사번
String empno = request.getParameter("empno");
if (empno.equals("ex099129")) { //ex099129는 전화번호 변경 가능하도록하자.
	exRead = "readonly='readonly'"; //"";
	refuserid = "ex09912";
}else{
	exRead = "readonly='readonly'";
}

String refuserid2 = request.getParameter("refuserid2") ;
if (refuserid2 == null) {
	refuserid2 = "";
}

//타임아이디
String tmid = request.getParameter("tmid");

int cnt_user = 0 ; // 사번에 해당하는 사용자 존재 유무(0:없음, 그외 존재)
int pwdCnt = 0;
int certCnt = 0 ;
String userName = null;
String phone = "010-9911-7557";
String phone1 = null;
String phone2 = null;
String phone3 = null;
String org_phone = null;
String cellQry = null ;
String PHONENUM = null;
String isChk = "Y"; // 인사정보에 연락처가 제대로 등록안되었을 경우 플래그
String cellNotice = null; //인사정보에 연락처가 제대로 등록 안되었을 경우 메세지
int winH = 460;
int winW = 330;

int phoneLen = 0 ;

if (empno.equals("") || empno==null || tmid.equals("") || tmid==null ){
	isChk = "N" ;
	//사번이 넘어오지 않으면 창을 닫아버리자
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('PUSH인증을 위한 사번정보가 전달되지 않았습니다.');");
	writer.println("window.close();");
	writer.println("</script>");
	writer.flush();
	return;
}

if (is_insa) { //인사정보 연동시

	//사번이 넘어오면 인사쪽에서 해당 사번의 전화번호를 가지고 오자
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
			writer.println("window.close();");
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
			cellQry = cellQry + "	WHERE EMPNO = '"+ empno +"' ";
			cellQry = cellQry + ") X ";
							
			
			rs = stmt.executeQuery(cellQry);
			
			while (rs.next()){
				userName = rs.getString("USER_NAME");
				org_phone = rs.getString("CELLNO");
				PHONENUM = rs.getString("PHONENUM");
				phoneLen = phone.length();
			}
			cnt_user = 1;
			
			rs = stmt.executeQuery("select count(userid) as cnt from user_pwd where userid='" + empno + "' " );
			while (rs.next()){
				pwdCnt = rs.getInt("cnt");
			}

			rs = stmt.executeQuery("select count(name) as cnt from certs where name='" + empno + "' " );
			while (rs.next()){
				certCnt = rs.getInt("cnt");
			}

			if (pwdCnt < 1) {
				String q = "";
				q += "	INSERT INTO USER_PWD";
				q += "	   (USERID, USERPWD,CRDATE,USERNAME,USERIP) ";
				q += "		VALUES";
				q += "	 ('"+empno+"', '"+getBase64Data(getHashValue(empno + "!@"))+"', SYSDATE, '"+userName+"', '"+request.getRemoteAddr()+"')";
				rs = stmt.executeQuery(q);
			}

			//연락처가 제대로 등록이 안된 경우

			if (PHONENUM.equals("x")  ){
				isChk = "N" ;
				cellNotice = "<br /> -" + userName +"("+ empno +")님의 핸드폰 번호가 인사정보에<br />&nbsp;&nbsp;올바르게 등록되지 않았습니다.<br />- 등록된 핸드폰 번호 : <span style='font-weight:bold;color:#ff0000;'>"+ org_phone +"</span> <br />- 아래 PUSH인증 받으실 분의 사번을<br />&nbsp;&nbsp;입력하십시오."; 
				org_phone = "000-0000-0000" ;
				phoneLen = org_phone.length();
				refuserid = "";

			}else{
				isChk = "Y" ;
				org_phone = PHONENUM ;
				phoneLen = org_phone.length();
				refuserid = empno ;
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
}else{ //인사정보 연동 안할때
	isChk = "Y" ;
	org_phone = phone ;
	cnt_user = 1 ;
	phoneLen = 13;
	userName = empno;
	refuserid = empno;
}
		
if (!"".equals(refuserid2)) {
	refuserid = refuserid2;
}

if (cnt_user > 0 ) { //사용자 정보가 존재한다면 인증폼보여주자
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=11"/>
<title>[1]PUSH 인증하기</title>
<style type="text/css">
<!--
body {
	font-family: "돋움";
	font-size: 9pt;
	color: #064687;
	margin:0px;
}
.input
{
	border: solid 1px #b6b6b6;
	text-align:center;
	color:#064687;
	background-color:#fafafa
}
-->
</style>
<script language=javascript>
<%
if (isChk.equals("N")) {
%>
	window.resizeTo(<%=winW%>,<%=winH%>)
<%
}else{
%>
	window.resizeTo(<%=winW%>,490)
<%
}
%>
function  NumberCheck(no)
{
	numstr = '0123456789';
	for(var i=0;i<no.value.length;i++) {  
		if(numstr.indexOf(no.value.charAt(i)) == -1) { 
			alert('PUSH 인증키 수신자 전화번호는 숫자만 입력이 가능합니다.'); 
			no.value='';
			no.focus();
			return false;
		}
	}
	return true;
}

function  CheckEmpno(no)
{
	numstr = '0123456789';
	/*
	for(var i=0;i<no.value.length;i++) {  
		if(numstr.indexOf(no.value.charAt(i)) == -1) { 
			alert('사번 입력은 숫자만 입력이 가능합니다.'); 
			no.value='';
			no.focus();
			return false;
		}
	}
	*/
	return true;
}

function	send()
{
	
	var form = document.data ;
	var lyrId = document.getElementById("tr_refuserid");
<%
if (isChk.equals("N")) { //연락처 포맷이 핸드폰이 아니거나 연락처 등록이 안된 경우
%>
	if (form.refuserid.value.length !=8) {
		alert("PUSH인증을 받으실 사원의 사번을 입력하시고\n[사원확인]버튼을 클릭하셔서 PUSH인증을 받을 수있는 사원인지 확인하십시오.");
		form.isOkEmp.value = "N";
		form.hdnRefEmp.value="";
		form.refuserid.focus();
		return ;
	}
	if (form.isOkEmp.value=="N") {
		alert("[사원확인]버튼을 클릭하셔서 PUSH인증을 받을 수있는 사원인지 확인하십시오.");
		form.refuserid.focus();
		form.refuserid.value="";
		form.hdnRefEmp.value="";
		return ;
	}
	
<%
}
%>	
<%
if (isChk.equals("Y")) { 
%>
	if (lyrId.style.display=="") { //refuserid레이어가 활성되었다면 반드시 refuserid입력해야함
		if (form.refuserid.value.length !=8) {
			alert("PUSH인증을 받으실 사원의 사번을 입력하시고\n[사원확인]버튼을 클릭하셔서 PUSH인증을 받을 수있는 사원인지 확인하십시오.");		
			form.hdnRefEmp.value="";
			form.isOkEmp.value = "N";	
			form.refuserid.focus();
			return ;
		}		
		if (form.isOkEmp.value=="N") {
			alert("[사원확인]버튼을 클릭하셔서 PUSH인증을 받을 수있는 사원인지 확인하십시오.");
			form.refuserid.value="";	
			form.hdnRefEmp.value="";	
			form.refuserid.focus();	
			return ;
		}
	}else{
		form.refuserid.value=form.empno.value;
		form.hdnRefEmp.value=form.empno.value;
		form.isOkEmp.value = "Y";
		//alert(form.hdnRefEmp.value + " / " + form.refuserid.value + " / " + form.isOkEmp.value );
	}

<%
}
%>	

	
	if ((form.refuserid.value != "") && (form.isOkEmp.value == "Y")) {
		if (form.refuserid.value != form.hdnRefEmp.value){
			alert("PUSH인증을 받을 수 있는 사원 확인 후, 사번을 변경하시면 안됩니다.\n다시 한번 PUSH인증을 받으실 사원의 사번을 입력하시고\n[사원확인]버튼을 클릭하셔서 PUSH인증을 받을 수있는 사원인지 확인하십시오.");
			form.refuserid.value = "" ;
			form.refuserid.focus();
			return ;
		}
	}
	
	//alert(form.isOkEmp.value + " / emp: " + form.empno.value  + " / refuserid : " + form.refuserid.value + " / hdnRefEmp : " + form.hdnRefEmp.value);
	form.target = "_self";
	form.action='apppushsend.jsp';
	
	if(form.refuserid.value == form.empno.value) {
		form.submit();
	} else {
		if(CheckEmpno(document.data.refuserid)) {
			form.submit();
		}
	}
}

function changeUserPhone(){
	var form = document.data;
	var lyrId = document.getElementById("tr_refuserid");
	if (lyrId.style.display=="") {
		lyrId.style.display = "none";
<%
if (isChk.equals("Y")) { //올바른 포맷이고 레이어가 닫힐때
%>
		form.isOkEmp.value= "Y";
		form.refuserid.value = form.empno.value;		
		form.hdnRefEmp.value = form.empno.value;
<%
} else { //올바른 포맷이 아니고 레이어가 닫힐 경우는 없지마..
%>
		form.isOkEmp.value= "N";
		form.refuserid.value = "";		
		form.hdnRefEmp.value = "";
<%
} 
%>
	}else{
		lyrId.style.display = "";
		form.isOkEmp.value= "N";
		form.refuserid.value = "";
		form.hdnRefEmp.value = "";
	}
}

function isRightUser(){
	var form = document.data;
	if (form.refuserid.value.length < 8) {
		form.isOkEmp.value="N";
		alert("8자리 이상의 사번을 입력하십시요.");
		form.refuserid.focus();
		return false;
	}
	if (form.refuserid.value==form.empno.value) {
		form.isOkEmp.value="N";
		alert("인증받을 사번이 자신의 사번과 일치합니다.\n\n다시 한번 확인하십시오.");
		form.refuserid.value="";
		form.refuserid.focus();
		return false;
	}

	form.target = "hdnFrame";
	form.action = "checkUserId2.jsp";
	form.submit();

}
function fncChangeMod(){
	location.href="websmsform.jsp?empno=<%=empno%>&tmid=<%=tmid%>";
}
function fncChangeMod2(){
	location.href="webmailform.jsp?empno=<%=empno%>&tmid=<%=tmid%>";
}

<% if (!"".equals(refuserid2)) { %>
window.onload = function() {
	document.data.isOkEmp.value='Y';
	document.data.hdnRefEmp.value='<%=refuserid2%>';
}
<% } %>
</script>
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#eeeeee;">
	<form name="data" method="post">
	<input type="hidden" name="empno" value="<%=empno%>" />
	<input type="hidden" name="chk" />
	<input type="hidden" name="isOkEmp" value="Y" />
	<input type="hidden" name="hdnRefEmp" value="" />
	<%
	if (empno.equals("ex099129")) {
	%>
	<input type="hidden" name="org_phone" value="<%=org_phone%>" />
	<%
	}
	%>
	<input type="hidden" name="userName" value="<%=userName%>" />
	<input type="hidden" name="strIsInsa" value="<%=strIsInsa%>" />
	<input type="hidden" name="tmid" value="<%=tmid%>" />
	<tr> 
		<td height="30" style="border-top:solid 1px #cecece;"><img src="/idmake_sms/IMAGE/title.gif" width="98" height="21" border="0" /></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0">
				<tr>
					<td style="text-align:center;">
						<img src="/idmake_sms/IMAGE/popup_sms_n.gif" alt="" /><br/>
						<input type="radio" name="chk" onclick="fncChangeMod();" /><br/>휴대전화로 발송
					</td>
					<td style="text-align:center;">
						<img src="/idmake_sms/IMAGE/popup_email_n.gif" alt="" /><br/>
						<input type="radio" name="chk" onclick="fncChangeMod2();" /><br/>이메일로 발송
					</td>
					<td style="text-align:center;">
						<img src="/idmake_sms/IMAGE/popup_push_n.gif" alt="" /><br/>
						<input type="radio" name="chk" checked="checked" /><br/>해외사용자 전용
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
		<td valign="top">
			<table width="100%" border="0" cellpadding="0" style="border:solid 1px #d7d5d5;">
				<tr>
					<td style="background-color:#ffffff;padding-top:10px;padding-left:10px;">
						<table width="98%" border="0" cellpadding="0" cellspacing="0">
							<!--
							<tr> 
								<td colspan="2" style="padding-top:5px;padding-bottom:5px;"><img src="/idmake_sms/IMAGE/title4.gif" width="200" height="13" border="0" /></td>
							</tr>
							<tr> 
								<td colspan="2" style="padding-right:10px;padding-top:5px;padding-bottom:10px;">
									<span style="cursor:pointer;font-weight:bold;color:#ffffff;background-color:#6633ff;border:solid 1px #666666;padding:6px 7px 2px 7px;" onclick="fncChangeMod();">SMS 인증으로 변경</span>
									<span style="cursor:pointer;font-weight:bold;color:#ffffff;background-color:#6633ff;border:solid 1px #666666;padding:6px 7px 2px 7px;" onclick="fncChangeMod2();">이메일 인증으로 변경</span>
								 </td>
							</tr>	
							-->
	<%
	String cell[] = org_phone.split("-"); 
	phone1 =  cell[0] ;
	phone2 =  cell[1] ;
	phone3 =  cell[2] ;
		
	//if (empno.equals("ex099129")) {
	//}else{
		phone2 = "****";
	//}
	%>
							
							
							
							<tr> 
								<td>
									<input type="text" name="phone1" size="3" class="input" maxlength="3" value="<%=phone1%>" onkeyup='javascript:NumberCheck(document.data.phone1)' <%=exRead%> />&nbsp;-&nbsp; 
									<input type="text" name="phone2" size="4" class="input" maxlength="4" value="<%=phone2%>" onkeyup='javascript:NumberCheck(document.data.phone2)' <%=exRead%> />&nbsp;-&nbsp; 
									<input type="text" name="phone3" size="4" class="input" maxlength="4" value="<%=phone3%>" onkeyup='javascript:NumberCheck(document.data.phone3)' <%=exRead%> />
								</td>
								<td style="width:60px; text-align:right; padding-right:10px;">
								<%if (isChk.equals("Y")){%>
									<img src="/idmake_sms/IMAGE/burton_edit.gif" width="50" height="19" border="0" style="cursor:pointer;" onclick="changeUserPhone();" align="absmiddle" />
								<%}else{%>&nbsp;<%}%>
								</td>
							</tr>
							<tr>
								<td height=25 colspan="2"><span style="color:#6600cc;">☞</span><%=userName%>님 인사정보의 핸드폰 번호입니다.</td>
							</tr>
							<!--
							<tr>
								<td height=25 colspan="2"><span style="color:red; font-weight:bold;">☞PUSH인증이용은 해외사용자에 해당합니다.</span></td>
							</tr>
							-->
							<%
							if (isChk.equals("N")) {
							%>
							<tr>
								<td colspan="2">
								<%=cellNotice%>
								</td>
							</tr>
							<%
							}
							%>
							<tr id="tr_refuserid" style="display:<%if (isChk.equals("Y") && "".equals(refuserid2)) {%>none<%}else{%><%}%>;">
								<td height=25 colspan="2">
									<br />
									<span style="color:#6600cc;font-weight:bold;"><strong>※ 입력하신 사번에 해당하는 사원의 핸드폰 번호로 PUSH 인증번호가 전송됩니다.</strong></span> 
									<br />
									<%
										if ( pwdCnt < 1 || certCnt < 1   ) {
									%>
									<span>※ 최초 인증서를 받을경우 이전 비밀번호는 <br/><strong style="color:red;">'사번!@'</strong> 입니다. </span><br/>
									<%
										}	
									%>
									<span style="display:inline-block; width:114px; font-size:8pt; padding-bottom:2px;"><%=userName%>님의 비밀번호 :</span><input type="password" name="orguserpw" value="" class="input" style="width:93px; margin-top:5px;" />
									
									<span style="display:inline-block; width:110px; font-size:8pt; padding-bottom:2px; margin-top:10px;">대리자 사번 :</span> <input type="text" name="refuserid" value="<%=refuserid%>" size="8" class="input" style="width:93px; margin-top:10px;"  <%if (empno.equals("ex099129")) {%><%}else{%> onkeyup="CheckEmpno(document.data.refuserid);"<%}%> /> 
									<img src="/idmake_sms/IMAGE/btn_userConfirm1.gif" border="0" align="absmiddle" style="cursor:pointer; margin-left:4px; vertical-align:bottom; margin-bottom:1px;" onclick="isRightUser();" />
									
								</td>
							</tr>
							<tr> 
								<td colspan="2" style="text-align:center;height:20px; border-bottom:dotted 1px #666666;">&nbsp;</td>
							</tr>
							<tr> 
								<td colspan="2" style="text-align:center; padding:4px;">
									<a href='javascript:send()'><img src="/idmake_sms/IMAGE/burton_go.gif" width="50" height="19" border="0" /></a>
									&nbsp;
									<a href='javascript:window.close();'><img src="/idmake_sms/IMAGE/burton_close.gif" width="50" height="19" border="0" /></a>
								</td>
							</tr>
							<tr> 
								<td colspan="2" style="text-align:center;height:20px; border-top:dotted 1px #666666;">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<!-- <tr>
		<td height="1" bgcolor="#CECECE"></td>
	</tr> -->
	</form>
</table>
<iframe name="hdnFrame" id="hdnFrame" src="blank.html" width="110" height="110" style="display:none" scrolling="no" frameborder="0"></iframe>
</body>
</html>

<%
}//사용자 정보 존재 ..end
%>