<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import='java.net.*, java.io.*' %>

<%

System.out.println("aaaaa");
     URL url;//URL 주소 객체
        URLConnection connection;//URL접속을 가지는 객체
        InputStream is;//URL접속에서 내용을 읽기위한 Stream
        InputStreamReader isr;
        BufferedReader br;

        try{
            //URL객체를 생성하고 해당 URL로 접속한다..
            url = new URL("http://10.180.6.97:8080/SSL/EMPLOYEE2/epi_relay.php?id=ex099129&pw=aa231a");
            connection = url.openConnection();
System.out.println("aaaaa123");

            //내용을 읽어오기위한 InputStream객체를 생성한다..
            is = connection.getInputStream();
            isr = new InputStreamReader(is);
            br = new BufferedReader(isr);

            //내용을 읽어서 화면에 출력한다..
            String buf = null;
            while(true){
                buf = br.readLine();
                if(buf == null) break;
                System.out.println(buf);
            }
        }catch(MalformedURLException mue){
            System.err.println("잘못되 URL입니다. 사용법 : java URLConn http://hostname/path]");
            System.exit(1);
        }catch(IOException ioe){
            System.err.println("IOException " + ioe);
            ioe.printStackTrace();
            System.exit(1);
        }

%>
<html>
<script language="javascript">
function test(){
 //frm.action = "http://10.180.6.97:8080/SSL/EMPLOYEE2/epi_relay.php";
 //frm.submit();
}
</script>
<body onload="test();">
<form name="frm" action="test.jsp" method="post> 
<input type="hidden" name="id" value="ex099129"/>
<input type="hidden" name="pw" value="2KIzmbe/lnjS+y2axAqT8A=="/>
</form>
</body>
</html>
