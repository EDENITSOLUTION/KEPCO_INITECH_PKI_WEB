<%-- CertVIDCheck.jsp --%>
<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*,java.util.*,java.lang.*, java.text.*" %>

<%@ page import="java.security.*,java.security.cert.*"%>
<%@ page import="com.initech.iniplugin.vid.*"%>
<%@ page import="com.initech.iniplugin.*" %>
<%@ include file ="../include/Init.jsp"%>

<html>
<head>
	<title>INISAFE Public PKI VID Result</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript" src="/initech/plugin/INIplugin.js"></script>
</head>

<body>

<% out = m_IP.startEncrypt(out); %>
<%

	X509Certificate cert = null;
	String juminNO = null;
	String vid = null;
	IDVerifier idv = null;

	//������ �ʿ��� ������ ���� üũ
	if (m_IP.isClientAuth() == false) {
      m_IniErrCode = "PPKI_000";
	    m_IniErrMsg  = "Exception : Cert is null"; 

	} else {
	    //����� �������� ����.
			cert = m_IP.getClientCertificate();

			juminNO = m_IP.getParameter("juminNO");
			try{
				vid = m_IP.getVIDRandom();

				idv = new IDVerifier();

				out.println("cert:"+cert+"<br><br>");
				out.println("juminNO:"+juminNO+"<br><br>");
				out.println("vid.getBytes():"+vid.getBytes()+"<br><br>");
				out.println("vid:"+vid+"<br><br>");
				out.println("idv:"+idv+"<br><br>");
				out.println("idv.getVID():"+idv.getVID()+"<br><br>");

				if ((idv.checkVID(cert, juminNO, vid.getBytes())) == true) {
					
					out.println(" <br><br><b>����Ȯ�ο� �����߽��ϴ�.!! </b><br>");
					out.println("===================================<Br>");
					out.println("VID Result	:[TRUE]<br>");
					out.println("===================================<br>");
					out.println("����� �ֹε�Ϲ�ȣ�� <b>[" + juminNO + "]</b> �Դϴ�.<Br>");
					out.println("RANDOM Number	: <b>[" + m_IP.getVIDRandom() + "]</b><br>");
					out.println("hashedData	: <b>[" + com.initech.util.Hex.dumpHex(idv.getVID()) + "]</b><br>");
					out.println("===================================<br>");

			   } else {
					
					out.println(" <Br><br><b>����Ȯ�ο� �����߽��ϴ�.!!  </b><br>");
					out.println(" <Br><br><b> �ֹε�Ϲ�ȣ�� Ȯ�����ּ���.!!  </b><br>");
					out.println("===================================<br>");
					out.println("VID Result	:[FALSE]<br>");
					out.println("===================================<br>");
					out.println("����� �ֹε�Ϲ�ȣ�� <b>[" + juminNO + "]</b> �Դϴ�.<br>");
					out.println("RANDOM Number	: <b>[" + m_IP.getVIDRandom() + "]</b><br>");
					out.println("hashedData	: <b>[" + com.initech.util.Hex.dumpHex(idv.getVID()) + "]<b><br>");
					out.println("===================================<br>");

			   }
			}
			catch(Exception e){
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
