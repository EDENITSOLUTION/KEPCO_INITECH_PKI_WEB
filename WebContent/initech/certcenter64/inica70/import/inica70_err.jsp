<%@ page contentType="text/html;charset=EUC-KR" %>
<%-- 
	//************************************************
        //      �����ڵ带 ���� �޽����� ��ȯ
	//	input : m_How => output : m_Title
	//	input : m_Code => output : m_ErrMsg
        //************************************************
--%>

<%
if (m_How.equals("certNew"))
	m_Title = "ID(" + m_ID + ")�� ������ ��û���� ������ ���� ������ �߻��Ͽ����ϴ�.";
else if (m_How.equals("certRevoke"))
	m_Title = "ID(" + m_ID + ")�� ������ ��ҵ��� ������ ���� ������ �߻��Ͽ����ϴ�.";
else if (m_How.equals("certReplace"))
	m_Title = "ID(" + m_ID + ")�� ������ ���浵�� ������ ���� ������ �߻��Ͽ����ϴ�.";
else if (m_How.equals("certRenewal"))
	m_Title = "ID(" + m_ID + ")�� ������ ���ŵ��� ������ ���� ������ �߻��Ͽ����ϴ�.";
else if (m_How.equals("logon"))
	m_Title = "�α׿� ���� ������ ���� ������ �߻��Ͽ����ϴ�.";
else 		
	m_Title = "������ ���� ������ �߻��Ͽ����ϴ�.";

if (m_Code.equals("iniPlugin_101"))
	m_ErrMsg = "��ȣȭ ��� ��ġ�� Ȯ�ο�.(INIpluginDATA is null)";
else if (m_Code.equals("iniPlugin_102"))
		m_ErrMsg = "��ȣȭ ��� ��ġ�� Ȯ�ο�.(��ȣȭ ����)";
else if (m_Code.equals("iniPlugin_103"))
		m_ErrMsg = "��ȣȭ ��� ��ġ�� Ȯ�ο�.(��ȣȭ ����)";

else if (m_Code.equals("iniLDAP_001"))
	m_ErrMsg = "ã�����ϴ� Attribute�� �������� �ʽ��ϴ�.";
else if (m_Code.equals("iniLDAP_002"))
	m_ErrMsg = "�߱� ���� �������� �����ϴ�.";
else if (m_Code.equals("iniLDAP_003"))
	m_ErrMsg = "�̹� �߱޹��� ������ �Դϴ�.";

else if (m_Code.equals("iniLDAP_101"))
	m_ErrMsg = "LDAP �˼� ���� �����Դϴ�.";
else if (m_Code.equals("iniLDAP_102"))
	m_ErrMsg = "LDAP ���� ���ῡ �����Ͽ����ϴ�.";
else if (m_Code.equals("iniLDAP_103"))
	m_ErrMsg = "LDAP ���� ���ῡ �����Ͽ����ϴ�.";

else if (m_Code.equals("iniLDAP_201"))
	m_ErrMsg = "��ҵ� ������ �Դϴ�.";
else if (m_Code.equals("iniLDAP_301"))
	m_ErrMsg = "LDAP������ ID �߰��� �����Ͽ����ϴ�.";
else if (m_Code.equals("iniLDAP_401"))
	m_ErrMsg = "������ ��� ��й�ȣ�� Ʋ���ϴ�..";

else if (m_Code.equals("iniCA_000"))
	m_ErrMsg = "������ �Ľ� ����(�߸��� �Լ� ȣ��)";
else if (m_Code.equals("iniCA_101") || m_Code.equals("iniCA_201")
	|| m_Code.equals("iniCA_301") || m_Code.equals("iniCA_401")
	|| m_Code.equals("iniCA_501") )
	m_ErrMsg = "inimessage is null";
else if (m_Code.equals("iniCA_102") || m_Code.equals("iniCA_202")
	|| m_Code.equals("iniCA_302") || m_Code.equals("iniCA_402")
	|| m_Code.equals("iniCA_502") )
	m_ErrMsg = "�������� ���ῡ �����Ͽ����ϴ�.";
else 
	if (m_ErrMsg == null) m_ErrMsg = "����� �ٽý�û�Ͽ� �ֽʽÿ�";
%>