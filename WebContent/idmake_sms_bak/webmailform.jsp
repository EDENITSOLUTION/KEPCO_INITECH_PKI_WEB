<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
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
//타임아이디
String tmid = request.getParameter("tmid");

int cnt_user = 0 ; // 사번에 해당하는 사용자 존재 유무(0:없음, 그외 존재)
String userName = null;
String org_mail = null;
String cellQry = null ;
String MAILADDR = null;
String isChk = "Y"; // 인사정보에 연락처가 제대로 등록안되었을 경우 플래그
String cellNotice = null; //인사정보에 연락처가 제대로 등록 안되었을 경우 메세지
int winH = 480;
int winW = 330;

if (empno.equals("") || empno==null || tmid.equals("") || tmid==null ){
	isChk = "N" ;
	//사번이 넘어오지 않으면 창을 닫아버리자
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('SMS인증을 위한 사번정보가 전달되지 않았습니다.');");
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
			cellQry = cellQry + "SELECT X.EMPNO ";
			cellQry = cellQry + "    , X.NAME AS USER_NAME ";
			cellQry = cellQry + "    , X.MAILNO ";
			cellQry = cellQry + "			 ,( ";
			cellQry = cellQry + "    CASE WHEN X.MAILNO IS NULL THEN 'x' ";
			cellQry = cellQry + "    ELSE ";
			cellQry = cellQry + "		CASE INSTR(X.MAILNO,'@',1)  ";
 			cellQry = cellQry + "			WHEN 0 THEN X.MAILNO || '@kepco.co.kr' ";
 			cellQry = cellQry + "       ELSE X.MAILNO ";
 			cellQry = cellQry + "       END ";
			cellQry = cellQry + "     END ";
			cellQry = cellQry + "    ) AS MAILADDR ";
			cellQry = cellQry + " FROM V_INSA X ";
			cellQry = cellQry + " WHERE EMPNO = '"+ empno +"' ";
			
							
			
			rs = stmt.executeQuery(cellQry);
			
			while (rs.next()){
				userName = rs.getString("USER_NAME");
				org_mail = rs.getString("MAILADDR");
				MAILADDR = rs.getString("MAILADDR");
			}
			cnt_user = 1;


			//연락처가 제대로 등록이 안된 경우

			if (MAILADDR.equals("x")  ){
				isChk = "N" ;
				cellNotice = "<br /> -" + userName +"("+ empno +")님의 메일주소가 인사정보에<br />&nbsp;&nbsp;올바르게 등록되지 않았습니다.<br />- 등록된 메일 주소 : <span style='font-weight:bold;color:#ff0000;'>미등록</span> <br />- 아래 메일 인증 받으실 분의 사번을<br />&nbsp;&nbsp;입력하십시오."; 
				org_mail = "메일주소 미등록" ;
				refuserid = "";

			}else{
				isChk = "Y" ;
				org_mail = MAILADDR ;
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
	org_mail = "ex099129@kepco.co.kr" ;
	cnt_user = 1 ;
	userName = empno;
	refuserid = empno;
}
		


if (cnt_user > 0 ) { //사용자 정보가 존재한다면 인증폼보여주자
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>[1]메일 인증하기</title>
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
	window.resizeTo(<%=winW%>,400)
<%
}
%>


function  CheckEmpno(no)
{
	numstr = '0123456789';
	for(var i=0;i<no.value.length;i++) {  
		if(numstr.indexOf(no.value.charAt(i)) == -1) { 
			alert('사번 입력은 숫자만 입력이 가능합니다.'); 
			no.value='';
			no.focus();
			return false;
		}
	}
	return true;
}


function	send()
{
	
	var form = document.data ;
	var lyrId = document.getElementById("tr_refuserid");
<%
if (isChk.equals("N")) { //연락처 포맷이 핸드폰이 아니거나 연락처 등록이 안된 경우
%>
	if (form.refuserid.value.length < 8) {
		alert("메일 인증을 받으실 사원의 사번을 8자리 이상 입력하십시오.");
		form.isOkEmp.value = "N";
		form.hdnRefEmp.value="";
		form.refuserid.focus();
		return ;
	}
	if (form.isOkEmp.value=="N") {
		alert("[사원확인]버튼을 클릭하셔서 메일 인증을 받을 수있는 사원인지 확인하십시오.");
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
		if (form.refuserid.value.length < 8) {
			alert("메일 인증을 받으실 사원의 사번을 8자리 이상 입력하십시오.");	
			form.hdnRefEmp.value="";
			form.isOkEmp.value = "N";	
			form.refuserid.focus();
			return ;
		}		
		if (form.isOkEmp.value=="N") {
			alert("[사원확인]버튼을 클릭하셔서 메일 인증을 받을 수있는 사원인지 확인하십시오.");
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
			alert("메일 인증을 받을 수 있는 사원 확인 후, 사번을 변경하시면 안됩니다.\n다시 한번 메일 인증을 받으실 사원의 사번을 입력하시고\n[사원확인]버튼을 클릭하셔서 메일 인증을 받을 수있는 사원인지 확인하십시오.");
			form.refuserid.value = "" ;
			form.refuserid.focus();
			return ;
		}
	}
	
	//alert(form.isOkEmp.value + " / emp: " + form.empno.value  + " / refuserid : " + form.refuserid.value + " / hdnRefEmp : " + form.hdnRefEmp.value);
	
	form.target = "_self";
	form.action='webmailsend.jsp';
	form.submit();
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
	form.action = "checkUserMail.jsp";
	form.submit();
	
}
function fncChangeMod(){
	location.href="websmsform.jsp?empno=<%=empno%>&tmid=<%=tmid%>";
}
</script>
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#eeeeee;">
	<form name="data" method="post">
	<input type="hidden" name="empno" value="<%=empno%>" />
	<input type="hidden" name="chk" />
	<input type="hidden" name="isOkEmp" value="Y" />
	<input type="hidden" name="hdnRefEmp" value="" />
	<input type="hidden" name="userName" value="<%=userName%>" />
	<input type="hidden" name="strIsInsa" value="<%=strIsInsa%>" />
	<input type="hidden" name="tmid" value="<%=tmid%>" />
	<tr> 
		<td height="30" style="border-top:solid 1px #cecece;"><img src="/idmake_sms/IMAGE/title.gif" width="98" height="21" border="0" /></td>
	</tr>
	<tr> 
		<td valign="top">
			<table width="100%" border="0" cellpadding="0" style="border:solid 1px #d7d5d5;">
				<tr>
					<td style="background-color:#ffffff;padding-left:10px;">
						<table width="98%" border="0" cellpadding="0" cellspacing="0">
							<tr> 
								<td colspan="2" style="padding-top:5px;padding-bottom:5px;"><img src="/idmake_sms/IMAGE/title3.gif" width="200" height="13" border="0" /></td>
							</tr>
							<tr> 
								<td colspan="2" style="padding-right:10px;padding-top:5px;padding-bottom:10px;">
									<span style="cursor:pointer;font-weight:bold;color:#ffffff;background-color:#6633ff;border:solid 1px #666666;padding:2px;" onclick="fncChangeMod();">SMS인증으로 변경</span>
								 </td>
							</tr>	
							<tr> 
								<td>
									<input type="text" name="org_mail"  class="input" style="width:200px;" value="<%=org_mail%>"  <%=exRead%> />
								</td>
								<td style="width:60px; text-align:right; padding-right:10px;">
								<%if (isChk.equals("Y")){%>
									<img src="/idmake_sms/IMAGE/burton_edit.gif" width="50" height="19" border="0" style="cursor:pointer;" onclick="changeUserPhone();" align="absmiddle" />
								<%}else{%>&nbsp;<%}%>
								</td>
							</tr>
							<tr>
								<td height=25 colspan="2"><span style="color:#6600cc;">☞</span><%=userName%>님 인사정보의 메일주소입니다.</td>
							</tr>
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
							
							<tr id="tr_refuserid" style="display:<%if (isChk.equals("Y")) {%>none<%}else{%><%}%>;">
								<td height=25 colspan="2">
									<br />
									<span style="color:#6600cc;font-weight:bold;"><strong>※입력하신 사번에 해당하는 사원의 메일주소로  인증번호가 전송됩니다.</strong></span> 
									<br /><br />
									인증받을 사번 : <input type="text" name="refuserid" value="<%=refuserid%>" size="8" class="input" style="width:100px;"<%if (empno.equals("ex099129") || empno.equals("ex090055") ) {%><%}else{%> onkeyup="CheckEmpno(document.data.refuserid);"<%}%> /> <img src="/idmake_sms/IMAGE/btn_userConfirm.gif" border="0" align="absmiddle" style="cursor:pointer;" onclick="isRightUser();" />
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
