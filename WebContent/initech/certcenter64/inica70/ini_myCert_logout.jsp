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
session.removeAttribute("myLogin");
response.sendRedirect("ini_myCert_list.jsp");

%>