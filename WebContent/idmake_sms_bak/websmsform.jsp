<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import='java.sql.*, javax.sql.*, javax.naming.*' %>
<%
boolean is_insa = true; //SMS�λ����� ���� ����

String strIsInsa = "Y" ;
if (is_insa) {
	strIsInsa = "Y";
}else{
	strIsInsa = "N";
}



String exRead = "readonly='readonly'"; //ex099129����� ����
String refuserid = "" ;
//���
String empno = request.getParameter("empno");
if (empno.equals("ex099129")) { //ex099129�� ��ȭ��ȣ ���� �����ϵ�������.
	exRead = "readonly='readonly'"; //"";
	refuserid = "ex09912";
}else{
	exRead = "readonly='readonly'";
}
//Ÿ�Ӿ��̵�
String tmid = request.getParameter("tmid");

int cnt_user = 0 ; // ����� �ش��ϴ� ����� ���� ����(0:����, �׿� ����)
String userName = null;
String phone = "010-9911-7557";
String phone1 = null;
String phone2 = null;
String phone3 = null;
String org_phone = null;
String cellQry = null ;
String PHONENUM = null;
String isChk = "Y"; // �λ������� ����ó�� ����� ��ϾȵǾ��� ��� �÷���
String cellNotice = null; //�λ������� ����ó�� ����� ��� �ȵǾ��� ��� �޼���
int winH = 460;
int winW = 330;

int phoneLen = 0 ;

if (empno.equals("") || empno==null || tmid.equals("") || tmid==null ){
	isChk = "N" ;
	//����� �Ѿ���� ������ â�� �ݾƹ�����
	response.setCharacterEncoding("EUC-KR");
	PrintWriter writer = response.getWriter();
	writer.println("<script type='text/javascript'>");
	writer.println("alert('SMS������ ���� ��������� ���޵��� �ʾҽ��ϴ�.');");
	writer.println("window.close();");
	writer.println("</script>");
	writer.flush();
	return;
}

