require 'pry'
require 'csv'
require 'colorize'
require 'open-uri'

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
				addCount   = 0
				failCount  = {}
				model_name = file.split('/').last.split('.').first.camelize.singularize
				firstline  = true
				keys       = {}
				linecount  = 1.0
				totalLines = File.open(file) { |f| f.count }
				puts "Importing #{file} (#{totalLines} total rows)".green
				begin
					# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render
					CSV.foreach(file, {:quote_char => "~", col_sep: "\t", encoding: "ISO8859-1"}) do |row|
						print "\r\tProgress: %#{(linecount/totalLines*100).round(1)} | Added: #{addCount} | Rejected: #{failCount}".green
						if firstline
							# changed updated to changedd inorder to avoid ActiveRecord conflict
							row.each { |val| val.gsub!("changed", "changedd") }
							keys = row if row.first
						end
						params = {}
						keys.each_with_index do |key, i|
							if !firstline
								row[i].gsub!(/"/,'/"') if row[i]
								params[key] = row[i]
							else
								break
							end
						end
						begin
							if !firstline
								eval(model_name).create(params)
								addCount += 1
							end
						rescue ActiveRecord::ActiveRecordError => e
							summary = e.message[/#{'PG::'}(.*?)#{': ERROR'}/m, 1]
							if failCount[summary]
								failCount[summary] += 1
							else 
								failCount[summary] = 1
							end
						end
						firstline = false
						linecount += 1
					end
					puts ""
				rescue ActiveRecord::RecordNotUnique
					puts "#{e.message} : #{model_name}"
				end
			else
				puts "Skipping #{file} (**will only import sub.txt, num.txt, pre.txt and tag.txt**)".red
			end
		end
	end
	
	task :ticker_import => :environment do |task|
		desc "Import ticker data into database record via '|' delimited csv from rankandfiled.com"
		addCount   = 0
		failCount  = {}
		firstline  = true
		keys       = {}
		linecount  = 1.0
		totalLines = open("http://rankandfiled.com/static/export/cik_ticker.csv") { |f| f.count }
		puts "Importing #{file} (#{totalLines} total rows)".green
		begin
			# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render
			CSV.foreach(open("http://rankandfiled.com/static/export/cik_ticker.csv"), {:quote_char => "~", col_sep: "|", encoding: "ISO8859-1"}) do |row|
				print "\r\tProgress: %#{(linecount/totalLines*100).round(1)} | Added: #{addCount} | Rejected: #{failCount}".green
				if firstline
					keys = row if row.first
				end
				params = {}
				keys.each_with_index do |key, i|
					if !firstline && row[i]
						row[i].gsub!(/"/,'/"')
						if keys[i].downcase == "cik"
							params[key.downcase] = row[i].to_i
						else
							params[key.downcase] = row[i]
						end
					else
						break
					end
				end
				begin
					if !firstline
						Stock.create(params)
						addCount += 1
					end
				rescue ActiveRecord::ActiveRecordError => e
					summary = e.message[/#{'PG::'}(.*?)#{': ERROR'}/m, 1]
					if failCount[summary]
						failCount[summary] += 1
					else 
						failCount[summary] = 1
					end
				end
				firstline = false
				linecount += 1
			end
			puts ""
		rescue Exception => e
			puts e.message
		end
	end
	task :sic_import => :environment do |task|
		desc "Import sic / naics data into database record via '|' delimited csv from rankandfiled.com"
		addCount   = 0
		failCount  = {}
		firstline  = true
		keys       = {}
		linecount  = 1.0
		totalLines = open("http://rankandfiled.com/static/export/sic_naics.csv") { |f| f.count }
		puts "Importing #{file} (#{totalLines} total rows)".green
		begin
			# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render
			CSV.foreach(open("http://rankandfiled.com/static/export/sic_naics.csv"), {:quote_char => '"', col_sep: "|", encoding: "ISO8859-1"}) do |row|
				print "\r\tProgress: %#{(linecount/totalLines*100).round(1)} | Added: #{addCount} | Rejected: #{failCount}".green
				if firstline
					keys = row if row.first
				end
				params = {}
				keys.each_with_index do |key, i|
					if !firstline && row[i]
						params[key.downcase.gsub(' ','')] = row[i]
					else
						break
					end
				end
				begin
					if !firstline
						Sic.create(params)
						addCount += 1
					end
				rescue ActiveRecord::ActiveRecordError => e
					summary = e.message[/#{'PG::'}(.*?)#{': ERROR'}/m, 1]
					if failCount[summary]
						failCount[summary] += 1
					else 
						failCount[summary] = 1
					end
				end
				firstline = false
				linecount += 1
			end
			puts ""
		rescue Exception => e
			puts e.message
		end
	end
end
