class Stock < ActiveRecord::Base
	has_one :subs
	validates_uniqueness_of :name
	MARKETS = OpenStruct.new(
	us: OpenStruct.new(
		url: "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=amex&render=download"))
	def self.seedStockData
		keys = []
		symbols = []
		firstrow = true
		return symbols unless MARKETS['us']
		CSV.foreach(open(MARKETS['us'].url)) do |row|
			if firstrow
				row.each do |s|
					keys.push(s.gsub(" ", "").downcase) if s
				end
				firstrow = false
				next
			end
			params = {}
			row.each_with_index do |val, index|
				params[keys[index]] = val if val
			end
			params["name"].gsub!(".", "")
			params["name"].gsub!(",", "")
			Stock.create(params)
		end
	end
end
