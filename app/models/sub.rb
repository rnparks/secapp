require 'Sec'

class Sub < ActiveRecord::Base

	self.primary_key = :adsh
	has_one :stock, :foreign_key => 'cik', :primary_key => 'cik'
	has_one :filer, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :nums, :foreign_key => 'adsh', :primary_key => 'adsh'
	has_many :xbrls, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :sics, :foreign_key => 'sic', :primary_key => 'sic'
	has_many :pres, :foreign_key => 'adsh', :primary_key => 'adsh'
	validates_uniqueness_of [:adsh]

	def get_sub_data_path
		"#{Sec.get_data_path}#{self.cik}/#{self.adsh.gsub('-','')}/"
	end
	def get_excel_path
		"#{self.get_sub_data_path}Financial_Report.xlsx"
	end
	def get_instance_path
		"#{self.get_sub_data_path}#{self.instance}"
	end
	def get_sec_instance
  	Net::HTTP.get(URI.parse(self.get_instance_path))
	end
end
