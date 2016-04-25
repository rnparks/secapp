class Filer < ActiveRecord::Base
	self.primary_key = :cik
	has_one :stock, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :subs, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :nums, through: :subs, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :pres, through: :subs, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :xbrls, :foreign_key => 'cik', :primary_key => 'cik'
	has_many :sics, :foreign_key => 'sic', :primary_key => 'sic'
	validates_uniqueness_of [:cik]

	def self.get_ids_and_names
  	self.connection.select_all("select id, name, username from users")
	end

	def displayName
		if self.stock
			self.stock.name
		else 
			self.name
		end
	end

	 def self.to_csv
    attributes = %w{id email name}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
