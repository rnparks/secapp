class Xbrl < ActiveRecord::Base
	has_one :sub, :class_name => 'Sub', :foreign_key => 'cik'
end
