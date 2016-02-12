function modalPopup(event) {
	//This function will be called when the button to create a post is pressed
	$("#blogModal").modal({backdrop: 'static', keyboard: false}).one('click', "#submitPost", function() {
		//This function just needs to submit the form
		$("#form").submit();
	});
}

function managePosts(event) {
	$("#manageModal").modal({backdrop: 'static', keyboard: false});
}

function deletePost(item) {
	var current = $(item);
	var id = current.prev();
	var title = id.prev();
	title = title.text().substring(6);
	id = id.text().substring(4);
	$("#hidden-title").attr("value", title);
	$("#hidden-id").attr("value", id);
	$("#manage").submit();
}

function openBlogPost(item) {
	//Now we need to get all the post information and fill the modal before we show it
	var elem = $(item);
	$("#post-modal-title").text(elem.text().substring(6));
	elem = elem.next();
	$("#post-modal-author").text("Post by: " + elem.text() + ", ");
	elem = elem.next();
	$("#post-modal-date").text("Date: " + elem.text());
	elem = elem.next();
	$("#post-modal-content").text(elem.text());
	//Show the modal
	$("#postModal").modal({backdrop: 'static', keyboard: false});
}

$("#makePost").click(modalPopup);
$("#managePosts").click(managePosts);