class Num < ActiveRecord::Base
	belongs_to :sub, :class_name => 'Sub', :foreign_key => 'adsh'
	validates :adsh, uniqueness: {scope: [:tag, :version, :ddate, :qtrs, :uom, :coreg] }
	def value_in_shares?
		return self.uom.include? "shares"
	end
end
