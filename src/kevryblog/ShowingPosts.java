package kevryblog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

public class ShowingPosts extends HttpServlet {
	static {
      ObjectifyService.register(Post.class);
  }
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
         throws IOException {
		String parameter = req.getParameter("list-all");
		if (parameter.equals("Yes")) {
			resp.sendRedirect("/kevry.jsp?list-all=Yes");
		}
		else {
			resp.sendRedirect("/kevry.jsp");
		}
	}
}
