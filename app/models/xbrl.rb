class Xbrl < ActiveRecord::Base
	has_one :sub, :class_name => 'Sub', :foreign_key => 'cik'
	validates :cik, uniqueness: {scope: [:formtype, :datefiled, :filename] }
end
