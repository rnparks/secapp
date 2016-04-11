class Sic < ActiveRecord::Base
	has_many :subs, :class_name => 'Sub', :foreign_key => 'sic', :primary_key => 'sic'
end
