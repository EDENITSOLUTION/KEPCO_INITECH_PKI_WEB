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
String org_mail = null;
String cellQry = null ;
String MAILADDR = null;
String isChk = "Y"; // �λ������� ����ó�� ����� ��ϾȵǾ��� ��� �÷���
String cellNotice = null; //�λ������� ����ó�� ����� ��� �ȵǾ��� ��� �޼���
int winH = 480;
int winW = 330;

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


			//����ó�� ����� ����� �ȵ� ���

			if (MAILADDR.equals("x")  ){
				isChk = "N" ;
				cellNotice = "<br /> -" + userName +"("+ empno +")���� �����ּҰ� �λ�������<br />&nbsp;&nbsp;�ùٸ��� ��ϵ��� �ʾҽ��ϴ�.<br />- ��ϵ� ���� �ּ� : <span style='font-weight:bold;color:#ff0000;'>�̵��</span> <br />- �Ʒ� ���� ���� ������ ���� �����<br />&nbsp;&nbsp;�Է��Ͻʽÿ�."; 
				org_mail = "�����ּ� �̵��" ;
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
}else{ //�λ����� ���� ���Ҷ�
	isChk = "Y" ;
	org_mail = "ex099129@kepco.co.kr" ;
	cnt_user = 1 ;
	userName = empno;
	refuserid = empno;
}
		


if (cnt_user > 0 ) { //����� ������ �����Ѵٸ� ��������������
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>[1]���� �����ϱ�</title>
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
	if (form.refuserid.value.length < 8) {
		alert("���� ������ ������ ����� ����� 8�ڸ� �̻� �Է��Ͻʽÿ�.");
		form.isOkEmp.value = "N";
		form.hdnRefEmp.value="";
		form.refuserid.focus();
		return ;
	}
	if (form.isOkEmp.value=="N") {
		alert("[���Ȯ��]��ư�� Ŭ���ϼż� ���� ������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");
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
		if (form.refuserid.value.length < 8) {
			alert("���� ������ ������ ����� ����� 8�ڸ� �̻� �Է��Ͻʽÿ�.");	
			form.hdnRefEmp.value="";
			form.isOkEmp.value = "N";	
			form.refuserid.focus();
			return ;
		}		
		if (form.isOkEmp.value=="N") {
			alert("[���Ȯ��]��ư�� Ŭ���ϼż� ���� ������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");
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
			alert("���� ������ ���� �� �ִ� ��� Ȯ�� ��, ����� �����Ͻø� �ȵ˴ϴ�.\n�ٽ� �ѹ� ���� ������ ������ ����� ����� �Է��Ͻð�\n[���Ȯ��]��ư�� Ŭ���ϼż� ���� ������ ���� ���ִ� ������� Ȯ���Ͻʽÿ�.");
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
									<span style="cursor:pointer;font-weight:bold;color:#ffffff;background-color:#6633ff;border:solid 1px #666666;padding:2px;" onclick="fncChangeMod();">SMS�������� ����</span>
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
								<td height=25 colspan="2"><span style="color:#6600cc;">��</span><%=userName%>�� �λ������� �����ּ��Դϴ�.</td>
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
									<span style="color:#6600cc;font-weight:bold;"><strong>���Է��Ͻ� ����� �ش��ϴ� ����� �����ּҷ�  ������ȣ�� ���۵˴ϴ�.</strong></span> 
									<br /><br />
									�������� ��� : <input type="text" name="refuserid" value="<%=refuserid%>" size="8" class="input" style="width:100px;"<%if (empno.equals("ex099129") || empno.equals("ex090055") ) {%><%}else{%> onkeyup="CheckEmpno(document.data.refuserid);"<%}%> /> <img src="/idmake_sms/IMAGE/btn_userConfirm.gif" border="0" align="absmiddle" style="cursor:pointer;" onclick="isRightUser();" />
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