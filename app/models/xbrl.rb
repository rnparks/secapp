require 'net/ftp'
require 'nokogiri'
require 'open-uri'

class Xbrl < ActiveRecord::Base
	has_one :filer, :foreign_key => 'cik'
	validates :cik, uniqueness: {scope: [:formtype, :datefiled, :filename] }
	
	def getXbrlLink
		"ftp.sec.gov/#{self.filename}"
	end

	def getTables
		self.parse_xbrl_data.css('table')
	end
	def parse_xbrl_data
		return Nokogiri::HTML(self.getRawData)
	end
	
	def getRawData
		begin
			url      = "ftp.sec.gov"
			split    = self.filename.rpartition('/')
			filename = split.last
			path     = split.first
			tries ||= 3
			Net::FTP.open(url) do |ftp|
				ftp.passive = true
				ftp.login("anonymous")
				ftp.chdir(path)
				return ftp.gettextfile(filename, nil)
			end
		rescue ActiveRecord::ActiveRecordError => e
			if tries.zero?
				return "Error connecting. Details below: \n #{e}"
			else
				tries -= 1
				retry
			end
		end
	end
end
