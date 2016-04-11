class Sub < ActiveRecord::Base
	self.primary_key = 'adsh'
	has_many :nums
	has_one :stocks
	validates_uniqueness_of :adsh

		# yahoo_client = YahooFinance::Client.new
		# YahooStock::ScripSymbol.new(‘Yahoo’)
		# return yahoo_client.symbols_by_market('us', 'nyse')
	def getSymbol
		binding.pry
	end
end
