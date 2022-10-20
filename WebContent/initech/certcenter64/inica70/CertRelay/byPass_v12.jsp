<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@page import="com.initech.certrelay.transfer.CertificateRelayV12"%><%

	CertificateRelayV12 CertSync = new CertificateRelayV12(application, request, response);
		
	/** Server~Server 구간 암화화 적용 시 "use_encrypt" parameter가 true인 경우 복호화를 한다. **/
	// request가 암호화 데이터 인지 확인 한다.
	CertSync.setEncryptRequest(request.getParameter(CertificateRelayV12.USE_ENCRYPT));
	
	// Action 
	CertSync.setParameter(CertificateRelayV12.ACTION, request.getParameter(CertificateRelayV12.ACTION));
	// 인증코드
	CertSync.setEmptyToNullParameter(CertificateRelayV12.AUTH_NUM, request.getParameter(CertificateRelayV12.AUTH_NUM));
	// 암호화된 인증서
	CertSync.setEmptyToNullParameter(CertificateRelayV12.ENC_CERT, request.getParameter(CertificateRelayV12.ENC_CERT));
	// Cache된 상태를 확인하기 위한 비밀번호
	CertSync.setParameter(CertificateRelayV12.PWD, request.getParameter(CertificateRelayV12.PWD));
	// 진행 상태
	CertSync.setParameter(CertificateRelayV12.STATUS, request.getParameter(CertificateRelayV12.STATUS));
	// 인증코드 사이즈
	CertSync.setParameter(CertificateRelayV12.AUTH_SIZE, request.getParameter(CertificateRelayV12.AUTH_SIZE));
	
	CertSync.setParameter(CertificateRelayV12.OPEN_STORAGE, request.getParameter(CertificateRelayV12.OPEN_STORAGE));
	// 응답 
	CertSync.writeResponse( response.getWriter() );
%>
