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

	# def vet_subs(file, conn)
	# 	file = File.open(file, 'r')
	# 	while !file.eof?
	# 		line = file.readline
	# 		cik  = line.split("\t")[1]
	# 		adsh = line.split("\t")[0]
	# 		rc   = conn.raw_connection
	# 		if rc.exec("select exists (select true from subss where adsh='#{adsh})';").first == "f"
	# 			self.create_filer(line)
	# 		end
	# 	end
	# end

	def self.create_filer(file, conn)
		puts "Creating Filers off of subs data"
		addCount    = 0
		keeperAttrs = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,26]
		failCount   = {}
		model_name  = file.split('/').last.split('.').first.camelize.singularize
		firstline   = true
		keys        = {}
		linecount   = 1.0
		index       = 0
		headers     = File.open(file,"r") { |fh_in| fh_in.readline }.gsub("\n", "").gsub("changed", "changedd").gsub("version", "v").gsub("ddate", "dd").gsub("coreg", "cr").split("\t")
		totalLines  = File.read(file).each_line.count
		file = File.open(file, 'r')
		while !file.eof?
			line = file.readline
			params = {}
			print "\r\tProgress: %#{(linecount/totalLines*100).round(1)} | Added: #{addCount} | Rejected: #{failCount}".green
			attrs = line.split("\t")
			keeperAttrs.each {|i| params[headers[i].to_sym] = attrs[i]}
			if !firstline
				begin
						Filer.create(params)
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
		conn = ActiveRecord::Base.connection
		conn.execute('SET client_encoding=latin1;')
		self.create_filer(file, conn) if model_name == "Sub"
		rc = conn.raw_connection
		rc.exec("COPY #{model_name.downcase}s (#{headers}) FROM STDIN WITH CSV HEADER DELIMITER '\t' QUOTE '~'")
		file = File.open(file, 'r')
		while !file.eof?
		print "\r\tProgress: %#{(linecount/totalLines*100).round(1)} | Added: #{addCount} | Rejected: #{failCount}".green
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
		rc.put_copy_end
		while res = rc.get_result
			if e_message = res.error_message
				p e_message if e_message != ""
			end
		end
		puts ""
	end
end
