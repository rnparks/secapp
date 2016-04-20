class Pre < ActiveRecord::Base
	validates :adsh, uniqueness: {scope: [:report, :line] }
	has_one :tag_num, :class_name => 'Num', :foreign_key => 'tag', :primary_key => 'tag'
	has_one :v_num, :class_name => 'Num', :foreign_key => 'v', :primary_key => 'v'
	has_one :adsh_num, :class_name => 'Num', :foreign_key => 'adsh', :primary_key => 'adsh'
end
