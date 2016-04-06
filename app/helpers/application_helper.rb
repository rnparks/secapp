module ApplicationHelper
	def get_subs_path(adsh)
		return url_for(controller: 'subs', action: 'show', anchor: adsh)
	end
end
