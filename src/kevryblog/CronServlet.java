package kevryblog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.*;

import java.util.List;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@SuppressWarnings("serial")
public class CronServlet extends HttpServlet {
	static {
      ObjectifyService.register(Post.class);
      ObjectifyService.register(Subscriber.class);
   }
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
			Properties props = new Properties();
			Session session = Session.getDefaultInstance(props, null);
	
			//build the message here
			String msgBody = new String();
			List<Post> posts = ofy().load().type(Post.class).list();
			
			//code to get yesterday was found from stack overflow 
			//http://stackoverflow.com/questions/22458042/how-can-i-get-yesterdays-date-without-using-calendar-in-java-and-without-a-time
			Date yesterday = new Date(System.currentTimeMillis() - 1000L * 60L * 60L * 24L);
			for(Post post: posts){
				if(post.getDate().before(yesterday)){continue;}
				msgBody = msgBody.concat(post.getUser().getEmail() + " posted at : " + post.getDate().toString() + "\n");
				msgBody = msgBody.concat(post.getTitle() + "\n");
				msgBody = msgBody.concat(post.getContent() + "\n\n\n");
			}
			java.lang.System.out.println("heres the message\n" + msgBody);
			try {

				List<Subscriber> subs = ofy().load().type(Subscriber.class).list();
				for(Subscriber sub: subs){
					//send an email to the subscriber
					Message msg = new MimeMessage(session);
					msg.setFrom(new InternetAddress("admin@kevryblog.appspotmail.com", "kevryblog.appspotmail.com Admin"));
					msg.addRecipient(Message.RecipientType.TO,
					new InternetAddress(sub.getUser().getEmail(), sub.getUser().getNickname()));
					msg.setSubject("KevryBlog Daily Digest!");
					msg.setText(msgBody);
					Transport.send(msg);
				}
	
			} catch (AddressException e) {
			    // ...
			} catch (MessagingException e) {
			    // ...
			}
      
	}
}
