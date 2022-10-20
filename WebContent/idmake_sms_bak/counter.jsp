<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="com.caucho.util.*" %>
<%@ page session="true" %>
<% 
java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("[yyyy/MM/dd/ HH:mm:ss ]");
Integer count = null;

synchronized (session) {
  count = (Integer) session.getAttribute("basic.counter");
  if (count == null)
    count = new Integer(0);
  count = new Integer(count.intValue() + 1);
  session.setAttribute("basic.counter", count);
}
java.util.Date creationTime = new java.util.Date(session.getCreationTime());
java.util.Date lastAccessedTime = new java.util.Date(session.getLastAccessedTime());
java.util.Date currentTime = new java.util.Date(System.currentTimeMillis());
com.caucho.management.server.ServerMXBean _server = (com.caucho.management.server.ServerMXBean)com.caucho.jmx.Jmx.findGlobal("resin:type=Server");
String ResinServerId = _server.getId();

//System.out.println(session.getId());
//System.err.println(session.getId());
//Thread.sleep(10000);
%>

<html>
<head><title>Session Counter</title></head>
<body bgcolor="dbdbdb">

<h1>Counter Num : <%= count %></h1><br>
server.id           : <%= ResinServerId %><br>
Session isNew()     : <%= session.isNew() %><br>
Session ID          : <%= session.getId() %><br>
Session CreateTime  : <%= df.format(creationTime) %><br>
LastAccessTime      : <%= df.format(lastAccessedTime) %><br>
<br>
SessionExpireTime   : <%= session.getMaxInactiveInterval() %> sec.<br>
<a href='<%=response.encodeURL("counter.jsp")%>'>Retry</a>
</body>
</html>
