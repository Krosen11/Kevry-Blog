function modalPopup(event) {
	//This function will be called when the button to create a post is pressed
	$("#blogModal").modal({backdrop: 'static', keyboard: false}).one('click', "#submitPost", function() {
		//This function just needs to submit the form
		$("#form").submit();
	});
}

$("#makePost").click(modalPopup);