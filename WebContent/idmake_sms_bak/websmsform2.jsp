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

//사번
String empno = request.getParameter("empno");
//타임아이디
String tmid = request.getParameter("tmid");

int cnt_user = 0 ; // 사번에 해당하는 사용자 존재 유무(0:없음, 그외 존재)
String userName = null;
String phone = "010-9911-7557";
String phone1 = null;
String phone2 = null;
String phone3 = null;
String org_phone = null;
String cellQry = null ;
String PHONENUM = null;

int phoneLen = 0 ;

if (empno.equals("") || empno==null || tmid.equals("") || tmid==null ){
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
else {
	if (is_insa) { //인사정보 연동시
		//사번이 넘어오면 인사쪽에서 해당 사번의 전화번호를 가지고 오자
		Context ic = new InitialContext();
		DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/INSA");
		ResultSet rs = null;

		Connection conn = null;
		Statement stmt = null;

		try{
			//사번이 인사정보에 존재하는지 체크
			conn = ds.getConnection();
			//Creat Query and get results
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM IRIS.V_INSA WHERE EMPNO ='"+ empno +"'");
			while (rs.next()){
				cnt_user = rs.getInt("cnt");
			}
			if (cnt_user == 0){
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
				cellQry = cellQry + "	FROM  IRIS.V_INSA ";
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


				//연락처가 제대로 등록이 안된 경우

				if (PHONENUM.equals("x")  ){
					
					
					response.setCharacterEncoding("EUC-KR");
					PrintWriter writer = response.getWriter();
					writer.println("<script type='text/javascript'>");
					writer.println("alert('입력하신 사번("+ empno +")에 대한 핸드폰번호가 \\n인사정보에 올바르게 등록되지 않았습니다.\\n등록된 핸드폰번호 : "+ org_phone +" \\n인사정보에 올바른 핸드폰번호를 등록하셔야 \\nSMS인증을 수행할 수 있습니다.');");
					writer.println("window.close();");
					writer.println("</script>");
					writer.flush();
					return;
				}else{
					org_phone = PHONENUM ;
					phoneLen = org_phone.length(); 
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
		org_phone = phone ;
		cnt_user = 1 ;
		phoneLen = 13;
		userName = empno;
	}
		
} //사번정보가 넘어왔을 때 end

if (cnt_user > 0 ) { //사용자 정보가 존재한다면 인증폼보여주자
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>[1]SMS 인증하기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<style type="text/css">
<!--
a:hover
{
	font-family: "돋움";
	font-size: 9pt;
	line-height: normal;
	color: #064687;
	text-decoration: underline;
}
td
{
	font-family: "돋움";
	font-size: 9pt;
	color: #064687;
}
a 
{ 
	font-family: "돋움";
	font-size: 9pt;
	color: #064687;
	text-decoration: none;
}
select 
{
	font-family: "돋움";
	font-size: 9pt;
	color: #064687;
}
.input
{
	BORDER-RIGHT: B6B6B6 1px solid;
	BORDER-TOP: B6B6B6 1px solid; 
	FONT-SIZE: 9pt; 
	BORDER-LEFT: B6B6B6 1px solid;
	BORDER-BOTTOM: B6B6B6 1px solid;
	border-color:B6B6B6;
	text-align:center;
	color:064687;
	background-color:FAFAFA
}
IMG 
{
	border:0;
}
-->
</style>
<script language=javascript>
function  NumberCheck(no)
{
	numstr = '0123456789-';
	for(var i=0;i<no.value.length;i++) {  
		if(numstr.indexOf(no.value.charAt(i)) == -1) { 
			alert('SMS 인증키 수신자 전화번호는 숫자만 입력이 가능합니다.'); 
			no.value='';
			no.focus();
			return false;
		}
	}
	return true;
}

function	send()
{
	document.data.action='websmssend2.jsp';
	
	if (document.data.phone2.value=="0000")	{
		alert("올바른 전화번호를 입력하십시오");
		document.data.phone2.focus();
		return;
	}
	if (document.data.phone3.value=="0000")	{
		alert("올바른 전화번호를 입력하십시오");
		document.data.phone3.focus();
		return;
	}

	document.data.submit();
}

</script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="235" height="190" border="0" cellpadding="0" cellspacing="0" bgcolor="EEEEEE">
<form name="data" method="post">
<input type="hidden" name="empno" value="<%=empno%>">
<input type="hidden" name="chk">
<input type="hidden" name="org_phone" value="<%=org_phone%>">
<input type="hidden" name="userName" value="<%=userName%>">
<input type="hidden" name="strIsInsa" value="<%=strIsInsa%>">
<input type="hidden" name="tmid" value="<%=tmid%>">
<tr>
	<td width="220" height="1" bgcolor="#CECECE"></td>
</tr>
<tr> 
	<td height="45"><img src="/idmake_sms/IMAGE/title.gif" width="98" height="21"></td>
</tr>
<tr> 
	<td height="144" valign="top">
	<table width="220" height="131" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="D7D5D5">
	<tr>
		<td width="208" height="129" bgcolor="#FFFFFF">
		<table width="220" height="113" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr> 
			<td height="26"><div align="center"><img src="/idmake_sms/IMAGE/title2.gif" width="200" height="13"></div></td>
		</tr>
		<tr> 
			<td>
			<table border=0 align=center cellpadding="0" cellspacing="1">
<%
String cell[] = org_phone.split("-"); 
phone1 =  cell[0] ;
phone2 =  cell[1] ;
phone3 =  cell[2] ;
if (phoneLen==13 || phoneLen == 12) {
	
%>

			<tr>
				<td>
				<input type="text" name="phone1" size="3" class="input" maxlength=3 value="<%=phone1%>" onkeyup='javascript:NumberCheck(document.data.phone1)'>&nbsp;&nbsp;-&nbsp; 
				<input type="text" name="phone2" size="4" class="input" maxlength=4 value="<%=phone2%>" onkeyup='javascript:NumberCheck(document.data.phone2)'>&nbsp;&nbsp;-&nbsp; 
				<input type="text" name="phone3" size="4" class="input" maxlength=4 value="<%=phone3%>" onkeyup='javascript:NumberCheck(document.data.phone3)'>
				</td>
			</tr>
			<tr>
				<td height=25><font color=blue>☞</font> 개인정보의 핸드폰 번호임</td>
			</tr>
<%
}else{
%>
			<tr>
				<td>
				<select name="phone1">
				<option value='010'>010
				<option value='011'>011
				<option value='016'>016
				<option value='017'>017
				<option value='018'>018
				<option value='019'>019
				</select>
				-&nbsp; 
				<input type="text" name="phone2" size=4 class=input maxlength=4 onkeyup='javascript:NumberCheck(document.data.phone2)'>&nbsp;&nbsp;-&nbsp; 
				<input type="text" name="phone3" size=4 class=input maxlength=4  onkeyup='javascript:NumberCheck(document.data.phone3)'>
				</td>
			</tr>
<%
}
%>


			</table>
			</td>
		</tr>
		<tr> 
			<td>
			<table border="0" align="right" cellpadding="0" cellspacing="0">
			<tr>
				<td width="50"><a href='javascript:send()'><img src="/idmake_sms/IMAGE/burton_go.gif" width="50" height="19"></a></td>
				<td width="2"></td>

				<td width="50"><a href='javascript:window.close();'><img src="/idmake_sms/IMAGE/burton_close.gif" width="50" height="19"></a></td>

				<td width="13"></td>
			</tr>
			</table>
			</td>
		</tr>
		</table>
		</td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="1" bgcolor="#CECECE"></td>
</tr>
</form>
</table>
</body>
</html>

<%
}//사용자 정보 존재 ..end
%>