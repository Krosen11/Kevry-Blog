package kevryblog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

import kevryblog.Post;
import kevryblog.Subscriber;

public class SubscribeServlet extends HttpServlet{
	static {
      ObjectifyService.register(Post.class);
      ObjectifyService.register(Subscriber.class);
      } 
   public void doPost(HttpServletRequest req, HttpServletResponse resp)
         throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		List<Subscriber> subs = ofy().load().type(Subscriber.class).list();
		boolean subscribed = false;
		Subscriber oldSub = null;
		for(Subscriber sub: subs){
			if(sub.getUser().getEmail().equals(user.getEmail())){
				subscribed = true;
				oldSub = sub;
				break;
			}
		}
		
		if(subscribed){
			//delete the user
			ofy().delete().entity(oldSub).now();
		}
		else{
			Subscriber newSub = new Subscriber(user);
			ofy().save().entity(newSub).now();
		}
		resp.sendRedirect("/kevry.jsp");
		
   }
}
