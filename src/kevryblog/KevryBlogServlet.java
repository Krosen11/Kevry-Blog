package kevryblog;

import java.io.IOException;

import javax.servlet.http.*;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class KevryBlogServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
		UserService userService = UserServiceFactory.getUserService();
      User user = userService.getCurrentUser();
      if (user != null) {
      	//This is when the user is logged in
         resp.setContentType("text/plain");
         resp.getWriter().println("SO MUCH DEBUG Hello, " + user.getNickname());
      } else {
      	//User is not logged in
         resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
      }
      
	}
}
