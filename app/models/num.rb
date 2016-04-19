class Num < ActiveRecord::Base
	belongs_to :sub, :class_name => 'Sub', :foreign_key => 'adsh', :primary_key => 'adsh'
	has_one :tag_tag, :class_name => 'Tag', :foreign_key => 'tag', :primary_key => 'tag'
	has_one :v_tag, :class_name => 'Tag', :foreign_key => 'v', :primary_key => 'v'
	validates :adsh, uniqueness: {scope: [:tag, :v, :dd, :qtrs, :uom, :cr] }

	def value_in_shares?
		return self.uom.include? "shares"
	end
	def get_tag_data
		Tag.find_by_sql("Select * FROM tags WHERE tag = '#{self.tag}' AND v = '#{self.v}'").first
	end
	def get_pres
		Pre.find_by_sql("Select * FROM pres WHERE tag = '#{self.tag}' AND v = '#{self.v}' AND adsh = '#{self.adsh}'")
	end
end
