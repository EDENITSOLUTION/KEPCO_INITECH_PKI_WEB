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
	
	//������ �ʿ��� ������ ���� üũ
	if (m_IP.isClientAuth() == false) {
      m_IniErrCode = "PPKI_000";
	    m_IniErrMsg  = "Exception : Cert is null"; 

	} else {
		  //����� �������� ����.
			cert = m_IP.getClientCertificate();

			// OID check!!

			try{
			
					cou = new CertOIDUtil("C:/WAS/initech/iniplugin/properties/jCERTOID.properties");
			
					if (cou.checkOID(cert) == true) {

						out.println(" <br><br><b>OID Ȯ�ο� �����߽��ϴ�.!! </b><br>");
						out.println("===================================<br>");
						out.println("OID Result  : [TRUE]<br>");
						out.println("UserCertOID : <b>[" + cou.getCertOID() + "]</b><br>");
						out.println("===================================<br><br>");

					} else {
							
						out.println(" <br><br><b>OID Ȯ�ο� �����߽��ϴ�.!! </b><br>");	
						out.println("===================================<br>");
						out.println("OID Result  : [FALSE]<br>");
						out.println("UserCertOID : <b>[" + cou.getCertOID() + "]</b><br>");
						out.println("===================================<br><br>");
					}
			
					int iou = 0;
					iou = cou.getCertOU(cou.getCertOID());
						
					out.println(" <b>**������ ���� ����** </b><br> ");
				
					if (iou == ConstDef.PERSONAL) {
					   out.println("������ ���� : <b>[ ���� ] </b><br>");
					} else if (iou == ConstDef.CORPORATION) {
						out.println("������ ���� : <b>[ ���� ] </b><br>");
					} else if (iou == ConstDef.ORGAN) {
						out.println("������ ���� : <b>[ ��� ] </b><br>");
					} else {
						out.println(" <b>������ ������ �˼� �����ϴ�. </b><br>");
					}

					String issuer = null;
					issuer = cou.getCertIssuer(cou.getCertOID());
					
					out.println(" <br><b>**������ �߱��� ����**</b><Br> ");
					if (issuer != null) {

						if (issuer.equals(ConstDef.KICA)) {
							out.println("������ �߱���  : <b>[ �ѱ��������� ]</b><br>");
						} else if (issuer.equals(ConstDef.SIGNKOREA)) {
							out.println("������ �߱���  : <b>[ �ѱ��������� ]</b><Br>");
						} else if (issuer.equals(ConstDef.YESSIGN)) {
							out.println("������ �߱���  : <b>[ ���������� ]</b><Br>");
						} else if (issuer.equals(ConstDef.NCA)) {
							out.println("������ �߱���  : <b>[ �ѱ������ ]</b><br>");
						} else if (issuer.equals(ConstDef.CROSSCERT)) {
							out.println("������ �߱���  : <b>[ �ѱ��������� ]</b><br>");
						} else if (issuer.equals(ConstDef.TRADESIGN)) {
							out.println("������ �߱���  : <b>[ �ѱ������������ ]</b><br>");
						}

					}		
				}catch (Exception e) {
					    m_IniErrCode = "PPKI_999";
	            m_IniErrMsg  = "Exception : " + e.getMessage();
				}
		 }
		 if(m_IniErrCode != null){
		    out.println("<br><b>INISAFE Public PKI ���� ERROR</b>");
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
<center><input type=button value='�ǵ��ư���' onClick='history.back();'></center>
<hr size='1' width='550' color='#CCCCCC'></p>
<p align='center'><font size='2'>Copyright(c) 1997-2007 by INITECH</font><br></p>

</body>
</html>
