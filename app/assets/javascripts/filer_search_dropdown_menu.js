$( document ).ready(function() {

	var subList = new Bloodhound({
		datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
		queryTokenizer: Bloodhound.tokenizers.whitespace,
		local: $('.subs').data('source')
	});
	subList.initialize();

	$('.typeahead').typeahead(null, 
	{
		displayKey: 'name',
		source: subList.ttAdapter(),
		templates: {
			empty: [
			'<div class="empty-message">',
			'unable to find any filers with that name',
			'</div>'
			].join('\n'),
			suggestion: function(item){
				return '<div><strong><a href="' + subsUrl(item) + '">'+item.name+'</a></strong></div>';
			}
		}
	});

	function subsUrl(item) {
		return '/subs/' + item.adsh 
	}
});