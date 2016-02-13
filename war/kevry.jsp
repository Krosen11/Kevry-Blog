<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kevryblog.Post" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="org.w3c.dom.Document" %>
<%@ page import="org.w3c.dom.Element" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
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
  <div class="page-div">
  <div id="banner-div">
  <img id="banner" src="/stylesheets/kevry-name.png">
  <%
  	boolean listAllPosts = false;
  	if (request.getParameter("list-all") != null) listAllPosts = true;
  	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
	%>
	<p class="sign-in">Welcome <span id="username">${fn:escapeXml(user.nickname)}</span> | 
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Log Out</a></p>
	<%
	    } else {
	%>
	<p class="sign-in">Welcome Guest | 
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Log in</a></p>
	<%
	    }
	%>
	</div>
  	<%
  		if (user != null) {
  	%>
  	<div class="btn-div">
  	<button id="makePost" type="button" value="Post">Make Post</button>
  	<button id="managePosts" type="button" value="Manage">Manage Posts</button>
  	</div>
  	<%
  		}
 	 ObjectifyService.register(Post.class);
 	 List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();   
	 Collections.sort(posts); 
    if (posts.isEmpty()) {
        %>
        <p>There are currently no posts in Kevry Blog. Please stay tuned!</p>
        <%
    } else {
   	 int numPosts = 0;
        for (Post post : posts) {
      	  if (!listAllPosts && numPosts >= 5) break;
        		pageContext.setAttribute("post_title", post.getTitle());
            pageContext.setAttribute("post_content", post.getContent());
            pageContext.setAttribute("post_date", post.getDate());
            if (post.getUser() == null) {
            	//TODO: Remove this if-else, since all posts will be made by people logged in
            } else {
                pageContext.setAttribute("post_user",
                                         post.getUser());
            }
            %>
            <div class="post-div">
            <h3 class="title">${fn:escapeXml(post_title)}</h3>
            <div class="div-id">
            <span class="post-author">Posted by ${fn:escapeXml(post_user)} </span>
            <span class="post-date">on ${fn:escapeXml(post_date)}</span>
            </div>
            <p class="post-content">${fn:escapeXml(post_content)}</p>
            </div>
            <%
            numPosts++;
            }
        if (!listAllPosts && numPosts >= 5) {
      	  //More posts than we want on 1 page, so add a button to display all posts
      	  %>
      	  <form id="all-posts" action="/show" method="post">
      	  		<input type="hidden" name="list-all" value="Yes">
      	  		<button type="submit" class="btn" id="list-posts">List All Posts</button>
      	  </form>
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
	    				int numPosts = 0;
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
	    						numPosts++;
	    					}
	    				}
	    				if (numPosts == 0) {
	    					%>
	    					<p>You have not made any posts yet.</p>
	    					<%
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