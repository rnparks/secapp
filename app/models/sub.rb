class Sub < ActiveRecord::Base
	self.primary_key = :adsh
	has_many :nums, :class_name => 'Num', :foreign_key => 'adsh', :primary_key => 'adsh'
	has_one :stock, :class_name => 'Stock', :foreign_key => 'cik', :primary_key => 'cik'
	has_many :xbrls, :class_name => 'Xbrl', :foreign_key => 'cik', :primary_key => 'cik'
	has_many :sics, :class_name => 'Sic', :foreign_key => 'sic', :primary_key => 'sic'
	has_many :pres, :foreign_key => 'adsh', :primary_key => 'adsh'
	validates_uniqueness_of [:adsh]

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
end
