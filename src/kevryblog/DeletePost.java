package kevryblog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

public class DeletePost extends HttpServlet {
	static {
      ObjectifyService.register(Post.class);
  }
   public void doPost(HttpServletRequest req, HttpServletResponse resp)
               throws IOException {
   	Long idText = Long.valueOf(req.getParameter("delete-id")).longValue();
   	Post post = ofy().load().type(Post.class).id(idText).get();
   	ofy().delete().entity(post).now();
   	resp.sendRedirect("/kevry.jsp");
   }
}
