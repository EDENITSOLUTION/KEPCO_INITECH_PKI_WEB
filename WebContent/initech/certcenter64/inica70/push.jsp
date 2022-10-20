<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="com.daou.smartpush.service.message2.Message" %>
<%@ page import="com.daou.smartpush.service.result.Result" %>
<%@ page import="com.daou.smartpush.service.send.Sender" %>
<%@ page import="com.daou.smartpush.util.contents.ConfirmUse" %>
<%@ page import="com.daou.smartpush.util.contents.Contents" %>

<%
	//String HOST = "https://203.248.44.215:35000/server";	// ���� : Ǫ�� ���� Host �� - ���߼��� http://211.223.60.10:35000/server	
	String HOST = "http://203.248.44.215:35001/server";
	String APP_KEY 	= "dR/hxv3BZg22gCVzl6YDFwkPhWY=";	// ���� : �߼� �� Key
	String USER_ID 	= "kepco123";						// ���� : ���� ID
	String USER_PW 	= "powernet!@";						// ���� : ���� PWD
	String LOG_PATH 	= "/home/kdnadmin/initech";						// �Է� : log���� ���
	String CALL_PHONE 	= "0613458000";					// �Է� : �߽��� ��ȭ��ȣ 
	String LEGACY_CODE = "IDNTN";							// �Է� : �����ڵ�
	String SEND_MESSAGE = "���ͳݸ� Ǫ�� �߼�  �޼���2";				// �Է� : �߼� �޽���
	
	String PUSH_KEY1 	= "PUSH1100000012";					// �׽�Ʈ �ڵ� : ����Ű #1
	String PUSH_PHONE1	= "01088686268";					// �׽�Ʈ �ڵ� : ������ ��ȭ��ȣ #1


		//-----------------------------------------
		//Smartpush �������� ��û�� �ϱ����� Sender ��ü ����
		//��� : �� 4����
		//      1. Auth Key ��û
		//      2. Braodcast �߼ۿ�û
		//      3. Named �߼� ��û
		//      4. ���� �߼� ��û
		//      5. Solution�� Named �߼� ��û
		
		//�߼� ��ü ����
		//Sender ��ü ������ �ʿ� �Ű�����
		//ù��° : Smartpush ���� Host ��
		//�ι�° : Log File ���� �� Path(�ش� Path�� ���� �Ͽ��� �Ѵ�.)
		Sender sender = new Sender(HOST, LOG_PATH);

		//------------------------------------------
		// 1. AuthKey ��û
		
		// 1-1. ��û �޼��� ����
		// Message             : ��� ��û �޼����� ���� �ϱ����� ��ü
		// newAuthKeyMessage() : Auth Key ��û �޼��� ���� �޼���
		// .userId()           : Auth Key ��û�� �ޱ� ���� ��� ���� ID
		// .pwd()              : Auth Key ��û�� �ޱ� ���� ��� ���� Password
		String authRequestMsg = Message.newAuthKeyMessage()
				.userId(USER_ID)
				.pwd(USER_PW).build();
		
		// 1-2. ���� ��û �� ��� �ޱ�
		// ��û�� Sender �� sendAuthKey�޼��带 �̿��Ͽ� ȣ��
		// Result ��ü�� ������� ���õǾ� ��ȯ�ȴ�.
		// .sendAuthKey() : ������ Sender ��ü ���� �޼���. Auth Key ��û�� ����ϴ� �޼���
		Result authResult = sender.sendAuthKey(authRequestMsg);
		
		//��� ��ü �� ���� �޼���
		//Result : �߼� ����� �����ϰ� �ִ� ��ü
		//.getResultCode()   : ��û ��� Code ��ȯ �޼���
		//.getResultMsg()    : ��û ��� Message ��ȯ �޼��� 
		//.getAuthKey()      : AuthKey ��û ������ �߱� �� Auth Key ��ȯ �޼���
		//.getMsgTag()       : �߼� ��û ������ �߱޵� Message Tag ��ȯ �޼���
		//.getInvalidId      : Named �߼� ��û�� ��û�� ID�� ���� ID ��� ��ȯ �޼���
		out.println("ResultCode : " + authResult.getResultCode()
				+ "\n Result Message : " + authResult.getResultMsg()
				+ "\n AuthKey : " + authResult.getAuthKey());
		
		// 5. Named Package Push
		
		// 5-1. named �غ� ����
		
		// 5-2. ��û �޼��� ����
		// Message               : ��� ��û �޼����� ���� �ϱ����� ��ü
		//.newNamdMessage() : Named �߼� ��û �޼��� ���� �޼���
		//.authKey()             : ���� ���� Auth Key ���� �޼���. Auth Key ��û�� ���� Result�� .getAuthKey()�� �̿��ϸ� �ȴ�.
		//.appkey()              : �߼��� ���� ����� ������ Appkey ���� �޼���
		//.message()             : �߼��Ϸ��� ���� ���� �޼���
		//.pushType()            : �߼��Ϸ��� �߼ۻ� Ÿ�� ���� �޼���. Contents ��ü�� ���� key ����(all / apns / gcm / hydro)
		//                       : all   - Contents.PAYLOAD_PUSHTYPE_ALL
		//      				 : apns  - Contents.PAYLOAD_PUSHTYPE_APNS
		//      				 : gcm   - Contents.PAYLOAD_PUSHTYPE_GCM
		//      				 : hydro - Contents.PAYLOAD_PUSHTYPE_HYDRO
		//.sendType()            : �߼� ���� ���� �޼���. Contents ��ü�� ���� key ���� (normal : �Ϲ� Ǫ�� / rich : Rich Ǫ��)
		//      				 : normal - Contents.PAYLOAD_SENDTYPE_NORMAL
		//      				 : rich   - Contents.PAYLOAD_SENDTYPE_RICH
		//.receiveType()         : named ��� Ÿ�� ���� �޼���. Contents ��ü�� ���� key ���� (id : Ư�� ID / maddress : ����̽� Mac-Address)
		//                       : id        - Contents.PAYLOAD_RECEIVETYPE_ID
		//                       : maddress  - Contents.PAYLOAD_RECEIVETYPE_MADDRESS
		//.targetList()			 : �߼��Ϸ��� ID ���� �޼���. ArrayList (id �Ǵ� Mac-Address , PhoneNum)���� �����ش�.
		//.cutOption()           : �޼����� ���� ���� �̻��ΰ�� Smartpush���� ���� ���� ���� ���� �޼���. Contents ��ü�� ���� Key ����(y : ���� ��� / n : ���� �����)
		//      				 : y      - Contents.PAYLOAD_CUTOPTION_YES
		//      				 : n      - Contents.PAYLOAD_CUTOPTION_NO
		//.confirmUse(�ʼ��� �ƴ�)	 : Android �ܸ��� �߼� �� ����Ȯ�� üũ Rseponse�� ���� ���� �ܸ��⿡ ���Ͽ� SMS ��ȸ �߼� ����
		//					     : y      - ��� ���
		//						 : n      - ��� ��� ����
		//.confirmTimeout(�ʼ��� �ƴ�): confirm��� ���� �߼� �޼����� ���Ͽ� SMS ��ȸ �߼� ���� Timeout �ð� , �Է��� �ð� �̳��� ����Ȯ�� üũ�� ���� ������ SMS ��ȸ �߼�( ���� : ��)
		//.option()              : �߰� ���� �ɼǰ� ���� �޼���. �ش簪���� Client Device���� Ư�� ������ �����Ҽ� �ִ� ��.(key,value)�� ����

		/* ----------------------------------------------------- */
		// �׽�Ʈ �ڵ� : ������ �Է� -- ������ ����ũ loop �����Ͽ� �Է��ʿ�
		ArrayList targetList = new ArrayList();
		HashMap named = new HashMap();
        named.put(PUSH_KEY1, PUSH_PHONE1);
        targetList.add(named);
        /* ----------------------------------------------------- */
		
		String namedPackageRequestMsg = null;

		try {
			namedPackageRequestMsg = Message.newNamedPackageMessage()
					.authKey(authResult.getAuthKey())
					.appkey(APP_KEY)
					.message(SEND_MESSAGE)
					.pushType(Contents.PAYLOAD_PUSHTYPE_ALL)
					.sendType(Contents.PAYLOAD_SENDTYPE_NORMAL)
					.receiveType(Contents.PAYLOAD_RECEIVETYPE_ID)
					.sendPhone(CALL_PHONE)
//					.targetList(PUSH_KEY1, PUSH_PHONE1) //.targetList("Target ID","Send Phone Number")
					.targetList(targetList)
					.cutOption(Contents.PAYLOAD_CUTOPTION_YES)
					.confirmUse(ConfirmUse.Y)
					.confirmTimeout(30)
					.option("code", LEGACY_CODE).build();
			
		} catch (Exception e) {
			out.println("Named Package Message Setting Error");
		}
		
		// 5-3. �߼� ��û �� ��� �ޱ�
		//.sendNamed() : ������ Sender ��ü ���� �޼���. Named �߼� ��û�� ����ϴ� �޼���
		Result namedResult = sender.sendNamedPackage(namedPackageRequestMsg);
		
		//��� ��ü �� ���� �޼���
		//Result : �߼� ����� �����ϰ� �ִ� ��ü
		//.getResultCode()   : ��û ��� Code ��ȯ �޼���
		//.getResultMsg()    : ��û ��� Message ��ȯ �޼��� 
		//.getAuthKey()      : AuthKey ��û ������ �߱� �� Auth Key ��ȯ �޼���
		//.getMsgTag()       : �߼� ��û ������ �߱޵� Message Tag ��ȯ �޼���
		//.getInvalidId      : Named �߼� ��û�� ��û�� ID�� ���� ID ��� ��ȯ �޼���
		out.println("ResultCode : " + namedResult.getResultCode()
				+ "\n msgTag : " + namedResult.getMsgTag()
				+ "\n Result Message : " + namedResult.getResultMsg()
				+ "\n Invalid ID : " + namedResult.getInvalidId());

%>
