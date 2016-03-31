# namespace :data_import do
#   desc "import sub.txt file"
#   task :import_subs, [:filename] => :environment do    
#     CSV.foreach('myfile.csv', :headers => true) do |row|
#       Sub.create!(row.to_hash)
#     end

# end

require 'pry'
require 'csv'
namespace :data_import do
	desc "Import csv data into database record"
	task :csv_table_import, [:dir] => :environment do |task, args|
		files = Dir.glob("#{args[:dir]}*.txt")
		puts("Found #{files.count()} files")
		# iterate through files in chosen path
		files.each_with_index do |file, index|
			if file.include? "num.txt" or file.include? "sub.txt"
				puts "Importing #{file}"
				model_name = file.split('/').last.split('.').first.camelize.singularize
				firstline = 0
				params_arr = []
				keys = {}
				begin
					# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render
					CSV.foreach(file, {:quote_char => "~", encoding: "ISO8859-1"}) do |row|
						if firstline == 0
							# changed updated to changedd inorder to avoid ActiveRecord conflict
							row.first.gsub!("changed", "changedd")
							keys = row.first.split(/\t/)
						end
						params = {}
						keys.each_with_index do |key, i|
							if firstline > 0 && row.first.split(/\t/)[i]
								params[key] = row.first.split(/\t/)[i].gsub(/"/,'/"')
							else
								break
							end
						end
						params_arr << params if firstline > 0
						firstline = 1
					end
					eval(model_name).create(params_arr)
				rescue Exception => e
					puts "#{e.message} : #{model_name}"
				end
			else
				puts "Skipping #{file} (**will only import sub.txt and num.txt**)"
			end
		end
	end
end
