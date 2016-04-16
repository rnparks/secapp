require 'colorize'

namespace :data_cleanse do
	# turn off console logging
	dev_null = Logger.new("/dev/null")
	Rails.logger = dev_null
	ActiveRecord::Base.logger = dev_null

	desc "Add Ticker Data to subs"
	task :ticker => :environment do |task, args|
		success = 0
		failure = 0
		fixed   = 0 
		Stock.all.each do |stock|
			sub = Sub.find_by(cik: stock.cik)
			if sub
				if !sub.symbol
					puts "Saving #{stock.ticker} to #{sub.name}".green
					sub.update(symbol: stock.ticker)
					fixed += 1
				else
					puts "#{sub.name} already has symbol #{sub.symbol}".yellow			
				end
			end
		end
	Sub.all.each do |sub|
		sub.symbol ? success += 1 : failure += 1
	end
		puts "#{fixed} symbols were fixed\n#{success} have symbols : #{failure} don't"
	end
end
