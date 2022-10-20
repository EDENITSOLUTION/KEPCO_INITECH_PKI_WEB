<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.String.*" %>

<%
//session.invalidate();
session.removeAttribute("adminLogin");
session.removeAttribute("admin2Login");
response.sendRedirect("ini_manage_cert_login.jsp");

%>