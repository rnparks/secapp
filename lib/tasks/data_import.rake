require 'csv'
require 'colorize'
require 'open-uri'
require 'net/ftp'
require 'zip'
require 'task_helpers/application_helper'


namespace :data_import do
	# turn off console logging
	dev_null = Logger.new("/dev/null")
	Rails.logger = dev_null
	ActiveRecord::Base.logger = dev_null

	desc "Import sec archive data to database. Pass any arguments (sub, num, tag, pre) to only import that resource *no whitespace between arguments*. If no variable is chosen, then all will import. Ex: rake data_import:archive[num,tag]"
	task :archive => :environment do |task, args|
		# set resources to import in acceptedFiles array
		args.extras.map { |arg| arg+=".txt" }
		acceptedFiles = args.extras.count > 0 ? args.extras.map{|arg|arg+=".txt"} : ['num.txt', 'sub.txt', "pre.txt", "tag.txt"]
		secUrl   			= "www.sec.gov"
		zipFiles 			= ["2015q4.zip"]
		response 			= nil
		temp_dir			= "temp_archive/"
		puts "Flushing all existing temp files"
		
		Dir["#{temp_dir}*"].each{|f| FileUtils.rm(f) unless f == "#{temp_dir}.gitignore"}
		zipFiles.each do |zipFile|
			begin
				tries ||= 3
				Net::HTTP.start(secUrl) do |http|
					response = http.get("/data/financial-statements/#{zipFile}")
					open("temp_archive/#{zipFile}", "wb") { |file| file.write(response.body) }
				end
			rescue ActiveRecord::ActiveRecordError => e
				puts e
				if tries.zero?
					puts "You'll have to try again later"
				else
					puts "Trying again..."
					tries -= 1
					retry
				end
			end
			puts "Opening #{zipFile} from #{secUrl}"
			Zip::File.open("#{temp_dir}#{zipFile}") do |zip_file| 
				# Handle entries one by one
				zip_file.each do |entry|
					if acceptedFiles.any? { |word| entry.name.include?(word) }
						fileInfo = entry
						puts "Temporarily saving #{entry.name} locally"
						begin
							entry.extract("#{temp_dir}#{entry.name}")
						rescue
							puts "#{entry.name} already exists! Deleting existing file".red
							File.delete("#{temp_dir}#{entry.name}")
							entry.extract("#{temp_dir}#{entry.name}")
						end
							puts "Successfully saved #{entry.name}".green
					else
						puts "Skipping #{file} (**currently configured to import [#{acceptedFiles.join(', ')}]**)".red
					end
				end
			end
			files = Dir.glob("#{temp_dir}*.txt")
			puts "Found #{files.count()} .txt files"
			files.each do |file| 
				ApplicationHelper.chunker(file)
				File.delete(file)
			end
			files = Dir.glob("#{temp_dir}*.txt")
			files.each_with_index do |file, index|
				addCount   = 0
				failCount  = {}
				model_name = file.split('/').last.split('.').first.camelize.singularize
				firstline  = true
				keys       = {}
				linecount  = 1.0
				totalLines = File.read(file).each_line.count
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
				rescue ActiveRecord::RecordNotUnique
					puts "#{e.message} : #{model_name}"
				end
				puts ""
			end
		end
		puts "Flush all temporary data files"
		Dir.foreach(temp_dir) {|f| fn = File.join(temp_dir, f); File.delete(fn) if f != '.' && f != '..'}
	end

	desc "Import ticker data into database record via '|' delimited csv from rankandfiled.com"
	task :ticker => :environment do |task|
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
		rescue Exception => e
			puts e.message
		end
		puts ""
	end

	desc "Import sic / naics data into database record via '|' delimited csv from rankandfiled.com"
	task :sic => :environment do |task|
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
		rescue Exception => e
			puts e.message
		end
		puts ""
	end

	desc "Import xbrl indexing (currently for testing as it only brings in 2015/QTR4"
	task :xbrl => :environment do |task|
		url = "ftp.sec.gov"
		qtrs = ['2015/QTR4', '2015/QTR3', '2015/QTR2', '2015/QTR1', '2014/QTR4', '2014/QTR3', '2014/QTR2', '2014/QTR1']
		qtrs.each do |qtr|
			content = nil
			fileInfo = nil
			puts "Connecting to #{url}"
			begin
				tries ||= 3
				Net::FTP.open(url) do |ftp|
					ftp.passive = true
					begin
						tries_b ||= 3
						puts ftp.login("anonymous") ? "Successfully logged in".green : "Loggin unsuccessful".red
					rescue ActiveRecord::ActiveRecordError => e
						puts e
						if tries_b.zero?
							puts "You'll have to try again later"
						else
							puts "Trying again..."
							tries_b -= 1
							retry
						end
					end
					puts "Pulling #{qtr} data"
					ftp.chdir("/edgar/full-index/#{qtr}")
					ftp.getbinaryfile("xbrl.zip")
					Zip::File.open('xbrl.zip') do |zip_file|
						# Handle entries one by one
						zip_file.each do |entry|
			  			fileInfo = entry
							puts "Temporarily saving #{entry.name} locally"
							begin
								entry.extract(entry.name)
							rescue
								puts "#{entry.name} already exists! Deleting existing file".red
								File.delete(entry.name)
								entry.extract(entry.name)
							end
							puts "Successfully saved #{entry.name}".green
						end
					end
				end
			rescue ActiveRecord::ActiveRecordError => e
				puts e
				if tries.zero?
					puts "You'll have to try again later"
				else
					puts "Trying again..."
					tries -= 1
					retry
				end
			end
			addCount   = 0
			failCount  = {}
			firstline  = true
			keys       = {}
			linecount  = 1.0
			totalLines = open(fileInfo.name) { |f| f.count }
			puts "Importing #{fileInfo.name} (#{totalLines} total rows)"
			begin
				# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render
				CSV.foreach(fileInfo.name, {:quote_char => '"', col_sep: "|", encoding: "ISO8859-1"}) do |row|
					print "\r\tProgress: %#{(linecount/totalLines*100).round(1)} | Added: #{addCount} | Rejected: #{failCount}".green
					if row.count > 1
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
								Xbrl.create(params)
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
					end
					linecount += 1
				end
			rescue Exception => e
				puts e.message
			end
			puts ""
			puts "Flushing local copy of #{fileInfo.name}"
			File.delete(fileInfo.name)
		end
	end
	desc "Perform all data import tasks"
	task :all => :environment do |task, args|
		puts "Resetting databases"
		Rake::Task["db:drop"].execute
		Rake::Task["db:create"].execute
		Rake::Task["db:migrate"].execute
		puts "Importing sec archive data from files located in https://www.sec.gov/dera/data/financial-statement-data-sets.html"
		Rake::Task["data_import:archive"].execute
		puts "Importing ticker data from rankandfiled.com's database"
		Rake::Task["data_import:ticker"].execute
		puts "Importing sic (business taxonomy) data from rankandfiled.com's database"
		Rake::Task["data_import:sic"].execute
		puts "Importing xbrl indexing data from the sec's ftp site"
		Rake::Task["data_import:xbrl"].execute
		Rake::Task["data_cleanse:ticker"].execute
	end
end
