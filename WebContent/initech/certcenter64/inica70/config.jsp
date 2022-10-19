<%@ page import="com.initech.iniplugin.*" %>
<% 
		IniPlugin m_IP = null;
		String pluginConfig  = null;
		String signConfig  = null;
		String oidConfig  = null;
		String crlConfig  = null;
		String certConfig  = null;
		String certverifierConfig = null;
		String netConfig = null;
		String inimasConfig = null;
		
		pluginConfig  = "/home/initech/iniplugin/properties/IniPlugin.inica70.properties";
				
		signConfig  = "/home/unixdev/initech/iniplugin/properties/INISAFESign.properties";
		oidConfig = "/home/unixdev/initech/iniplugin/properties/jCERTOID.properties";
		crlConfig = "/home/unixdev/initech/iniplugin/properties/CRL.properties";
		certConfig = "/home/unixdev/initech/iniplugin/properties/certcenter.properties";
		certverifierConfig = "/home/unixdev/initech/iniplugin/properties/certverifier.properties";
		netConfig = "/home/unixdev/initech/iniplugin/properties/INISAFENet.properties";
		inimasConfig = "/home/unixdev/initech/iniplugin/properties/IniMas.properties";
	
		String iniData = request.getParameter("INIpluginData");
		
		if(iniData != null && !iniData.equals("")){
			
		m_IP = new IniPlugin(request,response,pluginConfig);
		
		try {
			m_IP.init(false);
		} catch(Exception e) {
			e.printStackTrace();
		} 
	}	
		
%>
