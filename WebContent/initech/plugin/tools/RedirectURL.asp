<%
	'RedirectURL = Trim(Request.ServerVariables("QUERY_STRING"))
	RedirectURL = Request("RedirectURL")
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language=javascript src="/initech/plugin/INIplugin.js"></script>
	<script>
	function encrypt_submit() 
	{
		var url = '<%=RedirectURL%>';
		alert(url);
		//alert(EncLocation(url));
		//location = EncLocation(url);
		location.replace(EncLocation(url));
	}
	</script>
</head>
<body onload="encrypt_submit();">
</body>

