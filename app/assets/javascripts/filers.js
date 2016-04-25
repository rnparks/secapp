var ready;
ready = function() {
$("tr[data-link]").click(function() {
	window.location = $(this).data("link")
})
};
$(document).ready(ready);
$(document).on('page:load', ready);
