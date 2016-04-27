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

	def displayName
		if self.stock
			self.stock.name
		else 
			self.name
		end
	end

	def get_periods
		sql = "SELECT n.dd, p.stmt FROM nums AS n JOIN subs AS s ON s.adsh = n.adsh JOIN pres AS p ON (n.tag = p.tag AND n.adsh = p.adsh AND n.v = p.v) WHERE s.cik='#{self.cik}' AND EXTRACT(YEAR FROM n.dd) > 2013 GROUP BY n.dd, p.stmt ORDER BY n.dd;"
		records_array = ActiveRecord::Base.connection.execute(sql)
		hash = {}
		records_array.each do |n| 
			hash[n["stmt"]] ? hash[n["stmt"]].push(n["dd"]) : hash[n["stmt"]]=[n["dd"]]
		end
		hash
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
