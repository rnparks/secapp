class Stock < ActiveRecord::Base
	has_one :sub, :class_name => 'Sub', :foreign_key => 'cik'
	validates_uniqueness_of :cik
	MARKETS = OpenStruct.new(
	us: OpenStruct.new(
		url: "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=amex&render=download"))

	def getMorningStarData(reportType="is", period=3)
		# symbol: ticker
		# reportType: is = Income Statement, cf = Cash Flow, bs = Balance Sheet
		# period: 12 for annual reporting, 3 for quarterly reporting
		url = "http://financials.morningstar.com/ajax/ReportProcess4CSV.html?t=#{self.ticker}&reportType=#{reportType}&period=#{period}&dataType=A&order=asc&columnYear=5&number=3"
		response = HTTParty.get(url)
		parsedResponse = response.split("\n").map do |row|
			CSV::parse_line(row)
		end
		hash = {}
		key = nil
		parsedResponse.each_with_index do |row, index|
			if index == 0
				key = parsedResponse.first.first.gsub("???", "")
				hash[key] = []
			else
				hash[key].push(row)
			end
		end
		reportTypeName = { "is" => "Income Statement", "cf" => "Cash Flow", "bs" => "Balance Sheet" }
		periodName = { "3" => "Qtly", "12" => "Yrly" }
		displayName = "#{periodName[period.to_s]} #{reportTypeName[reportType]}"
		finalHash = {"displayName" => displayName, "reportType" => reportType, "period" => period, "data" => hash}
	end
	
	def getYahooFinanceData
		yahoo_client = YahooFinance::Client.new
		data = {
			labels: [
				{ close: "Prev Close:"},
				{ open: "Open:"},
				{ bid: "Bid:"},
				{ ask: "Ask:"},
				{ one_year_target_price: "1y Target Est:"},
				{ a: "Beta:"},
				{ b: "Next Earnings Date:"},
				{ c: "Day's Range:"},
				{ d: "52wk Range:"},
				{ e: "Volume:"},
				{ f: "Avg Vol (3m)"},
				{ g: "Market Cap:"},
				{ h: "P/E (ttm)"},
				{ i: "EPS (ttm)"},
				{ j: "Div & Yield:"}
			],
		data: yahoo_client.quotes([self.ticker], [:after_hours_change_real_time,
			:annualized_gain,
			:ask,
			:ask_real_time,
			:ask_size,:average_daily_volume,
			:bid,
			:bid_real_time,
			:bid_size,
			:book_value,
			:change,
			:change_and_percent_change,
			:change_from_200_day_moving_average,
			:change_from_50_day_moving_average,
			:change_from_52_week_high,
			:change_From_52_week_low,
			:change_in_percent,
			:change_percent_realtime,
			:change_real_time,
			:close,
			:comission,
			:day_value_change,
			:day_value_change_realtime,
			:days_range,
			:days_range_realtime,
			:dividend_pay_date,
			:dividend_per_share,
			:dividend_yield,
			:earnings_per_share,
			:ebitda,
			:eps_estimate_current_year,
			:eps_estimate_next_quarter,
			:eps_estimate_next_year,
			:error_indicator,
			:ex_dividend_date,
			:float_shares,
			:high,
			:high_52_weeks,
			:high_limit,
			:holdings_gain,
			:holdings_gain_percent,
			:holdings_gain_percent_realtime,
			:holdings_gain_realtime,
			:holdings_value,
			:holdings_value_realtime,
			:last_trade_date,
			:last_trade_price,
			:last_trade_realtime_withtime,
			:last_trade_size,
			:last_trade_time,
			:last_trade_with_time,
			:low,
			:low_52_weeks,
			:low_limit,
			:market_cap_realtime,
			:market_capitalization,
			:more_info,
			:moving_average_200_day,
			:moving_average_50_day,
			:name,
			:notes,
			:one_year_target_price,
			:open,
			:order_book,
			:pe_ratio,
			:pe_ratio_realtime,
			:peg_ratio,
			:percent_change_from_200_day_moving_average,
			:percent_change_from_50_day_moving_average,
			:percent_change_from_52_week_high,
			:percent_change_from_52_week_low,
			:previous_close,
			:price_eps_estimate_current_year,
			:price_eps_Estimate_next_year,
			:price_paid,
			:price_per_book,
			:price_per_sales,
			:shares_owned,
			:short_ratio,
			:stock_exchange,
			:symbol,
			:ticker_trend,
			:trade_date,
			:trade_links,
			:volume,
			:weeks_range_52]).first.to_h
		}
	end
end
