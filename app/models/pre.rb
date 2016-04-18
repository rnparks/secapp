class Pre < ActiveRecord::Base
	validates :adsh, uniqueness: {scope: [:report, :line] }
	has_one :tag_num, :class_name => 'Num', :foreign_key => 'tag', :primary_key => 'tag'
	has_one :version_num, :class_name => 'Num', :foreign_key => 'version', :primary_key => 'version'
	has_one :adsh_num, :class_name => 'Num', :foreign_key => 'adsh', :primary_key => 'adsh'
end
