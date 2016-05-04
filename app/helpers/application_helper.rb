module ApplicationHelper
	def get_subs_path(adsh)
		return url_for(controller: 'subs', action: 'show', anchor: adsh)
	end
	def get_filers_path(cik)
		return url_for(controller: 'filers', action: 'show', anchor: cik)
	end
	  def get_sec_data_path
    "http://www.sec.gov/Archives/edgar/data/"
  end
end
