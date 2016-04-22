require 'colorize'

namespace :data_cleanse do
	# turn off console logging
	dev_null = Logger.new("/dev/null")
	Rails.logger = dev_null
	ActiveRecord::Base.logger = dev_null

	desc "Add Ticker Data to filers"
	task :ticker => :environment do |task, args|
		success = 0
		failure = 0
		fixed   = 0 
		Stock.all.each do |stock|
			filer = Filer.find_by(cik: stock.cik)
			if filer
				if !filer.symbol
					puts "Saving #{stock.ticker} to #{filer.name}".green
					filer.update(symbol: stock.ticker)
					fixed += 1
				else
					puts "#{filer.name} already has symbol #{filer.symbol}".yellow			
				end
			end
		end
	Filer.all.each do |filer|
		filer.symbol ? success += 1 : failure += 1
	end
		puts "#{fixed} symbols were fixed\n#{success} have symbols : #{failure} don't"
	end
end
