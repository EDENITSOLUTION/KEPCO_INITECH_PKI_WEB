<%@ page language="java" %>
<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import='java.net.*, java.io.*' %>

<%

System.out.println("aaaaa");
     URL url;//URL �ּ� ��ü
        URLConnection connection;//URL������ ������ ��ü
        InputStream is;//URL���ӿ��� ������ �б����� Stream
        InputStreamReader isr;
        BufferedReader br;

        try{
            //URL��ü�� �����ϰ� �ش� URL�� �����Ѵ�..
            url = new URL("http://10.180.6.97:8080/SSL/EMPLOYEE2/epi_relay.php?id=ex099129&pw=aa231a");
            connection = url.openConnection();
System.out.println("aaaaa123");

            //������ �о�������� InputStream��ü�� �����Ѵ�..
            is = connection.getInputStream();
            isr = new InputStreamReader(is);
            br = new BufferedReader(isr);

            //������ �о ȭ�鿡 ����Ѵ�..
            String buf = null;
            while(true){
                buf = br.readLine();
                if(buf == null) break;
                System.out.println(buf);
            }
        }catch(MalformedURLException mue){
            System.err.println("�߸��� URL�Դϴ�. ���� : java URLConn http://hostname/path]");
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
