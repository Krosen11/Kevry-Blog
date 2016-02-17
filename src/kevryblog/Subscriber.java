package kevryblog;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Subscriber {
	@Id Long id;
	//Additional parameters for each post should be variables here
	User user;
	String email;
	String content;
	
	private Subscriber() {}
	
   public Subscriber(User user) {
       this.user = user;
       this.email = user.getEmail();
   }
   
   public Long getId() {
   	return id;
   }
   public User getUser() {
       return user;
   }
   public String getEmail() {
   	return email;
   }

}