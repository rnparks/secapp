var ready;
ready = function() {
	// initiate table popovers
	$('[data-toggle="popover"]').popover();
	// turn table rows into links
	$("tr[data-link]").click(function() {
		window.location = $(this).data("link")
	})
};
$(document).ready(ready);
$(document).on('page:load', ready);
