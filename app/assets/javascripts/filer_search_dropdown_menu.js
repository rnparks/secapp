$( document ).ready(function() {

	var subList = new Bloodhound({
		datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.searchName); },
		queryTokenizer: Bloodhound.tokenizers.whitespace,
		local: $('.subs').data('source')
	});
	subList.initialize();

	$('.typeahead').typeahead(
	{
		hint: false,
		highlight: true
	}, 
	{
		limit: 50,
		display: function(item){ return item.name.toTitleCase()},
		source: subList.ttAdapter(),
		templates: {
			empty: [
			'<div class="empty-message">',
			'unable to find any filers with that name',
			'</div>'
			].join('\n'),
			suggestion: function(item){
				if (item.symbol)
					return '<div><a href="' + subsUrl(item) + '">' + item.name.toTitleCase() + "<span style='color: #20783F'> [" + item.symbol +']</span></a></div>';
				else
					return '<div><a href="' + subsUrl(item) + '">' + item.name.toTitleCase() + '</a></div>';
				end

			}
		}
	});

	$('.typeahead').bind('typeahead:select', function(ev, suggestion) {
		window.open(subsUrl(suggestion),"_self")
});

	function subsUrl(item) {
		return '/filers/' + item.adsh 
	}

	String.prototype.toTitleCase = function() {
		return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
	}

});
