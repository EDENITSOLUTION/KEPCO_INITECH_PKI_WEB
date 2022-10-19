<%-- CertOIDCheck.jsp --%>
<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>


<%@ page import="java.security.*,java.security.cert.*"%>
<%@ page import="com.initech.iniplugin.oid.* "%>
<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init.jsp"%>

<html>
<head>
	<title>INISAFE Web Public PKI OID Result</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>


<% out = m_IP.startEncrypt(out); %>
<%


	X509Certificate cert = null;
	CertOIDUtil cou = null;
	
	//인증이 필요한 페이지 인지 체크
	if (m_IP.isClientAuth() == false) {
      m_IniErrCode = "PPKI_000";
	    m_IniErrMsg  = "Exception : Cert is null"; 

	} else {
		  //사용자 인증서를 얻음.
			cert = m_IP.getClientCertificate();

			// OID check!!

			try{
			
					cou = new CertOIDUtil("C:/WAS/initech/iniplugin/properties/jCERTOID.properties");
			
					if (cou.checkOID(cert) == true) {

						out.println(" <br><br><b>OID 확인에 성공했습니다.!! </b><br>");
						out.println("===================================<br>");
						out.println("OID Result  : [TRUE]<br>");
						out.println("UserCertOID : <b>[" + cou.getCertOID() + "]</b><br>");
						out.println("===================================<br><br>");

					} else {
							
						out.println(" <br><br><b>OID 확인에 실패했습니다.!! </b><br>");	
						out.println("===================================<br>");
						out.println("OID Result  : [FALSE]<br>");
						out.println("UserCertOID : <b>[" + cou.getCertOID() + "]</b><br>");
						out.println("===================================<br><br>");
					}
			
					int iou = 0;
					iou = cou.getCertOU(cou.getCertOID());
						
					out.println(" <b>**인증서 종류 구분** </b><br> ");
				
					if (iou == ConstDef.PERSONAL) {
					   out.println("인증서 구분 : <b>[ 개인 ] </b><br>");
					} else if (iou == ConstDef.CORPORATION) {
						out.println("인증서 구분 : <b>[ 법인 ] </b><br>");
					} else if (iou == ConstDef.ORGAN) {
						out.println("인증서 구분 : <b>[ 기관 ] </b><br>");
					} else {
						out.println(" <b>인증서 종류를 알수 없습니다. </b><br>");
					}

					String issuer = null;
					issuer = cou.getCertIssuer(cou.getCertOID());
					
					out.println(" <br><b>**인증서 발급자 구분**</b><Br> ");
					if (issuer != null) {

						if (issuer.equals(ConstDef.KICA)) {
							out.println("인증서 발급자  : <b>[ 한국정보인증 ]</b><br>");
						} else if (issuer.equals(ConstDef.SIGNKOREA)) {
							out.println("인증서 발급자  : <b>[ 한국증권전산 ]</b><Br>");
						} else if (issuer.equals(ConstDef.YESSIGN)) {
							out.println("인증서 발급자  : <b>[ 금융결제원 ]</b><Br>");
						} else if (issuer.equals(ConstDef.NCA)) {
							out.println("인증서 발급자  : <b>[ 한국전산원 ]</b><br>");
						} else if (issuer.equals(ConstDef.CROSSCERT)) {
							out.println("인증서 발급자  : <b>[ 한국전자인증 ]</b><br>");
						} else if (issuer.equals(ConstDef.TRADESIGN)) {
							out.println("인증서 발급자  : <b>[ 한국무역정보통신 ]</b><br>");
						}

					}		
				}catch (Exception e) {
					    m_IniErrCode = "PPKI_999";
	            m_IniErrMsg  = "Exception : " + e.getMessage();
				}
		 }
		 if(m_IniErrCode != null){
		    out.println("<br><b>INISAFE Public PKI 검증 ERROR</b>");
		    out.println("<hr>");
		    out.println("<br><b>Error Code</b> = <font color='red'>" + m_IniErrCode + "</font>");
		    out.println("<br><b>Error Message</b> = " + m_IniErrMsg);
		    //return;
		
	   }

%>
<% out = m_IP.endEncrypt(out); %>

		</span></font>

		</td>
	</tr>
	
</table>


<br><br>
<center><input type=button value='되돌아가기' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>

</body>
</html>
