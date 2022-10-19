import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import sun.misc.*;

public class Time extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		String str = null;
		String time = null;

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		time = Long.toString(System.currentTimeMillis() / 1000);
		try {
			str = new String(base64Encode(time.getBytes()));
		} catch (Exception e) {
			e.printStackTrace();
		}

		out.println(str);
	}

	public byte[] base64Encode(byte[] in) {
		byte[] bytes = null;
		try {
			ByteArrayInputStream bais = new ByteArrayInputStream(in);
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			BASE64Encoder b64ec = new BASE64Encoder();
			b64ec.encodeBuffer(bais, baos);
			bytes = baos.toByteArray();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bytes;
	}

}