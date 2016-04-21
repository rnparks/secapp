class Filer < ActiveRecord::Base
		self.primary_key = :adsh
	has_many :subs, :class_name => 'Num', :foreign_key => 'cik', :primary_key => 'cik'
	has_one :stock, :class_name => 'Stock', :foreign_key => 'cik', :primary_key => 'cik'
	validates_uniqueness_of [:cik]

	def self.get_ids_and_names
  	self.connection.select_all("select id, name, username from users")
	end
end
