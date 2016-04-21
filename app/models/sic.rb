class Sic < ActiveRecord::Base
	has_many :filers, :foreign_key => 'sic', :primary_key => 'sic'
	validates :sic, uniqueness: {scope: [:naics] }
end
