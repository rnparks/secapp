class Sub < ActiveRecord::Base
	self.primary_key = :adsh
	has_many :nums, :class_name => 'Num', :foreign_key => 'adsh'
	has_one :stock, :class_name => 'Stock', :foreign_key => 'cik', :primary_key => 'cik'
	has_many :xbrls, :class_name => 'Xbrl', :foreign_key => 'cik', :primary_key => 'cik'
	has_many :sics, :class_name => 'Sic', :foreign_key => 'sic', :primary_key => 'sic'
	validates_uniqueness_of [:adsh, :cik]

	def getStock
		Stock.where("cik = #{self.cik}")
	end

	def displayName
		if self.stock
			self.stock.name
		else 
			self.name
		end
	end
	def self.get_ids_and_names
  	self.connection.select_all("select id, name, username from users")
	end

end
