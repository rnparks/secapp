class Num < ActiveRecord::Base
	belongs_to :sub, :class_name => 'Sub', :foreign_key => 'adsh'
	has_one :tag_tag, :class_name => 'Tag', :foreign_key => 'tag', :primary_key => 'tag'
	has_one :version_tag, :class_name => 'Tag', :foreign_key => 'version', :primary_key => 'version'
	validates :adsh, uniqueness: {scope: [:tag, :version, :ddate, :qtrs, :uom, :coreg] }

	def value_in_shares?
		return self.uom.include? "shares"
	end
	def get_tag_data
		Tag.find_by_sql("Select * FROM tags WHERE tag = '#{self.tag}' AND version = '#{self.version}'").first
	end
end
