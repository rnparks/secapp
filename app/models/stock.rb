class Stock < ActiveRecord::Base
	has_one :sub, :class_name => 'Sub', :foreign_key => 'cik'
	validates_uniqueness_of :cik
	MARKETS = OpenStruct.new(
	us: OpenStruct.new(
		url: "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=amex&render=download"))
	def self.seedStockData
	end
end
