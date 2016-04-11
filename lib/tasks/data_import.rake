require 'pry'
require 'csv'
require 'colorize'

namespace :data_import do
	desc "Import csv data into database record"
	task :csv_table_import, [:dir] => :environment do |task, args|
		args[:dir].chomp!("/")
		acceptedFiles = ['sub.txt','num.txt','tag.txt', 'pre.txt']
		files = Dir.glob("#{args[:dir]}/*.txt")
		puts "Found #{files.count()} .txt files"
		# iterate through files in chosen path
		files.each_with_index do |file, index|
			if acceptedFiles.any? { |word| file.include?(word) }
				model_name = file.split('/').last.split('.').first.camelize.singularize
				firstline  = true
				keys       = {}
				linecount  = 1.0
				totalLines = File.open(file) { |f| f.count }
				puts "Importing #{file} (#{totalLines} total rows)".green
				begin
					# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render
					CSV.foreach(file, {:quote_char => "~", col_sep: "\t", encoding: "ISO8859-1"}) do |row|
						print "\r\tProgress: %#{(linecount/totalLines*100).round(1)}".green
						if firstline
							# changed updated to changedd inorder to avoid ActiveRecord conflict
							row.first.gsub!("changed", "changedd")
							keys = row if row.first
						end
						params = {}
						keys.each_with_index do |key, i|
							if !firstline && row[i]
								params[key] = row.gsub(/"/,'/"')
							else
								break
							end
						end
						eval(model_name).create(params) if !firstline
						firstline = false
						linecount += 1
					end
					puts ""
				rescue Exception => e
					puts "#{e.message} : #{model_name}"
				end
			else
				puts "Skipping #{file} (**will only import sub.txt, num.txt, pre.txt and tag.txt**)".red
			end
		end
	end
	task :ticker_import, [:dir] => :environment do |task, args|
		desc "Import ticker data into database record via '|' delimited csv"
		args[:dir].chomp!("/")
		acceptedFiles = ['cik_ticker.csv']
		files = Dir.glob("#{args[:dir]}/*.csv")
		puts "Found #{files.count()} .csv files"
		files.each_with_index do |file, index|
			if acceptedFiles.any? { |word| file.include?(word) }
				firstline  = true
				keys       = {}
				linecount  = 1.0
				totalLines = File.open(file) { |f| f.count }
				puts "Importing #{file} (#{totalLines} total rows)".green
				begin
					# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render
					CSV.foreach(file, {:quote_char => "~", col_sep: "|", encoding: "ISO8859-1"}) do |row|
						print "\r\tProgress: %#{(linecount/totalLines*100).round(1)}".green
						if firstline
							keys = row if row.first
						end
						params = {}
						keys.each_with_index do |key, i|
							if !firstline && row[i]
								params[key.downcase] = row[i].gsub(/"/,'/"')
							else
								break
							end
						end
						eval('Stock').create(params) if !firstline
						firstline = false
						linecount += 1
					end
					puts ""
				rescue Exception => e
					puts e.message
				end
			else
				puts "Skipping #{file} (**will only import cik_ticker.csv**)".red
			end
		end
	end
end
