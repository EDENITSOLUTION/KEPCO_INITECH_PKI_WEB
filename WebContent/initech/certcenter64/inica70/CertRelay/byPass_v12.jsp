<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@page import="com.initech.certrelay.transfer.CertificateRelayV12"%><%

	CertificateRelayV12 CertSync = new CertificateRelayV12(application, request, response);
		
	/** Server~Server ���� ��ȭȭ ���� �� "use_encrypt" parameter�� true�� ��� ��ȣȭ�� �Ѵ�. **/
	// request�� ��ȣȭ ������ ���� Ȯ�� �Ѵ�.
	CertSync.setEncryptRequest(request.getParameter(CertificateRelayV12.USE_ENCRYPT));
	
	// Action 
	CertSync.setParameter(CertificateRelayV12.ACTION, request.getParameter(CertificateRelayV12.ACTION));
	// �����ڵ�
	CertSync.setEmptyToNullParameter(CertificateRelayV12.AUTH_NUM, request.getParameter(CertificateRelayV12.AUTH_NUM));
	// ��ȣȭ�� ������
	CertSync.setEmptyToNullParameter(CertificateRelayV12.ENC_CERT, request.getParameter(CertificateRelayV12.ENC_CERT));
	// Cache�� ���¸� Ȯ���ϱ� ���� ��й�ȣ
	CertSync.setParameter(CertificateRelayV12.PWD, request.getParameter(CertificateRelayV12.PWD));
	// ���� ����
	CertSync.setParameter(CertificateRelayV12.STATUS, request.getParameter(CertificateRelayV12.STATUS));
	// �����ڵ� ������
	CertSync.setParameter(CertificateRelayV12.AUTH_SIZE, request.getParameter(CertificateRelayV12.AUTH_SIZE));
	
	CertSync.setParameter(CertificateRelayV12.OPEN_STORAGE, request.getParameter(CertificateRelayV12.OPEN_STORAGE));
	// ���� 
	CertSync.writeResponse( response.getWriter() );
%>
