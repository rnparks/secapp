class ApplicationHelper

	def self.chunker f_in, chunksize = 10_000_000
		outfilenum = 1
		File.open(f_in,"r") do |fh_in|
			headers = fh_in.readline
			until fh_in.eof?
			File.open("#{f_in}#{outfilenum}","w") do |fh_out|
				line = ""
				fh_out << headers
				while fh_out.size <= (chunksize-line.length) && !fh_in.eof?
					line = fh_in.readline
					fh_out << line
				end
				first_file = false
			end
			outfilenum += 1
			end
		end
	end

	def self.importToDatabase(file)
		addCount   = 0
		failCount  = {}
		model_name = file.split('/').last.split('.').first.camelize.singularize
		firstline  = true
		keys       = {}
		linecount  = 1.0
		index      = 0
		headers    = File.open(file,"r") { |fh_in| fh_in.readline }.gsub("\n", "").gsub("changed", "changedd").gsub("version", "v").gsub("ddate", "dd").gsub("coreg", "cr").split("\t").map {|header| header.to_sym}.join(", ")
		totalLines = File.read(file).each_line.count
		puts "Importing #{file} (#{totalLines} total rows)".green
		# quote characters are being replaced with an unlikely symbol ('~') that must be gsub'd back at render

		# Setup raw connection
		conn = ActiveRecord::Base.connection
		conn.execute('SET client_encoding=latin1;')
		rc = conn.raw_connection
		rc.exec("COPY #{model_name.downcase}s (#{headers}) FROM STDIN WITH CSV HEADER DELIMITER '\t' QUOTE '~'")

		file = File.open(file, 'r')
		while !file.eof?
		print "\r\tProgress: %#{(linecount/totalLines*100).round(1)} | Added: #{addCount} | Rejected: #{failCount}".green
			# Add row to copy data
			if !firstline
				begin
					rc.put_copy_data(file.readline)
					addCount += 1
				rescue ActiveRecord::ActiveRecordError => e
					summary = e.message[/#{'PG::'}(.*?)#{': ERROR'}/m, 1]
					if failCount[summary]
						failCount[summary] += 1
					else 
						failCount[summary] = 1
					end
				end
			else
				firstline = false
			end
			linecount += 1
		end
		# We are done adding copy data
		rc.put_copy_end
		# Display any error messages
		while res = rc.get_result
			if e_message = res.error_message
				p e_message if e_message != ""
			end
		end
		puts ""
	end
end
