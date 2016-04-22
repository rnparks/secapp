class Sub < ActiveRecord::Base
	self.primary_key = :adsh
	has_one :stock, :foreign_key => 'cik', :primary_key => 'cik'
	has_one :filer, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :nums, :foreign_key => 'adsh', :primary_key => 'adsh'
	has_many :xbrls, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :sics, :foreign_key => 'sic', :primary_key => 'sic'
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
