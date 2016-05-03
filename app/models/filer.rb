class Filer < ActiveRecord::Base
	self.primary_key = :cik
	has_one :stock, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :subs, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :nums, through: :subs, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :pres, through: :subs, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :xbrls, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :sics, :foreign_key => 'sic', :primary_key => 'sic'
	validates_uniqueness_of [:cik]

	def self.get_ids_and_names
  	self.connection.select_all("select id, name, username from users")
	end

	def get_excel
		cik = "#{self.cik}"
		ticker = self.symbol
		mechanize = Mechanize::new
		surface_page = mechanize.get("http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{cik}&type=#{type}&dateb=&owner=exclude&count=100")
		counter = 1
		surface_page.links.each do |link|
			if link.to_s.include? "Interactive"
				level1 = link.click
				level1.link_with(text: "View Excel Document").click.save "#{ticker}_#{type}_#{self.period.strftime('%d%b%Y')}_#{counter}.xlsx" if level1.link_with(text: "View Excel Document") != nil
				counter += 1
			end
		end
	end

	def displayName
		if self.stock
			self.stock.name
		else 
			self.name
		end
	end

	def get_periods
		collection = self.subs.map {|a| a.period}.sort.uniq.reject {|x| x.year < 2014}.map{|date| date.strftime("%m/%y")}
	end

	def to_csv
    attributes = %w{id email name}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
