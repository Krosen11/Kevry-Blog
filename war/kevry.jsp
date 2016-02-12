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
  <img id="banner" src="/stylesheets/kevry-name.png">
  <div class="page-div">
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
	<p>Welcome back <span id="username">${fn:escapeXml(user.nickname)}</span>! (You can sign out
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">here</a>.)</p>
	<%
	    } else {
	%>
	<p>Hello!
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	 to make posts!</p>
	<hr>
	<%
	    }
	%>
  	<%
  		if (user != null) {
  	%>
  	<div class="btn-div">
  	<button id="makePost" type="button" value="Post">Make Post</button>
  	<button id="managePosts" type="button" value="Manage">Manage Posts</button>
  	</div>
  	<%
  		}
  	%>
  	<p id="instructions">Welcome to Kevry Blog! Click on posts to read them!</p>
  	<%
 	 ObjectifyService.register(Post.class);
 	 List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();   
	 Collections.sort(posts); 
    if (posts.isEmpty()) {
        %>
        <p>There are currently no posts in Kevry Blog. Please stay tuned!</p>
        <%
    } else {
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
            }
            %>
            <div class="post-div">
            <h1 class="title" onclick="openBlogPost(this)">Title: ${fn:escapeXml(post_title)}</h1>
            <p id="post-author" class="post-info">${fn:escapeXml(post_user)}</h6>
            <p id="post-date" class="post-info">${fn:escapeXml(post_date)}</h6>
            <p id="post-content" class="post-info">${fn:escapeXml(post_content)}</p>
            </div>
            <%
            }
        }
	%>
	</div>
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
	    					if (user != null && user.equals(post.getUser())) {
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
    <div id="postModal" class="modal fade" role="dialog">
	    	<div class="modal-dialog">
	    		<div class="modal-content">
	    			<div class="modal-header">
	    				<h1 id="post-modal-title">WHA?</h1>
	    			</div>
	    			<div class="modal-body">
	    				<span id="post-modal-author">Test</span>
	    				<span id="post-modal-date">Testing</span>
	    				<p class="content" id="post-modal-content">Hi?</p>
	    			</div>
	    			<div class="modal-footer">
	    				<button type="button" data-dismiss="modal" class="btn" id="close">Close Post</button>
	    			</div>
	    		</div>
	    	</div>
	    </div>
    <script src="scripts/blog.js"></script>
  </body>
</html>