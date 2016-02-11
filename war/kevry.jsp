<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kevryblog.Post" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="org.w3c.dom.Document" %>
<%@ page import="org.w3c.dom.Element" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>
  <head>
  	<title>Kevry Blog</title>
   <!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
   
   <!-- jQuery -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
   
   <!-- JavaScript -->
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
 	
 	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>
 
  <body>
  <%
  String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
  	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
	%>
	<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
	<%
	    } else {
	%>
	<p>Hello!
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	to include your name with greetings you post.</p>
	<%
	    }
	%>
  	<%
  		if (user != null) {
  	%>
  	<div>
  	<button id="makePost" type="button" value="Post">Make Post</button>
  	<button id="managePosts" type="button" value="Manage">Manage Posts</button>
  	</div>
  	<%
  		}
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
 	 ObjectifyService.register(Post.class);
 	 List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();   
	 Collections.sort(posts); 
    if (posts.isEmpty()) {
        %>
        <p>Kevry Blog '${fn:escapeXml(guestbookName)}' has no blog posts.</p>
        <%
    } else {
        %>
        <p>Messages in Kevry Blog '${fn:escapeXml(guestbookName)}'.</p>
        <%
        for (Post post : posts) {
        		pageContext.setAttribute("post_title", post.getTitle());
            pageContext.setAttribute("post_content", post.getContent());
            pageContext.setAttribute("post_date", post.getDate());
            if (post.getUser() == null) {
            	//TODO: Remove this if-else, since all posts will be made by people logged in
                %>
                <p>An anonymous person wrote:</p>
                <%
            } else {
                pageContext.setAttribute("post_user",
                                         post.getUser());
                %>
                <!-- <p><b>${fn:escapeXml(post_user.nickname)}</b> wrote:</p> -->
                <%
            }
            %>
            <h1>Title: ${fn:escapeXml(post_title)}</h1>
            <h6>Author: ${fn:escapeXml(post_user)}</h6>
            <h6>Date Posted: ${fn:escapeXml(post_date)}</h6>
            <p class="content">${fn:escapeXml(post_content)}</p>
            <%
            }
        }
	%>
    <form id="form" action="/post" method="post">
	    <div id="blogModal" class="modal fade" role="dialog">
	    	<div class="modal-dialog">
	    		<div class="modal-content">
	    			<div class="modal-header">
	    				<h4 id="modalTitle">Title</h4>
	    				<textarea name="title" rows="1" cols="60"></textarea>
	    			</div>
	    			<div class="modal-body">
	    				<h4 id="modalText">Content</h4>
	    				<textarea name="content" rows="3" cols="60"></textarea>
	    			</div>
	    			<div class="modal-footer">
	    				<button type="button" data-dismiss="modal" class="btn btn-primary" id="submitPost">Submit Blog Post</button>
	    				<button type="button" data-dismiss="modal" class="btn" id="cancel">Cancel</button>
	    			</div>
	    		</div>
	    	</div>
	    </div>
    </form>
    <form id="manage" action="/manage" method="post">
	    <div id="manageModal" class="modal fade" role="dialog">
	    	<div class="modal-dialog">
	    		<div class="modal-content">
	    			<div class="modal-header">
	    				<h4 id="modalTitle">Blog Post Manager</h4>
	    			</div>
	    			<div class="modal-body">
	    			<%
	    				for (Post post : posts) {
	    					if (user.equals(post.getUser())) {
	    						pageContext.setAttribute("post_title", post.getTitle());
	    						pageContext.setAttribute("post_id", post.getId());
	    						%>
	    						<div>
	    						<h4 class="post-title">Post: ${fn:escapeXml(post_title)}</h4>
	    						<p class="post-id">Id: ${fn:escapeXml(post_id)}</p>
	    						<button type="button" class="btn delete" onclick="deletePost(this)">Delete</button>
	    						</div>
	    						<%
	    					}
	    				}
	    			%>
	    			</div>
	    			<div class="modal-footer">
	    				<button type="button" data-dismiss="modal" class="btn" id="cancel">Exit Post Manager</button>
	    			</div>
	    		</div>
	    	</div>
	    </div>
	    <input id="hidden-title" type="hidden" name="delete-title">
	    <input id="hidden-id" type="hidden" name="delete-id">
    </form>
    <script src="scripts/blog.js"></script>
  </body>
</html>