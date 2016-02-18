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

function subscribeForm(item) {
		$(item).wrap("<form class='sub-form' action='/subscribe' method='post'>");
		$(item).closest("form").submit();
}

$("#makePost").click(modalPopup);
$("#managePosts").click(managePosts);