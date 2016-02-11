<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kevryblog.Post" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
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
  	<p>Testing</p>
  	<%
  		if (user != null) {
  	%>
  	<button id="makePost" type="button" value="Post">Make Post</button>
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
        		pageContext.setAttribute("post_title",
                                     post.getTitle());
            pageContext.setAttribute("post_content",
                                     post.getContent());
            if (post.getUser() == null) {
                %>
                <p>An anonymous person wrote:</p>
                <%
            } else {
                pageContext.setAttribute("post_user",
                                         post.getUser());
                %>
                <p><b>${fn:escapeXml(post_user.nickname)}</b> wrote:</p>
                <%
            }
            %>
            <blockquote>Title: ${fn:escapeXml(post_title)}</blockquote>
            <blockquote>Content: ${fn:escapeXml(post_content)}</blockquote>
            <%
        }
    }
	%>
  	<p>Testing2</p>
  	<!-- 
  	<form action="/post" method="post">
  		<div><p>Title</p><textarea name="title" rows="1" cols="60"></textarea></div>
      <div><p>Content</p><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Make Blog Post" /></div>
      <input type="hidden" name="guestbookName" value="default"/>
    </form>
     -->
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
    <script src="scripts/blog.js"></script>
  </body>
</html>