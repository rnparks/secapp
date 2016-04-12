require 'httparty'
class Financial < ActiveRecord::Base

	def getMorningStarData(symbol, reportType="is", period=3)
		# symbol: ticker
		# reportType: is = Income Statement, cf = Cash Flow, bs = Balance Sheet
		# period: 12 for annual reporting, 3 for quarterly reporting
	"http://financials.morningstar.com/ajax/ReportProcess4CSV.html?t=#{symbol}&reportType=#{reportType}&period=12&dataType=A&order=asc&columnYear=5&number=3"

end
