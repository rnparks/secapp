class Num < ActiveRecord::Base
	has_one :sub, :foreign_key => 'adsh', :primary_key => 'adsh'
	has_one :filer, through: :subs
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
	def get_pre(stmt, report)
		Pre.find_by_sql("Select * FROM pres WHERE tag = '#{self.tag}' AND v = '#{self.v}' AND adsh = '#{self.adsh}' AND report = #{report} AND stmt = '#{stmt}'").first	
	end
end