if (is_insa) { //�λ����� ������

	//����� �Ѿ���� �λ��ʿ��� �ش� ����� ��ȭ��ȣ�� ������ ����
	Context ic = new InitialContext();
	DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/USERS");
	ResultSet rs = null;

	Connection conn = null;
	Statement stmt = null;

	try{
		//����� �λ������� �����ϴ��� üũ
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
			writer.println("alert('�Է��Ͻ� ���("+ empno +")�� ���� ������ �λ��������� �������� �ʽ��ϴ�.');");
			writer.println("window.close();");
			writer.println("</script>");
			writer.flush();
			return;
		}else{ // ����� ���� �����Ҷ�				
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


			//����ó�� ����� ����� �ȵ� ���

			if (PHONENUM.equals("x")  ){
				isChk = "N" ;
				cellNotice = "<br /> -" + userName +"("+ empno +")���� �ڵ��� ��ȣ�� �λ�������<br />&nbsp;&nbsp;�ùٸ��� ��ϵ��� �ʾҽ��ϴ�.<br />- ��ϵ� �ڵ��� ��ȣ : <span style='font-weight:bold;color:#ff0000;'>"+ org_phone +"</span> <br />- �Ʒ� SMS���� ������ ���� �����<br />&nbsp;&nbsp;�Է��Ͻʽÿ�."; 
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
}else{ //�λ����� ���� ���Ҷ�
	isChk = "Y" ;
	org_phone = phone ;
	cnt_user = 1 ;
	phoneLen = 13;
	userName = empno;
	refuserid = empno;
}
		


if (cnt_user > 0 ) { //����� ������ �����Ѵٸ� ��������������
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>[1]SMS �����ϱ�</title>
<style type="text/css">
<!--
body {
	font-family: "����";
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
	window.resizeTo(<%=winW%>,400)
<%
}
%>
function  NumberCheck(no)
{
	numstr = '0123456789';
	for(var i=0;i<no.value.length;i++) {  
		if(numstr.indexOf(no.value.charAt(i)) == -1) { 
			alert('SMS ����Ű ������ ��ȭ��ȣ�� ���ڸ� �Է��� �����մϴ�.'); 
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
	for(var i=0;i<no.value.length;i++) {  
		if(numstr.indexOf(no.value.charAt(i)) == -1) { 
			alert('��� �Է��� ���ڸ� �Է��� �����մϴ�.'); 
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
if (isChk.equals("N")) { //����ó ������ �ڵ����� �ƴϰų� ����ó ����� �ȵ� ���
%>
	if (form.refuserid.value.length !=8) {
		alert("SMS������ ������ ����� ����� �Է��Ͻð�\n[���Ȯ��]��ư�� Ŭ���ϼż� SMS������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");
		form.isOkEmp.value = "N";
		form.hdnRefEmp.value="";
		form.refuserid.focus();
		return ;
	}
	if (form.isOkEmp.value=="N") {
		alert("[���Ȯ��]��ư�� Ŭ���ϼż� SMS������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");
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
	if (lyrId.style.display=="") { //refuserid���̾ Ȱ���Ǿ��ٸ� �ݵ�� refuserid�Է��ؾ���
		if (form.refuserid.value.length !=8) {
			alert("SMS������ ������ ����� ����� �Է��Ͻð�\n[���Ȯ��]��ư�� Ŭ���ϼż� SMS������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");		
			form.hdnRefEmp.value="";
			form.isOkEmp.value = "N";	
			form.refuserid.focus();
			return ;
		}		
		if (form.isOkEmp.value=="N") {
			alert("[���Ȯ��]��ư�� Ŭ���ϼż� SMS������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");
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
			alert("SMS������ ���� �� �ִ� ��� Ȯ�� ��, ����� �����Ͻø� �ȵ˴ϴ�.\n�ٽ� �ѹ� SMS������ ������ ����� ����� �Է��Ͻð�\n[���Ȯ��]��ư�� Ŭ���ϼż� SMS������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");
			form.refuserid.value = "" ;
			form.refuserid.focus();
			return ;
		}
	}
	
	//alert(form.isOkEmp.value + " / emp: " + form.empno.value  + " / refuserid : " + form.refuserid.value + " / hdnRefEmp : " + form.hdnRefEmp.value);
	form.target = "_self";
	form.action='websmssend.jsp';
	
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
if (isChk.equals("Y")) { //�ùٸ� �����̰� ���̾ ������
%>
		form.isOkEmp.value= "Y";
		form.refuserid.value = form.empno.value;		
		form.hdnRefEmp.value = form.empno.value;
<%
} else { //�ùٸ� ������ �ƴϰ� ���̾ ���� ���� ������..
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
		alert("8�ڸ� �̻��� ����� �Է��Ͻʽÿ�.");
		form.refuserid.focus();
		return false;
	}
	if (form.refuserid.value==form.empno.value) {
		form.isOkEmp.value="N";
		alert("�������� ����� �ڽ��� ����� ��ġ�մϴ�.\n\n�ٽ� �ѹ� Ȯ���Ͻʽÿ�.");
		form.refuserid.value="";
		form.refuserid.focus();
		return false;
	}

	form.target = "hdnFrame";
	form.action = "checkUserId.jsp";
	form.submit();

}
function fncChangeMod(){
	location.href="webmailform.jsp?empno=<%=empno%>&tmid=<%=tmid%>";
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
		<td valign="top">
			<table width="100%" border="0" cellpadding="0" style="border:solid 1px #d7d5d5;">
				<tr>
					<td style="background-color:#ffffff;padding-left:10px;">
						<table width="98%" border="0" cellpadding="0" cellspacing="0">
							<tr> 
								<td colspan="2" style="padding-top:5px;padding-bottom:5px;"><img src="/idmake_sms/IMAGE/title2.gif" width="200" height="13" border="0" /></td>
							</tr>
							<tr> 
								<td colspan="2" style="padding-right:10px;padding-top:5px;padding-bottom:10px;">
									<span style="cursor:pointer;font-weight:bold;color:#ffffff;background-color:#6633ff;border:solid 1px #666666;padding:2px;" onclick="fncChangeMod();">�̸��� �������� ����</span>
								 </td>
							</tr>	
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
								<td height=25 colspan="2"><span style="color:#6600cc;">��</span><%=userName%>�� �λ������� �ڵ��� ��ȣ�Դϴ�.</td>
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
									<span style="color:#6600cc;font-weight:bold;"><strong>���Է��Ͻ� ����� �ش��ϴ� ����� �ڵ��� ��ȣ�� SMS ������ȣ�� ���۵˴ϴ�.</strong></span> 
									<br /><br />
									�������� ��� : <input type="text" name="refuserid" value="<%=refuserid%>" size="8" class="input" style="width:100px;"  <%if (empno.equals("ex099129")) {%><%}else{%> onkeyup="CheckEmpno(document.data.refuserid);"<%}%> /> <img src="/idmake_sms/IMAGE/btn_userConfirm.gif" border="0" align="absmiddle" style="cursor:pointer;" onclick="isRightUser();" />
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
}//����� ���� ���� ..end
%>